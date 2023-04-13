module App = {
  type state = Initializing | Done

  @react.component
  let make = () => {
    let (state, setState) = React.useState(() => Initializing)

    React.useEffect0(() => {
      Js.Global.setTimeout(() => {setState(_ => Done)}, 1_000)->ignore
      None
    })

    switch state {
    | Initializing =>
      <p style={lineHeight: "0.8rem"}>
        <Heroicons.Outline.ChevronDoubleDownIcon className="h-6 w-6 animate-bounce" />
        <span> {React.string("Initializing")} </span>
      </p>

    | Done =>
      <p style={lineHeight: "0.8rem"}>
        <Heroicons.Solid.CheckCircleIcon className="h-6 w-6" />
        <span> {React.string("Done")} </span>
      </p>
    }
  }
}

ReactDOM.querySelector("#app")
->Belt.Option.map(rootElement => {
  let root = ReactDOM.Client.createRoot(rootElement)
  ReactDOM.Client.Root.render(root, <App />)
})
->ignore
