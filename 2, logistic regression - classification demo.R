# a simple demo using modelStudio for model explainability - classification

library(DALEX)
library(modelStudio)
library(tidyverse)

# fit a model
model_titanic <- glm(survived ~., data = titanic_imputed, family = "binomial")

# create an explainer for the model
explainer_titanic <- DALEX::explain(model_titanic,
                             data = titanic_imputed,
                             y = titanic_imputed$survived,
                             label = "Titanic GLM")

# pick observations
new_observations <- titanic_imputed[1:2,]
rownames(new_observations) <- c("Lucas","James")

# make a studio for the model
modelStudio(explainer_titanic,
            new_observations,
            N = 200,  B = 5) # faster example

predictions <- new_observations %>% 
  mutate(pred = predict(explainer_titanic, new_observations))

head(predictions)

#       gender age class    embarked  fare sibsp parch survived       pred
# Lucas   male  42   3rd Southampton  7.11     0     0        0 0.06020549
# James   male  13   3rd Southampton 20.05     0     2        0 0.15319320

