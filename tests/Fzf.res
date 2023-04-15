@@doc("Small binding and opinionated bindings to fzf")

type t<'item>
type entry<'item> = {
  item: 'item,
  start: int,
  end: int,
  score: float,
  positions: array<int>,
}
type casing = [
  | #"smart-smart"
  | #"case-sensitive"
  | #"case-insensitive"
]

type options<'item> = {
  selector?: 'item => string,
  casing?: casing,
}

%%private(
  @new @module("fzf")
  external _make: (array<'item>, ~options: options<'item>, unit) => t<'item> = "Fzf"
)
let make = (items, ~selector: 'item => string) =>
  _make(items, ~options={selector, casing: #"case-insensitive"}, ())

@send external find: (t<'item>, string) => array<entry<'item>> = "find"
