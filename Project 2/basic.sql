use juicd;
select O.address, count(*), dayname(C.date) 
from customerorder C, outlet O 
where O.jStoreId = C.outletID group by O.address, dayname(C.date);

select cupId from comprises
group by cupId
having count(*) > 3;

select E.name, E.address from employee E 
where E.jEmpId not in ( select W.jEmpId from worksat W);

select C.orderId from customerorder C
where C.orderId not in ( select N.orderId from hasnonjuice N) order by C.orderID;

Drop function if exists juiceCupCost;
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