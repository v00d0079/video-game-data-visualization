library(tidyverse)
library(dplyr)
library(readxl)
library(shiny)

Video_Games_Sales <- read_excel("C:/Users/sniss/OneDrive/Desktop/CSC 324/Data Set/Video_Games_Sales_as_at_22_Dec_2016.xlsx")
Ps4_Games_Sales <- read_excel("C:/Users/sniss/OneDrive/Desktop/CSC 324/Data Set/PS4_GamesSales.xlsx")
Xbox1_Games_Sales <- read_excel("C:/Users/sniss/OneDrive/Desktop/CSC 324/Data Set/XboxOne_GameSales.xlsx")
top_selling_xbox<-Xbox1_Games_Sales %>% group_by(Year) %>% slice(which.max(Global))
by_gamesales <- filter(Video_Games_Sales, Global_Sales > .001)




#View(Video_Games_Sales)
#View(Ps4_Games_Sales)
#View(Xbox1_Games_Sales)
#view(top_selling_xbox)

clean<-filter(Video_Games_Sales,Global_Sales>.37 & Critic_Score > 40)

ggplot(filter(Video_Games_Sales,Global_Sales>.37), aes(x= User_Score*10, y = Critic_Score))+
  geom_point()+
  geom_point(data = Video_Games_Sales %>% select(Platform:Critic_Score,Rating,User_Score), aes(color=Genre, size = (Global_Sales)),show.legend=TRUE)

#ggplot(Xbox1_Games_Sales, aes(x= Global, y = Year))+
 # geom_point()+ 
  #geom_point(data = top_selling_xbox %>% select(`North America`:Global,Year), aes(x = `North America`,y =Year), color = 'purple', size =3)


