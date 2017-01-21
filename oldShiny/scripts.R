options(stringsAsFactors = FALSE)


nfl_teams <- read.csv("nfl_teams.csv")
nfl_teams$Name

# manually add boundary quotations for now
cat(nfl_teams$Name, file= "list_of_team_names.txt", sep="\", \"")
cat


# used to create stat.list, just copy paste what you have again and put it here
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


# use this and just copy and paste from console
create.stat.list <- names(stats.frame)
slist <- character()
for(i in create.stat.list){
  slist <- paste(slist, i, sep = "', '")
}
slist

# retired
# actionButton(inputId = 'rush.yds', 'Rush Yards'),
# actionButton(inputId = 'rec.yds', 'Receiving Yards'),
# actionButton(inputId = 'pass.yds', 'Passing Yards')

# shelved
# selectInput(inputId="year", "Year", years.available)
# 
# selectInput(inputId ="team.name", "Team", team.name.list),
# 
# selectInput(inputId ="player.name", "Player", c(""))
# # selectizeInput for multiple selections


# which stat by button
# observeEvent(input$rush.yds, { stats$stat <- 'RushingYards'})
# observeEvent(input$rec.yds, { stats$stat <- 'ReceivingYards'})
# observeEvent(input$pass.yds, { stats$stat <- 'PassingYards'})


# join test
test1 <- data.frame(num=(sample(seq(1,10),10)), let = letters[1:10])
test2 <- data.frame(num = (sample(seq(4,13),10)), let = LETTERS[1:10])
test1 <- arrange(test1, num)
test2 <- arrange(test2, num)
test1$num <- as.character(test1$num)
test2$num <- as.character(test2$num)
test3 <- full_join(test1, test2, by = 'num')
test1$num
?letters

# it works?
