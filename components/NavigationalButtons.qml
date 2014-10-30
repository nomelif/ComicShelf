import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.Pickers 0.1
import QtQuick.Window 2.0
Item {
    anchors.horizontalCenter: parent.horizontalCenter
    Button{
        anchors.verticalCenter: parent.verticalCenter
        color: "#DD4814"
        anchors.horizontalCenter: parent.horizontalCenter;
        iconSource: "../graphics/camera-flip.svg"
        width: units.gu(7)
        height: units.gu(7)
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
        width: units.gu(6)
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
        width: units.gu(6)
        height: units.gu(3)
        color: "#dd4814"
        anchors.horizontalCenterOffset: units.gu(-17)
        anchors.horizontalCenter: parent.horizontalCenter
        text: "|◄◄"
        onClicked: comic.first()
    }
}
