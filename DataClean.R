#### Load Libraries ####
library(readxl)
library(tidyverse)
library(dplyr)
library(lubridate)
library(naniar)

#### Load in Test Events and Test Data ####

#Load in Test Data
TestData <- read_excel("data/SummaryData.xlsx", sheet = "Test Data")

#Template for Test Events to Test Data Table
#Name of Event, Type of Event, Dates, All Data Types
names = c('Event Name', 'Event Type', 'Date Start', 'Date End')
names = c(names, TestData$'Testing Subset')

#Put into dataframe
Events = data.frame(matrix(ncol = length(names), nrow = 0))
colnames(Events) = names

#Detail of Events (Expanded roll-over)
Events_Detail = Events

#Loop through all Tables and fill in the Tables
for(event in list.files(path = "data/Events")){
  #Pull Description and Testing Subsets 
  Description = read_excel(paste("data/Events/", event, sep = ''), 
                           sheet = "Description", 
                           col_types = c("text", "date", "date", "text", "text"))
  Subsets = read_excel(paste("data/Events/", event, sep = ''),
                       sheet = "Testing Subsets", 
                       col_types = c("text", "text", "text"))
  #Create two one-row datraframes
  #One for showing, second for further Detail
  Events_Temp = data.frame(matrix(ncol = length(names), nrow = 1))
  colnames(Events_Temp) = names
  Events_Temp_Detail = Events_Temp
  
  Events_Temp$`Event Name`[1] = Description$`Event Name`[1]
  Events_Temp$`Event Type`[1] = Description$`Test Type`[1]
  Events_Temp$`Date Start`[1] = format(as.Date(Description$`Date Start`[1]), "%m-%d-%Y")
  Events_Temp$`Date End`[1] = format(as.Date(Description$`Date End`[1]), "%m-%d-%Y")
  
  Events_Temp_Detail$`Event Name`[1] = Description$`Description`[1]
  
  for(i in 1:nrow(Subsets)){
    Events_Temp[1, Subsets$`Test Data Evaluated`[i]] = Subsets$`Result`[i]
    Events_Temp_Detail[1, Subsets$`Test Data Evaluated`[i]] = Subsets$`Result Notes`[i]
  }
  
  #Format Dates
  Events = rbind(Events, as.data.frame(Events_Temp))
  Events_Detail = rbind(Events_Detail, Events_Temp_Detail)
}

#Order Data
Events_Detail$`Date Start` <- Events$`Date Start`


#Required twice for some reason
Events <- Events %>% arrange(mdy(Events$`Date Start`))
Events <- Events %>% arrange(mdy(Events$`Date Start`))
Events_Detail <- Events_Detail %>% arrange(mdy(Events_Detail$`Date Start`))
Events_Detail <- Events_Detail %>% arrange(mdy(Events_Detail$`Date Start`))

Events_Detail$`Date Start` <- Events_Detail$`Date End`

#For convenience shorten header
newnames <-  c('Event Name', 'Event Type', 'Date Start', 'Date End')
newnames = c(newnames, TestData$'ID')

colnames(Events) = newnames
colnames(Events_Detail) = newnames

Decisions <- read_excel("data/SummaryData.xlsx", sheet = "Decisions")
Decisions$`Date of Completion` = format(as.Date(Decisions$`Date of Completion`), "%m-%d-%Y")

Questions <- read_excel("data/SummaryData.xlsx", sheet = "Questions")

SummaryData <- read_excel("data/SummaryData.xlsx", sheet = "Operational Capabilities")

OperationalData <- read_excel("data/SummaryData.xlsx", sheet = "Operational Measures")

SystemData <- read_excel("data/SummaryData.xlsx", sheet = "Technical Capabilities")

SubsetConverter <- read_excel("data/SummaryData.xlsx", sheet = "Capabilities Data Crosswalk")