/*
Lab 1 report <Jakob Nilsson, Axel Nilsson, Erik Snällfot and jakni322, axeni664, erisn497>
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS custom_table CASCADE;


/* Have the source scripts in the file so it is easy to recreate!*/

SOURCE company_schema.sql;
SOURCE company_data.sql;

/*
Question 1: Print a message that says "hello world"
*/

SELECT 'hello world!' AS 'message';

/* Show the output for every question.
+--------------+
| message      |
+--------------+
| hello world! |
+--------------+
1 row in set (0.00 sec)


 
Q1: List all employees*/
SELECT * FROM jbemployee;
/*
+------+--------------------+--------+---------+-----------+-----------+
| id   | name               | salary | manager | birthyear | startyear |
+------+--------------------+--------+---------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |
+------+--------------------+--------+---------+-----------+-----------+
25 rows in set (0.00 sec)

*/


/* Q2: Sort dept names in alphabetical order*/
SELECT DISTINCT name FROM jbdept
ORDER BY name ASC;

/*
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
+------------------+
16 rows in set (0.00 sec)
*/


/*Q3: What parts are not in store?*/

SELECT name FROM jbparts
WHERE qoh = 0;

/*
+-------------------+
| name              |
+-------------------+
| card reader       |
| card punch        |
| paper tape reader |
| paper tape punch  |
+-------------------+
4 rows in set (0.00 sec)
*/

/*Q4: Which employees have a salary between 9000 and 10000?*/

SELECT name FROM jbemployee
WHERE salary >= 9000 AND salary <= 10000;

/*
+----------------+
| name           |
+----------------+
| Edwards, Peter |
| Smythe, Carol  |
| Williams, Judy |
| Thomas, Tom    |
+----------------+
4 rows in set (0.00 sec)
*/

/* Q5: What was the age of each employee when they started working (startyear)?*/

SELECT name, (startyear-birthyear) FROM jbemployee;

/*
+--------------------+-----------------------+
| name               | (startyear-birthyear) |
+--------------------+-----------------------+
| Ross, Stanley      |                    18 |
| Ross, Stuart       |                     1 |
| Edwards, Peter     |                    30 |
| Thompson, Bob      |                    40 |
| Smythe, Carol      |                    38 |
| Hayes, Evelyn      |                    32 |
| Evans, Michael     |                    22 |
| Raveen, Lemont     |                    24 |
| James, Mary        |                    49 |
| Williams, Judy     |                    34 |
| Thomas, Tom        |                    21 |
| Jones, Tim         |                    20 |
| Bullock, J.D.      |                     0 |
| Collins, Joanne    |                    21 |
| Brunet, Paul C.    |                    21 |
| Schmidt, Herman    |                    20 |
| Iwano, Masahiro    |                    26 |
| Smith, Paul        |                    21 |
| Onstad, Richard    |                    19 |
| Zugnoni, Arthur A. |                    21 |
| Choy, Wanda        |                    23 |
| Wallace, Maggie J. |                    19 |
| Bailey, Chas M.    |                    19 |
| Bono, Sonny        |                    24 |
| Schwarz, Jason B.  |                    15 |
+--------------------+-----------------------+
25 rows in set (0.00 sec)
*/

/* Q6: Which employees have a last name endingwith “son”? */

SELECT name FROM jbemployee
WHERE name LIKE '%son,%';

/*
+---------------+
| name          |
+---------------+
| Thompson, Bob |
+---------------+
1 row in set (0.00 sec)
*/

/* Q7: Which items (note items, not parts) have been delivered by a supplier called Fisher-Price? Formulate this query using a subquery in the where-clause.*/



SELECT name FROM jbitem
WHERE supplier = (SELECT id FROM jbsupplier
WHERE name LIKE '%Fisher-Price%');

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0.00 sec)
*/

/* Q8: Formulate the same query as above, but without a subquery */

SELECT jbitem.name FROM jbitem, jbsupplier
WHERE supplier = jbsupplier.id AND jbsupplier.name LIKE '%Fisher-Price%';

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0.00 sec)
*/

/* Q9: Show all cities that have suppliers located in them. Formulate this query using a subquery in the where-clause.*/

SELECT jbcity.name FROM jbcity
WHERE id IN (SELECT city FROM jbsupplier);

/*
+----------------+
| name           |
+----------------+
| Amherst        |
| Boston         |
| New York       |
| White Plains   |
| Hickville      |
| Atlanta        |
| Madison        |
| Paxton         |
| Dallas         |
| Denver         |
| Salt Lake City |
| Los Angeles    |
| San Diego      |
| San Francisco  |
| Seattle        |
+----------------+
15 rows in set (0.00 sec)
*/

/*Q10:What is the name and color of the parts that are heavier than a card reader?
 Formulate this query using a subquery in the where-clause. (The SQL query must not contain the weightas a constant.) */
 
 /*SELECT name, color FROM jbparts
 WHERE weight > (SELECT weight FROM jbparts WHERE name LIKE '%card reader%');
 
 /*
 +--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.01 sec)
*/

/*Q11: Formulate the same query as above, but without a subquery. (The query must not contain the weight as a constant.)*/

SELECT A.name AS jbparts, A.color AS jbparts FROM jbparts A, jbparts B
WHERE B.name LIKE '%card reader%' AND A.weight > B.weight;

/*
+--------------+---------+
| jbparts      | jbparts |
+--------------+---------+
| disk drive   | black   |
| tape drive   | black   |
| line printer | yellow  |
| card punch   | gray    |
+--------------+---------+
4 rows in set (0.00 sec)
*/

/*Q12: What is the average weight of black parts?*/

SELECT AVG(weight) FROM jbparts
WHERE color LIKE '%black';

/*
+-------------+
| AVG(weight) |
+-------------+
|    347.2500 |
+-------------+
1 row in set (0.00 sec)
*/

/*Q13: What is the total weight of all parts that each supplier in Massachusetts (“Mass”) has delivered?
 Retrieve the name and the total weight for each of these suppliers.
 Do not forget to take the quantity of delivered parts into account.Note that one row should be returned for each supplier.*/ 
 
 
 
 SELECT jbsupplier.name, SUM(jbsupply.quan*jbparts.weight) FROM jbparts, jbsupply, jbsupplier, jbcity
 WHERE jbparts.id = jbsupply.part AND jbsupply.supplier = jbsupplier.id AND jbsupplier.city = jbcity.id AND jbcity.state LIKE '%Mass%'
 GROUP BY jbsupplier.name;
 
 
 /*
 +--------------+-----------------------------------+
| name         | SUM(jbsupply.quan*jbparts.weight) |
+--------------+-----------------------------------+
| DEC          |                              3120 |
| Fisher-Price |                           1135000 |
+--------------+-----------------------------------+
2 rows in set (0.00 sec)
*/

/*Q14: Create a new relation (a table),with the same attributes as the table 
items using the CREATE TABLE syntax where you define every attribute explicitly (i.e. not as a copy of another table).
Then fill the table with all items that cost less than the average price for items.
Remember to define primary and foreign keys in your table!*/


CREATE TABLE jbitemsless (id int, name varchar(20), dept int, price int, qoh int, supplier int,
constraint pk_jbitemsless
	primary key (id),
    
constraint fk_jbitem
	FOREIGN KEY (id) references jbitem(id)

);

SELECT AVG(price) FROM jbitem;
INSERT INTO jbitemsless (SELECT * FROM jbitem WHERE price < (SELECT AVG(price) FROM jbitem));

SELECT * FROM jbitemsless;

/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.00 sec)
*/

/*Q15: Create a view that contains the items that cost less than the average price for items. */




CREATE VIEW jbitemsless_view AS 
SELECT name AS A, price AS B
FROM jbitemsless
GROUP BY name;

SELECT A, B FROM jbitemsless_view;

/*
+-----------------+------+
| A               | B    |
+-----------------+------+
| 1 lb Box        |  215 |
| 2 lb Box, Mix   |  450 |
| ABC Blocks      |  198 |
| Bellbottoms     |  450 |
| Clock Book      |  198 |
| Earrings        | 1000 |
| Jean            |  825 |
| Maze            |  325 |
| Shirt           |  650 |
| Squeeze Ball    |  250 |
| The 'Feel' Book |  225 |
| Towels, Bath    |  250 |
| Twin Sheet      |  800 |
| Wash Cloth      |   75 |
+-----------------+------+
14 rows in set (0.00 sec)
*/

/*Q16: What is the difference between a table and a view?One is static and the other is dynamic.
 Which is which and what do we mean by static respectively dynamic?*/
 
 /*A table contains data, a view is just a select statement which displays the data from the concerned table.
 A view provides data security, given viewers can't manipulate data with just the view. View is static, given that it can't be changed,
 while a table is dynamic, given that we can add and manipulate data in the table.*/
 
 /*Q17: Create a view that calculates the total cost of each debit, by considering price and quantity of each bought item.
 (To be used for charging customer accounts). The view should contain the sale identifier (debit) and total cost. 
 Use only the implicit join notation, i.e. only use a where clause but not the keywords inner join, right join or left join */
 
 DROP VIEW customercharge_view;
 
 CREATE VIEW customercharge_view AS
 SELECT SUM(jbsale.quantity*jbitem.price) AS cost, jbdebit.id AS debit_id FROM jbdebit, jbsale, jbitem
 WHERE jbdebit.id = jbsale.debit AND jbsale.item = jbitem.id
 GROUP BY jbdebit.id;
 
 SELECT debit_id, cost FROM customercharge_view;
 
 /*
 +----------+-------+
| debit_id | cost  |
+----------+-------+
|   100581 |  2050 |
|   100582 |  1000 |
|   100586 | 13446 |
|   100592 |   650 |
|   100593 |   430 |
|   100594 |  3295 |
+----------+-------+
6 rows in set (0.00 sec)
*/

/*Q18: Do the same as in (17), using only the explicit join notation,
 i.e. using only left, right or inner joins but no join condition in a where clause.
 Motivate why you use the join you do (left, right or inner), and why this is the correct one (unlike the others).*/
 DROP VIEW customercharge_view_join;

 CREATE VIEW customercharge_view_join AS
 SELECT SUM(jbsale.quantity*jbitem.price) AS cost, jbdebit.id AS debit_id FROM
 jbdebit INNER JOIN  jbsale INNER JOIN jbitem ON jbdebit.id = jbsale.debit AND jbsale.item = jbitem.id
 
 GROUP BY jbdebit.id;
 
 
 SELECT debit_id, cost FROM customercharge_view_join; 
 
 /*
 +----------+-------+
| debit_id | cost  |
+----------+-------+
|   100581 |  2050 |
|   100582 |  1000 |
|   100586 | 13446 |
|   100592 |   650 |
|   100593 |   430 |
|   100594 |  3295 |
+----------+-------+
6 rows in set (0.00 sec)


We use inner join, given that left and right join also joins tuples that doesn't have a match in the joining table.
*/

/*Q19: Oh no! An earthquake! 
a)Remove all suppliers in Los Angeles from the table jbsupplier. 
This will not work right away (you will receive error code 23000)
which you will have to solve by deleting some other related tuples.
However, do not delete more tuples from other tables than necessary and do not change the structure of the tables,
 i.e. do not remove foreign keys. Also, remember that you are only allowed to use “Los Angeles” as a constant in your queries,
not “199” or “900”.
b)Explain what you did and why.*/
DELETE FROM jbsale WHERE item IN (SELECT id FROM jbitem WHERE supplier = (SELECT id FROM jbsupplier WHERE city = (SELECT id FROM jbcity WHERE name LIKE '%Los Angeles%')));

DELETE FROM jbitemsless WHERE supplier = (SELECT id FROM jbsupplier 
WHERE city = (SELECT id FROM jbcity 
WHERE name LIKE '%Los Angeles%'));


DELETE FROM jbitem WHERE supplier = (SELECT id FROM jbsupplier WHERE city = (SELECT id FROM jbcity WHERE name LIKE '%Los Angeles%'));
DELETE FROM jbsupplier  WHERE city = (SELECT id FROM jbcity WHERE name LIKE '%Los Angeles%');

SELECT * FROM jbsupplier;

/*+-----+--------------+------+
| id  | name         | city |
+-----+--------------+------+
|   5 | Amdahl       |  921 |
|  15 | White Stag   |  106 |
|  20 | Wormley      |  118 |
|  33 | Levi-Strauss |  941 |
|  42 | Whitman's    |  802 |
|  62 | Data General |  303 |
|  67 | Edger        |  841 |
|  89 | Fisher-Price |   21 |
| 122 | White Paper  |  981 |
| 125 | Playskool    |  752 |
| 213 | Cannon       |  303 |
| 241 | IBM          |  100 |
| 440 | Spooley      |  609 |
| 475 | DEC          |   10 |
| 999 | A E Neumann  |  537 |
+-----+--------------+------+
15 rows in set (0.00 sec)

We deleted all the tuples connected with a foreign key constraint to the suppliers in los angeles, before removing the actual suppliers.
This was done because we cannot remove a tuple that has foreign key constraints referencing still existing tuples in other relations.
*/


/*Q20: Help the guy*/



CREATE VIEW jbsale_supply(supplier, item, quantity) AS
SELECT jbsupplier.name, jbitem.name, jbsale.quantity
FROM jbitem LEFT JOIN jbsupplier ON jbitem.supplier = jbsupplier.id 
LEFT JOIN jbsale ON jbitem.id = jbsale.item;

SELECT supplier, SUM(quantity) AS sum FROM jbsale_supply
GROUP BY supplier;
DROP VIEW jbsale_supply;


/*
+--------------+------+
| supplier     | sum  |
+--------------+------+
| Cannon       | NULL |
| Fisher-Price | NULL |
| Levi-Strauss | NULL |
| Playskool    | NULL |
| White Stag   | NULL |
| Whitman's    | NULL |
+--------------+------+
6 rows in set (0.01 sec)
*/