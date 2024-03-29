% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input-chip.R
\name{chipInput}
\alias{chipInput}
\alias{updateChipInput}
\title{Chip inputs}
\usage{
chipInput(
  id,
  choices = NULL,
  values = choices,
  selected = NULL,
  ...,
  placeholder = NULL,
  max = Inf,
  inline = TRUE,
  sort = "stack"
)

updateChipInput(
  id,
  choices = NULL,
  values = choices,
  selected = NULL,
  max = NULL,
  enable = NULL,
  disable = NULL,
  session = getDefaultReactiveDomain()
)
}
\arguments{
\item{id}{A character string specifying the id of the reactive input.}

\item{choices}{A character vector or list specifying the possible choices.}

\item{values}{A character vector or list of strings specifying the input's
values, defaults to \code{choices}.}

\item{selected}{One or more of \code{values} specifying which values are selected
by default.}

\item{...}{Additional named arguments passed as HTML attributes to the
parent element or tag elements passed as child elements to the parent
element.}

\item{placeholder}{A character string specifying placeholder text of the
chip input, defaults to \code{NULL}.}

\item{max}{A number specifying the maximum number of items a user may select,
defaults to \code{Inf}.}

\item{inline}{One of \code{TRUE} or \code{FALSE} specifying if chips are rendered
inline. If \code{TRUE} multiple chips may fit onto a single row, otherwise, if
\code{FALSE}, chips expand to fill the width of their parent element, one chip
per row.}

\item{sort}{One of \code{"stack"}, \code{"queue"}, or \code{"fixed"} specifying how
selected chips are ordered, defaults to \code{"stack"}.

\code{"stack"}, selected chips are placed ahead of other selected chips.

\code{"queue"}, selected chips are placed behind other selected chips.

\code{"fixed"}, selected chips appear in the order specified by
\code{choices} and \code{values}. Use \code{"fixed"} and sort \code{choices} to keep selected
chips in the same sorted order.}

\item{enable}{One of \code{values} specifying particular choices to enable or
\code{TRUE} specifying the entire input is enabled, defaults to \code{NULL}.}

\item{disable}{One of \code{values} specifying particular choices to disable or
\code{TRUE} specifying the entire input is disabled, defaults to \code{NULL}.}

\item{session}{A reactive context, defaults to \code{\link[=getDefaultReactiveDomain]{getDefaultReactiveDomain()}}.}
}
\description{
The chip input is a selectize alternative. Choices are selected from a
dropdown menu and appear as chips below the input's text box. Chips do not
appear in the order they are selected. Instead chips are shown in the order
specified by the \code{choices} argument. Use the \code{max} argument to limit the
number of choices a user may select.
}
\details{
\subsection{Getting started}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{chipInput(
  .style \%>\% width(50),
  id = "chips",
  choices = paste("Option number", 1:10),
  values = 1:10,
  inline = TRUE
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div id="chips" class="yonder-chip btn-group dropup" data-max="-1" data-sort="stack">
<input class="form-control custom-select" data-toggle="dropdown"/>
<div class="dropdown-menu">
<button class="dropdown-item" value="1">Option number 1</button>
<button class="dropdown-item" value="2">Option number 2</button>
<button class="dropdown-item" value="3">Option number 3</button>
<button class="dropdown-item" value="4">Option number 4</button>
<button class="dropdown-item" value="5">Option number 5</button>
<button class="dropdown-item" value="6">Option number 6</button>
<button class="dropdown-item" value="7">Option number 7</button>
<button class="dropdown-item" value="8">Option number 8</button>
<button class="dropdown-item" value="9">Option number 9</button>
<button class="dropdown-item" value="10">Option number 10</button>
</div>
<div class="chips chips-inline chips-grey">
<button class="chip" value="1">
<span class="chip-content">Option number 1</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="2">
<span class="chip-content">Option number 2</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="3">
<span class="chip-content">Option number 3</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="4">
<span class="chip-content">Option number 4</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="5">
<span class="chip-content">Option number 5</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="6">
<span class="chip-content">Option number 6</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="7">
<span class="chip-content">Option number 7</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="8">
<span class="chip-content">Option number 8</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="9">
<span class="chip-content">Option number 9</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="10">
<span class="chip-content">Option number 10</span>
<span class="chip-close">&times;</span>
</button>
</div>
</div>
}}


\if{html}{\out{<div class="sourceCode r">}}\preformatted{chipInput(
  .style \%>\%
    width(50) \%>\%
    background("primary"),
  id = "chips",
  choices = c(
    "A rather long option, isn't it?",
    "Shorter",
    "A middle-size option",
    "One more"
  ),
  values = 1:4,
  fill = FALSE
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div id="chips" class="yonder-chip btn-group dropup" data-max="-1" data-sort="stack" fill="FALSE">
<input class="form-control custom-select" data-toggle="dropdown"/>
<div class="dropdown-menu">
<button class="dropdown-item" value="1">A rather long option, isn't it?</button>
<button class="dropdown-item" value="2">Shorter</button>
<button class="dropdown-item" value="3">A middle-size option</button>
<button class="dropdown-item" value="4">One more</button>
</div>
<div class="chips chips-inline chips-grey">
<button class="chip" value="1">
<span class="chip-content">A rather long option, isn't it?</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="2">
<span class="chip-content">Shorter</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="3">
<span class="chip-content">A middle-size option</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="4">
<span class="chip-content">One more</span>
<span class="chip-close">&times;</span>
</button>
</div>
</div>
}}


\if{html}{\out{<div class="sourceCode r">}}\preformatted{chipInput(
  id = "chip1",
  choices = c("Choice 1", "Choice 2", "Choice 3",
              "Choice 4", "Choice 5"),
  selected = c("Choice 3", "Choice 4")
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div id="chip1" class="yonder-chip btn-group dropup" data-max="-1" data-sort="stack">
<input class="form-control custom-select" data-toggle="dropdown"/>
<div class="dropdown-menu">
<button class="dropdown-item" value="Choice 1">Choice 1</button>
<button class="dropdown-item" value="Choice 2">Choice 2</button>
<button class="dropdown-item selected" value="Choice 3">Choice 3</button>
<button class="dropdown-item selected" value="Choice 4">Choice 4</button>
<button class="dropdown-item" value="Choice 5">Choice 5</button>
</div>
<div class="chips chips-inline chips-grey">
<button class="chip" value="Choice 1">
<span class="chip-content">Choice 1</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="Choice 2">
<span class="chip-content">Choice 2</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip active" value="Choice 3">
<span class="chip-content">Choice 3</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip active" value="Choice 4">
<span class="chip-content">Choice 4</span>
<span class="chip-close">&times;</span>
</button>
<button class="chip" value="Choice 5">
<span class="chip-content">Choice 5</span>
<span class="chip-close">&times;</span>
</button>
</div>
</div>
}}

}
}
\seealso{
Other inputs: 
\code{\link{buttonGroupInput}()},
\code{\link{buttonInput}()},
\code{\link{checkbarInput}()},
\code{\link{checkboxInput}()},
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
