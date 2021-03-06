# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# SCATTERPLOTS

bd = read.csv("BoulderDaily.csv")
# Good variable names are very helpful.  But, we're going to be typing the name of this
# dataset alot, so short names are sometimes nice too
head(bd)
dim(bd)
summary(bd)

#It's hard to really understand what's happening with this data by just looking at these
#statistics.  Plotting can be really helpful with understanding the data.

?plot
plot(bd$tmin, bd$tmax)

# That's a pretty ugly plot.  Let's see if we can make it better

plot(bd$tmin, bd$tmax, pch = 16)

#Why 16?

?pch

# We can use all kinds of symbols with our plots

plot(bd$tmin, bd$tmax, pch="+")
plot(bd$tmin, bd$tmax, pch="a") #We should probably avoid some options, though

# There's alot of points on this graph, and it's hard to see what's happening.  Let's see if 
# we can make it any clearer.

# Sometimes, you need additional functions that aren't installed with R by default.  In this
# case, we want to install the "scales" package.  Note that you'll only need to install this
# once, then just use library() to load the code.

install.packages("scales") #adds a new package to your library
library(scales) #tells R to bring the objects from that library into your workspace.

# In this case, scales gives us the alpha() function:

plot(bd$tmin, bd$tmax, pch=16, col=alpha(colour="black", alpha=0.1))
plot(bd$tmin, bd$tmax, pch=16, col=alpha(colour="black", alpha=0.01))

# Using alpha=0.01 means that each point is 0.01 times the weight of a standard point.  So, if
# 100 points are on top of each other, we'll get a full black dot at that location.

# Where are most of the temperatures?
plot(bd$tmin, bd$tmax, pch=16, col=alpha(colour="black", alpha=1))
# Maybe between -20 and 80 for the min and 0 to 100 for max?
plot(bd$tmin, bd$tmax, pch=16, col=alpha(colour="black", alpha=0.04))
# Ah, most mins are between 10 and 70, and most maxes are between 20 and 100.

# Our titles don't make much sense:

plot(bd$tmin, bd$tmax, pch=16, col=alpha(colour="black", alpha=0.04), main="Temperature Plot"
  ,xlab="Minimum Temperature (degrees F)"
  ,ylab="Maximum Temperature (degrees F)")

# Let's add some pretty colors.

install.packages("RColorBrewer") #Package with nice colors.  See http://colorbrewer2.org/
library(RColorBrewer)
pal = brewer.pal(name="Spectral", n=10)
bd$colorGroup = floor( bd$tmax/10 )
bd$colorGroup[bd$colorGroup<1] = 1
plot(bd$tmin, bd$tmax, pch=16, col=alpha(colour=pal[bd$colorGroup], alpha=.1)
  ,main="Temperature Plot"
  ,xlab="Minimum Temperature (degrees F)"
  ,ylab="Maximum Temperature (degrees F)")

# Whoops!  pal is reversed.

pal = rev(pal)
plot(bd$tmin, bd$tmax, pch=16, col=alpha(colour=pal[bd$colorGroup], alpha=.1)
  ,main="Temperature Plot"
  ,xlab="Minimum Temperature (degrees F)"
  ,ylab="Maximum Temperature (degrees F)")

# What if we want to look at months individually?

?par
par(mfrow=c(3,4)) #Use a 3x4 grid
plot(bd$tmin, bd$tmax)
plot(bd$tmin, bd$tmax)
par(mfrow=c(3,4))
plot(bd$tmin, bd$tmax)

par(mfrow=c(3,4))
for(i in 1:12){
  temp = bd[bd$month==i,]
  plot(temp$tmin, temp$tmax, pch=16, col=alpha(colour=pal[temp$colorGroup], alpha=.1)
    ,main="Temperature Plot"
    ,xlab="Minimum Temperature (degrees F)"
    ,ylab="Maximum Temperature (degrees F)")
}

# It looks a bit weird because the scale keeps changing.

par(mfrow=c(3,4)) #Use a 3x4 grid
for(i in 1:12){
  temp = bd[bd$month==i,]
  plot(temp$tmin, temp$tmax, pch=16, col=alpha(colour=pal[temp$colorGroup], alpha=.1)
    ,main="Temperature Plot"
    ,xlab="Minimum Temperature (degrees F)"
    ,ylab="Maximum Temperature (degrees F)"
    ,xlim=c(-30,80), ylim=c(-10,110))
}

# Let's add a better label

months = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

par(mfrow=c(3,4)) #Use a 3x4 grid
for(i in 1:12){
  temp = bd[bd$month==i,]
  plot(temp$tmin, temp$tmax, pch=16, col=alpha(colour=pal[temp$colorGroup], alpha=.3)
    ,main=months[i]
    ,xlab="Minimum Temperature (degrees F)"
    ,ylab="Maximum Temperature (degrees F)"
    ,xlim=c(-30,80), ylim=c(-10,110))
}

# QUESTION!  Using the same dataset, examine the seasonal trends in temperature.
# Hints:
# - Use par(mfrow=c(1,1)) to return to a 1x1 plot grid (if you want)

# You may want to plot the same scatterplots above, but for each season.  For simplicity,
# let's say the seasons are Jan-Mar (Winter), Apr-Jun (Spring), Jul-Sep (Summer), Oct-Dec (Fall).]

ceiling( 1:12/3 )
seasons = c("Winter", "Spring", "Summer", "Fall")

par(mfrow=c(2,2))
for(i in 1:4){
  temp = bd[ceiling(bd$month/3) == i,]
  plot(temp$tmin, temp$tmax, pch=16, col=alpha(colour=pal[temp$colorGroup], alpha=.3)
    ,main=seasons[i]
    ,xlab="Minimum Temperature (degrees F)"
    ,ylab="Maximum Temperature (degrees F)"
    ,xlim=c(-30,80), ylim=c(-10,110))
}

# Or, if we didn't want to use ceiling()

#We'll store data in temp:
temp = matrix(nrow=0, ncol=ncol(bd))
temp

par(mfrow=c(2,2))
for(i in 1:12){
  #Append on data for the current month:
  temp = rbind(temp, bd[bd$month==i,])
  #Now, if i is 3, 6, 9, or 12 we want to plot the data.
  if(i%%3 == 0){
    plot(temp$tmin, temp$tmax, pch=16, col=alpha(colour=pal[temp$colorGroup], alpha=.3)
      ,main=seasons[i/3]
      ,xlab="Minimum Temperature (degrees F)"
      ,ylab="Maximum Temperature (degrees F)"
      ,xlim=c(-30,80), ylim=c(-10,110))
    #Also, remove the current values from the matrix of temp so we can plot next season
    temp = matrix(nrow=0, ncol=ncol(bd))
  }
}

# Or, we could look at trends over time
par(mfrow=c(1,1))
plot( bd$month + bd$day/31, bd$tmax, pch=16, col=alpha(colour="red", alpha=.05)
      ,xlab="Month of Year", ylab="Maximum Temperature", ylim=c(-20,110))
points( bd$month + bd$day/31, bd$tmin, pch=16, col=alpha(colour="blue", alpha=.05)
      ,xlab="Month of Year", ylab="Maximum Temperature")

# Note the vertical gaps in the plot.  These are because we're dividing days by 31 instead of
# converting the values to dates.  Here's a better approach:

bd$Date = paste(bd$year, bd$month, bd$day, sep="-")
head(bd)
is(bd$Date)
bd$Date = as.Date( bd$Date, format="%Y-%m-%d")
head(bd)
is(bd$Date)
bd$Day_Of_Year = as.character(bd$Date, format="%j") #Why %j?  This returns the day of year, i.e. 1-366
head(bd)
is(bd$Day_Of_Year)
bd$Day_Of_Year = as.numeric(bd$Day_Of_Year)
is(bd$Day_Of_Year)

# Ok, back to plotting:

plot( bd$Day_Of_Year, bd$tmax, pch=16, col=alpha(colour="red", alpha=.05)
      ,xlab="Day of Year", ylab="Maximum Temperature", ylim=c(-20,110))
points( bd$Day_Of_Year, bd$tmin, pch=16, col=alpha(colour="blue", alpha=.05)
      ,xlab="Day of Year", ylab="Maximum Temperature")

#No more vertical lines!  Another check:

hist( bd$Day_Of_Year, breaks=0:366 )

# Only 366 looks substantially smaller than the others, which makes sense since 366 will only
# happen on leap years.