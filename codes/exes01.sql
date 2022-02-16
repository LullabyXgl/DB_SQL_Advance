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