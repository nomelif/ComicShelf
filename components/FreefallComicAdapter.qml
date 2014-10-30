import QtQuick 2.0

Item {
    property var load;
    property var html;
    property var archive;
    property string last_url;
    property string page_url;


    function update(){
        var update_page_url = "http://freefall.purrsia.com/fcdex.htm"; // The url of the page is set
        var request = new XMLHttpRequest() // Variable to hold the request
        request.open('GET', update_page_url) // Send the request
        request.onreadystatechange = function(event) { // When the page loading state is changed
            if (request.readyState === XMLHttpRequest.DONE) { // If the page is loaded
                var html_modified = request.responseText; // Load the html to the variable
                // Begin treating html
                html_modified = html_modified.substring(html_modified.indexOf("<FONT SIZE=+1>The adventure begins!</FONT>&nbsp;&nbsp;3/30/1998<BR>"), html_modified.indexOf("<A HREF=\"/default.htm\">Current</A>")); // Call load comic with the url of th last comic
                // List of all links
                var link_list = html_modified.split("HREF=\"")
                var i = 1;
                // Iterate throught the list of links
                while(i < link_list.length){
                    // Get the name of the strip
                    var name = link_list[i].split("\"")[0]
                    // Insert relevant information to the archive model
                    archive.insert(i-1, {index: i, url:"http://freefall.purrsia.com"+link_list[i].split("\"")[0], name:"Freefall n."+String(parseInt(name.substring(name.indexOf("0/f")+4, name.indexOf("."))))})
                    i = i + 1
                }
                // Insert latest strip to the archive model
                archive.insert(0, {index: 0, url:"http://freefall.purrsia.com/", name:"Latest Freefall"});
            }
            // Copy the archive model to the list model to searchimport QtQuick.Window 2.2
            comic.copy_list_models();
        }
        request.send() // Send the request
    }

    function first_url(){
        get_by_url("http://freefall.purrsia.com/ff100/fv00001.htm")
    }

    function next_url(){

        if(page_url.split(".htm")[0] !== last_url.split(".png")[0]){
        var fc_vs_fv = "fv"
        var png_vs_gif = ".gif"
        if(page_url === "http://freefall.purrsia.com/ff1300/fv01252.htm"){
            page_url = "http://freefall.purrsia.com/ff1300/fc01253.htm"
            load("http://freefall.purrsia.com/ff1300/fc01253.png");
        }else{
            if(parseInt(page_url.split(".")[2].substring(page_url.split(".")[2].length-5, page_url.split(".")[2].length)) > 1252){
                fc_vs_fv = "fc"
                png_vs_gif = ".png"
            }
            if(page_url.split(".")[2].substring(page_url.split(".")[2].length-2, page_url.split(".")[2].length) !== "00"){
                page_url = page_url.split(fc_vs_fv)[0]+fc_vs_fv+Array((5-(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString().length)+1).join("0")+(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString()+".htm";
                load(page_url.split(".htm")[0]+png_vs_gif); // Call load comic with the url of the last comic
            }else{
                page_url = page_url.split("ff")[0]+"ff"+(parseInt(page_url.substring(page_url.indexOf("ff")+2, page_url.lastIndexOf("/f")))+100).toString()+"/"+fc_vs_fv+Array((5-(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString().length)+1).join("0")+(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString()+".htm";
                load(page_url.split(".htm")[0]+png_vs_gif); // Call load comic with the url of the last comic
            }
        }}
    }

    function previous_url(){

        if(page_url !== "http://freefall.purrsia.com/"){
            if(page_url !== "http://freefall.purrsia.com/ff100/fv00001.htm"){
                var fc_vs_fv = "fv"
                var png_vs_gif = ".gif"

                if(page_url === "http://freefall.purrsia.com/ff1300/fc01253.htm"){
                    page_url = "http://freefall.purrsia.com/ff1300/fv01252.htm"
                    load("http://freefall.purrsia.com/ff1300/fv01252.gif");
                }else{

                    if(parseInt(page_url.split(".")[2].substring(page_url.split(".")[2].length-5, page_url.split(".")[2].length)) > 1253){
                        fc_vs_fv = "fc"
                        png_vs_gif = ".png"
                    }
                    if(page_url.split(".")[2].substring(page_url.split(".")[2].length-2, page_url.split(".")[2].length) !== "00"){
                        page_url = page_url.split(fc_vs_fv)[0]+fc_vs_fv+Array((5-(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString().length)+1).join("0")+(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])-1).toString()+".htm";
                        load(page_url.split(".htm")[0]+png_vs_gif); // Call load comic with the url of the last comic
                    }else{
                        page_url = page_url.split("ff")[0]+"ff"+(parseInt(page_url.substring(page_url.indexOf("ff")+2, page_url.lastIndexOf("/f")))-100).toString()+"/"+fc_vs_fv+Array((5-(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])+1).toString().length)+1).join("0")+(parseInt(page_url.split(fc_vs_fv)[1].split(png_vs_gif)[0])-1).toString()+".htm";
                        load(page_url.split(".htm")[0]+png_vs_gif); // Call load comic with the url of the last comic
                    }
                }
            }
        }else{
            var html_modified = html.substring(0, html.indexOf("\">Previous</A>"));
            page_url = "http://freefall.purrsia.com"+html_modified.substring(html_modified.lastIndexOf("<A HREF=\"")+9, html_modified.length);
            load(page_url.split(".htm")[0]+".png");
        }
    }

    function latest_url(){

        page_url = "http://freefall.purrsia.com/"; // The url of the page is set
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
        if(page_url === "http://freefall.purrsia.com/"){
            latest_url();
        }
        var fc_vs_fv = "fv"
        var png_vs_gif = ".gif"
        if(page_url === "http://freefall.purrsia.com/ff1300/fc01253.htm"){
            page_url = "http://freefall.purrsia.com/ff1300/fc01253.htm"
            load("http://freefall.purrsia.com/ff1300/fc01253.png");
        }else{
            if(parseInt(page_url.split(".")[2].substring(page_url.split(".")[2].length-5, page_url.split(".")[2].length)) > 1253){
                fc_vs_fv = "fc"
                png_vs_gif = ".png"
            }
            load(page_url.split(".htm")[0] + png_vs_gif)
        }
    }

    function parse_url(){
        if(page_url === "http://freefall.purrsia.com/"){
            var html_modified = html.substring(html.search("The grayscale version"), html.search("Freefall updates on Monday, Wednesday, and Friday."));
            var url = "http://freefall.purrsia.com"+html_modified.substring(html_modified.indexOf("<img src=\"")+10, html_modified.indexOf("\" height="));
            last_url = url;
            return url
        }else if(page_url.indexOf("http://freefall.purrsia.com/ff") !== -1){
            var html_modified = html.substring(html.indexOf("<img src=\"")+10, html.indexOf("\" height="));
            var url = "http://freefall.purrsia.com"+html_modified;
            return url;
        }
    }
}
