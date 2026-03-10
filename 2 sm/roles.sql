grant connect on database taskdb to admin;
grant all privileges on schema task_manager to admin;
grant all privileges on all tables in schema task_manager to admin;
grant all privileges on all sequences in schema task_manager to admin;

create role app login password 'app123';
grant connect on database taskdb to app;
grant usage on schema task_manager to app;
grant select, insert, update, delete on all tables in schema task_manager to app;
grant usage, select on all sequences in schema task_manager to app;

create role readonly login password 'readonly123';
grant connect on database taskdb to readonly;
grant usage on schema task_manager to readonly;
grant select on all tables in schema task_manager to readonly;

alter default privileges in schema task_manager
grant all privileges on tables to admin;

alter default privileges in schema task_manager
grant all privileges on sequences to admin;

alter default privileges in schema task_manager
grant select, insert, update, delete on tables to app;

alter default privileges in schema task_manager
grant usage, select on sequences to app;

alter default privileges in schema task_manager
grant select on tables to readonly;

grant app to admin;
grant readonly to admin;