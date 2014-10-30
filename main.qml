import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.Pickers 0.1
import "components"

MainView {
    useDeprecatedToolbar: false
    // Used to retrieve html pages and find out newest comics

    applicationName: "com.ubuntu.developer.theo.friberg.comicshelf";

    // List model containing basic info about comics

    ListModel{
        id: comics_list_model
        ListElement { // Twokinds
            comic_name: "Twokinds";
            artist: "Tom Fischbach";
            favicon_url: "http://twokinds.keenspot.com/favicon.ico";
        }
        ListElement { // Freefall
            comic_name: "Freefall";
            artist: "Mark Stanley";
            favicon_url: "http://freefall.purrsia.com/funstuff/freefall.ico";
        }
        ListElement { // XKCD
            comic_name: "XKCD";
            artist: "Randall Munroe";
            favicon_url: "../graphics/xkcd.png";
        }/*
        ListElement { // Carribbean Blue
            comic_name: "Caribbean Blue"
            artist: "Ronaldo \"Nekonny\" Rodrigues"
            favicon_url: "http://cb.katbox.net/wp-content/uploads/sites/5/2013/03/icon.ico"
        }*/
    }

    // The Item is mainly used to clip the upper edge of the Flipable when it is moving

    Item{
        width:parent.width;
        height: parent.height-header.height+units.gu(5);
        y: header.height;
        clip: true;

    // Main UI-element

    MainFlippable{
        width:parent.width
        height: parent.height - units.gu(5)
    }
    }
}
