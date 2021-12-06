## Data Processing
### About the Corpora
The corpora are collected from publicly available sources by a web crawler. The crawler checks for
language, so as to mainly get texts consisting of the desired language*.  

The corpus data is provided by SwiftKey's Natural Language Processing (NLP) project, will be processed to create N-grams Given the size of text files provided for three corpus, and available machine architecture, project will be limited to creating bigrams, trigrams, and quadgrams to make predictions of next word that will most likely be typed by User.

Data was downloaded from [Coursera site](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)  

### Dataset Wrangling and Test mining
The raw data contains corpora in 4 different langauages, for this project only en_US locale files were downloaded. Text mining was implemented using the **tidy** libraries. Due to huge size of twitter and blog files, used only 33% of their size in this project. 

**Some details about the data:**  
*News   : File.Size: 196.2775 File.Length: 77259&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Longest.Line: 5760*  
*Blogs  : File.Size: 200.4242 File.Length: 899288&nbsp;&nbsp; Longest.Line: 40833*  
*Twitter: File.Size: 159.3641 File.Length: 2360148 Longest.Line: 140*  
  
* Datatable of quadgrams (ngrams=4) and their frequencies were processed using R.   
* Successfully implemented parallization of 'tm_map" and 'TermDocumentMatrix' but settled on 'tidy' since memory usage to create Corpus was very high.  
* Implement the Shiny app for this project, and the final object size of data table is 21MB.   
  
### List of Files  
- 01-data-download.R*
- 02-create-dfs.R*
- 03-create-ngrams.R*
- 04-createDT.R*

- scripts/clean_create_corpus.R*
- scripts/clean_tibble.R*
- scripts/create_ngram.R*
- scripts/extFiles.R*
- scripts/getFileInfo.R*
- scripts/get_profanity.R*
- scripts/processLines.R*

- rdata/all_ngrams_app.RData*
- rdata/common_words.RData*
- rdata/profane_words.RData*

[Shiny App](https://jyanamandala.shinyapps.io/swiftkey_next_word_prediction)  

### References:
* [Text Mining with R (Julia Silge & David Robinson](https://www.tidytextmining.com/index.html)
* [The Life-Changing Magic of Tidying Text | Julia Silge](https://juliasilge.com/blog/life-changing-magic)

