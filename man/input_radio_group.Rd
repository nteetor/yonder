% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input-radio-group.R
\name{input_radio_group}
\alias{input_radio_group}
\alias{update_radio_group}
\title{Radio inputs}
\usage{
input_radio_group(
  id,
  choices,
  ...,
  values = choices,
  select = NULL,
  disable = NULL,
  appearance = c("default", "buttons", "switches", "list"),
  layout = c("column", "row"),
  label = c("after", "before")
)

update_radio_group(
  id,
  choices = NULL,
  values = choices,
  select = NULL,
  disable = NULL,
  session = get_current_session()
)
}
\arguments{
\item{id}{A character string. The id of the reactive input.}

\item{choices}{A character vector or list. The labels for the input choices.}

\item{...}{Optional named arguments specifying HTML attributes for the input
element.}

\item{values}{A character vector. The values for the input, defaults to
\code{choices}.}

\item{select}{A character vector. The values selected by default, one or more
of \code{values}.}

\item{disable}{A character vector. The values disabled by default.}

\item{appearance}{A character string. The appearance of the input's choices.}

\item{layout}{A character string. The layout of the choices.}

\item{label}{A character string. The placement of a label relative to its
checkbox.}

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
\code{\link{input_form}()},
\code{\link{input_list_group}()},
\code{\link{input_menu}()},
\code{\link{input_multi_select}()},
\code{\link{input_numeric}()},
\code{\link{input_range}()},
\code{\link{input_select}()},
\code{\link{input_text}()},
\code{\link{input_text_group}()}
}
\concept{inputs}
