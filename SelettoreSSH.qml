import QtQuick 2.4
import QtQuick.Controls 1.2
import "componenti"
import "storage.js" as Storage

Item {
    id: root
    signal aggiungiSessione;
    signal modificaSessione(int indice);
    signal eliminaSessione(int indice);
    signal eseguiSessione(int indice);

    function popolaListaSessioni() {
        return form.popolaListaSessioni();
    }


    SelettoreSSHForm {
        id: form
        anchors.fill: parent
    /*    property alias currentIndex : lvServers.currentIndex */


        function popolaListaSessioni() {
            listaSessioni.clear();
            var sessioni = Storage.getSessioni();
            if (sessioni.length === 0)
            {
                lvServers.currentIndex = -1;

            }

            for (var i = 0; i < sessioni.length; i++)
            {
                listaSessioni.append(sessioni[i]);
            }

            if (sessioni.length === 1)
            {
                lvServers.currentIndex = 0;
            }
        }

        Component.onCompleted: {

            popolaListaSessioni();
            if (listaSessioni.count > 0)
            {
                lvServers.currentIndex = 0;
            }

        }

//        lvServers.delegate: lvServersDelegate
        lvServers.delegate: AndroidDelegate {
            text: nome
            onClicked: {
                form.lvServers.currentIndex = index;
                root.eseguiSessione(index);
            }
            onPressAndHold: {
                form.lvServers.currentIndex = index;
                menuContesto.popup();
            }
        }

//        lvServers.highlight: lvServersHighlight

        Menu {
            id: menuContesto
            MenuItem {
                    text: qsTr("Nuova sessione")
                    onTriggered: root.aggiungiSessione();
            }
            MenuSeparator {

            }

            MenuItem {
                text: qsTr("Modifica sessione")
                onTriggered: root.modificaSessione(form.lvServers.currentIndex);
            }
            MenuItem {
                text: qsTr("Elimina sessione")
                onTriggered: root.eliminaSessione(form.lvServers.currentIndex);
            }
        }

        Component {
            id: lvServersDelegate
            Item {
                        anchors.right: parent.right
                        anchors.left: parent.left
                        x: 5
                        height: 40

                        Item {
                            id: row1
                            anchors.fill: parent
                            Text {
                                id: testo
                                text: nome
                                font.bold: true
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                            }
                            //spacing: 10
                        }

                        MouseArea {
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            id: itemMouseArea
                            anchors.fill: parent
                            onClicked: {
                                form.lvServers.currentIndex = index
                                if (mouse.button == Qt.RightButton)
                                {
                                    menuContesto.popup()
                                }
                           }

                            onPressAndHold: [form.lvServers.currentIndex = index,menuContesto.popup()]
                        }
                    }
        }


        Component {
            id: lvServersHighlight
            Rectangle {
                        anchors.left: (parent !== null? parent.left:undefined)
                        anchors.right: (parent !== null? parent.right:undefined)
                                color: 'grey'
                                /*
                                Text {
                                    anchors.centerIn: parent
                                    text: 'Hello ' + lvServers.chiaveCorrente
                                    color: 'white'
                                }
                                */
                    }
        }
    }

}


