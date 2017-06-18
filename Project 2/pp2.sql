drop function if exists juiceCupCost;
DELIMITER //
CREATE FUNCTION juiceCupCost (id INT)
RETURNS double

BEGIN
   declare total double;
   declare numRows, numDone double;
   declare ja, jb, jc double;
   declare _continue int default 0;   
   declare perml CURSOR FOR
      SELECT J.perMl, C.percentage, A.size from juice J, comprises C, juicecup A where C.cupId = id and J.jId = C.juiceId
	  and A.cupId = id;
   declare continue handler for not found set _continue = 1;   
   set total = 0; 
   set numDone = 0;  
   select count(*) into numRows from comprises where cupId = id;
   OPEN perml;    
     While numDone < numRows Do
     fetch perml into ja, jb, jc;	 
	 set jb = jb / 100;  
	 set jb = jb * jc;
	 set ja = ja * jb;
	 set total = total + ja;     
	 set numDone = numDone + 1;
 	 End While;	 
   CLOSE perml;  
   return total;
END //
DELIMITER ;


drop function if exists juiceOrderCost;
delimiter //
create function juiceOrderCost(id int)
returns double

begin 
   declare fcontinue int default 0;
   declare total, subtotal int;
   declare numDone, numRows, cup, q int;
   declare orderq cursor for
     select cupId, quantity from hasjuice where orderId = id;
   declare continue handler for not found set fcontinue = 1;
   set total = 0;
   set numDone = 0;
   select count(*) into numRows from hasjuice where orderId = id;
   open orderq;
     while numDone < numRows Do
	 fetch orderq into cup, q;
	 set subtotal = (juiceCupCost(cup) * q);
	 set total = total + subtotal;
	 set numDone = numDone + 1;
	 end while;
   close orderq;
	 return total;
end //
delimiter ;


drop function if exists totalOrderCost;
delimiter //
create function totalOrderCost(id int)
returns double

begin 
   declare pcontinue int default 0;
   declare numDone, numRows int;
   declare ttotal, total, q, pitem double;
   declare prodq cursor for
     select H.quantity, N.perItem from hasnonjuice H, nonjuice N where H.orderID = id
	 and H.prodId = N.prodId;
   declare continue handler for not found set pcontinue = 1;
   set total = 0;
   set numDone = 0;
   select count(*) into numRows from hasnonjuice where orderId = id;
   open prodq;
     while numDone < numRows Do
	 fetch prodq into q, pitem;
	 set pitem = pitem * q;
	 set total = total + pitem;
	 set numDone = numDone + 1;
	 end while;
   close prodq;
    set ttotal = total + juiceOrderCost(id);
	return ttotal;
end //
delimiter;

drop view if exists CustomerPriceOrder;
create view CustomerPriceOrder AS
select date, customerID as customerId, orderID as orderId , totalOrderCost(orderID) as orderCost 
from customerorder ;


drop procedure if exists customerOfMonth;
drop procedure listCofM;
delimiter ++
create procedure listCofM ()
begin  
   create table customerOfMonth as
   select year(C.date) as year, 
   monthname(C.date) as month,
   C.customerID as COfM,
   C1.email as cOfMemail
   from customerorder C, customer C1
   where C.customerID = (select C2.jCardNum
                         from customer C2 
						 order by jPoints desc limit 1)
						 and C.customerID = C1.jCardNum
						 group by month(C.date);
end++
delimiter ;


   


   
