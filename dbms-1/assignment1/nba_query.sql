--4.1
SELECT position, COUNT(ilkid)
FROM players
GROUP BY position;

--4.2
SELECT year, SUM(gp) AS total_games
FROM (
  SELECT ilkid, year, gp
  FROM player_playoffs
  UNION ALL
  SELECT ilkid, year, gp
  FROM player_regular_season
)
GROUP BY year
ORDER BY total_games DESC, year ASC
LIMIT 5;

--4.3
ALTER TABLE player_regular_season_career
ADD eff int;

UPDATE player_regular_season_career
SET eff = pts + reb + asts + stl + blk - ((fga - ftm) + turnover);

SELECT ilkid, SUM(gp), SUM(eff)
FROM player_regular_season_career
GROUP BY ilkid
HAVING SUM(gp) > 500
ORDER BY eff desc
LIMIT 10;
--4.4
WITH games_per_year(ilkid, year, gp) as (
  SELECT ilkid, year, SUM(gp)
  FROM player_regular_season
  GROUP BY year, ilkid
),
games_in_1990(ilkid, year, gp) as (
  SELECT ilkid, year, SUM(gp)
  FROM player_regular_season
  GROUP BY year, ilkid
  HAVING year=1990
)
SELECT DISTINCT COUNT(ilkid)
FROM games_in_1990
WHERE games_in_1990.gp > (SELECT MAX(gp)
                          FROM games_per_year
                          WHERE games_per_year.ilkid = games_in_1990.ilkid AND games_per_year.year != 1990);


--4.5
WITH GROUP_GP_EFF(ilkid, firstname, lastname, gp, eff) AS (
  SELECT ilkid, firstname, lastname, SUM(gp), SUM(eff)
  FROM player_regular_season_career
  GROUP BY ilkid, firstname, lastname
)
SELECT ilkid, firstname, lastname, gp, eff
FROM GROUP_GP_EFF AS T1
WHERE NOT EXISTS (
  SELECT DISTINCT(ilkid), firstname, lastname, gp, eff
  FROM GROUP_GP_EFF AS T2
  WHERE T1.ilkid != T2.ilkid AND (
    T2.gp > T1.gp AND T2.eff > T1.eff
  )
);
