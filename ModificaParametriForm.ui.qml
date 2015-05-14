import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import "componenti"


Item {
    id: root
    height: 600
    property alias btOk: btOk
    property alias btTest: btTest

    property alias cancella : txNomeComando

    property alias nome : txNomeComando.text
    property alias indirizzoServer: txIndirizzoServer.text
    property alias username : txUsername.text
    property alias password : txPassword.text
    property alias comandoDaEseguire : txComandoDaEseguire.text
    property alias pty : ckPTY.checked
    width: 400

    Row {
        id: row1
        y: 362
        height: btOk.height
        spacing: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8

        CustomButton {
            id: btTest
            width: (parent.width - parent.spacing) / 2
            text: qsTr("Test")
        }

        CustomButton {
            width: (parent.width - parent.spacing) / 2
            id: btOk
            text: qsTr("OK")
        }

    }


    Flickable {
        id: fkContenitoreGriglia
        contentHeight: parent.height > 400?parent.height:400
        interactive: true
        flickableDirection: Flickable.VerticalFlick
        anchors.bottom: row1.top
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        clip: true
        ColumnLayout {
            id: layoutContenitore
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            anchors.bottomMargin: 8
            anchors.topMargin: 8
            anchors.fill: parent


            CustomTextInput {
                id: txNomeComando
                placeholderText: qsTr("Nome Comando")
                Layout.fillWidth: true
            }

            CustomTextInput {
                id: txIndirizzoServer
                placeholderText: qsTr("Indirizzo Server")
                Layout.fillWidth: true
            }

            CustomTextInput {
                id: txUsername
                placeholderText: qsTr("Username")
                Layout.fillWidth: true
            }


            CustomTextInput {
                id: txPassword
                z: 2
                echoMode: 2
                inputMask: qsTr("")
                placeholderText: qsTr("Password")
                Layout.fillWidth: true
            }


            CustomSwitch {
                id:ckPTY
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                text: qsTr("PTY (A volte richiesto)")
            }

            CustomTextInput {
                id: txComandoDaEseguire
                transformOrigin: Item.Left
                placeholderText: qsTr("Comando da eseguire")
                Layout.fillWidth: true
            }






        }
    }
}

