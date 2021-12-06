## Jay Yanamandala
## Dec 06, 2021
#######################################################################
## Create n-grams using tidy

## Load Needed libraries for Creating ngrams ---------------------------------------------
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(tm))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidytext))
suppressPackageStartupMessages(library(tibble))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(sqldf))
suppressPackageStartupMessages(library(tidyr))
suppressPackageStartupMessages(library(data.table))
## End Load Needed libraries for Creating ngrams -----------------------------------------

###################----------------------------------------------#########################
## Source R files to create n-grams for DFs ----------------------------------------------
source("scripts/create_ngram.R")

## Load profanity words
load("rdata/profane_words.RData")

## ----------------------------------------------------------------------------------------------
## For blogs and twitter we need to split file into 2 or 3 lengths and pick any -----------------
## For this project, picked first one - we could have tried a random split

## Begin Data Wrangling and Text Mining of twitter -------------------------------
## blogs - Split data into 3 and pick the first one to continue analysis	- nrow(blogs_df)  - 899288
blogs_split <- split( blogs_df, seq(nrow(blogs_df)) %/% (nrow(blogs_df) %/% 3))
blogs_df <- blogs_split[[1]]		## nrow(blogs_df) - 299761
save(blogs_df, file="rdata/blogs_df.RData")

## twitter - Split data into 3 and pick the first one to continue analysis	- nrow(twitter_df) - 2360148
twitter_split <- split( twitter_df, seq(nrow(twitter_df)) %/% (nrow(twitter_df) %/% 3))
twitter_df <- twitter_split[[1]]		## nrow(twitter_df)  - 786715
save(twitter_df, file="rdata/twitter_df.RData")
## End blogs and twitter we need to split file into 2 or 3 lengths and pick any --------------------

## Create ngrams for news, blogs, and twitter ------------------------------------------------------
## Create ngrams for news
news_quadgram <- create_ngram(news_df,4)
save(news_quadgram, file="rdata/news_quadgram.RData")

## Create ngrams for blogs
blogs_quadgram <- create_ngram(blogs_df,4)
save(blogs_quadgram, file="rdata/blogs_quadgram.RData")

## Create ngrams for twitter
twitter_quadgram <- create_ngram(twitter_df,4)
save(twitter_quadgram, file="rdata/twitter_quadgram.RData")
## End ngrams for news, blogs, and  twitter ---------------------------------

## Combine all Data Frames into one and update Count -----------------------------

## News
load("rdata/news_quadgram.RData")
names(news_quadgram) <- c("ngrams","news")
save(news_quadgram,file="rdata/news_quadgram.RData")

load("rdata/blogs_quadgram.RData")
names(blogs_quadgram) <- c("ngrams","blog")
save(blogs_quadgram,file="rdata/blogs_quadgram.RData")

load("rdata/twitter_quadgram.RData")
names(twitter_quadgram) <- c("ngrams","twit")
save(twitter_quadgram,file="rdata/twitter_quadgram.RData")

df_list <- list(news_quadgram, blogs_quadgram, twitter_quadgram)
all_ngrams <- df_list %>% reduce(full_join, by='ngrams')

rm(news_quadgram,twitter_quadgram,blogs_quadgram) 	## clean up memory
## nrow(all_ngrams)
## [1] 18751646

## Rearrange columns to ngrams, twit, blog news
all_ngrams <- all_ngrams %>% select(ngrams, twit, blog, news)

setDT(all_ngrams)												## Convert to Data Table
save(all_ngrams,file="rdata/all_ngrams.RData")					## save to not loose data

## create 'total total count
all_ngrams <- transform(all_ngrams, total = rowSums(all_ngrams[, 2:4], na.rm = TRUE)) %>% arrange(desc(total))

## sort and bring all_ngrams down to 500000
all_ngrams <- all_ngrams[1:500000, ]	## you can also limit by 'total' number 
										## all_ngrams <- all_ngrams[(all_ngrams$total > 2) , ]
## nrow[all_ngrams]
## 500000

## Copy column ngrams to words
all_ngrams <- all_ngrams %>% mutate(words = ngrams)

## Split ngrams to individual words
all_ngrams <- all_ngrams %>% separate(words, c("w1","w2","w3","w4"), sep=" ")

## Convert NA to 0 in dataframe
all_ngrams <- all_ngrams %>% mutate(across(where(is.numeric), ~ ifelse(is.na(.), 0, .)))

## Convert dataframe to datatable
setDT(all_ngrams)
save(all_ngrams,file="rdata/all_ngrams.RData")

## class(all_ngrams)
## [1] "data.table" "data.frame"

## head(all_ngrams)
##                   ngrams twit blog news total     w1   w2    w3     w4
## 1: thanks for the follow 2076    0    0 2076 thanks  for   the follow
## 2:        the end of the  478 1078  194 1750    the  end    of    the
## 3:       the rest of the  475  988  150 1613    the rest    of    the
## 4:         at the end of  403  968  195 1566     at  the   end     of
## 5:    for the first time  567  631  227 1425    for  the first   time
## 6:      at the same time  388  745  126 1259     at  the  same   time

## End combine all Data Frames into one and update Count -------------------------
## End Data Wrangling and Text Mining of twitter ---------------------------------

## Check all_ngrams and once satisfied with the results, clean it up for Shiny App (don't need all columns)
all_ngrams <- subset(all_ngrams, select=-c(ngrams, twit, blog, news))

## Rearrange columns - move total to end
all_ngrams <- select(all_ngrams, w1,w2,w3,w4,total)

head(all_ngrams)
#        w1   w2    w3     w4 total
# 1: thanks  for   the follow 2076
# 2:    the  end    of    the 1750
# 3:    the rest    of    the 1613
# 4:     at  the   end     of 1566
# 5:    for  the first   time 1425
# 6:     at  the  same   time 1259

save(all_ngrams,file="rdata/all_ngrams_app.RData") 					## Save for Shiny App

object.size(all_ngrams)												## Size of all_ngrams on disk
# 23006768 bytes  # 21MB


