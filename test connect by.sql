create table test_connect_by (
  parent     number,
  child      number primary key,
  constraint test_connect_by_FK foreign key (parent) references test_connect_by(child)
);

delete from test_connect_by;
select * from test_connect_by;
/
begin

insert into test_connect_by values (null, 38);
insert into test_connect_by values (null, 26);
insert into test_connect_by values (null, 18);

insert into test_connect_by values (38,15);
insert into test_connect_by values (38,17);
insert into test_connect_by values (38, 6);

insert into test_connect_by values (15,10);
insert into test_connect_by values (15, 5);

insert into test_connect_by values (26,13);
insert into test_connect_by values (26, 1);
insert into test_connect_by values (26,12);

insert into test_connect_by values (17, 9);
insert into test_connect_by values (17, 8);

insert into test_connect_by values (18,11);
insert into test_connect_by values (18, 7);

insert into test_connect_by values ( 5, 2);
insert into test_connect_by values ( 5, 3);

commit;
end;
/

--bez start with. pocnuva dfs preorder od sekoj jazol
select lpad(' ',2*(level-1)) || to_char(child) s 
from test_connect_by 
  connect by prior child = parent;

select child, count(*), max(level)
  from test_connect_by t
  connect by prior child = parent
  group by child
  order by child;
  
--so start with, pocnva dfs preorder od tie vo start with
select lpad(' ',2*(level-1)) || to_char(child) s 
  from test_connect_by 
  start with parent is null
  connect by prior child = parent;
  --order by level; /*so ova pravime bfs*/
  
select child, count(*), max(level)
  from test_connect_by t
  start with parent is null
  connect by prior child = parent
  group by child
  order by child;