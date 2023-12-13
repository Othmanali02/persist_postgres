-- Database Init Script
-- Table Creation Statements

-- Core Brapi Module
CREATE TYPE program_type AS ENUM ('STANDARD', 'PROJECT');

CREATE TABLE Country (
    countryCode varchar(3) NOT NULL PRIMARY KEY,
    countryName varchar(50) NOT NULL
);

CREATE TABLE Institute (
    instituteDbId varchar(50) NOT NULL PRIMARY KEY,
    instituteName varchar(50) NOT NULL,
    instituteAddress varchar(50) NULL, -- This is a composite, break into smaller fields
    instituteURL text NULL,
    instituteType varchar(50) NULL,
    instituteROR varchar(50) NULL
);

CREATE TABLE InstituteAlias (
    instituteDbId varchar(50) NOT NULL REFERENCES Institute (instituteDbId),
    instituteAlias varchar(50) UNIQUE NOT NULL,
    PRIMARY KEY (instituteDbId, instituteAlias)
);

CREATE TABLE CommmonCropName (
    cropDbId varchar(50) NOT NULL PRIMARY KEY,
    commonCropName varchar(50) UNIQUE NOT NULL
);

CREATE TABLE Person (
    personDbId varchar(50) NOT NULL PRIMARY KEY,
    additionalInfo json NULL, -- move to separate table
    description text NULL,
    emailAddress varchar(254) NULL,
    externalReferences json[] NULL, -- move to PersonExtRef table
    firstName varchar(50) NULL,
    middleName varchar(50) NULL,
    lastName varchar(50) NULL,
    mailingAddress varchar(255) NULL,
    phoneNumber varchar(50) NULL,
    orcid varchar(50) NULL, -- set up regex to validate this in Django
    roleType varchar(50) NULL, -- MIAPPE V1.1 (DM-34 Person role)
    instituteDbId varchar(50) NOT NULL REFERENCES Institute (instituteDbId) ON DELETE CASCADE,
    userID varchar(50) NULL -- should this be public or private?
);

CREATE TABLE PersonExtRef (
    personDbId varchar(50) NOT NULL REFERENCES Person (personDbId) ON DELETE CASCADE,
    referenceId varchar(50) UNIQUE NOT NULL,
    referenceSource varchar(50) NOT NULL,
    PRIMARY KEY (personDbId, referenceId)
);

CREATE TABLE Season (
    seasonDbId varchar(50) NOT NULL PRIMARY KEY,
    seasonName varchar(50) NOT NULL,
    year integer NOT NULL
);

CREATE TABLE Location (
    locationDbId varchar(50) NOT NULL PRIMARY KEY,
    locationName varchar(50) UNIQUE NOT NULL,
    abbreviation varchar(50) NULL,
    additionalInfo json NULL, -- moved to separate table
    coordinateDescription text NULL,
    coordinateUncertainty varchar(255) NULL,
    coordinates json NULL, -- GeoJSON move to MONGODB?
    countryCode varchar(3) NOT NULL REFERENCES Country (countryCode) ON DELETE CASCADE,
    countryName varchar(50) NULL, -- moved to Country Table 
    documentationURL text NULL,
    environmentType varchar(50) NULL, -- control this list as an ENUM type or in an admin defined controlled vocab
    exposure varchar(50) NULL,
    externalReferences json[] NULL, -- moved to LocationExtRef
    instituteDbId varchar(50) NULL REFERENCES Institute (instituteDbId) ON DELETE CASCADE, -- Added
    instituteAddress varchar(50) NULL, -- moved to Institute
    instituteName varchar(50) NULL, -- moved to Institute
    locationType varchar(50) NULL, -- control this list as an ENUM type or admin defined controlled vocab
    parentLocationDbId varchar(50) NULL REFERENCES Location (locationDbId) ON DELETE CASCADE,
    parentLocationName varchar(50) NULL, -- Redundant, remove
    siteStatus varchar(50) NULL, -- description of accessibility of the location
    slope varchar(50) NULL,
    topography varchar(50) NULL
);

CREATE TABLE LocationExtRef (
    locationDbId varchar(50) NOT NULL REFERENCES Location (locationDbId) ON DELETE CASCADE,
    referenceId varchar(50) UNIQUE NOT NULL,
    referenceSource varchar(50) NOT NULL,
    PRIMARY KEY (locationDbId, referenceId)
);

CREATE TABLE ListDetails (
    listDbId varchar(50) NOT NULL PRIMARY KEY,
    listName varchar(50) NOT NULL,
    listType varchar(50) NOT NULL,
    --data varchar(50)[] NOT NULL (References germplasm db ids, may need to make constraint in application not SQL. Probably need join table with list id and gerplams ids and create data list in application, return as array in api)
    additionalInfo json NULL, -- move to separate table
    dateCreated timestamp NULL,
    dateModified timestamp NULL,
    externalReferences json[] NULL,
    listDescription text NULL,
    listOwnerPersonDbId varchar(50) NULL REFERENCES Person (personDbId),
    listOwnerName varchar(50) NULL, -- part of a view?
    listSize integer NULL, -- calculated field based on list size
    listSource varchar(50) NULL
);

CREATE TABLE List (
    listDbId varchar(50),
    listItemDbId varchar(50),
    PRIMARY KEY (listDbId, listItemDbId)
);

CREATE TABLE ListExtRef (
    listDbId varchar(50) NOT NULL REFERENCES ListDetails (listDbId) ON DELETE CASCADE,
    referenceId varchar(50) UNIQUE NOT NULL,
    referenceSource varchar(50) NOT NULL,
    PRIMARY KEY (listDbId, referenceId)
);

CREATE TABLE Program (
    programDbId varchar(50) NOT NULL PRIMARY KEY,
    programName varchar(50) UNIQUE NOT NULL,
    abbreviation varchar(50) NULL,
    additionalInfo json NULL, -- moved to separate table
    commonCropName varchar(50) NULL, -- Can one program have more than one common crop as a focus? For instance, should the TLI Perennial Legumes have two common crops, sainfoi
    documentationURL text NULL,
    externalReferences json[] NULL, -- Moved to ProgramExtRef table
    fundingInformation varchar(255) NULL,
    instituteDbId varchar(50) NOT NULL REFERENCES Institute (instituteDbId) ON DELETE CASCADE,
    leadPersonDbId varchar(50) NOT NULL REFERENCES Person (personDbId),
    leadPersonName varchar(50) NULL, -- part of a view?
    objective text NULL,
    programType program_type NULL
);

CREATE TABLE ProgramExtRef (
    programDbId varchar(50) NOT NULL REFERENCES Program (programDbId) ON DELETE CASCADE,
    referenceId varchar(50) UNIQUE NOT NULL,
    referenceSource varchar(50) NOT NULL,
    PRIMARY KEY (programDbId, referenceId)
);

CREATE TABLE ProgramMembers (
    programDbId varchar(50) NOT NULL REFERENCES Program(programDbId) ON DELETE CASCADE,
    personDbId varchar(50) NOT NULL REFERENCES Person (personDbId) ON DELETE CASCADE,
    PRIMARY KEY (programDbId, personDbId)
);

CREATE TABLE Trial ( -- equivalent to MIAPPE V1 Investigation
    trialDbId varchar(50) NOT NULL PRIMARY KEY,
    trialName varchar(50) UNIQUE NOT NULL,
    active boolean NULL,
    additionalInfo json NULL, -- moved to separate table
    commonCropName varchar(50) NULL,
    contacts json[] NULL, -- moved to TrialPeople
    datasetAuthorship json[] NULL, -- moved to DatasetAuthorship
    documentationURL text NULL,
    endDate timestamp NULL,
    externalReferences json[] NULL, -- moved to TrialExtRef
    programDbId varchar(50) NOT NULL REFERENCES Program (programDbId) ON DELETE CASCADE,
    programName varchar(50) NULL, -- part of a view?
    publications json[] NULL, -- moved to publications
    startDate timestamp NULL,
    trialDescription text NULL,
    trialPUI varchar(255) NULL
);

CREATE TABLE TrialExtRef (
    trialDbId varchar(50) NOT NULL REFERENCES Trial (trialDbId) ON DELETE CASCADE,
    referenceId varchar(50) UNIQUE NOT NULL,
    referenceSource varchar(50) NOT NULL,
    PRIMARY KEY (trialDbId, referenceId)
);

CREATE TABLE TrialPeople (
    trialDbId varchar(50) NOT NULL REFERENCES Trial (trialDbId) ON DELETE CASCADE,
    personDbId varchar(50) NOT NULL REFERENCES Person (personDbId) ON DELETE CASCADE,
    PRIMARY KEY (trialDbId, personDbId)
);

CREATE TABLE DatasetAuthorship (
    trialDbId varchar(50) NOT NULL REFERENCES Trial (trialDbId) ON DELETE CASCADE,
    datasetPUI varchar(50) NOT NULL, -- A DOI or PUID associated with a dataset
    license varchar(50) NOT NULL,
    publicReleaseDate varchar(50) NOT NULL,
    PRIMARY KEY (trialDbId, datasetPUI)
);

CREATE TABLE Publications ( -- I think we should modify this table heavily...
    trialDbId varchar(50) NOT NULL REFERENCES Trial (trialDbId) ON DELETE CASCADE,
    publicationPUI varchar(50) NOT NULL, -- DOI for publication,
    publicationReference varchar(50) NULL,
    PRIMARY KEY (trialDbId, publicationPUI)
);

CREATE TABLE Study ( -- equivalent to MIAPPE v1 Study
    studyDbId varchar(50) NOT NULL PRIMARY KEY,
    studyName varchar(50) UNIQUE NOT NULL,
    active boolean NULL, 
    additionalInfo json NULL, -- moved to separate table
    commonCropName varchar(50) NULL,
    contacts json[] NULL, -- moved to StudyPeople
    culturalPractices varchar(50) NULL,
    dataLinks json[] NULL, -- will migrate this later
    documentationURL text NULL,
    endDate timestamp NULL,
    environmentParameters json[] NULL, -- moved to StudyEnvParams
    experimentalDesign json NULL,
    externalReferences json[] NULL, -- moved to StudyExtRef
    growthFacility json NULL, -- make this a new table
    lastUpdate json NULL, -- make this a new table
    license varchar(50) NULL,
    locationDbId varchar(50) NULL,
    locationName varchar(50) NULL,
    observationLevels json[] NULL, -- make this a new table
    observationUnitsDescription text NULL,
    observationVariableDbIds varchar(50)[] NULL,
    seasons varchar(50)[] NULL,
    startDate timestamp NULL,
    studyCode varchar(50) NULL,
    studyDescription text NULL,
    studyPUI varchar(50) NULL,
    studyType varchar(50) NULL,
    trialDbId varchar(50) NULL,
    trialName varchar(50) NULL -- part of a view?
);

CREATE TABLE StudyPeople (
    studyDbId varchar(50) NOT NULL REFERENCES Study (studyDbId) ON DELETE CASCADE,
    personDbId varchar(50) NOT NULL REFERENCES Person (personDbId) ON DELETE CASCADE,
    PRIMARY KEY (studyDbId, personDbId)
);

-- CREATE TABLE DataLinks , pass for now

CREATE TABLE StudyEnvParams ( -- Build more of this out with AGRO and ENVO ontologies
    trialDbId varchar(50) NOT NULL REFERENCES Study (studyDbId) ON DELETE CASCADE,
    description text NOT NULL,
    parameterName varchar(50) NOT NULL,
    parameterPUI varchar(50) NOT NULL,
    unit varchar(50) NOT NULL, -- reference to a units ontology?
    unitPUI varchar(50) NOT NULL, -- URI pointing to ontology class
    value varchar(50) NOT NULL,
    valuePUI varchar(50) NOT NULL,
    PRIMARY KEY (trialDbId, parameterPUI)
);

CREATE TABLE StudyExtRef (
    studyDbId varchar(50) NOT NULL REFERENCES Study (studyDbId) ON DELETE CASCADE,
    referenceId varchar(50) UNIQUE NOT NULL,
    referenceSource varchar(50) NOT NULL,
    PRIMARY KEY (studyDbId, referenceId)
);

-- BrAPI Core Module Additional Info Tables
CREATE TABLE PersonAdditionalInfo (
    personDbId varchar(50) NOT NULL REFERENCES Person (personDbId),
    infoKey varchar(50) NOT NULL,
    infoValue varchar(50) NOT NULL,
    PRIMARY KEY (personDbId, infoKey)
);

CREATE TABLE LocationAdditionalInfo (
    locationDbId varchar(50) NOT NULL REFERENCES Location (locationDbId),
    infoKey varchar(50) NOT NULL,
    infoValue varchar(50) NOT NULL,
    PRIMARY KEY (locationDbId, infoKey)
);

CREATE TABLE ListAdditionalInfo (
    listDbId varchar(50) NOT NULL REFERENCES ListDetails (listDbId),
    infoKey varchar(50) NOT NULL,
    infoValue varchar(50) NOT NULL,
    PRIMARY KEY (listDbId, infoKey)
);

CREATE TABLE ProgramAdditionalInfo (
    programDbId varchar(50) NOT NULL REFERENCES Program (programDbId),
    infoKey varchar(50) NOT NULL,
    infoValue varchar(50) NOT NULL,
    PRIMARY KEY (programDbId, infoKey)
);

CREATE TABLE TrialAdditionalInfo (
    trialDbId varchar(50) NOT NULL REFERENCES Trial (trialDbId),
    infoKey varchar(50) NOT NULL,
    infoValue varchar(50) NOT NULL,
    PRIMARY KEY (trialDbId, infoKey)
);

CREATE TABLE StudyAdditionalInfo (
    studyDbId varchar(50) NOT NULL REFERENCES Study (studyDbId),
    infoKey varchar(50) NOT NULL,
    infoValue varchar(50) NOT NULL,
    PRIMARY KEY (studyDbId, infoKey)
);

