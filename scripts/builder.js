const fs = require('fs');
const path = require('path');

function generateNs(ns, where) {
  const Mod = require(ns);
  let fh = fs.openSync(where, "w");

  for (let name of Object.keys(Mod)) {
    if (name.endsWith("Icon")) {
      fs.writeSync(fh, generateModule(ns, name));
    }
  }
}


function generateModule(ns, module) {
  return `
module ${module} = {
  @module("${ns}") @scope("${module}")
  external make: JsxDOM.domProps => React.element = "render"
}
`
}

generateNs(
  "@heroicons/react/24/outline",
  path.join(path.dirname(__dirname), "src", "HeroIcons__Outline.res")
)

generateNs(
  "@heroicons/react/24/solid",
  path.join(path.dirname(__dirname), "src", "HeroIcons__Solid.res")
)
