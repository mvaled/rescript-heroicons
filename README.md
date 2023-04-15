# Kaiko's ReScript binding to @heroicons/react

This is a fork of [Jazz's original work](#original-author), it was updated to
Heroicons 2 and rescript 10.1 with JSX 4.

To avoid clashes with the old package, the namespace was changed to
'HeroIcons'.

[Live gallery](https://kaiko-systems.gitlab.io/rescript-heroicons-react/).


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


### Development

1. Update the dependencies, if needed, and install: `yarn install`.

2. Update the script `scripts/builder.js` to adjust to new versions, etc.

3. Generate the modules with `npm run generate`

4. Run the test server `npm run run` and go to http://localhost:8000 to watch the live examples.


### Original author


Nyi Nyi Than (Jazz)
- LinkedIn: [@nyinyithann](https://www.linkedin.com/in/nyinyithan/)
- Twitter: [@JazzTuyat](https://twitter.com/JazzTuyat)

### License

MIT
