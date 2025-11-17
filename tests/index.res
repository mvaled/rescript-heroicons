let getFullNs = ns =>
  switch ns {
  | #outline => "Heroicons.Outline"
  | #solid => "Heroicons.Solid"
  }

module App = {
  module Icon = {
    type state = {animating: bool}

    @react.component
    let make = (~ns: AllIcons.kind, ~name: string, ~children: React.element) => {
      let fullNs = ns->getFullNs

      <div
        className="group border border-gray-200 dark:border-gray-700 rounded-lg p-3 hover:shadow-lg transition-shadow duration-200">
        <div className="flex flex-col items-center">
          <div className="w-full aspect-square flex items-center justify-center p-3 mb-2">
            <div className="w-10 h-10"> {children} </div>
          </div>
          <h3
            className="text-center font-mono text-xs text-gray-700 dark:text-gray-300 mb-2 truncate w-full px-1">
            {React.string(name)}
          </h3>
          <div
            className="w-full transition-all
                       invisible group-hover:visible
                       opacity-0 group-hover:opacity-100
                       grid gap-2 grid-cols-2">
            <CopyToClipboard text={`<${fullNs}.${name} />`}>
              <button
                className="cursor-pointer px-2 py-1 text-xs rounded bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 transition-colors">
                {React.string("Copy JSX")}
              </button>
            </CopyToClipboard>
            <CopyToClipboard text={`${fullNs}.${name}`}>
              <button
                className="cursor-pointer px-2 py-1 text-xs rounded bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600 text-gray-700 dark:text-gray-300 transition-colors">
                {React.string("Copy name")}
              </button>
            </CopyToClipboard>
          </div>
        </div>
      </div>
    }
  }

  type entry = {ns: AllIcons.kind, name: string, el: React.element, words: string}
  let makeEntry: ((AllIcons.kind, string, React.element)) => entry = ((ns, name, el)) => {
    let uncamelized = %re("/([a-z0-9])([A-Z])/g")->Js.String.replaceByRe(name, "$1 $2")
    let words = [(ns :> string), name, uncamelized]
    {
      ns,
      name,
      el,
      words: words->Array.join(" "),
    }
  }
  type state = {
    entries: array<entry>,
    namespace: AllIcons.kind,
    query: option<string>,
    fzf: Fzf.t<entry>,
  }

  @react.component
  let make = (~icons: array<(AllIcons.kind, string, React.element)>) => {
    let entries = icons->Array.map(makeEntry)
    let (state, setState) = React.useState(_ => {
      entries,
      namespace: #solid,
      query: None,
      fzf: Fzf.make(entries, ~selector=({words}) => words),
    })

    let filteredByNamespace = state.entries->Array.filter(entry => entry.ns == state.namespace)

    let shown = switch state.query {
    | Some("") | None => filteredByNamespace
    | Some(query) => {
        let searchableFzf = Fzf.make(filteredByNamespace, ~selector=({words}) => words)
        let entries = searchableFzf->Fzf.find(query)
        entries->Array.map(entry => entry.item)
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
      <div className="mb-10 flex flex-col gap-2 mt-2">
        <div className="w-full m-auto relative rounded-md shadow-sm">
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
        // Namespace filter buttons
        <div className="flex justify-center">
          <div
            className="inline-flex rounded-full shadow-sm overflow-clip border border-gray-300 dark:border-gray-600"
            role="group">
            <button
              type_="button"
              className={`cursor-pointer px-4 py-2 text-sm font-medium ${state.namespace == #solid
                  ? "bg-blue-600 dark:bg-blue-500 text-white"
                  : "bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"}`}
              onClick={_ => setState(state => {...state, namespace: #solid})}>
              {React.string("Solid")}
            </button>
            <button
              type_="button"
              className={`cursor-pointer px-4 py-2 text-sm font-medium ${state.namespace == #outline
                  ? "bg-blue-600 dark:bg-blue-500 text-white"
                  : "bg-white dark:bg-gray-800 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700"}`}
              onClick={_ => setState(state => {...state, namespace: #outline})}>
              {React.string("Outline")}
            </button>
          </div>
        </div>
      </div>
      <div
        className="grid grid-cols-2 gap-6 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 2xl:grid-cols-8">
        {if shown->Array.length > 0 {
          shown
          ->Array.map(({ns, name, el}) =>
            <Icon key={`${ns->getFullNs}.${name}`} ns name> el </Icon>
          )
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
->Option.map(rootElement => {
  let root = ReactDOM.Client.createRoot(rootElement)
  ReactDOM.Client.Root.render(root, <App icons={AllIcons.icons} />)
})
->ignore
