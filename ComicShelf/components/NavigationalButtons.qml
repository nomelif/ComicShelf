import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.Pickers 0.1
import QtQuick.Window 2.0
Item {
    anchors.horizontalCenter: parent.horizontalCenter
    Button{
        id: home
        anchors.verticalCenter: parent.verticalCenter

        anchors.horizontalCenter: parent.horizontalCenter;
        iconSource: "../graphics/camera-flip.svg"
        width: units.gu(7)
        height: units.gu(7)
        style: UbuntuShape{
            id: home_shape
            color: "#DD4814"
            radius: "medium"
            states: [
                    State {
                        name: "NORMAL"
                    },
                    State {
                        name: "PRESSED"
                        when: home.pressed
                        PropertyChanges { target: home_shape; color: "#BC3D11"}
                    }
                ]
            transitions: Transition {
                    ColorAnimation { properties: "color"; easing.type: Easing.InOutQuad }
                }
            Image{
                anchors.centerIn: parent;
                width: parent.width-units.gu(2)
                height: parent.height-units.gu(2)
                source: "../graphics/camera-flip.svg"
            }
        }
        onClicked: flipable.flipped = !flipable.flipped

    }

    Button {
        anchors.verticalCenter: parent.verticalCenter
        width: units.gu(4)
        height: units.gu(4)
        color: "#dd4814"
        anchors.horizontalCenterOffset: units.gu(10)
        anchors.horizontalCenter: parent.horizontalCenter
        text: "►"
        onClicked: comic.next()

    }
    Button {
        anchors.verticalCenter: parent.verticalCenter
        width: units.gu(6.5)
        height: units.gu(3)
        color: "#dd4814"
        anchors.horizontalCenterOffset: units.gu(17)
        anchors.horizontalCenter: parent.horizontalCenter
        text: "►►|"
        onClicked: comic.last()

    }

    Button {
        anchors.verticalCenter: parent.verticalCenter
        width: units.gu(4)
        height: units.gu(4)
        color: "#dd4814"
        anchors.horizontalCenterOffset: units.gu(-10)
        anchors.horizontalCenter: parent.horizontalCenter
        text: "◄"
        onClicked: comic.previous()
    }
    Button {
        anchors.verticalCenter: parent.verticalCenter
        width: units.gu(6.5)
        height: units.gu(3)
        color: "#dd4814"
        anchors.horizontalCenterOffset: units.gu(-17)
        anchors.horizontalCenter: parent.horizontalCenter
        text: "|◄◄"
        onClicked: comic.first()
    }
}
