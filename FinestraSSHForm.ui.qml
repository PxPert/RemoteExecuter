import QtQuick 2.4
import QtQuick.Controls 1.4

Item {
    id: item1
    width: 400
    height: 400
    property alias modelLog : modelLog
//    property alias btOK : btOK


    ListModel {
        id: modelLog
    }

    ListView {
        id: lvLog
        x: 75
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        model: modelLog
        clip: true

        delegate: Item {
            x: 5
            anchors.left: parent.left
            anchors.right: parent.right
            height: (testoItem.height > 30? testoItem.height: 30)
            // clip: true

            Item {
                // clip: true

                // anchors.fill: parent
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                id: riga
                Rectangle {
                    x: 5
                    y: 5
                    width: 20
                    height: 20
                    radius: width*0.5
                    color: colorCode
                    visible: colorVisible
                }

                Text {
                    id: testoItem
                    y: 0
                    clip: true
                    // anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    // height: 40
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    color: "#ffffff"
                    // font.bold: true
                }
            }
        }
    }




}

