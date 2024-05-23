# NFL-Defensive-Schemes-Analysis

## Introduction: 
The goal of this project was to learn how often different defensive coverages are called in the NFL, and then analyze how quarterbacks perform against each of these
coverages. To do this I used two datasets; one with offensive statistics for every player who played in the 2022 and 2023 seasons and one with data on how often each 
defensive coverage type was called in each game in those two seasons. 

When analyzing quarterback performance I mostly focused on passing epa (expected points added).  Epa takes the expected point total for a team in a game and measures how
many additional points a player added to that expected point total. It isn’t a perfect measure, but it is a good way to measure how good a player performed during a game. I
also looked at fantasy points as I wanted to see how this data could be applied to evaluating players during fantasy football. However, epa was what was used when evaluating
actual differences in performance since fantasy points aren’t necessarily indicative of how good a player did. 

To measure performance against each individual coverage I filtered for games when the frequency of specified defensive coverage was run in the top 25 percentile. For example
let’s say across all games from 2022 to 2023 cover 2 was called at minimum 5% during a game and maximum 70% of the games. Between those values you have quartile 1 
(25% of values), the median (50% of the values), and quartile 3 (75% of the values). If across all games the third quartile of cover 2 percent was 30% then I would filter
for all games when cover 2 was called greater than 30% of the time. By doing this I could see whether or not the output by quarterbacks in those games were higher, lower,
or the same as their average output across all games. If there was a big performance difference in those games versus their average I would make a note of it and say they 
were worse against that defensive scheme (the scheme being running cover 2 more than 30%).

There were a few limitations of the project that should be considered. One was that I could only get defensive coverage data from the past two seasons. It would’ve been
preferable to have data for more seasons, but I had to work with what was available. Next, the biggest issue was that I would have much rather had play by play data instead
of game by game data. With play by play data I could’ve looked at which defensive coverage was called each play and what the result of each play was. This could’ve been much
more accurate when showing the difference in performance against different coverages. Instead I had to resort to using the percentiles method that I talked about above. This
method has flaws as a team can run a coverage much more than normal in a game, but they aren’t running one coverage the whole game, so you can’t completely gauge if a player
is necessarily worse or better against a certain coverage. That is why it’s more accurate to say that I was measuring quarterback performance against defensive schemes than
coverages. That being said I couldn’t find any play by play data, so I’d say I picked the best possible method given the data I had.

## Football Terminology (Please read if you don't have much football knowledge):

In football a defense calls a play on every down to combat whatever the offense had called. There are all sorts of variations of those defensive plays but they will
almost always be in one of seven defensive coverage shells: cover 0, cover 1, cover 2, cover 2 man, cover 3, cover 4, and cover 6. Cover 0, 1, and 2 man are types of man
coverages where defensive players are matched up against each receiver and guard them man to man. In cover 1 there is one safety dropped back in zone coverage, in 
cover 2 man there are two safeties dropped back in zone, and cover 0 there are no safeties. Cover 0 is arguably the most risky coverage as there are no safeties dropped back
to help out if someone can’t guard their man. Cover 2, cover 3, cover 4 and cover 6 are types of zone coverage. Zone coverage is when every defensive player in coverage
guards a specified area of the field i.e. a zone. In cover 2 there are two players dropped back in deep zones while the rest of the players in zones play closer to the
quarterback. In cover 3 three defensive players drop back into deep zones and cover 4 four players are dropped back. Cover 6 is a little different where instead of six
players dropping back it is splitting the field in half and playing cover 2 on one side of the field and cover 4 on the other.

Fantasy points are used to score player's performance in way that can be applied to fantasy football. Quarterbacks are given fantasy points for every yard, touchdown, 
interception, and fumble. The higher the points the better.

Expected Points Added, commonly referred to as EPA, is a measure of how well a team performs relative to expectation. For example, if a team starts a drive on the 50-yard
line, its expected points to start the drive would be about 2.5. If the team ends the drive with a field goal, thus gaining 3 points, its EPA for that drive would be found
by subtracting its expected points from how many points it actually gained, 3 – 2.5 or 0.5 EPA. This same logic can be applied to individual plays. Say the Chiefs start with
the ball first-and-10 from their 25-yard line, where its expected points would be about 1.06. If Patrick Mahomes throws a 15-yard completion, making it first-and-10 on the
KC 40-yard line, where the expected points is now 1.88, the EPA of that play would be 1.88 – 1.06 or 0.82. In other words, that completion increased the Chiefs’ expected
points on that drive by just over three-fourths of a point (source: https://www.the33rdteam.com/epa-explained/).
