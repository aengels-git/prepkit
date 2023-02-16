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
