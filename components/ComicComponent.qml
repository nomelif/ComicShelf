import QtQuick 2.0
import Ubuntu.Components 0.1
import QtQuick.Window 2.0

// Item holding all the components of the comic reader

Item {

    // Comic Adapters -------------------------------------------------------------------------




    TwokindsComicAdapter{
        id: tk_adapter;
        load: loadComic;
        archive: archive_model;
    }

    XKCDComicAdapter{
        id: xkcd_adapter;
        load: loadComic;
        archive: archive_model;
    }

    FreefallComicAdapter{
        id: freefall_adapter;
        load: loadComic;
        archive: archive_model;
    }

    CaribbeanBlueComicAdapter{
        id: cblue_adapter;
        load: loadComic;
        archive: archive_model;
    }

    ACBFAdapter{
        id: acbf_adapter;
        load: loadComic;
        archive: archive_model;
    }

    // Properties ------------------------------------------------------------------------------




    // Property for using adapter-classes in a polymorphical fashion (the variable adapter will be set to point to the correct adapter-instance)

    property var adapter;

    // Name of the current comic in a human-readable format

    property string comic_name;

    width: parent.width - units.gu(3);
    anchors.horizontalCenter: parent.horizontalCenter;
    anchors.verticalCenter: parent.verticalCenter;
    height: (parent.height / 3)*2;

    // ListModels ------------------------------------------------------------------------------



    // This ListModel contains the full archives of the current commic.

    ListModel{
        id: archive_model;

    }

    // This ListModel contains the model displayed in the dialog to select comics. This can and will be modified and filtered

    ListModel{
        id: archive_model_copy;

    }


    // Methods ---------------------------------------------------------------------------------



    // Function, that returns the title of the strip_title:

    function get_title(){
        return ""
    }


    // Function that updates archive_model ListModel

    function update(){

        archive_model.clear(); // Clear archive_model ListModel's contents
        adapter.update(); // Call the update-method of the correct comic-adapter
    }

    // Function that returns archive list model

    function get_archive_model(){

        return archive_model_copy;
    }

    // Function that copies the contents of the original archive_model to archive_model_copy

    function copy_list_models(){

        archive_model_copy.clear();
        var i = 0;
        while(i < archive_model.count){
            archive_model_copy.append(archive_model.get(i));
            i = i + 1;
        }
    }

    // Function that filters searches by removing unwanted elements from archive_model_copy

    function filter_archives(search_querry, archive_selector){

        var i = 1;
        var keywords = search_querry.toLowerCase().split(" ");
        while(i < archive_model_copy.count){
            var ii = 0;
            var listEntry = false;
            while(!listEntry && ii < keywords.length){
                if(archive_model_copy.get(i).name.toLowerCase().indexOf(keywords[ii]) !== -1){
                    listEntry = true;
                }
                ii++;
            }

            if(listEntry){
                if(archive_selector.url === archive_model_copy.get(i).url){
                    archive_selector.selectedIndex = i;
                }
                i++;
            }else{
                if(archive_selector.url === archive_model_copy.get(i).url){
                    archive_selector.selectedIndex = 0;
                }
                archive_model_copy.remove(i);
            }
        }
    }

    // Callback called from dialog to get index of clicked element (Dark Magic)

    function setSelIndexByUrl(selUrl, archive_selector){

        if(archive_model_copy.count !== archive_model.count){
            var i = 1;
            while(i < archive_model_copy.count){
                if(selUrl === archive_model_copy.get(i).url){
                    archive_selector.selectedIndex = i;
                }
                i = i + 1;
            }
        }
    }

    // Function that sets comic name and loads latest strip

    function set_comic(name){

        if(name === "Freefall"){
            adapter = freefall_adapter;
        }else if(name === "Twokinds"){
            adapter =  tk_adapter;
        }else if(name === "Caribbean Blue"){
            adapter =  cblue_adapter;
        }else if(name === "XKCD"){
            adapter =  xkcd_adapter;
        }else if(name === "ACBF"){
            adapter =  acbf_adapter;
        }

        error_msg.visible = false;
        comic_name = name;
        last();
    }

    // Function that shows the image and hides the busy-indicator and text

    function show_image(){

        comic_strip.visible = true;
        activity.visible = false;
        comic_status.visible = false;
        activity.value = 0;
    }

    // Function that hides the image and shows the busy-indicator and text

    function show_loading_status(name){

        comic_strip.visible = false;
        activity.visible = true;
        comic_status.visible = true;
    }

    // Function that loads the comic into the image and shows the loading-widgets

    function loadComic(url){

        update();
        comic_strip.source = url;
        if(comic_strip.progress !== 1){
            show_loading_status();
        }
        var i = 0;
    }

    // Function that, if the image is loaded calls show_image() to show the image

    function checkLoading(){

        if(comic_strip.progress === 1){
            show_image();
        }
        activity.value = comic_strip.progress;
    }

    function get_comic_by_url(url_to_load){

        if(url_to_load === "[last]"){
            last();
        }else{
            adapter.get_by_url(url_to_load);
        }
    }


    // Function that determines the url of the last strip and calls load_comic to load it

    function last(){

        comic_strip.source = ""; // Clear the source of the comic strip
        adapter.latest_url();

    }

    // Function that fetches next comic

    function next(){

        adapter.next_url();
    }

    // Function that determines the previous strip and calls load_comic

    function previous(){

        adapter.previous_url();
    }

    // Function that determines the first strip and calls load_comic

    function first(){

        comic_strip.source = ""; // Clear the source of the comic strip
        adapter.first_url();
    }

    // Flickable to hold the image
    PinchArea {
        anchors.fill: parent
        pinch.target: comic_strip
        pinch.minimumScale: 0.5
        pinch.maximumScale: 7
        MouseArea {
            id: dragArea
            hoverEnabled: true
            anchors.fill: parent
            drag.target: comic_strip
            drag.onActiveChanged: {
                if(drag.active){
                    comic_strip.state = "default"
                }
            }

            onDoubleClicked: {
                comic_strip.state = "centered"
                //comic_strip.x = comic_strip.parent.width / 2 -comic_strip.width / 2;
                //comic_strip.y = comic_strip.parent.height / 2 - comic_strip.height / 2;
            }

        Image{
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            id: comic_strip;
            visible: false;
            smooth: true;
            anchors.centerIn: undefined;

            // Calls check_comic whenever the progress changes

            onProgressChanged: checkLoading();

            state: "default"

            states: [
                State{
                    name: "centered";
                    AnchorChanges {
                        target: comic_strip;
                        anchors.horizontalCenter: comic_strip.parent.horizontalCenter;
                        anchors.verticalCenter: comic_strip.parent.verticalCenter;
                    }
                }

            ]
            transitions: Transition {
                     // smoothly reanchor myRect and move into new position
                    from: "default"
                    AnchorAnimation { duration: 150 }
                 }


    }
    }
    }

    // ProgressBar giving indication of remaining image to download

    ProgressBar {
        id: activity;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.verticalCenter: parent.verticalCenter;
        value: 0;
        visible: false;
    }

    // Text telling that the comic is loading

    Text{
        id: comic_status;
        text: comic_name+i18n.tr(" is loading.");
        font.family: "Ubuntu";
        font.pixelSize: units.gu(2);
        color: "#333333"
        anchors.horizontalCenter: parent.horizontalCenter;
        y: activity.y + units.gu(5);
        visible: false;
    }

    // Message that, if lucky is shown in case of error

    VisualMsg{
        id: error_msg;
        anchors.verticalCenter: parent.verticalCenter;
        width: parent.width;
        msg: "Something went wrong. Please try again"
        sign: "☹"
    }
}
