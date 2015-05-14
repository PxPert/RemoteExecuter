import QtQuick 2.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls 1.2

TextField {
    id: txNomeComando

    style: TextFieldStyle {
        textColor: "white"
        placeholderTextColor: "grey"
        font.pixelSize: 28
        background: Item {
            implicitHeight: 50
            implicitWidth: 320
            BorderImage {
                source: "../images/textinput.png"
                border.left: 8
                border.right: 8
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }
    }
}

