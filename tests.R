library(devtools)
load_all()

#Calculate the overlap of a period:
example_data <- tibble(
  period1 = interval(ymd("20140101"),ymd("20160101")),
  period2 = interval(ymd("20150101"),ymd("20170101"))
)

dt_int_overlap(example_data$period1,example_data$period2)

example_data%>%
  mutate(overlap_in_days = dt_int_overlap(period1,period2))
