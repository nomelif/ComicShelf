import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import QtQuick.Window 2.0

// Main page

Page{
    id: page_component;
    title: "Comic Shelf";

    // Flipable holding ListView / ComicComponent

    Flipable {
        clip: true;
        id: flipable;
        width: parent.width;
        height: parent.height-units.gu(5);

        // Properties ----------------------------------------------------------------

        // Is the Flipable flipped?

        property bool flipped: false;


        // Flipable side displaying the ListView

        front: Item {
            id: choose_comic;
            width:parent.width;
            height: parent.height;

            // Listview listing all comics

            UbuntuListView {
                id: comics_list_view;
                width: parent.width;
                height: parent.height;
                clip: true;
                model: comics_list_model;
                delegate:

                    // ListItem

                    ListItem.Subtitled {

                    // Load icon from site / app's ../grahics folder

                    iconSource: favicon_url;
                    text: comic_name;
                    subText: i18n.tr("by ")+artist;
                    onClicked: {

                        // Change tab and set comic

                        flipable.flipped = !flipable.flipped;
                        comic.set_comic(comic_name);
                    }
                }
            }

            // "Disclaimer"

            VisualMsg{
                y: units.gu(10)
                msg: "More Stuff Coming Soon"
            }

        }


        // Backside of the Flipable displaying ComicComponent

        back:
            Item{
            width: parent.width;
            height: parent.height;
            id: read_comic;
            visible: false;

            // The comic component

            ComicComponent{
                id: comic;
            }

            // UI-element used to navigate between strips

            NavigationalButtons{
                y: comic.y+comic.height+units.gu(6);
            }

        }


        transform: Rotation {
            id: rotation;
            origin.x: flipable.width/2;
            origin.y: flipable.height/2;
            axis.x: 0; axis.y: 1; axis.z: 0;     // set axis.y to 1 to rotate around y-axis
            angle: 0;    // the default angle
        }

        states:
            [
            State {
                name: "back"
                PropertyChanges {
                    target: rotation;
                    angle: 180;
                }
                when: flipable.flipped;
                onCompleted: {
                    choose_comic.visible = false;
                    read_comic.visible = true;
                    find_action.visible = true;
                    page_component.title = comic.comic_name;
                }
            },
            State {
                name: ""
                PropertyChanges {
                    target: rotation;
                    angle: 360;
                }
                onCompleted: {
                    choose_comic.visible = true;
                    read_comic.visible = false;
                    find_action.visible = false;
                    page_component.title = "Comic Shelf";
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                target: rotation;
                property: "angle";
                duration: 250;
            }
        }
    }

    // The toolbar

    tools: ToolbarItems {

        // Find

        ToolbarButton {
            action: Action {
                id: find_action;
                visible: false;
                iconSource: Qt.resolvedUrl("../graphics/find.svg");
                onTriggered: PopupUtils.open(comic_strip_chooser_component);
            }
        }
        ToolbarButton {
            action: Action {
                id: info_action;
                iconSource: Qt.resolvedUrl("../graphics/info.svg");
                onTriggered: PopupUtils.open(about_component);
            }
        }
    }
    width: parent.width;
    height: parent.height;

    Component {
        id: about_component;

        // Dialog that contains the comic-page selector

        Dialog {
            id: about_dialog;

            // Copyright text

            Flickable{
                width: parent.width
                contentHeight: copyright.height
                contentWidth: copyright.width
                height: units.gu(30)
                clip: true
            Rectangle{
                radius: 4;
                width: parent.width
                height: copyright.height
                color: "#333333"
                clip: true
            Text{
                id: copyright
                color: "#AEA79F"
                font.family: "Ubuntu Mono"
                font.pointSize: 8.4
                text: "
    *******************************************
    *                                         *
    *       By Théo Friberg 29.10.2014        *
    *                                         *
    *******************************************

Webcomic-reader app for the Ubuntu Mobile platform.

         Copyright (c) 2014 Théo Friberg

Permission is hereby granted, free of charge, to
any person obtaining a copy of this software and
associated documentation files (the \"Software\"),
  to deal in the Software without restriction,
 including without limitation the rights to use,
   copy, modify, merge, publish, distribute,
 sublicense, and/or sell copies of the Software,
  and to permit persons to whom the Software is
  furnished to do so, subject to the following
                  conditions:

The above copyright notice and this permission
   notice shall be included in all copies or
     substantial portions of the Software.

    THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT
     WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
   OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
       OR OTHER DEALINGS IN THE SOFTWARE.

  COMICS DISPLAYED BY THIS SOFTWARE ARE PROPERTY
  OF THEIR RESPECTIVE OWNERS. PERMISSION MUST BE
   GRANTED BY THE COMICS' RESPECTIVE OWNERS TO
    REDISTRIBUTE ANY OR ALL THE COMICS. I, THÉO
    FRIBERG, DO NOT TAKE RESPONSIBILITY FOR THE
  CONTENTS OF ANY OF THE COMICS DISPLAYED BY THIS
    SOFTWARE. COMICS REMAIN UNDER HEIR ORIGINAL
             LICENSES, WICH MAY VARY.

"
            }
            }
            }

            // Button to dismiss dialog
                Button{
                    color: "#DD4814";
                    text: "OK";
                    anchors.horizontalCenter: parent.horizontalCenter;
                    onClicked: {
                        PopupUtils.close(about_dialog);
                    }
                }
        }
    }

    Component {
        id: comic_strip_chooser_component;

        // Dialog that contains the comic-page selector

        Dialog {
            id: comic_strip_chooser_dialog;

            // Text-field used for the search function

            TextField {
                id: search_querry;
                width: parent.width;
                placeholderText: "Enter search querry";

                // Function that filters the ListView

                onTextChanged: {
                    if(text.length > length){
                        comic.filter_archives(text, archive_selector);
                    }else{
                        comic.copy_list_models();
                    }
                    length = text.length;
                }

                // Length of the text contained by the TextField

                property int length: 0;
            }

            // Option selector for the archives

            OptionSelector {
                id: archive_selector;

                // Text displayed on the top of the dialog

                text: comic.comic_name+i18n.tr(" archives:");
                model: comic.get_archive_model();
                delegate: selectorDelegate;
                containerHeight: units.gu(50)-buttons.height;
                expanded: true;

                // Current url, this will point to the last comic of the given series

                property string url: "[last]";
            }
            Component {
                id: selectorDelegate;

                // Delegate for above selector

                OptionSelectorDelegate {
                    text: name;
                    onClicked: {
                        comic.setSelIndexByUrl(url, archive_selector);
                        archive_selector.url = url;
                    }
                }
            }

            // Buttons of the selector-dialog

            Row{
                id: buttons;
                spacing: width * 0.1;
                Button{
                    text: "Cancel";
                    onClicked: PopupUtils.close(comic_strip_chooser_dialog);
                    width: parent.width * 0.45;
                }
                Button{
                    color: "#DD4814";
                    text: "Choose";
                    onClicked: {
                        comic.get_comic_by_url(archive_selector.url);
                        PopupUtils.close(comic_strip_chooser_dialog);
                    }
                }
            }
        }
    }
}
