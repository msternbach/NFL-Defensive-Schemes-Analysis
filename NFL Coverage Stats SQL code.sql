------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- How often was zone and man run in 2023 and 2022?

SELECT season, SUM(db) AS tot_db, AVG(man) AS man_avg,
AVG(zone) AS zone_avg
FROM
(SELECT * FROM coveragestats2023
UNION
SELECT * FROM coveragestats2022)
GROUP BY season;

-- Man was run 24.9% in 2023 and 25.1% in 2022
-- Zone was run 70.5% in 2023 and 68.5% in 2022

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- What about per week?

SELECT week, season, ROUND(SUM(db),2) AS tot_db, ROUND(AVG(man),2) AS man_percent,
ROUND(AVG(zone),2) AS zone_percent
FROM
(SELECT * FROM coveragestats2023
UNION
SELECT * FROM coveragestats2022)
GROUP BY week, season
ORDER BY man_percent DESC;

-- Zone and man were run pretty consistently week by week with zone ranging from 60-73% and man from 22-31%
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--What was the most run coverage in 2023 and 2022?

SELECT season, SUM(db) AS tot_db, AVG(cover0) AS cover0_percent,
AVG(cover1) AS cover1_percent, AVG(cover2) AS cover2_percent,
AVG(cover2man) AS cover2man_percent, AVG(cover3) AS cover3_percent,
AVG(cover4) AS cover4_percent, AVG(cover6) AS cover6_percent
FROM
(SELECT * FROM coveragestats2023
UNION
SELECT * FROM coveragestats2022)
GROUP BY season;

-- Cover 3 was run the most by far with it being called about 32% of the time in both 2022 and 2023
-- Cover2man was run the least with it being called about only 1.7% in both seasons

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For each coverage type which team had the highest percentage? The least?

SELECT name, season, SUM(db) AS tot_db, ROUND(AVG(cover0),4) AS cover0_percent,
ROUND(AVG(cover1),4) AS cover1_percent, ROUND(AVG(cover2),4) AS cover2_percent,
ROUND(AVG(cover2man),4) AS cover2man_percent, ROUND(AVG(cover3),4) AS cover3_percent,
ROUND(AVG(cover4),4) AS cover4_percent, ROUND(AVG(cover6),4) AS cover6_percent
FROM
(SELECT * FROM coveragestats2023
UNION
SELECT * FROM coveragestats2022)
GROUP BY name, season
ORDER BY cover0_percent DESC;

/*
Cover 0:
The Eagles had the highest percentage of cover 0 ran against them on average in 2023 at 7.22%. The Colts in 2022 had the least at 1.02%.
It seems that teams with more mobile quarterbacks faced more cover 0, as the Eagles, Bills, Ravens, and Bearss led.
Cover 1:
The 2023 New England had the highest average percentage with 29.04%, the 2022 Chiefs had the second most at 28.91%. The 2023 bucs 
and Dolphins had the least. 
Cover 2:
The 2022 Bengals had the highest percentage of cover 2 23.20%, there was a large gap between them and second, the 2022 Dolphins
had the second most at 19.45%. The 2023 and 2022 Ravens had the least at 7.90% and 4.23% respectively.
Cover 2man:
The 2023 Dolphins had cover2man run against them the most at 5.71%. The 2023 Ravens had the least at 0.16%
Cover 3:
The 2022 Panthers had cover 3 run against them 44.34% almost half of the time. The 2022 Vikings had it run against them
at 20.47% for the lowest.
Cover 4:
The 2023 Eagles had cover 4 run against them the most at 23% on average. The 2022 49ers had it run against them the least at 7.55%
Cover 6:
The 2023 Titans had cover 6 run against them the most at 14.52% on avrage. The 2022 Texans had it the least at just 4.22%
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- top 25 percentile for each coverage (I needed to find this in order to do the next step):

SELECT
  SUM(db) AS tot_db,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cover0) AS cover0_Q4,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cover1) AS cover1_Q4,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cover2) AS cover2_Q4,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cover3) AS cover3_Q4,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cover4) AS cover4_Q4,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cover6) AS cover6_Q4
FROM
  (SELECT * FROM coveragestats2023
   UNION
   SELECT * FROM coveragestats2022);

-- Percentiles: Cover 0 - 0.047, Cover 1 - 0.276, Cover 2 - 0.19, Cover 3 - 0.40875, Cover 4 - 0.216, Cover 6 - 0.138

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- When qbs played games where they faced coverages more than normal (top 25 percentile) did they do better or worse than their overall average output?

with playerstats AS (SELECT player_name, position, recent_team, season, week,
					 passing_yards, attempts, passing_tds, 
					 interceptions, passing_epa, fantasy_points
					 FROM stats2022
					 WHERE position = 'QB'
					 UNION 
					 SELECT player_name, position, recent_team, season, week,
					 passing_yards, attempts, passing_tds, 
					 interceptions, passing_epa, fantasy_points
					 FROM stats2023
					 WHERE position = 'QB'),
					 
coveragestats AS (SELECT *
				  FROM coveragestats2022
				  UNION
				  SELECT *
				  FROM coveragestats2023
),

cover0_stats AS (SELECT player_name, ROUND(SUM(db),2) AS cov0_dropbacks,
			ROUND(AVG(passing_yards),2) AS cov0_avg_yards, 
			ROUND(AVG(passing_tds),2) AS cov0_avg_tds,
			ROUND(AVG(interceptions),2) AS cov0_avg_ints,
			ROUND(AVG(passing_epa),2) AS cov0_avg_epa,
			ROUND(AVG(fantasy_points),2) AS cov0_avg_fantasy_points
			FROM playerstats
			INNER JOIN coveragestats
			ON playerstats.recent_team = coveragestats.name AND
			playerstats.week = coveragestats.week AND 
			playerstats.season = coveragestats.season
			WHERE attempts > 10 AND cover0 > .047
			-- Change based on which coverage querying for
			GROUP BY player_name
			HAVING SUM(db) > 100),

total_averages AS (SELECT player_name, ROUND(SUM(db),2) AS total_dropbacks,
	   		ROUND(AVG(passing_yards),2) AS avg_yards, ROUND(AVG(passing_tds),2) AS avg_tds,
	   		ROUND(AVG(interceptions),2) AS avg_ints, ROUND(AVG(passing_epa),2) AS avg_epa,
	   		ROUND(AVG(fantasy_points),2) AS avg_fantasy_points
			FROM playerstats
			INNER JOIN coveragestats
			ON playerstats.recent_team = coveragestats.name AND
			playerstats.week = coveragestats.week AND 
			playerstats.season = coveragestats.season
			GROUP BY player_name)
			
SELECT cover0_stats.player_name, cov0_dropbacks, total_dropbacks,
cov0_avg_yards, avg_yards, (cov0_avg_yards - avg_yards) AS yard_diff, cov0_avg_tds, 
avg_tds, (cov0_avg_tds - avg_tds) AS tds_diff, cov0_avg_ints, avg_ints,
(cov0_avg_ints - avg_ints) AS ints_diff, cov0_avg_epa, avg_epa,
(cov0_avg_epa - avg_epa) AS epa_diff, cov0_avg_fantasy_points, avg_fantasy_points,
(cov0_avg_fantasy_points - avg_fantasy_points) AS fantasy_points_diff
FROM total_averages
INNER JOIN cover0_stats
ON total_averages.player_name = cover0_stats.player_name
ORDER BY yard_diff;

/*
Cover0 > 4.7%:

When facing cover 0 an increased amount the majority of the players in the list had increased success. Gardner Minshew, Tua Tagovailoa,
Kenny Pickett, Patrick Mahomes, and Kyler Murray stood out as having much higher than normal statistical output. In games when facing
Cover 0 percentages in the top 25th percentile Minshew had a whopping increase of 67.19 more passing yards, 6.29 more fantasy points
and an increased epa of 4.54 on 253 total dropbacks. Kyler Murray had 5.27 more fantasy points, though on just 104 dropbacks, Tua
and Kenny Pickett each had an increased epa of about 8 which is a very impressive difference, and Mahomes had an increased epa of
of 4.5 on 348 dropbacks.

Only one qb stood out as doing much worse in games where he faced cover 0 an increased amount and that was Joe Flacco. Flacco had
an average epa 12.58 points less than his average and had 5.91 less fantasy points despite throwing for 30 more yards than his average.

Cover1 > 27.6%:

Cover 1 was another coverage that quarterbacks seemed to have increased success on. Geno Smith and Justin Herbert had increased epas
of 9.10 and 8.90 respectively and Herbert did it on 293 dropbacks. Also, Geno and Jordan Love each had increased fantasy point outputs
of about 8.

A few qbs such as Mac Jones, Tua, and Andy Dalton did a little worse than their averages but nothing really stood out. Cover 0 and Cover 1
are both man coverages, so then reason that teams run man coverages only about 30% of the time average might be because qbs have overall
increased success against man.

Cover2 > 19% :

Against cover 2 Jacoby Brisett and Baker Mayfield both had increased epas of about 8.30, and Joe Falcco had increased epa of 7.36 although
none of these qbs surpassed 150 total dropbacks against cover 2 when played in the top 25 percentile. Jordan Love had an increased fantasy
points output of 5.44 on 304 dropbacks.

One star quarterback stood out as doing much worse when facing cover 2 an increased amount; Dak Prescott. Dak had a horrendous
epa difference of -15.74 with his average epa of 5.54 going to -10.20. He also had 11.54 less fantasy points and 0.92 interceptions.
It was only on 159 dropbacks but those numbers are so bad that teams start thinking about running cover 2 more against him.

Cover3 > 40.875%:

Cover 3 should not be run more than 40% of the time against Patrick Mahomes because the star quarterback averaged an epa of 15.46
which 8.10 points above his normal average. Tua also had an impressive epa increase of 6.60. Sam Darnold and Tyrod Taylor had fantasy
point increases of 9.02 and 11.15 respectievly although neither had more than 130 dropbacks. One interesting was that almost half
of Brock Purdy's 811 total dropbacks have been in games facing cover 3 in the top 25 percentile. In those games his fantasy point 
output was 4.18 more than normal and his epa was 2.82 points more than his average.

Josh Dobbs struggled mightly as he had an epa 7.25 points less than his average and also had 6.03 less fantasy points on 191 dropbacks.
Baker Mayfield also struggled as he had decreased epa of 5.84 on 403 dropbacks.

Cover4 > 21.6%:

Very few quarterbacks were able to find more success than their average in games when facing cover 4 in the top 25 percentile.
Only 3 qbs an epa difference of over 2. Matt Stafford had the most success with an epa difference of 4.06. Jalen Hurts also had 
success with an increased epa of 2.89 and 4.09 more fantasy points than average. 

Among those who did worse Russell Wilson led the pack with a epa 6.66 points less than his average on 356 dropbacks. Dak Prescott had
a epa of 4.10 less and also had 3.53 fantasy points less than average. Justin Herbert, Mahomes, Josh Allen, and Tua notably had epas
around 3-4 points less than thier averages.


Cover6 > 13.8%:

In games when cover 6 was run in the top 25 percentile qbs seemed to either do much better or worse than their average without much
in between. Justin Fields and Jordan Love had increased epas of about 8 each although they had 108 and 121 total dropbacks respectively.
Dak Prescott had an increased epa of 6.06 and also had 3 more fantasy points than average on 205 dropbacks. Mac Jones had increased fantasy
output of 3.61 on 362 dropbacks.

On the flip side 10 qbs had a epa that was at least 5.5 less than average which is a huge difference. Mahomes, Joe Burrow, Daniel Jones,
Kyler Murray, and Brock Purdy were among those qbs. Mahomes and Burrow had 4.86 and 4.34 less fantasy points than their averages respectively.
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Any coverage run more than 50%

cover_stats AS (SELECT player_name, ROUND(SUM(db),2) AS cov0_dropbacks,
			ROUND(AVG(passing_yards),2) AS cov0_avg_yards, 
			ROUND(AVG(passing_tds),2) AS cov0_avg_tds,
			ROUND(AVG(interceptions),2) AS cov0_avg_ints,
			ROUND(AVG(passing_epa),2) AS cov0_avg_epa,
			ROUND(AVG(fantasy_points),2) AS cov0_avg_fantasy_points
			FROM playerstats
			INNER JOIN coveragestats
			ON playerstats.recent_team = coveragestats.name AND
			playerstats.week = coveragestats.week AND 
			playerstats.season = coveragestats.season
			WHERE attempts > 10 AND (cover0 > 0.50 OR cover1 > .50
									 OR cover2 > 0.50 OR cover3 > .50
									 OR cover4 > 0.50 OR cover6 > .50)
			GROUP BY player_name
			HAVING SUM(db) > 100), 

/*	
Justin Fields had the most dropbacks of 317 which is interesting because he has 919 total dropbacks over the past two seasons, so almost a third
of his dropbacks have been in games when he faced a certain coverage more than 50% of the time. He had a +0.52 epa in these games so he did do
a little better than average when facing a single coverage in the majority of the game.	The quarterback with the biggest epa increase was actually
Bryce Young who had a epa 8.06 better in these games. 
	
Quite a few star quarterbacks struggled. Lamar Jackson had -7.71 epa and Dak had -6.25 on 115 dropbacks each. Justin Herbert had -5.56, Jared Goff had -4.54, and 
Trevor Lawrence had -4.42 epa with each of them having at least 200 dropbacks. This is very interesting because one would expect star quarterbacks to do
better than average when facing the same coverage more than 50% of the game
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Coverage played evenly (at least less then 30% each):

cover_stats AS (SELECT player_name, ROUND(SUM(db),2) AS cov0_dropbacks,
			ROUND(AVG(passing_yards),2) AS cov0_avg_yards, 
			ROUND(AVG(passing_tds),2) AS cov0_avg_tds,
			ROUND(AVG(interceptions),2) AS cov0_avg_ints,
			ROUND(AVG(passing_epa),2) AS cov0_avg_epa,
			ROUND(AVG(fantasy_points),2) AS cov0_avg_fantasy_points
			FROM playerstats
			INNER JOIN coveragestats
			ON playerstats.recent_team = coveragestats.name AND
			playerstats.week = coveragestats.week AND 
			playerstats.season = coveragestats.season
			WHERE attempts > 10 AND (cover0 < 0.30 AND cover1 < .30
									 AND cover2 < 0.30 AND cover3 < .30
									 AND cover4 < 0.30 AND cover6 < .30)
			GROUP BY player_name
			HAVING SUM(db) > 100),

/*
Trevor Lawrence had most dropbacks at 465, and Tua, Burrow, Kirk Cousins, and Josh Allen all had over 300. Mahomes had +3.44 epa on 270 dropbacks,
Herbert had +2.13 on 280, and Burrow +1.98 on 403. Brock Purdy was once qb who strggled and had -8.13 epa on 189 dropbacks.
*/

