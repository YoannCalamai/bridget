-- Create the Category table if it doesn't exist
CREATE TABLE IF NOT EXISTS BudCategory (
    CategoryId SERIAL PRIMARY KEY,
    Name TEXT NOT NULL UNIQUE
);

-- Create the SubCategory table if it doesn't exist
CREATE TABLE IF NOT EXISTS BudSubCategory (
    SubCategoryId SERIAL PRIMARY KEY,
    Name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS BudTag(
    TagId SERIAL PRIMARY KEY,
    Name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS BudCategoryAutoConfiguration(
    CategoryAutoConfigurationId SERIAL PRIMARY KEY,
    CategoryId INTEGER NOT NULL,
    TransactionName TEXT NOT NULL,
    TransactionDescription TEXT
);

CREATE TABLE IF NOT EXISTS BudSubCategoryAutoConfiguration(
    SubCategoryAutoConfigurationId SERIAL PRIMARY KEY,
    SubCategoryId INTEGER NOT NULL,
    TransactionName TEXT NOT NULL,
    TransactionDescription TEXT
);

CREATE TABLE IF NOT EXISTS BudTagAutoConfiguration(
    TagAutoConfigurationId SERIAL PRIMARY KEY,
    TagId INTEGER NOT NULL,
    TransactionName TEXT NOT NULL,
    TransactionDescription TEXT
);

CREATE TABLE IF NOT EXISTS BudAccount (
    AccountId SERIAL PRIMARY KEY,
    Name TEXT NOT NULL UNIQUE,
    UserId INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS BudTransaction (
    TransactionId SERIAL PRIMARY KEY,
    AccountId INTEGER NOT NULL,
    CategoryId INTEGER NOT NULL,
    SubCategoryId INTEGER NOT NULL,
    Date DATE NOT NULL,
    Name TEXT NOT NULL,
    Description TEXT NOT NULL,
    Type TEXT NOT NULL,
    Value DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS BudTransactionTag(
    TransactionTagId SERIAL PRIMARY KEY,
    TagId INTEGER NOT NULL,
    TransactionId INTEGER NOT NULL
);