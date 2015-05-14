import QtQuick 2.4
import "storage.js" as Storage

Item {
    id: root
    property string nomeFinestra: "Aggiungi comando"

    signal salva

    property int indiceCorrente

    function modifica(indice) {
        indiceCorrente = indice;
        form.modifica(indice);
    }

    ModificaParametriForm {
        id: form
        anchors.fill: parent
        btTest.onClicked: {
            var sessione = formToSessione();
            if (sessione.errore === undefined) {
                stackView.push({item: componentefinestraSSH});
                stackView.currentItem.eseguiSSH(sessione);
            } else {

                messageDialog.show("Errore", sessione.errore);

                // messageDialog.show("Errore", griglia.flow);
            }
        }

        function formToSessione() {
            function ritornaErrore(nomeCampo) {
                return {errore: "Compila il campo " + nomeCampo};
            }

            var sessione = {};

            if (nome == "")
            {
                return ritornaErrore("Nome");
            }
            if (indirizzoServer == "")
            {
                return ritornaErrore("Indirizzo Server");
            }
            if (username == "")
            {
                return ritornaErrore("Username");
            }
            if (password == "")
            {
                return ritornaErrore("Password");
            }
            if (comandoDaEseguire == "")
            {
                return ritornaErrore("Comando da eseguire");
            }

            sessione.nome = nome;
            sessione.indirizzoServer = indirizzoServer;
            sessione.username = username;
            sessione.password = password;
            sessione.comandoDaEseguire = comandoDaEseguire;
            sessione.pty = pty;
            return sessione;
        }

        btOk.onClicked: {

            var listaSessioni = Storage.getSessioni();
            var sessione = formToSessione();
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
                messageDialog.show("Errore", sessione.errore);
            }

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
                nomeFinestra = "Modifica " + sessione.nome;
                stackView.aggiornaTitolo();

            }
        }

    }
}

