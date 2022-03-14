# Importing various Librarys of use (Decided to use flexdashbaord since markdown was way easier to create a graph generator)
library(flexdashboard)
library(plyr)
library(dplyr)
library(tidyverse)
library(gganimate)
library(shiny)
library(readxl)
library(ddplot)
library(plotly)

#Reading data from an excel spread sheet
Video_Games_Sales <- read_excel("C:/Users/sniss/OneDrive/Desktop/CSC 324/Data Set/Video_Games_Sales_as_at_22_Dec_2016.xlsx")

#Cleaning data to give year as a numeric variable rather than catagorical
clean<-select(filter(mutate(Video_Games_Sales, year=as.integer(Year_of_Release)), !is.na(year)& !is.na(Genre)), -c(Year_of_Release))

#Getting all the games with a Common Rating used in over 95% of cases 
ratings<-filter(clean, Rating=="M"| Rating=="E"| Rating=="T"|Rating=="E10+"& !is.na(Rating))

#Groups the dataframe by year in ascending order
groupedbyyear<-clean%>%group_by(year)%>%arrange(year)
#Reduces the dataframe to the name,year and global sales of every game then arranges them into alphabetic order 
salesperyearbyname<-arrange(ddply(groupedbyyear,.(Name,year),colwise(sum,.(Global_Sales))),Name)
#Adds the total cumulative sales of games through every year avaible 
cumulative<-salesperyearbyname%>%group_by(Name)%>%mutate(Cumulative_Sales=cumsum(Global_Sales))
# Ranks the games per year based on cumulative sales
cumulative%>%
  group_by(year)%>%
  mutate(rank = rank(-Cumulative_Sales),
         Cumulative_Sales_rel = Cumulative_Sales/Cumulative_Sales[rank==1],
         Cumulative_Sales_lbl = paste0(" ",round(Cumulative_Sales/1e9)))%>%
  group_by(Name)%>%
  filter(rank<=10)%>%
  ungroup()->
  rankedbysalesperyear

#Produces a tile graph that transitions through years changing the top spot according to the rankings.
staticplot <-ggplot(rankedbysalesperyear, aes(rank, group = Name, 
                                       fill = as.factor(Name), color = as.factor(Name))) +
  geom_tile(aes(y = Cumulative_Sales,
                height = Cumulative_Sales*2,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(Name, " ")), vjust = 0.2, hjust = 1) +
  geom_text(aes(y=Cumulative_Sales,label = Cumulative_Sales, hjust=0),alpha = .3,color="Black") +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = "none", fill = "none") +
  transition_states(year,transition_length=4,state_length=1 )+
  theme(axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.grid.major.x = element_line( size=.1, color="grey" ),
        panel.grid.minor.x = element_line( size=.1, color="grey" ),
        plot.title=element_text(size=25, hjust=0.5, face="bold", colour="grey", vjust=-1),
        plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="grey"),
        plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
        plot.background=element_blank(),
        plot.margin = margin(2,4, 2, 11, "cm"))+
  view_follow(fixed_x = TRUE)  +
  labs(title = 'Top Games per Year : {closest_state}',  
       subtitle  =  "Top 10 Games",
       caption  = "Cumulative Sales in Millions | Data Source: Video Game Sales Data")

#Makes the animation larger and longer in duration, used by the dashboard
anim_save("TopSellsData.gif", animate(staticplot, height=800, width=1800,fps=25,duration = 40))

#Creates an animation that plots every game based on the User and Critic Scores, Size based on sales and color based on genre
totalplot<-ggplot(
  clean, aes(x= (User_Score*10), y = Critic_Score))+
  geom_point(data = clean,aes(color=Genre,size=Global_Sales), alpha= .5)+
  guides(color=guide_legend(override.aes = list(size=15)))+
  theme(text = element_text(size=20),legend.key.size = unit(1,"cm"))+
  scale_size(range=c(2,100),guide="none")+
  transition_time(year,range = c(1996L,2016L))+
  labs(x="User Score", y="Critic Score",title = "Year of Release: {frame_time}")

#Creates a larger animation to split the screen with the next and makes it longer in duration
anim_save("GameSalesData.gif", animate(totalplot, height=950, width=950,fps=25,duration = 30))

#Creates a similar animation as above but it's faceted into the most common Ratings given to games
salesbyrating<-ggplot(
  ratings, aes(x= (User_Score*10), y = Critic_Score))+
  geom_point(data = ratings,aes(color=Genre,size=Global_Sales), alpha= .5)+
  guides(color=guide_legend(override.aes = list(size=10)))+
  theme(text = element_text(size=20),legend.key.size = unit(1,"cm"))+
  facet_wrap(~Rating,ncol=2)+
   scale_size(range=c(2,40),guide = "none")+
   transition_time(year,range = c(1996L,2016L))+
   labs(x="User Score", y="Critic Score",title = "Year of Release: {frame_time}")

#Creates a larger animation to split the screen with the previous and makes it longer in duration
 anim_save("gamesalesbyrating.gif", animate(salesbyrating,height=950,width=950,fps=25, duration = 30))


