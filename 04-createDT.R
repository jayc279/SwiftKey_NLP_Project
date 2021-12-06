## Jay Yanamandala
## Dec 06, 2021
#######################################################################
## Create data.table for Shiny App

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

## Load profanity words
load("rdata/profane_words.RData")

## load ngrams for news, blogs, and twitter ------------------------------------------------------
## news_quadgram
load("rdata/news_quadgram.RData")

## blogs_quadgram
load("rdata/blogs_quadgram.RData")

## twitter_quadgram
load("rdata/twitter_quadgram.RData")
## End load ngrams for news, blogs, and  twitter ---------------------------------

## Combine all Data Frames into one and update Count -----------------------------

df_list <- list(news_quadgram, blogs_quadgram, twitter_quadgram)
all_ngrams <- df_list %>% reduce(full_join, by='ngrams')

rm(news_quadgram,twitter_quadgram,blogs_quadgram) 	## clean up memory

## Rearrange columns to ngrams, twit, blog news
all_ngrams <- all_ngrams %>% select(ngrams, twit, blog, news)

setDT(all_ngrams)												## Convert to Data Table
save(all_ngrams,file="rdata/all_ngrams.RData")					## save to not loose data

## create 'total' totals count
all_ngrams <- transform(all_ngrams, total = rowSums(all_ngrams[, 2:4], na.rm = TRUE)) %>% arrange(desc(total))

## sort and bring all_ngrams down to 500000
all_ngrams <- all_ngrams[1:500000, ]	## you can also limit by 'total' number 
										## all_ngrams <- all_ngrams[(all_ngrams$total > 2) , ]
## Copy column ngrams to words
all_ngrams <- all_ngrams %>% mutate(words = ngrams)

## Split ngrams to individual words
all_ngrams <- all_ngrams %>% separate(words, c("w1","w2","w3","w4"), sep=" ")

## Convert NA to 0 in dataframe
all_ngrams <- all_ngrams %>% mutate(across(where(is.numeric), ~ ifelse(is.na(.), 0, .)))

## remove ngrams, twit, blog, news from table
## # all_ngrams[, ngrams:=NULL]
## # all_ngrams[, twit:=NULL]
## # all_ngrams[, blog:=NULL]
## # all_ngrams[, news:=NULL]
subset(all_ngrams, select = -c(ngrams, twit, blog, news) )

## Convert dataframe to datatable
save(all_ngrams,file="rdata/all_ngrams_app.RData")
## save(all_ngrams,file="rdata/all_ngrams_dt.RData")

## End combine all Data Frames into one and update Count -------------------------
## End Data Wrangling and Text Mining of twitter ---------------------------------
