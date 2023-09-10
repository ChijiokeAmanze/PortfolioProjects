
select * from countries;
select * from currencies;
select * from economies;
select * from languages;
select * from populations;




-- Table showing the Majority languages of countries 

SELECT country_name, continent, independence_year, majority_language
FROM ( SELECT c1.country_name, c1.continent, c1.indep_year AS independence_year, 
	  l.name AS majority_language,
	  ROW_NUMBER() OVER (PARTITION BY l.code ORDER BY l.percent DESC) AS rn
	  FROM countries c1
	  INNER JOIN languages l
	  USING (code)
	  WHERE l.official = true
	 ) AS ranking_query
	 WHERE rn = 1;
	 
-- economic metrics in 2010
CREATE VIEW metrics2010 AS
SELECT DISTINCT ON (c1.country_name)
    c1.country_name,
    e.income_group,
    (e.gdp_percapita * p.size) AS gdp,
    ROUND((e.gross_savings / e.gdp_percapita * 100), 2) AS saving_rate,
    e.inflation_rate,
    e.total_investment,
    e.unemployment_rate,
    e.exports,
    e.imports,
    (e.exports - e.imports) AS trade_bal,
    ROUND((e.total_investment / e.gdp_percapita * 100), 2) AS investment_rate
FROM countries c1
INNER JOIN economies e USING (code)
INNER JOIN populations p ON e.code = p.country_code
WHERE e.year = 2010;

select * from metrics2010;
		
-- economic metrics in 2015
CREATE VIEW metrics2015 AS 
SELECT DISTINCT ON (c1.country_name)
    c1.country_name,
    e.income_group,
    (e.gdp_percapita * p.size) AS gdp,
    ROUND((e.gross_savings / e.gdp_percapita * 100), 2) AS saving_rate,
    e.inflation_rate,
    e.total_investment,
    e.unemployment_rate,
    e.exports,
    e.imports,
    (e.exports - e.imports) AS trade_bal,
    ROUND((e.total_investment / e.gdp_percapita * 100), 2) AS investment_rate
FROM countries c1
INNER JOIN economies e USING (code)
INNER JOIN populations p ON e.code = p.country_code
WHERE e.year = 2015;

SELECT * FROM metrics2015;


--economic growth in 5 years
SELECT ROUND((((m2.gdp - m1.gdp)/m1.gdp)*100),2) AS gdp_growth,
ROUND((((m2.imports - m1.imports)/m1.imports)*100),2) AS import_growth,
ROUND((((m2.exports - m1.exports)/m1.exports)*100),2) as export_growth,
ROUND((((m2.unemployment_rate - m1.unemployment_rate)/m1.unemployment_rate)*100),2) AS unemployment_change

-- negative sign indicates decline
FROM metrics2010 m1 INNER JOIN metrics2015 m2
USING (country_name);

		

		

	 

	 


