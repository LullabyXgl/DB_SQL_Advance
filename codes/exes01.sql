-- 有一个员工employees表如下
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
| 10001  | 1953-09-02 | Georgi     | Facello   |   M    | 1986-06-26 |
| 10002  | 1964-06-02 | Bezalel    | Simmel    |   F    | 1985-11-21 |
| 10003  | 1959-12-03 | Parto      | Bamford   |   M    | 1986-08-28 |
| 10004  | 1954-05-01 | Christian  | Koblick   |   M    | 1986-12-01 |
+--------+------------+------------+-----------+--------+------------+
-- 1.查找employees里最晚入职员工的所有信息
-- 注意:date类型的数据可以按照大小排序,越大表示日期越晚
select * from employees where hire_date=(select max(hire_date) from employees); -- 最稳的解决方式
select * from employees order by hire_date desc limit 1; -- 最晚入职的员工不一定只有一个,所以这种方式不太可取
-- 2.查找入职员工时间排名倒数第三的员工所有信息
select * from employees where hire_date=(select distinct(hire_date) from employees order by hire_date desc limit 2, 1);
select * from employees where hire_date=(select distinct(hire_date) from employees order by hire_date desc limit 1 offset 2);

-- 3.获取每个部门中当前员工薪水最高的相关信息
-- 员工表dept_emp
+--------+---------+------------+------------+
| emp_no | dept_no | from_date  | to_date    |
+--------+---------+------------+------------+
|  10001 | d001    | 1986-06-26 | 9999-01-01 |
|  10002 | d001    | 1996-08-03 | 9999-01-01 |
|  10003 | d002    | 1996-08-03 | 9999-01-01 |
+--------+---------+------------+------------+
-- 薪水表salaries
+--------+--------+------------+------------+
| emp_no | salary | from_date  | to_date    |
+--------+--------+------------+------------+
|  10001 |  88958 | 2002-06-22 | 9999-01-01 |
|  10002 |  72527 | 2001-08-02 | 9999-01-01 |
|  10003 |  92527 | 2001-08-02 | 9999-01-01 |
+--------+--------+------------+------------+
-- 获取每个部门中当前员工薪水最高的相关信息，给出dept_no, emp_no以及其对应的salary，按照部门编号dept_no升序排列
/*
通过查询构建两张虚拟表
一张表记录最高薪水（部门编号,当前最高薪水），一张表记录所有员工的部门及薪水信息（部门编号,员工编号,当前薪水），用部门编号和薪水相等取到最高薪水的员工ID
 */
-- 实现方式1
select sa.dept_no, ep.emp_no, sa.maxSalary from
        (select emp.emp_no, emp.dept_no, sal.salary from dept_emp emp inner join salaries sal on emp.emp_no=sal.emp_no) ep inner join
        (select dept_no, max(salary) maxSalary from (select emp.emp_no emp_no, emp.dept_no dept_no, sal.salary salary from dept_emp emp inner join salaries sal on emp.emp_no=sal.emp_no) un group by dept_no) sa
        on ep.salary=sa.maxSalary and ep.dept_no=sa.dept_no order by dept_no;
-- 实现方式2
select emp.dept_no, sa.emp_no, sa.salary maxSalary from dept_emp emp inner join salaries sa on emp.emp_no=sa.emp_no
where sa.salary in (select max(s.salary) from dept_emp e inner join salaries s on e.emp_no=s.emp_no where e.dept_no=emp.dept_no) order by dept_no;

-- 4.获取当前薪水第二多的员工的emp_no以及其对应的薪水salary
-- 员工表employees
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
|  10001 | 1953-09-02 | Georgi     | Facello   | M      | 1986-06-26 |
|  10002 | 1964-06-02 | Bezalel    | Simmel    | F      | 1985-11-21 |
|  10003 | 1959-12-03 | Parto      | Bamford   | M      | 1986-08-28 |
|  10004 | 1954-05-01 | Chirstian  | Koblick   | M      | 1986-12-01 |
+--------+------------+------------+-----------+--------+------------+
-- 薪水表salaries
+--------+--------+------------+------------+
| emp_no | salary | from_date  | to_date    |
+--------+--------+------------+------------+
|  10001 |  88958 | 2002-06-22 | 9999-01-01 |
|  10002 |  72527 | 2001-08-02 | 9999-01-01 |
|  10003 |  43311 | 2001-12-01 | 9999-01-01 |
|  10004 |  74057 | 2001-11-27 | 9999-01-01 |
+--------+--------+------------+------------+
-- 实现方法1:order by和limit配合使用
select emp.emp_no, sal.salary, emp.last_name, emp.first_name from employees emp inner join salaries sal on emp.emp_no=sal.emp_no
where sal.salary=(select distinct(salary) from salaries order by salary desc limit 1, 1);
-- 实现方式2:对薪资取两次max运算(第二高的薪资是低于最高薪资的最高薪资)得到第二高的薪资
select emp.emp_no, sal.salary, emp.last_name, emp.first_name from employees emp inner join salaries sal on emp.emp_no=sal.emp_no
where sal.salary=(select max(salary) from salaries where salary < (select max(salary) from salaries));
-- 实现方式三:salaries自连接查询,连接条件为s1.salary<=s2.salary,自连接后最高的s1.salary对应s2中count(distinct(s2.salary))的值为1,第二高的s1.salary对应s2中count(distinct(s2.salary))的值为2....
select emp.emp_no, sal.salary, emp.last_name, emp.first_name from employees emp inner join salaries sal on emp.emp_no=sal.emp_no
where sal.salary=(select s1.salary from salaries s1 inner join salaries s2 on s1.salary <= s2.salary group by s1.salary having count(distinct(s2.salary))=2);