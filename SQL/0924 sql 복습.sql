use mydata;
select database();

# DALLAS에 근무하는 사원들의 이름, 부서번호를 사원이름으로 오름차순 정렬해서 조회하시오.
# where 절에 서브쿼리를 사용할 것

-- 서브쿼리 미사용
select ename, emp.deptno,loc
from emp
inner join dept on dept.deptno = emp.deptno
where loc = 'DALLAS'
order by ename ;

-- 서브쿼리 사용
select ename, emp.deptno,loc
from emp
inner join dept on dept.deptno = emp.deptno
where dept.deptno in (
    select deptno
    from dept
    where loc = 'DALLAS'
)
order by ename;


# 직무(job)가 Manager인 사람들이 속한 부서의 부서번호와 부서명 , 지역을 조회하시오.
-- manager 사람들이 다수이기 때문에 where절에 in 을 활용!
-- where 절에 서브쿼리를 사용할 것
select emp.deptno, dname, loc
from emp
inner join dept on dept.deptno = emp.deptno
where job = 'Manager';

# emp 테이블에서 커미션이 있는 사람들의 이름과 부서번호, 부서이름, 지역 조회하시오.
-- from 절에 서브쿼리 사용하고 , inner join 활용
select ename, emp.deptno, dname, loc
from emp
inner join dept on dept.deptno = emp.deptno
where comm != 0 ;

# 항구별 평균 운임료를 구하여 항구에 매칭 시켜 조회해 주는 예시
select a.*, avg_fare
from tb_titanic a
left join (
    select embarked, avg(fare) as avg_fare
    from tb_titanic
    group by embarked
) b
on a.embarked = b.embarked;


# 객실번호별 빈도수를 구하여 객실번호에 매칭 시켜 조회해 주세요.
select a.*, avg_fare
from tb_titanic a
left join (
    select embarked, avg(fare) as avg_fare
    from tb_titanic
    group by embarked
) b
on a.embarked = b.embarked;

# 각 항구에 대하여 객실등급별 빈도수를 구하여 각 항구의 객실등급에  매칭 시켜 조회해 주세요.
SELECT a.*, b.count_passengers
from tb_titanic a
inner join(
	select embarked,pclass,COUNT(passengerid) as count_passengers
    from tb_titanic
    group by embarked, pclass) b
on a.embarked = b.embarked and a.pclass = b.pclass;

# 각 항구에 대하여 객실등급별 나이와 운임료의 평균과 표준편차, 그리고 여성의 비율을  각 항구의 객실등급에 매칭 시켜 조회해 주세요.
select a.*, b.avg_age, b.av_fare, b.std_fare, b.female_rate -- 나이, 운임료평균 , 운임료 표준편차, 여성의 비율
from tb_titanic a
inner join(
	select embarked,pclass
		,avg(age) AS avg_age
        ,avg(fare) as av_fare
        , std(fare) as std_fare
        , avg( if(gender='female',1,0)) female_rate
    from tb_titanic
    group by embarked, pclass) b
on a.embarked = b.embarked and a.pclass = b.pclass;