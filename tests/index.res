module App = {
  module Icon = {
    @react.component
    let make = (~ns: string, ~name: string, ~children: React.element) =>
      <div className="group bg-gray-200 rounded-lg p-1 overflow-hidden">
        <h3 className="text-center font-mono mt-1 text-sm text-gray-700"> {React.string(ns)} </h3>
        <div
          className="aspect-h-1 aspect-w-1 w-full p-20 bg-white
                     xl:aspect-h-8 xl:aspect-w-7">
          children
        </div>
        <h3 className="text-center font-mono mt-2 text-sm text-gray-700"> {React.string(name)} </h3>
      </div>
  }

  type entry = {ns: string, name: string, el: React.element, words: string}
  let makeEntry = ((ns, name, el)) => {
    let uncamelized = %re("/([a-z0-9])([A-Z])/g")->Js.String.replaceByRe(name, "$1 $2")
    let words = [ns, name, uncamelized]->Belt.Array.concat(ns->Js.String.split("."))
    {
      ns,
      name,
      el,
      words: words->Belt.Array.joinWith(" ", x => x),
    }
  }
  type state = {
    entries: array<entry>,
    query: option<string>,
    fzf: Fzf.t<entry>,
  }

  @react.component
  let make = (~icons: array<(string, string, React.element)>) => {
    let entries = icons->Belt.Array.map(makeEntry)
    let (state, setState) = React.useState(_ => {
      entries,
      query: None,
      fzf: Fzf.make(entries, ~selector=({words}) => words, ()),
    })

    let shown = switch state.query {
    | Some("") | None => state.entries
    | Some(query) => {
        Js.Console.log2("Filtering", query)
        let entries = state.fzf->Fzf.find(query)
        Js.Console.log(entries)
        entries->Belt.Array.map(entry => entry.item)
      }
    }

    let onSearchChange = e => {
      let query = switch (e->ReactEvent.Form.target)["value"] {
      | val => Some(val)
      | exception _ => None
      }
      setState(_ => {...state, query})
    }

    <div className="font-mono">
      <h1 className="font-mono text-2xl text-center m-8"> {React.string("HeroIcons")} </h1>
      /// Search input
      <div className="mb-10">
        <div className="w-1/2 m-auto relative mt-2 rounded-md shadow-sm">
          <input
            type_="text"
            name="query"
            autoComplete="false"
            className="block w-full rounded-md border-0 py-1.5 pl-7 pr-20
               text-gray-900 ring-1 ring-inset ring-gray-300
               placeholder:text-gray-400 focus:ring-1 focus:ring-inset
               focus:ring-indigo-100 sm:text-sm sm:leading-6"
            placeholder="Filter"
            onChange={onSearchChange}
          />
          <div className="absolute inset-y-0 right-2 flex items-center">
            <Outline.MagnifyingGlassIcon className="w-5 h-5" />
          </div>
        </div>
      </div>
      <div
        className="grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 xl:gap-x-8">
        {if shown->Belt.Array.length > 0 {
          shown
          ->Belt.Array.map(({ns, name, el}) => <Icon key={`${ns}.${name}`} ns name> el </Icon>)
          ->React.array
        } else {
          React.string("Nothing found")
        }}
      </div>
    </div>
  }
}

ReactDOM.querySelector("#app")
->Belt.Option.map(rootElement => {
  let root = ReactDOM.Client.createRoot(rootElement)
  ReactDOM.Client.Root.render(root, <App icons={AllIcons.icons} />)
})
->ignore
