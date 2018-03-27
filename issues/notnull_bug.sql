create table t1 (c1 varchar2(30));

insert into t1 select ' ' from dual connect by level <= 10;
commit;

select * from t1;

alter table t1 add (c2 varchar2(30) default nullif(' ',' ') not null );  --BUG here!
alter table t1 add (c3 varchar2(30) default nullif('a','b') not null );  --BUG here!


select * from t1 where c2 is null; --no rows
select * from t1 where c3 is null; --no rows
select * from t1; --nulls exist

--check constraint
select owner, table_name, constraint_type, table_name, search_condition, status, deferrable, deferred, validated from dba_constraints where table_name = 'T1'; --constrain is validated!!!

--CTAS
create table t2 as select * from t1;  --propagation of error to another table

select * from t2; --nulls exist

select owner, table_name, constraint_type, table_name, search_condition, status, deferrable, deferred, validated from dba_constraints where table_name = 'T2'; --constrain is validated!!!