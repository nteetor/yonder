% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input-button.R
\name{update_button}
\alias{update_button}
\alias{update_link}
\title{Change button}
\usage{
update_button(
  id,
  label = NULL,
  value = NULL,
  disable = NULL,
  session = get_current_session()
)

update_link(
  id,
  label = NULL,
  value = NULL,
  disable = NULL,
  session = get_current_session()
)
}
\arguments{
\item{value}{A number specifying a new value for the button, defaults to
\code{NULL}.}

\item{disable}{A boolean or \code{NULL}.
\itemize{
\item If \code{TRUE}, the button is disabled and will not react to clicks from the user.
\item If \code{FALSE}, the button is enabled.
\item If \code{NULL}, the argument is ignored.
}}

\item{session}{A reactive context, defaults to \code{\link[=get_current_session]{get_current_session()}}.}
}
\description{
Change button.
}
