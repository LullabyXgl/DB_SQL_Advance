## 1. UNION和UNION ALL
    合并两个或多个查询的结果集，要求被合并的多个查询的结果集的字段个数和类型相同
    UNION：去除多个结果集中重复的记录
    UNION ALL：保留多个结果集查询的所有记录，不去除重复记录

## 2. MySQL中的ALL和ANY
ANY：可以与=、>、>=等结合起来使用，表示等于、大于、大于等于其中任意一个数据
any关键字可以理解为"对于子查询返回的列中的任一数一比较，如果结果为true，则返回true"
~~~sql
-- 查询工资比20号部门任意一个员工高的员工信息
select * from emp where sal > ANY(select sal from emp where depno=20);
-- 这个sql等价于如下
select * from emp where sal > sal1 or sal > sal2 or sal > sal3...;
select * from emp where sal > (select min(sal) from emp where depno=20);
~~~
ALL：可以与=、>、>=等结合起来使用，表示等于、大于、大于等于其中所有数据
all的意思是"对于子查询返回的列中的所有数据比较，如果比较结果都为true，则返回true"
~~~sql
-- 查询工资比20号部门所有员工高的员工信息
select * from emp where sal > ALL(select sal from emp where depno=20);
-- 这个sql等价于如下
select * from emp where sal > sal1 and sal > sal2 and sal > sal3...;
select * from emp where sal > (select max(sal) from emp where depno=20);
~~~

## 3. INSERT INTO ... SELECT和SELECT INTO
~~~sql
-- INSERT INTO SELECT
/*
	语法格式为 insert into Table2(field1,field2,...) select value1,value2,... from Table1;
  或者为 insert into Table2 select * from Table1;
  注意事项:
  		1.要求表Table2必须存在,且字段field1,field2,...等也必须存在
      2.如果Table2中有主键索引,则字段field1,field2,...中必须包括主键的存在
      3.不要和插入insert into table_name values...搞混了
      4.因为Table2已经存在,则select后面除了数据来源表Table1中的字段外也可以插入常量
*/
-- SELECT INTO FROM
/*
	语法格式为 SELECT value1,value2 into Table2 from Table1
  注意事项:
  	  1.要求目标表Table2不存在,会根据select查询得到的结果来创建新的表
      2.MySQL并不支持SELECT INTO语句,但是可以使用create table|view Table2 as select * from Table1;的方式达到同样的效果
      3.MySQL中支持SELECT value1,value2 into @x,@y from Table1的方式将字段的值存储到变量@x和@y中
*/
~~~

## 4. limit和offset用法
~~~sql
-- mysql中一般使用limit实现分页
-- 当limit后面跟一个参数的时候,该参数表示要取的数据的数量,如下表示从test表中只取3条数据
select * from test limit 3;
-- 如下两个sql均表示取test表中的第2、3、4条数据
-- 当limit后面跟两个参数的时候,第一个数表示要跳过的数量后一位表示要取的数量
select* from test limit 1,3;
--当limit和offset组合使用的时候,limit后面只能有一个参数,表示要取的的数量,offset表示要跳过的数量
select * from test limit 3 offset 1;
~~~

## 5. 按位与运算&判断奇数偶数
~~~sql
/*
    用 1 & x 后面跟的x是奇数的时候，所得到的结果就是1；而跟的x是偶数的时候，运算结果就是 0
    因此要判断一个数（这里指的是整数）是奇偶数的时候，直接用某个数与1进行按位与，就可以得到结果
    再SQL语句中使用" & 1"来判断一个数是否为奇数或偶数效率大大提高
    而sql语句中where后面的值0表示false,非0表示true
*/
select * from test where no & 1; -- 这种方式可以直接判断字段no为奇数的情况
~~~
