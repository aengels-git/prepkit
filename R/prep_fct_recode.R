#' prep_fct_recode
#'
#' @param var a factor variable
#' @param old_codes character vector of old values to replace
#' @param new_codes character vector of new replacements (should have the same order as old values!)
#'
#' @return
#' @export
#'
#' @examples
#' prep_fct_recode(diamonds$cut,c("Fair","Good"),c("Fair Diamond Quality","Pretty Good"))
prep_fct_recode<-function(var,old_codes,new_codes){
  require(forcats)
  require(glue)
  require(rlang)
  require(purrr)
  require(stringr)
  recode_instruction<-map2_chr(new_codes,old_codes,~glue("'{.x}'='{.y}'"))%>%
    str_c(collapse = ",")
  
  return(glue("fct_recode({deparse(substitute(var))},{recode_instruction})")%>%
           parse_expr()%>%
           eval())
}