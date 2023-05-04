#' Recode numbers to month labels
#'
#' @param x a numeric vector with numbers between 1 and 12
#' @param abbr abbreviate month labels? 
#'
#' @return
#' @export
#'
#' @examples
dt_month_recode<-function(x,abbr=T){
  recodes<-as.character(seq(1:12))
  names(recodes)<-lubridate::month(1:12,abbr=abbr,label=T)
  x<-as.factor(as.character(x))
  var<-fct_recode(x,!!!recodes)
  return(factor(var,levels = as.character(lubridate::month(1:12,abbr=abbr,label=T))))
}


#' Start of the month
#'
#' @param date a date vector
#'
#' @return
#' @export
#'
#' @examples
dt_start_month<-function(date){
  ym(paste0(year(date),ifelse(str_count(month(date))==1,paste0("0",month(date)),month(date))))
}

#' End of the month
#'
#' @param date a date vector
#'
#' @return
#' @export
#'
#' @examples
dt_end_month<-function(date){
  ymd(paste0(year(date),ifelse(str_count(month(date))==1,paste0("0",month(date)),month(date)),days_in_month(date)))
}


#' Recode dates to a Month Year variable
#'
#' @param dates a date vector
#'
#' @return
#' @export
#'
#' @examples
dt_to_ym<-function(dates, template="{months} {years}"){
  require(glue)
  start<-min(dates)
  end<-max(dates)
  year_month<-function(dates,template){
    months <- month(dates,label = T,abbr = T)
    years <- year(dates)
    return(glue(template))
  }
  levels<-seq(dt_start_month(start),dt_end_month(end), by = '1 month')
  levels<-year_month(levels,template=template)
  new_var<-fct_relevel(year_month(dates,template=template),levels)
  #Also include unused factor levels
  return(factor(new_var,levels=levels))
}

# to_year_month(c(ymd("20190101"),ymd("20180101")),template = "{months}. {years} ")


#' dt_int_overlap is a function to calculate the overlap between to periods in days
#'
#' @param first_period first interval variable
#' @param second_period second interval variable
#' @param unit days, seconds or minutes
#' @param complete_data if true returns the full dataset that was calculated in between to derive the overlapping days (contains for instance the overlapping period as an interval)
#'
#' @return
#' @export
#'
#' @examples
dt_int_overlap <- function(first_period,second_period,unit="days",complete_data=F){
  correction_factor <- time_length(interval(ymd("20140101"),ymd("20140102")),unit = unit)
  #Either vectors of intervals or a single interval
  result <- tibble(first_period,second_period)%>%
    mutate(any_overlap = int_overlaps(first_period,second_period))%>%
    mutate(overlap_start = pmax(int_start(first_period),int_start(second_period)),
           overlap_end = pmin(int_end(first_period),int_end(second_period)))
  result$overlap_start[!result$any_overlap]<-NA
  result$overlap_end[!result$any_overlap]<-NA
  
  result <- result%>%
    mutate(overlap_interval = interval(overlap_start,overlap_end))%>%
    mutate(overlap_outcome=time_length(overlap_interval,unit=unit)+correction_factor)%>%
    mutate(overlap_outcome=ifelse(is.na(overlap_outcome),0,overlap_outcome))
  if(complete_data){
    return(result)
  } else {
    return(result%>%pull(overlap_outcome))
  }
}



