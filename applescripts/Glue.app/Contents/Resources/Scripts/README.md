# Glue

Helps make clickable urls that open in local apps.
Can be used with redirector to have links clicked in a browser open local apps.
Helps loosely couple 

# Chrome Redirector Integration

* https://chrome.google.com/webstore/detail/redirector/ocgpenflpmgnfapjedencafcfakcekcd
* Configuration: 
    * Redirects Glue URLs to xcallback.
    * Redirect:	Redirect:	https://glue/*
    * to:	glue://$1
    * Hint:	Special Glue URLs
    * Example:	https://glue/blueprints/initiatives/tool-dashboard.md#id.dashboard → glue://blueprints/initiatives/tool-dashboard.md#id.dashboard
    * Applies to:	Main window (address bar)