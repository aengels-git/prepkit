#' prep_freq_table 
#' a function to calculate counts, proportions and conditional proportions based on grouping variables
#'
#' @param data a dataframe or tibble object
#' @param ... arbitrary number of grouping variables
#'
#' @return
#' @export
#'
#' @examples
#' library(ggplot2)
#' prep_freq_table(diamonds,cut,color)
#' 
prep_freq_table<-function(data,...){
  #incompatible with plyr!!
  require(rlang)
  require(dplyr)
  require(magrittr)
  require(stringr)
  library(purrr)
  expression<-enquos(...)

  freq_table<-data%>%
    group_by(!!!expression)%>%
    summarise(n=n())
  
  single_conditions<-map(expression,function(x){
    name<-paste0("n_",quo_name(x))
    data%>%
      group_by(!!x)%>%
      summarise(!!name := n())
  })
  
  freq_table<-append(list(freq_table),single_conditions)%>%
    reduce(left_join)
  calculated_proportions<-map(expression,function(x){
    new_var<-paste0("prop_",quo_name(x))
    old_var<-paste0("n_",quo_name(x))
    freq_table%>%
      mutate(!!new_var := !!parse_expr(paste0("n/",old_var)))
  })
  freq_table<-append(list(freq_table),calculated_proportions)%>%
    reduce(left_join)
  freq_table$prop<-freq_table$n/sum(freq_table$n)
  if(length(expression)==1){
    return(freq_table%>%
             select_if(str_detect(names(.),"^n_|^prop_")==F))
  } else {
    return(freq_table)
  }

}