% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input-radio-group.R
\name{input_radio_group}
\alias{input_radio_group}
\alias{update_radio_group}
\title{Radio inputs}
\usage{
input_radio_group(
  id,
  choices = NULL,
  ...,
  values = choices,
  select = NULL,
  disable = NULL,
  appearance = c("default", "buttons", "list")
)

update_radio_group(
  id,
  choices = NULL,
  values = choices,
  selected = NULL,
  inline = FALSE,
  enable = NULL,
  disable = NULL,
  valid = NULL,
  invalid = NULL,
  session = getDefaultReactiveDomain()
)
}
\arguments{
\item{id}{A character string. The id of the reactive input.}

\item{choices}{A character vector or list of tag elements specifying the
input's choices.}

\item{...}{Optional named arguments specifying HTML attributes for the input
element.}

\item{values}{A character vector, list of character strings, vector of values
to coerce to character strings, or list of values to coerce to character
strings specifying the values of the radio input's choices, defaults to
\code{choices}.}

\item{disable}{A boolean. The checkbox starts disabled if \code{TRUE}.}

\item{selected}{One of \code{values} indicating the default selected value of the
radio input, defaults to \code{NULL}, in which case the first choice is
selected by default.}

\item{inline}{If \code{TRUE}, the radio input renders inline, defaults to \code{FALSE},
in which case the radio controls render on separate lines.}

\item{session}{A shiny session object.}
}
\description{
A stylized radio input. A reactive input with multiple choices where only one
choice and value at most may be selected.
}
\seealso{
Other inputs: 
\code{\link{fileInput}()},
\code{\link{input_button}()},
\code{\link{input_checkbox}()},
\code{\link{input_checkbox_group}()},
\code{\link{input_chip}()},
\code{\link{input_form}()},
\code{\link{input_list_group}()},
\code{\link{input_menu}()},
\code{\link{radiobarInput}()},
\code{\link{rangeInput}()},
\code{\link{selectInput}()},
\code{\link{textInput}()}
}
\concept{inputs}
