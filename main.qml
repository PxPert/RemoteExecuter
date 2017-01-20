import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import "componenti"
import "storage.js" as Storage
import "qrc:/componenti/Utility.js" as Utility

ApplicationWindow {
    title: qsTr("Remote Executer")
    width: 640
    height: 480
    visible: true

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    toolBar: BorderImage {
        border.bottom: 8
        source: "images/toolbar.png"
        width: parent.width
        // height: (titoloApplicazione.height * 1.5) > 60 ? (titoloApplicazione.height * 1.5) : 60
        height: Utility.calcolaAltezza(64,Screen.pixelDensity,titoloApplicazione.height * 1.5)

        // height: titoloApplicazione.height * 1.3

        Rectangle {
            id: backButton
            height: parent.height * 0.8
            width: opacity ? parent.height : 0

            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                source: "images/navigation_previous_item.png"
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: stackView.pop()
            }
        }

        Text {
            id: titoloApplicazione
            font.pointSize: 22
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: qsTr("Remote Executer")
        }

        Rectangle {
            id: optionButton
            height: parent.height * 0.8
            width: opacity ? parent.height : 0
            anchors.right: parent.right
            anchors.rightMargin: 20

            opacity:
                (stackView.currentItem === null || stackView.currentItem.toolButtonImage === undefined || stackView.currentItem.toolButtonImage === null || stackView.currentItem.toolButtonImage === "")?0:1
            // opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            radius: 4
            color: optionmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                width: height
                height: parent.height
                // x: 6
                // y: 6
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                property string immagine: (stackView.currentItem === null || stackView.currentItem.toolButtonImage === undefined || stackView.currentItem.toolButtonImage === null || stackView.currentItem.toolButtonImage === "")?"":stackView.currentItem.toolButtonImage
                onImmagineChanged: {
                    if (immagine != "")
                    {
                        source = immagine
                    }
                }



            }
            MouseArea {
                id: optionmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: {
                    if (stackView.currentItem != null && stackView.currentItem.eventoToolButton !== undefined)
                    {
                        stackView.currentItem.eventoToolButton();
                    }
                }

                // onClicked: stackView.pop()
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        // Implements back key navigation
        focus: true
        Keys.onReleased: {
            if (event.key === Qt.Key_Back && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
            }
            if (event.key === Qt.Key_Menu) {
                if (stackView.currentItem != null && stackView.currentItem.eventoMenu !== undefined)
                {
                    stackView.currentItem.eventoMenu();
                    event.accepted = true;
                }
            }

        }

        onCurrentItemChanged: {
            aggiornaTitolo();
        }

        function aggiornaTitolo() {

            titoloApplicazione.text = ((currentItem == null)||(currentItem.nomeFinestra === undefined))?initialItem.nomeFinestra:currentItem.nomeFinestra;
        }


        initialItem: SelettoreSSH {
            property string nomeFinestra: qsTr("Remote Executer")
            property string toolButtonImage: "images/ic_action_new.png"

            
            Menu {

                id: menuGenerico
                MenuItem {
                        text: qsTr("Nuova sessione")
                        onTriggered: selettoreSSH.eseguiAggiungiSessione();
                }
                MenuSeparator {

                }

                MenuItem {
                    text: "Esci"
                    onTriggered: Qt.quit()
                }
            }
            function eventoMenu() {
                menuGenerico.popup();

            }

            function eventoToolButton() {
                eseguiAggiungiSessione();
            }

            function eseguiAggiungiSessione() {
                stackView.push({item: componentModificaParametri});
                stackView.currentItem.modifica(-1);
            }

            id: selettoreSSH
            x: 0
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 0
            width: parent.width
            onAggiungiSessione: {
                eseguiAggiungiSessione();
            }

            onModificaSessione: {
                stackView.push({item: componentModificaParametri});
                stackView.currentItem.modifica(indice);
            }

            onEliminaSessione: {
                var listaSessioni = Storage.getSessioni();
                confermaCancellazione.nome = listaSessioni[indice].nome;
                confermaCancellazione.indice = indice;
                confermaCancellazione.show();
            }

            onEseguiSessione: {


                var listaSessioni = Storage.getSessioni();
                confermaEsecuzione.nome = listaSessioni[indice].nome;
                confermaEsecuzione.indice = indice;
                confermaEsecuzione.show();

            }


        }
    }


    Component {
        id: componentModificaParametri
        ModificaParametri {
            id: modificaParametri
            onSalva: {
                    selettoreSSH.popolaListaSessioni();
            }
        }
    }

    Component {
        id: componentefinestraSSH
        FinestraSSH {
            id: finestraSSH
        }
    }

    MessageDialog {
        id: messageDialog
        /*
        Keys.onReleased:  {
            console.log("CHIAVE!!!")
            if (event.key === Qt.Key_Back && stackView.depth > 1) {
                messageDialog.close();
            }
        }
        */
        function show(title, caption) {
            messageDialog.title = title
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    MessageDialog {
        id: confermaCancellazione
        property int indice;
        property string nome;
        title: qsTr("Elimina comando");

        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            var listaSessioni = Storage.getSessioni();
            listaSessioni.splice(indice,1);
            Storage.setSessioni(listaSessioni);
            selettoreSSH.popolaListaSessioni();

        }
        /*
        Keys.onReleased:  {
            console.log("CHIAVE!!!")
            if (event.key === Qt.Key_Back && stackView.depth > 1) {
                confermaCancellazione.close();
            }
        }
        */
        function show() {
            confermaCancellazione.text = qsTr("Eliminare ") + nome + "?";
            confermaCancellazione.open();
        }
    }

    MessageDialog {
        id: confermaEsecuzione
        property int indice;
        property string nome;
        title: qsTr("Esegui comando");
/*
        Keys.onReleased:  {
            console.log("CHIAVE!!!")
            if (event.key === Qt.Key_Back && stackView.depth > 1) {
                confermaEsecuzione.close();
            }
        }
*/

        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            stackView.push({item: componentefinestraSSH});
            stackView.currentItem.eseguiSSH(Storage.getSessioni()[indice]);

        }

        function show() {
            confermaEsecuzione.text = qsTr("Eseguire ") + nome + "?";
            confermaEsecuzione.open();
        }
    }
}
