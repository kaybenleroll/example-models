# 3.1 one_predictor.R
library(rstan)
library(ggplot2)

### Data
source("ARM/Ch.3/kidiq.data.R", echo = TRUE)

### First model: kid_score ~ mom_hs
data.list.1 <- c("N", "kid_score", "mom_hs")
kidscore_momhs <- stan(file = "ARM/Ch.3/kidscore_momhs.stan", data = data.list.1, iter = 500)
kidscore_momhs
pairs(kidscore_momhs)

### Second model: lm(kid_score ~ mom_iq)
data.list.2 <- c("N", "kid_score", "mom_iq")
kidscore_momiq <- stan(file = 'ARM/Ch.3/kidscore_momiq.stan', data = data.list.2, iter = 500)
kidscore_momiq
pairs(kidscore_momiq)

# Figure 3.1
kidiq.data <- data.frame(kid_score, mom_hs, mom_iq)
beta.post.1 <- extract(kidscore_momhs, "beta")$beta
beta.mean.1 <- colMeans(beta.post.1)
p1 <- ggplot(kidiq.data, aes(x = mom_hs, y = kid_score)) +
  geom_jitter(position = position_jitter(width = 0.05, height = 0)) +
  geom_abline(aes(intercept = beta.mean.1[1], slope = beta.mean.1[2])) +
  scale_x_continuous("Mother completed high school", breaks = c(0, 1)) +
  scale_y_continuous("Child test score", breaks = c(20, 60, 100, 140)) +
  theme_bw()
print(p1)

# Figure 3.2
beta.post.2 <- extract(kidscore_momiq, "beta")$beta
beta.mean.2 <- colMeans(beta.post.2)
p2 <- ggplot(kidiq.data, aes(x = mom_iq, y = kid_score)) +
  geom_point() +
  geom_abline(aes(intercept = beta.mean.2[1], slope = beta.mean.2[2])) +
  scale_x_continuous("Mother IQ score", breaks = c(80, 100, 120, 140)) +
  scale_y_continuous("Child test score", breaks = c(20, 60, 100, 140)) +
  theme_bw()
print(p2)
