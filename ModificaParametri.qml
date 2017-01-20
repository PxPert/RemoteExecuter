import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

import "storage.js" as Storage
import "componenti"

Item {
    id: root
    property string nomeFinestra: qsTr("Aggiungi comando")

    signal salva

    property int indiceCorrente

    function modifica(indice) {
        indiceCorrente = indice;
        form.modifica(indice);
    }

    Item {
        id: form
        anchors.fill: parent
        anchors.margins: 10

        property alias nome : txNomeComando.text
        property alias indirizzoServer: txIndirizzoServer.text
        property alias username : txUsername.text
        property alias password : txPassword.text
        property alias comandoDaEseguire : txComandoDaEseguire.text
        property alias pty : ckPTY.checked


        function formToSessione() {
            function ritornaErrore(nomeCampo) {
                return {errore: qsTr("Compila il campo ") + nomeCampo};
            }

            var sessione = {};

            if (nome == "")
            {
                return ritornaErrore(qsTr("Nome Comando"));
            }
            if (indirizzoServer == "")
            {
                return ritornaErrore(qsTr("Indirizzo Server"));
            }
            if (username == "")
            {
                return ritornaErrore(qsTr("Username"));
            }
            if (password == "")
            {
                return ritornaErrore(qsTr("Password"));
            }
            if (comandoDaEseguire == "")
            {
                return ritornaErrore(qsTr("Comando da eseguire"));
            }

            sessione.nome = nome;
            sessione.indirizzoServer = indirizzoServer;
            sessione.username = username;
            sessione.password = password;
            sessione.comandoDaEseguire = comandoDaEseguire;
            sessione.pty = pty;
            return sessione;
        }



        function modifica(indice) {
            if (indice === -1)
            {
                nome = "";
                indirizzoServer = "";
                username = "";
                password = "";
                comandoDaEseguire = "";
                pty = false;
            } else {
                var sessione = Storage.getSessioni()[indice];
                nome = sessione.nome;
                indirizzoServer = sessione.indirizzoServer;
                username = sessione.username;
                password = sessione.password;
                comandoDaEseguire = sessione.comandoDaEseguire;
                pty = sessione.pty;
                nomeFinestra = qsTr("Modifica ") + sessione.nome;
                stackView.aggiornaTitolo();

            }
        } 

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
                onClicked: {
                    var sessione = form.formToSessione();
                    if (sessione.errore === undefined) {
                        stackView.push({item: componentefinestraSSH});
                        stackView.currentItem.eseguiSSH(sessione);
                    } else {
                        messageDialog.show(qsTr("Errore"), sessione.errore);
                    }
                }
            }

            CustomButton {
                width: (parent.width - parent.spacing) / 2
                id: btOk
                text: qsTr("OK")

                onClicked: {

                    var listaSessioni = Storage.getSessioni();
                    var sessione = form.formToSessione();
                    if (sessione.errore === undefined) {
                        if (root.indiceCorrente === -1)
                        {
                            listaSessioni.push(sessione);
                        } else {
                            listaSessioni[root.indiceCorrente] = sessione;
                        }

                        Storage.setSessioni(listaSessioni);

                        root.salva();
                        stackView.pop();
                    } else {
                        messageDialog.show(qsTr("Errore"), sessione.errore);
                    }

                }
            }

        }


        Flickable {
            id: fkContenitoreGriglia
            // contentHeight: parent.height > 400?parent.height:400

            contentHeight: layoutContenitore.height + layoutContenitore.spacing
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
                anchors.topMargin: txNomeComando.height / 4
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                spacing: txNomeComando.height / 2

                // anchors.fill: parent



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
}

