#Model
library(tseries)
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(ggplot2)
panel_data <- readRDS("Output/panel_data.rds")

#檢查變數是否單根
wage <- panel_data %>%
  distinct(date, real_min_wage) %>%
  arrange(date) %>%
  pull(real_min_wage)
adf.test(wage) #此有單根傾向

youth <- panel_data %>%
  filter(age_group=="15-24") %>%
  pull(unemployment)
adf.test(youth)

adult <- panel_data %>%
  filter(age_group=="25-44") %>%
  pull(unemployment)
adf.test(adult)

older <- panel_data %>%
  filter(age_group=="45-64") %>%
  pull(unemployment)
adf.test(older)

panel_data <- panel_data %>%
  arrange(age_group, date) %>%
  group_by(age_group) %>%
  mutate(
    d_real_min_wage = real_min_wage - lag(real_min_wage)
  ) %>%
  ungroup()

adf.test(na.omit(panel_data$d_real_min_wage)) #I(0)

#把最低薪資改成以千元為單位
panel_data <- panel_data %>%
  mutate(
    d_real_min_wage_k = d_real_min_wage / 1000
  )

m1 <- lm(
  unemployment ~
    d_real_min_wage_k * age_group +
    overall_unemployment,
  data = panel_data
)
summary(m1)

m1 <- lm(
  unemployment ~
    d_real_min_wage_k * age_group +
    pros,
  data = panel_data
)

m_signal <- lm(
  unemployment ~
    d_real_min_wage_k * age_group +
    pros,
  data = panel_data
)
