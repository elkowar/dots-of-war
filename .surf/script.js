

// ==UserScript==
// @name vimkeybindings
// @namespace renevier.fdn.fr
// @author arno <arenevier@fdn.fr>
// @licence GPL/LGPL/MPL
// @description use vim keybingings (i, j, k, l, …) to navigate a web page.
// ==/UserScript==

/*
* If you're a vim addict, and you always find yourself typing j or k in a web
* page, then wondering why it just does not go up and down like any good
* software, that user script is what you have been looking for.
*/

function up() {
    if (window.scrollByLines)
	window.scrollByLines(-1); // gecko
    else
	window.scrollBy(0, -12); // webkit
}

function down() {
    if (window.scrollByLines)
	window.scrollByLines(1); // gecko
    else
	window.scrollBy(0, 12); // webkit
}

function pageup() {
    if (window.scrollByPages)
	window.scrollByPages(-1); // gecko
    else
	window.scrollBy(0, 0 - _pageScroll()); // webkit
}

function pagedown() {
    if (window.scrollByPages)
	window.scrollByPages(1); // gecko
    else
	window.scrollBy(0, _pageScroll()); // webkit
}

function right() {
    window.scrollBy(15, 0);
}

function left() {
    window.scrollBy(-15, 0);
}

function home() {
    window.scroll(0, 0);
}

function bottom() {
    window.scroll(document.width, document.height);
}

// If you don't like default key bindings, customize here.
// if you want to use the combination 'Ctrl + b' (for example), use '^b'
var bindings = {
    'h' : left,
    'l' : right,
    'k' : up,
    'j' : down,
    'g' : home,
    'G' : bottom,
    //'^b': pageup,
    //'^f': pagedown,
}

function isEditable(element) {

    if (element.nodeName.toLowerCase() == "textarea")
	return true;

    // we don't get keypress events for text input, but I don't known
    // if it's a bug, so let's test that
    if (element.nodeName.toLowerCase() == "input" && element.type == "text")
	return true;

    // element is editable
    if (document.designMode == "on" || element.contentEditable == "true") {
	return true;
    }

    return false;
}

function keypress(evt) {
    var target = evt.target;

    // if we're on a editable element, we probably don't want to catch
    // keypress, we just want to write the typed character.
    if (isEditable(target))
	return;

    var key = String.fromCharCode(evt.charCode);
    if (evt.ctrlKey) {
	key = '^' + key;
    }

    var fun = bindings[key];
    if (fun)
	fun();

}

function _pageScroll() {
    // Gecko algorithm
    // ----------------
    // The page increment is the size of the page, minus the smaller of
    // 10% of the size or 2 lines.
    return window.innerHeight - Math.min(window.innerHeight / 10, 24);
}

window.addEventListener("keypress", keypress, false);

