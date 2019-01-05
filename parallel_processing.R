# Load the benchmarkme package
library("benchmarkme")

# Assign the variable ram to the amount of RAM on this machine
ram <- get_ram()
ram

# Assign the variable cpu to the cpu specs
cpu <- get_cpu()
cpu

# How many cores do I have?
library("parallel")
detectCores()

# Run the io benchmark
res <- benchmark_io(runs = 1, size = 50)

# Plot the results
plot(res)

# Never, ever grow a vector!
# Slow code
n <- 30000

growing <- function(n) {
    x <- NULL
    for(i in 1:n)
        x <- c(x, rnorm(1))
    x
}

system.time(res_grow <- growing(n))

# This is better...
# Fast code
pre_allocate <- function(n) {
    x <- numeric(n) # Pre-allocate
    for(i in 1:n) 
        x[i] <- rnorm(1)
    x
}

system.time(res_allocate <- pre_allocate(n))

#####################################

x <- rnorm(10)

# Why do this...
x2 <- numeric(length(x))
for(i in 1:10)
    x2[i] <- x[i] * x[i]

# ... when you can just do this (vectorized solution)...
x2_imp <- x * x

# Another example of preferring a vectorized solution...
# Initial code
n <- 100
total <- 0
x <- runif(n)
for(i in 1:n) 
    total <- total + log(x[i])

# Rewrite in a single line. Store the result in log_sum
log_sum <- sum(log(x))

####################################

# Parallel processing and specifying the number of cores to use.
# Also see parSapply and parLapply
copies_of_r = 3 # Specify the number of cores
m = matrix(1000,100)
cl = makeCluster(copies_of_r) # create a cluster object
parApply(cl, m, 1, median)
stopCluster(cl)

exportCluster(
