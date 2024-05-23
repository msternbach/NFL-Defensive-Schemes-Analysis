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
