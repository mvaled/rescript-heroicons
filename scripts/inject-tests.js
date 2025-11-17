const fs = require('fs');
const path = require('path');

function findIcons(ns, rescriptMod) {
    const Mod = require(ns);
    const result = [];
    for (let name of Object.keys(Mod)) {
        if (name.endsWith("Icon")) {
            result.push(name);
        }
    }
    return result;
}

const testFname = path.join(path.dirname(__dirname), "tests", "AllIcons.res")
const fh = fs.openSync(testFname, "w")

const outline = findIcons("@heroicons/react/24/outline", "HeroIcons.Outline");
const solid = findIcons("@heroicons/react/24/solid", "HeroIcons.Solid");

fs.writeSync(fh, `/// *** AUTOMATICALLY GENERATED FILE!
type kind = [#outline | #solid]
let icons: array<(kind, string, React.element)> = [
`);

for (icon of outline) {
    fs.writeSync(fh, `   (#outline, "${icon}", <HeroIcons.Outline.${icon} />),
`);
}
for (icon of solid) {
    fs.writeSync(fh, `   (#solid, "${icon}", <HeroIcons.Solid.${icon} />),
`);
}


fs.writeSync(fh, `]
`)
