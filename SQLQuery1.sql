CREATE DATABASE ServiceRequestsDB
ON PRIMARY (
    NAME = ServiceRequestsDB_Data,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\ServiceRequestsDB.mdf'
)
LOG ON (
    NAME = ServiceRequestsDB_Log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\ServiceRequestsDB_log.ldf'
);

