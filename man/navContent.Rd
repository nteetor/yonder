% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/input-nav.R
\name{navContent}
\alias{navContent}
\alias{navPane}
\alias{showNavPane}
\alias{hideNavPane}
\title{Navigation panes}
\usage{
navContent(...)

navPane(id, ..., fade = TRUE)

showNavPane(id, session = getDefaultReactiveDomain())

hideNavPane(id, session = getDefaultReactiveDomain())
}
\arguments{
\item{...}{For \strong{navContent}, any number of nav panes passed as child
elements to the nav parent element or named arguments passed as HTML
attributes to the parent element.

For \strong{navPane}, any number of unnamed arguments passed as tag elements to
the parent element or named arguments passed as HTML elements to the
parent element.}

\item{id}{A character string specifying the id of the nav pane.}

\item{fade}{One of \code{TRUE} or \code{FALSE} specifying if the pane fades in when
shown and fades out when hidden, defaults to \code{TRUE}.}

\item{session}{A reactive context, defaults to \code{\link[=getDefaultReactiveDomain]{getDefaultReactiveDomain()}}.}
}
\description{
These functions pair with \code{\link[=navInput]{navInput()}}. Use \code{navContent()} and \code{navPane()} to
create the pane layout. To show a new pane use \code{showNavPane()} from within an
observer. \code{showNavPane()} will also hide a previously active pane. If needed
you can hide an active pane with \code{hideNavPane()}. \code{hideNavPane()} is useful
when you do not have a new pane to show, but want to hide the current active
pane.
}
\section{App with pills}{


\if{html}{\out{<div class="sourceCode R">}}\preformatted{ui <- container(
  navInput(
    id = "tabs",
    choices = paste("Tab", 1:3),
    values = paste0("pane", 1:3),
    appearance = "pills"
  ),
  navContent(
    navPane(
      id = "pane1",
      "Nullam tristique diam non turpis.",
      "Cum sociis natoque penatibus et magnis dis parturient montes, ",
      "nascetur ridiculus mus.",
      "Etiam laoreet quam sed arcu.",
      "Curabitur vulputate vestibulum lorem."
    ),
    navPane(
      id = "pane2",
      "Praesent fermentum tempor tellus.",
      "Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.",
      "Phasellus lacus.",
      "Nam euismod tellus id erat."
    ),
    navPane(
      id = "pane3",
      "Nullam eu ante vel est convallis dignissim.",
      "Phasellus at dui in ligula mollis ultricies.",
      "Fusce suscipit, wisi nec facilisis facilisis, est dui ",
      "fermentum leo, quis tempor ligula erat quis odio.",
      "Donec hendrerit tempor tellus."
    )
  )
)

server <- function(input, output) \{
  observeEvent(input$tabs, \{
    showNavPane(input$tabs)
  \})
\}

shinyApp(ui, server)
}\if{html}{\out{</div>}}
}

\section{App with dropdown}{


\if{html}{\out{<div class="sourceCode R">}}\preformatted{ui <- container(
  navInput(
    id = "tabs",
    choices = list(
      "Tab 1",
      dropdown(
        label = "Tab 2",
        buttonInput("action", "Action"),
        buttonInput("another", "Another action")
      ),
      "Tab 3"
    ),
    values = paste0("pane", 1:3),
    appearance = "tabs"
  ),
  navContent(
    navPane(
      id = "pane1",
      "Donec at pede.",
      "Pellentesque tristique imperdiet tortor.",
      "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
    ),
    navPane(
      id = "pane2",
      "Nullam tristique diam non turpis.",
      "Cras placerat accumsan nulla.",
      "Donec at pede."
    ),
    navPane(
      id = "pane3",
      "Phasellus purus.",
      "Etiam laoreet quam sed arcu.",
      "Donec pretium posuere tellus."
    )
  )
)

server <- function(input, output) \{
  observeEvent(input$tabs, \{
    showNavPane(input$tabs)
  \})

  observeEvent(c(input$action, input$another), \{
    if (input$action > 0 || input$another > 0) \{
      showNavPane("pane2")
    \}
  \})
\}

shinyApp(ui, server)
}\if{html}{\out{</div>}}
}

\section{App with multiple sets of panes}{


\if{html}{\out{<div class="sourceCode R">}}\preformatted{ui <- container(
  navInput(
    id = "tabs",
    choices = paste("Tab", 1:3),
    values = paste0("pane", 1:3)
  ),
  columns(
    column(
      navContent(
        navPane(
          id = "pane1_1",
          "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
          "venenatis vestibulum. Praesent commodo cursus magna, vel ",
          "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
          "augue laoreet rutrum faucibus dolor auctor."
        ),
        navPane(
          id = "pane2_1",
          "Nullam quis risus eget urna mollis ornare vel eu leo. ",
          "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
          "magna, vel scelerisque nisl consectetur et."
        ),
        navPane(
          id = "pane3_1",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
          "Vivamus sagittis lacus vel augue laoreet rutrum faucibus ",
          "dolor auctor. Etiam porta sem malesuada magna mollis euismod."
        )
      )
    ),
    column(
      navContent(
        navPane(
          id = "pane1_2",
          "Aenean eu leo quam. Pellentesque ornare sem lacinia quam ",
          "venenatis vestibulum. Praesent commodo cursus magna, vel ",
          "scelerisque nisl consectetur et. Vivamus sagittis lacus vel ",
          "augue laoreet rutrum faucibus dolor auctor."
        ),
        navPane(
          id = "pane2_2",
          "Nullam quis risus eget urna mollis ornare vel eu leo. ",
          "Maecenas faucibus mollis interdum. Praesent commodo cursus ",
          "magna, vel scelerisque nisl consectetur et."
        ),
        navPane(
          id = "pane3_2",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
          "Vivamus sagittis lacus vel augue laoreet rutrum faucibus ",
          "dolor auctor. Etiam porta sem malesuada magna mollis euismod."
        )
      )
    )
  )
)

server <- function(input, output) \{
  observeEvent(input$tabs, \{
    showNavPane(paste0(input$tabs, "_1"))
    showNavPane(paste0(input$tabs, "_2"))
  \})
\}

shinyApp(ui, server)
}\if{html}{\out{</div>}}
}

\examples{

### Examples

# Because these are server-side utilities please see the example applications
# above.

}
\seealso{
Other components: 
\code{\link{alert}()},
\code{\link{badge}()},
\code{\link{blockquote}()},
\code{\link{card}()},
\code{\link{collapsePane}()},
\code{\link{d1}()},
\code{\link{dropdown}()},
\code{\link{img}()},
\code{\link{jumbotron}()},
\code{\link{modal}()},
\code{\link{popover}()},
\code{\link{pre}()},
\code{\link{toast}()}
}
\concept{components}
