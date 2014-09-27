import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.Pickers 0.1
import "components"

MainView {

    // Used to retrieve html pages and find out newest comics
    applicationName: "com.ubuntu.developer.username.comicshelf";
    ListModel{
        id: comics_list_model
        ListElement { // Twokinds
            comic_name: "Twokinds"
            artist: "Tom Fischbach"
            favicon_url: "http://twokinds.keenspot.com/favicon.ico"
        }
        ListElement { // Freefall
            comic_name: "Freefall"
            artist: "Mark Stanley"
            favicon_url: "http://freefall.purrsia.com/funstuff/freefall.ico"
        }
        ListElement { // Carribbean Blue
            comic_name: "Caribbean Blue"
            artist: "Ronaldo \"Nekonny\" Rodrigues"
            favicon_url: "http://cb.katbox.net/wp-content/uploads/sites/5/2013/03/icon.ico"
        }
    }

    Tabs { // Tab widget
        id: tabs
        Tab { // Tab listing all comics

            id: all_comicsemail
            title: i18n.tr("All comics")
            page: Page { // Page-item
                UbuntuListView { // Listview listing all comics
                    clip: true
                    width:parent.width;
                    height: parent.height;
                    model: comics_list_model
                    delegate: ListItem.Subtitled { // List item
                        iconSource: favicon_url
                        text: comic_name
                        subText: i18n.tr("by ")+artist
                        onClicked: { // Change tab and set comic
                            tabs.selectedTabIndex = 1;
                            comic.set_comic(comic_name)
                        }
                    }

                }
            }
        }
        Tab { // Tab to read the comics
            id: read_comic
            title: i18n.tr("Read comic")
            page: Page {
                id: read_comic_page
                property int selected_comic_index: 0;
                Component {
                    id: popoverComponent

                    Dialog {
                        id: popover
                        TextField {
                            id: search_querry
                            width: parent.width
                            placeholderText: "Enter search querry"
                            onTextChanged: {
                                if(text.length > length){
                                    comic.filter_archives(text, archive_selector);
                                }else{
                                    comic.copy_list_models();
                                }
                                length = text.length;
                            }
                            property int length: 0;
                        }
                        OptionSelector {
                            id: archive_selector
                            text: comic.comic_name+i18n.tr(" archives:")
                            model: comic.get_archive_model()
                            delegate: selectorDelegate
                            containerHeight: units.gu(50)-buttons.height;
                            expanded: true
                            property string url: "http://freefall.purrsia.com/";
                        }
                        Component {
                            id: selectorDelegate
                            OptionSelectorDelegate {
                                text: name;
                                onClicked: {
                                    comic.setSelIndexByUrl(url, archive_selector);
                                    archive_selector.url = url;
                                }
                            }
                        }
                        Row{
                            id: buttons
                            spacing: width * 0.1
                            Button{
                                text: "Cancel"
                                onClicked: PopupUtils.close(popover)
                                width: parent.width * 0.45
                            }
                            Button{
                                color: "#DD4814"
                                text: "Choose"
                                onClicked: {
                                    comic.get_comic_by_url(archive_selector.url);
                                    PopupUtils.close(popover)
                                }
                            }
                        }
                    }
                }
                ComicComponent{ // The comic component
                    id: comic
                }
                tools: ToolbarItems { // The toolbar
                    ToolbarButton { // First
                        action: Action {
                            text: i18n.tr("First")
                            iconSource: Qt.resolvedUrl("graphics/go-first.svg")
                            onTriggered: comic.first();
                        }
                    }
                    ToolbarButton { // Previous
                        action: Action {
                            text: i18n.tr("Previous")
                            iconSource: Qt.resolvedUrl("graphics/go-previous.svg");
                            onTriggered: comic.previous();
                        }
                    }
                    ToolbarButton { // Find
                        action: Action {
                            text: i18n.tr("Find")
                            iconSource: Qt.resolvedUrl("graphics/find.svg");
                            onTriggered: PopupUtils.open(popoverComponent, read_comic_page)
                        }
                    }
                    ToolbarButton { // Next
                        action: Action {
                            text: i18n.tr("Next")
                            iconSource: Qt.resolvedUrl("graphics/go-next.svg");
                            onTriggered: comic.next()
                        }
                    }
                    ToolbarButton { // Latest
                        action: Action {
                            text: i18n.tr("Latest")
                            iconSource: Qt.resolvedUrl("graphics/go-last.svg");
                            onTriggered: comic.last()
                        }
                    }
                }
            }
        }
    }
}
