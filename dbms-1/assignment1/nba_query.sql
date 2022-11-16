/*SELECT position, count(ilkid)
FROM players
GROUP BY position;

SELECT year, total(gp) AS total_games
FROM (
  SELECT ilkid, year, gp
  FROM player_playoffs
  UNION ALL
  SELECT ilkid, year, gp
  FROM player_regular_season
)
GROUP BY year
ORDER BY total_games DESC, year ASC;

ALTER TABLE player_regular_season_career
ADD eff int;

UPDATE player_regular_season_career
SET eff = pts + reb + asts + stl + blk - ((fga - ftm) + turnover);*/

SELECT ilkid, total(gp), total(eff)
FROM player_regular_season_career
GROUP BY ilkid
HAVING total(gp) > 500
ORDER BY eff desc
LIMIT 10;

/*SELECT ilkid, firstname, lastname, total(gp) as games_played
FROM player_regular_season
GROUP BY year
HAVING total(gp) >= ALL (SELECT total(gp)
                            FROM player_regular_season
                            GROUP BY year) AND year = 1990);*/
