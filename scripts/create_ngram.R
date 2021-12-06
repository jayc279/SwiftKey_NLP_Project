## Jay Yanamandala
## Dec 06, 2021
#######################################################################

## Function to create n-gram based on number
## Function: create_ngram
##	Args: df, num
##
##	create_ngram(news_df, 2)	## bigram
##	create_ngram(news_df, 3)	## trigram
##	create_ngram(news_df, 4)	## quadgram

## str_replace_all(word, "[^[:alpha:]]", " ")
## str_replace_all(word, "[[:punct:]]", "")
## str_trim(word)
create_ngram <- function(df, num) {
	df %>%
    unnest_tokens(word, word, token="ngrams", n=num) %>%
    anti_join(profane_words) %>%
    filter(str_detect(word, "[a-zA-Z]")) %>%
    count(word, sort=T)
    ungroup()
}
