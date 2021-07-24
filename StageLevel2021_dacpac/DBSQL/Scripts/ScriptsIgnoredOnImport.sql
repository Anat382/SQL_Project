﻿
USE [master]
GO

/****** Object:  Database [StageLevel2021]    Script Date: 24.07.2021 10:04:15 ******/
CREATE DATABASE [StageLevel2021]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'StageLevel2021', FILENAME = N'E:\SQL_Developer\DataBase\StageLevel2021.mdf' , SIZE = 512000KB , MAXSIZE = UNLIMITED, FILEGROWTH = 102400KB )
 LOG ON 
( NAME = N'StageLevel2021_log', FILENAME = N'E:\SQL_Developer\DataBase\StageLevel2021_log.ldf' , SIZE = 512000KB , MAXSIZE = 1048576KB , FILEGROWTH = 102400KB )
GO

ALTER DATABASE [StageLevel2021] SET COMPATIBILITY_LEVEL = 140
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [StageLevel2021].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [StageLevel2021] SET ANSI_NULL_DEFAULT OFF
GO

ALTER DATABASE [StageLevel2021] SET ANSI_NULLS OFF
GO

ALTER DATABASE [StageLevel2021] SET ANSI_PADDING OFF
GO

ALTER DATABASE [StageLevel2021] SET ANSI_WARNINGS OFF
GO

ALTER DATABASE [StageLevel2021] SET ARITHABORT OFF
GO

ALTER DATABASE [StageLevel2021] SET AUTO_CLOSE OFF
GO

ALTER DATABASE [StageLevel2021] SET AUTO_SHRINK OFF
GO

ALTER DATABASE [StageLevel2021] SET AUTO_UPDATE_STATISTICS ON
GO

ALTER DATABASE [StageLevel2021] SET CURSOR_CLOSE_ON_COMMIT OFF
GO

ALTER DATABASE [StageLevel2021] SET CURSOR_DEFAULT  GLOBAL
GO

ALTER DATABASE [StageLevel2021] SET CONCAT_NULL_YIELDS_NULL OFF
GO

ALTER DATABASE [StageLevel2021] SET NUMERIC_ROUNDABORT OFF
GO

ALTER DATABASE [StageLevel2021] SET QUOTED_IDENTIFIER OFF
GO

ALTER DATABASE [StageLevel2021] SET RECURSIVE_TRIGGERS OFF
GO

ALTER DATABASE [StageLevel2021] SET  ENABLE_BROKER
GO

ALTER DATABASE [StageLevel2021] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO

ALTER DATABASE [StageLevel2021] SET DATE_CORRELATION_OPTIMIZATION OFF
GO

ALTER DATABASE [StageLevel2021] SET TRUSTWORTHY OFF
GO

ALTER DATABASE [StageLevel2021] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO

ALTER DATABASE [StageLevel2021] SET PARAMETERIZATION SIMPLE
GO

ALTER DATABASE [StageLevel2021] SET READ_COMMITTED_SNAPSHOT OFF
GO

ALTER DATABASE [StageLevel2021] SET HONOR_BROKER_PRIORITY OFF
GO

ALTER DATABASE [StageLevel2021] SET RECOVERY FULL
GO

ALTER DATABASE [StageLevel2021] SET  MULTI_USER
GO

ALTER DATABASE [StageLevel2021] SET PAGE_VERIFY CHECKSUM
GO

ALTER DATABASE [StageLevel2021] SET DB_CHAINING OFF
GO

ALTER DATABASE [StageLevel2021] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO

ALTER DATABASE [StageLevel2021] SET TARGET_RECOVERY_TIME = 60 SECONDS
GO

ALTER DATABASE [StageLevel2021] SET DELAYED_DURABILITY = DISABLED
GO

EXEC sys.sp_db_vardecimal_storage_format N'StageLevel2021', N'ON'
GO

ALTER DATABASE [StageLevel2021] SET QUERY_STORE = OFF
GO

USE [StageLevel2021]
GO

/****** Object:  Table [dbo].[Contact]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Deal]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[EMAIL]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Emploee]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Lead]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Region]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[Source]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[TypeProduct]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[WORK_POSITION]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Table [dbo].[СправочникTest]    Script Date: 24.07.2021 10:04:15 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

USE [master]
GO

ALTER DATABASE [StageLevel2021] SET  READ_WRITE
GO
