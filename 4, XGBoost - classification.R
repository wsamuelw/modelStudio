# a simple demo using modelStudio for model explainability - classification (xgboost)

library(modelStudio)
library(DALEX)
library(tidyverse)
library(tidymodels)

# import data
customers <- read.csv('/Users/samuelwong/Desktop/Work/Data/datacamp/bank_churners.csv', stringsAsFactors = T)

# convert factor to number
customers$still_customer <- ifelse(customers$still_customer == 'yes', 1, 0) 

# split data 
set.seed(222) 
customers_split <- initial_split(customers, prop = 0.8, strata = still_customer) # enforce similar distributions
customers_split

customers_train <- training(customers_split); nrow(customers_train) # 8101
customers_test <- testing(customers_split); nrow(customers_test) # 2026

fit_xgboost <- boost_tree() %>%
  set_mode("classification") %>%
  set_engine("xgboost") %>% 
  fit(as.factor(still_customer) ~ ., data = customers_train)

explainer <- DALEX::explain(
  model = fit_xgboost,
  data = customers_train,
  y = customers_train$still_customer,
  label = "XGBoost"
)

# make predictions
predictions <- customers_test %>% 
  mutate(pred = predict(explainer, customers_test))

head(predictions)

# create a df with prediction = yes
yes <- predictions %>% 
  filter(pred > 0.5) %>% 
  sample_n(1)

# create a df with prediction = no
no <- predictions %>% 
  filter(pred < 0.5) %>% 
  sample_n(1)

new_observations <- rbind(yes, no)
new_observations
rownames(new_observations) <- c("Person A", "Person B")

modelStudio(explainer,
            new_observations,
            N = 200,  B = 5) # faster example
