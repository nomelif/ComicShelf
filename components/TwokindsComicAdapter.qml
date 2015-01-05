import QtQuick 2.0

Item {
    property var load;
    property var html;
    property var archive;
    property string page_url;

    function update(){
        var update_page_url = "http://twokinds.keenspot.com/?p=archive"; // The url of the page is set
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', update_page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                var html_modified = request.responseText; // Load the html to the variable
                // Split the html by chapter
                html_modified = html_modified.substring(html_modified.indexOf("<div class=\"archive\">"), html_modified.indexOf("<div style=\"clear: both;\"></div>")); // Call load comic with the url of th last comic
                html_modified = html_modified.substring(0, html_modified.lastIndexOf("/a"))
                html_modified = html_modified.split("<h4>");
                var i = 1;
                var ndth = 1; // Iterator for giving values to the index property of the list model
                var chapter = "x" // Chapter in wich the current strip appears
                while(i < html_modified.length){ // Iterate through chapters
                    chapter = html_modified[i].split("</h4>")[0]; // Retrieve the name of the chapter
                    var ii = 1;
                    // Retrieve list of links from chapter's html
                    var links = html_modified[i].substring(html_modified[i].indexOf("href=\""), html_modified[i].lastIndexOf("\"")).split("href=\"");
                    // Iterate through the list of links
                    while(ii < links.length){
                        archive.append({index: ndth, url:"http://twokinds.keenspot.com/"+links[ii].split("\"")[0], name:"Twokinds n. "+String(ndth)+" ("+chapter+")"});
                        ii = ii + 1;
                        ndth = ndth + 1;
                    }
                    i = i + 1;
                }
                // Insert the missing two entries
                archive.insert(0, {index: 0, url:"http://twokinds.keenspot.com/index.php/", name:"Latest Twokinds"});
                archive.append({index: ndth, url:"http://twokinds.keenspot.com/archive.php", name: "Twokinds n. "+String(ndth+1)+" ("+chapter+")"})
                // Copy the archive model to the list model to search
                comic.copy_list_models();
            }
        }
        request.send() // Send the request
    }

    function first_url(){
        get_by_url("http://twokinds.keenspot.com/archive.php?p=1")
    }

    function next_url(){

        if(page_url !== "http://twokinds.keenspot.com/archive.php" && page_url !== "http://twokinds.keenspot.com/index.php"){
            if(html.indexOf("id=\"cg_next\"><span>Next Comic &raquo;</span></a>") !== -1){
                var request = new XMLHttpRequest() // Variable to hold the request
                page_url = "http://twokinds.keenspot.com/archive.php?p="+(parseInt(page_url.split("=")[1])+1).toString()
                request.open('GET', page_url)
                request.onreadystatechange = function(event) { // When the page loading state is changed
                    if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                        html = request.responseText; // Load the html to the variable
                        load(parse_url());
                    }
                }
                request.send() // Send the request
            }else{
                latest_url();
            }


        }else if(page_url === "http://twokinds.keenspot.com/archive.php"){
            latest_url()
        }
    }

    function previous_url(){
        if(page_url !== "http://twokinds.keenspot.com/"){
            if(page_url !== "http://twokinds.keenspot.com/archive.php?p=1" && page_url !== "http://twokinds.keenspot.com/archive.php"){
                var request = new XMLHttpRequest() // Variable to hold the request
                page_url = "http://twokinds.keenspot.com/archive.php?p="+(parseInt(page_url.split("=")[1])-1).toString()
                request.open('GET', page_url)
                request.onreadystatechange = function(event) { // When the page loading state is changed
                    if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                        html = request.responseText; // Load the html to the variable
                        load(parse_url())
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
                            load(parse_url())
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
                    load(parse_url())
                }
            }
            request.send() // Send the request
        }
    }

    function latest_url(){

        page_url = "http://twokinds.keenspot.com/"; // The url of the page is set
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                html = request.responseText; // Load the html to the variable
                load(parse_url()); // Call load comic with the url of th last comic
            }
        }
        request.send() // Send the request
    }

    function get_by_url(url){
        page_url = url
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                html = request.responseText; // Load the html to the variable
                load(parse_url())
            }
        }
        request.send() // Send the request
    }

    function parse_url(){
        if(page_url === "http://twokinds.keenspot.com/index.php" || page_url === "http://twokinds.keenspot.com/"){
            var html_modified = html.substring(html.search("Comic Page for"), html.length)
            var url = "http://twokinds.keenspot.com/"+html_modified.substring(html_modified.search("<img src=\"")+10, html_modified.search("\" title=\""))
            url = url;
            return url;
        }else{
            var html_modified = html.substring(html.indexOf("<p id=\"cg_img\">"), html.length)
            return "http://twokinds.keenspot.com"+html_modified.substring(html_modified.search("src=\"")+5, html_modified.search("\" alt=\""))
        }
    }
}
