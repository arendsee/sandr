#' SAND access and assignment functions
#'
#' Functions for accessing elements of a SAND object, accessing and casting
#' sand classes, and viewing documentation.
#'
#' \code{as.sand} is particularly noteworthy. Any data frame can be case as a
#' sand object. Then it can be written into a SAND format data directory with
#' the \code{write_sand} function. This will automatically generate default
#' COLUMN.tsv and TYPE.tsv files. So this is the starting point for building a
#' new SAND project.
#'
#' @param x anything
#' @param field a column name from the dataset
#' @param value object on right side of assignment
#' @name access
NULL

#' @rdname access
#' @export
is.sand <- function(x){
  'sand' %in% class(x)
}

#' @rdname access
#' @export
as.sand <- function(x){

  if(is.sand(x)) return(x)

  if(is.data.frame(x)){
    x <- tibble::as_data_frame(x)
    class(x) <- c('sand', class(x))
    meta(x) <- tibble::data_frame(variable = names(x))
    desc(x) <- "No description\n"
    return(x)
  }

  stop("Cannot convert object of class '%s' to sand", paste0(class(x), collapse=", "))
}

#' @rdname access
#' @export
desc <- function(x){
  attributes(x)$desc
}

#' @rdname access
#' @export
meta <- function(x){
  as.data.frame(attributes(x)$meta)
}

#' @rdname access
#' @export
type <- function(x){
  as.data.frame(attributes(x)$type)
}

#' @rdname access
#' @export
`desc<-` <- function(x, value){
  attributes(x)$desc <- value
  x
}

#' @rdname access
#' @export
`meta<-` <- function(x, value){
  attributes(x)$meta <- value
  x
}

#' @rdname access
#' @export
`type<-` <- function(x, value){
  attributes(x)$type <- value
  x
}

#' @rdname access
#' @export
field_info <- function(x, field){
  if(!field %in% meta(x)[[1]]){
    stop(sprintf("'%s' is not a field in '%s'", field, deparse(substitute(x))))
  }
  d <- tibble::as_data_frame(meta(x))[meta(x)[[1]] == field, ] 
  for(name in names(d)){
    cat(sprintf('%s\n  %s\n', name, d[1, name]))
  }
}
