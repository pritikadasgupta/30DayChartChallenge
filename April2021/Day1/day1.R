#!/usr/bin/env Rscript

#Libraries
library(tidyverse)
library(ggraph)
library(igraph)
library(circlepackeR)  
# devtools::install_github("jeromefroe/circlepackeR")

##Load In Data

#Use this if you're running from the command line:
# df <- read.table(file("stdin"), header = FALSE, sep = " ")

#Use this if you're opening this repo as a R project, using relative paths:
df <- read.table(file = 'April2021/Day1/input.csv', sep = ',', header = TRUE)
# https://raw.githubusercontent.com/nytimes/covid-19-data/master/prisons/facilities.csv

df <- df[-c(352),] #corrupt row

state_sum <- aggregate(df$latest_inmate_population, list(df$facility_state), sum)
state_sum_covid <- aggregate(df$total_inmate_cases, list(df$facility_state), sum)

state_sum_covid$total <- state_sum$x
state_sum_covid$fraction <- state_sum_covid$x/state_sum_covid$total

state_sum_covid_complete <- state_sum_covid[complete.cases(state_sum_covid),]
View(state_sum_covid_complete)

# Plot
ggplot(state_sum_covid_complete, aes(x=Group.1, y=fraction)) +
  geom_point() + 
  geom_segment( aes(x=Group.1, xend=Group.1, y=0, yend=fraction))+
  theme(axis.text.x = element_text(angle = 90)) +
  xlab("State") +
  ylab("Fraction of COVID-19 cases out of the total inmate population")


