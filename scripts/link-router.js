const http = require('http');
const open = require('open');
const url = require('url');


var mapping = {
  "/GO-2": "ia-writer://open?path=/Locations/personalbook/roles-for-vocation/The%20Software%20Developer/Learning%20Programming%20Languages/Tinker%20with%20Go.md",
  "/GO-3": "ia-writer://open?path=/Locations/personalbook/roles-for-vocation/The%20Software%20Developer/Tinker%20with%20CLIs.md",
  "/GO-4": "ia-writer://open?path=/Locations/personalbook/roles-for-vocation/The%20DevOps%20Engineer/Tinker%20with%20k8s.txt",
}
// This can be run in my local mac ... and I can use it to open links I embedd ... in websites ... locally on my laptop!
// I can also have it proxy ... and link to a public version vs private version ...

// https://stackoverflow.com/questions/8500326/how-to-use-nodejs-to-open-default-browser-and-navigate-to-a-specific-url
// https://github.com/sindresorhus/open
const requestListener = async function (req, res) {
  var urlParts = url.parse(req.url, true);
  var urlPathname = urlParts.pathname;
  console.log(urlPathname);
  var toOpen = mapping[urlPathname]; 
  if (typeof toOpen !== 'undefined') {
    await open(toOpen);
    // res.writeHead(200);
    // res.end('Opened link: ' + toOpen);
    res.writeHead(302, {'Location': "https://sacred-patterns.atlassian.net/browse" + req.url});
    res.end();
  }
  else {
    res.writeHead(500);
    res.end();
    // res.end('Mapping not found: ' + urlPathname);
  }
  // https://sailsjs.com/documentation/reference/response-res/res-redirect
  // res.redirect(req.originalUrl);
}

const server = http.createServer(requestListener);
server.listen(80);
