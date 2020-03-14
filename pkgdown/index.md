
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="kw">d3</span>(<span class="st">&quot;yonder&quot;</span>)</span></code></pre></div>
<!--html_preserve-->
<h1 class="display-3">
yonder
</h1>
<!--/html_preserve-->
<p class="lead">
A shiny framework.
</p>
<!--html_preserve-->
<p class="lead">
Build shiny applications with an all new set of
inputs, utilties, and design tools. Click
<button class="yonder-link btn btn-link" data-toggle="collapse" data-target=".hasCopyButton">here</button>
to see these great new tools help build pieces of this page.
</p>
<!--/html_preserve-->
<h2 id="inputs">Inputs</h2>
<div class="row">
<div class="col-md-6 col-12">
<p>New inputs let you build a variety of user interfaces. Develop the best ui for
your users’ needs. Whether you are building an application for personal use,
internal use, or public use an intuitive ui helps guide users through your
application.</p>
</div>
<div class="col-md-6 col-12">
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co"># button group input</span></span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="kw">div</span>(</span>
<span id="cb2-3"><a href="#cb2-3"></a>  .style <span class="op">%&gt;%</span></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="st">    </span><span class="kw">display</span>(<span class="st">&quot;flex&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="st">    </span><span class="kw">flex</span>(<span class="dt">justify =</span> <span class="st">&quot;center&quot;</span>),</span>
<span id="cb2-6"><a href="#cb2-6"></a>  <span class="kw">buttonGroupInput</span>(</span>
<span id="cb2-7"><a href="#cb2-7"></a>    .style <span class="op">%&gt;%</span></span>
<span id="cb2-8"><a href="#cb2-8"></a><span class="st">      </span><span class="kw">background</span>(<span class="st">&quot;primary&quot;</span>),</span>
<span id="cb2-9"><a href="#cb2-9"></a>    <span class="dt">id =</span> <span class="ot">NULL</span>,</span>
<span id="cb2-10"><a href="#cb2-10"></a>    <span class="dt">choices =</span> <span class="kw">c</span>(<span class="st">&quot;Sample&quot;</span>, <span class="st">&quot;Model&quot;</span>, <span class="st">&quot;Download&quot;</span>)</span>
<span id="cb2-11"><a href="#cb2-11"></a>  )</span>
<span id="cb2-12"><a href="#cb2-12"></a>)</span></code></pre></div>
<!--html_preserve-->
<div class="d-flex justify-content-center">
<div class="yonder-button-group btn-group btn-group-primary" role="group">
<button type="button" class="btn" value="Sample">
Sample
</button>
<button type="button" class="btn" value="Model">
Model
</button>
<button type="button" class="btn" value="Download">
Download
</button>
</div>
</div>
<!--/html_preserve-->
</div>
</div>
<div class="row">
<div class="col-md-6 col-12">
<p>As shiny developers we are not only developing programs and scripts for a
variety of users we are developing applications for many different devices.</p>
<p>Yonder’s inputs are ready for both mobile and web. Once you include</p>
</div>
<div class="col-md-6 col-12">
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb3-1"><a href="#cb3-1"></a><span class="co"># list group input</span></span>
<span id="cb3-2"><a href="#cb3-2"></a><span class="kw">div</span>(</span>
<span id="cb3-3"><a href="#cb3-3"></a>  .style <span class="op">%&gt;%</span></span>
<span id="cb3-4"><a href="#cb3-4"></a><span class="st">    </span><span class="kw">display</span>(<span class="st">&quot;flex&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb3-5"><a href="#cb3-5"></a><span class="st">    </span><span class="kw">flex</span>(<span class="dt">align =</span> <span class="st">&quot;center&quot;</span>, <span class="dt">justify =</span> <span class="st">&quot;center&quot;</span>),</span>
<span id="cb3-6"><a href="#cb3-6"></a>  <span class="kw">card</span>(</span>
<span id="cb3-7"><a href="#cb3-7"></a>    .style <span class="op">%&gt;%</span></span>
<span id="cb3-8"><a href="#cb3-8"></a><span class="st">      </span><span class="kw">border</span>(<span class="st">&quot;info&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb3-9"><a href="#cb3-9"></a><span class="st">      </span><span class="kw">background</span>(<span class="st">&quot;info&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb3-10"><a href="#cb3-10"></a><span class="st">      </span><span class="kw">font</span>(<span class="st">&quot;light&quot;</span>),</span>
<span id="cb3-11"><a href="#cb3-11"></a>    <span class="dt">header =</span> <span class="st">&quot;Learn more&quot;</span>,</span>
<span id="cb3-12"><a href="#cb3-12"></a>    <span class="kw">listGroupInput</span>(</span>
<span id="cb3-13"><a href="#cb3-13"></a>      .style <span class="op">%&gt;%</span></span>
<span id="cb3-14"><a href="#cb3-14"></a><span class="st">        </span><span class="kw">background</span>(<span class="st">&quot;info&quot;</span>),</span>
<span id="cb3-15"><a href="#cb3-15"></a>      <span class="dt">flush =</span> <span class="ot">TRUE</span>,</span>
<span id="cb3-16"><a href="#cb3-16"></a>      <span class="dt">id =</span> <span class="ot">NULL</span>,</span>
<span id="cb3-17"><a href="#cb3-17"></a>      <span class="dt">choices =</span> <span class="kw">c</span>(<span class="st">&quot;About&quot;</span>, <span class="st">&quot;Our process&quot;</span>, <span class="st">&quot;Partners&quot;</span>, <span class="st">&quot;License&quot;</span>)</span>
<span id="cb3-18"><a href="#cb3-18"></a>    )</span>
<span id="cb3-19"><a href="#cb3-19"></a>  )</span>
<span id="cb3-20"><a href="#cb3-20"></a>)</span></code></pre></div>
<!--html_preserve-->
<div class="d-flex justify-content-center align-items-center">
<div class="card border border-info bg-info text-light">
<div class="card-header">
Learn more
</div>
<div class="yonder-list-group list-group list-group-flush list-group-info">
<button class="list-group-item list-group-item-action" value="About">
About
</button>
<button class="list-group-item list-group-item-action" value="Our process">
Our process
</button>
<button class="list-group-item list-group-item-action" value="Partners">
Partners
</button>
<button class="list-group-item list-group-item-action" value="License">
License
</button>
</div>
</div>
</div>
<!--/html_preserve-->
</div>
</div>
<h2 id="designs">Designs</h2>
<div class="row">
<div class="col-12">
<p>Based on the widely used Bootstrap library, yonder provides a series of design
utilities to help prototype and produce the shiny apps you imagine.</p>
</div>
</div>
<div class="row">
<div class="col-4-md col-12">
<p>That control panel never has to sit on the left again.</p>
</div>
<div class="col-8-md col-12">
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb4-1"><a href="#cb4-1"></a><span class="kw">div</span>(</span>
<span id="cb4-2"><a href="#cb4-2"></a>  .style <span class="op">%&gt;%</span></span>
<span id="cb4-3"><a href="#cb4-3"></a><span class="st">    </span><span class="kw">width</span>(<span class="dv">100</span>) <span class="op">%&gt;%</span></span>
<span id="cb4-4"><a href="#cb4-4"></a><span class="st">    </span><span class="kw">padding</span>(<span class="dv">2</span>) <span class="op">%&gt;%</span></span>
<span id="cb4-5"><a href="#cb4-5"></a><span class="st">    </span><span class="kw">display</span>(<span class="st">&quot;flex&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb4-6"><a href="#cb4-6"></a><span class="st">    </span><span class="kw">flex</span>(<span class="dt">justify =</span> <span class="st">&quot;center&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb4-7"><a href="#cb4-7"></a><span class="st">    </span><span class="kw">border</span>(<span class="st">&quot;dark&quot;</span>, <span class="dt">round =</span> <span class="st">&quot;all&quot;</span>),</span>
<span id="cb4-8"><a href="#cb4-8"></a>  <span class="kw">card</span>(</span>
<span id="cb4-9"><a href="#cb4-9"></a>    <span class="dt">header =</span> <span class="st">&quot;Controls&quot;</span>,</span>
<span id="cb4-10"><a href="#cb4-10"></a>    <span class="kw">formGroup</span>(</span>
<span id="cb4-11"><a href="#cb4-11"></a>      <span class="dt">label =</span> <span class="st">&quot;Options&quot;</span>,</span>
<span id="cb4-12"><a href="#cb4-12"></a>      <span class="kw">selectInput</span>(</span>
<span id="cb4-13"><a href="#cb4-13"></a>        <span class="dt">id =</span> <span class="ot">NULL</span>,</span>
<span id="cb4-14"><a href="#cb4-14"></a>        <span class="dt">choices =</span> <span class="kw">c</span>(<span class="st">&quot;Option 1&quot;</span>, <span class="st">&quot;Option 2&quot;</span>, <span class="st">&quot;Option 3&quot;</span>)</span>
<span id="cb4-15"><a href="#cb4-15"></a>      )</span>
<span id="cb4-16"><a href="#cb4-16"></a>    ),</span>
<span id="cb4-17"><a href="#cb4-17"></a>    <span class="kw">buttonInput</span>(</span>
<span id="cb4-18"><a href="#cb4-18"></a>      .style <span class="op">%&gt;%</span></span>
<span id="cb4-19"><a href="#cb4-19"></a><span class="st">        </span><span class="kw">background</span>(<span class="st">&quot;primary&quot;</span>),</span>
<span id="cb4-20"><a href="#cb4-20"></a>      <span class="dt">id =</span> <span class="ot">NULL</span>,</span>
<span id="cb4-21"><a href="#cb4-21"></a>      <span class="dt">label =</span> <span class="st">&quot;Run&quot;</span></span>
<span id="cb4-22"><a href="#cb4-22"></a>    )</span>
<span id="cb4-23"><a href="#cb4-23"></a>  )</span>
<span id="cb4-24"><a href="#cb4-24"></a>)</span></code></pre></div>
<!--html_preserve-->
<div class="w-100 p-2 d-flex justify-content-center border border-dark rounded">
<div class="card">
<div class="card-header">
Controls
</div>
<div class="card-body">
<div class="form-group">
<label>Options</label>
<div class="yonder-select">
<input type="text" class="form-control custom-select" data-toggle="dropdown" data-boundary="window" placeholder="Option 1"/>
<div class="dropdown-menu">
<button class="dropdown-item active" value="Option 1">
Option 1
</button>
<button class="dropdown-item" value="Option 2">
Option 2
</button>
<button class="dropdown-item" value="Option 3">
Option 3
</button>
</div>
<div class="valid-feedback">

</div>
<div class="invalid-feedback">

</div>
</div>
</div>
<button autocomplete="off" class="yonder-button btn btn-primary" role="button" type="button">
Run
</button>
</div>
</div>
</div>
<!--/html_preserve-->
</div>
</div>
<div class="row mt-5">
<div class="col-12">
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb5-1"><a href="#cb5-1"></a><span class="kw">div</span>(</span>
<span id="cb5-2"><a href="#cb5-2"></a>  .style <span class="op">%&gt;%</span></span>
<span id="cb5-3"><a href="#cb5-3"></a><span class="st">    </span><span class="kw">width</span>(<span class="dv">100</span>) <span class="op">%&gt;%</span></span>
<span id="cb5-4"><a href="#cb5-4"></a><span class="st">    </span><span class="kw">padding</span>(<span class="dv">2</span>) <span class="op">%&gt;%</span></span>
<span id="cb5-5"><a href="#cb5-5"></a><span class="st">    </span><span class="kw">display</span>(<span class="st">&quot;flex&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb5-6"><a href="#cb5-6"></a><span class="st">    </span><span class="kw">flex</span>(<span class="dt">justify =</span> <span class="st">&quot;end&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb5-7"><a href="#cb5-7"></a><span class="st">    </span><span class="kw">border</span>(<span class="st">&quot;dark&quot;</span>, <span class="dt">round =</span> <span class="st">&quot;all&quot;</span>),</span>
<span id="cb5-8"><a href="#cb5-8"></a>  <span class="kw">dropdown</span>(</span>
<span id="cb5-9"><a href="#cb5-9"></a>    .style <span class="op">%&gt;%</span></span>
<span id="cb5-10"><a href="#cb5-10"></a><span class="st">      </span><span class="kw">background</span>(<span class="st">&quot;secondary&quot;</span>),</span>
<span id="cb5-11"><a href="#cb5-11"></a>    <span class="dt">label =</span> <span class="st">&quot;Menu&quot;</span>,</span>
<span id="cb5-12"><a href="#cb5-12"></a>    <span class="kw">h5</span>(<span class="st">&quot;Controls&quot;</span>) <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">margin</span>(<span class="dt">r =</span> <span class="dv">3</span>, <span class="dt">l =</span> <span class="dv">3</span>),</span>
<span id="cb5-13"><a href="#cb5-13"></a>    <span class="kw">formInput</span>(</span>
<span id="cb5-14"><a href="#cb5-14"></a>      .style <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">padding</span>(<span class="dt">r =</span> <span class="dv">3</span>, <span class="dt">l =</span> <span class="dv">3</span>),</span>
<span id="cb5-15"><a href="#cb5-15"></a>      <span class="dt">id =</span> <span class="ot">NULL</span>,</span>
<span id="cb5-16"><a href="#cb5-16"></a>      <span class="kw">formGroup</span>(</span>
<span id="cb5-17"><a href="#cb5-17"></a>        <span class="dt">label =</span> <span class="st">&quot;Target&quot;</span>,</span>
<span id="cb5-18"><a href="#cb5-18"></a>        <span class="dt">input =</span> <span class="kw">textInput</span>(</span>
<span id="cb5-19"><a href="#cb5-19"></a>          <span class="dt">id =</span> <span class="ot">NULL</span></span>
<span id="cb5-20"><a href="#cb5-20"></a>        )</span>
<span id="cb5-21"><a href="#cb5-21"></a>      ),</span>
<span id="cb5-22"><a href="#cb5-22"></a>      <span class="kw">formGroup</span>(</span>
<span id="cb5-23"><a href="#cb5-23"></a>        <span class="dt">label =</span> <span class="st">&quot;Description&quot;</span>,</span>
<span id="cb5-24"><a href="#cb5-24"></a>        <span class="dt">input =</span> <span class="kw">textInput</span>(</span>
<span id="cb5-25"><a href="#cb5-25"></a>          <span class="dt">id =</span> <span class="ot">NULL</span></span>
<span id="cb5-26"><a href="#cb5-26"></a>        )</span>
<span id="cb5-27"><a href="#cb5-27"></a>      ),</span>
<span id="cb5-28"><a href="#cb5-28"></a>      <span class="kw">buttonInput</span>(</span>
<span id="cb5-29"><a href="#cb5-29"></a>        .style <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">background</span>(<span class="st">&quot;primary&quot;</span>),</span>
<span id="cb5-30"><a href="#cb5-30"></a>        <span class="dt">id =</span> <span class="ot">NULL</span>,</span>
<span id="cb5-31"><a href="#cb5-31"></a>        <span class="dt">label =</span> <span class="st">&quot;Update&quot;</span></span>
<span id="cb5-32"><a href="#cb5-32"></a>      )</span>
<span id="cb5-33"><a href="#cb5-33"></a>    )</span>
<span id="cb5-34"><a href="#cb5-34"></a>  )</span>
<span id="cb5-35"><a href="#cb5-35"></a>)</span></code></pre></div>
<!--html_preserve-->
<div class="w-100 p-2 d-flex justify-content-end border border-dark rounded">
<div class="dropdown btn-group-secondary">
<button class="btn dropdown-toggle" type="button" data-toggle="dropdown" aria-haspop="true" aria-expanded="false">
Menu
</button>
<div class="dropdown-menu">
<h5 class="mr-3 ml-3">
Controls
</h5>
<form class="yonder-form pr-3 pl-3">
<div class="form-group">
<label>Target</label>
<div class="yonder-textual">
<input class="form-control" type="text" autocomplete="off"/>
<div class="valid-feedback">

</div>
<div class="invalid-feedback">

</div>
</div>
</div>
<div class="form-group">
<label>Description</label>
<div class="yonder-textual">
<input class="form-control" type="text" autocomplete="off"/>
<div class="valid-feedback">

</div>
<div class="invalid-feedback">

</div>
</div>
</div>
<button autocomplete="off" class="yonder-button btn dropdown-item btn-primary" role="button" type="button">
Update
</button>
</form>
</div>
</div>
</div>
<!--/html_preserve-->
</div>
</div>
<div class="row">
<div class="col-md-4 col-12">
<p>Convey more.</p>
</div>
</div>
<div class="row">
<div class="col-12 d-flex justify-content-center">
<div class="display-4 my-3">
<p>… and much <a href="reference/index.html">more</a>!</p>
</div>
</div>
</div>
