## Jay Yanamandala
## Dec 06, 2021
#######################################################################

# get list of profanity words from github repository
get_profanity <- function() {
    file_url <- "https://raw.githubusercontent.com/RobertJGabriel/Google-profanity-words/master/list.txt"

    profane_words <- read.table(
        file=file_url,          ## URL of text file
        header = F,             ## Do not read Header -- no header exists for text file but safe to add
        col.names = "word"      ## Change column name from "V1" to "word"
    )

    return(profane_words)
}
