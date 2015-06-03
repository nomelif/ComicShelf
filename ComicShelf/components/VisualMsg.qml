import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.Pickers 0.1
import QtQuick.Window 2.0

Item{

    width: parent.width;
    property string sign: "✉";
    property string msg;

    id:more_stuff_coming_soon_msg;
    anchors.horizontalCenter: parent.horizontalCenter;
Rectangle{
    color: "#333333b6"
    width: parent.height/2
    height: parent.height/2
    radius: units.gu(15)
    anchors.horizontalCenter: parent.horizontalCenter;
    y: parent.height*0.025
}
Rectangle{
    color: "#DD4814"
    width: parent.height/2
    height: parent.height/2
    radius: units.gu(15)
    anchors.horizontalCenter: parent.horizontalCenter;
}
Text{
    text: sign
    font.bold: true
    font.pixelSize: parent.height/2
    font.family: "Ubuntu"
    x: parent.x + parent.width/2-width/2
    color: "#AEA79F"
    y: parent.height*-0.040

}
Text{
    text: sign
    font.bold: true
    font.pixelSize: parent.height/2
    font.family: "Ubuntu"
    x: parent.x + parent.width/2-width/2
    color: "White"
    y: parent.height*-0.05

}

Text{
    wrapMode: Text.WordWrap
    text: msg
    font.pointSize: parent.height*0.07
    font.family: "Ubuntu"
    width: getWidth();
    color: "#333333"
    function getWidth(){
        if(parent.width < units.gu(70)){
            return parent.width
        }else{
            return units.gu(70)
        }
    }
    x: parent.width/2-getWidth()/2;
    y: parent.height*0.7
    horizontalAlignment: Text.AlignHCenter

}
}
