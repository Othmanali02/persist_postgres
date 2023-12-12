-- Database Creation
--CREATE DATABASE IF NOT EXISTS brapi_core;
--USE brapi_core;

-- Table Creation Statements


-- Core Brapi Module
CREATE TABLE CommmonCropName (
    commonCropName varchar(50) UNIQUE,
);

CREATE TABLE Person (
    personDbId varchar(50) UNIQUE,
    additionalInfo json NULL,
    description varchar(50) NULL,
    emailAddress varchar(50) NULL,
    externalReferences json ARRAY,
    firstName varchar(50) NULL,
    lastName varchar(50) NULL,
    mailingAddress varchar(100) NULL,
    middleName varchar(50) NULL,
    phoneNumber varchar(50) NULL,
    userID varchar(50) NULL
);

CREATE TABLE Season (
    seasonDbId varchar(50) UNIQUE,
    seasonName varchar(50) NULL,
    year integer NULL
);

CREATE TABLE Location (
    locationDbId varchar(50) UNIQUE,
    locationName varchar(50) UNIQUE,
    abbreviation varchar(50) NULL,
    additionalInfo json NULL,
    coordinateDescription varchar(100) NULL,
    coordinateUncertainty varchar(50) NULL,
    coordinates json NULL,
    countryCode varchar(3) NULL,
    countryName varchar(50) NULL,
    documentationURL varchar(50) NULL,
    environmentType varchar(50) NULL,
    exposure varchar(50) NULL,
    externalReferences json ARRAY,
    instituteAddress varchar(50) NULL,
    instituteName varchar(50) NULL,
    locationType varchar(50) NULL,
    parentLocationDbId varcahr(50) NULL,
    parentLocationName varchar(50) NULL,
    siteStatus varchar(50) NULL,
    slope varchar(50) NULL,
    topography varchar(50) NULL
);

CREATE TABLE ListDetails (
    listDbId varchar(50) UNIQUE NOT NULL,
    listName varchar(50) NOT NULL,
    listType varchar(50) NOT NULL,
    additionalInfo json NULL,
    dateCreated varchar(50) NULL,
);

CREATE TABLE Program (

);

CREATE TABLE Trial (

);

CREATE TABLE Study (

);


