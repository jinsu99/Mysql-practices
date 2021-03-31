-- 쿼리문에 집계 함수가 사용되면, 다른 칼럼(name,num....) 은 올라올 수 없다. 
-- 다른 DBMS에서는 오류가 발생하나, MySQL은 에러가 발생하지 않는다.
-- 그렇다고해서 사용해도 된다는 것은 아니니 주의하자.
-- 같은 집계 함수는 같이 사용해도 된다.

-- 예제1. salaries 테이블에서 현재 재직중인 전체 직원의 평균 급여 출력
select emp_no, avg(salary)
	from salaries
	where to_date = '9999-01-01';
	
-- 예제2. salaries 테이블에서 사번이 10060인 직원의 급여 평균과 총 합계를 출력
select avg(salary) as '급여 평균', sum(salary) as '급여 합계' from salaries where emp_no=10060;

-- 예제3.
-- select 절에 집계 함수가 있다면 다른 칼럼은 올 수 없다.
-- 따라서 시기는 조인이나, 서브 쿼리를 통해서 구해야한다.
select max(salary) as '최대 임금', min(salary) as '최저 임금' from salaries where emp_no=10060;


-- 예제4.
select count(*) from dept_emp where dept_no = 'd008' and to_date = '9999-01-01';

-- group by : 그룹 별로 통계를 내야할 때에 사용한다.
-- select - from - where - group by - order by
-- group by에 참여하고 있는 칼럼을 select해야한다.

-- 예제5. 각 사원별로 평균 연봉 출력
select emp_no, avg(salary) as avg_salary
	from salaries
	group by emp_no 
	order by avg_salary desc;

-- having 절
-- group by까지 마무리되면 다시 where절을 사용할 수 없다.
-- having은 group by 이 후에 조건을 주기위해 사용한다.
select emp_no, avg(salary) as avg_salary
	from salaries  
	where to_date = '9999-01-01' 
	group by emp_no
	having avg(avg_salary) > 35000
	order by avg_salary desc;


















