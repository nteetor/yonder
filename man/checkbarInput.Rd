% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input-checkbar.R
\name{checkbarInput}
\alias{checkbarInput}
\alias{updateCheckbarInput}
\title{Checkbar input}
\usage{
checkbarInput(..., id, choices = NULL, values = choices, selected = NULL)

updateCheckbarInput(
  id,
  choices = NULL,
  values = choices,
  selected = NULL,
  enable = NULL,
  disable = NULL,
  session = getDefaultReactiveDomain()
)
}
\arguments{
\item{...}{Additional named arguments passed as HTML attributes to the
parent element or tag elements passed as child elements to the parent
element.}

\item{id}{A character string specifying the id of the reactive input.}

\item{choices}{A character vector or list of tag element specifying the
input's choices, defaults to \code{NULL}.}

\item{values}{A vector of values specifying the values of the input's
choices, defaults to \code{choices}.}

\item{selected}{One or more of \code{values} specifying the input's default
selected values, defaults to \code{NULL}.}

\item{enable}{One of \code{values} specifying particular choices to enable or
\code{TRUE} specifying the entire input is enabled, defaults to \code{NULL}.}

\item{disable}{One of \code{values} specifying particular choices to disable or
\code{TRUE} specifying the entire input is disabled, defaults to \code{NULL}.}

\item{session}{A reactive context, defaults to \code{\link[=getDefaultReactiveDomain]{getDefaultReactiveDomain()}}.}
}
\description{
A stylized checkbox input. The checkbar input appears similar to a group of
buttons, but with a checked or highlighted state.
}
\details{
\subsection{Getting started}{

Checkbars will expand to fill the width of their parent element.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{checkbarInput(
  .style \%>\%
    background("secondary"),
  id = NULL,
  choices = c("Choice 1", "Choice 2", "Choice 3")
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="yonder-checkbar btn-group btn-group-toggle d-flex bg-secondary" data-toggle="buttons">
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 1"/>
Choice 1
</label>
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 2"/>
Choice 2
</label>
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 3"/>
Choice 3
</label>
</div>
}}


If you want to adjust the width you can use the \code{width()} utility.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{checkbarInput(
  .style \%>\%
    background("secondary") \%>\%
    width(50),  # <-
  id = NULL,
  choices = c("Choice 1", "Choice 2", "Choice 3")
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="yonder-checkbar btn-group btn-group-toggle d-flex bg-secondary w-50" data-toggle="buttons">
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 1"/>
Choice 1
</label>
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 2"/>
Choice 2
</label>
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 3"/>
Choice 3
</label>
</div>
}}

}

\subsection{Background color}{

Like other inputs, checkbar inputs apply modified background styles

\if{html}{\out{<div class="sourceCode r">}}\preformatted{checkbarInput(
  .style \%>\%
    background("info"),
  id = NULL,
  choices = c("Choice 1", "Choice 2")
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="yonder-checkbar btn-group btn-group-toggle d-flex bg-info" data-toggle="buttons">
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 1"/>
Choice 1
</label>
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 2"/>
Choice 2
</label>
</div>
}}

}

\subsection{Labelling}{

Use a \code{formGroup()} to add a label or help text to checkbar input.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{formGroup(
  label = "Label",  # <-
  checkbarInput(
    .style \%>\%
      border("dark") \%>\%
      font("light"),
    id = NULL,
    choices = c("Choice 1", "Choice 2")
  ),
  help = "Help text about the input"
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="form-group">
<label>Label</label>
<div class="yonder-checkbar btn-group btn-group-toggle d-flex border border-dark text-light" data-toggle="buttons">
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 1"/>
Choice 1
</label>
<label class="btn">
<input type="checkbox" autocomplete="off" value="Choice 2"/>
Choice 2
</label>
</div>
<small class="form-text text-muted">Help text about the input</small>
</div>
}}

}
}
\seealso{
Other inputs: 
\code{\link{buttonGroupInput}()},
\code{\link{buttonInput}()},
\code{\link{checkboxInput}()},
\code{\link{chipInput}()},
\code{\link{fileInput}()},
\code{\link{formInput}()},
\code{\link{listGroupInput}()},
\code{\link{menuInput}()},
\code{\link{navInput}()},
\code{\link{radioInput}()},
\code{\link{radiobarInput}()},
\code{\link{rangeInput}()},
\code{\link{selectInput}()},
\code{\link{textInput}()}
}
\concept{inputs}
