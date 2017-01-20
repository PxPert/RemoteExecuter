.pragma library
.import QtQuick.Window 2.0 as LocalWindow

function calcolaAltezza(altezza, pixelDensity, min) {
    return Math.max(Math.round(altezza * (pixelDensity / 9.5)) ,min);
}
