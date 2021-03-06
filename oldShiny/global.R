library(stattleshipR)
library(dplyr)
library(googleVis)

options(stringsAsFactors = FALSE)

set_token("INSERT Stattleship API")

team.name.list <- c("Arizona Cardinals", "Atlanta Falcons", "Baltimore Ravens",
                    "Buffalo Bills", "Carolina Panthers", "Chicago Bears",
                    "Cincinnati Bengals", "Cleveland Browns", "Dallas Cowboys",
                    "Denver Broncos", "Detroit Lions", "Green Bay Packers",
                    "Houston Texans", "Indianapolis Colts", "Jacksonville Jaguars",
                    "Kansas City Chiefs", "Miami Dolphins", "Minnesota Vikings",
                    "New England Patriots", "New Orleans Saints", "NY Giants",
                    "NY Jets", "Oakland Raiders", "Philadelphia Eagles",
                    "Pittsburgh Steelers", "San Diego Chargers", "San Francisco 49ers",
                    "Seattle Seahawks", "St. Louis Rams", "Tampa Bay Buccaneers",
                    "Tennessee Titans", "Washington Redskins")

years.available<- c('2016-2017', '2015-2016', '2013-2014', '2012-2013', '2011-2012')

chart.type <- c('Bar Chart', 'Line Chart')

offensive.positions <- c("QB", "RB", "WR", "K", "TE")

# removed Week and Home Away for now
stat.list <- c('RushingYards', 'ReceivingYards', 'PassingYards',
               'TotalTouchdowns', 'ReceivingTouchdowns', 'RushingTouchdowns',
               'PassingTouchdowns')

# make stat.list for comparing two players to use in a single data frame / plot
compare.stat.list <- paste(rep(stat.list, each ='2'), c('.p1','.p2'), sep='')
names(compare.stat.list) <- rep(stat.list, each='2')
compare.stat.list <- split(compare.stat.list, 1:2)





queryAPI <- function(player.name, year){
  
  # format name for query
  name <- gsub(' ','-',tolower(player.name), fixed = TRUE)
  q_body <- list(player_id = paste0('nfl-', name), season_id = paste0('nfl-', year))
  
  # run query
  game.log <- ss_get_result(sport = "football",
                            league = "nfl", ep = "game_logs", query = q_body, 
                            verbose = T)
  
  # strip extraneous outer layer
  game.log <- game.log[[1]]
  
  # check if query is correct/given player exists
  if(!is.null(game.log$error)){
    ab <- 'return error somehow'
  }
  
  if(game.log$players$position_abbreviation %in% offensive.positions) {
    abc <- "continue!"
    # otherwise say only offensive positions currently supported
  }
  
  
  # week info
  stats.frame <- data.frame("Week"=game.log$games$interval_number)
  
  # home or away
  home.away <- game.log$games$home_team_id
  home.away <-  ifelse(home.away == game.log$players$team_id,
                       'Home', 'Away')
  

  # quick rename, accesses the game log level of game logs
  gl <- game.log$game_logs
  
  # build up the data frame
  stats.frame$HomeAway <- home.away
  stats.frame$RushingYards <- as.numeric(gl$rushes_yards)
  stats.frame$ReceivingYards <- as.numeric(gl$receptions_yards)
  stats.frame$PassingYards <- as.numeric(gl$passes_yards_gross)
  stats.frame$TotalTouchdowns <- as.numeric(gl$total_touchdowns) # includes passing, anything
  stats.frame$ReceivingTouchdowns <- as.numeric(gl$receptions_touchdowns)
  stats.frame$RushingTouchdowns <- as.numeric(gl$rushes_touchdowns)
  stats.frame$PassingTouchdowns <- as.numeric(gl$passes_touchdowns)
  
  
  stat.list <- names(stats.frame)
  
  
  # arrange stats by week because for some reason they aren't in a weekly order
  stats.frame <- arrange(stats.frame, Week)
  
  # more natural and shows all values on graph
  stats.frame$Week <- as.character(stats.frame$Week)
  
  # non game dependent info
  default.stat <- switch(game.log$players$position_abbreviation, 
                         'QB' = 'PassingYards', 'RB' = 'RushingYards',
                         'WR' = 'ReceivingYards', 'TE' = 'ReceivingYards',
                         'K' = 'FieldGoalsMade')
  
  team.id <- game.log$players$team_id
  
  
  player.info <- list('name'= game.log$players$name,
                      'position' = game.log$players$position_name,
                      'team' = paste(game.log$teams$name, game.log$teams$nickname,sep = ' '),
                      'default.stat'= default.stat )
  
  
  return(list('stats.frame'=stats.frame, 'player'= player.info))
  
}



# Gvis plotting -----------------------------------------------------------

selectedGvis <- function(chart.type, title, data, xvar, yvar) {
  
  if (chart.type == 'Bar Chart') {
    
    k <- gvisBarChart(data, xvar, yvar,
                 options = list(width = 600, height = 400,
                                title = title,
                                titleTextStyle = "{fontSize:18}",
                                vAxis = "{title: 'Week'}"
                 )
    ) } else if(chart.type == 'Line Chart') {
      k <- gvisLineChart(data, xvar, yvar,
                    options = list(width = 600, height = 400,
                                  title = title,
                                  titleTextStyle = "{fontSize:18}",
                                  vAxis = "{title: 'Week'}"  
                  )
      )
     }
                         
  return(k)
}



# Combining Data Frame for Plotting --------------------------------------------

# to deal with how we set Week as class character in the original data frame
# because when we do a full join, we have to sort again.
# reason is full join, order is ambiguous, so it will sort first and parse downwards
combineByWeek <- function(data.frame1, data.frame2){
  
  df.p1 <- data.frame1
  df.p2 <- data.frame2
  plot.p1$Week <- as.numeric(plot.p1$Week)
  plot.p2$Week < as.numeric
  arrange(full_join(queryData()$stats.frame, queryData2()$stats.frame, 
                    by = 'Week', suffix = c('.p1', '.p2')),
          Week)
  
}

# db1 <- queryAPI('David Johnson', '2015-2016')$stats.frame
# db2 <- queryAPI('Devonta Freeman', '2015-2016')$stats.frame
# db1
# db1$Week
# db2$Week
# k <- full_join(db1, db2, by = 'Week')
# k$Week <- as.numeric(k$Week)
# k <- arrange(k, Week)
# k
# ?full_join
# handle bye week? right now it's just left out.


#gvistest <-  gvisBarChart(queryAPI('Eli Manning'))
#plot(gvistest)



# Javascript Code ---------------------------------------------------------

