-- Create a user with a password
CREATE USER admin WITH PASSWORD 'changeme';

-- Create a database and grant all privileges to the user
CREATE DATABASE db;
GRANT ALL PRIVILEGES ON DATABASE db TO admin;
