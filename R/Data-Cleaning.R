library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(ggplot2)

## 就業資料
unemp_raw <- read_excel(
  "Data/失業率-年齡_20260604135319.xlsx",
  col_names = FALSE
)

age  <- as.character(unemp_raw[2, ])
sex  <- as.character(unemp_raw[3, ])
type <- as.character(unemp_raw[4, ])

# 把 age 往右補滿
for (i in seq_along(age)) {
  if (is.na(age[i]) && i > 1) age[i] <- age[i - 1]
}

names_new <- paste(age, sex, type, sep = "_")
names_new[1] <- "month_roc"

data <- unemp_raw[-c(1:5), ]
names(data) <- names_new

unemp_long <- data %>%
  select(
    month_roc,
    `15-24歲_總計_統計值 (%)`,
    `25-44歲_總計_統計值 (%)`,
    `45-64歲_總計_統計值 (%)`
  ) %>%
  pivot_longer(
    cols = -month_roc,
    names_to = "age_group",
    values_to = "unemployment"
  ) %>%
  mutate(
    age_group = str_remove(age_group, "_總計_統計值 \\(\\%\\)"),
    year = as.numeric(str_extract(month_roc, "\\d+(?=年)")) + 1911,
    month = as.numeric(str_extract(month_roc, "(?<=年)\\d+(?=月)")),
    date = as.Date(sprintf("%d-%02d-01", year, month)),
    unemployment = as.numeric(unemployment)
  ) %>%
  select(date, age_group, unemployment)

View(unemp_long)

##總失業率
overall_raw <- read_excel(
  "Data/失業率-總計_2026060413526.xlsx",
  col_names = FALSE
)

overall_unemp <- overall_raw[-c(1:5), ] %>%
  transmute(
    period = as.character(...1),
    overall_unemployment = as.numeric(...3)
  ) %>%
  filter(str_detect(period, "月")) %>%
  mutate(
    year = str_extract(period, "\\d+(?=年)") |> as.numeric() + 1911,
    month = str_extract(period, "(?<=年)\\d+(?=月)") |> as.numeric(),
    date = as.Date(sprintf("%d-%02d-01", year, month))
  ) %>%
  select(date, overall_unemployment)

##最低工資

min_wage_change <- tibble(
  start_date = as.Date(c(
    "2011-01-01",
    "2012-01-01",
    "2013-04-01",
    "2014-07-01",
    "2015-07-01",
    "2016-01-01",
    "2017-01-01",
    "2018-01-01",
    "2019-01-01",
    "2020-01-01",
    "2021-01-01",
    "2022-01-01",
    "2023-01-01",
    "2024-01-01",
    "2025-01-01",
    "2026-01-01"
  )),
  min_wage = c(
    17880,
    18780,
    19047,
    19273,
    20008,
    20008,
    21009,
    22000,
    23100,
    23800,
    24000,
    25250,
    26400,
    27470,
    28590,
    29500
  )
)

min_wage_monthly <- tibble(
  date = seq(as.Date("2011-01-01"), as.Date("2026-04-01"), by = "month")
) %>%
  left_join(min_wage_change, by = c("date" = "start_date")) %>%
  fill(min_wage, .direction = "down")
data_panel <- unemp_long %>%
  left_join(min_wage_monthly, by = "date")

#CPI
CPI <- read.csv("Data/CPI(100~115).csv",fileEncoding = "BIG5")
names(CPI)[1] <- "period"
names(CPI)[2] <- "CPI"

cpi_monthly <- CPI %>%
  filter(str_detect(period, "月"))

cpi_monthly <- cpi_monthly %>%
  mutate(
    year = str_extract(period, "\\d+(?=年)") |> as.numeric() + 1911,
    month = str_extract(period, "(?<=年)\\d+(?=月)") |> as.numeric(),
    date = as.Date(sprintf("%d-%02d-01", year, month)),
    CPI = as.numeric(CPI)
  ) %>%
  select(date, CPI)

#Mutate
panel_data <- unemp_long %>%
  left_join(cpi_monthly, by = "date")
panel_data <- panel_data %>%
  left_join(min_wage_monthly, by = "date")
panel_data <- panel_data %>% #實質最低薪資
  mutate(
    real_min_wage = min_wage / CPI * 100
  )
panel_data <- panel_data %>%
  mutate(
    age_group = str_remove(age_group, "歲")
  )
panel_data <- panel_data %>%
  left_join(
    overall_unemp,
    by = "date"
  )

saveRDS(
  panel_data,
  "Output/panel_data.rds"
)
