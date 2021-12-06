## Jay Yanamandala
## Dec 06, 2021
#######################################################################
## Data Exploratory Analysis -----------------------------------------------------------

## Load Needed libraries for Data Exploratory Analysis
suppressPackageStartupMessages(library(tm))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidytext))
suppressPackageStartupMessages(library(tibble))

#######################################################################
## Source R files to Process text file
source("scripts/processLines.R")
source("scripts/getFileInfo.R")

source("scripts/get_profanity.R")
## End source R files to create n-grams for DFs ------------------------------------------

## Remove profanilty words - we will not remove stop_words -------------------------------
## Need stop_words to form sentences to predict next word
## Get profanity words to delete from tibble datasets
profane_words <- get_profanity()

## Add a column to "profane_words" and convert to tibble -- if not we will get ERROR
## 		<error/rlang_error>
## 		`x` and `y` must share the same src, set `copy` = TRUE (may be slow).
profane_words$lexicon <- c("SMART")
profane_words <- as_tibble(profane_words)

## save profane_words to rdata/profane_words.RData
save(profane_words, file="rdata/profane_words.RData")

## Preliminary Data Analysis and Setup for Processing -----------------------------------
## Create tibbles and gather files information
news <- processLines(file = "data/news.txt", num = Inf)
news_df <- tibble(line=1:length(news), news)
names(news_df) <- c("line","word")
newsInfo<-getFileInfo(file = "data/news.txt", txtFile = news)

## Create blogs tibble
blogs <- processLines(file = "data/blogs.txt", num = Inf)
blogs_df <- tibble(line=1:length(blogs), blogs)
names(blogs_df) <- c("line","word")
blogsInfo<-getFileInfo(file = "data/blogs.txt", txtFile = blogs)

## Create twitter tibble
twitter <- processLines(file = "data/twitter.txt", num = Inf)
twitter_df <- tibble(line=1:length(twitter), twitter)
names(twitter_df) <- c("line","word")
twitterInfo<-getFileInfo(file = "data/twitter.txt", txtFile = twitter)

## Create data.frame with file size, length, longest line info
`File Size` <- c(newsInfo$FileSize,blogsInfo$FileSize,twitterInfo$FileSize)
`File Length` <- c(newsInfo$FileLength,blogsInfo$FileLength,twitterInfo$FileLength)
`Longest Line` <- c(newsInfo$LongestLineLength,blogsInfo$LongestLineLength,twitterInfo$LongestLineLength)

## Combine files into a dataframe
all_files_info <- data.frame(`File Size`, `File Length`, `Longest Line`)
row.names(all_files_info) <- c("News", "Blogs", "Twitter")
print(all_files_info)			## Print table 

#         File.Size File.Length Longest.Line
# News     196.2775       77259         5760
# Blogs    200.4242      899288        40833
# Twitter  159.3641     2360148          140

## Remove unneeded VARs from memory
rm(news, newsInfo,twitter,blogs,twitterInfo, blogsInfo)
## End Exploration -------------------------------------------------------------
