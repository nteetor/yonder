% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input-form.R
\name{input_form}
\alias{input_form}
\alias{form_submit_button}
\alias{submit_form}
\title{Form inputs}
\usage{
input_form(id, ..., label = NULL, disable = FALSE, inline = FALSE)

form_submit_button(label, value = label, ...)

submit_form(id, session = get_current_session())
}
\arguments{
\item{id}{A character string. The id of the reactive input.}

\item{...}{Any number of unnamed arguments passed as child elements to the
parent form element or named arguments passed as HTML attributes to the
parent element. At least one \code{formSubmit()} must be included.}

\item{label}{A character string specifying the label of the form submit
button.}

\item{disable}{A character vector. The values disabled by default.}

\item{inline}{One of \code{TRUE} or \code{FALSE}, if \code{TRUE} the form and its child
elements are rendered in a horizontal row, defaults to \code{FALSE}. On small
viewports, think mobile device, \code{inline} intentionally has no effect and
the form will span multiple lines.}

\item{value}{A character string specifying the value of the form submit
button and the value of the form input when the button is clicked,
defaults to \code{label}.}

\item{session}{A shiny session object.}

\item{submit}{One of \code{TRUE} or \code{FALSE} or a character string specifying
whether to trigger a form submission, defaults to \code{FALSE}. If a character
string, the form is submitted and the reactive value passed is the character
string specified.}
}
\description{
Form inputs are a new reactive input. Form inputs are an alternative to
shiny's submit buttons. A form input is comprised of any number of inputs.
The value of these inputs will \emph{not} change until a form submit button within
the form input is clicked. A form input's reactive value depends on the
clicked form submit button. This allows you to distinguish between different
form submission types, think "login" versus "register".

A form submit button, \code{formSubmit()}, is a special type of button used to
control form input submission. A form input and its child reactive inputs
will \emph{never} update if a form submit button is not included in \code{...} passed
to \code{formInput()}.
}
\seealso{
Other inputs: 
\code{\link{fileInput}()},
\code{\link{input_button}()},
\code{\link{input_checkbox}()},
\code{\link{input_checkbox_button}()},
\code{\link{input_chip}()},
\code{\link{listGroupInput}()},
\code{\link{menuInput}()},
\code{\link{radioInput}()},
\code{\link{radiobarInput}()},
\code{\link{rangeInput}()},
\code{\link{selectInput}()},
\code{\link{textInput}()}
}
\concept{inputs}
