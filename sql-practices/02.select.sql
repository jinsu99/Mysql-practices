-- select from where order by 
-- 순서를 맞추지 않으면 에러 발생하니 주의. 
-- 실행 순서는 입력 순서와 다르다.

-- 1. from 		: from절의 테이블을 확인 > 테이블을 여러개 선택하기도 한다. 
-- 2. where 	: 데이터 조건 
-- 3. order by 	: 정렬 > 데이터만 가져오는 것에 비해 속도가 느려진다. 
-- 4. select	: projection > 위의 문장을 모두 확인하고 마지막에 데이터를 가져온다. 

select * from departments;
select first_name, last_name, hire_date from employees;

-- 칼럼 별칭설정해서 select 
select first_name as '이름', last_name as '성', hire_date as '입사일' from employees;

-- 함수 사용하기 --
-- concat 함수 사용하기 : 칼럼을 병합해서 보여준다. 
select concat(first_name, ' ' ,last_name) as '이름', hire_date as '입사일' from employees;

-- length 함수 사용하기 : 데이터의 길이를 보여준다. 
select 
	concat(first_name, ' ' ,last_name) as 'name', 
	length(first_name)+length(last_name) as 'name-length' 
from employees

-- distinct 함수 사용하기 : 중복값을 제외하고 보여준다. 
select * from titles;
select distinct title from titles;

-- order by 사용하기
-- 1. (default) : 오름차순
-- 2. asc : 오름차순
-- 3. desc : 내림차순
select 	
	concat(first_name, last_name) as 'name',
	length(first_name)+length(last_name) as 'name-length',
	gender, hire_date
	from employees 
	order by hire_date desc;

-- where-like 사용하기 : 데이터의 형태를 지정하여, 해당하는 데이터 걸러내기 
-- 언더바 : 글자 자리수를 지정 
select * from employees where first_name like '%p'; 	-- p로 시작하는 firstname
select * from employees where first_name like 'p____'; 	-- p로 시작하고, p를 제외한 글자수가 4글자인 firstname


-- Quiz1. salaries 테이블에서 2001년 월급을 높은순으로 출력 (사번, 월급 순으로 출력) 
-- 1. where Like 검색을 사용하기 
select		
	emp_no as '사번 ', salary as '월급 '  
	from salaries 
	where from_date like '2001-%' 
	order by salary desc;

-- 2. where절에 부등호 사용하기 
select		
	emp_no as '사번 ', salary as '월급 '  
	from salaries 
	where from_date > '2000-12-31' and from_date < '2002-01-01'
	order by salary desc;


-- Quiz2. employees 테이블에서 1991년 이전에 입사한 직원의 이름, 성별, 입사일을 출력
select 
	concat(first_name, ' ', last_name) as name,
	gender, hire_date
	from employees
	where hire_date < '1991-1-1'
	order by hire_date desc;


-- Quiz3. employees 테이블에서 1989년 이전에 입사한 여직원의 이름, 입사일 출력 
select 
	concat(first_name, ' ', last_name) as name,
	gender, hire_date
	from employees
	where hire_date < '1989-1-1' and gender = 'F'
	order by hire_date desc;

-- date_format 사용하기 : 날짜뿐만 아니라 시간 fromat도 정해줄 수 있다.
select
	DATE_FORMAT(hire_date, '%Y/%m/%d - %h:%i:%s') as 'hire_date'
	from employees
	
-- count 사용하기
select count(*) from employees;
select count(salary) from salaries where salary > 120000;
-- 실행 순서가 select가 가장 마지막 이기 때문에 위와 같이 사용할 수 있다.
-- select문을 사용하면 sql에서는 임시 테이블을 보여준다.
-- 그렇기 때문에 조건문을 통해 먼저 데이터를 선별한 다음 count를 하므로, 위와 같은 쿼리문을 사용할 수 있다.



