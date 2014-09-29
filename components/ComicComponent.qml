import QtQuick 2.0
import Ubuntu.Components 0.1

// Item holding all the components of the comic reader

Item {
    property string comic_name: ""; // Name of the current comic (eg. "Twokinds")
    property string page_url: ""; // url of the html-page where the comic being displayed can be seen
    property string html: ""; // Name of the current comic (eg. "Twokinds")
    property string latest_url: "";
    property int selected_index: 0;

    // List model of all comics

    ListModel{
        id: archive_model

    }
    ListModel{
        id: archive_model_copy

    }

    // Function that updates archive list model

    function update(){
        archive_model.clear();
        if(comic_name === "Freefall"){
        var update_page_url = "http://freefall.purrsia.com/fcdex.htm"; // The url of the page is set
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', update_page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                var html_modified = request.responseText; // Load the html to the variable
                html_modified = html_modified.substring(html_modified.indexOf("<FONT SIZE=+1>The adventure begins!</FONT>&nbsp;&nbsp;3/30/1998<BR>"), html_modified.indexOf("<A HREF=\"/default.htm\">Current</A>")); // Call load comic with the url of th last comic
                var link_list = html_modified.split("HREF=\"")
                var i = 1;
                while(i < link_list.length){
                    var name = link_list[i].split("\"")[0]
                    archive_model.insert(i-1, {index: i, url:"http://freefall.purrsia.com"+link_list[i].split("\"")[0], name:"Freefall n."+String(parseInt(name.substring(name.indexOf("0/f")+4, name.indexOf("."))))})
                    i = i + 1
                }
                archive_model.insert(0, {index: 0, url:"http://freefall.purrsia.com/", name:"Latest Freefall"});
            }
            copy_list_models();
        }
        request.send() // Send the request
        }else if(comic_name === "Twokinds"){
            var update_page_url = "http://twokinds.keenspot.com/?p=archive"; // The url of the page is set
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', update_page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    var html_modified = request.responseText; // Load the html to the variable
                    html_modified = html_modified.substring(html_modified.indexOf("<div class=\"archive\">"), html_modified.indexOf("<div class=\"content-bottom\"></div>")); // Call load comic with the url of th last comic
                    html_modified = html_modified.substring(0, html_modified.lastIndexOf("/a"))
                    html_modified = html_modified.split("<h4>");
                    var i = 1;
                    var ndth = 1;
                    var chapter = "x"
                    while(i < html_modified.length){
                        chapter = html_modified[i].split("</h4>")[0];
                        var ii = 1;
                        var links = html_modified[i].substring(html_modified[i].indexOf("href=\""), html_modified[i].lastIndexOf("\"")).split("href=\"");
                        while(ii < links.length){
                            archive_model.append({index: ndth, url:"http://twokinds.keenspot.com/"+links[ii].split("\"")[0], name:"Twokinds n. "+String(ndth)+" ("+chapter+")"});
                            ii = ii + 1;
                            ndth = ndth + 1;
                        }
                        i = i + 1;
                    }

                    archive_model.insert(0, {index: 0, url:"http://twokinds.keenspot.com/index.php/", name:"Latest Twokinds"});
                    archive_model.append({index: ndth, url:"http://twokinds.keenspot.com/archive.php", name: "Twokinds n. "+String(ndth+1)+" ("+chapter+")"})
                    copy_list_models();
                }
            }
            request.send() // Send the request
        }else if(comic_name === "Caribbean Blue"){
            var update_page_url = "http://cblue.katbox.net/archive/"; // The url of the page is set
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', update_page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    var html_modified = request.responseText; // Load the html to the variable
                    var qty = html_modified.split("class=\"archive-link\"").length;
                    html_modified = html_modified.split("<!-- .archive-header -->")[1].split("<script type=\"text/javascript\">")[0].split("<header class='archive-year'>")
                    var i = 0;
                    var ndth = 0;
                    while(i < html_modified.length){
                        var ii = 1;
                        var links = html_modified[i].split("<a href=\"")
                        while(ii < links.length){
                            archive_model.insert(0, {index: qty-ndth-1, url:links[ii].split("\"")[0], name:links[ii].split(">")[1].split("<")[0].replace("&#8211;", " - ").replace("&#8217;", "'").replace("&#8220;", "“").replace("&#8221;", "”").replace("&#8230;", "…").replace("&#8217;", "’")});
                            ii = ii + 1;
                            ndth = ndth + 1;
                        }

                        i = i + 1;
                    }
                    archive_model.insert(0, {index: 0, url:"[last]", name:"Latest Caribbean Blue"});
                    copy_list_models();
                }
            }
            request.send() // Send the request
        }
    }

    // Function that returns archive list model

    function get_archive_model(){
        return archive_model_copy
    }

    function copy_list_models(){
        archive_model_copy.clear();
        var i = 0;
        while(i < archive_model.count){
            archive_model_copy.append(archive_model.get(i));
            i = i + 1;
        }
    }

    function filter_archives(search_querry, archive_selector){
        var i = 1;
        while(i < archive_model_copy.count){
            if(archive_model_copy.get(i).name.indexOf(search_querry) !== -1){
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
        update()
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

    // Function determining the url of an image assoiciated to a html-page
    function extract_image_url(){
        if(comic_name == "Freefall"){
            if(page_url === "http://freefall.purrsia.com/"){
                var html_modified = html.substring(html.search("The grayscale version"), html.search("Freefall updates on Monday, Wednesday, and Friday."));
                var url = "http://freefall.purrsia.com"+html_modified.substring(html_modified.indexOf("<img src=\"")+10, html_modified.indexOf("\" height="));
                latest_url = url;
                return url
            }else if(page_url.indexOf("http://freefall.purrsia.com/ff") !== -1){
                var html_modified = html.substring(html.indexOf("<img src=\"")+10, html.indexOf("\" height="));
                var url = "http://freefall.purrsia.com"+html_modified;
                return url;
            }
        }else if(comic_name == "Twokinds"){
            if(page_url === "http://twokinds.keenspot.com/index.php" || page_url === "http://twokinds.keenspot.com/"){
                var html_modified = html.substring(html.search("Comic Page for"), html.length)
                var url = "http://twokinds.keenspot.com/"+html_modified.substring(html_modified.search("<img src=\"")+10, html_modified.search("\" title=\""))
                latest_url = url;
                return url;
            }else{
                var html_modified = html.substring(html.indexOf("<p id=\"cg_img\">"), html.length)
                return html_modified.substring(html_modified.search("src=\"")+5, html_modified.search("\" alt=\""))
            }
        }else if(comic_name == "Caribbean Blue"){
            var html_modified = html.substring(0, html.search("\" class=\"attachment-full\"")) // Parse the  html...
            var url = html_modified.substring(html_modified.lastIndexOf("src=\"")+5, html_modified.length)
            if(page_url === "http://cblue.katbox.net//")
                latest_url = url;
            return url // ...
        }
    }

    function get_comic_by_url(url_to_load){
        if(url_to_load === "[last]"){
            last();
        }else{
        page_url = url_to_load;
        if(comic_name === "Freefall"){
        if(page_url === "http://freefall.purrsia.com/"){
            last();
        }

        comic_strip.source = ""; // Clear the source of the comic strip
        var fc_vs_fv = "fv"
        var png_vs_gif = ".gif"
        if(page_url === "http://freefall.purrsia.com/ff1300/fc01253.htm"){
            page_url = "http://freefall.purrsia.com/ff1300/fc01253.htm"
            loadComic("http://freefall.purrsia.com/ff1300/fc01253.png");
        }else{
            if(parseInt(page_url.split(".")[2].substring(page_url.split(".")[2].length-5, page_url.split(".")[2].length)) > 1253){
                fc_vs_fv = "fc"
                png_vs_gif = ".png"
            }
            loadComic(page_url.split(".htm")[0] + png_vs_gif)
        }
        }else if(comic_name === "Twokinds"){
            page_url = url_to_load; // The url of the page is set
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    html = request.responseText; // Load the html to the variable
                    loadComic(extract_image_url()); // Call load comic with the url of th last comic
                }
            }
            request.send() // Send the request
        }else if(comic_name === "Caribbean Blue"){
            page_url = url_to_load; // The url of the page is set
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    html = request.responseText; // Load the html to the variable
                    loadComic(extract_image_url()); // Call load comic with the url of th last comic
                }
            }
            request.send() // Send the request
        }
    }
    }


    // Function that determines the url of the last strip and calls load_comic to load it

    function last(){
        comic_strip.source = ""; // Clear the source of the comic strip
        if(comic_name === "Freefall"){ // If the last Freefall must be loaded...
            page_url = "http://freefall.purrsia.com/"; // The url of the page is set
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    html = request.responseText; // Load the html to the variable
                    loadComic(extract_image_url()); // Call load comic with the url of th last comic
                }
            }
            request.send() // Send the request
        }else if(comic_name === "Twokinds"){ // If the last Twokinds must be loaded...
            page_url = "http://twokinds.keenspot.com/"; // The url of the page is set
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    html = request.responseText; // Load the html to the variable
                    loadComic(extract_image_url()); // Call load comic with the url of th last comic
                }
            }
            request.send() // Send the request
        }else if(comic_name === "Caribbean Blue"){ // If the last Caribbean Blue must be loaded...
            page_url = "http://cblue.katbox.net//"; // The url of the page is set
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    html = request.responseText; // Load the html to the variable
                    loadComic(extract_image_url());// Call load comic with the url of the last comic
                }
            }
            request.send() // Send the request
        }
    }

    // Function that fetches next comic

    function next(){
        if(comic_name === "Freefall" && page_url !== "http://freefall.purrsia.com/" && comic_strip.source != latest_url){ // If the next Freefall must be loaded...
            comic_strip.source = ""; // Clear the source of the comic strip
            var fc_vs_fv = "fv"
            var png_vs_gif = ".gif"
            if(page_url === "http://freefall.purrsia.com/ff1300/fv01252.htm"){
                page_url = "http://freefall.purrsia.com/ff1300/fc01253.htm"
                loadComic("http://freefall.purrsia.com/ff1300/fc01253.png");
            }else{
                if(parseInt(page_url.split(".")[2].substring(page_url.split(".")[2].length-5, page_url.split(".")[2].length)) > 1252){
                    fc_vs_fv = "fc"
                    png_vs_gif = ".png"
                }
                if(page_url.split(".")[2].substring(page_url.split(".")[2].length-2, page_url.split(".")[2].length) !== "00"){
                    page_url = page_url.split(fc_vs_fv)[0]+fc_vs_fv+Array((5-(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString().length)+1).join("0")+(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString()+".htm";
                    loadComic(page_url.split(".htm")[0]+png_vs_gif); // Call load comic with the url of the last comic
                }else{
                    page_url = page_url.split("ff")[0]+"ff"+(parseInt(page_url.substring(page_url.indexOf("ff")+2, page_url.lastIndexOf("/f")))+100).toString()+"/"+fc_vs_fv+Array((5-(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString().length)+1).join("0")+(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString()+".htm";
                    loadComic(page_url.split(".htm")[0]+png_vs_gif); // Call load comic with the url of the last comic
                }
            }
        }else if(comic_name === "Twokinds"){ // If the next Twokinds must be loaded...
            if(page_url !== "http://twokinds.keenspot.com/archive.php" && page_url !== "http://twokinds.keenspot.com/index.php"){
                if(html.indexOf("id=\"cg_next\"><span>Next Comic &raquo;</span></a>") !== -1){
                    var request = new XMLHttpRequest() // Variable to hold the request
                    page_url = "http://twokinds.keenspot.com/archive.php?p="+(parseInt(page_url.split("=")[1])+1).toString()
                    request.open('GET', page_url)
                    request.onreadystatechange = function(event) { // When the page loading state is changed
                        if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                            html = request.responseText; // Load the html to the variable
                            loadComic(extract_image_url());
                        }
                    }
                    request.send() // Send the request
                }else{
                    last();
                }


            }else if(page_url === "http://twokinds.keenspot.com/archive.php"){
                last()
            }
        }else if(comic_name === "Caribbean Blue" && comic_strip.source != latest_url){ // If the next Caribbean Blue must be loaded...
            page_url = html.substring(html.indexOf("<img src=\"http://cblue.katbox.net/wp-content/uploads/sites/5/2014/02/nav_prev1.png\" alt=\"&lsaquo;\"></a>	<a href=\"")+113, html.indexOf("\" class=\"webcomic-link webcomic1-link next-webcomic-link next-webcomic1-link\" rel=\"next\">")); // The url of the page is set
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    html = request.responseText; // Load the html to the variable
                    loadComic(extract_image_url());  // Call load comic with the url of th last comic
                }
            }
            request.send() // Send the request
        }
    }

    // Function that determines the previous strip and calls load_comic

    function previous(){
        if(comic_name === "Freefall"){ // If the next Freefall must be loaded...
            if(page_url !== "http://freefall.purrsia.com/"){
                if(page_url !== "http://freefall.purrsia.com/ff100/fv00001.htm"){
                    comic_strip.source = ""; // Clear the source of the comic strip
                    var fc_vs_fv = "fv"
                    var png_vs_gif = ".gif"

                    if(page_url === "http://freefall.purrsia.com/ff1300/fc01253.htm"){
                        page_url = "http://freefall.purrsia.com/ff1300/fv01252.htm"
                        loadComic("http://freefall.purrsia.com/ff1300/fv01252.gif");
                    }else{

                        if(parseInt(page_url.split(".")[2].substring(page_url.split(".")[2].length-5, page_url.split(".")[2].length)) > 1253){
                            fc_vs_fv = "fc"
                            png_vs_gif = ".png"
                        }
                        if(page_url.split(".")[2].substring(page_url.split(".")[2].length-2, page_url.split(".")[2].length) !== "00"){
                            page_url = page_url.split(fc_vs_fv)[0]+fc_vs_fv+Array((5-(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString().length)+1).join("0")+(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])-1).toString()+".htm";
                            loadComic(page_url.split(".htm")[0]+png_vs_gif); // Call load comic with the url of the last comic
                        }else{
                            page_url = page_url.split("ff")[0]+"ff"+(parseInt(page_url.substring(page_url.indexOf("ff")+2, page_url.lastIndexOf("/f")))-100).toString()+"/"+fc_vs_fv+Array((5-(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString().length)+1).join("0")+(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])-1).toString()+".htm";
                            loadComic(page_url.split(".htm")[0]+png_vs_gif); // Call load comic with the url of the last comic
                        }
                    }
                }
            }else{
                var html_modified = html.substring(0, html.indexOf("\">Previous</A>"));
                page_url = "http://freefall.purrsia.com"+html_modified.substring(html_modified.lastIndexOf("<A HREF=\"")+9, html_modified.length);
                loadComic(page_url.split(".htm")[0]+".png");
            }
        }else if(comic_name === "Twokinds"){ // If the next Twokinds must be loaded...
            if(page_url !== "http://twokinds.keenspot.com/"){
                if(page_url !== "http://twokinds.keenspot.com/archive.php?p=1" && page_url !== "http://twokinds.keenspot.com/archive.php"){
                    var request = new XMLHttpRequest() // Variable to hold the request
                    page_url = "http://twokinds.keenspot.com/archive.php?p="+(parseInt(page_url.split("=")[1])-1).toString()
                    request.open('GET', page_url)
                    request.onreadystatechange = function(event) { // When the page loading state is changed
                        if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                            html = request.responseText; // Load the html to the variable
                            loadComic(extract_image_url());
                        }
                    }
                    request.send() // Send the request
                }else{
                    if(page_url == "http://twokinds.keenspot.com/archive.php?p=1"){
                        first();
                    }else{
                        var request = new XMLHttpRequest() // Variable to hold the request
                        page_url = html.substring(html.indexOf("<span class=\"cg_divider\"> &middot; </span><a href=\"")+51, html.indexOf("\" id=\"cg_back\">"))
                        request.open('GET', page_url)
                        request.onreadystatechange = function(event) { // When the page loading state is changed
                            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                                html = request.responseText; // Load the html to the variable
                                loadComic(extract_image_url());
                            }
                        }
                        request.send() // Send the request
                    }
                }


            }else{
                var request = new XMLHttpRequest() // Variable to hold the request
                page_url = "http://twokinds.keenspot.com/archive.php"
                request.open('GET', page_url)
                request.onreadystatechange = function(event) { // When the page loading state is changed
                    if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                        html = request.responseText; // Load the html to the variable
                        loadComic(extract_image_url());
                    }
                }
                request.send() // Send the request
            }
        }else if(comic_name === "Caribbean Blue" && page_url !== "http://cblue.katbox.net/comic/caribbean-blue/"){ // If the next Caribbean Blue must be loaded...
            page_url = html.substring(html.indexOf("<img src=\"http://cblue.katbox.net/wp-content/uploads/sites/5/2014/02/nav_first1.png\" alt=\"&laquo;\"></a>	<a href=\"")+113, html.indexOf("\" class=\"webcomic-link webcomic1-link previous-webcomic-link previous-webcomic1-link\" rel=\"prev\"><img src=\"")); // The url of the page is set
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    html = request.responseText; // Load the html to the variable
                    loadComic(extract_image_url(html));  // Call load comic with the url of th last comic
                }
            }
            request.send() // Send the request
        }
    }

    // Function that determines the first strip and calls load_comic

    function first(){
        comic_strip.source = ""; // Clear the source of the comic strip
        //html = ""; // Variable to hold the content of the html-page
        if(comic_name === "Freefall"){ // If the last Freefall must be loaded...
            page_url = "http://freefall.purrsia.com/ff100/fv00001.htm"; // Set the page url
            loadComic("http://freefall.purrsia.com/ff100/fv00001.gif"); // Load the comic
        }else if(comic_name === "Twokinds"){ // If the last Twokinds must be loaded...
            page_url = "http://twokinds.keenspot.com/archive.php?p=1"; // Set the page url
            loadComic("http://cdn.twokinds.keenspot.com/comics/20031022.jpg"); // Load the comic
        }else if(comic_name === "Caribbean Blue"){ // If the last Caribbean Blue must be loaded...
            page_url = "http://cblue.katbox.net/comic/caribbean-blue/"; // Set the page url
            loadComic("http://cblue.katbox.net/wp-content/uploads/sites/5/2013/01/cb000en.png"); // Load the comic
        }
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                html = request.responseText; // Load the html to the variable
            }
        }
        request.send() // Send the request
    }

    id: shape
    width: parent.width - units.gu(3);
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    height: (parent.height / 3)*2;
    Flickable{ // Flickable to hold the image
        function get_width(){ // Function to determine the width of the Flickable
            if(parent.width > comic_strip.width){
                return comic_strip.width;
            }else{
                return parent.width;
            }
        }
        function get_height(){ // Function to determine the height of the Flickable
            if(parent.height > comic_strip.height){
                return comic_strip.height;
            }else{
                return parent.height;
            }
        }

        width: get_width()
        height: get_height();
        contentWidth: comic_strip.width;
        contentHeight: comic_strip.height
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true;
        Image{ // Image to hold the comic strip
            id: comic_strip
            visible: false;
            onProgressChanged: checkLoading() // Calls check_comic whenever the progress changes
        }
    }

    ProgressBar { // Busy-indicator
        id: activity
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        value: 0;
    }
    Text{ // Text telling that the comic is loading
        id: comic_status
        text: comic_name+i18n.tr(" is loading...")
        font.family: "Ubuntu"
        font.pointSize: 12;
        color: "#333333"
        anchors.horizontalCenter: parent.horizontalCenter;
        y: activity.y + units.gu(5);
    }
}
