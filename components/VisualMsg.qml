import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.Pickers 0.1
import QtQuick.Window 2.0

Item{

    property string sign: "☆";
    property string msg;

    id:more_stuff_coming_soon_msg
    y: units.gu(13)
    anchors.horizontalCenter: parent.horizontalCenter;
    width: parent.width;
Rectangle{
    color: "#333333b6"
    width: units.gu(30)
    height: units.gu(30)
    radius: units.gu(15)
    anchors.horizontalCenter: parent.horizontalCenter;
    y: parent.y + units.gu(1)
}
Rectangle{
    color: "#DD4814"
    width: units.gu(30)
    height: units.gu(30)
    radius: units.gu(15)
    anchors.horizontalCenter: parent.horizontalCenter;
    y: parent.y
}
Text{
    text: sign
    font.bold: true
    font.pixelSize: units.gu(25)
    font.family: "Ubuntu"
    x: parent.x + parent.width/2-width/2
    color: "#AEA79F"
    y: parent.y + parent.height/2 + units.gu(0.5)

}
Text{
    text: sign
    font.bold: true
    font.pixelSize: units.gu(25)
    font.family: "Ubuntu"
    x: parent.x + parent.width/2-width/2
    color: "White"
    y: parent.y + parent.height/2

}
Text{
    wrapMode: Text.WordWrap
    text: msg
    font.pointSize: 24
    font.family: "Ubuntu"
    width: getWidth();
    color: "#333333"
    function getWidth(){
        if(Screen.width < units.gu(70)){
            return Screen.width
        }else{
            return units.gu(70)
        }
    }
    x: parent.width/2-getWidth()/2;
    y: parent.y+units.gu(35)
    horizontalAlignment: Text.AlignHCenter

}
}
