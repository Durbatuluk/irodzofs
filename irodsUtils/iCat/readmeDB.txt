#installer la BD :
cmd : su - postgres
cmd : psql 
cmd : CREATE USER irods WITH PASSWORD 'root';
cmd : CREATE DATABASE "ICAT";
cmd : GRANT ALL PRIVILEGES ON DATABASE "ICAT" TO irods;
cmd : \q

