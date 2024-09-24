use mydata;
select database();

show tables;

select * from tb_titanic;

/*
passengerid : 승객 id
survived : 생존여부 ( 0:사망 , 1:생존 )
pclass : 객실 등급 (1,2,3)
gender : 성별
age : 나이
sibsp : 동반한 형제 or 자매 or 배우자 수
parch : 동반한 부모 or 자식 수
ticket : 티켓번호
fare : 운임료
cabin : 객실번호
embarked : 탑승항구 ( C:프랑스항구 , S:영국항구 , Q:아일랜드항구 )
*/

-- 컬럼을 선택해서 조회 사능
select name, age from tb_titanic;

-- 조회한 컬럼명에 대해 별칭을 부여할 수 있다
select name as 나이, age as 나이 from tb_titanic;
select name as "이름" , age as 나이 from tb_titanic;

# where 이용하여 조건 줘서 조회하기
select * from tb_titanic
where survived != 1;   -- 사망자만 나온다

select * from tb_titanic
where age > 59;
 
-- is null
select * from tb_titanic
where age is null;

-- is not null
select * from tb_titanic
where age is not null;

-- 특정 문자열이 포함 되어 있는지 조회
-- Miss. , Mrs. , Mr. , Ms. 도 해보자
select * from tb_titanic
where name like '%miss.%'; -- 대소문자 구분하고 싶으면 where 뒤에 binary 넣으면 됨

-- and
select * from tb_titanic
where survived = 1 and gender = "female";

-- or
-- 기혼 여성이거나 미혼 여성인 승객 조회하기
select * from tb_titanic
where name like '%mrs.%' or name like '%misss.%';

-- in, not in
select * from tb_titanic
where embarked in ("c","s");
select * from tb_titanic
where embarked not in ("c","s");

-- 구간 조회
select * from tb_titanic
where age between 20 and 40;

-- 조회 결과 정렬하기
select * 
from tb_titanic
where survived = 1
order by fare ; # 오름차순

select * 
from tb_titanic
where survived = 1
order by fare ; # 내림차순

-- 산술 연산
select name, sibsp + parch as add_sibsp_parch
from tb_titanic;

select name, sibsp - parch as add_sibsp_parch
from tb_titanic;

select name, sibsp * parch as add_sibsp_parch
from tb_titanic;

select name, sibsp / parch as add_sibsp_parch
from tb_titanic;

-- 정규표현식도 가능
select * from tb_titanic
where name regexp "M[rsi]{1,3}[.]";

# 함수 사용하기
-- 중복 제거하기
select distinct(cabin)
from tb_titanic;

-- 조회된 결과의 총 개수 확인하기
select count(passengerid) -- null 제외하고 counting
from tb_titanic;

-- 합계 함수(null 무시)
select sum(fare)
from tb_titanic;

-- 평균 함수(null 무시)
select avg(fare)
from tb_titanic;

-- 표준편차 함수(null 무시)
select std(fare)
from tb_titanic;

-- pclass가 1등급에 운임료 표준편차와 3등금 운임료의 표준편차를 확인해보세요.
select std(fare)
from tb_titanic
where pclass = 1;

select std(fare)
from tb_titanic
where pclass = 3;

-- 분산
select variance(fare)
from tb_titanic;

-- 거듭제곱
select pow(fare,2)
from tb_titanic;

-- 최대값
select max(fare)
from tb_titanic;

-- 최솟값
select min(fare)
from tb_titanic;

-- 생존자 나이에 대한 평균과 표준편차
select avg(age), std(age)
from tb_titanic
where survived = 1;

-- 사망자 나이에 대한 평균과 표준편차
select avg(age), std(age)
from tb_titanic
where survived = 0;

-- 3등급(pclass)에 대한 생존률
select avg(survived)
from tb_titanic
where pclass= 3; #0.2694

-- 1등급, 2등급, 전체생존률, 여자생존률 각각 조회해서 의견
select avg(survived)
from tb_titanic
where pclass= 1;  # 0.5759

select avg(survived)
from tb_titanic
where pclass= 2; # 0.4224

select avg(survived)
from tb_titanic; # 0.3774

select avg(survived)
from tb_titanic
where gender = "female"; # 0.8762

-- 10세 미만의 생존률 확인해보기
select avg(survived) from tb_titanic where age between 0 and 9;

-- 생존자에 대한 sibsp 와 parch의 평균
select avg(sibsp), avg(parch)
from tb_titanic
where survived = 1;

-- 사망자에 대한 sibsp 와 parch의 평균
select avg(sibsp), avg(parch)
from tb_titanic
where survived = 0;

# select
-- ifnull
select if(gender = 'male', "남자","여자")
from tb_titanic;

-- if
select ifnull(cabin, "알수 없음")
from tb_titanic;

-- Mr. 생존률,  Mrs. 생존률, Miss. 생존률, Ms. 생존률
select
avg(if(name like '%mr.%', survived, null)) mr_rate,-- Mr. 생존률
avg(if(name like '%Mrs.%', survived, null)) mrs_rate,-- Mrs. 생존률
avg(if(name like '%Miss.%', survived, null)) miss_rate,-- Miss. 생존률
avg(if(name like '%Ms.%', survived, null)) ms_rate-- Ms. 생존률
from tb_titanic;

-- one hot encoding
-- embarked : C , Q, S
-- C | Q | S
-- 1 | 0 | 0 -- c 항구일 경우
-- 0 | 1 | 0 -- q 항구일 경우
-- 0 | 0 | 1 -- s 항구일 경우

select 
if(embarked = "c", 1, 0 ) C,
if(embarked = "q", 1, 0 ) Q,
if(embarked = "s", 1, 0 ) S
from tb_titanic;

-- case 문
select
case
	when embarked = 'c' then '프랑스 항구'
    when embarked = 'q' then '아일랜드 항구'
    when embarked = 's' then '영국 항구'
end as em
from tb_titanic;

-- count encoding ( 범주의 빈도수로 인코딩 해주는 기법)


# group by
-- 데이터 그룹화
-- 동일한 값을 가진 행들을 하나의 그룹으로 묶어주는 역할
-- pclass 별 평균 나이를 알고 싶다면??

select avg(age) from tb_titanic where pclass=1;
select avg(age) from tb_titanic where pclass=2;
select avg(age) from tb_titanic where pclass=3;

select pclass, avg(age)
from tb_titanic
group by pclass;

select pclass, embarked, avg(survived) result
from tb_titanic
group by pclass, embarked
order by pclass, embarked

-- q항구에 대해서 pclass 별 여자의 비율과, 나이의 평균 어쩌고저쩌고
select pclass, embarked, avg(survived) result
from tb_titanic
group by pclass, embarked
order by pclass, embarked;

-- Q항구에 대해서 pclass별 여자의 비율과, 나이의 평균 구하기
SELECT pclass, AVG(age)
FROM tb_titanic
WHERE gender = 'female' AND embarked = 'q'
GROUP BY pclass
order by pclass;

# 강사님 답 
select pclass,
avg( if(gender='female',1,0)) female_rate,
avg(age) age_avg
from tb_titanic
where embarked = 'q'
group by pclass;
## q항구의 경우 3등급에 여자 비율이 높은 편이고 평균연령도 낮아서 다른 항구의 3등급에 비해 생존률이 높아진 것으로 추측

-- 남성 승객들 중에 각 항구에 대하여 객실 등급별 생존률 확인하기
select embarked, pclass,
avg( if(gender='male',1,0)) male_rate
from tb_titanic
WHERE gender = 'male'
group by embarked, pclass
order by embarked, pclass;

-- 각 탑승항구에 대하여 생존여부 별 특징을 알아보자
select embarked, survived , count(survived)
from tb_titanic
group by embarked, survived
order by embarked, survived;

-- 가족수(sibsp+parch)에 평균, 운임료의 평균, 티켓번호(ticket)에 고유값의 개수, cabin의 고유값의 개수c;

select avg(sibsp + parch) as avg_family,
       avg(fare) as avg_fare,
       COUNT(distinct ticket) as uni_ticket,
       COUNT(distinct cabin) as uni_cabin
from tb_titanic;

-- 가족이 없는 승객의 비율
select 
	count(sibsp + parch) as total_family_count,
	count(CASE WHEN (sibsp + parch) = 0 THEN 1 END) AS no_family_count -- 가족이 없는 승객 
from tb_titanic;


-- 객실번호(cabin)별 생존률이 0.6 이상의 객실만 보고 싶다면?
select cabin, avg(survived) survived_rate, avg(fare)
from tb_titaic
group by cabin
having survived_rate >= 0.6
order by survived_rate desc;

-- 객실번호(cabin)별 티켓번호의 고유값 개수가 1개인 객실들만 조회해보기
select cabin, count(distinct(ticket)) nunique_ticket
from tb_titanic
where cabin is not null
group by cabin
having nunique_ticket=1;

-- join 배우기
/*
부서 정보 테이블 (dept)
-- deptno: 부서번호
-- dname : 부서이름
-- loc : 지역
*/
select * from dept;
/*
empno : 사원번호
ename : 사원이름
job : 직무
mgr : 상급자의 사원번호
hiredate : 입사일
sal : 급여
comm : 커미션
depno : 부서번호
*/
select * from emp;

# join 이란?
-- 다수의 테이블에 있는 데이터를 특정 조건에 따라 연결하여 하나의 결과로 만들어 조회할 수 있는 키워드
-- 서로 다른 테이블에 분리되어 있는 관련된 데이터를 하나의 결과로 조회
-- 다수의 테이블에서 공통된 데이터를 기준으로 조회하는 명령어
-- 컬럼을 기준으로 데이터가 동일할 경우 매칭을 시켜 결합

## inner join
-- 테이블 사이에서 on 조건에 맞는 데이터만 join
select *
from dept
inner join emp
on dept.deptno = emp.deptno;

-- table 에 별칭 줄 수 있다.
select ename, dname, mgr
from emp e
inner join dept d
on e.deptno = d.deptno;

-- scott 사원에 이름과 부서이름, 지역 조회하기
select ename, dname, loc
from emp
inner join dept
on emp.deptno = dept.deptno and emp.ename = 'scott';

-- 뉴욕지역에 근무하는 사원이름과 급여, 지역 등을 조회하기
select ename, sal, loc
from emp
inner join dept
on emp.deptno = dept.deptno and dept.loc = 'new york';

-- research 부서에서 근무하는 사원의 이름과, 급여, 입사일 조회
select ename, sal, hiredate
from emp
inner join dept
on emp.deptno = dept.deptno and dept.dname = 'research';

-- 직무가 manager 인 사원의 이름, 부서명, 급여, 커미션 조회
select ename, dname,sal,comm
from emp
inner join dept
on emp.deptno = dept.deptno and emp.job = 'manager';

# self join 
-- 동일한 테이블끼리 조인

-- 각 사원의 상사 이름을 알고 싶다면?
select e.ename '사원이름' , m.ename '상사이름'
from emp e
inner join emp m
on e.mgr = m.empno;

-- 상사 이름이 king 인 사원의 이름과 상사이름을 조회하고 싶다면?
select e.ename AS '사원이름', m.ename AS '상사이름'
from emp e
inner join emp m
on e.mgr = m.empno and m.ename = 'king';

-- allen 의 동료 이름(같은 부서에서 일하는 동료) 조회
select e.ename as '동료이름'
from emp e
inner join emp m
on e.deptno = m.deptno 
and m.ename = 'allen'
and e.ename != 'allen';


# left join
-- 왼쪽 테이블을 기준으로 join
-- 왼쪽 테이블에 컬럼값과 on 조건에 맞는 샘플이 없을 경우 null 값이 들어간다.
-- join 후에 조회 결과의 행 개수가 줄어들지 않고, 늘어날 수는 있다.

-- 상사이름을 조회할 때 king 같이 조회하고 싶다면?
select e.ename '사원이름', m.ename '상사이름'
from emp e
left join emp m
on e.mgr = m.empno;

-- 모든 부서의 정보와 함께 부서에 속한 사원들의 정보를 조회하기
select * 
from dept
left join emp
on dept.deptno = emp.deptno;

-- 모든 부서의 정보와 함께 급여가 3000 이상인 직원들의 연봉과 이름을 조회하기
select d.*
from dept d
left join emp e
on e.sal >= 3000 and d.deptno = e.deptno;

-- 모든 부서의 정보와 함께 커미션이 있는 직원들의 이름과 커미션을 조회하기
select * 
from dept d
left join emp e
on e.comm > 0 and d.deptno = e.deptno;

-- 모든 부서의 부서별 연봉에 대한 총합과 평균, 표준편차, 사원수를 조회
select
	sum(e.sal) sum_sal,
    avg(e.sal) sum_sal,
    std(e.sal) sum_sal,
    count(d.deptno) as cnt
from dept d
left join emp e
on d.deptno = e.deptno
group by d.deptno;

-- 각 상사들의 부하직원수와 부하직원들의 평균 연봉
-- 셀프 조인을 한 다음, 관리자의 사원번호를 기준으로 그룹화하고 
select
	m.ename as '상사이름',
    avg(e.sal) as '부하직원 평균연봉',
    count(e.empno) as '부하직원 수'
from emp m
inner join emp e
on m.empno = e.mgr
group by m.ename;

# sub-query
-- 쿼리 안에 쿼리를 넣을 수 있음
-- 일반적으로 where, from, join 절에 사용된다.

-- select *, (select dname from dept where deptno=e.deptno) 셀렉트절엔 서브쿼리 안쓴다
-- from emp e;

-- where 절
-- scott 사원관 같은 부서에 있는 직언 이름을 검색하기
select ename
from emp
where deptno = (select deptno from emp where ename = 'scott');

-- smith와 동일한 직무를 가진 직원들의 정보를 검색하기
select *
from emp
where job = (select job from emp where ename='smith' ) and ename != 'smith';



-- smith의 급여 이상을 받는 직원들의 사원명과 급여를 검색해주세요
select ename, sal
from emp
where sal >= (select sal from emp where ename='smith') and ename != 'smith';

-- from 절에서 서브쿼리 작성
-- 사원 테이블에서 급여가 2000이 넘는 사람들의 이름과 부서번호, 부서이름, 지역 조회
select e.ename, d.deptno, d.dname, d.loc
from (select * from emp where sal > 2000) e
inner join dept d
on e.deptno = d.deptno;

-- join 절에서 서브쿼리 작성
-- 모든 부서의 부서이름과 지역, 부서내의 평균 급여를 조회하기
select d.dname, d.loc, e.avg_sal
from dept d
left join (select deptno, avg(sal) avg_sal from emp group by deptno) e
on d.deptno = e.deptno;

-- 서브쿼리를 활용해서 테이블 복제하기
create table emp01 as select * from emp;
select * from emp01;

-- 데이터를 제외하고 테이블 복제하기
create table emp02 as select * from emp where 1= 0;
select * from emp02;

-- 서브쿼리를 활용해서 insert 해보기
insert into emp02 select * from emp;
select * from emp02;

