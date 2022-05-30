
#Define diretório de trabalho e importa as bibliotecas necessárias
setwd("D:/Data_Science/Projetos")
library(rtweet)
library(dplyr)
library(SnowballC)
library(tm)

#baixa tweets com a biblioteca rtweet
tweetdata <- search_tweets("Champions", n = 10000,
                           include_rts = FALSE,
                           token = NULL, lang='pt')

head(tweetdata)


# Tratamento (limpeza, organização e transformação) dos dados coletados
sub <- function(x){
  y <- gsub("[^\x01-\x7F]", "",x)
  y <- gsub("/", "",y)
  y <- gsub("@", "",y)
  y <- gsub("\\|", "",y)
  return(y)
}

tweetlist <- data.frame(tweetdata$text)
tweetlist <- data.frame(apply(tweetlist,1,sub))
tweetcorpus <- Corpus(VectorSource(tweetlist))
tweetcorpus <- tm_map(tweetcorpus, removePunctuation)
tweetcorpus <- tm_map(tweetcorpus, removeNumbers)
tweetcorpus <- tm_map(tweetcorpus, content_transformer(tolower))
tweetcorpus <- tm_map(tweetcorpus, function(x)removeWords(x, stopwords("portuguese")))
tweetcorpus <- tm_map(tweetcorpus, removeWords, c("pra","vai","ver","ter","champions","ser","vai","ttulo","fez","pro","est","sim","forest","voc","aps","nao","faz","quer")) 

# Convertendo o objeto Corpus para texto plano
tweetcorpus <- tm_map(tweetcorpus, PlainTextDocument)

#converter para dataframe
dtm <- TermDocumentMatrix(tweetcorpus)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

d1 <- d %>% filter(freq >= 12)

write.csv(d1, "tweets.csv")