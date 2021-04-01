-- 예제1. 현재 Fai Bale이 근무하는 부서의 전체 직원의 사번과 이름을 출력

-- sol(1) 개별 쿼리로 해결
select dept_no
	from dept_emp de, employees e 
	where de.emp_no = e.emp_no 
		and de.to_date = '9999-01-01'
		and concat(e.first_name, ' ', e.last_name) = 'Fai Bale';

select de.emp_no , e.first_name 
	from dept_emp de, employees e 
	where de.emp_no = e.emp_no 
		and de.to_date = '9999-01-01'
		and de.dept_no = 'd004';

-- sol(2) 서브 쿼리로 해결
-- > where의 조건식에 서브쿼리 사용
-- > 결과가 단일 행인 경우 =, !=, >, <, >=, <= 연산자를 사용할 수 있다

-- 1. Fai Bale이 근무하는 부서.no을 구하는 쿼리를 먼저 작성 : sol(1) 참고
-- 2. 부서를 찾는 서브 쿼리로 넣기 (where절)
select de.emp_no , concat(e.first_name, ' ', e.last_name)
	from dept_emp de, employees e 
	where de.emp_no = e.emp_no 
		and de.to_date = '9999-01-01'
		and de.dept_no = (select dept_no
							from dept_emp de, employees e 
							where de.emp_no = e.emp_no 
								and de.to_date = '9999-01-01'
								and concat(e.first_name, ' ', e.last_name) = 'Fai Bale');		

-- 예제2. 현재 전체 사원의 평균 급여보다 적은 급여를 받는 사원들의 이름, 급여를 출력
-- 1. 평균 급여 구하기
select avg(salary) from salaries s	where s.to_date = '9999-01-01';

-- 2. 서브 쿼리로 넣기	 							
select concat(e.first_name, ' ', e.last_name) as name, s.salary 
	from salaries s, employees e
	where s.emp_no = e.emp_no
	 and s.to_date = '9999-01-01'
	 and s.salary < (select avg(salary) from salaries s	where s.to_date = '9999-01-01')
	order by s.salary desc; 


-- > where의 조건식에 서브쿼리를 사용한 경우
-- > 결과가 멀티행, 멀티열인 경우 :
-- >> in (not in)
-- >> any: =any(in 동일), >any, <any, <>any(!=any), <=any, >=any
-- >> all: =all, >all, <>all(!=all, not in), <=all, >=all
-- >> != 와 <>의 의미는 같다. != 사용을 추천

-- 예제3. 현 급여가 50000 이상인 직원의 이름과 급여를 출력

-- sol(1) equi-join 사용하기
select e.first_name , s.salary 
	from employees e , salaries s 
	where e.emp_no = s.emp_no
	 and s.to_date = '9999-01-01'
	 and s.salary > 50000
	order by s.salary ;

-- sol(2) subquery-멀티행,열 : =any
-- 1. 현 급여가 50000 이상인 직원의 emp_no/급여 조회하기
select emp_no, salary from salaries where to_date = '9999-01-01'and salary > 50000;

-- 2. 서브 쿼리로 넣기
select e.first_name , s.salary 
	from employees e , salaries s 
	where e.emp_no = s.emp_no
	 and s.to_date = '9999-01-01'
	 -- > 서브 쿼리로 조회한 임시 테이블과 비교하기
	 -- > 서브 쿼리에서 조회한 칼럼과, 비교 대상이 같아야한다.
	 and (e.emp_no, s.salary) = any(select emp_no, salary from salaries where to_date = '9999-01-01'and salary > 50000)
	order by s.salary ;

-- sol(3) subquery-멀티행,열 : in
select e.first_name , s.salary 
	from employees e , salaries s 
	where e.emp_no = s.emp_no
	 and s.to_date = '9999-01-01'
	 and (e.emp_no, s.salary) in(select emp_no, salary from salaries where to_date = '9999-01-01'and salary > 50000)
	order by s.salary ;

-- sol(4) subquery-멀티행,열 : from 쿼리물
-- > 쿼리문은 결과를 출력하기 위해 임시 테이블을 생성하므로, from문에 쿼리문을 삽입할수도 있다.
-- > 이 경우 별칭을 반드시 만들어야 where절이나 다른 곳에서 사용할 수 있으니 주의하자. (별칭 만들 때 as 생략 가능)
select e.first_name , temp.salary 
	from employees e , 
		(select emp_no, salary from salaries where to_date = '9999-01-01'and salary > 50000) temp
	where e.emp_no = temp.emp_no
	order by temp.salary;

-- 예제4-1. 현재의 직책별 평균 급여를 출력
select t.title, temp.avg_salary
	from titles t,
		 (select emp_no, avg(salary) as avg_salary from salaries where to_date = '9999-01-01' group by emp_no) temp
	where t.emp_no = temp.emp_no
	group by t.title
	order by temp.avg_salary
	limit 1;

-- 예제4-2. [심화] 현재 가장 적은 직책별 평균급여를 구하고 칙책과 평균급여를 같이 출력
-- 힌트. 직책별 평균 급여를 먼저 구하고, 해당 쿼리문을 from문에 추가한다
-- 힌트. 소수점 처리를 위해 round() 함수를 사용

-- sol(1) 
-- 1. 직책별 평균 급여 구하기
select t.title, round(avg(s.salary)) as avg_salary 
	from titles t, salaries s 
	where t.emp_no = s.emp_no 
	 and t.to_date = '9999-01-01' 
	 and s.to_date = '9999-01-01' 
	group by t.title;

-- 2. 서브 쿼리로 넣기 : having절에 사용
select t.title, round(avg(s.salary)) as avg_salary 
	from titles t, salaries s 
	where t.emp_no = s.emp_no 
	 and t.to_date = '9999-01-01' 
	 and s.to_date = '9999-01-01' 
	group by t.title
	having avg_salary = ( select min(avg_salary) 
							from (select t.title, round(avg(s.salary)) as avg_salary 
									from titles t, salaries s 
									where t.emp_no = s.emp_no 
									 and t.to_date = '9999-01-01' 
									 and s.to_date = '9999-01-01' 
									group by t.title) as s
									);


-- sol(2) top-k : 정렬 후 limit절 활용
select t.title, round(avg(s.salary)) as avg_salary 
	from titles t , salaries s 
	where t.emp_no = s.emp_no 
	 and t.to_date = '9999-01-01'
	 and s.to_date = '9999-01-01'
	group by t.title 
	order by avg_salary
	limit 1;
	
	
-- 예제5. !현재! 각 부서별로 최고 급여를 받는 사원의 이름과 급여를 출력
-- 힌트. 부서별 최고 급여를 먼저 구한다. 
-- sol(1) from절에 서브쿼리 / sol(2) where절에 서브쿼리

-- sol(1) : 진숙
-- 1. 부서별 최고 급여 구하기
select de.dept_no , max(s.salary) as max_salary
	from salaries s , dept_emp de
	where s.emp_no = de.emp_no and de.to_date = '9999-01-01' and s.to_date = '9999-01-01' 
	group by de.dept_no ;

-- 2. from에 서브쿼리 추가
select d.dept_name , concat(e.first_name, ' ', e.last_name) as name, s.salary
	from departments d, dept_emp de, employees e, salaries s,
		(select de.dept_no , max(s.salary) as max_salary
			from salaries s , dept_emp de
			where s.emp_no = de.emp_no and de.to_date = '9999-01-01' and s.to_date = '9999-01-01' 
			group by de.dept_no ) as temp
	where temp.dept_no = de.dept_no 
	 -- > 실행 시간 단축위해 먼저 한번 걸러주자 (현재 재직 여부)
     and de.to_date = '9999-01-01'
     and s.to_date = '9999-01-01'
	 and de.emp_no = e.emp_no 
	 and de.emp_no = s.emp_no 
	 and de.dept_no = d.dept_no 
	 and temp.max_salary = s.salary;	 

-- sol(2) : 진숙
-- 1. 부서별 최고 급여 구하기
select de.dept_no , max(s.salary) as max_salary
	from salaries s , dept_emp de
	where s.emp_no = de.emp_no and de.to_date = '9999-01-01' and s.to_date = '9999-01-01' 
	group by de.dept_no ;

-- 2. where에 서브쿼리 추가
-- 	 and (e.emp_no, s.salary) = any(select emp_no, salary from salaries where to_date = '9999-01-01'and salary > 50000)
select d.dept_name , concat(e.first_name, ' ', e.last_name) as name, s.salary
	from departments d, dept_emp de, employees e, salaries s
	where de.emp_no = e.emp_no 
	 and de.emp_no = s.emp_no 
	 and de.dept_no = d.dept_no
	 -- > 실행 시간 단축위해 먼저 한번 걸러주자 (현재 재직 여부)
     and de.to_date = '9999-01-01'
     and s.to_date = '9999-01-01'
	 and (de.dept_no, s.salary) in (select de.dept_no , max(s.salary) as max_salary
									from salaries s , dept_emp de
									where s.emp_no = de.emp_no and de.to_date = '9999-01-01' and s.to_date = '9999-01-01' 
									group by de.dept_no );
	
	
-- sol(1) : 강사님 코드
select a.first_name, b.dept_no, d.dept_name, c.salary
  from employees a,
       dept_emp b,
       salaries c,
       departments d,
       (  select a.dept_no, max(b.salary) as max_salary
		    from dept_emp a, salaries b
           where a.emp_no = b.emp_no
             and a.to_date = '9999-01-01'
             and b.to_date = '9999-01-01'
        group by a.dept_no) e
 where a.emp_no = b.emp_no
   and b.emp_no = c.emp_no
   and b.dept_no = d.dept_no
   and b.dept_no = e.dept_no
   and c.salary = e.max_salary
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
order by c.salary desc; 
	 
-- sol(2) where 에 서브쿼리 추가(다중행으로) : 강사님 코드
select a.first_name, b.dept_no, d.dept_name, c.salary
  from employees a,
       dept_emp b,
       salaries c,
       departments d
 where a.emp_no = b.emp_no
   and b.emp_no = c.emp_no
   and b.dept_no = d.dept_no
   and b.to_date = '9999-01-01'
   and c.to_date = '9999-01-01'
   and (b.dept_no, c.salary) in (select a.dept_no, max(b.salary) as max_salary
                                     from dept_emp a, salaries b
                                      where a.emp_no = b.emp_no
                                        and a.to_date = '9999-01-01'
                                        and b.to_date = '9999-01-01'
								   group by a.dept_no)
order by c.salary desc;


-- 추가
-- > slect문에도 서브쿼리 사용 가능
-- > insert문에도 서브쿼리 사용 가능 (join은 불가능) : transaction 때문
select (select max(salary) from salaries where to_date ='9999-01-01') as test;

-- transaction : setion을 만들어서 가상으로 수정하다가 commit을 사용해야 실제로 처리된다.
-- > 예를 들어 	
-- >> update 받는 계좌 set 잔고 = 잔고 + 금액 where account = ...
-- >> update 보낸 계좌 set 잔고 = 잔고 - 금액 where account = ...
-- >> 아직 반영되지 않은 상태
-- >> commit()
-- >> 반영 완료 
-- > 마지막에 반영되지 않고 즉각적으로 반영되는 경우, 
-- > 만약 중간에 문제가 발생하면 보낸 계좌에서 잔고에서 차감이 안될수도 있다.

-- > 즉, DB 서버에 여러 개의 클라이언트가 동시에 액세스 하거나 
-- > 응용프로그램이 갱신을 처리하는 과정에서 중단될 수 있는 경우 등 
-- > 데이터 부정합을 방지하고자 할 때 사용한다.

-- > 정리
-- >> 업무를 논리적 단위로 나누어 진행
-- >> 데이터의 부정합 방지!













