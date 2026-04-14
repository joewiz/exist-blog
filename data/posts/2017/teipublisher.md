---
title: "TEI Publisher"
date: 2017-02-21
author: "magdalena"
tags:
  - "TEI single-source publishing"
  - "news"
  - "teipublisher"
status: published
migrated-from: AtomicWiki
original-id: "teipublisher"
original-url: "https://exist-db.org/exist/apps/wiki/blogs/eXist/teipublisher"
original-image-urls:
  - "https://exist-db.org/exist/apps/wiki/data/blogs/eXist/sebastian.jpg"

---

It is our great pleasure to announce the official release of the [TEI Publisher](http://teipublisher.com/index.html), an open source app for eXist-db offering single-source publishing without writing any code. Currently TEI Publisher works out of the box with [TEI](http://www.tei-c.org) documents (hence its name) but it can be customized to accommodate any XML schema.

Publishing any TEI content requires only few simple steps: 

* Upload the content into eXist
* Customize the appearance via TEI ODD file
* Generate a robust standalone application

Apps generated with TEI Publisher work well **across devices** and include features like **page by page** browsing, **search** and **cross-media export** or [side-by-side text and image display](http://showcases.exist-db.org/exist/apps/shakespeare-pm/works/F-ham.xml?odd=shakespeare.odd). 
This approach has been applied to a range of commercial and academic projects, and has proven very successful in terms of **development time, maintenance cost, performance and scalability**, an outstanding example being the [Foreign Relations of the United States series at the US Department of State](https://history.state.gov/).

TEI Publisher builds upon an efficient implementation of the [TEI Processing Model](http://www.tei-c.org/release/doc/tei-p5-doc/en/html/TD.html#TDPM), which has become a standard part of TEI Consortium’s recommendations, so customising the appearance of the text is done in TEI XML. No media specific stylesheets are required since rendition choices are transparently translated into different media types like HTML, XSL-FO, LaTeX, or ePUB.

TEI Publisher **empowers the editors**, offering **rapid publishing across media** while assuring full control over editorial decisions. 
For developers, TEI Publisher heavily reduces the amount of custom code required by typical digital edition. Transformations can be customized just by tweaking a single processing specification expressed in TEI ODD and changes are consistently carried through into all output formats. Highly formulaic and easily readable TEI ODD processing models **save thousands of lines** of handwritten transformations. Typically less than a few hundred lines of ODD instructions are sufficient to cover the needs even for projects of broad scope and volume, sustaining substantial everyday traffic. This means roughly **ten-fold decrease in code size alone**, not mentioning **drastic improvements in maintenance**.

<figure>
    <img src="sebastian.jpg" alt="Sebastian Rahtz sketching Wolfgang Meier's proposal for Processing Model extension"/>
    <figcaption>Sebastian Rahtz sketching Wolfgang Meier's proposal for Processing Model extension</figcaption>
</figure>

TEI Publisher is a result of serendipitous chain of events started with the TEI Processing Model developed by **TEI Simple** project. TEI Simple, funded by a generous grant from the Andrew W. Mellon Foundation, with substantial contributions from the Northwestern University, University of Nebraska-Lincoln, the University of Oxford, and the TEI Consortium was the work of the late Sebastian Rahtz and Martin Mueller with substantial contributions from James Cummings, Brian Pytlik Zillig, and Magdalena Turska. The integration of the Processing Model into the TEI infrastructure has been possible due to the efforts of the TEI Council with notable input of Lou Burnard. Implementation of the TEI Processing Model in XQuery has been the work of Wolfgang Meier and so was later the development of the TEI Publisher (initially under the name of _TEI Processing Model Toolbox_), made possible by strong support from eXist Solutions.

Having its roots in the TEI community, TEI Publisher is obviously well-suited to publishing TEI documents, but by no means are its applications limited to documents encoded in TEI (or TEI Simple) schema. Thanks to the universality of the Processing Model, the TEI Publisher can be made to work with any XML vocabulary as long as default processing models are defined for it. Moreover the processing model library can be used independently of the TEI Publisher app.

TEI Publisher is a free software released under GPLv3 licence. It requires eXist-db v3.0 and can be installed from the Dashboard via Package Manager.

We welcome and strongly encourage other contributions, both via community engagement and pull requests as well as financial support and other forms of cooperation. Ideas for future developments include:

* preconfigured app templates to cover specific TEI use cases like EpiDoc, epistolary corpora or manuscripts, as well as support for different layouts (e.g. facsimile display). We are looking for your suggestions and contributions in this area,
* more output options: we would welcome some TeX specialists to improve the current LaTeX output mode. There are also concrete plans concerning an interface to indesign,
* a visual ODD editor to facilitate creation of processing model instructions,
* extension for the TEI processing model library to transform other XML languages.

We hope you will find this project interesting and useful and encourage you to visit the [project website](http://teipublisher.com/index.html) and try it out together with new eXist-db release.

