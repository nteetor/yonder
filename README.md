# dull

A new approach to building Shiny applications.

dull is built on top of shiny and bootstrap 4 among other icon and javascript
libraries. This package provides new takes on many of the functionalities 
found in shiny. The user may find some aspects of the provided functions 
frustrating to begin with, for example there are some explict `*Input`
functions, but some reactive inputs are built into `Thruputs`. All UI functions
include a `...` argument to allow HTML attributes to be added for all parent
elements, however an explicit `id` argument is available for all reactive input,
output, update, or render functions.

While shiny has, in my opinion and rightfully so, remained accessible to new
users as new capabilities were added, dull is an effort to provide the user
more flexibility and open up new creative possibilities for shiny based 
applications. Additionally, I believe shiny's evolution over time has locked in
some paradigms that might otherwise be removed with a clean slate. dull hopes
to be that clean slate and much of what I sought to build into dull I later
found mirrored in the issues and requests raised under the shiny GitHub repo.

dull is not intended to replace shiny, dull builds upon shiny, and I hope dull
is a breath of fresh air and an exciting new tool for those who have loved 
working shiny thus far.

---
