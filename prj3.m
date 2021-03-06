title: "Project3"
authors: "Anthony Pagan", "Alexander Niculescu", "Jack Russo"
date: "October 17, 2018"
output: html_document
---

#Libraries
```{r message=FALSE, warning=FALSE}
library(dplyr)
library(tidyr)
library(readxl)
library(ggplot2)
library(plotrix)
library(plotly)
library(gapminder)
library(RMySQL)
library(DT)

memory.limit()
## To increase the storage capacity
memory.limit(size=32000)
```

## CSV files to data frames

```{r echo=FALSE}
apprDstr<-data.frame(read.csv(file = 'APPR_DISTRICT_RESEARCHER_FILE_DATA.csv', header = TRUE, sep= ",", stringsAsFactors = FALSE))
apprSch<-data.frame(read.csv(file = 'APPR_SCHOOL_RESEARCHER_FILE_DATA.csv', header = TRUE, sep= ",", stringsAsFactors = FALSE))
apprState<-data.frame(read.csv(file = 'APPR_STATEWIDE_RESEARCHER_FILE_DATA.csv', header = TRUE, sep= ",", stringsAsFactors = FALSE))
#d<-apprDstr%>%
    #filter(OVERALL_SCORE != "Suspended" & OVERALL_SCORE > 98)%>%
    #filter(OVERALL_RATING == "Highly Effective")
#h<-inner_join(d, apprSch, by="DISTRICT_BEDS")
#View(h)
#fapprState<-
    #apprSch%>%
    #select(PER_PUPIL_EXPENDITURE)%>%unique()
    #filter(EDUCATOR_ID == 5019496)
```

#Import data to MYSQL for analysis

```{r dbInit}
mydb = dbConnect(MySQL(), user='root', password='123456', dbname='education', host='localhost')
dbListTables(mydb)
dbRemoveTable(mydb, "apprdstr")
dbWriteTable(mydb, "apprDstr",apprDstr, overwrite = TRUE)
dbRemoveTable(mydb, "apprsch")
dbWriteTable(mydb, "apprSch",apprSch, overwrite = TRUE)
dbRemoveTable(mydb, "apprstate")
dbWriteTable(mydb, "apprState",apprState, overwrite = TRUE)
dbDisconnect(mydb)
```

#Run Query to extract join 2 tables and extract 1million rows

```{r dbConnect}
mydb = dbConnect(MySQL(), user='root', password='123456', dbname='education', host='localhost')
joineddata<-dbGetQuery(mydb, "select d.educator_id as EducatorD_ID, d.DISTRICT_NAME, s.Educator_id as EducatorS_ID, s.School_name, district_needs_category, per_pupil_expenditure,
d.overall_score, d.overall_rating, s.growth_rating from apprdstr d
inner join apprsch s on  d.district_beds = s.district_beds limit 1000000")
dbDisconnect(mydb)
```

#Write data back to CSV for team to review
```{r csvOut}
write.csv(joineddata, file="JoinedEDUData.csv")
```

# Load Data
```{r csvLoad}
x <- "/Users/codedesk/Documents/CUNY_SPS/Data_607/JoinedEDUData.csv"
x <- read.csv(x, header = TRUE)
x
```

# Check Levels

```{r levels}
levels(x$overall_score)
levels(x$per_pupil_expenditure)
```

# Remove NAs

```{r dataCleanse}
sum(is.na(x$overall_score))
sum(is.na(x$per_pupil_expenditure))
```

```{r dplyrFilter}
x <- x %>%
     filter(complete.cases(.))
```

```{r sumStats}
sum(is.na(x$overall_score))
sum(is.na(x$per_pupil_expenditure))
```

# Coerce and Scale

```{r CoerceAndScale}
x$overall_score <- as.numeric(paste(x$overall_score))/100
x$per_pupil_expenditure <- unclass(x$per_pupil_expenditure)/-2
```

# Review Data

```{r DataReview}
sum(is.na(x$overall_score))
sum(is.na(x$per_pupil_expenditure))
```

# Test

Ho: The true correlation between teacher performance ratings and per pupil expenditure is zero.

Ha: The true correlation between teacher performance ratings and per pupil expenditure is zero.

```{r TestCase}
cor.test(x$per_pupil_expenditure,x$overall_score)
```

On the basis of this correlation, we reject the null hypothesis.