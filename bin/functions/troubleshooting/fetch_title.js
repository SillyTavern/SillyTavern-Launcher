var x = new ActiveXObject("Microsoft.XMLHTTP");
var url = WScript.Arguments(0);
var timeout = 5000;  // 5 seconds timeout
var startTime = new Date().getTime();

x.open("GET", url, false);
x.setRequestHeader('User-Agent', 'XMLHTTP/1.0');

try {
    x.send('');
    while (x.readyState != 4) {
        if (new Date().getTime() - startTime > timeout) {
            throw new Error("Request timed out");
        }
        WScript.Sleep(50);
    }

    if (x.status == 200) {
        var responseText = x.responseText;
        var matches = responseText.match(/<title>(.*?)<\/title>/i);
        if (matches && matches[1]) {
            WScript.Echo(matches[1]);
        } else {
            WScript.Echo("Title tag not found");
        }
    } else if (x.status == 404) {
        WScript.Echo("No User Accessible Web Application running on port, May be an API (404 Not Found)");
    } else {
        WScript.Echo("HTTP Error: " + x.status);
    }
} catch (e) {
    WScript.Echo(e.message);
}
