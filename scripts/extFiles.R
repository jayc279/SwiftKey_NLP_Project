## Jay Yanamandala
## Dec 06, 2021
#######################################################################

## https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip
## Files to extract for local - en_US, de_DE, ru_RU, fi_FI
#' Function to extract specific file from zip file
#'
#' @param zpath 		path to ZIP file
#' @param datadir 		Directory to extract the spaecifc file
#' @param lname 		Name of file to extract
#'
#' Extract 3 files - blogs.txt, news.txt, and twitter.txt for specific locale
#'
#' @examples 
#' To read all lines from the Text File
#' extFiles(zpath="https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",
#'	datadir="data", lname="en_US")
#'

extFiles <- function(zpath, datadir="data", lname)
{
	## Check and create datadir directory to copy file
	cwdir <- getwd()
	datadir <- paste0(cwdir,"/",datadir)
	if (! dir.exists(datadir) ) {
		dir.create(datadir)
	}
	
	## Set limit to download and extract
	options(timeout=180)

	## Download file and extract
	tempfname <- paste0(datadir,"/tempfile.zip")

	download.file(url=zpath, destfile=tempfname, method="curl", quiet=T)
	if (! file.exists(tempfname) ){
		stop("ERROR: issue with unzipping files")
	}

	## List of files names to extract
	fnames <- c("twitter.txt", "blogs.txt", "news.txt")

	## Create file names to Extract
	for ( fl in fnames ) {
		fname <- paste0("final/",lname,"/",lname,".",fl)
		dffname <- paste0(datadir,"/final/",lname,"/",lname,".",fl)
		fdir <- paste0(datadir,"/final")
		dfname <- paste0(datadir,"/",fl)

		## cat("zipfile =", tempfname, "files= ",fname, "exdir= ", datadir, "DataFile: ",dfname,"\n")	
		unzip(zipfile=tempfname, files=fname, exdir=datadir)

		## Move file from "datadir/fname" to "datadir/fl"
		if ( file.exists(dfname) ) {
			file.remove(dfname)
		}

		## Rename file - actually move fname to dfname
		file.rename(from=dffname, to=dfname)

		## Check if file exists in datadir
		if (! file.exists(dfname) ) {
		 	stop("ERROR: issue with unzipping files")
		}

	}

	## Remove TEMP file and final directory
	unlink(tempfname, recursive=T, force=T)
	unlink(fdir, recursive=T, force=T)

}
