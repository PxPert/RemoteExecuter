import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.0
import "Utility.js" as Utility

Button {
    style: ButtonStyle {
        panel: Item {
            implicitWidth: 320
            // implicitHeight: (txTesto.height + 16) > 100 ? (txTesto.height + 16) : 100
            implicitHeight: Utility.calcolaAltezza(64,Screen.pixelDensity,txTesto.height + 16)

            BorderImage {

                anchors.fill: parent
                antialiasing: true
                border.bottom: 8
                border.top: 8
                border.left: 8
                border.right: 8
                anchors.margins: control.pressed ? -4 : 0
                source: control.pressed ? "../images/button_pressed.png" : "../images/button_default.png"
                Text {
                    id: txTesto
                    text: control.text
                    anchors.centerIn: parent
                    color: "white"
                    font.pointSize: 18
                    renderType: Text.NativeRendering
                }
            }
        }
    }
}

