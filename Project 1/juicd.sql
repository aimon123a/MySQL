DROP DATABASE IF EXISTS juicd;
CREATE DATABASE juicd;
USE juicd;

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
  jCardNum INT PRIMARY KEY,
  jPoints INT,
  email VARCHAR(128));
  
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
  jEmpId INT PRIMARY KEY,
  name VARCHAR(64),
  address TEXT);

DROP TABLE IF EXISTS Outlet;
CREATE TABLE Outlet (
  jStoreId INT PRIMARY KEY,
  address VARCHAR(64),
  phone CHAR(10));

DROP TABLE IF EXISTS worksAt;
CREATE TABLE worksAt(
  jStoreId INT,
  jEmpId INT,
  percentage INT,
  PRIMARY KEY (jStoreId, jEmpId),
  FOREIGN KEY (jStoreId) REFERENCES Outlet(jStoreId),
  FOREIGN KEY (jEmpId) REFERENCES Employee(jEmpId));

DROP TABLE IF EXISTS manages;
CREATE TABLE manages(
  jStoreId INT,
  jEmpId INT PRIMARY KEY,
  FOREIGN KEY (jStoreId) REFERENCES Outlet(jStoreId),
  FOREIGN KEY (jEmpId) REFERENCES Employee(jEmpId));

DROP TABLE IF EXISTS lineMgr;
CREATE TABLE lineMgr(
  supervisee  INT,
  supervisor  INT,
  FOREIGN KEY (supervisee) REFERENCES Employee(jEmpId),
  FOREIGN KEY (supervisor) REFERENCES manages(jEmpId));

DROP TABLE IF EXISTS NonJuice;
CREATE TABLE NonJuice(
  prodId INT PRIMARY KEY,
  pName VARCHAR(128),
  perItem DOUBLE);

DROP TABLE IF EXISTS Juice;
CREATE TABLE Juice(
  jId INT PRIMARY KEY,
  jName VARCHAR(128),
  perMl DOUBLE);

DROP TABLE IF EXISTS JuiceCup;
CREATE TABLE JuiceCup(
  cupId INT PRIMARY KEY,
  size INT);

DROP TABLE IF EXISTS comprises;
CREATE TABLE comprises(
  cupId INT,
  juiceId INT,
  percentage INT,
  PRIMARY KEY (cupId, juiceId),
  FOREIGN KEY (cupId) REFERENCES JuiceCup(cupId),
  FOREIGN KEY (juiceId) REFERENCES Juice(jId));

DROP TABLE IF EXISTS CustomerOrder;
CREATE TABLE CustomerOrder(
  orderID INT PRIMARY KEY,
  customerID INT,
  employeeID INT,
  outletID INT,
  date DATE,
  FOREIGN KEY (customerID) REFERENCES Customer(jCardNum),
  FOREIGN KEY (employeeID, outletID) REFERENCES worksAt(jEmpId, jStoreID));

DROP TABLE IF EXISTS hasNonJuice;
CREATE TABLE hasNonJuice(
  orderId INT,
  prodId INT,
  quantity INT,
  PRIMARY KEY (orderId, prodId),
  FOREIGN KEY (orderId) REFERENCES CustomerOrder(orderId),
  FOREIGN KEY (prodId) REFERENCES NonJuice(prodId));

DROP TABLE IF EXISTS hasJuice;
CREATE TABLE hasJuice(
  orderId INT,
  cupId INT,
  quantity INT,
  PRIMARY KEY (orderId, cupId),
  FOREIGN KEY (orderId) REFERENCES CustomerOrder(orderId),
  FOREIGN KEY (cupId) REFERENCES JuiceCup(cupId));
