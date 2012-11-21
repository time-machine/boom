# boom changes

## 0.1.1
- Don't force Redis on everyone.

## 0.1.0
- boom has been rewritten to use multiple backends. Use `boom switch <backend>`
  to switch from the default JSON backend. Currently only Redis is supported.
  Pull Requests are welcome.

## 0.0.10
- `boom open` will open the Item's URL in a browser, or it'll open all the URLs
  in a List for you. Thanks [lwe](https://github.com/lwe).
- Values for item creation can have spaces, and then they get concat'ed as one
  value. Thanks [lwe](https://github.com/lwe).
- Replacing an item no longer dupes the item; it'll just replace the value.
  Thank god, finally. Thanks [thbishop](https://github.com/thbishop).
- Also started `completion/`, a place to drop in scripts to set up completion
  support for boom. Starting out with [thbishop](https://github.com/thbishop)'s
  bash script, but if anyone has something for zsh I'd kiss them a bit.
- `boom echo` (and `boom e`) just echos the value; great for command-line
   scripts and junk! Thanks [bschaeffer](https://github.com/bschaeffer).

## 0.0.9
- Backport `Symbol#to_proc` for 1.8.6 support (thanks
  [kastner](https://github.com/kastner) and
  [DeMarko](https://github.com/DeMarko)).

## 0.0.8
- Support for Ruby 1.9 (thanks [jimmycuadra](https://github.com/jimmycuadra)).

## 0.0.7
- Reverts item creation from stdin, since it broke regular item creation.

## 0.0.6
- Searching for an item that doesn't exist doesn't murder puppies anymore
  (thanks [jimmycuadra](https://github.com/jimmycuadra)).
- Output is a bit cleaner with a constrained `name` column.
- Adds items from stdin (thanks
  [MichaelXavier](https://github.com/MichaelXavier)).

## 0.0.5
- Item deletes are now scoped by list rather than GLOBAL DESTRUCTION! (thanks
  [natebean](https://github.com/natebean)).
- Command line options, like `boop --help` are translated into `boom help`. In
  the future we play around with options a bit more.

## 0.0.4
- Adds `boom help`. You know, for help.

## 0.0.3
- `boom edit` to edit your stuff in a friendly $EDITOR.
- Class-level accessors in List for ActiveRecordesque actions.

## 0.0.2
- Fix for list selection (thanks [bgkittrell](https://github.com/bgkittrell)).

## 0.0.1
- BOOM!
