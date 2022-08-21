
#' prep_mean_table
#'
#' @param data dataset
#' @param ... arbitrary number of grouping variables
#' @param outcomes one or more numeric outcome variables
#' @param weight optional vector of weights for weighted mean / and std
#' @param gather change to long format
#' @param digits number of digits to round to
#'
#' @return
#' @export
#'
#' @examples
#' library(ggplot2)
#' prep_mean_table(diamonds,cut,color,outcomes=c("price"))
#' 
prep_mean_table<-function(data,...,outcomes,weight=NULL,gather=F,digits=2){
  require(rlang)
  require(tidyverse)
  require(stringr)
  require(Hmisc)
  
  #Grouping Expression
  expression<-enquos(...)
  
  #Generate a list of expressions to get the sample size of all groups
  single_conditions<-map(expression,function(x){
    name<-paste0("n_",quo_name(x))
    if(is.null(weight)){
      data%>%
        group_by(!!x)%>%
        summarise(!!name := n())
    } else {
      data%>%
        group_by(!!x)%>%
        summarise(!!name := !!parse_expr(paste0("sum(",weight,")")))
    }
    
  })
  #H?ufigkeiten f?r die kleineren Gruppen
  if(is.null(weight)){
    summary_fun<-expr(n())
  } else {
    summary_fun<-parse_expr(paste0("sum(",weight,")"))
  } 
  freq_table<-data%>%
    group_by(!!!expression)%>%
    summarise(n=!!summary_fun)
  
  if(length(outcomes)>1){
    #Generate list of expression to get means of all variables
    funs<-map(outcomes,~expr(!!.x := !!parse_expr(
      paste0("weighted.mean(",.x,ifelse(is.null(weight),"",paste0(",w=",weight)),")")
    )))%>%reduce(exprs)%>%unlist()
    
    funs2<-map(outcomes,~expr(!!parse_expr(paste0("sd_",.x)) := !!parse_expr(
      paste0("sqrt(wtd.var(",.x,ifelse(is.null(weight),"",paste0(",weights=",weight)),"))")
    )))%>%reduce(exprs)%>%unlist()
    
    #Calculate actual values
    results<-data%>%group_by(!!!expression)%>%
      dplyr::summarise(!!!funs)%>%
      left_join(data%>%group_by(!!!expression)%>%
                  dplyr::summarise(!!!funs2))
    if(gather==T){
      #the grouping variables should not be gathered
      untouched_grouping_variables<-map(expression,~parse_expr(paste0("`-`(",.x[[2]],")")))%>%reduce(exprs)
      results<-results%>%
        gather(key = "outcome",value = "value",!!!untouched_grouping_variables)
      results<-results%>%filter(str_detect(outcome,"sd_")==F)%>%
        left_join(results%>%filter(str_detect(outcome,"sd_"))%>%
                    rename(sd_value=value)%>%
                    mutate(outcome=str_replace(outcome,"sd_","")))
    }
  } else {
    #print(paste0("sqrt(wtd.var(",outcomes,ifelse(is.null(weight),"",paste0(",weights=",weight)),"))"))
    results<-data%>%group_by(!!!expression)%>%
      dplyr::summarise(!!outcomes := !!parse_expr(
        paste0("weighted.mean(",outcomes,ifelse(is.null(weight),"",paste0(",w=",weight)),")")
      ))%>%left_join(data%>%group_by(!!!expression)%>%
                       dplyr::summarise(!!parse_expr(paste0("sd_",outcomes)) := !!parse_expr(
                         paste0("sqrt(wtd.var(",outcomes,ifelse(is.null(weight),"",paste0(",weights=",weight)),"))")
                       )))
    # print(results)
    
  }
  results<-append(append(list(results),single_conditions),list(freq_table))%>%reduce(left_join)
  results<-results%>%mutate_if(is.numeric,function(x){round(x,digits)})

  return(results)
}
