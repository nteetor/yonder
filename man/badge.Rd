% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/badge.R
\name{badge}
\alias{badge}
\title{Badges}
\usage{
badge(..., appearance = c("default", "pill"))
}
\arguments{
\item{...}{Any number of child elements passed to the parent element. Named
values are passed as HTML attributes to the parent element.}

\item{appearance}{A string. The appearance of the badge.}
}
\value{
A \link[htmltools:builder]{htmltools::tag} object.
}
\description{
Highlight small pieces of content with badges. A badge's size scales with
their parent's size.
}
\examples{
\dontshow{if (rlang::is_interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

badge(99)

badge(
  class = "text-bg-primary",
  "New"
)
\dontshow{\}) # examplesIf}
}
\seealso{
Other components: 
\code{\link{alert}()},
\code{\link{collapse_panel}()},
\code{\link{d1}()},
\code{\link{modal_dialog}()},
\code{\link{toast}()}
}
\concept{components}
