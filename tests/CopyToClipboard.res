@module("react-copy-to-clipboard") @react.component
external make: (
  ~children: React.element,
  ~text: string,
  ~onCopy: (string, bool) => unit=?,
) => React.element = "CopyToClipboard"
