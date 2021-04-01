-- join :  (대부분 inner join을 의미)
-- 0. join condition : fk = pk 인 경우를 조건으로 삼는다

-- 1. inner join : join condition에 맞는 경우만 조회
--    - ANSI1999 표준 join 문법
--    - equi join : where 문에서 

-- 2. outer join : join condition에 맞지 않는 경우도 함께 조회
--    - ANSI1999 표준 join 문법 : outer join은 표준 join만 사용
-- 		> join ~ on : join codition을 명시하므로 가장 많이 사용하고 추천!
-- 		> natural join
-- 		> join ~ using

-- 예제. 현재 근무하고 있는 여자 직원의 이름과 직책을 직원 이름 순으로 출력
select concat(e.last_name, ' ', e.first_name) as name , t.title 
	from employees e , titles t 		-- Alias를 준다 = 별칭 지정
	where e.emp_no = t.emp_no			-- join condition : 연관이 있는 칼럼으로 설정
		and t.to_date = '9999-01-01'	-- select condition 1 : 현재 근무 여부
		and e.gender = 'F'				-- select condition 2 : gender
	order by e.first_name;
	
		
-- limit 0,5 : 0부터 5개 / start 생략 시 첫번째 db부터 end까지 출력
select * from employees limit 0,5;

-- join condition을 설정할 때, 반드시 erd 를 확인하자.
-- 필요한 table이 관계가 있다면 상관없지만, 
-- 아래 예제와 같이 여러 table의 관계를 이용해 join condition을 정해야할수도 있다.

-- 예제. 부서별로 현재 직책이 Enginieer인 직원들에 대해서만 평균 급여 구하기
select de.dept_no , avg(s.salary) as avg_salary
	from dept_emp de, salaries s , titles t 
	where de.emp_no = s.emp_no 	-- join condition 1-1 
		and s.emp_no = t.emp_no -- join condition 1-2
		and de.to_date = '9999-01-01'	-- select condition
		and s.to_date = '9999-01-01'	-- select condition
		and t.to_date = '9999-01-01'	-- select condition
		and t.title = 'Engineer'		-- select condition
	group by de.dept_no
	order by avg_salary desc;

select de.dept_no , d2.dept_name , avg(s.salary) as avg_salary
	from dept_emp de, salaries s , titles t, departments d2 
	where de.emp_no = s.emp_no 			-- join condition 1-1 
		and s.emp_no = t.emp_no 		-- join condition 1-2
		and de.dept_no = d2.dept_no 	-- join condition 1-3
		and de.to_date = '9999-01-01'	-- select condition
		and s.to_date = '9999-01-01'	-- select condition
		and t.to_date = '9999-01-01'	-- select condition
		and t.title = 'Engineer'		-- select condition
	group by de.dept_no
	order by avg_salary desc;

-- Quiz. 
-- 현재 직책별로 급여의 총합을 구하되, Engineer 직책은 제외
-- 급여의 합이 2,000,000,000 이상인 직책을 조회 
-- 급여 총합의 내림차순으로 정렬

select t.title , sum(s.salary) as sum_salary
	from titles t , salaries s 
	where t.emp_no = s.emp_no 			-- join condition
		and t.title != 'Engineer'		-- select condition
		and t.to_date = '9999-01-01'
		and s.to_date = '9999-01-01'
	group by t.title
	having sum_salary > 2000000000
	order by sum_salary desc;


-- ANSI1999 /ISO SQL 1999 JOIN 문법 (ANSI1999 표준 join 문법)
-- > join ~ on
-- > natural join

-- 예제. 현재 근무하고 있는 여자 직원의 이름과 직책을 직원 이름 순으로 출력

-- (1)join ~ on : join 테이블명 on JOIN-CONDITION
select e.first_name, t.title 
	from employees e
	join titles t 						-- join ~ on 사용
	on e.emp_no = t.emp_no				-- join condition : 연관이 있는 칼럼으로 설정
	where t.to_date = '9999-01-01'	-- select condition 1 : 현재 근무 여부
		and e.gender = 'F'				-- select condition 2 : gender
	order by e.first_name;


-- (2)natural join : 같은 이름의 칼럼으로 join condition을 자동 설정
select e.first_name , t.title 
	from employees e 
	natural join titles t 			-- natural join 사용
	where t.to_date = '9999-01-01'
	and e.gender = 'F'
	order by e.first_name ;

-- natural join의 단점
-- > 이름이 같은 칼럼이 모두 join condition으로 설정된다
-- > 아래 예제에서 테이블 titles, salaries를 사용하면
-- > 이름이 같은 칼럼인 emp_no, from_date, to_date가 모두 join condition이 된다
-- > 이를 보완한 방법이 join ~ using

-- join ~ on 사용했을 때 결과 : 146,915
select count(*) 
	from titles t 
	join salaries s 
	on t.emp_no = s.emp_no 
	where t.to_date = '9999-01-01'
		and s.to_date = '9999-01-01';

-- join ~ on 사용했을 때 결과 : 4
select count(*) 
	from titles t 
	natural join salaries s 
	where t.to_date = '9999-01-01'
		and s.to_date = '9999-01-01';
		
-- (3)join ~ using
-- join ~ using 사용했을 때 결과 : 146,915
-- 가장 추천하는 방법은 join ~ on : 원하는 join condition을 명시하자
select count(*) 
	from titles t 
	join salaries s 
	using (emp_no) 
	where t.to_date = '9999-01-01'
		and s.to_date = '9999-01-01';

-- outer join : join condition에 맞지 않는 경우도 함께 조회
--  - ANSI1999 표준 join 문법 : outer join은 표준 join만 사용
-- 	> join ~ on : join codition을 명시하므로 가장 많이 사용하고 추천!
-- 	> natural join
-- 	> join ~ using
--  > left, right join ~ on
	
-- 예제. 현재 회사의 직원명과 부서명을 출력
-- > 예제를 위한 모델링 해보기 : table dept, emp
-- > 추가한 table에 데이터 추가하기
-- > 테이블간 관계를 고려해서 순서대로 insert할 것

-- dept insert
insert into dept values(null, '총무부');
insert into dept values(null, '개발부');
insert into dept values(null, '영업부');

-- emp insert
insert into emp values(null, '둘리', 2);
insert into emp values(null, '마이콜', 3);
insert into emp values(null, '또치', 2);
insert into emp values(null, '도우넛', 3);
insert into emp values(null, '길동', 1);
insert into emp values(null, '희동', NULL);

-- (1)left join : 설정된 테이블의 칼럼이 왼쪽에 출력
-- dept의 name 칼럼이 왼쪽에 출력
-- ifnull(칼럼, '대체문구')

select a.name, ifnull(b.name, '없음')
	from emp a
    left join dept b
    on a.dept_no = b.no;
    
-- (2)right join : 논리적으로 오른쪽에 위치한 테이블의 칼럼이 오른쪽에 출력
-- dept의 name 칼럼이 오른쪽에 출력
select a.name, ifnull(b.name, '없음')
	from emp a
    right join dept b
    on a.dept_no = b.no;
    













