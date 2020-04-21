# Congress Analysis

##Data Summary

The file Congress99.RData contains voting data from the US Congress from 1999. It contains the following columns:
year, 
roll_number, 
issue, 
question, 
result, 
title_or_description, 
vote_result, 
vote_legislator.party, 
vote_legislator.text, 
vote_legislator.role, 
vote_legislator.state, 
vote_metadata, 
parsed_date
**Note that vote_metadata contains JSON-formatted data. **

Arrange the voting data in a table, so that in each row you will have one member of Congress, and the table will contain the following columns: Name, Party, State, and roll-number. Note that there are 611 roll numbers in the 1999 data.

**Note that one issue may be split into multiple votes (rolls).**
**Also note that votes may be Yea, Nay, but also may no-vote. You have to account for all, not just the yes/no votes.**

##This project is to answer the following questions:
1. How many representatives does each party have in the 1999 Congress?
2. How many representatives does each party have in each state?
3. What is the propensity of each member to vote by party lines? That is, that he/she voted in the same way as the majority of people in his/her party, and opposed to the majority of the voters from the other party.
4. Voting outcomes – how many votes passed/failed/other? How many votes were determined by party affiliations? (that is, votes in which the majority from one party were “yea”, while the majority from the other party was “nay”.)
5. Find a way to summarize the votes by issue.


