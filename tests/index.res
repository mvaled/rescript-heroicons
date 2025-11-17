module App = {
  module Icon = {
    type state = {animating: bool}

    @react.component
    let make = (~ns: string, ~name: string, ~children: React.element) => {
      <div className="group border border-gray-200 dark:border-gray-700 rounded-lg p-3 hover:shadow-lg transition-shadow duration-200">
        <div className="flex flex-col items-center">
          <div className="w-full aspect-square flex items-center justify-center p-3 mb-2">
            <div className="w-10 h-10">
              {children}
            </div>
          </div>
          <h3 className="text-center font-mono text-xs text-gray-700 dark:text-gray-300 mb-2 truncate w-full px-1">
            {React.string(name)}
          </h3>
          <div
            className="w-full transition-all
                       invisible group-hover:visible
                       opacity-0 group-hover:opacity-100
                       grid gap-2 grid-cols-2">
            <CopyToClipboard text={`<${ns}.${name} />`}>
              <button
                className="px-2 py-1 text-xs rounded bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 transition-colors">
                {React.string("Copy JSX")}
              </button>
            </CopyToClipboard>
            <CopyToClipboard text={`${ns}.${name}`}>
              <button
                className="px-2 py-1 text-xs rounded bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 transition-colors">
                {React.string("Copy name")}
              </button>
            </CopyToClipboard>
          </div>
        </div>
      </div>
    }
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
      fzf: Fzf.make(entries, ~selector=({words}) => words),
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
      /// Search input
      <div className="mb-10">
        <div className="w-1/2 m-auto relative mt-2 rounded-md shadow-sm">
          <input
            type_="text"
            name="query"
            autoComplete="false"
            className="block w-full rounded-md border-0 py-1.5 pl-7 pr-20
               bg-white dark:bg-gray-800
               text-gray-900 dark:text-gray-100
               ring-1 ring-inset ring-gray-300 dark:ring-gray-600
               placeholder:text-gray-400 dark:placeholder:text-gray-500
               focus:ring-1 focus:ring-inset
               focus:ring-indigo-100 dark:focus:ring-indigo-900 sm:text-sm sm:leading-6"
            placeholder="Filter"
            onChange={onSearchChange}
          />
          <div className="absolute inset-y-0 right-2 flex items-center">
            <HeroIcons.Outline.MagnifyingGlassIcon
              className="w-5 h-5 text-gray-400 dark:text-gray-500"
            />
          </div>
        </div>
      </div>
      <div
        className="grid grid-cols-2 gap-6 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8">
        {if shown->Belt.Array.length > 0 {
          shown
          ->Belt.Array.map(({ns, name, el}) => <Icon key={`${ns}.${name}`} ns name> el </Icon>)
          ->React.array
        } else {
          <span className="text-gray-700 dark:text-gray-300">
            {React.string("Nothing found")}
          </span>
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
