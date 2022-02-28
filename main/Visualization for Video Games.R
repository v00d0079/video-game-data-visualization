library(tidyverse)
library(plyr)
library(dplyr)
library(readxl)
library(gganimate)
library(shiny)
library(shinydashboard)
library(qrcode)

Video_Games_Sales <- read_excel("C:/Users/sniss/OneDrive/Desktop/CSC 324/Data Set/Video_Games_Sales_as_at_22_Dec_2016.xlsx")

#View(Video_Games_Sales)

filtered<-Video_Games_Sales%>% filter(!is.na(as.numeric(Year_of_Release)%%1==0))
clean<-filter(mutate(filtered, year=as.integer(Year_of_Release)), !is.na(year)& !is.na(Genre))
ratings<-filter(clean, Rating=="M"| Rating=="E"| Rating=="T"|Rating=="E10+"& !is.na(Rating))


mega<-clean%>%group_by(year)%>%arrange(year)
#mega%>%arrange("year")
idk<-arrange(ddply(mega,.(Name,year),colwise(sum,.(Global_Sales))),Name)
idk2<-arrange(ddply(mega,.(Publisher),colwise(sumn,.(Global_Sales))),Publisher)
ct<-count(clean,c("Name"))

SalesperPublisher<-arrange(ddply(clean,"Publisher",colwise(sum,.(Global_Sales))),desc(Global_Sales))
SalesperName<-arrange(ddply(clean,.(Name,Genre),numcolwise(sum)),desc(Global_Sales))
SalesperGenre<-arrange(ddply(clean,.(Genre),numcolwise(sum)),desc(Global_Sales))
SalesperPlatform<-arrange(ddply(clean,.(Platform),numcolwise(sum)),desc(Global_Sales))

sumn<-clean %>%
  group_by(Publisher,Developer,Name) %>%
  summarise(Name,Publisher,Global_Sales,Genre)
meansales<-mean(clean$Global_Sales)

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

Top25Publishers<-ggplot(
  head(SalesperPublisher,25),aes(x=Global_Sales,y=reorder(Publisher, +Global_Sales)))+
  geom_bar(stat="identity")+
  theme(text = element_text(size=20))+
  labs(x="Global Sales in Millions", y="Publisher", title="Top 25 Most Selling Publishers")

Top25Sales<-ggplot(
  head(SalesperName,25),aes(x=Global_Sales,y=reorder(Name, +Global_Sales)))+
  geom_bar(stat="identity",aes(fill = Genre))+
  theme(text = element_text(size=20))+
  labs(x="Global Sales in Millions", y="Name", title="Top 25 Most Selling Games")

TopGenre<-ggplot(
  SalesperGenre, aes(x=Global_Sales,y=reorder(Genre, +Global_Sales)))+
  geom_bar(stat = "identity",aes(fill = Genre, color="White"),show.legend = FALSE)+
  theme(text= element_text(size =20))+
  labs(x="Global Sales in Millions ",y="Genre", title="Top Selling Genre's")

TopPlatform<-ggplot(
  head(SalesperPlatform,10), aes(x=Global_Sales,y=reorder(Platform, +Global_Sales)))+
  geom_bar(stat = "identity")+
  theme(text= element_text(size =20))+
  labs(x="Global Sales in Millions ",y="Platform", title="Top Selling Platform's")


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
anim_save("GameSalesData.gif", animate(totalplot, height=950, width=950,fps=25,duration = 1))

salesbyrating<-ggplot(
  ratings, aes(x= (User_Score*10), y = Critic_Score))+
  geom_point(data = ratings,aes(color=Genre,size=Global_Sales), alpha= .5)+
  guides(color=guide_legend(override.aes = list(size=10)))+
  theme(text = element_text(size=20),legend.key.size = unit(1,"cm"))+
  facet_wrap(~Rating,ncol=2)+
   scale_size(range=c(2,40),guide = "none")+
   transition_time(year,range = c(1996L,2016L))+
   labs(x="User Score", y="Critic Score",title = "Year of Release: {frame_time}")
#ratinggif<-animate(salesbyrating,height=1000,width=3000,fps=30, duration = 30)
 anim_save("gamesalesbyrating.gif", animate(salesbyrating,height=950,width=950,fps=25, duration = 1))

ui<-dashboardPage(
    dashboardHeader( title="Game Sales"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Animations", tabName = "animations", icon = icon("th"))
      )
    ),
     dashboardBody(
       tabItems(
         tabItem(tabName = "dashboard",
                fluidPage(
                  sidebarLayout(
                    sidebarPanel(
                      helpText("Create graphs of top selling games based off of sales data from 1980-2020"),
                      
                      selectInput("var", 
                                  label = "Choose a variable to display",
                                  choices = c("Publishers", "Games","Genre","Platform"),
                                  selected = "Publishers"),
                    ),
                    mainPanel(plotOutput("bar",height = '600px',width = '1100px'))
                  )
                )
              ),
       
        tabItem( tabName = "animations",
         fluidPage(
            mainPanel(
            tabsetPanel(
              id="panels",
              tabPanel("Overall Sales",
                       imageOutput("Sales")
              ),
              tabPanel("Sales by Ratings",
                       imageOutput("RatingsGraph")
              )
             )
           )
          )
        )
       )
    )
)
  


server <- function(input, output) {
  
  output$bar <- renderPlot({
    data <- switch(input$var, 
                   "Publishers" = Top25Publishers,
                   "Games" = Top25Sales,
                   "Genre" = TopGenre,
                   "Platform" = TopPlatform)
    plot(data)
  })
  
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


