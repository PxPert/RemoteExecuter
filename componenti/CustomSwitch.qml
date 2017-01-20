import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Item {
    id: item1
    implicitHeight: lbDescrizione.height
    // implicitWidth: gvSwitch.width + lbDescrizione.implicitWidth + 8
    property alias text: lbDescrizione.text
    property alias checked: componente.checked

    CustomLabel {
        id: lbDescrizione
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
    }

    Switch {
        id: componente
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 8
        style:  SwitchStyle {


            groove: Rectangle {
                id: gvSwitch
                implicitHeight: lbDescrizione.height
                implicitWidth: (txSwitchOn.width > txSwitchOff.width)? (txSwitchOn.width * 2.4) :(txSwitchOff.width * 2.4)
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: parent.width/2 - 2
                    // height: 20
                    anchors.margins: 2
                    color: control.checked ? "#468bb7" : "#222"
                    Behavior on color {ColorAnimation {}}
                    Text {
                        id: txSwitchOn
                        font.pixelSize: lbDescrizione.height * 0.8
                        color: "white"
                        anchors.centerIn: parent
                        text: "ON"
                    }
                }
                Item {
                    width: parent.width/2
                    height: parent.height
                    anchors.right: parent.right
                    Text {
                        id: txSwitchOff
                        font.pixelSize: lbDescrizione.height * 0.8
                        color: "white"
                        anchors.centerIn: parent
                        text: "OFF"
                    }
                }
                color: "#222"
                border.color: "#444"
                border.width: 2
            }
            handle: Rectangle {
                width: parent.parent.width/2
                height: control.height
                color: "#444"
                border.color: "#555"
                border.width: 2
            }
        }
    }

}

