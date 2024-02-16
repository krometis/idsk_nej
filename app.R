#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#### Load Relevant Libraries ####
library(shiny)
library(DT)

#Run Data Cleaning
source("DataClean.R")

ui <- fluidPage(
  #App Title
  titlePanel('Counterfire Target Acquisition Radar System'),
  
  #Main Panel (Tabs)
  mainPanel(
    tabsetPanel(type = "tabs",
                #Decisions and Questions
                tabPanel("Decisions and Questions", 
                         htmlOutput("DecisionSummary"),
                         dataTableOutput("DecisionSpace"),
                         htmlOutput("QuestionSummary"),
                         dataTableOutput("QuestionSpace")),
                #Operational View
                tabPanel("Operational View",
                         mainPanel(
                           tabsetPanel(
                             #tabPanel("Summary", dataTableOutput("OperationalSummary")),
                             tabPanel("Effectiveness", 
                                      htmlOutput("EffectivenessDes"),
                                      dataTableOutput("Effectiveness"),
                                      htmlOutput("EffectivenessRes")),
                             tabPanel("Suitability", 
                                      htmlOutput("SuitabilityDes"),
                                      dataTableOutput("Suitability"),
                                      htmlOutput("SuitabilityRes")),
                             tabPanel("Survivability", 
                                      htmlOutput("SurvivabilityDes"),
                                      dataTableOutput("Survivability"),
                                      htmlOutput("SurvivabilityRes"))
                           )
                         )),
                
                #Technical View
                tabPanel("Technical View", 
                         mainPanel(
                           tabsetPanel(
                             tabPanel("Key Performance Parameters", dataTableOutput("KPP"), 
                                      dataTableOutput("KPPSpec")),
                             tabPanel("Key System Attributes", dataTableOutput("KSA"),
                                      dataTableOutput("KSASpec"))
                           )
                         )),
                
                #Test Data
                tabPanel("Test Data", 
                         sidebarLayout( position = "right",
                                        sidebarPanel(
                                          selectInput("Subsets", "Choose a Testing Subset:",
                                                      choices = colnames(SubsetConverter[,-1]))
                                        ),
                                        mainPanel(htmlOutput("SubsetIntro"),
                                                  dataTableOutput("SubsetTable"),
                                                  htmlOutput("SubsetOutro"),
                                                  dataTableOutput("SubsetTable2"))
                         )),
                #Test Events
                tabPanel("Test Events", dataTableOutput("Events"))
                )
  )
)
  
server = function(input, output){
  #Decisions and Questions
  output$DecisionSummary <- renderText('This Integrated Decision Support Key (IDSK) was created to support decision 
                                       making for this Counterfire Target Acquisition Radar System. <br/>
                                       In particular, the following decisions were supported:')
  output$DecisionSpace <- renderDataTable({
    DT::datatable(Decisions, rownames= FALSE,
                  options = list(pageLength = 100, 
                                 dom = 'ft'))
  })
  #Questions
  output$QuestionSummary <- renderText('These decisions were made in reference to
                                       the following question related to the 
                                       system under test (SUT):')
  output$QuestionSpace <- renderDataTable({
    DT::datatable(Questions, rownames= FALSE,
                  options = list(pageLength = 100, columnDefs = list(list(width = '50px', targets = c(0))), 
                                 dom = 'ft'))
  })
    
  
  #Operational View
  output$EffectivenessDes <-  renderText({paste(strong('Description: '),SummaryData[1,]$Description, '<br/>',
                                                strong('Scope: '),SummaryData[1,]$Scope, 
                                                '<br/> This Operational Measure is related to ',
                                                strong(SummaryData[1,]$`Related Question`))})
  output$Effectiveness <- renderDataTable({
    DT::datatable(OperationalData[which(OperationalData$COI == 'Effectiveness'), -c(1)],
                  rownames= FALSE, escape = FALSE,
                  selection = list(target = 'cell', mode = 'single'),
                  options = list(pageLength = 100, autoWidth = FALSE,
                                 columnDefs = list(list(width = '50px', targets = c(0))),
                                 dom = 'ft'))
  })
  
  output$EffectivenessRes <- renderText({paste('<br/>', strong('Rationale: '), SummaryData[1,]$Rationale)}) 
  
  output$SuitabilityDes <-  renderText({paste(strong('Description: '),SummaryData[2,]$Description, '<br/>',
                                              strong('Scope: '),SummaryData[2,]$Scope, 
                                              '<br/> This Operational Measure is related to ',
                                              strong(SummaryData[2,]$`Related Question`))})
  output$Suitability <- renderDataTable({
    DT::datatable(OperationalData[which(OperationalData$COI == 'Suitability'), -c(1)],
                  rownames= FALSE, escape = FALSE,
                  selection = list(target = 'cell', mode = 'single'),
                  options = list(pageLength = 100, autoWidth = FALSE,
                                 columnDefs = list(list(width = '50px', targets = c(0))),
                                 dom = 'ft'))
  })
  
  output$SuitabilityRes <- renderText({paste('<br/>', strong('Rationale: '), SummaryData[2,]$Rationale)}) 
  
  
  output$SurvivabilityDes <-  renderText({paste(strong('Description: '),SummaryData[3,]$Description, '<br/>',
                                                strong('Scope: '),SummaryData[3,]$Scope, 
                                                '<br/> This Operational Measure is related to ',
                                                strong(SummaryData[3,]$`Related Question`))})
  output$Survivability <- renderDataTable({
    DT::datatable(OperationalData[which(OperationalData$COI == 'Survivability'), -c(1)],
                  rownames= FALSE, escape = FALSE,
                  selection = list(target = 'cell', mode = 'single'),
                  options = list(pageLength = 100, autoWidth = FALSE,
                                 columnDefs = list(list(width = '50px', targets = c(0))),
                                 dom = 'ft'))
  })

  
  output$SurvivabilityRes <- renderText({paste('<br/>', strong('Rationale: '), SummaryData[3,]$Rationale)}) 
  
  
  #Technical View
  output$KPP <- renderDataTable({
    datatable(SystemData[which(startsWith(SystemData$'ID', "KPP")),],
              rownames= FALSE, selection = list(target = 'cell', mode = 'single',
                                                selected = matrix(c(1, 0), nrow = 1, ncol = 2)),
              options = list(pageLength = 100, columnDefs = list(list(width = '50px', targets = c(0))),
                             dom = 'ft'))
  })
  output$KPPSpec <- renderDataTable({
    DT::datatable(read_excel("data/KPPs.xlsx", 
                             sheet = input$KPP_cells_selected[1]),
                  rownames= FALSE,
                  selection = list(target = 'cell', mode = 'single'),
                  options = list(pageLength = 100, 
                                 dom = 'ft'))
  })
  
  output$KSA <- renderDataTable({
    DT::datatable(SystemData[which(startsWith(SystemData$'ID', "KSA")),],
                  rownames= FALSE,
                  selection = list(target = 'cell', mode = 'single',
                                   selected = matrix(c(1, 0), nrow = 1, ncol = 2)),
                  options = list(pageLength = 100, columnDefs = list(list(width = '50px', targets = c(0))),
                                 dom = 'ft'))
  })
  output$KSASpec <- renderDataTable({
    DT::datatable(read_excel("data/KSAs.xlsx", 
                             sheet = input$KSA_cells_selected[1]),
                  rownames= FALSE,
                  selection = list(target = 'cell', mode = 'single'),
                  options = list(pageLength = 100, 
                                 dom = 'ft'))
  })
  
  
  #Test Data
  output$SubsetIntro <- renderText({paste(strong(input$Subsets), '<br/> ',
                                          strong('Objectives: '),
                                          TestData[TestData$`Testing Subset` == input$Subsets,]$Objectives,
                                          '<br/>', strong('Scope: '),
                                          TestData[TestData$`Testing Subset` == input$Subsets,]$Scope,
                                          '<br/> <br/> This measure is related to the following Operational Measures:')})
  output$SubsetTable <- renderDataTable({
    DT::datatable(OperationalData[which(OperationalData$ID %in% SubsetConverter$ID[which(SubsetConverter[,input$Subsets] == 1)]), -c(1)], rownames= FALSE,
                  options = list(pageLength = 100, 
                                 dom = 'ft'))
  })
  output$SubsetOutro <- renderText({paste('<br/> ', strong('And the Following Technical Capabilities: '))})
  output$SubsetTable2 <- renderDataTable({
    DT::datatable(SystemData[which(SystemData$ID %in% SubsetConverter$ID[which(SubsetConverter[,input$Subsets] == 1)]), c(1,2)], rownames= FALSE,
                  options = list(pageLength = 100, 
                                 dom = 'ft'))
  })
  
  
  #Test Events
  output$Events <-renderDataTable({
    #DT::datatable(mrgObjEvSub[,c('Decision Phase','Objective','Event','Testing Subset','Result')])
    dtable <- datatable(Events, filter = list(position = 'top'), escape = FALSE, rownames= FALSE,
                        selection = list(mode ='single', target = 'cell'),
                        options = list(pageLength = 100, filter = 'top', autoWidth= T,
                                       #Control filtering to only columns of interest
                                       rowsGroup = list(0), ordering = FALSE,
                                       autoWidth = TRUE,
                                       columnDefs = list(list(width = '1000px', targets = c(2))),
                                       dom = 'ft')) %>% formatStyle(
                                         TestData$`ID`,
                                         fontWeight = 'bold',
                                         backgroundColor = styleEqual(c('Issue', 'Satisfactory'), c('yellow', 'green'))
                                       )
    dtable
  })
  
  observeEvent(input$Events_cells_selected, {
    info <- 'This Summary Table gives information for all testing events, including the results for each testing subset for each event. Click on cells to see further results, if any.'
    if (all(is.na(input$Events_cells_selected)) == FALSE){
      info <- HTML(Events_Detail[[input$Events_cells_selected[2]+1]][input$Events_cells_selected[1]])
      if (is.na(info)){
        info <- 'No information available'
      }
    }
    
    showModal(modalDialog(info, escape = FALSE))
  })
  
  
}



shinyApp(ui = ui, server = server)
