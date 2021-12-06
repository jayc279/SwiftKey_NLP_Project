## Jay Yanamandala
## Dec 06, 2021
#######################################################################

# Function to print the following for file
# file size
# length of file
# Longest line in file
#
# @param file 			path to Raw Text File
# @param txtFile 		path to Processed Text File
#
# prints filesize, length of txtFile, Line with MAX characters
#
# @examples 
# grep_pattern(file="data/twitter.txt", txtFile=read_twitter)
#

getFileInfo <- function(file, txtFile) {

	## Print size of file
	fileSize <- as.numeric(file.info(file)$size / 1024^2)
    ## sprintf("File Size: %f", fileSize)

	## Print length of file
	fileLength <- as.numeric(length(txtFile))
	## sprintf("File Size: %d", fileLength)

	## Print Longest line
    fileMaxLine <- as.numeric(summary(nchar(txtFile)))
    fileLongLine <- fileMaxLine[length(fileMaxLine)]
	## sprintf("Longest Line Length: %d", fileLongLine)

	cat("File Size:", fileSize, "\nFile Length: ", fileLength, "\nLongest Line Length: ", fileLongLine)
	retList <- list("FileSize"=fileSize, "FileLength"=fileLength, "LongestLineLength"=fileLongLine)
	return(retList)
    
}
