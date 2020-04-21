library(ggplot2)


#Load the data and name it vote
load("~/Dropbox/Notability/Data Mgmt and Prog R and SAS/homework/code review/Congress99.rdata")
vote <- dat99
rm(dat99)       #data: vote
#Rename the column name: mainly on legistors
colnames(vote) <- c("year", "roll_number", "issue", "question", "result", "title_or_description", "vote_result", "party", "name", "role", "state", "metadata", "parsed_date")


#1. How many representatives does each party have in the 1999 Congress?
voteNP <- unique(vote[,8:9])
table(voteNP$party)
#Create a stacked barplot to show the distribution of diferent parties.
countsNP <- as.data.frame(table(voteNP$party))
colnames(countsNP) <- c("party", "Freq")
ggplot(data=countsNP, aes(x=party, y=Freq, fill=party)) +
  geom_col()+
  ggtitle("Barplot of Parties")


#2. How many representatives does each party have in each state?
votePS <- unique(vote[, c(8, 9, 11)])
xtabs(~party+state, data=votePS)
#Create a stacked barplot to show the distribution of diferent parties in different states.
countsPS <- as.data.frame(xtabs(~party+state, data=votePS))
ggplot(data=countsPS, mapping = aes(x = state, y = Freq, fill = party))+
  geom_col()+
  ggtitle("Party vs. States")


#3. What is the propensity of each member to vote by party lines? That is, that he/she voted in the same way as the majority of people in his/her party, and opposed to the majority of the voters from the other party.
#voteRResult: vote(roll_number) + member(name, party) + vote_result
voteRResultPN <- vote[, c(2, 7:9)]

#Regroup the vote_result: aggregate (Aye+Yea)=Y, (Nay+No)=N; rename (Not Voting)=NV, (Present)=P
voteRResultPN$result[(voteRResultPN$vote_result=="Aye")|(voteRResultPN$vote_result=="Yea")] <- "Y" 
voteRResultPN$result[(voteRResultPN$vote_result=="Nay")|(voteRResultPN$vote_result=="No")] <- "N" 
voteRResultPN$result[voteRResultPN$vote_result=="Not Voting"] <- "NV" 
voteRResultPN$result[voteRResultPN$vote_result=="Present"] <- "P" 

#Check which votes(roll_numbers) are invalid.
nrow(voteRResultPN[(voteRResultPN$vote_result=="")|(voteRResultPN$party=="")|(voteRResultPN$name==""),])
##Roll_number from 1 to 99 are invalid, which must be deleted later.
#Create a table to show the majority (each party for each vote).
roll_number <- NA
D <- NA
R <- NA
I <- NA
for (i in 100:611) {
  groups <- as.data.frame(xtabs(~party+result,data=voteRResultPN[voteRResultPN$roll_number==i,]))
  roll_number[i] <- i
  D[i] <- as.character(groups$result[(groups$party=="D")&groups$Freq==max(groups$Freq[groups$party=="D"])])
  R[i] <- as.character(groups$result[(groups$party=="R")&groups$Freq==max(groups$Freq[groups$party=="R"])])
  I[i] <- as.character(groups$result[(groups$party=="I")&groups$Freq==max(groups$Freq[groups$party=="I"])])
}
majority <- as.data.frame(cbind(roll_number, D, R, I))
majority <- majority[(100:611),]
#table propensity: add the major of vote_result for each party to voteRResultPN
propensity <- merge(majority, voteRResultPN[, c(1, 3:5)], by.x = "roll_number", by.y = "roll_number", all=TRUE)
propensity <- na.omit(propensity)   #there are 99 invalid roll_numbers
propensity$majority[propensity$party=="D"] = as.character(propensity$D[propensity$party=="D"])
propensity$majority[propensity$party=="R"] = as.character(propensity$R[propensity$party=="R"])
propensity$majority[propensity$party=="I"] = as.character(propensity$I[propensity$party=="I"])
#Create propensity_majority: name(of members) + CountsAll(#participated votes) + CountsPro(#vote_results==majority) + rate
name <- unique(vote[,9])
CountsAll <- NA
CountsPro <- NA
for (i in 1:length(name)) {
  groups <- propensity[propensity$name==name[i],]
  CountsAll[i] <- nrow(groups)
  CountsPro[i] <- sum(groups$result==groups$majority)
}
propensity_majority <- as.data.frame(cbind(as.character(name), CountsAll, CountsPro))
propensity_majority$ProRate <- as.numeric(propensity_majority$CountsPro)/as.numeric(propensity_majority$CountsAll)
colnames(propensity_majority) <- c("name", "CountsAll", "CountsPro", "ProRate")
propensity_majority


#4. Voting outcomes – how many votes passed/failed/other? How many votes were determined by party affiliations? (that is, votes in which the majority from one party were “yea”, while the majority from the other party was “nay”.)
#Regroup the result into 3 groups: Passed, Failed, Other.
affiliation <- merge(unique(propensity[,1:3]), unique(vote[,c(2, 5)]), by.x = "roll_number", by.y = "roll_number")
affiliation$Result[affiliation$result=="P"] = "Passed"
affiliation$Result[affiliation$result=="F"] = "Failed"
affiliation$Result[!((affiliation$result=="P")|(affiliation$result=="F"))] = "Other"
#Summary the voting outcomes.
table(affiliation$Result)
countsNP <- as.data.frame(table(affiliation$Result))
colnames(countsNP) <- c("Result", "Freq")
ggplot(data=countsNP, aes(x=Result, y=Freq, fill=Result)) + geom_col()
#Count the votes based on affiliations. Include N/Y only.
sum((affiliation$D=="Y"&affiliation$R=="N")|(affiliation$D=="N"&affiliation$R=="Y"))


#5. Find a way to summarize the votes by issue (again, an issue may be split into multiple votes).
voteI <- vote[,2:3]
voteI <- unique(voteI)
w <- NA
Q5 <- function(x){
  w <- c(w, x)
  return(w[-1])
}
voteI$issue <- as.character(voteI$issue)
#1.Delimiter = "|"
issue_roll <- tapply(voteI$roll_number,voteI$issue,function(x) paste(x,collapse ="|"),simplify =F)
print(as.data.frame(issue_roll))
#2.Delimiter = " "
issue_roll <- tapply(voteI$roll_number,voteI$issue,Q5)
print(issue_roll)
