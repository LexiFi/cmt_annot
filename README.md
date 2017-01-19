cmt_annot
=========

`cmt_annot` is a small command-line program that reimplements the functionality
provided by `.annot` files using `.cmt` files instead.  Concretely, given a
`.cmt` file and a `(line, column)` location, it queries the file for type and
scope information.

Installation
------------

Using opam:

    opam pin add cmt_annot git://github.com/LexiFi/cmt_annot

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

When invoked with `-type` the result can either be

  - `nil` if no expression was found at the given location, or

  - `(l1 c1 l2 c2 s)` where `(l1, c1)` and `(l2, c2)` are the `(line, column)` starting
    and ending positions of the term at the given location and `s` is a string (in the
    OCaml `%S` format) describing the type of the term.

When invoked with `-ident` the result can either be:

  - `nil` if no identifier was found at the given location, or

  - `(l1 c1 l2 c2 s k)` where `(l1, c1)` and `(l2, c2)` have the same meaning as
    before, `s` is the fully qualified form of the identifier in question as a
    string, and `k` is one of:

    - `external`: the identifier is defined outside of the current module.

    - `internal l1 c1 l2 c2`: the identifier is a variable reference, and `(l1, c1)`, `(l2, c2)`
      determine its place of definition in the current module.

    - `local-variable l1 c1 l2 c2`: the identifier is a local `let`-binding (this includes identifiers
      bound in patterns) and `(l1, c1)`, `(l2, c2)` determine its *scope*.

    - `global-variable l1 c1 l2 c2`: the identifier is a global `let`-binding and `(l1, c1)`, `(l2, c2)`
      determine its *scope*.

Emacs bindings
--------------

The file `cmt_annot.el` adds support for this tool to the standard `caml-mode`
included in the standard OCaml distribution.  To use it, make sure that this
file and the `caml-mode` package is in your `load-path` and add

    (require 'cmt_annot)

somewhere in your `.emacs` or `init.el` files.  The tool `cmt_annot` should be
in your `$PATH` as well (this is automatically the case when using `opam`).

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
