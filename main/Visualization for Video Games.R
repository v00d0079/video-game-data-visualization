library(tidyverse)
library(plyr)
library(dplyr)
library(readxl)
library(gganimate)
library(shiny)
library(shinydashboard)
library(qrcode)

Video_Games_Sales <- read_excel("C:/Users/sniss/OneDrive/Desktop/CSC 324/Data Set/Video_Games_Sales_as_at_22_Dec_2016.xlsx")
Ps4_Games_Sales <- read_excel("C:/Users/sniss/OneDrive/Desktop/CSC 324/Data Set/PS4_GamesSales.xlsx")
Xbox1_Games_Sales <- read_excel("C:/Users/sniss/OneDrive/Desktop/CSC 324/Data Set/XboxOne_GameSales.xlsx")
top_selling_xbox<-Xbox1_Games_Sales %>% group_by(Year) %>% slice(which.max(Global))




#View(Video_Games_Sales)
#View(Ps4_Games_Sales)
#View(Xbox1_Games_Sales)
#view(top_selling_xbox)

filtered<-Video_Games_Sales%>% filter(!is.na(as.numeric(Year_of_Release)%%1==0))
clean<-filter(mutate(filtered, year=as.integer(Year_of_Release)), !is.na(year))
ratings<-filter(clean, Rating=="M"| Rating=="E"| Rating=="T"|Rating=="E10+"& !is.na(Rating))

SalesperPublisher<-ddply(clean,"Publisher",numcolwise(sum))
SalesperName<-ddply(clean,"Name",numcolwise(sum))

sumn<-clean %>%
  group_by(Publisher,Developer) %>%
  summarise(Publisher,Global_Sales,year)

regplot<-ggplot(
  ratings, aes(x= (User_Score*10), y = Critic_Score))+
  geom_point(data = ratings,aes(color=Genre,size=Global_Sales),alpha= .5)+
#  facet_wrap(~ Rating)+
  guides(color=guide_legend(override.aes = list(size=10)))+
  theme(legend.position = "bottom",legend.key.size =  unit(1,"cm"),legend.text = element_text(size=10))+
  scale_size(range=c(2,50),guide = "none")+
  labs(x="User Score", y="Critic Score",title = "Global Sales data")

JPN<-ggplot(
  ratings, aes((x=User_Score*10),y=Critic_Score))+
  geom_point(data=ratings,aes(color=Rating, size = JP_Sales),alpha=.5)+
  guides(color=guide_legend(override.aes = list(size=10)))+
  theme(legend.position = "bottom",legend.key.size = unit(1,"cm"),text=element_text(size=15))+
  scale_size(range=c(2,30),guide ="none")+
  labs(x="User Score", y="Critic Score",title = "Japan's Sales Data")

#filet<-"https://github.com/v00d0079/video-game-data-visualization"
#qrcode_gen(
#  dataString = filet,
#  ErrorCorrectionLevel = "M",
#  wColor = "purple")



totalplot<-ggplot(
  clean, aes(x= (User_Score*10), y = Critic_Score))+
  geom_point(data = clean,aes(color=Genre,size=Global_Sales), alpha= .5)+
  guides(color=guide_legend(override.aes = list(size=15)))+
  theme(text = element_text(size=20),legend.key.size = unit(1,"cm"))+
  scale_size(range=c(2,100),guide="none")+
  transition_time(year,range = c(1996L,2016L))+
  labs(x="User Score", y="Critic Score",title = "Year of Release: {frame_time}")
anim_save("GameSalesData.gif", animate(totalplot, height=950, width=950,fps=25,duration = 30))

salesbyrating<-ggplot(
  ratings, aes(x= (User_Score*10), y = Critic_Score))+
  geom_point(data = ratings,aes(color=Genre,size=Global_Sales), alpha= .5)+
  guides(color=guide_legend(override.aes = list(size=6)))+
  theme(text = element_text(size=15),legend.key.size = unit(.5,"cm"))+
  facet_wrap(~Rating,ncol=2)+
   scale_size(range=c(2,40),guide = "none")+
   transition_time(year,range = c(1996L,2016L))+
   labs(x="User Score", y="Critic Score",title = "Year of Release: {frame_time}")
#ratinggif<-animate(salesbyrating,height=1000,width=3000,fps=30, duration = 30)
 anim_save("gamesalesbyrating.gif", animate(salesbyrating,height=950,width=950,fps=25, duration = 30))

ui<-fluidPage(
      titlePanel("Animations"),
      
      sidebarLayout(
        sidebarPanel(
          helpText("Create demographic maps with 
        information from the 2010 US Census."),
          
          selectInput("var", 
                      label = "Choose a variable to display",
                      choices = c("Percent White", "Percent Black",
                                  "Percent Hispanic", "Percent Asian"),
                      selected = "Percent White"),

        ),
      mainPanel(
        tabsetPanel(
          id="panels",
          tabPanel("Overall Sales",
                   imageOutput("Sales")
          ),
          tabPanel("Sales by Ratings",
                   imageOutput("RatingsGraph")
          ))
    )
)
)
  


server <- function(input, output) {
  
  output$Sales <- renderImage({
    
   # anim_save("outfile.gif",animate(data, height=1080, width=1080,fps=30,duration = 1))
    
   list(src = "GameSalesData.gif",
         contentType = 'image/gif'
         # width = 400,
         # height = 300,
         # alt = "This is alternate text"
    )}, deleteFile = TRUE)
output$RatingsGraph <- renderImage({
  
  #anim_save("outfile.gif",animate(salesbyrating,fps=30, duration = 1))
  
  list(src = "gamesalesbyrating.gif",
       contentType = 'image/gif'
       # width = 400,
       # height = 300,
       # alt = "This is alternate text"
  )}, deleteFile = TRUE)}


shinyApp(ui, server)
#ggplot(Xbox1_Games_Sales, aes(x= Global, y = Year))+
 # geom_point()+ 
  #geom_point(data = top_selling_xbox %>% select(`North America`:Global,Year), aes(x = `North America`,y =Year), color = 'purple', size =3)


