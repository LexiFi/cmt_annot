cmt_annot
=========

`cmt_annot` is a small command-line program that reimplements the functionality
provided by `.annot` files using `.cmt` files instead.  Concretely, given a
`.cmt` file and a `(line, column)` location, it queries the file for type and
scope information.

Installation
------------

Using opam:

    opam install cmt_annot

Or simply build it by doing

    make

and then copy the resulting `cmt_annot` (or `cmt_annot.exe` if on Windows) to
somewhere suitable.

Usage
-----

```
Usage: cmt_annot [-type | -ident] <filename> <startline> <startcol> [<endline> <endcol>]
  -v      Print timings
  -type   Query type
  -ident  Query ident
  -help   Display this list of options
  --help  Display this list of options
```

At the moment, results are returned in s-expression syntax.

Emacs bidings
-------------

The file `caml-types-cmt.el` adds support for this tool to the package
`caml-types.el` included in the standard OCaml distribution.  To use it,
make sure that this file is in your `load-path` and add

    (require 'caml-types-cmt)

somewhere in your `.emacs` or `init.el` files.  The tool `cmt_annot` should
be in your `$PATH` (this is automatically the case when using `opam`).

Contributions to improve this code are highly welcome.

Vim bindings
------------

None for the moment.  Contributions highly welcomed.

Remarks
-------

Since `cmt_annot` depends on the precise data structures used by the OCaml type
checker, it may not work when dealing with more than one OCaml versions at the
same time.  This should not be much of an issue when using `opam`.

About
-----

This package is licensed by LexiFi under the terms of the MIT license.

Contact: nicolas.ojeda.bar@lexifi.com
