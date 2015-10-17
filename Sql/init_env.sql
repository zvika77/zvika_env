create schema SITE_DATA;
create schema SITE_DATA_MASTER;

create schema DBADMIN;
create schema DBADMIN_MASTER;

create role LP_SITE_DATA_RO;
create role LP_SITE_DATA_DML;


grant usage on schema SITE_DATA to LP_SITE_DATA_RO;
grant usage on schema SITE_DATA to LP_SITE_DATA_DML;


create table dbadmin.version (version_date date,version_name varchar(100));
create table dbadmin_master.version (version_date date,version_name varchar(100));
create table site_data.version (version_date date,version_name varchar(100));
create table site_data_master.version (version_date date,version_name varchar(100));
