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
  | @as("smart-case") #smart
  | @as("case-sensitive") #sensitive
  | @as("case-insensitive") #insensitive
]

type options<'item> = {
  selector: 'item => string,
  casing: option<casing>,
}

%%private(
  @new @module("fzf")
  external _make: (array<'item>, ~options: options<'item>, unit) => t<'item> = "Fzf"
)
let make = (items, ~selector: 'item => string) =>
  _make(
    items,
    ~options={
      selector,
      casing: Some(#insensitive),
    },
  )

@send external find: (t<'item>, string) => array<entry<'item>> = "find"
