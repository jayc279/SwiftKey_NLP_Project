## Jay Yanamandala
## Dec 06, 2021
#######################################################################

## Setup to parallel process clean_create_corpus function ----------------------------------
## Function: clean_create_corpus
## Argument: a VCorpus(VectorSource) file
## Return: a cleaned and sanitized VCorpus(VectorSource) file
## Next step: create TextMiningDocument  with bigrams, trigrams, and ngrams for further processing

clean_create_corpus <- function(vdocs)
{

	require(tm)
	require(RWeka)

	## CORPUs need to be created outside function
	## ## Create Corpus from Tibble for txt mining
	## tryCatch( {vdocs <- VCorpus(VectorSource(df$word)); print("vdocs created") }
	## 		,stop("Error: vdocs not created") )

	## Load 'parallel' library	- You can also load in MAIN script if you prefer
	require(parallel)

	## Deletect number of cores (on m/c 12) and set 4 less 
	n_cores <- detectCores() -4

	## On windows need to set type to 'PSOCK' on MAC/Linux - SOCK -or- FORK (please read documentation to use)
    cl <- makeCluster(n_cores, type="PSOCK")
	
	## Need to add needed library for use in any "par*" function in 'parallel' library
	## invisible is to suppress msgs when loading library
	invisible(clusterEvalQ(cl, library(tm)))

	## Must Export Variable that will be used in below "parLapply" function
	clusterExport(cl,"vdocs", envir = environment())

	## https://community.rstudio.com/t/tm-package-removing-unwanted-characters-works-in-r-but-not-knitr/26734
	## https://stackoverflow.com/questions/42103676/how-to-read-and-write-termdocumentmatrix-in-r
	parLapply(cl, 1, function(x) 
	{
	## tm_parLapply_engine(cl)

			## Remove spaces only at END
			vdocs <- tm_map(vdocs, content_transformer(tolower))		## to lowercase
			vdocs <- tm_map(vdocs, stripWhitespace)						## Strip White Space

			## Remove non-WORDs
		    removeNon <- function(x) gsub("\\W", "", x)
		    vdocs <- tm_map(vdocs, content_transformer(removeNon))

			## Remove any that STARTs wth http -or- ftp -or- 
		    removeURL <- function(x) gsub("http[^[:space:]]*", "", x) ## removeURLs
		    vdocs <- tm_map(vdocs, content_transformer(removeURL))

			## Remove "/", "@", "\\|" and sub with <SPACE>
			toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
			vdocs <- tm_map(vdocs, toSpace, "/")
			vdocs <- tm_map(vdocs, toSpace, "@")
			vdocs <- tm_map(vdocs, toSpace, "\\|")

            ## https://stackoverflow.com/questions/23864860/using-filter-in-tm-maptestfile-removenumbers-in-r
            ## Jabro Oct 20, 2020
		    removeNums <- function(x) gsub('\\s*(?<!\\B|-)\\d+(?!\\B|-)\\s*', "", x,perl=TRUE) ## removeURLs
			vdocs <- tm_map(vdocs, content_transformer(removeNums))                 ## Remove Numbers
			## vdocs <- tm_map(vdocs, content_transformer(removeNumbers))			## Remove Numbers
			vdocs <- tm_map(vdocs, stripWhitespace)						## Strip White Space

		}
	)
		
    ## stop cluster - will always run when functions - clean -or- error
	## tm_parLapply_engine(NULL)
	on.exit(stopCluster(cl))
	showConnections()	## will close all open connections

	return(vdocs)
}
