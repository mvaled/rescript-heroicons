# Kaiko's ReScript binding to @heroicons/react

This is a fork of [Jazz's original work](#original-author), it was updated to
Heroicons 2 and rescript 10.1 with JSX 4.

To avoid clashes with the old package, the namespace was changed to
'HeroIcons'.


## Overview

With this binding, heroicons can be used as ReScript-React Components.

```OCaml
open HeroIcons

@react.component
let make = () => {
  <div>
    <Solid.PaperAirplaneIcon className="w-8 h-8" ariaHidden=true />
    <Outline.PaperAirplaneIcon className="w-8 h-8" ariaHidden=true/>
  </div>
}
(* w-8, h-8 are tailwind css classes.*)
```

### Installation

`yarn add @kaiko.io/rescript-heroicons-react` <br> or <br> `npm install @kaiko.io/rescript-heroicons-react` <br> <br>


In `bsconfig.json`:

```json 
"bs-dependencies": ["@kaiko.io/rescript-heroicons-react"]
```

The binding has the following dependencies, and they have to be installed.

- [@rescript/react](https://www.npmjs.com/package/@rescript/react)
- [@heroicons/react](https://www.npmjs.com/package/@heroicons/react)


### Original author


Nyi Nyi Than (Jazz)
- LinkedIn: [@nyinyithann](https://www.linkedin.com/in/nyinyithan/)
- Twitter: [@JazzTuyat](https://twitter.com/JazzTuyat)

### License

MIT
