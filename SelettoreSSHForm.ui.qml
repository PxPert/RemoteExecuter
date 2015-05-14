import QtQuick 2.4
import QtQuick.Controls 1.2

Item {
    id: root
    width: 400
    height: 400

    property alias lvServers : lvServers
    property alias listaSessioni : listaSessioni

    ListModel {
        id: listaSessioni
    }




    ListView {
        id: lvServers
        snapMode: ListView.SnapToItem
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 8
        // property var chiaveCorrente
        // selectionMode: SelectionMode.SingleSelection

        model: listaSessioni


    }
}

