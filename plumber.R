library(plumber)
library(promises)
library(coro)
library(fastmap)

future::plan("multicore")

#* @param delay:int response delay, in ms
#* @param cpu:int spin wait time, in ms
#* @param mem:int memory to allocate, in MB
#* @param data:int zero bytes to return
#* @get /
index <- async(function(delay = 0L, cpu = 0L, mem = 0L, data = 0L) {
  
  # ;( https://github.com/rstudio/plumber/issues/762
  delay <- as.integer(delay)
  cpu   <- as.integer(cpu)
  mem   <- as.integer(mem)
  data  <- as.integer(data)
  
  vec <- raw(mem * 1048576)
  
  end <- Sys.time() + cpu / 1000
  while (Sys.time() < end) {
    NULL
  }
  
  remaining_delay <- max((delay - cpu) / 1000, 0)
  await(future_promise({
    Sys.sleep(remaining_delay)
  }))
  
  rawToChar(raw(data), multiple = TRUE)
})
