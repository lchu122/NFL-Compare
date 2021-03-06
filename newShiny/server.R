#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyServer(function(input, output, session) {

 
 # default stat by position. is it running query Data twice?

 stats <- reactiveValues(stat = 'RushYards')  
 plot.compare <- reactiveValues(compare = data.frame(), title = 'DEFAULT')
 
 
 # redo this so changing year input automatically changes this? (instead of having to click search again)
 queryData <- eventReactive( input$search.button,  {
   query.df <- queryAPI(input$search.player, input$year.p1, 1)
 })

 # does it have to be separate?
 queryData2 <- eventReactive( input$search.button2, {
   query.df2 <- queryAPI(input$search.player2, input$year.p2, 2)

 })
  

 # then go by stat dropdown menu
 observeEvent( input$stats.input, { 
   # to handle comparing two players
   if(length(stats$stat) == 1){ 
   stats$stat <- input$stats.input
   plot.compare$title <- stats$stat} else{
   stats$stat <- c(compare.stat.list[[1]][input$stats.input],
                   compare.stat.list[[2]][input$stats.input])
   plot.compare$title <- paste0(paste0(stats$stat[1], ' vs. '), stats$stat[2])
   }
   
   
 })

  # use observeEvent and reactive value to change type of plot 
 
 observeEvent(input$search.button, {
   stats$stat <- queryData()$player$default.stat
   updateSelectInput(session, inputId = 'stats.input', selected = stats$stat)
   plot.compare$compare <- queryData()$stats.frame
   plot.compare$title <- stats$stat
   
   output$test.plot <- renderGvis({
     
     selectedGvis(input$chart.input, plot.compare$title, plot.compare$compare, xvar ='Week', yvar=stats$stat)
     
     
     
   })
   
 })
 observeEvent(input$search.button2, { 
   stats$stat <- c(compare.stat.list[[1]][input$stats.input],
                   compare.stat.list[[2]][input$stats.input])
   # or how to use runif? # this blocks program from crashing if they search second field first
   # buggy
   # if (length(queryData()) > 1){
   # 
   #   plot.compare$compare <- combineByWeek(queryData()$stats.frame, queryData2()$stats.frame)
   #   plot.compare$title <- paste0(paste0(stats$stat[1], ' vs. '), stats$stat[2])
   # }
   # 
   plot.compare$compare <- combineByWeek(queryData()$stats.frame, queryData2()$stats.frame)
   plot.compare$title <- paste0(paste0(stats$stat[1], ' vs. '), stats$stat[2])

 })
 
 # I suppose the input button is toggled on? because pressing second input button
 # which switches values inside, causes gvisBarChart to change
 # observeEvent(input$search.button, {
 #   
 #   # would like to make toggle button instead
 #   # is this best way to do ths?
 #   output$test.plot <- renderGvis({
 #     
 #     selectedGvis(input$chart.input, plot.compare$title, plot.compare$compare, xvar ='Week', yvar=stats$stat)
 # 
 #     
 #    
 #   })
 # })
 
  # cat to get only string and no index, quotes
  output$print.name <- renderPrint({cat(queryData()$player$name)})
  output$print.team <- renderPrint({cat(queryData()$player$team)})
  output$print.position <- renderPrint({cat(queryData()$player$position)})
  
  output$print.name2 <- renderPrint({cat(queryData2()$player$name)})
  output$print.team2 <- renderPrint({cat(queryData2()$player$team)})
  output$print.position2 <- renderPrint({cat(queryData2()$player$position)})
  

  
  
  # ask for team
  
  # ask for player
  
  
  
  # to get stats from team_logs
  # avg or sum
  
  # look at feats and try to compare players that part should be easy, double everything
  
  
})
