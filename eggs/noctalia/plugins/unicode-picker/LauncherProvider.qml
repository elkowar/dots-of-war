import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Item {
  id: root

  // Plugin API provided by PluginService
  property var pluginApi: null

  // Provider metadata
  property string name: "Unicode"
  property var launcher: null
  property bool handleSearch: false
  property string supportedLayouts: "list"
  property bool supportsAutoPaste: true

  // Browsing state
  property string selectedCategory: "recent"
  property bool showsCategories: true

  // Unicode data
  property bool loaded: false
  property bool namesLoaded: false
  property var usageCounts: ({})
  property var unicodeNames: ({})
  property var _categoryCache: ({})

  readonly property string emptyBrowsingMessage: selectedCategory === "recent" ? "No recently used characters" : ""

  // Cache directory - create from pluginDir
  readonly property string cacheDir: pluginApi?.pluginDir ? pluginApi.pluginDir + "/cache" : ""

  // File paths
  readonly property string usageFilePath: cacheDir ? cacheDir + "/unicode_usage.json" : ""
  readonly property string unicodeDataPath: cacheDir ? cacheDir + "/UnicodeData.txt" : ""
  readonly property string nameAliasesPath: cacheDir ? cacheDir + "/NameAliases.txt" : ""
  readonly property string unicodeDataUrl: "https://unicode.org/Public/15.1.0/ucd/UnicodeData.txt"
  readonly property string nameAliasesUrl: "https://unicode.org/Public/15.1.0/ucd/NameAliases.txt"

  // Unicode blocks configuration
  readonly property var unicodeBlocks: [
    { name: "arrows", start: 0x2190, end: 0x21FF, icon: "arrows-left-right" },
    { name: "mathematical", start: 0x2200, end: 0x22FF, icon: "math-function" },
    { name: "box-drawing", start: 0x2500, end: 0x257F, icon: "layout-board" },
    { name: "block-elements", start: 0x2580, end: 0x259F, icon: "square-filled" },
    { name: "geometric", start: 0x25A0, end: 0x25FF, icon: "shapes" },
    { name: "misc-symbols", start: 0x2600, end: 0x26FF, icon: "star" },
    { name: "currency", start: 0x20A0, end: 0x20CF, icon: "currency-dollar" },
    { name: "greek", start: 0x0370, end: 0x03FF, icon: "omega" },
    { name: "cyrillic", start: 0x0400, end: 0x04FF, icon: "letter-a" },
    { name: "misc-technical", start: 0x2300, end: 0x23FF, icon: "tool" },
    { name: "superscripts", start: 0x2070, end: 0x209F, icon: "superscript" },
    { name: "number-forms", start: 0x2150, end: 0x218F, icon: "numbers" },
    { name: "dingbats", start: 0x2700, end: 0x27BF, icon: "scissors" },
    { name: "latin-extended", start: 0x0100, end: 0x017F, icon: "letter-case" },
    { name: "braille", start: 0x2800, end: 0x28FF, icon: "dots" }
  ]

  // Categories list: recent + all unicode blocks
  property var categories: {
    var cats = ["recent"];
    for (var i = 0; i < unicodeBlocks.length; i++) {
      cats.push(unicodeBlocks[i].name);
    }
    return cats;
  }

  // Category icons
  property var categoryIcons: {
    var icons = { "recent": "clock" };
    for (var i = 0; i < unicodeBlocks.length; i++) {
      var block = unicodeBlocks[i];
      icons[block.name] = block.icon;
    }
    return icons;
  }

  function getCategoryName(category) {
    var names = {
      "recent": "Recent",
      "arrows": "Arrows",
      "mathematical": "Mathematical",
      "box-drawing": "Box Drawing",
      "block-elements": "Block Elements",
      "geometric": "Geometric",
      "misc-symbols": "Misc Symbols",
      "currency": "Currency",
      "greek": "Greek",
      "cyrillic": "Cyrillic",
      "misc-technical": "Technical",
      "superscripts": "Superscripts",
      "number-forms": "Number Forms",
      "dingbats": "Dingbats",
      "latin-extended": "Latin Extended",
      "braille": "Braille"
    };
    return names[category] || category;
  }

  // Initialize provider
  function init() {
    if (cacheDir) {
      usageFile.path = usageFilePath;
      usageFile.reload();
      unicodeDataFile.path = unicodeDataPath;
      unicodeDataFile.reload();
    } else {
      Logger.w("UnicodeProvider", "Cannot init - cacheDir not available");
    }
  }

  function selectCategory(category) {
    selectedCategory = category;
    if (launcher) {
      launcher.updateResults();
    }
  }

  function onOpened() {
    selectedCategory = "recent";
  }

  // Unicode helper functions
  function getCharacterName(cp) {
    return unicodeNames[cp] || "";
  }

  function _isValidUnicodeChar(cp) {
    return cp >= 0x20 && cp !== 0x7F &&
           !(cp >= 0x80 && cp <= 0x9F) &&
           !(cp >= 0xD800 && cp <= 0xDFFF) &&
           !(cp >= 0xE000 && cp <= 0xF8FF) &&
           cp !== 0xFFFE && cp !== 0xFFFF;
  }

  function _makeCharObj(cp, category) {
    return {
      char: String.fromCodePoint(cp),
      codePoint: cp,
      hex: "U+" + cp.toString(16).toUpperCase().padStart(4, "0"),
      name: getCharacterName(cp),
      category: category
    };
  }

  function generateBlockCharacters(block) {
    var key = block.name + (namesLoaded ? "_n" : "");
    if (_categoryCache[key]) return _categoryCache[key];

    var chars = [];
    for (var cp = block.start; cp <= block.end; cp++) {
      if (_isValidUnicodeChar(cp)) chars.push(_makeCharObj(cp, block.name));
    }
    _categoryCache[key] = chars;
    return chars;
  }

  function _getCategoryForCodePoint(cp) {
    var block = unicodeBlocks.find(b => cp >= b.start && cp <= b.end);
    return block ? block.name : "other";
  }

  function search(query) {
    if (!query || !query.trim()) return _getRecentCharacters(50);

    var results = [], q = query.toLowerCase().trim();
    var hexQuery = q.replace(/^u\+?/i, "");

    // Hex codepoint search
    if (/^[0-9a-f]+$/i.test(hexQuery) && hexQuery.length >= 2) {
      var cp = parseInt(hexQuery, 16);
      if (_isValidUnicodeChar(cp) && cp <= 0x10FFFF) {
        results.push(_makeCharObj(cp, _getCategoryForCodePoint(cp)));
      }
    }

    // Category and name search
    for (var block of unicodeBlocks) {
      var chars = generateBlockCharacters(block);
      if (block.name.includes(q)) {
        results = results.concat(chars.slice(0, 30));
      } else if (namesLoaded) {
        for (var c of chars) {
          if (results.length >= 100) break;
          if (c.name && c.name.toLowerCase().includes(q)) results.push(c);
        }
      }
    }

    // Deduplicate
    var seen = new Set();
    return results.filter(r => { if (seen.has(r.char)) return false; seen.add(r.char); return true; }).slice(0, 100);
  }

  function getCharactersByCategory(category) {
    if (category === "recent") return _getRecentCharacters(50);
    var block = unicodeBlocks.find(b => b.name === category);
    return block ? generateBlockCharacters(block) : [];
  }

  function _getRecentCharacters(limit) {
    return Object.entries(usageCounts)
      .sort((a, b) => (b[1].lastUsed - a[1].lastUsed) || (b[1].count - a[1].count))
      .slice(0, limit)
      .map(([ch]) => _makeCharObj(ch.codePointAt(0), "recent"));
  }

  function recordUsage(ch) {
    if (!ch) return;
    var d = usageCounts[ch] || { count: 0, lastUsed: 0 };
    usageCounts[ch] = { count: d.count + 1, lastUsed: Date.now() };
    saveTimer.restart();
  }

  function copy(ch) {
    if (!ch) return;
    recordUsage(ch);
    Quickshell.execDetached(["sh", "-c", `echo -n "${ch}" | wl-copy`]);
  }

  function _downloadUnicodeData() {
    if (!cacheDir) {
      Logger.w("UnicodeProvider", "Cannot download: cacheDir not available");
      return;
    }
    Logger.i("UnicodeProvider", "Downloading Unicode data from unicode.org...");

    Quickshell.execDetached(["sh", "-c",
      `mkdir -p "${cacheDir}" && \
       curl -f -s -S -o "${unicodeDataPath}" "${unicodeDataUrl}" && \
       curl -f -s -S -o "${nameAliasesPath}" "${nameAliasesUrl}"`
    ]);
    downloadTimer.start();
  }

  function _parseUnicodeData(content) {
    var names = {};
    for (var line of content.split("\n")) {
      var parts = line.split(";");
      if (parts.length >= 2 && parts[1] && !parts[1].startsWith("<")) {
        names[parseInt(parts[0], 16)] = parts[1];
      }
    }
    return names;
  }

  function _parseNameAliases(content, names) {
    for (var line of content.split("\n")) {
      if (!line.trim() || line.startsWith("#")) continue;
      var parts = line.split(";");
      if (parts.length >= 2) {
        var cp = parseInt(parts[0], 16);
        if (!names[cp] && parts[1]) names[cp] = parts[1];
      }
    }
    return names;
  }

  // Check if this provider handles the command
  function handleCommand(searchText) {
    return searchText.startsWith(">unicode");
  }

  // Return available commands when user types ">"
  function commands() {
    return [{
      "name": ">unicode",
      "description": "Browse and search Unicode characters",
      "icon": "code",
      "isTablerIcon": true,
      "isImage": false,
      "onActivate": function() {
        launcher.setSearchText(">unicode ");
      }
    }];
  }

  // Get search results
  function getResults(searchText) {
    if (!searchText.startsWith(">unicode")) {
      return [];
    }

    var query = searchText.slice(8).trim(); // ">unicode ".length = 8

    if (query === "") {
      showsCategories = true;
      var chars = getCharactersByCategory(selectedCategory);
      return chars.map(formatCharEntry);
    } else {
      showsCategories = false;
      var chars = search(query);
      return chars.map(formatCharEntry);
    }
  }

  // Format a character entry for the results list
  function formatCharEntry(charData) {
    var charValue = charData.char;
    var title = charData.name || charData.hex;
    var categoryName = getCategoryName(charData.category);
    var desc = charData.name ? `${charData.hex} • ${categoryName}` : categoryName;

    return {
      "name": title,
      "description": desc,
      "icon": null,
      "isImage": false,
      "displayString": charValue,
      "autoPasteText": charValue,
      "provider": root,
      "onAutoPaste": function() {
        recordUsage(charValue);
      },
      "onActivate": function() {
        copy(charValue);
        launcher.close();
      }
    };
  }

  // Timers
  Timer {
    id: downloadTimer
    interval: 5000  // Increased to 5 seconds for slower connections
    repeat: false
    onTriggered: {
      unicodeDataFile.reload();
    }
  }

  Timer {
    id: saveTimer
    interval: 1000
    onTriggered: {
      if (cacheDir) {
        Quickshell.execDetached(["sh", "-c", `mkdir -p "${cacheDir}" && echo '${JSON.stringify(usageCounts)}' > "${usageFilePath}"`]);
      }
    }
  }

  // File loaders
  FileView {
    id: unicodeDataFile
    path: ""
    printErrors: false
    watchChanges: false
    onLoaded: {
      var content = text();
      if (content && content.length > 1000) {
        root.unicodeNames = root._parseUnicodeData(content);
        nameAliasesFile.path = root.nameAliasesPath;
        nameAliasesFile.reload();
      } else {
        Logger.w("UnicodeProvider", "UnicodeData too small or empty, downloading...");
        root._downloadUnicodeData();
      }
    }
    onLoadFailed: {
      Logger.w("UnicodeProvider", "UnicodeData not found, downloading...");
      root._downloadUnicodeData();
    }
  }

  FileView {
    id: nameAliasesFile
    path: ""
    printErrors: false
    watchChanges: false
    onLoaded: {
      var content = text();
      if (content) {
        root.unicodeNames = root._parseNameAliases(content, root.unicodeNames);
      }
      root.namesLoaded = true;
      root._categoryCache = {};
      root.loaded = true;
      Logger.i("UnicodeProvider", "Unicode name database ready!");
    }
    onLoadFailed: {
      Logger.w("UnicodeProvider", "NameAliases not found, continuing without aliases");
      root.namesLoaded = false;
      root.loaded = true;
    }
  }

  FileView {
    id: usageFile
    path: ""
    printErrors: false
    watchChanges: false
    onLoaded: {
      try {
        root.usageCounts = JSON.parse(text()) || {};
      } catch(e) {
        root.usageCounts = {};
      }
    }
    onLoadFailed: {
      root.usageCounts = {};
      if (cacheDir) {
        Quickshell.execDetached(["sh", "-c", `mkdir -p "${cacheDir}" && echo '{}' > "${usageFilePath}"`]);
      }
    }
  }
}
