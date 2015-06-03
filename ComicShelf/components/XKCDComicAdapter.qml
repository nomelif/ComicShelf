import QtQuick 2.0
import com.comicshelf.fio 1.0

Item {

    property var load;
    property string html;
    property var archive;
    property string last_url;
    property string page_url;

    FIO{
        id: fio;
    }

    function getTitle(){
        console.log(html)
        return html.split("\"title\": \"")[1].split("\"")[0];
    }

    function continueReading(){
        get_by_url(fio.getPrevPage("XKCD"))
    }

    function update(){
        var update_page_url = "http://xkcd.com/archive/"; // The url of the page is set
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', update_page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                var html_modified = request.responseText; // Load the html to the variable
                html_modified = html_modified.split("<h1>Comics:</h1><br/>\n(Hover mouse over title to view publication date)<br /><br />")[1].split("</div>")[0]
                html_modified = html_modified.split("<a")
                var i = 0;
                while(i < html_modified.length){
                    var link = html_modified[i].split("<")[0]
                    var ndth = link.split("/")[1]
                    var date = link.split("\"")[3]
                    var title = link.split(">")[1]
                    archive.insert(0, {index: parseInt(ndth), url:"http://xkcd.com"+link.split("\"")[1]+"info.0.json", name:title + " ("+date+") n."+ndth});
                    i = i + 1
                }
                archive.insert(0, {index: 0, url:"[last]", name:"Latest xkcd"});
                comic.copy_list_models();
            }
        }
        request.send() // Send the request
    }

    function first_url(){
        get_by_url("http://xkcd.com/1/info.0.json")
    }

    function next_url(){
        if(page_url !== "http://xkcd.com/info.0.json" && page_url !== latest_url){
            page_url = "http://xkcd.com/"+String(parseInt(page_url.split("http://xkcd.com/")[1].split("/info.0.json")[0])+1)+"/info.0.json"
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

    function previous_url(){
        if(page_url === "http://xkcd.com/info.0.json"){
            page_url = "http://xkcd.com/"+String(parseInt(html.split("\"num\": ")[1].split(",")[0])-1)+"/info.0.json"
            var request = new XMLHttpRequest() // Variable to hold the request
            request.open('GET', page_url) // Send the request
            request.onreadystatechange = function(event) { // When the page loading state is changed
                if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                    html = request.responseText; // Load the html to the variable
                    load(parse_url());  // Call load comic with the url of th last comic
                }
            }
            request.send() // Send the request
        }else{
            if(page_url !== "http://xkcd.com/1/info.0.json"){
            page_url = "http://xkcd.com/"+String(parseInt(page_url.split("http://xkcd.com/")[1].split("/info.0.json")[0])-1)+"/info.0.json"
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
    }

    function latest_url(){
        page_url = "http://xkcd.com/info.0.json"; // The url of the page is set
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

    function get_by_url(url_to_load){
        page_url = url_to_load; // The url of the page is set
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

    function parse_url(){
        var html_modified = html.split("\"img\": \"http:\\/\\/imgs.xkcd.com\\/comics\\/")[1] // Parse the  html...
        var url = "http://imgs.xkcd.com/comics/"+html_modified.split("\"")[0]
        if(page_url === "http://xkcd.com/info.0.json")
            last_url = "http://xkcd.com/"+String(parseInt(html.split("\"num\": ")[1].split(",")[0]))+"/info.0.json";
        return url
    }
}
