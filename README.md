# video-game-data-visualization
Visualization of Game Sales using data gathered from kaggle
I am only using the video_games_sales file as the other two files did not mesh well with eachother.

# Purpose
I wanted to visualize this data to try and find if there were relationships between certain traits of a game and the overall success of that game. This came through in the form of a few animations relating critical and user scores to the overall global sales of a given game, I also broke it down by the most common ratings given out by the ESRB which includes M,T,E10+, and E. I also created an interative set of plots in order to see various stats such as the min,max, median and percentiles of different catagorical variables compared by some numeric variables.

# Data Description
The data from Kaggle included roughly 17 thousand rows of data from 1980 to 2020. There were a number of variables included such as name, year of release, Sales data from various regions and the ratings the games recieved from critics and users alike. There are some repeat games and I assume that's due to some sort of rerelease of the game on a different platform or some similar phenomenom.

# How the Data was collected
According to the author of the data set on kaggle "Motivated by Gregory Smith's web scrape of VGChartz Video Games Sales, this data set simply extends the number of variables with another web scrape from Metacritic. Unfortunately, there are missing observations as Metacritic only covers a subset of the platforms."

# Who is this for?
I didn't intend a very specific target audience but this is for anyone who wants to see how trends have evolved in gaming and how they might use that info to create a game with a high probability of doing well. This is also for people who are just interested in how gaming has evolved througout the roughly 40 years of data avaliable.

# Questions I wanted to Answer
1. What genre of games sells the best with the best reviews and is there a particular genre that consistently stands above the rest?

2. What types of games sell the best based on their ratings?

3. Is there a way to optomize what type of game someone creates to get the most sells?

# Insights
After creating my graphs and animations I discovered some pretty important things about how games change through the years. Specifically there tends to be a trend where a particular genre may do very well in sales, user and critical scores for a year or a few years, then its replaced by a different genre. This phenomenon tends to happen the later in years you get likely due to a greater amount of sales data being generated as compared to the early days. I also learned that there are defiently genre trends withing ratings. Genres that could be considered more mature tended to do way better in more mature ratings where as more family friendly genres did well in the less mature ratings. I dont think I can conclusively say there was a way to tell what an optimal game might look like due to the fact that genres popularities tended to rise and dip through different years.

# Improvements
I think I could improve the overall look of my dashboard since it seems kind of basic in my opinion. I also would love to improve the data set as sometimes it felt somewhat incomplete or lacking in various areas which made it more difficult to work with. I also would stay away from animations in the future as it takes a ridiculous time to render gifs for the graphs often taking 15-20 minutes for all 3 on a good day.

# Sources and Resources

Data: https://www.kaggle.com/sidtwr/videogames-sales-dataset
Dashboard insperation: https://towardsdatascience.com/create-an-interactive-dashboard-with-shiny-flexdashboard-and-plotly-b1f025aebc9c
Class Resources: 
Textbook: Visualization Analysis and Design. Munzner, Tamara, and Eamonn Maguire. Visualization Analysis & Design. Boca Raton, FL: CRC Press/Taylor & Francis Group, 2015. Web.
Textbook: Richards, Mark (W. Mark), and Neal Ford. Fundamentals of Software Architecture : an Engineering Approach. First edition. Sebastopol, CA: O’Reilly Media, Inc., 2019. Print.
Textbook: Dooley, John F. Software Development, Design and Coding With Patterns, Debugging, Unit Testing, and Refactoring. 2nd ed. 2017. Berkeley, CA: Apress, 2017. Web.
R for Data Science. Hadley Wickham & Garrett Grolemund. Free online book.
Advanced R. Hadley Wickham. Free online book.
RStudio Tutorial, Learn Shiny.
Mastering Shiny. Hadley Wickham. Free online book.
(Recommended) Tufte, Edward R. The Visual Display of Quantitative Information. Cheshire, Conn: Graphics Press, 1983. Print.