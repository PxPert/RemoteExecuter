import QtQuick 2.4
import org.pxpert.SessioneSSH 1.0
import org.pxpert.CodiceErrore 1.0

Item {
    id: root
    property string nomeFinestra: qsTr("Esegui comando")

    function eseguiSSH(parametri) {
        form.modelLog.clear();
        // form.state = "";

        nomeFinestra = parametri.nome + "...";
        stackView.aggiornaTitolo();
        // state = "activeState";

        form.modelLog.append(creaElementoLista(qsTr("Connessione al server ") + parametri.indirizzoServer + "...", "white", false));
        var indirizzo = parametri.indirizzoServer;
        var porta = 22;
        var espressione = new RegExp("(.*):([\\d]+)");
        var espressioneExec = espressione.exec(indirizzo);
        if (espressioneExec !== null)
        {
            indirizzo = espressioneExec[1];
            porta = espressioneExec[2];
        }

        sessioneSSH.connetti(indirizzo, porta, codiceErrore);

        if (codiceErrore.codiceErrore == 0)
        {
            form.modelLog.append(creaElementoLista(qsTr("Connessione riuscita"), "green", true));

            form.modelLog.append(creaElementoLista(qsTr("Autenticazione in corso..."), "white", false));
            sessioneSSH.autenticaConPassword(parametri.username,parametri.password,codiceErrore);

            if (codiceErrore.codiceErrore == 0)
            {
                form.modelLog.append(creaElementoLista(qsTr("Autenticazione completata"), "green", true));

                var output = sessioneSSH.eseguiComando(parametri.comandoDaEseguire, parametri.pty, codiceErrore);
                if (codiceErrore.codiceErrore == 0)
                {
                    form.modelLog.append(creaElementoLista(qsTr("Esecuzione terminata"), "green", true));
                    form.modelLog.append(creaElementoLista(qsTr("StdOut: "), "green", false));
                    form.modelLog.append(creaElementoLista(output.output, "green", false));
                    form.modelLog.append(creaElementoLista(qsTr("StdErr: "), "green", false));
                    form.modelLog.append(creaElementoLista(output.error, "green", false));
                } else {
                    form.modelLog.append(creaElementoLista(qsTr("Esecuzione fallita: ") + codiceErrore.testoErrore, "red", true));
                }

            } else {
                form.modelLog.append(creaElementoLista(qsTr("Connessione fallita: ") + codiceErrore.testoErrore, "red", true));
            }

        } else {
            form.modelLog.append(creaElementoLista(qsTr("Connessione fallita: ") + codiceErrore.testoErrore, "red", true));
        }

        sessioneSSH.disconnettiSessione(codiceErrore);

        // form.state = "complete";

    }

    function creaElementoLista(testo, colore, coloreVisibile)
    {
        return {
            name: testo,
            colorCode: colore,
            colorVisible: coloreVisibile
        };
    }

    FinestraSSHForm {
        id: form
        anchors.fill: parent
//        opacity: 0

        /*
        btOK.onClicked: {
            root.state = "";
        }
        */
    }

    SessioneSSH {
        id: sessioneSSH
    }
    CodiceErrore {
        id: codiceErrore
    }




}



