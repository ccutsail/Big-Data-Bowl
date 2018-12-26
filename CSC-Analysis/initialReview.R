path <- 'C:/Users/ccuts/OneDrive/Documents/GitHub/Big-Data-Bowl/Data'

dfTrackingData <- data.frame()

for(file in list.files(path, recursive=TRUE)){
  if(grepl(pattern='games',x=file))
    dfGames <- read.csv(paste(path,'/',file,sep=''))
  if(grepl(pattern='players',x=file))
    dfPlayers <- read.csv(paste(path,'/',file,sep=''))
  if(grepl(pattern='plays',x=file))
    dfPlays <- read.csv(paste(path,'/',file,sep=''))
  if(grepl(pattern='track',x=file))
    if(ncol(dfTrackingData)==0)
      dfTrackingData <- read.csv(paste(path,'/',file,sep=''))
    else{
      dfTrackingData <- rbind(dfTrackingData, read.csv(paste(path,'/',file,sep='')))
    }
}

spdList <- group_by_at(drop_na(dfTrackingData,s), vars(one_of(c('nflId','gameId'))))  %>%
  summarise(mean=mean(s), sd=sd(s))

spdlist <- spdList[with(spdList, order(-mean)),]

dfCbd <- merge(x = spdList, y = dfPlayers, by = "nflId", all = TRUE)

dfCbd <- merge(x = dfCbd, y = dfGames, by = "gameId", all = TRUE)


ggplot(dfCbd, aes(x=PositionAbbr,y=mean, color=GameWeather)) + geom_point()