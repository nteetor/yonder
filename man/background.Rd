% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/design-background.R
\name{background}
\alias{background}
\title{Backgrounds}
\usage{
background(x, color)
}
\arguments{
\item{x}{A tag element or \link{.style} pronoun.}

\item{color}{One of \code{"primary"}, \code{"secondary"}, \code{"success"}, \code{"info"}, \code{"warning"}, \code{"danger"}, \code{"light"} or \code{"dark"} specifying the background color of the tag element, defaults to \code{NULL}.}
}
\description{
Use \code{background()} to modify the background color of a tag element.
}
\details{
\subsection{Input backgrounds}{

Input backgrounds will change differently according to the particular
input. Changing the background of a \code{buttonGroupInput()} will change the
background colors of the buttons in the group.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{buttonGroupInput(
  .style \%>\%
    background("info") \%>\%  # <-
    display("flex"),
  id = "flavors",
  choices = c("Mint", "Strawberry", "Swirl"),
  values = c("mint", "strawberry", "swirl")
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="yonder-button-group btn-group btn-group-info d-flex" id="flavors" role="group">
<button type="button" class="btn" value="mint">Mint</button>
<button type="button" class="btn" value="strawberry">Strawberry</button>
<button type="button" class="btn" value="swirl">Swirl</button>
</div>
}}


Changing the background of an input is different than changing a tag
element. More is done under the hood to apply the correct background
styles. For example, changing the background of a radio or checkbox
input changes the color of the selected choices.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{radioInput(
  .style \%>\%
    background("warning"),
  id = "drinks",
  choices = c("Limemade", "Lemonade", "Orangeade"),
  values = c("lime", "lemon", "orange"),
  selected = "lime"
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="yonder-radio bg-warning" id="drinks">
<div class="custom-control custom-radio">
<input class="custom-control-input" type="radio" id="radio-433-345" name="drinks" value="lime" checked autocomplete="off"/>
<label class="custom-control-label" for="radio-433-345">Limemade</label>
</div>
<div class="custom-control custom-radio">
<input class="custom-control-input" type="radio" id="radio-665-165" name="drinks" value="lemon" autocomplete="off"/>
<label class="custom-control-label" for="radio-665-165">Lemonade</label>
</div>
<div class="custom-control custom-radio">
<input class="custom-control-input" type="radio" id="radio-332-323" name="drinks" value="orange" autocomplete="off"/>
<label class="custom-control-label" for="radio-332-323">Orangeade</label>
<div class="valid-feedback"></div>
<div class="invalid-feedback"></div>
</div>
</div>
}}


If you needed to change the entire background of an input, you can wrap
the input in a \code{div()} and modify its background.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{div(
  .style \%>\%
    padding(2) \%>\%
    background("dark"),  # <-
  radioInput(
    .style \%>\%
      font("light") \%>\%
      background("success"),
    id = "valid",
    choices = c("Yes", "No"),
    values = c("y", "n"),
    selected = "n"
  )
)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="p-2 bg-dark">
<div class="yonder-radio text-light bg-success" id="valid">
<div class="custom-control custom-radio">
<input class="custom-control-input" type="radio" id="radio-274-68" name="valid" value="y" autocomplete="off"/>
<label class="custom-control-label" for="radio-274-68">Yes</label>
</div>
<div class="custom-control custom-radio">
<input class="custom-control-input" type="radio" id="radio-187-927" name="valid" value="n" checked autocomplete="off"/>
<label class="custom-control-label" for="radio-187-927">No</label>
<div class="valid-feedback"></div>
<div class="invalid-feedback"></div>
</div>
</div>
</div>
}}

}
}
\seealso{
Other design utilities: 
\code{\link{active}()},
\code{\link{affix}()},
\code{\link{border}()},
\code{\link{display}()},
\code{\link{flex}()},
\code{\link{float}()},
\code{\link{font}()},
\code{\link{height}()},
\code{\link{margin}()},
\code{\link{padding}()},
\code{\link{scroll}()},
\code{\link{shadow}()},
\code{\link{width}()}
}
\concept{design utilities}
