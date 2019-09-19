# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
library(tidyr)
library(knitr)
library(rmarkdown)
library(googlesheets)
library(RCurl)
library(yaml)
library(magrittr)
library(stringr)
library(dplyr)
library(purrr)
library(lubridate)
library(fs)
library(readr)
library(futile.logger)
library(keyring)
library(RMySQL)
library(officer)

filter <- dplyr::filter # voorkom verwarring met stats::filter

home_prop <- function(prop) {
  prop_name <- paste0(prop, ".", host)
  prop <- config[[prop_name]] %>% 
    curlEscape %>% 
    str_replace_all(pattern = "\\%2F", replacement = "/")
}

# flog.appender(appender.file("/Users/nipper/Logs/cz_stats.log"), name = "stats_log")
# flog.info("= = = = = CZ-stats start = = = = =", name = "stats_log")

cz_rod <- read_delim(
  "~/cz-rod.log",
  "\"",
  escape_double = FALSE,
  col_names = FALSE,
  trim_ws = TRUE
) %>% as_tibble 

cz_rod_1 <-cz_rod %>% separate(X3, into = c("http_resp_sts_code", "bytes"))
cz_rod_2 <-cz_rod_1 %>% separate(X1, into = c("ip_adr", "stream_ts"), sep = " - - \\[") %>% 
  filter(http_resp_sts_code < "400")

device_n <- cz_rod_2 %>% select(X6) %>% group_by(X6) %>% summarise(n_dev = n()) %>% arrange(desc(n_dev))
device_type <- cz_rod_2 %>% select(X6) %>% group_by(X6) %>% summarise(n_dev = n()) %>% arrange(X6)




