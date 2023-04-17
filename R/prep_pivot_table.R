#' Pivot Tables inspired by pandas pivot_tables function
#'
#' @param df a dataframe or tibble
#' @param index "var", var, c("var") or c(var1,var2) to decribe the variables used to aggregated by row 
#' @param columns  "var", var, c("var") or c(var1,var2) to decribe the variables used to aggregated by column 
#' @param outcomes  "var", var, c("var") or c(var1,var2) to decribe the outcome variables 
#' @param agg_funs "var", var, c("var") or c(var1,var2) 
#' @param fun_names A string or character vector to prepend the column names for each function
#'
#' @return
#' @export
#'
#' @examples
prep_pivot_table<-function (df, index = NULL, columns = NULL, outcomes, agg_funs = mean, 
                            fun_names = NULL) 
{
  #Handle Index:
  if(!possibly(function(x){is.character(x)|is.null(x)},otherwise = F)(index)){
    index_names <- deparse(substitute(index))
    if (str_detect(index_names, "^c\\(")) {
      index <- map_chr(enexpr(index), ~as_string(.x)) %>% 
        .[. != "c"]
    } else {
      index <- index_names
    }
  }
  #Handle Columns:
  if(!possibly(function(x){is.character(x)|is.null(x)},otherwise = F)(columns)){
    column_names <- deparse(substitute(columns))
    if (str_detect(column_names, "^c\\(")) {
      columns <- map_chr(enexpr(columns), ~as_string(.x)) %>% 
        .[. != "c"]
    } else {
      columns <- column_names
    }
  }
  #Handle Outcomes:
  if(!possibly(function(x){is.character(x)|is.null(x)},otherwise = F)(outcomes)){
    outcome_names <- deparse(substitute(outcomes))
    if (str_detect(outcome_names, "^c\\(")) {
      outcomes <- map_chr(enexpr(outcomes), ~as_string(.x)) %>% 
        .[. != "c"]
    } else {
      outcomes <- outcome_names
    }
  }

  n_functions <- ifelse(is.function(agg_funs),1,length(agg_funs))
  if (is.null(index)  && is.null(columns) ) {
    stop("Please provide either column or index  variables")
  }
  
  if (is.null(index)) {
    grouper <- columns
  } else if (is.null(columns)) {
    grouper <- index
  } else {
    grouper <- c(columns, index)
  }
  grouper <- map(grouper, ~parse_expr(.x))
  result <- df %>% group_by(!!!grouper) %>% summarise(across(all_of(outcomes), 
                                                             agg_funs, .names = "f{.fn}_{.col}"))
  outcomes <- map(seq(1, n_functions), function(id) {
    paste0("f", id, "_", outcomes)
  }) %>% reduce(c)
  if (!is.null(columns)) {
    result <- result %>% pivot_wider(names_from = columns, 
                                     values_from = outcomes)
  }
  if (is_null(fun_names) == F) {
    names(result) <- str_replace_many(names(result), patterns = map_chr(1:n_functions, 
                                                                        ~paste0("f", .x)), replacements = fun_names)
  }
  return(result)
}

# prep_pivot_table(mtcars,index = cyl,columns = vs,outcomes = hp,agg_funs = function(x){mean(x,na.rm=T)})
# prep_pivot_table(mtcars,index = cyl,columns = vs,outcomes = hp,agg_funs = c(function(x){mean(x,na.rm=T)}))
# prep_pivot_table(mtcars,index = cyl,columns = vs,outcomes = hp,agg_funs = list(function(x){mean(x,na.rm=T)}))
# 
# prep_pivot_table(mtcars,index = cyl,columns = vs,outcomes = hp,agg_funs = mean)
# prep_pivot_table(mtcars,index = cyl,columns = vs,outcomes = hp,agg_funs = c(sum,mean))
# prep_pivot_table(mtcars,index = cyl,columns = vs,outcomes = hp,agg_funs = list(function(x){mean(x,na.rm=T)},sum),
#                  fun_names = c("mean","sum"))

# 
# prep_pivot_table <- function(df, index=NULL, columns=NULL,outcomes, agg_funs=mean,fun_names = NULL){
#   
#   #Accept various inputs: "var", var, c("var") and c(var1,var2)
#   index_name <- deparse(substitute(index))
#   columns_name <- deparse(substitute(columns))
#   
#   if(str_detect(deparse(substitute(agg_funs)),"^c\\(")){
#     function_vector <- map_chr(enexpr(agg_funs),~as_string(.x))%>%.[.!="c"]
#   } else {
#     function_vector <- as_string(enexpr(agg_funs))
#   }
#   
#   if(index_name=="NULL" && columns_name=="NULL"){
#     stop("Please provide either column or index  variables")
#   }
#   
#   if(index_name != "NULL"){
#     if(str_detect(deparse(substitute(index)),"^c\\(")){
#       #Convert to vector of strings:
#       
#       index <- map_chr(enexpr(index),~as_string(.x))%>%
#         .[.!="c"]
#       
#     } else {
#       index <- as_string(enexpr(index))
#     }
#     
#   }
#   
#   if(columns_name !="NULL"){
#     if(str_detect(deparse(substitute(columns)),"^c\\(")){
#       
#       #Convert to vector of strings:
#       columns <- map_chr(enexpr(columns),~as_string(.x))%>%
#         .[.!="c"]
#       
#     } else {
#       columns <- as_string(enexpr(columns))
#     }
#   }
#   
#   #Handle outcomes:
#   
#   if(str_detect(deparse(substitute(outcomes)),"^c\\(")){
#     
#     #Convert to vector of strings:
#     
#     outcomes <- map_chr(enexpr(outcomes),~as_string(.x))%>%
#       
#       .[.!="c"]
#     
#   } else {
#     
#     outcomes <- as_string(enexpr(outcomes))
#     
#   }
#   
#   #print(outcomes)
#   
#   #Create grouper
#   
#   if(index_name == "NULL"){
#     
#     grouper <- columns
#     
#   } else if(columns_name == "NULL"){
#     
#     grouper <- index
#     
#   } else {
#     
#     grouper <- c(columns,index)
#     
#   }
#   
#   
#   
#   grouper <- map(grouper,~parse_expr(.x))
#   
#   
#   
#   result <- diamonds%>%
#     group_by(!!!grouper)%>%
#     summarise(across(all_of(outcomes),agg_funs,.names = "f{.fn}_{.col}"))
#   
#   outcomes <- map(seq(1,length(function_vector)),function(id){
#     paste0("f",id,"_",outcomes)
#   })%>%reduce(c)
#   
#   if(columns_name != "NULL"){
#     result <- result%>%pivot_wider(names_from = columns,values_from = outcomes)
#   }
#   
#   if(is_null(fun_names)==F){
#     names(result) <- str_replace_many(names(result),
#                                       patterns = map_chr(1:length(function_vector),~paste0("f",.x)),
#                                       replacements = fun_names)
#     
#   }
#   
#   return(result)
# }
