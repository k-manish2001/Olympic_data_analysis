SELECT *
FROM [Olympic games ]..athelete_Events

SELECT *
FROM [Olympic games ]..noc_region

-- Query-1 -- Identify the sport which was played in all summer olympics

--counting total no of distinct games played in summer olympics-- (29)
SELECT COUNT(DISTINCT Games) AS Total_summer_games
FROM [Olympic games ]..athelete_Events
WHERE Season = 'summer'


--Sports which was played in all 29 summer olympics
WITH Temp AS
(
SELECT sport, COUNT(DISTINCT Games) AS Played_in
FROM [Olympic games ]..athelete_Events
WHERE Season = 'summer'
GROUP BY sport
)
SELECT *
FROM Temp
WHERE Played_in = 29
ORDER BY Sport

-- Query-2 -- SQL query to fetch the top 5 athletes who have won the most gold medals.

WITH T1 AS
(
SELECT Name, COUNT(1) AS Total_gold_medals
FROM [Olympic games ]..athelete_Events
WHERE Medal = 'Gold' 
GROUP BY NAME
--ORDER BY COUNT(1) DESC
),
T2 AS(
SELECT *,  DENSE_RANK() OVER (ORDER BY Total_gold_medals)AS rnk
FROM T1
)

SELECT *
FROM T2
WHERE rnk >=7
ORDER BY 2 DESC


-- Query-3 -- List down total gold, silver and broze medals won by each country.
WITH T1 AS
(
SELECT region, COUNT(1) AS total_Gold_medals
FROM [Olympic games ]..athelete_Events Ae
JOIN [Olympic games ]..noc_region Nr ON Ae.NOC = Nr.NOC 
WHERE Medal = 'Gold'
GROUP BY region
--ORDER BY 2 DESC
),
T2 AS
(
SELECT region, COUNT(1) AS total_Bronze_medals
FROM [Olympic games ]..athelete_Events Ae
JOIN [Olympic games ]..noc_region Nr ON Ae.NOC = Nr.NOC 
WHERE Medal = 'Bronze'
GROUP BY region
--ORDER BY 2 DESC
),
T3 AS
(
SELECT region, COUNT(1) AS total_Sliver_medals
FROM [Olympic games ]..athelete_Events Ae
JOIN [Olympic games ]..noc_region Nr ON Ae.NOC = Nr.NOC 
WHERE Medal = 'Silver'
GROUP BY region
--ORDER BY 2 DESC
)

SELECT T1.region AS Country, T1.total_Gold_medals, T3.total_Sliver_medals, T2.total_Bronze_medals 
FROM T1
JOIN T2 ON T1.region = T2.region
JOIN T3 ON T2.region = T3.region
ORDER BY 2 DESC, 3 DESC, 4 DESC

----------------------------Query 3 using Pivot table-----------------
--Step-1: describing data to be pivot

SELECT region, Medal, COUNT(1)AS total_medals
FROM [Olympic games ]..athelete_Events Ae
JOIN [Olympic games ]..noc_region Nr ON Ae.NOC = Nr.NOC
WHERE medal <> 'NA'
GROUP BY region, Medal
ORDER BY region, Medal

--Creating common table expression CTE--
SELECT *
FROM
	(SELECT Medal, Nr.region AS country -- COUNT(1) AS total_medals
	FROM [Olympic games ]..athelete_Events Ae
	JOIN [Olympic games ]..noc_region Nr ON Ae.NOC = Nr.NOC
	WHERE medal <> 'NA')
	T1
-- applying Pivot window function--
PIVOT(  COUNT(Medal)
		FOR Medal IN (
		[Gold],
		[Silver],
		[Bronze]) 
		)
AS  Pivot_table
ORDER BY Gold DESC, Silver DESC, Bronze DESC

-- Query-4 -- Write a SQL query to find the total no of Olympic Games held as per the dataset.
SELECT COUNT(DISTINCT Games) AS Total_olympic_games
FROM [Olympic games ]..athelete_Events

-- Query-5 -- Write a SQL query to list down all the Olympic Games held so far.
SELECT DISTINCT Year, Season, City
FROM [Olympic games ]..athelete_Events
ORDER BY Year

-- Query-6 -- SQL query to fetch total no of countries participated in each olympic games.
SELECT DISTINCT Games, COUNT(DISTINCT region) AS total_countries
FROM [Olympic games ]..athelete_Events Ae
JOIN [Olympic games ]..noc_region Nr ON Ae.NOC = Nr.noc
GROUP BY Games
ORDER BY Games

-- Query-7 -- Which year saw the highest and lowest no of countries participating in olympics?
WITH T1
AS
(
	SELECT DISTINCT Games, COUNT(DISTINCT region) AS total_countries
	FROM [Olympic games ]..athelete_Events Ae
	JOIN [Olympic games ]..noc_region Nr ON Ae.NOC = Nr.noc
	GROUP BY Games
	)

SELECT DISTINCT CONCAT(FIRST_VALUE (Games) OVER (ORDER BY Games), '-', FIRST_VALUE(total_countries) OVER (ORDER BY Games)) AS Lowest_countries,
CONCAT(FIRST_VALUE (Games) OVER (ORDER BY total_countries DESC), '-', FIRST_VALUE(total_countries) OVER (ORDER BY total_countries DESC)) AS Highest_countries
FROM T1

-- Query-8 -- Which nation has participated in all of the olympic games?
WITH T1
AS
(
	SELECT DISTINCT region, COUNT(DISTINCT Games) AS total_games_played
	FROM [Olympic games ]..athelete_Events Ae
	JOIN [Olympic games ]..noc_region Nr ON Ae.NOC = Nr.noc
	GROUP BY region
	)

SELECT *
FROM T1
WHERE total_games_played = 51


-- Query-9 -- Using SQL query, Identify the sport which were just played once in all of olympics.
WITH T1
AS(
	SELECT Sport, COUNT(DISTINCT Games) AS Times_played
	FROM [Olympic games ]..athelete_Events
	GROUP BY Sport
	--ORDER BY Sport
	),
T2 
AS(
	SELECT DiSTINCT Games, Sport
	FROM [Olympic games ]..athelete_Events
	GROUP BY Games, Sport
	--ORDER BY Games
	)
SELECT T1.*, T2.Games
FROM T1
JOIN T2 ON T1.sport = T2.sport
WHERE T1.Times_played = 1
ORDER  BY T1.Sport

-- Query-10 -- Fetch the total no of sports played in each olympic games.
SELECT DISTINCT Games, COUNT(DISTINCT Sport) AS no_of_games
FROM [Olympic games ]..athelete_Events
GROUP BY Games
ORDER BY 2 DESC

-- Query-11 -- SQL Query to fetch the details of the oldest athletes to win a gold medal at the olympics.
SELECT *
FROM [Olympic games ]..athelete_Events
WHERE age = 97
ORDER BY 4 DESC

-- Query-12 -- Calculate number of males and females participated

WITH T1
AS
	(
	SELECT COUNT(DISTINCT ID) AS Number_male
	FROM [Olympic games ]..athelete_Events
	WHERE Sex = 'M'
	)
, T2
AS
	(
	SELECT COUNT(DISTINCT ID) AS Number_female
	FROM [Olympic games ]..athelete_Events
	WHERE Sex = 'F'
	)

SELECT Number_male, Number_female
FROM T1, T2;









	



