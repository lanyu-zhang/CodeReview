load("~/Dropbox/Notability/Data Mgmt and Prog R and SAS/homework/code review/Congress99.rdata")
vote <- dat99
rm(dat99)
colnames(vote) <- c("year", "roll_number", "issue", "question", "result", "title_or_description", "vote_result", "party", "name", "role", "state", "metadata", "parsed_date")
