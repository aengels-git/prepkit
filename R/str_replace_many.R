#' Replace multiple strings in character vectors. Can be used for recoding!
#'
#' @param string A character vector
#' @param patterns A vector of strings or regular expressions to search for
#' @param replacements A vector of equal length to replace the found patterns
#'
#' @return
#' @export
#'
#' @examples
str_replace_many<-function(string,patterns,replacements){
  require(stringr)
  require(rlang)
  
  enviroment<-current_env()
  
  walk2(patterns,replacements,function(pattern,replacement){
    env_poke(
      value = str_replace_all(env_get(nm = "string",
                                      env = enviroment),
                              pattern = pattern,
                              replacement=replacement),
      nm = "string",
      env = enviroment
    )
  })
  
  return(string)
}