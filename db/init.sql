-- Database Creation
-- CREATE DATABASE brapi_core;
-- USE brapi_core;

-- Table Creation Statements


-- Core Brapi Module
CREATE TYPE program_type AS ENUM ('STANDARD', 'PROJECT');

CREATE TABLE IsoCountryCodes (
    countryCode varchar(3) NOT NULL PRIMARY KEY,
    countryName varchar(50) NOT NULL
)

CREATE TABLE Institutes (
    instituteDbId varchar(50) NOT NULL PRIMARY KEY,
    instituteName varchar(50) NOT NULL,
    otherNames varchar(50)[] NULL,
    instituteURL text NULL,
    instituteType varchar(50) NULL,
    instituteROR varchar(50) NULL,
    externalReferences json[] NULL
)

CREATE TABLE CommmonCropName (
    cropDbID varchar(50) NOT NULL PRIMARY KEY
    commonCropName varchar(50) UNIQUE NOT NULL
);

CREATE TABLE Person (
    personDbId varchar(50) NOT NULL PRIMARY KEY,
    additionalInfo json NULL,
    description text NULL,
    emailAddress varchar(254) NULL,
    externalReferences json[] NULL,
    firstName varchar(50) NULL,
    lastName varchar(50) NULL,
    mailingAddress varchar(255) NULL,
    middleName varchar(50) NULL,
    phoneNumber varchar(50) NULL,
    userID varchar(50) NULL
);

CREATE TABLE Season (
    seasonDbId varchar(50) NOT NULL PRIMARY KEY,
    seasonName varchar(50) NOT NULL,
    year integer(4) NOT NULL
);

CREATE TABLE Location (
    locationDbId varchar(50) NOT NULL PRIMARY KEY,
    locationName varchar(50) UNIQUE NOT NULL,
    abbreviation varchar(50) NULL,
    additionalInfo json NULL,
    coordinateDescription text NULL,
    coordinateUncertainty varchar(255) NULL,
    coordinates json NULL,
    countryCode varchar(3) NOT NULL REFERENCES IsoCountryCodes (countryCode) ON DELETE CASCADE,
    countryName varchar(50) NULL,
    documentationURL text NULL,
    environmentType varchar(50) NULL,
    exposure varchar(50) NULL,
    externalReferences json[] NULL,
    instituteDbId varchar(50) NULL REFERENCES Institutes (instituteDbId) ON DELETE CASCADE, -- Added
    instituteAddress varchar(50) NULL, -- part of a view?
    instituteName varchar(50) NULL, -- part of a view?
    locationType varchar(50) NULL,
    FOREIGN KEY parentLocationDbId varchar(50) NULL REFERENCES Location (locationDbId) ON DELETE CASCADE, -- Need a join table to do this effectively
    parentLocationName varchar(50) NULL, -- part of a view?
    siteStatus varchar(50) NULL,
    slope varchar(50) NULL,
    topography varchar(50) NULL
);

CREATE TABLE ListDetails (
    listDbId varchar(50) NOT NULL PRIMARY KEY
    listName varchar(50) NOT NULL,
    listType varchar(50) NOT NULL,
    --data varchar(50)[] NOT NULL (References germplasm db ids, may need to make constraint in application not SQL. Probably need join table with list id and gerplams ids and create data list in application, return as array in api)
    additionalInfo json NULL,
    dateCreated timestamp NULL,
    dateModified timestamp NULL,
    externalReferences json[] NULL,
    listDescription text NULL,
    listOwnerPersonDbId varchar(50) NULL REFERENCES Person (personDbId),
    listOwnerName varchar(50) NULL, -- part of a view?
    listSize integer NULL, -- calculated field based on list size
    listSource varchar(50) NULL
);

CREATE TABLE Program (
    programDbId varchar(50) NOT NULL PRIMARY KEY
    programName varchar(50) UNIQUE NOT NULL,
    abbreviation varchar(50) NULL,
    additionalInfo json NULL,
    commonCropName varchar(50) NULL, -- Can one program have more than one common crop as a focus? For instance, should the TLI Perennial Legumes have two common crops, sainfoi
    documentationURL text NULL,
    externalReferences json[] NULL,
    fundingInformation varchar(255) NULL,
    leadPersonDbId varchar(50) NULL,
    leadPersonName varchar(50) NULL,
    objective varchar(50) NULL,
    programType program_type NULL
);


CREATE TABLE Trial ( -- equivalent to MIAPPE V1 Investigation
    trialDbId varchar(50) NOT NULL PRIMARY KEY,
    trialName varchar(50) UNIQUE NOT NULL,
    active boolean NULL,
    additionalInfo json NULL,
    commonCropName varchar(50) NULL,
    contacts json[] NULL,
    datasetAuthorship json[] NULL,
    documentationURL text NULL,
    endDate timestamp NULL,
    externalReferences json[] NULL,
    programDbId varchar(50) NULL,
    programName varchar(50) NULL,
    publications json[] NULL,
    startDate timestamp NULL,
    trialDescription text NULL,
    trialPUI varchar(255) NULL
);

CREATE TABLE Study ( -- equivalent to MIAPPE v1 Study
    studyDbId varchar(50) NOT NULL PRIMARY KEY,
    studyName varchar(50) UNIQUE NOT NULL,
    active boolean NULL, 
    additionalInfo json NULL,
    commonCropName varchar(50) NULL,
    contacts json[] NULL,
    culturalPractices varchar(50) NULL,
    dataLinks json[] NULL,
    documentationURL text NULL,
    endDate timestamp NULL,
    environmentParameters json[] NULL,
    experimentalDesign json NULL,
    externalReferences json[] NULL,
    growthFacility json NULL,
    lastUpdate json NULL,
    license varchar(50) NULL,
    locationDbId varchar(50) NULL,
    locationName varchar(50) NULL,
    observationLevels json[] NULL,
    observationUnitsDescription text NULL,
    observationVariableDbIds varchar(50)[] NULL,
    seasons varchar(50)[] NULL,
    startDate timestamp NULL,
    studyCode varchar(50) NULL,
    studyDescription text NULL,
    studyPUI varchar(50) NULL,
    studyType varchar(50) NULL,
    trialDbId varchar(50) NULL,
    trialName varchar(50) NULL
);


