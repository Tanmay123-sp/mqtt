import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item {
    width: 400
    height: 200

    property real totalKm: 0    // Total kilometers traveled
    property real currentSpeed: 0  // Current speed to calculate distance
    property real fuelEfficiency: 1 // Assume fuel efficiency (km per liter)
    property real totalFuel: 50  // Assume the tank holds 50 liters
    property real fuelConsumed: 0  // Fuel consumed based on total km traveled

    // Timer to update the distance traveled and calculate fuel consumption
    Timer {
        interval: 1000   // Update every second
        running: true    // Start automatically
        repeat: true
        onTriggered: {
            // Increment total kilometers using the speed (km per second)
            totalKm += currentSpeed / 3600;  // Speed is in km/h, so divide by 3600 to get km per second
            fuelConsumed = totalKm / fuelEfficiency;  // Calculate fuel consumed
        }
    }

    // Function to update speed based on speedometer changes
    function updateSpeed(newSpeed) {
        currentSpeed = newSpeed;  // Update the current speed
    }

    // Function to get the total kilometers traveled
    function getTotalKm() {
        return totalKm;
    }

    // Function to get the remaining fuel based on total km traveled
    function getRemainingFuel() {
        return Math.max(totalFuel - fuelConsumed, 0);  // Ensure fuel doesn't go below 0
    }

    ColumnLayout {
        id: totalKmRect
        spacing: 5
        Label {
            id: totalKmLabel
            text: "Total Km "
            font.pixelSize: 20
            color: "#FF4500"
        }

        Text {
            id: totalKmDisplay
            text: totalKm.toFixed(2) + " km"
            font.pixelSize: 20
            color: "#FF4500"
        }
    }
}
