library(data.table)
library(readr)
library(lubridate)
library(writexl)
install.packages("dplyr")
library(dplyr)
install.packages("zoo")
library(zoo)
install.packages("highcharter")
library(highcharter)
install.packages("magrittr")
library(magrittr)
library(ggplot2)
library(xts) 
setwd("d://R/")

hourly <- data.table(read_delim("./data/data_hourly_2004_2020.txt", 
                             "\t", escape_double = FALSE, 
                             col_types = cols(D = col_double(), 
                                              Fmax = col_double(), Fprum = col_double(), 
                                              H = col_double(), RGLB1H = col_double(), 
                                              SCE = col_double(), SNO = col_double(), 
                                              SRA1H = col_double(), SSV1H = col_double(), 
                                              SVH = col_double(), T = col_double(), 
                                              T05 = col_double(), date = col_character(), 
                                              datum = col_date(format = "%Y-%m-%d"), 
                                              time = col_character()), trim_ws = TRUE))

hourly <- hourly[, .(T=mean(T, na.rm = T)), by = .(datum)]# mean daily Temperature value
hourly[, Troll5:= rollmean(x = T, k = 5, fill = NA, align = "right")]
hourly[, Troll3:= rollmean(x = T, k = 3, fill = NA, align = "right")]
hourly[, Nula:= 0]
hourly[, Pet:= 5]

plot_dta <- xts(x = hourly[,.(T,Troll5,Troll3, Nula, Pet)], order.by = hourly$datum)

highchart(type = "stock") %>% 
  hc_add_series(plot_dta$T, type = "line", color = "lightblue") %>%
  hc_add_series(plot_dta$Troll5, type = "line", color = "orange") %>%
  hc_add_series(plot_dta$Troll3, type = "line", color = "red") %>%
  hc_add_series(plot_dta$Nula, type = "line", color = "black") %>%
  hc_add_series(plot_dta$Pet, type = "line", color = "grey")

lbou_daily <- data.table(read_delim("./data/LBOU_daily_1961_2020.txt", "\t", 
                                    escape_double = FALSE, 
                                    col_types = cols(date = col_date(format = "%d.%m.%Y"),
                                                     Hprum = col_double(), SCE = col_double(),
                                                     SNO = col_double(), SVH = col_double(), 
                                                     SRA = col_double(), SSV = col_double(), 
                                                     Tprum = col_double(), T05prum = col_double(),
                                                     Fprum = col_double(), Fmax = col_double(), 
                                                     Dprum = col_double()), trim_ws = TRUE))
 

lbou_daily[, Troll5:= rollmean(x = Tprum, k = 5, fill = NA, align = "right")]
lbou_daily[, Troll3:= rollmean(x = Tprum, k = 3, fill = NA, align = "right")]
lbou_daily <- lbou_daily[,.(date, Tprum, Troll5, Troll3)]
lbou_daily <- lbou_daily[complete.cases(lbou_daily)]
lbou_daily[, Nula:= 0]
lbou_daily[, Pet:= 5]

dta <- xts(x = lbou_daily[,.(Tprum,Troll5,Troll3, Nula, Pet)], order.by = lbou_daily$date)


highchart(type = "stock") %>% 
  hc_add_series(dta$Tair, type = "line", color = "darkblue") %>%
  hc_add_series(dta$Troll5, type = "line", color = "orange") %>%
  hc_add_series(dta$Troll3, type = "line", color = "red") %>%
  hc_add_series(dta$Nula, type = "line", color = "black") %>%
  hc_add_series(dta$Pet, type = "line", color = "grey")


lbou_daily <- readRDS("C:/Users/marketa.souckova/OneDrive - CZU v Praze/R/Krkonose/Rcode/RDS/denni_data.rds")

lbou_daily[, Troll5:= rollmean(x = Tair, k = 5, fill = NA, align = "right")]
lbou_daily[, Troll3:= rollmean(x = Tair, k = 3, fill = NA, align = "right")]
lbou_daily <- lbou_daily[,.(Date, Tair, Troll5, Troll3)]
lbou_daily <- lbou_daily[complete.cases(lbou_daily)]
lbou_daily[, Nula:= 0]
lbou_daily[, Pet:= 5]

dta <- xts(x = lbou_daily[,.(Tair,Troll5,Troll3, Nula, Pet)], order.by = lbou_daily$Date)

