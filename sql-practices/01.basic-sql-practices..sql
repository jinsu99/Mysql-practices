-- pet table 생성 
create table pets(
	name varchar(20), 			-- 가변 데이터는 varchar
	owner varchar(20),
	species varchar(20),
	gender char(1),				-- f, m
	birth date,					-- date type
	death date
);

-- table scheme 확인하기
desc pets;

-- insert
insert into pets values('뽀삐', 'jinsook', 'dog', 'f', '2010-10-20', null);
insert into pets(owner,name,species,gender,birth) values('jinsook', '먼지', 'cat', 'f', '2010-7-10');
insert into pets values('구름', 'jinsook', 'dog', 'f', '2010-2-4', null);
insert into pets values('마', 'jinsook', 'dog', 'f', '2009-1-27', '2020-7-10');

-- select
select * from pets;				-- 이렇게 사용하지 말고
select name,birth from pets;	-- 필요한 정보만 select하자.

-- select / order by
select name, birth from pets order by birth asc;	-- 오름차순 
select name, birth from pets order by birth;		-- asc는 생략 가능 : default
select name, birth from pets order by birth desc;	-- 내림차순 

-- select / count
select count(*) from pets;			-- 테이블에 저장된 데이터 개수 확인 
select count(name) from pets;		-- 칼럼 name에 저장된 데이터 개수 확인 
select count(death) from pets;		-- 칼럼 death	에 저장된 데이터 개수 확인 / null은 count하지 않는다.
select count(*) from pets where death is not null; 

-- update(U)
update pets set species='monkey' where name='뽀삐';	-- workbench > setting > sql editor >  safty... 체크 해제

-- delete(D)
delete from pets where death is not null;

















