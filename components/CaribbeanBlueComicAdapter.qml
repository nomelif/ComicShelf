import QtQuick 2.0

Item {
    property var load;
    property var html;
    property var archive;
    property string page_url;


    function update(){
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
                        archive.insert(0, {index: qty-ndth-1, url:links[ii].split("\"")[0], name:links[ii].split(">")[1].split("<")[0].replace("&#8211;", " - ").replace("&#8217;", "'").replace("&#8220;", "“").replace("&#8221;", "”").replace("&#8230;", "…").replace("&#8217;", "’")});
                        ii = ii + 1;
                        ndth = ndth + 1;
                    }

                    i = i + 1;
                }
                archive.insert(0, {index: 0, url:"[last]", name:"Latest Caribbean Blue"});
                comic.copy_list_models();
            }
        }
        request.send() // Send the request
    }

    function first_url(){
        get_by_url("http://cblue.katbox.net/comic/caribbean-blue/"); // Set the page url
    }

    function next_url(){
        if(page_url !== "http://cblue.katbox.net//"){
        page_url = html.substring(html.indexOf("<img src=\"http://cblue.katbox.net/wp-content/uploads/sites/5/2014/02/nav_prev1.png\" alt=\"&lsaquo;\"></a>	<a href=\"")+113, html.indexOf("\" class=\"webcomic-link webcomic1-link next-webcomic-link next-webcomic1-link\" rel=\"next\">")); // The url of the page is set
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                if(page_url.indexOf("<!doctype html>") === -1){
                html = request.responseText; // Load the html to the variable
                load(parse_url())  // Call load comic with the url of th last comic
                }else{
                    page_url = "http://cblue.katbox.net//"
                }
            }
        }
        request.send() // Send the request
        }
    }

    function previous_url(){

       if(page_url !== "http://cblue.katbox.net/comic/caribbean-blue/"){
       page_url = html.substring(html.indexOf("<img src=\"http://cblue.katbox.net/wp-content/uploads/sites/5/2014/02/nav_first1.png\" alt=\"&laquo;\"></a>	<a href=\"")+113, html.indexOf("\" class=\"webcomic-link webcomic1-link previous-webcomic-link previous-webcomic1-link\" rel=\"prev\"><img src=\"")); // The url of the page is set
       var request = new XMLHttpRequest() // Variable to hold the request
       request.open('GET', page_url) // Send the request
       request.onreadystatechange = function(event) { // When the page loading state is changed
           if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
               html = request.responseText; // Load the html to the variable
               load(parse_url());  // Call load comic with the url of th last comic
           }
       }
       request.send() // Send the request
       }
    }

    function latest_url(){

        page_url = "http://cblue.katbox.net//"; // The url of the page is set
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                html = request.responseText; // Load the html to the variable
                load(parse_url());// Call load comic with the url of the last comic
            }
        }
        request.send() // Send the request
    }

    function get_by_url(url){

        page_url = url; // The url of the page is set
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                html = request.responseText; // Load the html to the variable
                load(parse_url()) // Call load comic with the url of th last comic
            }
        }
        request.send() // Send the request
    }

    function parse_url(){
        var html_modified = html.substring(0, html.search("\" class=\"attachment-full\"")) // Parse the  html...
        var url = html_modified.substring(html_modified.lastIndexOf("src=\"")+5, html_modified.length)
        return url // ...
    }
}
