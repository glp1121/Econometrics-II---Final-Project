# Econometrics II Final Project

## The Impact of Minimum Wage Increases on Unemployment Across Age Groups in Taiwan

### Authors
- 陳映岑（經濟三）
- 洪翊茗（經濟四）
- 黃俊程（統計系）
- 沈之晴（經濟三）

---

## Project Overview

This project examines the relationship between minimum wage adjustments and unemployment rates in Taiwan. Using annual data from 1985 to 2024, we investigate whether increases in the real minimum wage are associated with changes in unemployment and whether these effects differ across age groups.

Given the ongoing debate surrounding minimum wage policies, this study aims to provide empirical evidence from Taiwan's labor market using econometric methods learned in Econometrics II.

---

## Research Questions

1. Does an increase in the real minimum wage lead to higher unemployment?
2. Do minimum wage effects differ across age groups?
3. Does the relationship remain after controlling for macroeconomic conditions?

---

## Data Sources

### Ministry of Labor (Taiwan)
- Minimum wage data

### Directorate-General of Budget, Accounting and Statistics (DGBAS)
- Unemployment rates by age group
- Economic indicators

### National Development Council
- Business Monitoring Indicators (Prosperity Signal)

### Sample Period
1985–2024

---

## Variables

### Dependent Variable
- **Unemployment Rate (%)**

### Independent Variable
- **Change in Real Minimum Wage**
  - Nominal minimum wage adjusted for inflation
  - First-differenced to ensure stationarity

### Control Variable
- **Prosperity Signal (景氣對策信號)**

### Group Variable
- **Age Group**
  - 15–24 years old
  - 25–44 years old
  - 45–64 years old

---

## Methodology

### Stationarity Test

To avoid spurious regression, Augmented Dickey-Fuller (ADF) tests were conducted.

Results suggest:

| Variable | Result |
|-----------|----------|
| Unemployment Rate | Stationary (I(0)) |
| Real Minimum Wage | Non-Stationary (I(1)) |

Therefore, the first difference of the real minimum wage was used in the regression analysis.

### Regression Model

The main model is specified as:

```r
unemployment ~ d_real_min_wage_k * age_group + pros
```

where:

- `unemployment` = unemployment rate
- `d_real_min_wage_k` = change in real minimum wage
- `age_group` = age category
- `pros` = prosperity indicator

The interaction term allows the effect of minimum wage changes to vary across age groups.

---

## Repository Structure

```
Econometrics-II---Final-Project/
│
├── Data/
│   ├── Raw Data
│   └── Processed Data
│
├── R/
│   ├── Data Cleaning
│   ├── Analysis
│   └── Visualization
│
├── Figures/
│   └── Graphs and Plots
│
├── Output/
│   └── Regression Results
│
└── README.md
```

---

## Key Findings

### 1. No Evidence of Higher Unemployment

The results do not support the claim that minimum wage increases lead to higher unemployment during the sample period.

### 2. Negative Relationship

Changes in the real minimum wage are generally associated with lower unemployment rates.

### 3. Age Heterogeneity

The youth group (15–24 years old) appears to be more responsive to minimum wage adjustments than older age groups. However, the evidence is only marginally statistically significant.

### 4. Importance of Business Cycles

Macroeconomic conditions, represented by the prosperity indicator, remain important determinants of unemployment.

---

## Limitations

- Observational data do not allow strong causal interpretation.
- Potential omitted-variable bias may still exist.
- Industry-level and regional heterogeneity are not considered.
- Annual data may not fully capture short-run labor market adjustments.

---

## Future Research

Future studies could:

- Incorporate industry-level employment data.
- Examine regional differences within Taiwan.
- Investigate heterogeneous effects by education level.
- Apply causal inference methods such as Difference-in-Differences (DiD).

---

### Software
- R

---

## Sustainable Development Goals (SDGs)

This project is related to:

- SDG 1: No Poverty
- SDG 8: Decent Work and Economic Growth
- SDG 10: Reduced Inequalities

---

## Conclusion

Overall, this study finds no evidence that increases in Taiwan's minimum wage have led to higher unemployment. Instead, minimum wage growth is associated with lower unemployment rates during the study period. While the findings should be interpreted as conditional associations rather than causal effects, they contribute to the ongoing discussion regarding minimum wage policy and labor market outcomes in Taiwan.

---

## Course Information

Econometrics II Final Project

Department of Economics

National Chengchi University

Spring Semester 2026

Instructor : Prof. Shih-Hsun Hsu
