# Install and Activate Packages
install.packages(c("twitteR", "RCurl", "RJSONIO", "stringr"))
library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)

# Declare Twitter API Credentials
api_key <- "Enter your API Key here" # From dev.twitter.com
api_secret <- "Enter your API secret here" # From dev.twitter.com
access_token <- "Enter your Access token" # From dev.twitter.com
access_secret <- "Enter your Access Secret" # From dev.twitter.com

# Create Twitter Connection
setup_twitter_oauth(api_key, api_secret, access_token, access_secret)

# Run Twitter Search. Format is searchTwitter("Search Terms", n=100, lang="en", geocode="lat,lng", also accepts since and until).
tweets <- searchTwitter("American Airlines", n=1000,  since="2014-01-01",lang="en")

# Transform tweets list into a data frame
tweets.df <- twListToDF(tweets)
View(tweets.df)

#NLP (Text mining)
require(slam)
require(XML)
require(tm)
require(RWeka)
require(tau)
require(tm.plugin.webmining)
require(wordcloud)
require(RColorBrewer)

t <- as.character(tweets.df$text)
usableText=str_replace_all(tweets.df$text,"[^[:graph:]]", " ") 
t <- usableText

#data cleansing
ap.corpus <- Corpus(VectorSource(t))
ap.corpus <- tm_map(ap.corpus, PlainTextDocument)
ap.corpus <- tm_map(ap.corpus, removePunctuation)
ap.corpus <- tm_map(ap.corpus, content_transformer(tolower))

#remove URL from the text
removeURL <- function(x) gsub("http[[:alnum:][:punct:]]*","",x)
ap.corpus <- tm_map(ap.corpus, content_transformer(removeURL))
ap.corpus <- tm_map(ap.corpus, removeWords, c(stopwords("english"),"rt","it","retweet","violin","musician","drake","club","zakshawaii"))
wordcloud(ap.corpus,random.order=FALSE,scale=c(3,0.5),col=rainbow(15),max.words=80) 

