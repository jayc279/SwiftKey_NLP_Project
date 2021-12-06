## https://stackoverflow.com/questions/12626637/read-a-text-file-in-r-line-by-line
# Function to read "number of lines" from a text file
#
# @param file 			path to Text File
# @param num 			Number of lines to read from text file
# @param printLines 	print lines read, default is FALSE
#
# @return Number of lines read from file
#
#
# @examples 
# To read all lines from the Text File
# processLines(file="fileName", num=Inf)
#
# To read a set number of lines - say 10
# processLines(file="fileName", num=10)
# 
# No lines are read if num is 0 or less than 0

processLines <- function(file, num = 10 , printLines=FALSE) {
	con <- file(file, "r")

	## Break if Number of lines to read is '0' or less
	if ( num <=0 ) {
		close(con)
		stop("ERROR: Invalid Number of lines given to process")
	}

	## Read line from file
    ## readLines(con) : Use SkipNul to skip reading lines containing embedded null
	if ( num != Inf ) { 
		line <- readLines(con, n = num, skipNul=T, warn=F, encoding="UTF-8")
	} else {
		line <- readLines(con, skipNul=T, warn=F, encoding="UTF-8")
	}

	## Close File Connection
	on.exit(close(con))
	## close(con)

	## If all checks passed print line - limit to 20 if num > 20
	if ( printLines ) {
		if ( num > 20 ) { lnum = 20 } else { lnum = num }
		for (i in 1:lnum) {
			cat("Cnt: ", i, "Line: ", line[i],"\n")
		}
	}

	## Return Lines Read from file
	return(line)

}
