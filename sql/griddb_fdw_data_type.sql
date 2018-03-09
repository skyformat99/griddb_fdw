CREATE EXTENSION griddb_fdw;
CREATE SERVER griddb_svr FOREIGN DATA WRAPPER griddb_fdw OPTIONS(host '239.0.0.1', port '31999', clustername 'ktymCluster');
CREATE USER MAPPING FOR public SERVER griddb_svr OPTIONS(username 'admin', password 'testadmin');

IMPORT FOREIGN SCHEMA griddb_schema FROM SERVER griddb_svr INTO public;
-- GridDB containers type_XXX must be created for this test on GridDB server
/*
CREATE TABLE type_string (col text)
CREATE TABLE type_boolean (col boolean)
CREATE TABLE type_byte (col char)
CREATE TABLE type_short (col short)
CREATE TABLE type_integer (col integer)
CREATE TABLE type_long (col long)
CREATE TABLE type_float (col float)
CREATE TABLE type_double (col double)
CREATE TABLE type_timestamp (col timestamp)
CREATE TABLE type_blob (col blob)
CREATE TABLE type_string_array (col text[])
CREATE TABLE type_bool_array (col boolean[])
CREATE TABLE type_byte_array (col char[])
CREATE TABLE type_short_array (col short[])
CREATE TABLE type_integer_array (col integer[])
CREATE TABLE type_long_array (col long[])
CREATE TABLE type_float_array (col float[])
CREATE TABLE type_double_array (col double[])
CREATE TABLE type_timestamp_array (col timestamp[])
-- CREATE TABLE type_geometry (col geometry)
*/

DELETE FROM type_string;
DELETE FROM type_boolean;
DELETE FROM type_byte;
DELETE FROM type_short;
DELETE FROM type_integer;
DELETE FROM type_long;
DELETE FROM type_float;
DELETE FROM type_double;
DELETE FROM type_timestamp;
DELETE FROM type_blob;
DELETE FROM type_string_array;
DELETE FROM type_bool_array;
DELETE FROM type_byte_array;
DELETE FROM type_short_array;
DELETE FROM type_integer_array;
DELETE FROM type_long_array;
DELETE FROM type_float_array;
DELETE FROM type_double_array;
DELETE FROM type_timestamp_array;
-- DELETE FROM type_geometry;


INSERT INTO type_string(col) VALUES ('str');
INSERT INTO type_string(col) VALUES ('stringA');
INSERT INTO type_string(col) VALUES ('stringB');
INSERT INTO type_boolean(col) VALUES (TRUE);
INSERT INTO type_byte(col) VALUES ('c');
INSERT INTO type_short(col) VALUES (1);
INSERT INTO type_integer(col) VALUES (32768);
INSERT INTO type_long(col) VALUES (2147483648);
INSERT INTO type_float(col) VALUES (1.58);
INSERT INTO type_float(col) VALUES (3.14);
INSERT INTO type_double(col) VALUES (3.14159265);
INSERT INTO type_double(col) VALUES (5.67890123);
INSERT INTO type_timestamp(col) VALUES ('2017.11.06 12:34:56.789');
INSERT INTO type_timestamp(col) VALUES ('2200.12.31 23:59:59.999');
INSERT INTO type_blob(col) VALUES (bytea('\xDEADBEEF'));
INSERT INTO type_string_array(col) VALUES ('{"s1","s2","s3"}');
INSERT INTO type_bool_array(col) VALUES ('{TRUE, FALSE, TRUE, FALSE}');
INSERT INTO type_byte_array(col) VALUES ('{"a","b","c"}');
INSERT INTO type_short_array(col) VALUES ('{100,200,300}');
INSERT INTO type_integer_array(col) VALUES ('{1,32768,65537}');
INSERT INTO type_long_array(col) VALUES ('{1,2147483648,4294967297}');
INSERT INTO type_float_array(col) VALUES ('{3.14,3.149,3.1492}');
INSERT INTO type_double_array(col) VALUES ('{3.14926,3.149265,3.1492653}');
INSERT INTO type_timestamp_array(col) VALUES ('{"2017.11.06 12:34:56.789","2017.11.07 12:34:56.789","2017.11.08 12:34:56.789"}');
-- INSERT INTO type_geometry(col) VALUES ('');


SELECT * FROM type_string;
SELECT * FROM type_boolean;
SELECT * FROM type_byte;
SELECT * FROM type_short;
SELECT * FROM type_integer;
SELECT * FROM type_long;
SELECT * FROM type_float;
SELECT * FROM type_double;
SELECT * FROM type_timestamp;
SELECT * FROM type_blob;
SELECT * FROM type_string_array;
SELECT * FROM type_bool_array;
SELECT * FROM type_byte_array;
SELECT * FROM type_short_array;
SELECT * FROM type_integer_array;
SELECT * FROM type_long_array;
SELECT * FROM type_float_array;
SELECT * FROM type_double_array;
SELECT * FROM type_timestamp_array;
-- SELECT * FROM type_geometry;

-- function test
SELECT * FROM type_string WHERE char_length(col) > 5;
SELECT * FROM type_string WHERE concat(col,col) = 'strstr';
SELECT * FROM type_string WHERE upper(col) = 'STRINGA';
SELECT * FROM type_string WHERE lower(col) = 'stringa';
SELECT * FROM type_string WHERE substring(col from 2 for 3) = 'tri';
SELECT * FROM type_float WHERE round(col) = 3;
SELECT * FROM type_double WHERE round(col) = 3;
SELECT * FROM type_float WHERE ceiling(col) = 4;
SELECT * FROM type_double WHERE ceiling(col) = 4;
SELECT * FROM type_float WHERE ceil(col) = 4;
SELECT * FROM type_double WHERE ceil(col) = 4;
SELECT * FROM type_float WHERE floor(col) = 3;
SELECT * FROM type_double WHERE floor(col) = 3;
SELECT * FROM type_timestamp WHERE col > now();

-- Clean up
DELETE FROM type_string;
DELETE FROM type_boolean;
DELETE FROM type_byte;
DELETE FROM type_short;
DELETE FROM type_integer;
DELETE FROM type_long;
DELETE FROM type_float;
DELETE FROM type_double;
DELETE FROM type_timestamp;
DELETE FROM type_blob;
DELETE FROM type_string_array;
DELETE FROM type_bool_array;
DELETE FROM type_byte_array;
DELETE FROM type_short_array;
DELETE FROM type_integer_array;
DELETE FROM type_long_array;
DELETE FROM type_float_array;
DELETE FROM type_double_array;
DELETE FROM type_timestamp_array;
-- DELETE FROM type_geometry;

DROP FOREIGN TABLE type_string;
DROP FOREIGN TABLE type_boolean;
DROP FOREIGN TABLE type_byte;
DROP FOREIGN TABLE type_short;
DROP FOREIGN TABLE type_integer;
DROP FOREIGN TABLE type_long;
DROP FOREIGN TABLE type_float;
DROP FOREIGN TABLE type_double;
DROP FOREIGN TABLE type_timestamp;
DROP FOREIGN TABLE type_blob;
DROP FOREIGN TABLE type_string_array;
DROP FOREIGN TABLE type_bool_array;
DROP FOREIGN TABLE type_byte_array;
DROP FOREIGN TABLE type_short_array;
DROP FOREIGN TABLE type_integer_array;
DROP FOREIGN TABLE type_long_array;
DROP FOREIGN TABLE type_float_array;
DROP FOREIGN TABLE type_double_array;
DROP FOREIGN TABLE type_timestamp_array;
-- DROP FOREIGN TABLE type_geometry;

CREATE OR REPLACE FUNCTION drop_all_foreign_tables() RETURNS void AS $$
DECLARE
  tbl_name varchar;
  cmd varchar;
BEGIN
  FOR tbl_name IN SELECT foreign_table_name FROM information_schema._pg_foreign_tables LOOP
    cmd := 'DROP FOREIGN TABLE ' || tbl_name;
    EXECUTE cmd;
  END LOOP;
  RETURN;
END
$$ LANGUAGE plpgsql;
SELECT drop_all_foreign_tables();

DROP USER MAPPING FOR public SERVER griddb_svr;
DROP SERVER griddb_svr CASCADE;
DROP EXTENSION griddb_fdw CASCADE;
