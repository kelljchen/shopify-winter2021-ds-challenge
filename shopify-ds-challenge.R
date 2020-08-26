
# Read data in
shopify <- read.csv("2019 Winter Data Science Intern Challenge Data Set - Sheet1.csv")

# Question 1 Exploration

# Initial exploration of data
summary(shopify$order_amount)
plot(shopify$total_items,shopify$order_amount, 
     xlab="Order Size", ylab="Order Total Amount")

# Identify and examine $704000 outlier
head(shopify[shopify$order_amount==704000,])

# Further examine without the bulk orders
shopify2 <- shopify[shopify$order_amount!=704000,]
plot(shopify2$total_items,shopify2$order_amount, 
     xlab="Order Size", ylab="Order Total Amount")

# Identify the shoes that sell for $25,725
shopify["product_price"] = shopify$order_amount/shopify$total_items
summary(shopify$product_price) # Max is $25,725, likely a luxury shoe seller?


iqr = as.double(quantile(shopify$order_amount)[4] - quantile(shopify$order_amount)[2])
upper = 3*(iqr) + as.double(quantile(shopify$order_amount)[4])
lower = as.double(quantile(shopify$order_amount)[2]) - 3*(iqr)

# Plot while excluding extreme outliers 
plot(shopify[shopify$order_amount<1071,]$order_amount, xlab="Order Size", ylab="Order Total")

# Calculate statistics

# Median
median(shopify$order_amount)

# Average total order amount without all outliers
mean(shopify[shopify$order_amount<730.5,]$order_amount)

# Average total order amount excluding only two groups, 
# without considering definition of outlier
mean(shopify[shopify$product_price < 25725 & shopify$total_items < 2000,]$order_amount)
