# a simple demo using modelStudio for model explainability - regression (xgboost)

library(modelStudio)
library(DALEX)
library(tidyverse)
library(tidymodels)

# using the mpg dataset for the demo
data_tbl <- mpg %>% 
  select(hwy, manufacturer:drv, fl, class)

head(data_tbl)

#      hwy manufacturer model displ  year   cyl trans      drv   fl    class  
# 1    29 audi         a4      1.8  1999     4 auto(l5)   f     p     compact
# 2    29 audi         a4      1.8  1999     4 manual(m5) f     p     compact
# 3    31 audi         a4      2    2008     4 manual(m6) f     p     compact
# 4    30 audi         a4      2    2008     4 auto(av)   f     p     compact
# 5    26 audi         a4      2.8  1999     6 auto(l5)   f     p     compact
# 6    26 audi         a4      2.8  1999     6 manual(m5) f     p     compact

fit_xgboost <- boost_tree(learn_rate = 0.3) %>% 
  set_mode("regression") %>% 
  set_engine("xgboost") %>% 
  fit(hwy ~ ., data = data_tbl)

fit_xgboost

explainer <- DALEX::explain(
  model = fit_xgboost,
  data = data_tbl,
  y = data_tbl$hwy,
  label = "XGBoost"
)

modelStudio(explainer)
