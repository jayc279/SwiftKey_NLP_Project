## Jay Yanamandala
## Dec 06, 2021
#######################################################################
## Load Needed libraries for Data Exploratory Analysis
suppressPackageStartupMessages(library(tm))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(tidytext))
suppressPackageStartupMessages(library(tibble))

## Exract ZIP file for NLP project - 3 files based on locale will be extracted
## For e.x. locale - en_US, files extracted - twitter.txt, blogs.txt, news.txt
zipFile <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"	## pointer to zip file
source("scripts/extFiles.R")								## Source file to download en_US.* files only
extFiles(zpath=zipFile, datadir="data", lname="en_US")		## download files
