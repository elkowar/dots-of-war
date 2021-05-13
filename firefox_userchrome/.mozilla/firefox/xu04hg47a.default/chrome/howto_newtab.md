## A basic term-like startpage with tree structure

![preview-StartupPage](../Screenshots/StartupPage.png)

### For using it in Firfox follow the following steps -:

* Make a file called `enable-autoconfig.js` in `/usr/lib/firefox/browser/defaults/preferences`
  add this to that file:-
```
// enable autoconfig
    pref("general.config.sandbox_enabled", false);

pref("general.config.filename", "autoconfig.cfg");
    pref("general.config.obscure_value", 0);
```

* Make `autoconfig.cfg` in `/usr/lib/firefox`
  and add this to it:-

```
var {classes:Cc,interfaces:Ci,utils:Cu} = Components;

/* set new tab page */
try {
  Cu.import("resource:///modules/AboutNewTab.jsm");
  var newTabURL = "file://<path to html file>";
  AboutNewTab.newTabURL = newTabURL;
} catch(e){Cu.reportError(e);} // report errors in the Browser Console
```

Remember to change the path to where you store the HTML files

Use Discord.css with stylus(extension) to enable css in discord

