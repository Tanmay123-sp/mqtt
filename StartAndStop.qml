import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: startAndStopid
    width: 500
    height: 150

    Grid {
        id: startStopGrid
        columns: 2
        rowSpacing: 20
        columnSpacing: 20 // Adds space between columns

        Rectangle {
            width: 250
            height: 80
            color: "transparent"

            Button {
                text: "Start"
                width: 60
                height: 40
                anchors.centerIn: parent
                hoverEnabled: false
                background: Rectangle {
                    color: "blue"
                    border.color: "black"
                    radius: 10
                }
                contentItem: Text {
                    text: "Start"
                    color: "white"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }

            }
        }

        Rectangle {
            width: 250
            height: 80
            color: "transparent"

            Button {
                text: "Stop"
                width: 60
                height: 40
                anchors.centerIn: parent
                hoverEnabled: false
                background: Rectangle {
                    color: "blue"
                    border.color: "black"
                    radius: 10
                }
                contentItem: Text {
                    text: "Stop"
                    color: "white"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }
            }
        }
    }
}


// --------------------------------------------------------------------------------------


