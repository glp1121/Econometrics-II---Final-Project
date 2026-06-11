#Model
library(tseries)
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(ggplot2)
library(plm)
library(modelsummary)
library(lmtest)
library(sandwich)
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
    d_real_min_wage = real_min_wage - dplyr::lag(real_min_wage)
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
    d_real_min_wage_k * age_group + pros,
  data = panel_data
)
summary(m1)
dwtest(m1)
bptest(m1)
coeftest(
  m1,
  vcov = NeweyWest(m1)
)

m2 <- lm(unemployment ~ age_group, data = panel_data)
summary(m2)

pdata <- pdata.frame(
  panel_data,
  index = c("age_group", "date")
)
m3 <- plm(
  unemployment ~
    d_real_min_wage_k +
    pros,
  data = pdata,
  model = "within"
)
summary(m3)
coeftest(
  m3,
  vcov = vcovHC(
    m3,
    method = "arellano",
    type = "HC1",
    cluster = "group"
  )
)

youth_data <- panel_data %>%
  filter(age_group == "15-24") %>%
  mutate(month = month(date))

m4 <- lm(
  unemployment ~
    d_real_min_wage_k +
    pros +
    factor(month),
  data = youth_data
)
summary(m4)
dwtest(m4)
bptest(m4)
coeftest(
  m4,
  vcov = NeweyWest(m4)
)

library(modelsummary)
library(sandwich)
library(plm)

modelsummary(
  list(
    "Age FE Only" = m2,
    "Pooled OLS" = m1,
    "Pooled OLS (HAC)" = m1,
    "Fixed Effects" = m3,
    "Youth Model (HAC)" = m4
  ),
  vcov = list(
    NULL,                 # m2
    NULL,                 # m1 原始OLS標準誤
    NeweyWest(m1),        # m1 HAC標準誤
    vcovHC(
      m3,
      method = "arellano",
      type = "HC1",
      cluster = "group"
    ),
    NeweyWest(m4)
  ),
  stars = TRUE,
  output = "Tables/Regression.png"
)
