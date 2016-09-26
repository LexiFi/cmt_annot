cmt_annot
=========

`cmt_annot` is a small command-line program that reimplements the functionality
provided by `.annot` files using `.cmt` files instead.  Concretely, given a
`.cmt` file and a `(row, column)` location, it queries the file for type and
scope information.

Installation
------------

    opam install cmt_annot

Usage
-----

TBA

Editor support
--------------

### Emacs

TBA

Remarks
-------

In general, `cmt_annot` will only work with a single version of OCaml, since it
depends on the precise data structures used by the OCaml type checker.  This
should not be a problem if using the tool via `opam`.

About
-----

This package is licensed by LexiFi under the terms of the MIT license.

Contact: nicolas.ojeda.bar@lexifi.com
