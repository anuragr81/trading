
is.POSIXlt <- function(x) inherits(x, "POSIXlt")

get_signal_at_point <- function(date_vector,price_vector) {

}
get_signal_vector <- function(date_vector,price_vector) {
  if (!is.numeric(price_vector)) {
    stop("price_vector must be numeric");
  }
  if (!is.POSIXlt(date_vector)){
    stop("date_vector must be POSIXlt");
  }
  # use within or apply
  # within(x[2,],{print(sum(a));})
}
