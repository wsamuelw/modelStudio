# a simple demo using modelStudio for model explainability - regression

# read more below
# https://github.com/ModelOriented/modelStudio

# load packages
library(DALEX)
library(ranger)
library(modelStudio)
library(tidyverse)

# fit a model
model <- ranger(score ~., data = happiness_train)

# create an explainer for the model    
explainer <- DALEX::explain(model,
                     data = happiness_test,
                     y = happiness_test$score,
                     label = "Random Forest")

# make a studio for the model
modelStudio(explainer)

# combine test set with the prediction
# take a look at the actual vs. predicted
predictions <- happiness_test %>% 
  mutate(pred = predict(explainer, happiness_test))

head(predictions)

#             score gdp_per_capita social_support healthy_life_expectancy freedom_life_choices generosity perceptions_of_corruption     pred
# Finland     7.769          1.340          1.587                   0.986                0.596      0.153                     0.393 6.688596
# Denmark     7.600          1.383          1.573                   0.996                0.592      0.252                     0.410 6.677487
# Norway      7.554          1.488          1.582                   1.028                0.603      0.271                     0.341 6.679763
# Iceland     7.494          1.380          1.624                   1.026                0.591      0.354                     0.118 6.753863
# Netherlands 7.488          1.396          1.522                   0.999                0.557      0.322                     0.298 6.593914
# Switzerland 7.480          1.452          1.526                   1.052                0.572      0.263                     0.343 6.635066

# by default, the modelStudio function only selects 3 obs
# select the top 3 obs
selected_observations <- happiness_test[1:3,]

#             score gdp_per_capita social_support healthy_life_expectancy freedom_life_choices generosity perceptions_of_corruption
# Finland     7.769          1.340          1.587                   0.986                0.596      0.153                     0.393
# Denmark     7.600          1.383          1.573                   0.996                0.592      0.252                     0.410
# Norway      7.554          1.488          1.582                   1.028                0.603      0.271                     0.341
# Iceland     7.494          1.380          1.624                   1.026                0.591      0.354                     0.118
# Netherlands 7.488          1.396          1.522                   0.999                0.557      0.322                     0.298

explainer <- DALEX::explain(model,
                     data = selected_observations,
                     y = selected_observations$score,
                     label = "Random Forest")

# make a studio for the model
modelStudio(explainer)
