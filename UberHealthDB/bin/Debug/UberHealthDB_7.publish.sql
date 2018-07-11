﻿/*
Deployment script for UberHealthDB

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "UberHealthDB"
:setvar DefaultFilePrefix "UberHealthDB"
:setvar DefaultDataPath "c:\Program Files (x86)\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "c:\Program Files (x86)\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Starting rebuilding table [dbo].[answer]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_answer] (
    [Id]          INT           NOT NULL,
    [ReqId]       INT           NOT NULL,
    [description] VARCHAR (200) NOT NULL,
    [date]        VARCHAR (50)  NOT NULL
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[answer])
    BEGIN
        
        INSERT INTO [dbo].[tmp_ms_xx_answer] ([Id], [ReqId], [description], [date])
        SELECT [Id],
               [ReqId],
               [description],
               [date]
        FROM   [dbo].[answer];
        
    END

DROP TABLE [dbo].[answer];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_answer]', N'answer';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Update complete.'
GO
