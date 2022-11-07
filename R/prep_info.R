prep_info <- function(df,missings=F){
  require(glue)
  dimensions <- dim(df)
  cat("\nDimensionen:\n")
  print(glue("{dimensions[1]} Zeilen und {dimensions[2]} Spalten"))
  cat("\n")
  if(missings){
    cat("Fehlende Werte::\n")
    miss <- df%>%
      summarise_all(function(x){sum(is.na(x))})
    walk2(names(miss), as.numeric(map_dbl(miss,~.x)),function(var_name,n_miss){
      print(glue("{var_name} hat {n_miss} fehlende Werte"))
    })
    cat("\n")
  }
  return(invisible(df))
}

# library(tidyverse)
# diamonds%>%
#   prep_info(missings = T)%>%
#   group_by(cut)%>%
#   summarise(n=n())


