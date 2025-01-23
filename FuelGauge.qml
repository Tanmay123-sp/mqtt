import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: fuelGaugeContainer
    width: 100
    height: 300

    property Item totalKmItem
    property real maxFuelHeight: 200  // Maximum height of the fuel bar
    property real currentFuel: 10     // Initial fuel level (50 liters)
    property real fuelHeight: maxFuelHeight * (currentFuel / 50)  // Set fuel bar height proportionally

    Canvas {
        id: fuelGaugeCanvas
        width: 100
        height: 300

        onPaint: {
            var ctx = getContext("2d")
            var centerX = width / 2
            var gaugeHeight = height - 160

            // Fuel Gauge Background
            ctx.fillStyle = "#1C2D3C"
            ctx.fillRect(centerX - 10, 10, 20, gaugeHeight - 20)

            // Draw the fuel level bar dynamically
            ctx.fillStyle = "#FF4500"
            ctx.fillRect(centerX - 10, gaugeHeight - fuelHeight, 20, fuelHeight)
        }
    }

    // Update the fuel bar whenever fuelHeight changes
    function updateFuelLevel(remainingFuel) {
        currentFuel = remainingFuel;
        console.log(currentFuel+" fuel");
        fuelHeight = maxFuelHeight * (currentFuel / 50);  // Update fuel height
        fuelGaugeCanvas.requestPaint();  // Repaint the fuel gauge with updated fuel level
    }

    // Fuel Label
    Text {
        id: fuelLabel
        text: "Fuel"
        anchors.top: fuelGaugeCanvas.bottom
        anchors.topMargin: -165
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 20
        color: "#FFFFFF"
        verticalAlignment: Text.AlignHCenter
    }

    // Update the fuel gauge based on the total kilometers
    Component.onCompleted: {
        if (totalKmItem) {
            var remainingFuel = totalKmItem.getRemainingFuel();  // Get remaining fuel from TotalKm.qml
            console.log(remainingFuel+" Rfuel");
            updateFuelLevel(remainingFuel);  // Update the fuel gauge
        }
    }
}
