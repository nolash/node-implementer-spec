# Swarm Node implementer spec

Documentation on how to create a custom Swarm node implementation

[https://github.com/ethersphere/user-stories/issues/50](https://github.com/ethersphere/user-stories/issues/50)

## Contents

The documents are in latex format, and are found in `./src`

Tools used for message serializations used in the documents can be found in `./tools`. They are written in `golang` and use libraries from the official `geth` and `swarm` implementations.

## Build

To build pdf with bibliography:

```
cd $REPO/src
pdflatex spec.latex
bibtex spec
pdflatex spec.latex
pdflatex spec.latex
```

## SWIP generation

First `cd $REPO/src`

Then generate the SWIP markdown from an individual chapter. If the chapter filename is `data.latex`, the command to generate the markdown is `sh make.sh data`. Markdown file will be named `data.md` and will reside in the `md` subdirectory. The script performs the following steps:

* convert latex citations to footnotes [1] 
* copy latex file to file with .tex suffix
* wraps the chapter in generic SWIP template header and footer 
* generates github markdown with pandoc 
* converts ABNF listings to tables

Lastly, merge the generated SWIP with the existing one. This preserves the metadata header at the top of the document. The command to merge is `sh swipmerge.sh md/data.md <swipfile>`

1.  `pandoc` can handle footnotes, but not citations
