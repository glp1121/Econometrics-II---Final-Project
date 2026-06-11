#EDA
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(ggplot2)
library(gt)
panel_data <- readRDS("Output/panel_data.rds")

#描述統計
t1 <- panel_data %>%
  group_by(age_group) %>%
  summarise(
    Mean = mean(unemployment),
    SD = sd(unemployment),
    Min = min(unemployment),
    Max = max(unemployment)
  ) %>% 
  gt() %>%
  fmt_number(
    columns = c(Mean, SD, Min, Max),
    decimals = 2
  ) %>%
  tab_header(
    title = "Descriptive Statistics of Unemployment Rate"
    
  )
gtsave(
  t1,
  "Tables/descriptive_statistics_unemp.png"
)

#各年齡層失業率時間趨勢
f1 <- ggplot(panel_data,
       aes(date,
           unemployment,
           color = age_group)) +
  geom_line() +
  geom_vline(
    xintercept = as.Date("2020-01-01"),
    linetype = 2
  )
ggsave(
  "Figures/f1.png", f1,
  width = 8,
  height = 5
)

#實質最低工資時間趨勢
f2 <- ggplot(panel_data,
       aes(date,
           real_min_wage)) +
  geom_line()
ggsave(
  "Figures/f2.png",f2,
  width = 8,
  height = 5
)

#年齡層失業率分布
f3 <- ggplot(panel_data,
       aes(age_group,
           unemployment,
           fill = age_group)) +
  geom_boxplot()
ggsave(
  "Figures/f3.png",f3,
  width = 8,
  height = 5
)

#最低工資與失業率散點圖
f4 <- ggplot(panel_data,
       aes(real_min_wage,
           unemployment,
           color = age_group)) +
  geom_point(alpha=.3) +
  geom_smooth(method="lm")
ggsave(
  "Figures/f4.png",f4,
  width = 8,
  height = 5
)

#總失業率與景氣
f5 <- ggplot(panel_data,
       aes(pros,
           unemployment,
           color = age_group)) +
  geom_point(alpha=.3) +
  geom_smooth(method="lm")
ggsave(
  "Figures/f5.png",f5,
  width = 8,
  height = 5
)

#失業率季節性變化
f6 <- panel_data %>%
  group_by(age_group,
           month = month(date)) %>%
  summarise(
    mean_unemployment = mean(unemployment)
  ) %>%
  ggplot(
    aes(month,
        mean_unemployment,
        color = age_group)
  ) +
  geom_line() +
  geom_point()+
  scale_x_continuous(
    breaks = 1:12
  )
ggsave(
  "Figures/f6.png",f6,
  width = 8,
  height = 5
)
