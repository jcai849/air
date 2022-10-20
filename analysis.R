# Data Expo 2009: Airline on time data
# https://doi.org/10.7910/DVN/HG7NV7
# https://support.microsoft.com/en-gb/office/excel-specifications-and-limits-1672b34d-7043-467e-8e27-269d656771c3
# Excel max: 1,048,576 rows

# Analysis:

# - Find the mean arrival delay for each destination airport, by day of week
# - What are the full names of the top 5 carriers overall?
# - Plot of mean carrier delay over time (Check if worse on Saturdays)
# - Export all of the above for reporting purposes

# Import, functions

df <- read.csv("2008.csv") # unable to be opened in excel
str(df)

# Basic manipulation

1+1
x <- 1
x + 1
x + x
1:10
1:10 + x
y <- 1:10
z <- y * y
z[1:3]
c(z[1:3], x[1:4])

# Selection, more functions

sum(df$Cancelled) # ?sum

sort(table(df$UniqueCarrier), decreasing=TRUE)[1:5]

table(df$Dest, df$Cancelled)

# Data Manipulation

mean_delay <- aggregate(df$ArrDelay, df[,c("Dest", "DayOfWeek")], mean, na.rm=T)

carriers <- read.csv("carriers.csv")

named_df <- merge(df, carriers, by.x="UniqueCarrier", by.y="Code")
top5 <- sort(table(named_df$Description), decreasing=TRUE)[1:5]

mondays <- df[df$DayOfWeek == 1,]

# Column Creation

df$dates <- as.Date(paste(df$Year, df$Month, df$DayofMonth, sep="-"))

# Graphics

png("weather-delay.png")
date_delay <- aggregate(df$CarrierDelay, list(dates=df$dates), mean, na.rm=T)
plot(date_delay, type="l",
     main="Average Carrier Delay over Time", xlab="Date", ylab="Mean Delay (mins)")
abline(v=date_delay$dates[weekdays(date_delay$dates) == "Saturday"], col="red")
legend("bottomright", legend="Saturday", col="red", lty=1)
dev.off()

# Export

write.table(top5, file="top5.csv",
            row.names=F, col.names=c("Carrier", "Count"), sep=",")
write.table(mean_delay, file="mean_delay.csv",
            row.names=F, col.names=c("Destination", "Day of Week", "Mean Delay"),
            sep=",")

# Scripting, automation, packages, etc.
# https://cran.r-project.org/doc/manuals/r-release/R-intro.html