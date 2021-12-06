## Jay Yanamandala
## Dec 06, 2021
#######################################################################

## Create tibble
library(parallel)
cl <- makeCluster(4,"PSOCK")

## Need to specify what variable to use in parallel function - if you don't specify "base" here parLapply will FAIL
clusterExport(cl,"vdocs")
parLapply(cl, 1:length(vdocs), function(x){
        vdocs <- tm_map(vdocs, content_transformer(tolower))
    }
)
 stopCluster(cl)


#######################################################################
clean_create_tibble <- function(vdocs) 
{

	vdocs <- VCorpus(VectorSource(vdocs$word))
	vdocs <- tm_map(vdocs, content_transformer(tolower))      # to lowercase
	vdocs <- tm_map(vdocs, stripWhitespace)      # Strip White Space
	vdocs <- tm_map(vdocs, content_transformer(gsub), pattern="\\W",replace=" ") ## remove EMOJIs

	removeURL <- function(x) gsub("http[^[:space:]]*", "", x) ## removeURLs
	vdocs <- tm_map(vdocs, content_transformer(removeURL))

	removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x) ## remove all non-English letters or space
	vdocs <- tm_map(vdocs, content_transformer(removeNumPunct))

	## removeHex <- function(x) gsub("[[:xdigit:][:space:]]*", "", x) ## Remove Hexadecimal Digits
	## vdocs <- tm_map(vdocs, content_transformer(removeHex))

	## removeAlNum <- function(x) gsub("[[:alnum:][:space:]]*", "", x) ## Remove Alpha Numeric Characters
	## vdocs <- tm_map(vdocs, content_transformer(removeAlNum))

	## removeCntrl <- function(x) gsub("[[:cntrl:][:space:]]*", "", x) ## Remove CNTRL characters
	## vdocs <- tm_map(vdocs, content_transformer(removeCntrl))

	vdocs <- tm_map(vdocs, PlainTextDocument)		## plain English Text

	return(vdocs)

}
