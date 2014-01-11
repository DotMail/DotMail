/*************************************Closure************************************************************/

var COMPILED = !0,
	goog = goog || {};
goog.global = this;
goog.DEBUG = !0;
goog.LOCALE = "en";
goog.evalWorksForGlobals_ = null;
goog.provide = function (a) {
	if (!COMPILED) {
		if (goog.getObjectByName(a) && !goog.implicitNamespaces_[a]) throw Error('Namespace "' + a + '" already declared.');
		for (var b = a; b = b.substring(0, b.lastIndexOf("."));) goog.implicitNamespaces_[b] = !0
	}
	goog.exportPath_(a)
};
goog.setTestOnly = function (a) {
	if (COMPILED && !goog.DEBUG) throw a = a || "", Error("Importing test-only code into non-debug environment" + a ? ": " + a : ".");
};
COMPILED || (goog.implicitNamespaces_ = {});
goog.exportPath_ = function (a, b, c) {
	a = a.split(".");
	c = c || goog.global;
	!(a[0] in c) && c.execScript && c.execScript("var " + a[0]);
	for (var d; a.length && (d = a.shift());)!a.length && goog.isDef(b) ? c[d] = b : c = c[d] ? c[d] : c[d] = {}
};
goog.getObjectByName = function (a, b) {
	for (var c = a.split("."), d = b || goog.global, e; e = c.shift();)
		if (goog.isDefAndNotNull(d[e])) d = d[e];
		else return null;
	return d
};
goog.globalize = function (a, b) {
	var c = b || goog.global,
		d;
	for (d in a) c[d] = a[d]
};
goog.addDependency = function (a, b, c) {
	if (!COMPILED) {
		for (var d, a = a.replace(/\\/g, "/"), e = goog.dependencies_, f = 0; d = b[f]; f++) {
			e.nameToPath[d] = a;
			a in e.pathToNames || (e.pathToNames[a] = {});
			e.pathToNames[a][d] = true
		}
		for (d = 0; b = c[d]; d++) {
			a in e.requires || (e.requires[a] = {});
			e.requires[a][b] = true
		}
	}
};
goog.require = function (a) {
	if (!COMPILED && !goog.getObjectByName(a)) {
		var b = goog.getPathFromDeps_(a);
		if (b) {
			goog.included_[b] = true;
			goog.writeScripts_()
		} else {
			a = "goog.require could not find: " + a;
			goog.global.console && goog.global.console.error(a);
			throw Error(a);
		}
	}
};
goog.basePath = "";
goog.nullFunction = function () {};
goog.identityFunction = function (a) {
	return a
};
goog.abstractMethod = function () {
	throw Error("unimplemented abstract method");
};
goog.addSingletonGetter = function (a) {
	a.getInstance = function () {
		return a.instance_ || (a.instance_ = new a)
	}
};
COMPILED || (goog.included_ = {}, goog.dependencies_ = {
	pathToNames: {},
	nameToPath: {},
	requires: {},
	visited: {},
	written: {}
}, goog.inHtmlDocument_ = function () {
	var a = goog.global.document;
	return typeof a != "undefined" && "write" in a
}, goog.findBasePath_ = function () {
	if (goog.global.CLOSURE_BASE_PATH) goog.basePath = goog.global.CLOSURE_BASE_PATH;
	else if (goog.inHtmlDocument_())
		for (var a = goog.global.document.getElementsByTagName("script"), b = a.length - 1; b >= 0; --b) {
			var c = a[b].src,
				d = c.lastIndexOf("?"),
				d = d == -1 ? c.length : d;
			if (c.substr(d -
				7, 7) == "base.js") {
				goog.basePath = c.substr(0, d - 7);
				break
			}
		}
}, goog.importScript_ = function (a) {
	var b = goog.global.CLOSURE_IMPORT_SCRIPT || goog.writeScriptTag_;
	!goog.dependencies_.written[a] && b(a) && (goog.dependencies_.written[a] = true)
}, goog.writeScriptTag_ = function (a) {
	if (goog.inHtmlDocument_()) {
		goog.global.document.write('<script type="text/javascript" src="' + a + '"><\/script>');
		return true
	}
	return false
}, goog.writeScripts_ = function () {
	function a(e) {
		if (!(e in d.written)) {
			if (!(e in d.visited)) {
				d.visited[e] = true;
				if (e in d.requires)
					for (var g in d.requires[e])
						if (g in d.nameToPath) a(d.nameToPath[g]);
						else if (!goog.getObjectByName(g)) throw Error("Undefined nameToPath for " + g);
			}
			if (!(e in c)) {
				c[e] = true;
				b.push(e)
			}
		}
	}
	var b = [],
		c = {}, d = goog.dependencies_,
		e;
	for (e in goog.included_) d.written[e] || a(e);
	for (e = 0; e < b.length; e++)
		if (b[e]) goog.importScript_(goog.basePath + b[e]);
		else throw Error("Undefined script input");
}, goog.getPathFromDeps_ = function (a) {
	return a in goog.dependencies_.nameToPath ? goog.dependencies_.nameToPath[a] :
		null
}, goog.findBasePath_(), goog.global.CLOSURE_NO_DEPS || goog.importScript_(goog.basePath + "deps.js"));
goog.typeOf = function (a) {
	var b = typeof a;
	if (b == "object")
		if (a) {
			if (a instanceof Array || !(a instanceof Object) && Object.prototype.toString.call(a) == "[object Array]" || typeof a.length == "number" && typeof a.splice != "undefined" && typeof a.propertyIsEnumerable != "undefined" && !a.propertyIsEnumerable("splice")) return "array";
			if (!(a instanceof Object) && (Object.prototype.toString.call(a) == "[object Function]" || typeof a.call != "undefined" && typeof a.propertyIsEnumerable != "undefined" && !a.propertyIsEnumerable("call"))) return "function"
		} else return "null";
		else if (b == "function" && typeof a.call == "undefined") return "object";
	return b
};
goog.propertyIsEnumerableCustom_ = function (a, b) {
	if (b in a)
		for (var c in a)
			if (c == b && Object.prototype.hasOwnProperty.call(a, b)) return true;
	return false
};
goog.propertyIsEnumerable_ = function (a, b) {
	return a instanceof Object ? Object.prototype.propertyIsEnumerable.call(a, b) : goog.propertyIsEnumerableCustom_(a, b)
};
goog.isDef = function (a) {
	return a !== void 0
};
goog.isNull = function (a) {
	return a === null
};
goog.isDefAndNotNull = function (a) {
	return a != null
};
goog.isArray = function (a) {
	return goog.typeOf(a) == "array"
};
goog.isArrayLike = function (a) {
	var b = goog.typeOf(a);
	return b == "array" || b == "object" && typeof a.length == "number"
};
goog.isDateLike = function (a) {
	return goog.isObject(a) && typeof a.getFullYear == "function"
};
goog.isString = function (a) {
	return typeof a == "string"
};
goog.isBoolean = function (a) {
	return typeof a == "boolean"
};
goog.isNumber = function (a) {
	return typeof a == "number"
};
goog.isFunction = function (a) {
	return goog.typeOf(a) == "function"
};
goog.isObject = function (a) {
	a = goog.typeOf(a);
	return a == "object" || a == "array" || a == "function"
};
goog.getUid = function (a) {
	return a[goog.UID_PROPERTY_] || (a[goog.UID_PROPERTY_] = ++goog.uidCounter_)
};
goog.removeUid = function (a) {
	"removeAttribute" in a && a.removeAttribute(goog.UID_PROPERTY_);
	try {
		delete a[goog.UID_PROPERTY_]
	} catch (b) {}
};
goog.UID_PROPERTY_ = "closure_uid_" + Math.floor(2147483648 * Math.random()).toString(36);
goog.uidCounter_ = 0;
goog.getHashCode = goog.getUid;
goog.removeHashCode = goog.removeUid;
goog.cloneObject = function (a) {
	var b = goog.typeOf(a);
	if (b == "object" || b == "array") {
		if (a.clone) return a.clone();
		var b = b == "array" ? [] : {}, c;
		for (c in a) b[c] = goog.cloneObject(a[c]);
		return b
	}
	return a
};
goog.bindNative_ = function (a, b, c) {
	return a.call.apply(a.bind, arguments)
};
goog.bindJs_ = function (a, b, c) {
	var d = b || goog.global;
	if (arguments.length > 2) {
		var e = Array.prototype.slice.call(arguments, 2);
		return function () {
			var b = Array.prototype.slice.call(arguments);
			Array.prototype.unshift.apply(b, e);
			return a.apply(d, b)
		}
	}
	return function () {
		return a.apply(d, arguments)
	}
};
goog.bind = function (a, b, c) {
	goog.bind = Function.prototype.bind && Function.prototype.bind.toString().indexOf("native code") != -1 ? goog.bindNative_ : goog.bindJs_;
	return goog.bind.apply(null, arguments)
};
goog.partial = function (a, b) {
	var c = Array.prototype.slice.call(arguments, 1);
	return function () {
		var b = Array.prototype.slice.call(arguments);
		b.unshift.apply(b, c);
		return a.apply(this, b)
	}
};
goog.mixin = function (a, b) {
	for (var c in b) a[c] = b[c]
};
goog.now = Date.now || function () {
	return +new Date
};
goog.globalEval = function (a) {
	if (goog.global.execScript) goog.global.execScript(a, "JavaScript");
	else if (goog.global.eval) {
		if (goog.evalWorksForGlobals_ == null) {
			goog.global.eval("var _et_ = 1;");
			if (typeof goog.global._et_ != "undefined") {
				delete goog.global._et_;
				goog.evalWorksForGlobals_ = true
			} else goog.evalWorksForGlobals_ = false
		}
		if (goog.evalWorksForGlobals_) goog.global.eval(a);
		else {
			var b = goog.global.document,
				c = b.createElement("script");
			c.type = "text/javascript";
			c.defer = false;
			c.appendChild(b.createTextNode(a));
			b.body.appendChild(c);
			b.body.removeChild(c)
		}
	} else throw Error("goog.globalEval not available");
};
goog.typedef = !0;
goog.getCssName = function (a, b) {
	var c = a + (b ? "-" + b : "");
	return goog.cssNameMapping_ && c in goog.cssNameMapping_ ? goog.cssNameMapping_[c] : c
};
goog.setCssNameMapping = function (a) {
	goog.cssNameMapping_ = a
};
goog.getMsg = function (a, b) {
	var c = b || {}, d;
	for (d in c) var e = ("" + c[d]).replace(/\$/g, "$$$$"),
	a = a.replace(RegExp("\\{\\$" + d + "\\}", "gi"), e);
	return a
};
goog.exportSymbol = function (a, b, c) {
	goog.exportPath_(a, b, c)
};
goog.exportProperty = function (a, b, c) {
	a[b] = c
};
goog.inherits = function (a, b) {
	function c() {}
	c.prototype = b.prototype;
	a.superClass_ = b.prototype;
	a.prototype = new c;
	a.prototype.constructor = a
};
goog.base = function (a, b, c) {
	var d = arguments.callee.caller;
	if (d.superClass_) return d.superClass_.constructor.apply(a, Array.prototype.slice.call(arguments, 1));
	for (var e = Array.prototype.slice.call(arguments, 2), f = false, g = a.constructor; g; g = g.superClass_ && g.superClass_.constructor)
		if (g.prototype[b] === d) f = true;
		else if (f) return g.prototype[b].apply(a, e);
	if (a[b] === d) return a.constructor.prototype[b].apply(a, e);
	throw Error("goog.base called from a method of one name to a method of a different name");
};
goog.scope = function (a) {
	a.call(goog.global)
};

goog.string = {};
goog.string.Unicode = {
	NBSP: "\u00a0"
};
goog.string.startsWith = function (a, b) {
	return 0 == a.lastIndexOf(b, 0)
};
goog.string.endsWith = function (a, b) {
	var c = a.length - b.length;
	return 0 <= c && a.indexOf(b, c) == c
};
goog.string.caseInsensitiveStartsWith = function (a, b) {
	return 0 == goog.string.caseInsensitiveCompare(b, a.substr(0, b.length))
};
goog.string.caseInsensitiveEndsWith = function (a, b) {
	return 0 == goog.string.caseInsensitiveCompare(b, a.substr(a.length - b.length, b.length))
};
goog.string.subs = function (a, b) {
	for (var c = 1; c < arguments.length; c++) var d = ("" + arguments[c]).replace(/\$/g, "$$$$"),
	a = a.replace(/\%s/, d);
	return a
};
goog.string.collapseWhitespace = function (a) {
	return a.replace(/[\s\xa0]+/g, " ").replace(/^\s+|\s+$/g, "")
};
goog.string.isEmpty = function (a) {
	return /^[\s\xa0]*$/.test(a)
};
goog.string.isEmptySafe = function (a) {
	return goog.string.isEmpty(goog.string.makeSafe(a))
};
goog.string.isBreakingWhitespace = function (a) {
	return !/[^\t\n\r ]/.test(a)
};
goog.string.isAlpha = function (a) {
	return !/[^a-zA-Z]/.test(a)
};
goog.string.isNumeric = function (a) {
	return !/[^0-9]/.test(a)
};
goog.string.isAlphaNumeric = function (a) {
	return !/[^a-zA-Z0-9]/.test(a)
};
goog.string.isSpace = function (a) {
	return " " == a
};
goog.string.isUnicodeChar = function (a) {
	return 1 == a.length && " " <= a && "~" >= a || "\u0080" <= a && "\ufffd" >= a
};
goog.string.stripNewlines = function (a) {
	return a.replace(/(\r\n|\r|\n)+/g, " ")
};
goog.string.canonicalizeNewlines = function (a) {
	return a.replace(/(\r\n|\r|\n)/g, "\n")
};
goog.string.normalizeWhitespace = function (a) {
	return a.replace(/\xa0|\s/g, " ")
};
goog.string.normalizeSpaces = function (a) {
	return a.replace(/\xa0|[ \t]+/g, " ")
};
goog.string.trim = function (a) {
	return a.replace(/^[\s\xa0]+|[\s\xa0]+$/g, "")
};
goog.string.trimLeft = function (a) {
	return a.replace(/^[\s\xa0]+/, "")
};
goog.string.trimRight = function (a) {
	return a.replace(/[\s\xa0]+$/, "")
};
goog.string.caseInsensitiveCompare = function (a, b) {
	var c = ("" + a).toLowerCase(),
		d = ("" + b).toLowerCase();
	return c < d ? -1 : c == d ? 0 : 1
};
goog.string.numerateCompareRegExp_ = /(\.\d+)|(\d+)|(\D+)/g;
goog.string.numerateCompare = function (a, b) {
	if (a == b) return 0;
	if (!a) return -1;
	if (!b) return 1;
	for (var c = a.toLowerCase().match(goog.string.numerateCompareRegExp_), d = b.toLowerCase().match(goog.string.numerateCompareRegExp_), e = Math.min(c.length, d.length), f = 0; f < e; f++) {
		var g = c[f],
			h = d[f];
		if (g != h) return c = parseInt(g, 10), !isNaN(c) && (d = parseInt(h, 10), !isNaN(d) && c - d) ? c - d : g < h ? -1 : 1
	}
	return c.length != d.length ? c.length - d.length : a < b ? -1 : 1
};
goog.string.encodeUriRegExp_ = /^[a-zA-Z0-9\-_.!~*'()]*$/;
goog.string.urlEncode = function (a) {
	a = "" + a;
	return !goog.string.encodeUriRegExp_.test(a) ? encodeURIComponent(a) : a
};
goog.string.urlDecode = function (a) {
	return decodeURIComponent(a.replace(/\+/g, " "))
};
goog.string.newLineToBr = function (a, b) {
	return a.replace(/(\r\n|\r|\n)/g, b ? "<br />" : "<br>")
};
goog.string.htmlEscape = function (a, b) {
	if (b) return a.replace(goog.string.amperRe_, "&amp;").replace(goog.string.ltRe_, "&lt;").replace(goog.string.gtRe_, "&gt;").replace(goog.string.quotRe_, "&quot;");
	if (!goog.string.allRe_.test(a)) return a; - 1 != a.indexOf("&") && (a = a.replace(goog.string.amperRe_, "&amp;")); - 1 != a.indexOf("<") && (a = a.replace(goog.string.ltRe_, "&lt;")); - 1 != a.indexOf(">") && (a = a.replace(goog.string.gtRe_, "&gt;")); - 1 != a.indexOf('"') && (a = a.replace(goog.string.quotRe_, "&quot;"));
	return a
};
goog.string.amperRe_ = /&/g;
goog.string.ltRe_ = /</g;
goog.string.gtRe_ = />/g;
goog.string.quotRe_ = /\"/g;
goog.string.allRe_ = /[&<>\"]/;
goog.string.unescapeEntities = function (a) {
	return goog.string.contains(a, "&") ? "document" in goog.global && !goog.string.contains(a, "<") ? goog.string.unescapeEntitiesUsingDom_(a) : goog.string.unescapePureXmlEntities_(a) : a
};
goog.string.unescapeEntitiesUsingDom_ = function (a) {
	var b = goog.global.document.createElement("div");
	b.innerHTML = "<pre>x" + a + "</pre>";
	if (b.firstChild[goog.string.NORMALIZE_FN_]) b.firstChild[goog.string.NORMALIZE_FN_]();
	a = b.firstChild.firstChild.nodeValue.slice(1);
	b.innerHTML = "";
	return goog.string.canonicalizeNewlines(a)
};
goog.string.unescapePureXmlEntities_ = function (a) {
	return a.replace(/&([^;]+);/g, function (a, c) {
		switch (c) {
		case "amp":
			return "&";
		case "lt":
			return "<";
		case "gt":
			return ">";
		case "quot":
			return '"';
		default:
			if ("#" == c.charAt(0)) {
				var d = Number("0" + c.substr(1));
				if (!isNaN(d)) return String.fromCharCode(d)
			}
			return a
		}
	})
};
goog.string.NORMALIZE_FN_ = "normalize";
goog.string.whitespaceEscape = function (a, b) {
	return goog.string.newLineToBr(a.replace(/  /g, " &#160;"), b)
};
goog.string.stripQuotes = function (a, b) {
	for (var c = b.length, d = 0; d < c; d++) {
		var e = 1 == c ? b : b.charAt(d);
		if (a.charAt(0) == e && a.charAt(a.length - 1) == e) return a.substring(1, a.length - 1)
	}
	return a
};
goog.string.truncate = function (a, b, c) {
	c && (a = goog.string.unescapeEntities(a));
	a.length > b && (a = a.substring(0, b - 3) + "...");
	c && (a = goog.string.htmlEscape(a));
	return a
};
goog.string.truncateMiddle = function (a, b, c) {
	c && (a = goog.string.unescapeEntities(a));
	if (a.length > b) var d = Math.floor(b / 2),
	e = a.length - d, a = a.substring(0, d + b % 2) + "..." + a.substring(e);
	c && (a = goog.string.htmlEscape(a));
	return a
};
goog.string.specialEscapeChars_ = {
	"\x00": "\\0",
	"\u0008": "\\b",
	"\u000c": "\\f",
	"\n": "\\n",
	"\r": "\\r",
	"\t": "\\t",
	"\x0B": "\\x0B",
	'"': '\\"',
	"\\": "\\\\"
};
goog.string.jsEscapeCache_ = {
	"'": "\\'"
};
goog.string.quote = function (a) {
	a = "" + a;
	if (a.quote) return a.quote();
	for (var b = ['"'], c = 0; c < a.length; c++) {
		var d = a.charAt(c),
			e = d.charCodeAt(0);
		b[c + 1] = goog.string.specialEscapeChars_[d] || (31 < e && 127 > e ? d : goog.string.escapeChar(d))
	}
	b.push('"');
	return b.join("")
};
goog.string.escapeString = function (a) {
	for (var b = [], c = 0; c < a.length; c++) b[c] = goog.string.escapeChar(a.charAt(c));
	return b.join("")
};
goog.string.escapeChar = function (a) {
	if (a in goog.string.jsEscapeCache_) return goog.string.jsEscapeCache_[a];
	if (a in goog.string.specialEscapeChars_) return goog.string.jsEscapeCache_[a] = goog.string.specialEscapeChars_[a];
	var b = a,
		c = a.charCodeAt(0);
	if (31 < c && 127 > c) b = a;
	else {
		if (256 > c) {
			if (b = "\\x", 16 > c || 256 < c) b += "0"
		} else b = "\\u", 4096 > c && (b += "0");
		b += c.toString(16).toUpperCase()
	}
	return goog.string.jsEscapeCache_[a] = b
};
goog.string.toMap = function (a) {
	for (var b = {}, c = 0; c < a.length; c++) b[a.charAt(c)] = !0;
	return b
};
goog.string.contains = function (a, b) {
	return -1 != a.indexOf(b)
};
goog.string.removeAt = function (a, b, c) {
	var d = a;
	0 <= b && (b < a.length && 0 < c) && (d = a.substr(0, b) + a.substr(b + c, a.length - b - c));
	return d
};
goog.string.remove = function (a, b) {
	var c = RegExp(goog.string.regExpEscape(b), "");
	return a.replace(c, "")
};
goog.string.removeAll = function (a, b) {
	var c = RegExp(goog.string.regExpEscape(b), "g");
	return a.replace(c, "")
};
goog.string.regExpEscape = function (a) {
	return ("" + a).replace(/([-()\[\]{}+?*.$\^|,:#<!\\])/g, "\\$1").replace(/\x08/g, "\\x08")
};
goog.string.repeat = function (a, b) {
	return Array(b + 1).join(a)
};
goog.string.padNumber = function (a, b, c) {
	a = goog.isDef(c) ? a.toFixed(c) : "" + a;
	c = a.indexOf("."); - 1 == c && (c = a.length);
	return goog.string.repeat("0", Math.max(0, b - c)) + a
};
goog.string.makeSafe = function (a) {
	return null == a ? "" : "" + a
};
goog.string.buildString = function (a) {
	return Array.prototype.join.call(arguments, "")
};
goog.string.getRandomString = function () {
	return Math.floor(2147483648 * Math.random()).toString(36) + (Math.floor(2147483648 * Math.random()) ^ goog.now()).toString(36)
};
goog.string.compareVersions = function (a, b) {
	for (var c = 0, d = goog.string.trim("" + a).split("."), e = goog.string.trim("" + b).split("."), f = Math.max(d.length, e.length), g = 0; 0 == c && g < f; g++) {
		var h = d[g] || "",
			j = e[g] || "",
			k = RegExp("(\\d*)(\\D*)", "g"),
			l = RegExp("(\\d*)(\\D*)", "g");
		do {
			var n = k.exec(h) || ["", "", ""],
				m = l.exec(j) || ["", "", ""];
			if (0 == n[0].length && 0 == m[0].length) break;
			var c = 0 == n[1].length ? 0 : parseInt(n[1], 10),
				p = 0 == m[1].length ? 0 : parseInt(m[1], 10),
				c = goog.string.compareElements_(c, p) || goog.string.compareElements_(0 ==
					n[2].length, 0 == m[2].length) || goog.string.compareElements_(n[2], m[2])
		} while (0 == c)
	}
	return c
};
goog.string.compareElements_ = function (a, b) {
	return a < b ? -1 : a > b ? 1 : 0
};
goog.string.HASHCODE_MAX_ = 4294967296;
goog.string.hashCode = function (a) {
	for (var b = 0, c = 0; c < a.length; ++c) b = 31 * b + a.charCodeAt(c), b %= goog.string.HASHCODE_MAX_;
	return b
};
goog.string.uniqueStringCounter_ = 2147483648 * Math.random() | 0;
goog.string.createUniqueString = function () {
	return "goog_" + goog.string.uniqueStringCounter_++
};
goog.string.toNumber = function (a) {
	var b = Number(a);
	return 0 == b && goog.string.isEmpty(a) ? NaN : b
};
goog.userAgent = {};
goog.userAgent.ASSUME_IE = !1;
goog.userAgent.ASSUME_GECKO = !1;
goog.userAgent.ASSUME_WEBKIT = !1;
goog.userAgent.ASSUME_MOBILE_WEBKIT = !1;
goog.userAgent.ASSUME_OPERA = !1;
goog.userAgent.BROWSER_KNOWN_ = goog.userAgent.ASSUME_IE || goog.userAgent.ASSUME_GECKO || goog.userAgent.ASSUME_MOBILE_WEBKIT || goog.userAgent.ASSUME_WEBKIT || goog.userAgent.ASSUME_OPERA;
goog.userAgent.getUserAgentString = function () {
	return goog.global.navigator ? goog.global.navigator.userAgent : null
};
goog.userAgent.getNavigator = function () {
	return goog.global.navigator
};
goog.userAgent.init_ = function () {
	goog.userAgent.detectedOpera_ = !1;
	goog.userAgent.detectedIe_ = !1;
	goog.userAgent.detectedWebkit_ = !1;
	goog.userAgent.detectedMobile_ = !1;
	goog.userAgent.detectedGecko_ = !1;
	var a;
	if (!goog.userAgent.BROWSER_KNOWN_ && (a = goog.userAgent.getUserAgentString())) {
		var b = goog.userAgent.getNavigator();
		goog.userAgent.detectedOpera_ = 0 == a.indexOf("Opera");
		goog.userAgent.detectedIe_ = !goog.userAgent.detectedOpera_ && -1 != a.indexOf("MSIE");
		goog.userAgent.detectedWebkit_ = !goog.userAgent.detectedOpera_ && -1 != a.indexOf("WebKit");
		goog.userAgent.detectedMobile_ = goog.userAgent.detectedWebkit_ && -1 != a.indexOf("Mobile");
		goog.userAgent.detectedGecko_ = !goog.userAgent.detectedOpera_ && !goog.userAgent.detectedWebkit_ && "Gecko" == b.product
	}
};
goog.userAgent.BROWSER_KNOWN_ || goog.userAgent.init_();
goog.userAgent.OPERA = goog.userAgent.BROWSER_KNOWN_ ? goog.userAgent.ASSUME_OPERA : goog.userAgent.detectedOpera_;
goog.userAgent.IE = goog.userAgent.BROWSER_KNOWN_ ? goog.userAgent.ASSUME_IE : goog.userAgent.detectedIe_;
goog.userAgent.GECKO = goog.userAgent.BROWSER_KNOWN_ ? goog.userAgent.ASSUME_GECKO : goog.userAgent.detectedGecko_;
goog.userAgent.WEBKIT = goog.userAgent.BROWSER_KNOWN_ ? goog.userAgent.ASSUME_WEBKIT || goog.userAgent.ASSUME_MOBILE_WEBKIT : goog.userAgent.detectedWebkit_;
goog.userAgent.MOBILE = goog.userAgent.ASSUME_MOBILE_WEBKIT || goog.userAgent.detectedMobile_;
goog.userAgent.SAFARI = goog.userAgent.WEBKIT;
goog.userAgent.determinePlatform_ = function () {
	var a = goog.userAgent.getNavigator();
	return a && a.platform || ""
};
goog.userAgent.PLATFORM = goog.userAgent.determinePlatform_();
goog.userAgent.ASSUME_MAC = !1;
goog.userAgent.ASSUME_WINDOWS = !1;
goog.userAgent.ASSUME_LINUX = !1;
goog.userAgent.ASSUME_X11 = !1;
goog.userAgent.PLATFORM_KNOWN_ = goog.userAgent.ASSUME_MAC || goog.userAgent.ASSUME_WINDOWS || goog.userAgent.ASSUME_LINUX || goog.userAgent.ASSUME_X11;
goog.userAgent.initPlatform_ = function () {
	goog.userAgent.detectedMac_ = goog.string.contains(goog.userAgent.PLATFORM, "Mac");
	goog.userAgent.detectedWindows_ = goog.string.contains(goog.userAgent.PLATFORM, "Win");
	goog.userAgent.detectedLinux_ = goog.string.contains(goog.userAgent.PLATFORM, "Linux");
	goog.userAgent.detectedX11_ = !! goog.userAgent.getNavigator() && goog.string.contains(goog.userAgent.getNavigator().appVersion || "", "X11")
};
goog.userAgent.PLATFORM_KNOWN_ || goog.userAgent.initPlatform_();
goog.userAgent.MAC = goog.userAgent.PLATFORM_KNOWN_ ? goog.userAgent.ASSUME_MAC : goog.userAgent.detectedMac_;
goog.userAgent.WINDOWS = goog.userAgent.PLATFORM_KNOWN_ ? goog.userAgent.ASSUME_WINDOWS : goog.userAgent.detectedWindows_;
goog.userAgent.LINUX = goog.userAgent.PLATFORM_KNOWN_ ? goog.userAgent.ASSUME_LINUX : goog.userAgent.detectedLinux_;
goog.userAgent.X11 = goog.userAgent.PLATFORM_KNOWN_ ? goog.userAgent.ASSUME_X11 : goog.userAgent.detectedX11_;
goog.userAgent.determineVersion_ = function () {
	var a = "",
		b;
	goog.userAgent.OPERA && goog.global.opera ? (a = goog.global.opera.version, a = "function" == typeof a ? a() : a) : (goog.userAgent.GECKO ? b = /rv\:([^\);]+)(\)|;)/ : goog.userAgent.IE ? b = /MSIE\s+([^\);]+)(\)|;)/ : goog.userAgent.WEBKIT && (b = /WebKit\/(\S+)/), b && (a = (a = b.exec(goog.userAgent.getUserAgentString())) ? a[1] : ""));
	return goog.userAgent.IE && (b = goog.userAgent.getDocumentMode_(), b > parseFloat(a)) ? "" + b : a
};
goog.userAgent.getDocumentMode_ = function () {
	var a = goog.global.document;
	return a ? a.documentMode : void 0
};
goog.userAgent.VERSION = goog.userAgent.determineVersion_();
goog.userAgent.compare = function (a, b) {
	return goog.string.compareVersions(a, b)
};
goog.userAgent.isVersionCache_ = {};
goog.userAgent.isVersion = function (a) {
	return goog.userAgent.isVersionCache_[a] || (goog.userAgent.isVersionCache_[a] = 0 <= goog.string.compareVersions(goog.userAgent.VERSION, a))
};
goog.object = {};
goog.object.forEach = function (a, b, c) {
	for (var d in a) b.call(c, a[d], d, a)
};
goog.object.filter = function (a, b, c) {
	var d = {}, e;
	for (e in a) b.call(c, a[e], e, a) && (d[e] = a[e]);
	return d
};
goog.object.map = function (a, b, c) {
	var d = {}, e;
	for (e in a) d[e] = b.call(c, a[e], e, a);
	return d
};
goog.object.some = function (a, b, c) {
	for (var d in a)
		if (b.call(c, a[d], d, a)) return !0;
	return !1
};
goog.object.every = function (a, b, c) {
	for (var d in a)
		if (!b.call(c, a[d], d, a)) return !1;
	return !0
};
goog.object.getCount = function (a) {
	var b = 0,
		c;
	for (c in a) b++;
	return b
};
goog.object.getAnyKey = function (a) {
	for (var b in a) return b
};
goog.object.getAnyValue = function (a) {
	for (var b in a) return a[b]
};
goog.object.contains = function (a, b) {
	return goog.object.containsValue(a, b)
};
goog.object.getValues = function (a) {
	var b = [],
		c = 0,
		d;
	for (d in a) b[c++] = a[d];
	return b
};
goog.object.getKeys = function (a) {
	var b = [],
		c = 0,
		d;
	for (d in a) b[c++] = d;
	return b
};
goog.object.containsKey = function (a, b) {
	return b in a
};
goog.object.containsValue = function (a, b) {
	for (var c in a)
		if (a[c] == b) return !0;
	return !1
};
goog.object.findKey = function (a, b, c) {
	for (var d in a)
		if (b.call(c, a[d], d, a)) return d
};
goog.object.findValue = function (a, b, c) {
	return (b = goog.object.findKey(a, b, c)) && a[b]
};
goog.object.isEmpty = function (a) {
	for (var b in a) return !1;
	return !0
};
goog.object.clear = function (a) {
	for (var b = goog.object.getKeys(a), c = b.length - 1; 0 <= c; c--) goog.object.remove(a, b[c])
};
goog.object.remove = function (a, b) {
	var c;
	(c = b in a) && delete a[b];
	return c
};
goog.object.add = function (a, b, c) {
	if (b in a) throw Error('The object already contains the key "' + b + '"');
	goog.object.set(a, b, c)
};
goog.object.get = function (a, b, c) {
	return b in a ? a[b] : c
};
goog.object.set = function (a, b, c) {
	a[b] = c
};
goog.object.setIfUndefined = function (a, b, c) {
	return b in a ? a[b] : a[b] = c
};
goog.object.clone = function (a) {
	var b = {}, c;
	for (c in a) b[c] = a[c];
	return b
};
goog.object.transpose = function (a) {
	var b = {}, c;
	for (c in a) b[a[c]] = c;
	return b
};
goog.object.PROTOTYPE_FIELDS_ = "constructor hasOwnProperty isPrototypeOf propertyIsEnumerable toLocaleString toString valueOf".split(" ");
goog.object.extend = function (a, b) {
	for (var c, d, e = 1; e < arguments.length; e++) {
		d = arguments[e];
		for (c in d) a[c] = d[c];
		for (var f = 0; f < goog.object.PROTOTYPE_FIELDS_.length; f++) c = goog.object.PROTOTYPE_FIELDS_[f], Object.prototype.hasOwnProperty.call(d, c) && (a[c] = d[c])
	}
};
goog.object.create = function (a) {
	var b = arguments.length;
	if (1 == b && goog.isArray(arguments[0])) return goog.object.create.apply(null, arguments[0]);
	if (b % 2) throw Error("Uneven number of arguments");
	for (var c = {}, d = 0; d < b; d += 2) c[arguments[d]] = arguments[d + 1];
	return c
};
goog.object.createSet = function (a) {
	var b = arguments.length;
	if (1 == b && goog.isArray(arguments[0])) return goog.object.createSet.apply(null, arguments[0]);
	for (var c = {}, d = 0; d < b; d++) c[arguments[d]] = !0;
	return c
};
goog.math = {};
goog.math.Coordinate = function (a, b) {
	this.x = goog.isDef(a) ? a : 0;
	this.y = goog.isDef(b) ? b : 0
};
goog.math.Coordinate.prototype.clone = function () {
	return new goog.math.Coordinate(this.x, this.y)
};
goog.DEBUG && (goog.math.Coordinate.prototype.toString = function () {
	return "(" + this.x + ", " + this.y + ")"
});
goog.math.Coordinate.equals = function (a, b) {
	return a == b ? true : !a || !b ? false : a.x == b.x && a.y == b.y
};
goog.math.Coordinate.distance = function (a, b) {
	var c = a.x - b.x,
		d = a.y - b.y;
	return Math.sqrt(c * c + d * d)
};
goog.math.Coordinate.squaredDistance = function (a, b) {
	var c = a.x - b.x,
		d = a.y - b.y;
	return c * c + d * d
};
goog.math.Coordinate.difference = function (a, b) {
	return new goog.math.Coordinate(a.x - b.x, a.y - b.y)
};
goog.math.Coordinate.sum = function (a, b) {
	return new goog.math.Coordinate(a.x + b.x, a.y + b.y)
};
goog.math.Box = function (a, b, c, d) {
	this.top = a;
	this.right = b;
	this.bottom = c;
	this.left = d
};
goog.math.Box.boundingBox = function (a) {
	for (var b = new goog.math.Box(arguments[0].y, arguments[0].x, arguments[0].y, arguments[0].x), c = 1; c < arguments.length; c++) {
		var d = arguments[c];
		b.top = Math.min(b.top, d.y);
		b.right = Math.max(b.right, d.x);
		b.bottom = Math.max(b.bottom, d.y);
		b.left = Math.min(b.left, d.x)
	}
	return b
};
goog.math.Box.prototype.clone = function () {
	return new goog.math.Box(this.top, this.right, this.bottom, this.left)
};
goog.DEBUG && (goog.math.Box.prototype.toString = function () {
	return "(" + this.top + "t, " + this.right + "r, " + this.bottom + "b, " + this.left + "l)"
});
goog.math.Box.prototype.contains = function (a) {
	return goog.math.Box.contains(this, a)
};
goog.math.Box.prototype.expand = function (a, b, c, d) {
	if (goog.isObject(a)) {
		this.top = this.top - a.top;
		this.right = this.right + a.right;
		this.bottom = this.bottom + a.bottom;
		this.left = this.left - a.left
	} else {
		this.top = this.top - a;
		this.right = this.right + b;
		this.bottom = this.bottom + c;
		this.left = this.left - d
	}
	return this
};
goog.math.Box.prototype.expandToInclude = function (a) {
	this.left = Math.min(this.left, a.left);
	this.top = Math.min(this.top, a.top);
	this.right = Math.max(this.right, a.right);
	this.bottom = Math.max(this.bottom, a.bottom)
};
goog.math.Box.equals = function (a, b) {
	return a == b ? true : !a || !b ? false : a.top == b.top && a.right == b.right && a.bottom == b.bottom && a.left == b.left
};
goog.math.Box.contains = function (a, b) {
	return !a || !b ? false : b instanceof goog.math.Box ? b.left >= a.left && b.right <= a.right && b.top >= a.top && b.bottom <= a.bottom : b.x >= a.left && b.x <= a.right && b.y >= a.top && b.y <= a.bottom
};
goog.math.Box.distance = function (a, b) {
	return b.x >= a.left && b.x <= a.right ? b.y >= a.top && b.y <= a.bottom ? 0 : b.y < a.top ? a.top - b.y : b.y - a.bottom : b.y >= a.top && b.y <= a.bottom ? b.x < a.left ? a.left - b.x : b.x - a.right : goog.math.Coordinate.distance(b, new goog.math.Coordinate(b.x < a.left ? a.left : a.right, b.y < a.top ? a.top : a.bottom))
};
goog.math.Box.intersects = function (a, b) {
	return a.left <= b.right && b.left <= a.right && a.top <= b.bottom && b.top <= a.bottom
};
goog.debug = {};
goog.debug.Error = function (a) {
	this.stack = Error().stack || "";
	a && (this.message = "" + a)
};
goog.inherits(goog.debug.Error, Error);
goog.debug.Error.prototype.name = "CustomError";
goog.asserts = {};
goog.asserts.ENABLE_ASSERTS = goog.DEBUG;
goog.asserts.AssertionError = function (a, b) {
	b.unshift(a);
	goog.debug.Error.call(this, goog.string.subs.apply(null, b));
	b.shift();
	this.messagePattern = a
};
goog.inherits(goog.asserts.AssertionError, goog.debug.Error);
goog.asserts.AssertionError.prototype.name = "AssertionError";
goog.asserts.doAssertFailure_ = function (a, b, c, d) {
	var e = "Assertion failed";
	if (c) var e = e + (": " + c),
	f = d;
	else a && (e += ": " + a, f = b);
	throw new goog.asserts.AssertionError("" + e, f || []);
};
goog.asserts.assert = function (a, b, c) {
	goog.asserts.ENABLE_ASSERTS && !a && goog.asserts.doAssertFailure_("", null, b, Array.prototype.slice.call(arguments, 2));
	return a
};
goog.asserts.fail = function (a, b) {
	if (goog.asserts.ENABLE_ASSERTS) throw new goog.asserts.AssertionError("Failure" + (a ? ": " + a : ""), Array.prototype.slice.call(arguments, 1));
};
goog.asserts.assertNumber = function (a, b, c) {
	goog.asserts.ENABLE_ASSERTS && !goog.isNumber(a) && goog.asserts.doAssertFailure_("Expected number but got %s: %s.", [goog.typeOf(a), a], b, Array.prototype.slice.call(arguments, 2));
	return a
};
goog.asserts.assertString = function (a, b, c) {
	goog.asserts.ENABLE_ASSERTS && !goog.isString(a) && goog.asserts.doAssertFailure_("Expected string but got %s: %s.", [goog.typeOf(a), a], b, Array.prototype.slice.call(arguments, 2));
	return a
};
goog.asserts.assertFunction = function (a, b, c) {
	goog.asserts.ENABLE_ASSERTS && !goog.isFunction(a) && goog.asserts.doAssertFailure_("Expected function but got %s: %s.", [goog.typeOf(a), a], b, Array.prototype.slice.call(arguments, 2));
	return a
};
goog.asserts.assertObject = function (a, b, c) {
	goog.asserts.ENABLE_ASSERTS && !goog.isObject(a) && goog.asserts.doAssertFailure_("Expected object but got %s: %s.", [goog.typeOf(a), a], b, Array.prototype.slice.call(arguments, 2));
	return a
};
goog.asserts.assertArray = function (a, b, c) {
	goog.asserts.ENABLE_ASSERTS && !goog.isArray(a) && goog.asserts.doAssertFailure_("Expected array but got %s: %s.", [goog.typeOf(a), a], b, Array.prototype.slice.call(arguments, 2));
	return a
};
goog.asserts.assertBoolean = function (a, b, c) {
	goog.asserts.ENABLE_ASSERTS && !goog.isBoolean(a) && goog.asserts.doAssertFailure_("Expected boolean but got %s: %s.", [goog.typeOf(a), a], b, Array.prototype.slice.call(arguments, 2));
	return a
};
goog.asserts.assertInstanceof = function (a, b, c, d) {
	goog.asserts.ENABLE_ASSERTS && !(a instanceof b) && goog.asserts.doAssertFailure_("instanceof check failed.", null, c, Array.prototype.slice.call(arguments, 3))
};
goog.array = {};
goog.array.peek = function (a) {
	return a[a.length - 1]
};
goog.array.ARRAY_PROTOTYPE_ = Array.prototype;
goog.array.indexOf = goog.array.ARRAY_PROTOTYPE_.indexOf ? function (a, b, c) {
	goog.asserts.assert(null != a.length);
	return goog.array.ARRAY_PROTOTYPE_.indexOf.call(a, b, c)
} : function (a, b, c) {
	c = null == c ? 0 : 0 > c ? Math.max(0, a.length + c) : c;
	if (goog.isString(a)) return !goog.isString(b) || 1 != b.length ? -1 : a.indexOf(b, c);
	for (; c < a.length; c++)
		if (c in a && a[c] === b) return c;
	return -1
};
goog.array.lastIndexOf = goog.array.ARRAY_PROTOTYPE_.lastIndexOf ? function (a, b, c) {
	goog.asserts.assert(null != a.length);
	return goog.array.ARRAY_PROTOTYPE_.lastIndexOf.call(a, b, null == c ? a.length - 1 : c)
} : function (a, b, c) {
	c = null == c ? a.length - 1 : c;
	0 > c && (c = Math.max(0, a.length + c));
	if (goog.isString(a)) return !goog.isString(b) || 1 != b.length ? -1 : a.lastIndexOf(b, c);
	for (; 0 <= c; c--)
		if (c in a && a[c] === b) return c;
	return -1
};
goog.array.forEach = goog.array.ARRAY_PROTOTYPE_.forEach ? function (a, b, c) {
	goog.asserts.assert(null != a.length);
	goog.array.ARRAY_PROTOTYPE_.forEach.call(a, b, c)
} : function (a, b, c) {
	for (var d = a.length, e = goog.isString(a) ? a.split("") : a, f = 0; f < d; f++) f in e && b.call(c, e[f], f, a)
};
goog.array.forEachRight = function (a, b, c) {
	for (var d = a.length, e = goog.isString(a) ? a.split("") : a, d = d - 1; 0 <= d; --d) d in e && b.call(c, e[d], d, a)
};
goog.array.filter = goog.array.ARRAY_PROTOTYPE_.filter ? function (a, b, c) {
	goog.asserts.assert(null != a.length);
	return goog.array.ARRAY_PROTOTYPE_.filter.call(a, b, c)
} : function (a, b, c) {
	for (var d = a.length, e = [], f = 0, g = goog.isString(a) ? a.split("") : a, h = 0; h < d; h++)
		if (h in g) {
			var j = g[h];
			b.call(c, j, h, a) && (e[f++] = j)
		}
	return e
};
goog.array.map = goog.array.ARRAY_PROTOTYPE_.map ? function (a, b, c) {
	goog.asserts.assert(null != a.length);
	return goog.array.ARRAY_PROTOTYPE_.map.call(a, b, c)
} : function (a, b, c) {
	for (var d = a.length, e = Array(d), f = goog.isString(a) ? a.split("") : a, g = 0; g < d; g++) g in f && (e[g] = b.call(c, f[g], g, a));
	return e
};
goog.array.reduce = function (a, b, c, d) {
	if (a.reduce) return d ? a.reduce(goog.bind(b, d), c) : a.reduce(b, c);
	var e = c;
	goog.array.forEach(a, function (c, g) {
		e = b.call(d, e, c, g, a)
	});
	return e
};
goog.array.reduceRight = function (a, b, c, d) {
	if (a.reduceRight) return d ? a.reduceRight(goog.bind(b, d), c) : a.reduceRight(b, c);
	var e = c;
	goog.array.forEachRight(a, function (c, g) {
		e = b.call(d, e, c, g, a)
	});
	return e
};
goog.array.some = goog.array.ARRAY_PROTOTYPE_.some ? function (a, b, c) {
	goog.asserts.assert(null != a.length);
	return goog.array.ARRAY_PROTOTYPE_.some.call(a, b, c)
} : function (a, b, c) {
	for (var d = a.length, e = goog.isString(a) ? a.split("") : a, f = 0; f < d; f++)
		if (f in e && b.call(c, e[f], f, a)) return !0;
	return !1
};
goog.array.every = goog.array.ARRAY_PROTOTYPE_.every ? function (a, b, c) {
	goog.asserts.assert(null != a.length);
	return goog.array.ARRAY_PROTOTYPE_.every.call(a, b, c)
} : function (a, b, c) {
	for (var d = a.length, e = goog.isString(a) ? a.split("") : a, f = 0; f < d; f++)
		if (f in e && !b.call(c, e[f], f, a)) return !1;
	return !0
};
goog.array.find = function (a, b, c) {
	b = goog.array.findIndex(a, b, c);
	return 0 > b ? null : goog.isString(a) ? a.charAt(b) : a[b]
};
goog.array.findIndex = function (a, b, c) {
	for (var d = a.length, e = goog.isString(a) ? a.split("") : a, f = 0; f < d; f++)
		if (f in e && b.call(c, e[f], f, a)) return f;
	return -1
};
goog.array.findRight = function (a, b, c) {
	b = goog.array.findIndexRight(a, b, c);
	return 0 > b ? null : goog.isString(a) ? a.charAt(b) : a[b]
};
goog.array.findIndexRight = function (a, b, c) {
	for (var d = a.length, e = goog.isString(a) ? a.split("") : a, d = d - 1; 0 <= d; d--)
		if (d in e && b.call(c, e[d], d, a)) return d;
	return -1
};
goog.array.contains = function (a, b) {
	return 0 <= goog.array.indexOf(a, b)
};
goog.array.isEmpty = function (a) {
	return 0 == a.length
};
goog.array.clear = function (a) {
	if (!goog.isArray(a))
		for (var b = a.length - 1; 0 <= b; b--) delete a[b];
	a.length = 0
};
goog.array.insert = function (a, b) {
	goog.array.contains(a, b) || a.push(b)
};
goog.array.insertAt = function (a, b, c) {
	goog.array.splice(a, c, 0, b)
};
goog.array.insertArrayAt = function (a, b, c) {
	goog.partial(goog.array.splice, a, c, 0).apply(null, b)
};
goog.array.insertBefore = function (a, b, c) {
	var d;
	2 == arguments.length || 0 > (d = goog.array.indexOf(a, c)) ? a.push(b) : goog.array.insertAt(a, b, d)
};
goog.array.remove = function (a, b) {
	var c = goog.array.indexOf(a, b),
		d;
	(d = 0 <= c) && goog.array.removeAt(a, c);
	return d
};
goog.array.removeAt = function (a, b) {
	goog.asserts.assert(null != a.length);
	return 1 == goog.array.ARRAY_PROTOTYPE_.splice.call(a, b, 1).length
};
goog.array.removeIf = function (a, b, c) {
	b = goog.array.findIndex(a, b, c);
	return 0 <= b ? (goog.array.removeAt(a, b), !0) : !1
};
goog.array.concat = function (a) {
	return goog.array.ARRAY_PROTOTYPE_.concat.apply(goog.array.ARRAY_PROTOTYPE_, arguments)
};
goog.array.clone = function (a) {
	if (goog.isArray(a)) return goog.array.concat(a);
	for (var b = [], c = 0, d = a.length; c < d; c++) b[c] = a[c];
	return b
};
goog.array.toArray = function (a) {
	return goog.isArray(a) ? goog.array.concat(a) : goog.array.clone(a)
};
goog.array.extend = function (a, b) {
	for (var c = 1; c < arguments.length; c++) {
		var d = arguments[c],
			e;
		if (goog.isArray(d) || (e = goog.isArrayLike(d)) && d.hasOwnProperty("callee")) a.push.apply(a, d);
		else if (e)
			for (var f = a.length, g = d.length, h = 0; h < g; h++) a[f + h] = d[h];
		else a.push(d)
	}
};
goog.array.splice = function (a, b, c, d) {
	goog.asserts.assert(null != a.length);
	return goog.array.ARRAY_PROTOTYPE_.splice.apply(a, goog.array.slice(arguments, 1))
};
goog.array.slice = function (a, b, c) {
	goog.asserts.assert(null != a.length);
	return 2 >= arguments.length ? goog.array.ARRAY_PROTOTYPE_.slice.call(a, b) : goog.array.ARRAY_PROTOTYPE_.slice.call(a, b, c)
};
goog.array.removeDuplicates = function (a, b) {
	for (var c = b || a, d = {}, e = 0, f = 0; f < a.length;) {
		var g = a[f++],
			h = goog.isObject(g) ? goog.getUid(g) : g;
		Object.prototype.hasOwnProperty.call(d, h) || (d[h] = !0, c[e++] = g)
	}
	c.length = e
};
goog.array.binarySearch = function (a, b, c) {
	return goog.array.binarySearch_(a, c || goog.array.defaultCompare, !1, b)
};
goog.array.binarySelect = function (a, b, c) {
	return goog.array.binarySearch_(a, b, !0, void 0, c)
};
goog.array.binarySearch_ = function (a, b, c, d, e) {
	for (var f = 0, g = a.length, h; f < g;) {
		var j = f + g >> 1,
			k;
		k = c ? b.call(e, a[j], j, a) : b(d, a[j]);
		0 < k ? f = j + 1 : (g = j, h = !k)
	}
	return h ? f : ~f
};
goog.array.sort = function (a, b) {
	goog.asserts.assert(null != a.length);
	goog.array.ARRAY_PROTOTYPE_.sort.call(a, b || goog.array.defaultCompare)
};
goog.array.stableSort = function (a, b) {
	for (var c = 0; c < a.length; c++) a[c] = {
		index: c,
		value: a[c]
	};
	var d = b || goog.array.defaultCompare;
	goog.array.sort(a, function (a, b) {
		return d(a.value, b.value) || a.index - b.index
	});
	for (c = 0; c < a.length; c++) a[c] = a[c].value
};
goog.array.sortObjectsByKey = function (a, b, c) {
	var d = c || goog.array.defaultCompare;
	goog.array.sort(a, function (a, c) {
		return d(a[b], c[b])
	})
};
goog.array.isSorted = function (a, b, c) {
	for (var b = b || goog.array.defaultCompare, d = 1; d < a.length; d++) {
		var e = b(a[d - 1], a[d]);
		if (0 < e || 0 == e && c) return !1
	}
	return !0
};
goog.array.equals = function (a, b, c) {
	if (!goog.isArrayLike(a) || !goog.isArrayLike(b) || a.length != b.length) return !1;
	for (var d = a.length, c = c || goog.array.defaultCompareEquality, e = 0; e < d; e++)
		if (!c(a[e], b[e])) return !1;
	return !0
};
goog.array.compare = function (a, b, c) {
	return goog.array.equals(a, b, c)
};
goog.array.defaultCompare = function (a, b) {
	return a > b ? 1 : a < b ? -1 : 0
};
goog.array.defaultCompareEquality = function (a, b) {
	return a === b
};
goog.array.binaryInsert = function (a, b, c) {
	c = goog.array.binarySearch(a, b, c);
	return 0 > c ? (goog.array.insertAt(a, b, -(c + 1)), !0) : !1
};
goog.array.binaryRemove = function (a, b, c) {
	b = goog.array.binarySearch(a, b, c);
	return 0 <= b ? goog.array.removeAt(a, b) : !1
};
goog.array.bucket = function (a, b) {
	for (var c = {}, d = 0; d < a.length; d++) {
		var e = a[d],
			f = b(e, d, a);
		goog.isDef(f) && (c[f] || (c[f] = [])).push(e)
	}
	return c
};
goog.array.repeat = function (a, b) {
	for (var c = [], d = 0; d < b; d++) c[d] = a;
	return c
};
goog.array.flatten = function (a) {
	for (var b = [], c = 0; c < arguments.length; c++) {
		var d = arguments[c];
		goog.isArray(d) ? b.push.apply(b, goog.array.flatten.apply(null, d)) : b.push(d)
	}
	return b
};
goog.array.rotate = function (a, b) {
	goog.asserts.assert(null != a.length);
	a.length && (b %= a.length, 0 < b ? goog.array.ARRAY_PROTOTYPE_.unshift.apply(a, a.splice(-b, b)) : 0 > b && goog.array.ARRAY_PROTOTYPE_.push.apply(a, a.splice(0, -b)));
	return a
};
goog.array.zip = function (a) {
	if (!arguments.length) return [];
	for (var b = [], c = 0;; c++) {
		for (var d = [], e = 0; e < arguments.length; e++) {
			var f = arguments[e];
			if (c >= f.length) return b;
			d.push(f[c])
		}
		b.push(d)
	}
};
goog.array.shuffle = function (a, b) {
	for (var c = b || Math.random, d = a.length - 1; 0 < d; d--) {
		var e = Math.floor(c() * (d + 1)),
			f = a[d];
		a[d] = a[e];
		a[e] = f
	}
};
goog.math.Size = function (a, b) {
	this.width = a;
	this.height = b
};
goog.math.Size.equals = function (a, b) {
	return a == b ? !0 : !a || !b ? !1 : a.width == b.width && a.height == b.height
};
goog.math.Size.prototype.clone = function () {
	return new goog.math.Size(this.width, this.height)
};
goog.DEBUG && (goog.math.Size.prototype.toString = function () {
	return "(" + this.width + " x " + this.height + ")"
});
goog.math.Size.prototype.getLongest = function () {
	return Math.max(this.width, this.height)
};
goog.math.Size.prototype.getShortest = function () {
	return Math.min(this.width, this.height)
};
goog.math.Size.prototype.area = function () {
	return this.width * this.height
};
goog.math.Size.prototype.perimeter = function () {
	return (this.width + this.height) * 2
};
goog.math.Size.prototype.aspectRatio = function () {
	return this.width / this.height
};
goog.math.Size.prototype.isEmpty = function () {
	return !this.area()
};
goog.math.Size.prototype.ceil = function () {
	this.width = Math.ceil(this.width);
	this.height = Math.ceil(this.height);
	return this
};
goog.math.Size.prototype.fitsInside = function (a) {
	return this.width <= a.width && this.height <= a.height
};
goog.math.Size.prototype.floor = function () {
	this.width = Math.floor(this.width);
	this.height = Math.floor(this.height);
	return this
};
goog.math.Size.prototype.round = function () {
	this.width = Math.round(this.width);
	this.height = Math.round(this.height);
	return this
};
goog.math.Size.prototype.scale = function (a) {
	this.width = this.width * a;
	this.height = this.height * a;
	return this
};
goog.math.Size.prototype.scaleToFit = function (a) {
	return this.scale(this.aspectRatio() > a.aspectRatio() ? a.width / this.width : a.height / this.height)
};
goog.math.Rect = function (a, b, c, d) {
	this.left = a;
	this.top = b;
	this.width = c;
	this.height = d
};
goog.math.Rect.prototype.clone = function () {
	return new goog.math.Rect(this.left, this.top, this.width, this.height)
};
goog.math.Rect.prototype.toBox = function () {
	return new goog.math.Box(this.top, this.left + this.width, this.top + this.height, this.left)
};
goog.math.Rect.createFromBox = function (a) {
	return new goog.math.Rect(a.left, a.top, a.right - a.left, a.bottom - a.top)
};
goog.DEBUG && (goog.math.Rect.prototype.toString = function () {
	return "(" + this.left + ", " + this.top + " - " + this.width + "w x " + this.height + "h)"
});
goog.math.Rect.equals = function (a, b) {
	return a == b ? true : !a || !b ? false : a.left == b.left && a.width == b.width && a.top == b.top && a.height == b.height
};
goog.math.Rect.prototype.intersection = function (a) {
	var b = Math.max(this.left, a.left),
		c = Math.min(this.left + this.width, a.left + a.width);
	if (b <= c) {
		var d = Math.max(this.top, a.top),
			a = Math.min(this.top + this.height, a.top + a.height);
		if (d <= a) {
			this.left = b;
			this.top = d;
			this.width = c - b;
			this.height = a - d;
			return true
		}
	}
	return false
};
goog.math.Rect.intersection = function (a, b) {
	var c = Math.max(a.left, b.left),
		d = Math.min(a.left + a.width, b.left + b.width);
	if (c <= d) {
		var e = Math.max(a.top, b.top),
			f = Math.min(a.top + a.height, b.top + b.height);
		if (e <= f) return new goog.math.Rect(c, e, d - c, f - e)
	}
	return null
};
goog.math.Rect.intersects = function (a, b) {
	return a.left <= b.left + b.width && b.left <= a.left + a.width && a.top <= b.top + b.height && b.top <= a.top + a.height
};
goog.math.Rect.prototype.intersects = function (a) {
	return goog.math.Rect.intersects(this, a)
};
goog.math.Rect.difference = function (a, b) {
	var c = goog.math.Rect.intersection(a, b);
	if (!c || !c.height || !c.width) return [a.clone()];
	var c = [],
		d = a.top,
		e = a.height,
		f = a.left + a.width,
		g = a.top + a.height,
		h = b.left + b.width,
		j = b.top + b.height;
	if (b.top > a.top) {
		c.push(new goog.math.Rect(a.left, a.top, a.width, b.top - a.top));
		d = b.top;
		e = e - (b.top - a.top)
	}
	if (j < g) {
		c.push(new goog.math.Rect(a.left, j, a.width, g - j));
		e = j - d
	}
	b.left > a.left && c.push(new goog.math.Rect(a.left, d, b.left - a.left, e));
	h < f && c.push(new goog.math.Rect(h, d, f - h, e));
	return c
};
goog.math.Rect.prototype.difference = function (a) {
	return goog.math.Rect.difference(this, a)
};
goog.math.Rect.prototype.boundingRect = function (a) {
	var b = Math.max(this.left + this.width, a.left + a.width),
		c = Math.max(this.top + this.height, a.top + a.height);
	this.left = Math.min(this.left, a.left);
	this.top = Math.min(this.top, a.top);
	this.width = b - this.left;
	this.height = c - this.top
};
goog.math.Rect.boundingRect = function (a, b) {
	if (!a || !b) return null;
	var c = a.clone();
	c.boundingRect(b);
	return c
};
goog.math.Rect.prototype.contains = function (a) {
	return a instanceof goog.math.Rect ? this.left <= a.left && this.left + this.width >= a.left + a.width && this.top <= a.top && this.top + this.height >= a.top + a.height : a.x >= this.left && a.x <= this.left + this.width && a.y >= this.top && a.y <= this.top + this.height
};
goog.math.Rect.prototype.getSize = function () {
	return new goog.math.Size(this.width, this.height)
};
goog.dom = {};
goog.dom.classes = {};
goog.dom.classes.set = function (a, b) {
	a.className = b
};
goog.dom.classes.get = function (a) {
	return (a = a.className) && "function" == typeof a.split ? a.split(/\s+/) : []
};
goog.dom.classes.add = function (a, b) {
	var c = goog.dom.classes.get(a),
		d = goog.array.slice(arguments, 1),
		d = goog.dom.classes.add_(c, d);
	a.className = c.join(" ");
	return d
};
goog.dom.classes.remove = function (a, b) {
	var c = goog.dom.classes.get(a),
		d = goog.array.slice(arguments, 1),
		d = goog.dom.classes.remove_(c, d);
	a.className = c.join(" ");
	return d
};
goog.dom.classes.add_ = function (a, b) {
	for (var c = 0, d = 0; d < b.length; d++) goog.array.contains(a, b[d]) || (a.push(b[d]), c++);
	return c == b.length
};
goog.dom.classes.remove_ = function (a, b) {
	for (var c = 0, d = 0; d < a.length; d++) goog.array.contains(b, a[d]) && (goog.array.splice(a, d--, 1), c++);
	return c == b.length
};
goog.dom.classes.swap = function (a, b, c) {
	for (var d = goog.dom.classes.get(a), e = !1, f = 0; f < d.length; f++) d[f] == b && (goog.array.splice(d, f--, 1), e = !0);
	e && (d.push(c), a.className = d.join(" "));
	return e
};
goog.dom.classes.addRemove = function (a, b, c) {
	var d = goog.dom.classes.get(a);
	goog.isString(b) ? goog.array.remove(d, b) : goog.isArray(b) && goog.dom.classes.remove_(d, b);
	goog.isString(c) && !goog.array.contains(d, c) ? d.push(c) : goog.isArray(c) && goog.dom.classes.add_(d, c);
	a.className = d.join(" ")
};
goog.dom.classes.has = function (a, b) {
	return goog.array.contains(goog.dom.classes.get(a), b)
};
goog.dom.classes.enable = function (a, b, c) {
	c ? goog.dom.classes.add(a, b) : goog.dom.classes.remove(a, b)
};
goog.dom.classes.toggle = function (a, b) {
	var c = !goog.dom.classes.has(a, b);
	goog.dom.classes.enable(a, b, c);
	return c
};
goog.dom.TagName = {
	A: "A",
	ABBR: "ABBR",
	ACRONYM: "ACRONYM",
	ADDRESS: "ADDRESS",
	APPLET: "APPLET",
	AREA: "AREA",
	B: "B",
	BASE: "BASE",
	BASEFONT: "BASEFONT",
	BDO: "BDO",
	BIG: "BIG",
	BLOCKQUOTE: "BLOCKQUOTE",
	BODY: "BODY",
	BR: "BR",
	BUTTON: "BUTTON",
	CANVAS: "CANVAS",
	CAPTION: "CAPTION",
	CENTER: "CENTER",
	CITE: "CITE",
	CODE: "CODE",
	COL: "COL",
	COLGROUP: "COLGROUP",
	DD: "DD",
	DEL: "DEL",
	DFN: "DFN",
	DIR: "DIR",
	DIV: "DIV",
	DL: "DL",
	DT: "DT",
	EM: "EM",
	FIELDSET: "FIELDSET",
	FONT: "FONT",
	FORM: "FORM",
	FRAME: "FRAME",
	FRAMESET: "FRAMESET",
	H1: "H1",
	H2: "H2",
	H3: "H3",
	H4: "H4",
	H5: "H5",
	H6: "H6",
	HEAD: "HEAD",
	HR: "HR",
	HTML: "HTML",
	I: "I",
	IFRAME: "IFRAME",
	IMG: "IMG",
	INPUT: "INPUT",
	INS: "INS",
	ISINDEX: "ISINDEX",
	KBD: "KBD",
	LABEL: "LABEL",
	LEGEND: "LEGEND",
	LI: "LI",
	LINK: "LINK",
	MAP: "MAP",
	MENU: "MENU",
	META: "META",
	NOFRAMES: "NOFRAMES",
	NOSCRIPT: "NOSCRIPT",
	OBJECT: "OBJECT",
	OL: "OL",
	OPTGROUP: "OPTGROUP",
	OPTION: "OPTION",
	P: "P",
	PARAM: "PARAM",
	PRE: "PRE",
	Q: "Q",
	S: "S",
	SAMP: "SAMP",
	SCRIPT: "SCRIPT",
	SELECT: "SELECT",
	SMALL: "SMALL",
	SPAN: "SPAN",
	STRIKE: "STRIKE",
	STRONG: "STRONG",
	STYLE: "STYLE",
	SUB: "SUB",
	SUP: "SUP",
	TABLE: "TABLE",
	TBODY: "TBODY",
	TD: "TD",
	TEXTAREA: "TEXTAREA",
	TFOOT: "TFOOT",
	TH: "TH",
	THEAD: "THEAD",
	TITLE: "TITLE",
	TR: "TR",
	TT: "TT",
	U: "U",
	UL: "UL",
	VAR: "VAR"
};
goog.dom.BrowserFeature = {
	CAN_ADD_NAME_OR_TYPE_ATTRIBUTES: !goog.userAgent.IE || goog.userAgent.isVersion("9"),
	CAN_USE_INNER_TEXT: goog.userAgent.IE && !goog.userAgent.isVersion("9"),
	INNER_HTML_NEEDS_SCOPED_ELEMENT: goog.userAgent.IE
};
goog.dom.ASSUME_QUIRKS_MODE = !1;
goog.dom.ASSUME_STANDARDS_MODE = !1;
goog.dom.COMPAT_MODE_KNOWN_ = goog.dom.ASSUME_QUIRKS_MODE || goog.dom.ASSUME_STANDARDS_MODE;
goog.dom.NodeType = {
	ELEMENT: 1,
	ATTRIBUTE: 2,
	TEXT: 3,
	CDATA_SECTION: 4,
	ENTITY_REFERENCE: 5,
	ENTITY: 6,
	PROCESSING_INSTRUCTION: 7,
	COMMENT: 8,
	DOCUMENT: 9,
	DOCUMENT_TYPE: 10,
	DOCUMENT_FRAGMENT: 11,
	NOTATION: 12
};
goog.dom.getDomHelper = function (a) {
	return a ? new goog.dom.DomHelper(goog.dom.getOwnerDocument(a)) : goog.dom.defaultDomHelper_ || (goog.dom.defaultDomHelper_ = new goog.dom.DomHelper)
};
goog.dom.getDocument = function () {
	return document
};
goog.dom.getElement = function (a) {
	return goog.isString(a) ? document.getElementById(a) : a
};
goog.dom.$ = goog.dom.getElement;
goog.dom.getElementsByTagNameAndClass = function (a, b, c) {
	return goog.dom.getElementsByTagNameAndClass_(document, a, b, c)
};
goog.dom.getElementsByClass = function (a, b) {
	var c = b || document;
	return goog.dom.canUseQuerySelector_(c) ? c.querySelectorAll("." + a) : c.getElementsByClassName ? c.getElementsByClassName(a) : goog.dom.getElementsByTagNameAndClass_(document, "*", a, b)
};
goog.dom.getElementByClass = function (a, b) {
	var c = b || document,
		d = null;
	return (d = goog.dom.canUseQuerySelector_(c) ? c.querySelector("." + a) : goog.dom.getElementsByClass(a, b)[0]) || null
};
goog.dom.canUseQuerySelector_ = function (a) {
	return a.querySelectorAll && a.querySelector && (!goog.userAgent.WEBKIT || goog.dom.isCss1CompatMode_(document) || goog.userAgent.isVersion("528"))
};
goog.dom.getElementsByTagNameAndClass_ = function (a, b, c, d) {
	a = d || a;
	b = b && "*" != b ? b.toUpperCase() : "";
	if (goog.dom.canUseQuerySelector_(a) && (b || c)) return a.querySelectorAll(b + (c ? "." + c : ""));
	if (c && a.getElementsByClassName) {
		a = a.getElementsByClassName(c);
		if (b) {
			for (var d = {}, e = 0, f = 0, g; g = a[f]; f++) b == g.nodeName && (d[e++] = g);
			d.length = e;
			return d
		}
		return a
	}
	a = a.getElementsByTagName(b || "*");
	if (c) {
		d = {};
		for (f = e = 0; g = a[f]; f++) b = g.className, "function" == typeof b.split && goog.array.contains(b.split(/\s+/), c) && (d[e++] = g);
		d.length =
			e;
		return d
	}
	return a
};
goog.dom.$$ = goog.dom.getElementsByTagNameAndClass;
goog.dom.setProperties = function (a, b) {
	goog.object.forEach(b, function (b, d) {
		"style" == d ? a.style.cssText = b : "class" == d ? a.className = b : "for" == d ? a.htmlFor = b : d in goog.dom.DIRECT_ATTRIBUTE_MAP_ ? a.setAttribute(goog.dom.DIRECT_ATTRIBUTE_MAP_[d], b) : a[d] = b
	})
};
goog.dom.DIRECT_ATTRIBUTE_MAP_ = {
	cellpadding: "cellPadding",
	cellspacing: "cellSpacing",
	colspan: "colSpan",
	rowspan: "rowSpan",
	valign: "vAlign",
	height: "height",
	width: "width",
	usemap: "useMap",
	frameborder: "frameBorder",
	type: "type"
};
goog.dom.getViewportSize = function (a) {
	return goog.dom.getViewportSize_(a || window)
};
goog.dom.getViewportSize_ = function (a) {
	var b = a.document;
	if (goog.userAgent.WEBKIT && !goog.userAgent.isVersion("500") && !goog.userAgent.MOBILE) {
		"undefined" == typeof a.innerHeight && (a = window);
		var b = a.innerHeight,
			c = a.document.documentElement.scrollHeight;
		a == a.top && c < b && (b -= 15);
		return new goog.math.Size(a.innerWidth, b)
	}
	a = goog.dom.isCss1CompatMode_(b);
	goog.userAgent.OPERA && !goog.userAgent.isVersion("9.50") && (a = !1);
	a = a ? b.documentElement : b.body;
	return new goog.math.Size(a.clientWidth, a.clientHeight)
};
goog.dom.getDocumentHeight = function () {
	return goog.dom.getDocumentHeight_(window)
};
goog.dom.getDocumentHeight_ = function (a) {
	var b = a.document,
		c = 0;
	if (b) {
		var a = goog.dom.getViewportSize_(a).height,
			c = b.body,
			d = b.documentElement;
		if (goog.dom.isCss1CompatMode_(b) && d.scrollHeight) c = d.scrollHeight != a ? d.scrollHeight : d.offsetHeight;
		else {
			var b = d.scrollHeight,
				e = d.offsetHeight;
			d.clientHeight != e && (b = c.scrollHeight, e = c.offsetHeight);
			c = b > a ? b > e ? b : e : b < e ? b : e
		}
	}
	return c
};
goog.dom.getPageScroll = function (a) {
	return goog.dom.getDomHelper((a || goog.global || window).document).getDocumentScroll()
};
goog.dom.getDocumentScroll = function () {
	return goog.dom.getDocumentScroll_(document)
};
goog.dom.getDocumentScroll_ = function (a) {
	a = goog.dom.getDocumentScrollElement_(a);
	return new goog.math.Coordinate(a.scrollLeft, a.scrollTop)
};
goog.dom.getDocumentScrollElement = function () {
	return goog.dom.getDocumentScrollElement_(document)
};
goog.dom.getDocumentScrollElement_ = function (a) {
	return !goog.userAgent.WEBKIT && goog.dom.isCss1CompatMode_(a) ? a.documentElement : a.body
};
goog.dom.getWindow = function (a) {
	return a ? goog.dom.getWindow_(a) : window
};
goog.dom.getWindow_ = function (a) {
	return a.parentWindow || a.defaultView
};
goog.dom.createDom = function (a, b, c) {
	return goog.dom.createDom_(document, arguments)
};
goog.dom.createDom_ = function (a, b) {
	var c = b[0],
		d = b[1];
	if (!goog.dom.BrowserFeature.CAN_ADD_NAME_OR_TYPE_ATTRIBUTES && d && (d.name || d.type)) {
		c = ["<", c];
		d.name && c.push(' name="', goog.string.htmlEscape(d.name), '"');
		if (d.type) {
			c.push(' type="', goog.string.htmlEscape(d.type), '"');
			var e = {};
			goog.object.extend(e, d);
			d = e;
			delete d.type
		}
		c.push(">");
		c = c.join("")
	}
	c = a.createElement(c);
	d && (goog.isString(d) ? c.className = d : goog.isArray(d) ? goog.dom.classes.add.apply(null, [c].concat(d)) : goog.dom.setProperties(c, d));
	2 < b.length &&
		goog.dom.append_(a, c, b, 2);
	return c
};
goog.dom.append_ = function (a, b, c, d) {
	function e(c) {
		c && b.appendChild(goog.isString(c) ? a.createTextNode(c) : c)
	}
	for (; d < c.length; d++) {
		var f = c[d];
		goog.isArrayLike(f) && !goog.dom.isNodeLike(f) ? goog.array.forEach(goog.dom.isNodeList(f) ? goog.array.clone(f) : f, e) : e(f)
	}
};
goog.dom.$dom = goog.dom.createDom;
goog.dom.createElement = function (a) {
	return document.createElement(a)
};
goog.dom.createTextNode = function (a) {
	return document.createTextNode(a)
};
goog.dom.createTable = function (a, b, c) {
	return goog.dom.createTable_(document, a, b, !! c)
};
goog.dom.createTable_ = function (a, b, c, d) {
	for (var e = ["<tr>"], f = 0; f < c; f++) e.push(d ? "<td>&nbsp;</td>" : "<td></td>");
	e.push("</tr>");
	e = e.join("");
	c = ["<table>"];
	for (f = 0; f < b; f++) c.push(e);
	c.push("</table>");
	a = a.createElement(goog.dom.TagName.DIV);
	a.innerHTML = c.join("");
	return a.removeChild(a.firstChild)
};
goog.dom.htmlToDocumentFragment = function (a) {
	return goog.dom.htmlToDocumentFragment_(document, a)
};
goog.dom.htmlToDocumentFragment_ = function (a, b) {
	var c = a.createElement("div");
	goog.dom.BrowserFeature.INNER_HTML_NEEDS_SCOPED_ELEMENT ? (c.innerHTML = "<br>" + b, c.removeChild(c.firstChild)) : c.innerHTML = b;
	if (1 == c.childNodes.length) return c.removeChild(c.firstChild);
	for (var d = a.createDocumentFragment(); c.firstChild;) d.appendChild(c.firstChild);
	return d
};
goog.dom.getCompatMode = function () {
	return goog.dom.isCss1CompatMode() ? "CSS1Compat" : "BackCompat"
};
goog.dom.isCss1CompatMode = function () {
	return goog.dom.isCss1CompatMode_(document)
};
goog.dom.isCss1CompatMode_ = function (a) {
	return goog.dom.COMPAT_MODE_KNOWN_ ? goog.dom.ASSUME_STANDARDS_MODE : "CSS1Compat" == a.compatMode
};
goog.dom.canHaveChildren = function (a) {
	if (a.nodeType != goog.dom.NodeType.ELEMENT) return !1;
	switch (a.tagName) {
	case goog.dom.TagName.APPLET:
	case goog.dom.TagName.AREA:
	case goog.dom.TagName.BASE:
	case goog.dom.TagName.BR:
	case goog.dom.TagName.COL:
	case goog.dom.TagName.FRAME:
	case goog.dom.TagName.HR:
	case goog.dom.TagName.IMG:
	case goog.dom.TagName.INPUT:
	case goog.dom.TagName.IFRAME:
	case goog.dom.TagName.ISINDEX:
	case goog.dom.TagName.LINK:
	case goog.dom.TagName.NOFRAMES:
	case goog.dom.TagName.NOSCRIPT:
	case goog.dom.TagName.META:
	case goog.dom.TagName.OBJECT:
	case goog.dom.TagName.PARAM:
	case goog.dom.TagName.SCRIPT:
	case goog.dom.TagName.STYLE:
		return !1
	}
	return !0
};
goog.dom.appendChild = function (a, b) {
	a.appendChild(b)
};
goog.dom.append = function (a, b) {
	goog.dom.append_(goog.dom.getOwnerDocument(a), a, arguments, 1)
};
goog.dom.removeChildren = function (a) {
	for (var b; b = a.firstChild;) a.removeChild(b)
};
goog.dom.insertSiblingBefore = function (a, b) {
	b.parentNode && b.parentNode.insertBefore(a, b)
};
goog.dom.insertSiblingAfter = function (a, b) {
	b.parentNode && b.parentNode.insertBefore(a, b.nextSibling)
};
goog.dom.removeNode = function (a) {
	return a && a.parentNode ? a.parentNode.removeChild(a) : null
};
goog.dom.replaceNode = function (a, b) {
	var c = b.parentNode;
	c && c.replaceChild(a, b)
};
goog.dom.flattenElement = function (a) {
	var b, c = a.parentNode;
	if (c && c.nodeType != goog.dom.NodeType.DOCUMENT_FRAGMENT) {
		if (a.removeNode) return a.removeNode(!1);
		for (; b = a.firstChild;) c.insertBefore(b, a);
		return goog.dom.removeNode(a)
	}
};
goog.dom.getFirstElementChild = function (a) {
	return goog.dom.getNextElementNode_(a.firstChild, !0)
};
goog.dom.getLastElementChild = function (a) {
	return goog.dom.getNextElementNode_(a.lastChild, !1)
};
goog.dom.getNextElementSibling = function (a) {
	return goog.dom.getNextElementNode_(a.nextSibling, !0)
};
goog.dom.getPreviousElementSibling = function (a) {
	return goog.dom.getNextElementNode_(a.previousSibling, !1)
};
goog.dom.getNextElementNode_ = function (a, b) {
	for (; a && a.nodeType != goog.dom.NodeType.ELEMENT;) a = b ? a.nextSibling : a.previousSibling;
	return a
};
goog.dom.getNextNode = function (a) {
	if (!a) return null;
	if (a.firstChild) return a.firstChild;
	for (; a && !a.nextSibling;) a = a.parentNode;
	return a ? a.nextSibling : null
};
goog.dom.getPreviousNode = function (a) {
	if (!a) return null;
	if (!a.previousSibling) return a.parentNode;
	for (a = a.previousSibling; a && a.lastChild;) a = a.lastChild;
	return a
};
goog.dom.isNodeLike = function (a) {
	return goog.isObject(a) && 0 < a.nodeType
};
goog.dom.contains = function (a, b) {
	if (a.contains && b.nodeType == goog.dom.NodeType.ELEMENT) return a == b || a.contains(b);
	if ("undefined" != typeof a.compareDocumentPosition) return a == b || Boolean(a.compareDocumentPosition(b) & 16);
	for (; b && a != b;) b = b.parentNode;
	return b == a
};
goog.dom.compareNodeOrder = function (a, b) {
	if (a == b) return 0;
	if (a.compareDocumentPosition) return a.compareDocumentPosition(b) & 2 ? 1 : -1;
	if ("sourceIndex" in a || a.parentNode && "sourceIndex" in a.parentNode) {
		var c = a.nodeType == goog.dom.NodeType.ELEMENT,
			d = b.nodeType == goog.dom.NodeType.ELEMENT;
		if (c && d) return a.sourceIndex - b.sourceIndex;
		var e = a.parentNode,
			f = b.parentNode;
		return e == f ? goog.dom.compareSiblingOrder_(a, b) : !c && goog.dom.contains(e, b) ? -1 * goog.dom.compareParentsDescendantNodeIe_(a, b) : !d && goog.dom.contains(f,
			a) ? goog.dom.compareParentsDescendantNodeIe_(b, a) : (c ? a.sourceIndex : e.sourceIndex) - (d ? b.sourceIndex : f.sourceIndex)
	}
	d = goog.dom.getOwnerDocument(a);
	c = d.createRange();
	c.selectNode(a);
	c.collapse(!0);
	d = d.createRange();
	d.selectNode(b);
	d.collapse(!0);
	return c.compareBoundaryPoints(goog.global.Range.START_TO_END, d)
};
goog.dom.compareParentsDescendantNodeIe_ = function (a, b) {
	var c = a.parentNode;
	if (c == b) return -1;
	for (var d = b; d.parentNode != c;) d = d.parentNode;
	return goog.dom.compareSiblingOrder_(d, a)
};
goog.dom.compareSiblingOrder_ = function (a, b) {
	for (var c = b; c = c.previousSibling;)
		if (c == a) return -1;
	return 1
};
goog.dom.findCommonAncestor = function (a) {
	var b, c = arguments.length;
	if (c) {
		if (1 == c) return arguments[0]
	} else return null;
	var d = [],
		e = Infinity;
	for (b = 0; b < c; b++) {
		for (var f = [], g = arguments[b]; g;) f.unshift(g), g = g.parentNode;
		d.push(f);
		e = Math.min(e, f.length)
	}
	f = null;
	for (b = 0; b < e; b++) {
		for (var g = d[0][b], h = 1; h < c; h++)
			if (g != d[h][b]) return f;
		f = g
	}
	return f
};
goog.dom.getOwnerDocument = function (a) {
	return a.nodeType == goog.dom.NodeType.DOCUMENT ? a : a.ownerDocument || a.document
};
goog.dom.getFrameContentDocument = function (a) {
	return goog.userAgent.WEBKIT ? a.document || a.contentWindow.document : a.contentDocument || a.contentWindow.document
};
goog.dom.getFrameContentWindow = function (a) {
	return a.contentWindow || goog.dom.getWindow_(goog.dom.getFrameContentDocument(a))
};
goog.dom.setTextContent = function (a, b) {
	if ("textContent" in a) a.textContent = b;
	else if (a.firstChild && a.firstChild.nodeType == goog.dom.NodeType.TEXT) {
		for (; a.lastChild != a.firstChild;) a.removeChild(a.lastChild);
		a.firstChild.data = b
	} else {
		goog.dom.removeChildren(a);
		var c = goog.dom.getOwnerDocument(a);
		a.appendChild(c.createTextNode(b))
	}
};
goog.dom.getOuterHtml = function (a) {
	if ("outerHTML" in a) return a.outerHTML;
	var b = goog.dom.getOwnerDocument(a).createElement("div");
	b.appendChild(a.cloneNode(!0));
	return b.innerHTML
};
goog.dom.findNode = function (a, b) {
	var c = [];
	return goog.dom.findNodes_(a, b, c, !0) ? c[0] : void 0
};
goog.dom.findNodes = function (a, b) {
	var c = [];
	goog.dom.findNodes_(a, b, c, !1);
	return c
};
goog.dom.findNodes_ = function (a, b, c, d) {
	if (null != a)
		for (var e = 0, f; f = a.childNodes[e]; e++)
			if (b(f) && (c.push(f), d) || goog.dom.findNodes_(f, b, c, d)) return !0;
	return !1
};
goog.dom.TAGS_TO_IGNORE_ = {
	SCRIPT: 1,
	STYLE: 1,
	HEAD: 1,
	IFRAME: 1,
	OBJECT: 1
};
goog.dom.PREDEFINED_TAG_VALUES_ = {
	IMG: " ",
	BR: "\n"
};
goog.dom.isFocusableTabIndex = function (a) {
	var b = a.getAttributeNode("tabindex");
	return b && b.specified ? (a = a.tabIndex, goog.isNumber(a) && 0 <= a) : !1
};
goog.dom.setFocusableTabIndex = function (a, b) {
	b ? a.tabIndex = 0 : a.removeAttribute("tabIndex")
};
goog.dom.getTextContent = function (a) {
	if (goog.dom.BrowserFeature.CAN_USE_INNER_TEXT && "innerText" in a) a = goog.string.canonicalizeNewlines(a.innerText);
	else {
		var b = [];
		goog.dom.getTextContent_(a, b, !0);
		a = b.join("")
	}
	a = a.replace(/ \xAD /g, " ").replace(/\xAD/g, "");
	goog.userAgent.IE || (a = a.replace(/ +/g, " "));
	" " != a && (a = a.replace(/^\s*/, ""));
	return a
};
goog.dom.getRawTextContent = function (a) {
	var b = [];
	goog.dom.getTextContent_(a, b, !1);
	return b.join("")
};
goog.dom.getTextContent_ = function (a, b, c) {
	if (!(a.nodeName in goog.dom.TAGS_TO_IGNORE_))
		if (a.nodeType == goog.dom.NodeType.TEXT) c ? b.push(("" + a.nodeValue).replace(/(\r\n|\r|\n)/g, "")) : b.push(a.nodeValue);
		else if (a.nodeName in goog.dom.PREDEFINED_TAG_VALUES_) b.push(goog.dom.PREDEFINED_TAG_VALUES_[a.nodeName]);
	else
		for (a = a.firstChild; a;) goog.dom.getTextContent_(a, b, c), a = a.nextSibling
};
goog.dom.getNodeTextLength = function (a) {
	return goog.dom.getTextContent(a).length
};
goog.dom.getNodeTextOffset = function (a, b) {
	for (var c = b || goog.dom.getOwnerDocument(a).body, d = []; a && a != c;) {
		for (var e = a; e = e.previousSibling;) d.unshift(goog.dom.getTextContent(e));
		a = a.parentNode
	}
	return goog.string.trimLeft(d.join("")).replace(/ +/g, " ").length
};
goog.dom.getNodeAtOffset = function (a, b, c) {
	for (var a = [a], d = 0, e; 0 < a.length && d < b;)
		if (e = a.pop(), !(e.nodeName in goog.dom.TAGS_TO_IGNORE_))
			if (e.nodeType == goog.dom.NodeType.TEXT) var f = e.nodeValue.replace(/(\r\n|\r|\n)/g, "").replace(/ +/g, " "),
	d = d + f.length;
	else if (e.nodeName in goog.dom.PREDEFINED_TAG_VALUES_) d += goog.dom.PREDEFINED_TAG_VALUES_[e.nodeName].length;
	else
		for (f = e.childNodes.length - 1; 0 <= f; f--) a.push(e.childNodes[f]);
	goog.isObject(c) && (c.remainder = e ? e.nodeValue.length + b - d - 1 : 0, c.node = e);
	return e
};
goog.dom.isNodeList = function (a) {
	if (a && "number" == typeof a.length) {
		if (goog.isObject(a)) return "function" == typeof a.item || "string" == typeof a.item;
		if (goog.isFunction(a)) return "function" == typeof a.item
	}
	return !1
};
goog.dom.getAncestorByTagNameAndClass = function (a, b, c) {
	var d = b ? b.toUpperCase() : null;
	return goog.dom.getAncestor(a, function (a) {
		return (!d || a.nodeName == d) && (!c || goog.dom.classes.has(a, c))
	}, !0)
};
goog.dom.getAncestor = function (a, b, c, d) {
	c || (a = a.parentNode);
	for (var c = null == d, e = 0; a && (c || e <= d);) {
		if (b(a)) return a;
		a = a.parentNode;
		e++
	}
	return null
};
goog.dom.DomHelper = function (a) {
	this.document_ = a || goog.global.document || document
};
goog.dom.DomHelper.prototype.getDomHelper = goog.dom.getDomHelper;
goog.dom.DomHelper.prototype.setDocument = function (a) {
	this.document_ = a
};
goog.dom.DomHelper.prototype.getDocument = function () {
	return this.document_
};
goog.dom.DomHelper.prototype.getElement = function (a) {
	return goog.isString(a) ? this.document_.getElementById(a) : a
};
goog.dom.DomHelper.prototype.$ = goog.dom.DomHelper.prototype.getElement;
goog.dom.DomHelper.prototype.getElementsByTagNameAndClass = function (a, b, c) {
	return goog.dom.getElementsByTagNameAndClass_(this.document_, a, b, c)
};
goog.dom.DomHelper.prototype.getElementsByClass = function (a, b) {
	return goog.dom.getElementsByClass(a, b || this.document_)
};
goog.dom.DomHelper.prototype.getElementByClass = function (a, b) {
	return goog.dom.getElementByClass(a, b || this.document_)
};
goog.dom.DomHelper.prototype.$$ = goog.dom.DomHelper.prototype.getElementsByTagNameAndClass;
goog.dom.DomHelper.prototype.setProperties = goog.dom.setProperties;
goog.dom.DomHelper.prototype.getViewportSize = function (a) {
	return goog.dom.getViewportSize(a || this.getWindow())
};
goog.dom.DomHelper.prototype.getDocumentHeight = function () {
	return goog.dom.getDocumentHeight_(this.getWindow())
};
goog.dom.DomHelper.prototype.createDom = function (a, b, c) {
	return goog.dom.createDom_(this.document_, arguments)
};
goog.dom.DomHelper.prototype.$dom = goog.dom.DomHelper.prototype.createDom;
goog.dom.DomHelper.prototype.createElement = function (a) {
	return this.document_.createElement(a)
};
goog.dom.DomHelper.prototype.createTextNode = function (a) {
	return this.document_.createTextNode(a)
};
goog.dom.DomHelper.prototype.createTable = function (a, b, c) {
	return goog.dom.createTable_(this.document_, a, b, !! c)
};
goog.dom.DomHelper.prototype.htmlToDocumentFragment = function (a) {
	return goog.dom.htmlToDocumentFragment_(this.document_, a)
};
goog.dom.DomHelper.prototype.getCompatMode = function () {
	return this.isCss1CompatMode() ? "CSS1Compat" : "BackCompat"
};
goog.dom.DomHelper.prototype.isCss1CompatMode = function () {
	return goog.dom.isCss1CompatMode_(this.document_)
};
goog.dom.DomHelper.prototype.getWindow = function () {
	return goog.dom.getWindow_(this.document_)
};
goog.dom.DomHelper.prototype.getDocumentScrollElement = function () {
	return goog.dom.getDocumentScrollElement_(this.document_)
};
goog.dom.DomHelper.prototype.getDocumentScroll = function () {
	return goog.dom.getDocumentScroll_(this.document_)
};
goog.dom.DomHelper.prototype.appendChild = goog.dom.appendChild;
goog.dom.DomHelper.prototype.append = goog.dom.append;
goog.dom.DomHelper.prototype.removeChildren = goog.dom.removeChildren;
goog.dom.DomHelper.prototype.insertSiblingBefore = goog.dom.insertSiblingBefore;
goog.dom.DomHelper.prototype.insertSiblingAfter = goog.dom.insertSiblingAfter;
goog.dom.DomHelper.prototype.removeNode = goog.dom.removeNode;
goog.dom.DomHelper.prototype.replaceNode = goog.dom.replaceNode;
goog.dom.DomHelper.prototype.flattenElement = goog.dom.flattenElement;
goog.dom.DomHelper.prototype.getFirstElementChild = goog.dom.getFirstElementChild;
goog.dom.DomHelper.prototype.getLastElementChild = goog.dom.getLastElementChild;
goog.dom.DomHelper.prototype.getNextElementSibling = goog.dom.getNextElementSibling;
goog.dom.DomHelper.prototype.getPreviousElementSibling = goog.dom.getPreviousElementSibling;
goog.dom.DomHelper.prototype.getNextNode = goog.dom.getNextNode;
goog.dom.DomHelper.prototype.getPreviousNode = goog.dom.getPreviousNode;
goog.dom.DomHelper.prototype.isNodeLike = goog.dom.isNodeLike;
goog.dom.DomHelper.prototype.contains = goog.dom.contains;
goog.dom.DomHelper.prototype.getOwnerDocument = goog.dom.getOwnerDocument;
goog.dom.DomHelper.prototype.getFrameContentDocument = goog.dom.getFrameContentDocument;
goog.dom.DomHelper.prototype.getFrameContentWindow = goog.dom.getFrameContentWindow;
goog.dom.DomHelper.prototype.setTextContent = goog.dom.setTextContent;
goog.dom.DomHelper.prototype.findNode = goog.dom.findNode;
goog.dom.DomHelper.prototype.findNodes = goog.dom.findNodes;
goog.dom.DomHelper.prototype.getTextContent = goog.dom.getTextContent;
goog.dom.DomHelper.prototype.getNodeTextLength = goog.dom.getNodeTextLength;
goog.dom.DomHelper.prototype.getNodeTextOffset = goog.dom.getNodeTextOffset;
goog.dom.DomHelper.prototype.getAncestorByTagNameAndClass = goog.dom.getAncestorByTagNameAndClass;
goog.dom.DomHelper.prototype.getAncestor = goog.dom.getAncestor;
goog.style = {};
goog.style.setStyle = function (a, b, c) {
	goog.isString(b) ? goog.style.setStyle_(a, c, b) : goog.object.forEach(b, goog.partial(goog.style.setStyle_, a))
};
goog.style.setStyle_ = function (a, b, c) {
	a.style[goog.style.toCamelCase(c)] = b
};
goog.style.getStyle = function (a, b) {
	return a.style[goog.style.toCamelCase(b)] || ""
};
goog.style.getComputedStyle = function (a, b) {
	var c = goog.dom.getOwnerDocument(a);
	return c.defaultView && c.defaultView.getComputedStyle && (c = c.defaultView.getComputedStyle(a, null)) ? c[b] || c.getPropertyValue(b) : ""
};
goog.style.getCascadedStyle = function (a, b) {
	return a.currentStyle ? a.currentStyle[b] : null
};
goog.style.getStyle_ = function (a, b) {
	return goog.style.getComputedStyle(a, b) || goog.style.getCascadedStyle(a, b) || a.style[b]
};
goog.style.getComputedPosition = function (a) {
	return goog.style.getStyle_(a, "position")
};
goog.style.getBackgroundColor = function (a) {
	return goog.style.getStyle_(a, "backgroundColor")
};
goog.style.getComputedOverflowX = function (a) {
	return goog.style.getStyle_(a, "overflowX")
};
goog.style.getComputedOverflowY = function (a) {
	return goog.style.getStyle_(a, "overflowY")
};
goog.style.getComputedZIndex = function (a) {
	return goog.style.getStyle_(a, "zIndex")
};
goog.style.getComputedTextAlign = function (a) {
	return goog.style.getStyle_(a, "textAlign")
};
goog.style.getComputedCursor = function (a) {
	return goog.style.getStyle_(a, "cursor")
};
goog.style.setPosition = function (a, b, c) {
	var d, e = goog.userAgent.GECKO && (goog.userAgent.MAC || goog.userAgent.X11) && goog.userAgent.isVersion("1.9");
	b instanceof goog.math.Coordinate ? (d = b.x, b = b.y) : (d = b, b = c);
	a.style.left = goog.style.getPixelStyleValue_(d, e);
	a.style.top = goog.style.getPixelStyleValue_(b, e)
};
goog.style.getPosition = function (a) {
	return new goog.math.Coordinate(a.offsetLeft, a.offsetTop)
};
goog.style.getClientViewportElement = function (a) {
	a = a ? a.nodeType == goog.dom.NodeType.DOCUMENT ? a : goog.dom.getOwnerDocument(a) : goog.dom.getDocument();
	return goog.userAgent.IE && !goog.dom.getDomHelper(a).isCss1CompatMode() ? a.body : a.documentElement
};
goog.style.getBoundingClientRect_ = function (a) {
	var b = a.getBoundingClientRect();
	goog.userAgent.IE && (a = a.ownerDocument, b.left -= a.documentElement.clientLeft + a.body.clientLeft, b.top -= a.documentElement.clientTop + a.body.clientTop);
	return b
};
goog.style.getOffsetParent = function (a) {
	if (goog.userAgent.IE) return a.offsetParent;
	for (var b = goog.dom.getOwnerDocument(a), c = goog.style.getStyle_(a, "position"), d = "fixed" == c || "absolute" == c, a = a.parentNode; a && a != b; a = a.parentNode)
		if (c = goog.style.getStyle_(a, "position"), d = d && "static" == c && a != b.documentElement && a != b.body, !d && (a.scrollWidth > a.clientWidth || a.scrollHeight > a.clientHeight || "fixed" == c || "absolute" == c)) return a;
	return null
};
goog.style.getVisibleRectForElement = function (a) {
	for (var b = new goog.math.Box(0, Infinity, Infinity, 0), c = goog.dom.getDomHelper(a), d = c.getDocument().body, e = c.getDocumentScrollElement(), f; a = goog.style.getOffsetParent(a);)
		if ((!goog.userAgent.IE || 0 != a.clientWidth) && (!goog.userAgent.WEBKIT || 0 != a.clientHeight || a != d) && (a.scrollWidth != a.clientWidth || a.scrollHeight != a.clientHeight) && "visible" != goog.style.getStyle_(a, "overflow")) {
			var g = goog.style.getPageOffset(a),
				h = goog.style.getClientLeftTop(a);
			g.x += h.x;
			g.y +=
				h.y;
			b.top = Math.max(b.top, g.y);
			b.right = Math.min(b.right, g.x + a.clientWidth);
			b.bottom = Math.min(b.bottom, g.y + a.clientHeight);
			b.left = Math.max(b.left, g.x);
			f = f || a != e
		}
	d = e.scrollLeft;
	e = e.scrollTop;
	goog.userAgent.WEBKIT ? (b.left += d, b.top += e) : (b.left = Math.max(b.left, d), b.top = Math.max(b.top, e));
	if (!f || goog.userAgent.WEBKIT) b.right += d, b.bottom += e;
	c = c.getViewportSize();
	b.right = Math.min(b.right, d + c.width);
	b.bottom = Math.min(b.bottom, e + c.height);
	return 0 <= b.top && 0 <= b.left && b.bottom > b.top && b.right > b.left ? b : null
};
goog.style.scrollIntoContainerView = function (a, b, c) {
	var d = goog.style.getPageOffset(a),
		e = goog.style.getPageOffset(b),
		f = goog.style.getBorderBox(b),
		g = d.x - e.x - f.left,
		d = d.y - e.y - f.top,
		e = b.clientWidth - a.offsetWidth,
		a = b.clientHeight - a.offsetHeight;
	c ? (b.scrollLeft += g - e / 2, b.scrollTop += d - a / 2) : (b.scrollLeft += Math.min(g, Math.max(g - e, 0)), b.scrollTop += Math.min(d, Math.max(d - a, 0)))
};
goog.style.getClientLeftTop = function (a) {
	if (goog.userAgent.GECKO && !goog.userAgent.isVersion("1.9")) {
		var b = parseFloat(goog.style.getComputedStyle(a, "borderLeftWidth"));
		if (goog.style.isRightToLeft(a)) var c = a.offsetWidth - a.clientWidth - b - parseFloat(goog.style.getComputedStyle(a, "borderRightWidth")),
		b = b + c;
		return new goog.math.Coordinate(b, parseFloat(goog.style.getComputedStyle(a, "borderTopWidth")))
	}
	return new goog.math.Coordinate(a.clientLeft, a.clientTop)
};
goog.style.getPageOffset = function (a) {
	var b, c = goog.dom.getOwnerDocument(a),
		d = goog.style.getStyle_(a, "position"),
		e = goog.userAgent.GECKO && c.getBoxObjectFor && !a.getBoundingClientRect && "absolute" == d && (b = c.getBoxObjectFor(a)) && (0 > b.screenX || 0 > b.screenY),
		f = new goog.math.Coordinate(0, 0),
		g = goog.style.getClientViewportElement(c);
	if (a == g) return f;
	if (a.getBoundingClientRect) b = goog.style.getBoundingClientRect_(a), a = goog.dom.getDomHelper(c).getDocumentScroll(), f.x = b.left + a.x, f.y = b.top + a.y;
	else if (c.getBoxObjectFor && !e) b = c.getBoxObjectFor(a), a = c.getBoxObjectFor(g), f.x = b.screenX - a.screenX, f.y = b.screenY - a.screenY;
	else {
		b = a;
		do {
			f.x += b.offsetLeft;
			f.y += b.offsetTop;
			b != a && (f.x += b.clientLeft || 0, f.y += b.clientTop || 0);
			if (goog.userAgent.WEBKIT && "fixed" == goog.style.getComputedPosition(b)) {
				f.x += c.body.scrollLeft;
				f.y += c.body.scrollTop;
				break
			}
			b = b.offsetParent
		} while (b && b != a);
		if (goog.userAgent.OPERA || goog.userAgent.WEBKIT && "absolute" == d) f.y -= c.body.offsetTop;
		for (b = a;
			(b = goog.style.getOffsetParent(b)) && b != c.body && b != g;)
			if (f.x -= b.scrollLeft, !goog.userAgent.OPERA || "TR" != b.tagName) f.y -= b.scrollTop
	}
	return f
};
goog.style.getPageOffsetLeft = function (a) {
	return goog.style.getPageOffset(a).x
};
goog.style.getPageOffsetTop = function (a) {
	return goog.style.getPageOffset(a).y
};
goog.style.getFramedPageOffset = function (a, b) {
	var c = new goog.math.Coordinate(0, 0),
		d = goog.dom.getWindow(goog.dom.getOwnerDocument(a)),
		e = a;
	do {
		var f = d == b ? goog.style.getPageOffset(e) : goog.style.getClientPosition(e);
		c.x += f.x;
		c.y += f.y
	} while (d && d != b && (e = d.frameElement) && (d = d.parent));
	return c
};
goog.style.translateRectForAnotherFrame = function (a, b, c) {
	if (b.getDocument() != c.getDocument()) {
		var d = b.getDocument().body,
			c = goog.style.getFramedPageOffset(d, c.getWindow()),
			c = goog.math.Coordinate.difference(c, goog.style.getPageOffset(d));
		goog.userAgent.IE && !b.isCss1CompatMode() && (c = goog.math.Coordinate.difference(c, b.getDocumentScroll()));
		a.left += c.x;
		a.top += c.y
	}
};
goog.style.getRelativePosition = function (a, b) {
	var c = goog.style.getClientPosition(a),
		d = goog.style.getClientPosition(b);
	return new goog.math.Coordinate(c.x - d.x, c.y - d.y)
};
goog.style.getClientPosition = function (a) {
	var b = new goog.math.Coordinate;
	if (a.nodeType == goog.dom.NodeType.ELEMENT)
		if (a.getBoundingClientRect) {
			var c = goog.style.getBoundingClientRect_(a);
			b.x = c.left;
			b.y = c.top
		} else c = goog.dom.getDomHelper(a).getDocumentScroll(), a = goog.style.getPageOffset(a), b.x = a.x - c.x, b.y = a.y - c.y;
		else b.x = a.clientX, b.y = a.clientY;
	return b
};
goog.style.setPageOffset = function (a, b, c) {
	var d = goog.style.getPageOffset(a);
	b instanceof goog.math.Coordinate && (c = b.y, b = b.x);
	goog.style.setPosition(a, a.offsetLeft + (b - d.x), a.offsetTop + (c - d.y))
};
goog.style.setSize = function (a, b, c) {
	if (b instanceof goog.math.Size) c = b.height, b = b.width;
	else if (void 0 == c) throw Error("missing height argument");
	goog.style.setWidth(a, b);
	goog.style.setHeight(a, c)
};
goog.style.getPixelStyleValue_ = function (a, b) {
	"number" == typeof a && (a = (b ? Math.round(a) : a) + "px");
	return a
};
goog.style.setHeight = function (a, b) {
	a.style.height = goog.style.getPixelStyleValue_(b, !0)
};
goog.style.setWidth = function (a, b) {
	a.style.width = goog.style.getPixelStyleValue_(b, !0)
};
goog.style.getSize = function (a) {
	var b = goog.userAgent.OPERA && !goog.userAgent.isVersion("10");
	if ("none" != goog.style.getStyle_(a, "display")) return b ? new goog.math.Size(a.offsetWidth || a.clientWidth, a.offsetHeight || a.clientHeight) : new goog.math.Size(a.offsetWidth, a.offsetHeight);
	var c = a.style,
		d = c.display,
		e = c.visibility,
		f = c.position;
	c.visibility = "hidden";
	c.position = "absolute";
	c.display = "inline";
	b ? (b = a.offsetWidth || a.clientWidth, a = a.offsetHeight || a.clientHeight) : (b = a.offsetWidth, a = a.offsetHeight);
	c.display =
		d;
	c.position = f;
	c.visibility = e;
	return new goog.math.Size(b, a)
};
goog.style.getBounds = function (a) {
	var b = goog.style.getPageOffset(a),
		a = goog.style.getSize(a);
	return new goog.math.Rect(b.x, b.y, a.width, a.height)
};
goog.style.toCamelCaseCache_ = {};
goog.style.toCamelCase = function (a) {
	return goog.style.toCamelCaseCache_[a] || (goog.style.toCamelCaseCache_[a] = ("" + a).replace(/\-([a-z])/g, function (a, c) {
		return c.toUpperCase()
	}))
};
goog.style.toSelectorCaseCache_ = {};
goog.style.toSelectorCase = function (a) {
	return goog.style.toSelectorCaseCache_[a] || (goog.style.toSelectorCaseCache_[a] = a.replace(/([A-Z])/g, "-$1").toLowerCase())
};
goog.style.getOpacity = function (a) {
	var b = a.style,
		a = "";
	"opacity" in b ? a = b.opacity : "MozOpacity" in b ? a = b.MozOpacity : "filter" in b && (b = b.filter.match(/alpha\(opacity=([\d.]+)\)/)) && (a = "" + b[1] / 100);
	return "" == a ? a : Number(a)
};
goog.style.setOpacity = function (a, b) {
	var c = a.style;
	"opacity" in c ? c.opacity = b : "MozOpacity" in c ? c.MozOpacity = b : "filter" in c && (c.filter = "" === b ? "" : "alpha(opacity=" + 100 * b + ")")
};
goog.style.setTransparentBackgroundImage = function (a, b) {
	var c = a.style;
	goog.userAgent.IE && !goog.userAgent.isVersion("8") ? c.filter = 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src="' + b + '", sizingMethod="crop")' : (c.backgroundImage = "url(" + b + ")", c.backgroundPosition = "top left", c.backgroundRepeat = "no-repeat")
};
goog.style.clearTransparentBackgroundImage = function (a) {
	a = a.style;
	"filter" in a ? a.filter = "" : a.backgroundImage = "none"
};
goog.style.showElement = function (a, b) {
	a.style.display = b ? "" : "none"
};
goog.style.isElementShown = function (a) {
	return "none" != a.style.display
};
goog.style.installStyles = function (a, b) {
	var c = goog.dom.getDomHelper(b),
		d = null;
	if (goog.userAgent.IE) d = c.getDocument().createStyleSheet(), goog.style.setStyles(d, a);
	else {
		var e = c.getElementsByTagNameAndClass("head")[0];
		e || (d = c.getElementsByTagNameAndClass("body")[0], e = c.createDom("head"), d.parentNode.insertBefore(e, d));
		d = c.createDom("style");
		goog.style.setStyles(d, a);
		c.appendChild(e, d)
	}
	return d
};
goog.style.uninstallStyles = function (a) {
	goog.dom.removeNode(a.ownerNode || a.owningElement || a)
};
goog.style.setStyles = function (a, b) {
	goog.userAgent.IE ? a.cssText = b : a[goog.userAgent.WEBKIT ? "innerText" : "innerHTML"] = b
};
goog.style.setPreWrap = function (a) {
	a = a.style;
	goog.userAgent.IE && !goog.userAgent.isVersion("8") ? (a.whiteSpace = "pre", a.wordWrap = "break-word") : a.whiteSpace = goog.userAgent.GECKO ? "-moz-pre-wrap" : goog.userAgent.OPERA ? "-o-pre-wrap" : "pre-wrap"
};
goog.style.setInlineBlock = function (a) {
	a = a.style;
	a.position = "relative";
	goog.userAgent.IE && !goog.userAgent.isVersion("8") ? (a.zoom = "1", a.display = "inline") : a.display = goog.userAgent.GECKO ? goog.userAgent.isVersion("1.9a") ? "inline-block" : "-moz-inline-box" : "inline-block"
};
goog.style.isRightToLeft = function (a) {
	return "rtl" == goog.style.getStyle_(a, "direction")
};
goog.style.unselectableStyle_ = goog.userAgent.GECKO ? "MozUserSelect" : goog.userAgent.WEBKIT ? "WebkitUserSelect" : null;
goog.style.isUnselectable = function (a) {
	return goog.style.unselectableStyle_ ? "none" == a.style[goog.style.unselectableStyle_].toLowerCase() : goog.userAgent.IE || goog.userAgent.OPERA ? "on" == a.getAttribute("unselectable") : !1
};
goog.style.setUnselectable = function (a, b, c) {
	var c = !c ? a.getElementsByTagName("*") : null,
		d = goog.style.unselectableStyle_;
	if (d) {
		if (b = b ? "none" : "", a.style[d] = b, c)
			for (var a = 0, e; e = c[a]; a++) e.style[d] = b
	} else if (goog.userAgent.IE || goog.userAgent.OPERA)
		if (b = b ? "on" : "", a.setAttribute("unselectable", b), c)
			for (a = 0; e = c[a]; a++) e.setAttribute("unselectable", b)
};
goog.style.getBorderBoxSize = function (a) {
	return new goog.math.Size(a.offsetWidth, a.offsetHeight)
};
goog.style.setBorderBoxSize = function (a, b) {
	var c = goog.dom.getOwnerDocument(a),
		d = goog.dom.getDomHelper(c).isCss1CompatMode();
	if (goog.userAgent.IE && (!d || !goog.userAgent.isVersion("8")))
		if (c = a.style, d) {
			var d = goog.style.getPaddingBox(a),
				e = goog.style.getBorderBox(a);
			c.pixelWidth = b.width - e.left - d.left - d.right - e.right;
			c.pixelHeight = b.height - e.top - d.top - d.bottom - e.bottom
		} else c.pixelWidth = b.width, c.pixelHeight = b.height;
		else goog.style.setBoxSizingSize_(a, b, "border-box")
};
goog.style.getContentBoxSize = function (a) {
	var b = goog.dom.getOwnerDocument(a),
		c = goog.userAgent.IE && a.currentStyle;
	if (c && goog.dom.getDomHelper(b).isCss1CompatMode() && "auto" != c.width && "auto" != c.height && !c.boxSizing) return b = goog.style.getIePixelValue_(a, c.width, "width", "pixelWidth"), a = goog.style.getIePixelValue_(a, c.height, "height", "pixelHeight"), new goog.math.Size(b, a);
	c = goog.style.getBorderBoxSize(a);
	b = goog.style.getPaddingBox(a);
	a = goog.style.getBorderBox(a);
	return new goog.math.Size(c.width - a.left -
		b.left - b.right - a.right, c.height - a.top - b.top - b.bottom - a.bottom)
};
goog.style.setContentBoxSize = function (a, b) {
	var c = goog.dom.getOwnerDocument(a),
		d = goog.dom.getDomHelper(c).isCss1CompatMode();
	if (goog.userAgent.IE && (!d || !goog.userAgent.isVersion("8")))
		if (c = a.style, d) c.pixelWidth = b.width, c.pixelHeight = b.height;
		else {
			var d = goog.style.getPaddingBox(a),
				e = goog.style.getBorderBox(a);
			c.pixelWidth = b.width + e.left + d.left + d.right + e.right;
			c.pixelHeight = b.height + e.top + d.top + d.bottom + e.bottom
		} else goog.style.setBoxSizingSize_(a, b, "content-box")
};
goog.style.setBoxSizingSize_ = function (a, b, c) {
	a = a.style;
	goog.userAgent.GECKO ? a.MozBoxSizing = c : goog.userAgent.WEBKIT ? a.WebkitBoxSizing = c : goog.userAgent.OPERA && !goog.userAgent.isVersion("9.50") ? c ? a.setProperty("box-sizing", c) : a.removeProperty("box-sizing") : a.boxSizing = c;
	a.width = b.width + "px";
	a.height = b.height + "px"
};
goog.style.getIePixelValue_ = function (a, b, c, d) {
	if (/^\d+px?$/.test(b)) return parseInt(b, 10);
	var e = a.style[c],
		f = a.runtimeStyle[c];
	a.runtimeStyle[c] = a.currentStyle[c];
	a.style[c] = b;
	b = a.style[d];
	a.style[c] = e;
	a.runtimeStyle[c] = f;
	return b
};
goog.style.getIePixelDistance_ = function (a, b) {
	return goog.style.getIePixelValue_(a, goog.style.getCascadedStyle(a, b), "left", "pixelLeft")
};
goog.style.getBox_ = function (a, b) {
	if (goog.userAgent.IE) {
		var c = goog.style.getIePixelDistance_(a, b + "Left"),
			d = goog.style.getIePixelDistance_(a, b + "Right"),
			e = goog.style.getIePixelDistance_(a, b + "Top"),
			f = goog.style.getIePixelDistance_(a, b + "Bottom");
		return new goog.math.Box(e, d, f, c)
	}
	c = goog.style.getComputedStyle(a, b + "Left");
	d = goog.style.getComputedStyle(a, b + "Right");
	e = goog.style.getComputedStyle(a, b + "Top");
	f = goog.style.getComputedStyle(a, b + "Bottom");
	return new goog.math.Box(parseFloat(e), parseFloat(d), parseFloat(f),
		parseFloat(c))
};
goog.style.getPaddingBox = function (a) {
	return goog.style.getBox_(a, "padding")
};
goog.style.getMarginBox = function (a) {
	return goog.style.getBox_(a, "margin")
};
goog.style.ieBorderWidthKeywords_ = {
	thin: 2,
	medium: 4,
	thick: 6
};
goog.style.getIePixelBorder_ = function (a, b) {
	if ("none" == goog.style.getCascadedStyle(a, b + "Style")) return 0;
	var c = goog.style.getCascadedStyle(a, b + "Width");
	return c in goog.style.ieBorderWidthKeywords_ ? goog.style.ieBorderWidthKeywords_[c] : goog.style.getIePixelValue_(a, c, "left", "pixelLeft")
};
goog.style.getBorderBox = function (a) {
	if (goog.userAgent.IE) {
		var b = goog.style.getIePixelBorder_(a, "borderLeft"),
			c = goog.style.getIePixelBorder_(a, "borderRight"),
			d = goog.style.getIePixelBorder_(a, "borderTop"),
			a = goog.style.getIePixelBorder_(a, "borderBottom");
		return new goog.math.Box(d, c, a, b)
	}
	b = goog.style.getComputedStyle(a, "borderLeftWidth");
	c = goog.style.getComputedStyle(a, "borderRightWidth");
	d = goog.style.getComputedStyle(a, "borderTopWidth");
	a = goog.style.getComputedStyle(a, "borderBottomWidth");
	return new goog.math.Box(parseFloat(d),
		parseFloat(c), parseFloat(a), parseFloat(b))
};
goog.style.getFontFamily = function (a) {
	var b = goog.dom.getOwnerDocument(a),
		c = "";
	if (b.body.createTextRange) {
		b = b.body.createTextRange();
		b.moveToElementText(a);
		try {
			c = b.queryCommandValue("FontName")
		} catch (d) {
			c = ""
		}
	}
	c || (c = goog.style.getStyle_(a, "fontFamily"), goog.userAgent.OPERA && goog.userAgent.LINUX && (c = c.replace(/ \[[^\]]*\]/, "")));
	a = c.split(",");
	1 < a.length && (c = a[0]);
	return goog.string.stripQuotes(c, "\"'")
};
goog.style.lengthUnitRegex_ = /[^\d]+$/;
goog.style.getLengthUnits = function (a) {
	return (a = a.match(goog.style.lengthUnitRegex_)) && a[0] || null
};
goog.style.ABSOLUTE_CSS_LENGTH_UNITS_ = {
	cm: 1,
	"in": 1,
	mm: 1,
	pc: 1,
	pt: 1
};
goog.style.CONVERTIBLE_RELATIVE_CSS_UNITS_ = {
	em: 1,
	ex: 1
};
goog.style.getFontSize = function (a) {
	var b = goog.style.getStyle_(a, "fontSize"),
		c = goog.style.getLengthUnits(b);
	if (b && "px" == c) return parseInt(b, 10);
	if (goog.userAgent.IE) {
		if (c in goog.style.ABSOLUTE_CSS_LENGTH_UNITS_) return goog.style.getIePixelValue_(a, b, "left", "pixelLeft");
		if (a.parentNode && a.parentNode.nodeType == goog.dom.NodeType.ELEMENT && c in goog.style.CONVERTIBLE_RELATIVE_CSS_UNITS_) return a = a.parentNode, c = goog.style.getStyle_(a, "fontSize"), goog.style.getIePixelValue_(a, b == c ? "1em" : b, "left", "pixelLeft")
	}
	c =
		goog.dom.createDom("span", {
			style: "visibility:hidden;position:absolute;line-height:0;padding:0;margin:0;border:0;height:1em;"
		});
	goog.dom.appendChild(a, c);
	b = c.offsetHeight;
	goog.dom.removeNode(c);
	return b
};
goog.style.parseStyleAttribute = function (a) {
	var b = {};
	goog.array.forEach(a.split(/\s*;\s*/), function (a) {
		a = a.split(/\s*:\s*/);
		2 == a.length && (b[goog.style.toCamelCase(a[0].toLowerCase())] = a[1])
	});
	return b
};
goog.style.toStyleAttribute = function (a) {
	var b = [];
	goog.object.forEach(a, function (a, d) {
		b.push(goog.style.toSelectorCase(d), ":", a, ";")
	});
	return b.join("")
};
goog.style.setFloat = function (a, b) {
	a.style[goog.userAgent.IE ? "styleFloat" : "cssFloat"] = b
};
goog.style.getFloat = function (a) {
	return a.style[goog.userAgent.IE ? "styleFloat" : "cssFloat"] || ""
};
goog.style.getScrollbarWidth = function () {
	var a = goog.dom.createElement("div");
	a.style.cssText = "visibility:hidden;overflow:scroll;position:absolute;top:0;width:100px;height:100px";
	goog.dom.appendChild(goog.dom.getDocument().body, a);
	var b = a.offsetWidth - a.clientWidth;
	goog.dom.removeNode(a);
	return b
};
goog.events = {};
goog.events.EventType = {
	CLICK: "click",
	DBLCLICK: "dblclick",
	MOUSEDOWN: "mousedown",
	MOUSEUP: "mouseup",
	MOUSEOVER: "mouseover",
	MOUSEOUT: "mouseout",
	MOUSEMOVE: "mousemove",
	SELECTSTART: "selectstart",
	KEYPRESS: "keypress",
	KEYDOWN: "keydown",
	KEYUP: "keyup",
	BLUR: "blur",
	FOCUS: "focus",
	DEACTIVATE: "deactivate",
	FOCUSIN: goog.userAgent.IE ? "focusin" : "DOMFocusIn",
	FOCUSOUT: goog.userAgent.IE ? "focusout" : "DOMFocusOut",
	CHANGE: "change",
	SELECT: "select",
	SUBMIT: "submit",
	INPUT: "input",
	PROPERTYCHANGE: "propertychange",
	DRAGSTART: "dragstart",
	DRAGENTER: "dragenter",
	DRAGOVER: "dragover",
	DRAGLEAVE: "dragleave",
	DROP: "drop",
	TOUCHSTART: "touchstart",
	TOUCHMOVE: "touchmove",
	TOUCHEND: "touchend",
	TOUCHCANCEL: "touchcancel",
	CONTEXTMENU: "contextmenu",
	ERROR: "error",
	HELP: "help",
	LOAD: "load",
	LOSECAPTURE: "losecapture",
	READYSTATECHANGE: "readystatechange",
	RESIZE: "resize",
	SCROLL: "scroll",
	UNLOAD: "unload",
	HASHCHANGE: "hashchange",
	PAGEHIDE: "pagehide",
	PAGESHOW: "pageshow",
	POPSTATE: "popstate",
	COPY: "copy",
	PASTE: "paste",
	CUT: "cut"
};
goog.editor = {};
goog.editor.defines = {};
goog.editor.defines.USE_CONTENTEDITABLE_IN_FIREFOX_3 = !1;
goog.userAgent.product = {};
goog.userAgent.product.ASSUME_FIREFOX = !1;
goog.userAgent.product.ASSUME_CAMINO = !1;
goog.userAgent.product.ASSUME_IPHONE = !1;
goog.userAgent.product.ASSUME_IPAD = !1;
goog.userAgent.product.ASSUME_ANDROID = !1;
goog.userAgent.product.ASSUME_CHROME = !1;
goog.userAgent.product.ASSUME_SAFARI = !1;
goog.userAgent.product.PRODUCT_KNOWN_ = goog.userAgent.ASSUME_IE || goog.userAgent.ASSUME_OPERA || goog.userAgent.product.ASSUME_FIREFOX || goog.userAgent.product.ASSUME_CAMINO || goog.userAgent.product.ASSUME_IPHONE || goog.userAgent.product.ASSUME_IPAD || goog.userAgent.product.ASSUME_ANDROID || goog.userAgent.product.ASSUME_CHROME || goog.userAgent.product.ASSUME_SAFARI;
goog.userAgent.product.init_ = function () {
	goog.userAgent.product.detectedFirefox_ = !1;
	goog.userAgent.product.detectedCamino_ = !1;
	goog.userAgent.product.detectedIphone_ = !1;
	goog.userAgent.product.detectedIpad_ = !1;
	goog.userAgent.product.detectedAndroid_ = !1;
	goog.userAgent.product.detectedChrome_ = !1;
	goog.userAgent.product.detectedSafari_ = !1;
	var a = goog.userAgent.getUserAgentString();
	a && (-1 != a.indexOf("Firefox") ? goog.userAgent.product.detectedFirefox_ = !0 : -1 != a.indexOf("Camino") ? goog.userAgent.product.detectedCamino_ = !0 : -1 != a.indexOf("iPhone") || -1 != a.indexOf("iPod") ? goog.userAgent.product.detectedIphone_ = !0 : -1 != a.indexOf("iPad") ? goog.userAgent.product.detectedIpad_ = !0 : -1 != a.indexOf("Android") ? goog.userAgent.product.detectedAndroid_ = !0 : -1 != a.indexOf("Chrome") ? goog.userAgent.product.detectedChrome_ = !0 : -1 != a.indexOf("Safari") && (goog.userAgent.product.detectedSafari_ = !0))
};
goog.userAgent.product.PRODUCT_KNOWN_ || goog.userAgent.product.init_();
goog.userAgent.product.OPERA = goog.userAgent.OPERA;
goog.userAgent.product.IE = goog.userAgent.IE;
goog.userAgent.product.FIREFOX = goog.userAgent.product.PRODUCT_KNOWN_ ? goog.userAgent.product.ASSUME_FIREFOX : goog.userAgent.product.detectedFirefox_;
goog.userAgent.product.CAMINO = goog.userAgent.product.PRODUCT_KNOWN_ ? goog.userAgent.product.ASSUME_CAMINO : goog.userAgent.product.detectedCamino_;
goog.userAgent.product.IPHONE = goog.userAgent.product.PRODUCT_KNOWN_ ? goog.userAgent.product.ASSUME_IPHONE : goog.userAgent.product.detectedIphone_;
goog.userAgent.product.IPAD = goog.userAgent.product.PRODUCT_KNOWN_ ? goog.userAgent.product.ASSUME_IPAD : goog.userAgent.product.detectedIpad_;
goog.userAgent.product.ANDROID = goog.userAgent.product.PRODUCT_KNOWN_ ? goog.userAgent.product.ASSUME_ANDROID : goog.userAgent.product.detectedAndroid_;
goog.userAgent.product.CHROME = goog.userAgent.product.PRODUCT_KNOWN_ ? goog.userAgent.product.ASSUME_CHROME : goog.userAgent.product.detectedChrome_;
goog.userAgent.product.SAFARI = goog.userAgent.product.PRODUCT_KNOWN_ ? goog.userAgent.product.ASSUME_SAFARI : goog.userAgent.product.detectedSafari_;
goog.userAgent.product.determineVersion_ = function () {
	var a = "",
		b, c;
	if (goog.userAgent.product.FIREFOX) b = /Firefox\/([0-9.]+)/;
	else {
		if (goog.userAgent.product.IE || goog.userAgent.product.OPERA) return goog.userAgent.VERSION;
		goog.userAgent.product.CHROME ? b = /Chrome\/([0-9.]+)/ : goog.userAgent.product.SAFARI ? b = /Safari\/([0-9.]+)/ : goog.userAgent.product.IPHONE || goog.userAgent.product.IPAD ? (b = /Version\/(\S+).*Mobile\/(\S+)/, c = !0) : goog.userAgent.product.ANDROID ? b = /Android\s+([0-9.]+)(?:.*Version\/([0-9.]+))?/ : goog.userAgent.product.CAMINO &&
			(b = /Camino\/([0-9.]+)/)
	}
	b && (a = (a = b.exec(goog.userAgent.getUserAgentString())) ? c ? a[1] + "." + a[2] : a[2] || a[1] : "");
	return a
};
goog.userAgent.product.VERSION = goog.userAgent.product.determineVersion_();
goog.userAgent.product.isVersion = function (a) {
	return 0 <= goog.string.compareVersions(goog.userAgent.product.VERSION, a)
};
goog.editor.BrowserFeature = {
	HAS_IE_RANGES: goog.userAgent.IE,
	HAS_W3C_RANGES: goog.userAgent.GECKO || goog.userAgent.WEBKIT || goog.userAgent.OPERA,
	HAS_CONTENT_EDITABLE: goog.userAgent.IE || goog.userAgent.WEBKIT || goog.userAgent.OPERA || goog.editor.defines.USE_CONTENTEDITABLE_IN_FIREFOX_3 && goog.userAgent.GECKO && goog.userAgent.isVersion("1.9"),
	USE_MUTATION_EVENTS: goog.userAgent.GECKO,
	HAS_DOM_SUBTREE_MODIFIED_EVENT: goog.userAgent.WEBKIT || goog.editor.defines.USE_CONTENTEDITABLE_IN_FIREFOX_3 && goog.userAgent.GECKO &&
		goog.userAgent.isVersion("1.9"),
	HAS_DOCUMENT_INDEPENDENT_NODES: goog.userAgent.GECKO,
	PUTS_CURSOR_BEFORE_FIRST_BLOCK_ELEMENT_ON_FOCUS: goog.userAgent.GECKO,
	CLEARS_SELECTION_WHEN_FOCUS_LEAVES: goog.userAgent.IE || goog.userAgent.WEBKIT || goog.userAgent.OPERA,
	HAS_UNSELECTABLE_STYLE: goog.userAgent.GECKO || goog.userAgent.WEBKIT,
	FORMAT_BLOCK_WORKS_FOR_BLOCKQUOTES: goog.userAgent.GECKO || goog.userAgent.WEBKIT || goog.userAgent.OPERA,
	CREATES_MULTIPLE_BLOCKQUOTES: goog.userAgent.WEBKIT || goog.userAgent.OPERA,
	WRAPS_BLOCKQUOTE_IN_DIVS: goog.userAgent.OPERA,
	PREFERS_READY_STATE_CHANGE_EVENT: goog.userAgent.IE,
	TAB_FIRES_KEYPRESS: !goog.userAgent.IE,
	NEEDS_99_WIDTH_IN_STANDARDS_MODE: goog.userAgent.IE,
	USE_DOCUMENT_FOR_KEY_EVENTS: goog.userAgent.GECKO && !goog.editor.defines.USE_CONTENTEDITABLE_IN_FIREFOX_3,
	SHOWS_CUSTOM_ATTRS_IN_INNER_HTML: goog.userAgent.IE,
	COLLAPSES_EMPTY_NODES: goog.userAgent.GECKO || goog.userAgent.WEBKIT || goog.userAgent.OPERA,
	CONVERT_TO_B_AND_I_TAGS: goog.userAgent.GECKO || goog.userAgent.OPERA,
	TABS_THROUGH_IMAGES: goog.userAgent.IE,
	UNESCAPES_URLS_WITHOUT_ASKING: goog.userAgent.IE && !goog.userAgent.isVersion("7.0"),
	HAS_STYLE_WITH_CSS: goog.userAgent.GECKO && goog.userAgent.isVersion("1.8") || goog.userAgent.WEBKIT || goog.userAgent.OPERA,
	FOLLOWS_EDITABLE_LINKS: goog.userAgent.WEBKIT,
	HAS_ACTIVE_ELEMENT: goog.userAgent.IE || goog.userAgent.OPERA || goog.userAgent.GECKO && goog.userAgent.isVersion("1.9"),
	HAS_SET_CAPTURE: goog.userAgent.IE,
	EATS_EMPTY_BACKGROUND_COLOR: goog.userAgent.GECKO || goog.userAgent.WEBKIT,
	SUPPORTS_FOCUSIN: goog.userAgent.IE || goog.userAgent.OPERA,
	SELECTS_IMAGES_ON_CLICK: goog.userAgent.IE ||
		goog.userAgent.OPERA,
	MOVES_STYLE_TO_HEAD: goog.userAgent.WEBKIT,
	COLLAPSES_SELECTION_ONMOUSEDOWN: goog.userAgent.OPERA,
	CARET_INSIDE_SELECTION: goog.userAgent.OPERA,
	FOCUSES_EDITABLE_BODY_ON_HTML_CLICK: goog.userAgent.IE || goog.userAgent.GECKO || goog.userAgent.WEBKIT,
	USES_KEYDOWN: goog.userAgent.IE || goog.userAgent.WEBKIT && goog.userAgent.isVersion("525"),
	ADDS_NBSPS_IN_REMOVE_FORMAT: goog.userAgent.WEBKIT && !goog.userAgent.isVersion("531"),
	GETS_STUCK_IN_LINKS: goog.userAgent.WEBKIT && !goog.userAgent.isVersion("528"),
	NORMALIZE_CORRUPTS_EMPTY_TEXT_NODES: goog.userAgent.GECKO && goog.userAgent.isVersion("1.9") || goog.userAgent.IE || goog.userAgent.OPERA || goog.userAgent.WEBKIT && goog.userAgent.isVersion("531"),
	NORMALIZE_CORRUPTS_ALL_TEXT_NODES: goog.userAgent.IE,
	NESTS_SUBSCRIPT_SUPERSCRIPT: goog.userAgent.IE || goog.userAgent.GECKO || goog.userAgent.OPERA,
	CAN_SELECT_EMPTY_ELEMENT: !goog.userAgent.IE && !goog.userAgent.WEBKIT,
	FORGETS_FORMATTING_WHEN_LISTIFYING: goog.userAgent.GECKO || goog.userAgent.WEBKIT && !goog.userAgent.isVersion("526"),
	LEAVES_P_WHEN_REMOVING_LISTS: goog.userAgent.IE || goog.userAgent.OPERA,
	CAN_LISTIFY_BR: !goog.userAgent.IE && !goog.userAgent.OPERA,
	DOESNT_OVERRIDE_FONT_SIZE_IN_STYLE_ATTR: !goog.userAgent.WEBKIT,
	SUPPORTS_HTML5_FILE_DRAGGING: goog.userAgent.product.CHROME && goog.userAgent.product.isVersion("4") || goog.userAgent.product.SAFARI && goog.userAgent.product.isVersion("533")
};
goog.editor.style = {};
goog.editor.style.getComputedOrCascadedStyle_ = function (a, b) {
	return a.nodeType != goog.dom.NodeType.ELEMENT ? null : goog.userAgent.IE ? goog.style.getCascadedStyle(a, b) : goog.style.getComputedStyle(a, b)
};
goog.editor.style.isDisplayBlock = function (a) {
	return "block" == goog.editor.style.getComputedOrCascadedStyle_(a, "display")
};
goog.editor.style.isContainer = function (a) {
	var b = a && a.nodeName.toLowerCase();
	return !(!a || !goog.editor.style.isDisplayBlock(a) && !("td" == b || "table" == b || "li" == b))
};
goog.editor.style.getContainer = function (a) {
	return goog.dom.getAncestor(a, goog.editor.style.isContainer, !0)
};
goog.editor.style.SELECTABLE_INPUT_TYPES_ = goog.object.createSet("text", "file", "url");
goog.editor.style.cancelMouseDownHelper_ = function (a) {
	var b = a.target.tagName;
	b != goog.dom.TagName.TEXTAREA && b != goog.dom.TagName.INPUT && a.preventDefault()
};
goog.editor.style.makeUnselectable = function (a, b) {
	goog.editor.BrowserFeature.HAS_UNSELECTABLE_STYLE && b.listen(a, goog.events.EventType.MOUSEDOWN, goog.editor.style.cancelMouseDownHelper_, !0);
	goog.style.setUnselectable(a, !0);
	for (var c = a.getElementsByTagName(goog.dom.TagName.INPUT), d = 0, e = c.length; d < e; d++) {
		var f = c[d];
		f.type in goog.editor.style.SELECTABLE_INPUT_TYPES_ && goog.editor.style.makeSelectable(f)
	}
	goog.array.forEach(a.getElementsByTagName(goog.dom.TagName.TEXTAREA), goog.editor.style.makeSelectable)
};
goog.editor.style.makeSelectable = function (a) {
	goog.style.setUnselectable(a, !1);
	if (goog.editor.BrowserFeature.HAS_UNSELECTABLE_STYLE)
		for (var b = a, a = a.parentNode; a && a.tagName != goog.dom.TagName.HTML;) {
			if (goog.style.isUnselectable(a)) {
				goog.style.setUnselectable(a, !1, !0);
				for (var c = 0, d = a.childNodes.length; c < d; c++) {
					var e = a.childNodes[c];
					e != b && e.nodeType == goog.dom.NodeType.ELEMENT && goog.style.setUnselectable(a.childNodes[c], !0)
				}
			}
			b = a;
			a = a.parentNode
		}
};
goog.iter = {};
goog.iter.StopIteration = "StopIteration" in goog.global ? goog.global.StopIteration : Error("StopIteration");
goog.iter.Iterator = function () {};
goog.iter.Iterator.prototype.next = function () {
	throw goog.iter.StopIteration;
};
goog.iter.Iterator.prototype.__iterator__ = function () {
	return this
};
goog.iter.toIterator = function (a) {
	if (a instanceof goog.iter.Iterator) return a;
	if ("function" == typeof a.__iterator__) return a.__iterator__(!1);
	if (goog.isArrayLike(a)) {
		var b = 0,
			c = new goog.iter.Iterator;
		c.next = function () {
			for (;;) {
				if (b >= a.length) throw goog.iter.StopIteration;
				if (b in a) return a[b++];
				b++
			}
		};
		return c
	}
	throw Error("Not implemented");
};
goog.iter.forEach = function (a, b, c) {
	if (goog.isArrayLike(a)) try {
		goog.array.forEach(a, b, c)
	} catch (d) {
		if (d !== goog.iter.StopIteration) throw d;
	} else {
		a = goog.iter.toIterator(a);
		try {
			for (;;) b.call(c, a.next(), void 0, a)
		} catch (e) {
			if (e !== goog.iter.StopIteration) throw e;
		}
	}
};
goog.iter.filter = function (a, b, c) {
	var a = goog.iter.toIterator(a),
		d = new goog.iter.Iterator;
	d.next = function () {
		for (;;) {
			var d = a.next();
			if (b.call(c, d, void 0, a)) return d
		}
	};
	return d
};
goog.iter.range = function (a, b, c) {
	var d = 0,
		e = a,
		f = c || 1;
	1 < arguments.length && (d = a, e = b);
	if (0 == f) throw Error("Range step argument must not be zero");
	var g = new goog.iter.Iterator;
	g.next = function () {
		if (f > 0 && d >= e || f < 0 && d <= e) throw goog.iter.StopIteration;
		var a = d;
		d = d + f;
		return a
	};
	return g
};
goog.iter.join = function (a, b) {
	return goog.iter.toArray(a).join(b)
};
goog.iter.map = function (a, b, c) {
	var a = goog.iter.toIterator(a),
		d = new goog.iter.Iterator;
	d.next = function () {
		for (;;) {
			var d = a.next();
			return b.call(c, d, void 0, a)
		}
	};
	return d
};
goog.iter.reduce = function (a, b, c, d) {
	var e = c;
	goog.iter.forEach(a, function (a) {
		e = b.call(d, e, a)
	});
	return e
};
goog.iter.some = function (a, b, c) {
	a = goog.iter.toIterator(a);
	try {
		for (;;)
			if (b.call(c, a.next(), void 0, a)) return !0
	} catch (d) {
		if (d !== goog.iter.StopIteration) throw d;
	}
	return !1
};
goog.iter.every = function (a, b, c) {
	a = goog.iter.toIterator(a);
	try {
		for (;;)
			if (!b.call(c, a.next(), void 0, a)) return !1
	} catch (d) {
		if (d !== goog.iter.StopIteration) throw d;
	}
	return !0
};
goog.iter.chain = function (a) {
	var b = arguments,
		c = b.length,
		d = 0,
		e = new goog.iter.Iterator;
	e.next = function () {
		try {
			if (d >= c) throw goog.iter.StopIteration;
			return goog.iter.toIterator(b[d]).next()
		} catch (a) {
			if (a !== goog.iter.StopIteration || d >= c) throw a;
			d++;
			return this.next()
		}
	};
	return e
};
goog.iter.dropWhile = function (a, b, c) {
	var a = goog.iter.toIterator(a),
		d = new goog.iter.Iterator,
		e = !0;
	d.next = function () {
		for (;;) {
			var d = a.next();
			if (!e || !b.call(c, d, void 0, a)) return e = !1, d
		}
	};
	return d
};
goog.iter.takeWhile = function (a, b, c) {
	var a = goog.iter.toIterator(a),
		d = new goog.iter.Iterator,
		e = !0;
	d.next = function () {
		for (;;)
			if (e) {
				var d = a.next();
				if (b.call(c, d, void 0, a)) return d;
				e = !1
			} else throw goog.iter.StopIteration;
	};
	return d
};
goog.iter.toArray = function (a) {
	if (goog.isArrayLike(a)) return goog.array.toArray(a);
	var a = goog.iter.toIterator(a),
		b = [];
	goog.iter.forEach(a, function (a) {
		b.push(a)
	});
	return b
};
goog.iter.equals = function (a, b) {
	var a = goog.iter.toIterator(a),
		b = goog.iter.toIterator(b),
		c, d;
	try {
		for (;;) {
			c = d = !1;
			var e = a.next();
			c = !0;
			var f = b.next();
			d = !0;
			if (e != f) break
		}
	} catch (g) {
		if (g !== goog.iter.StopIteration) throw g;
		if (c && !d) return !1;
		if (!d) try {
			b.next()
		} catch (h) {
			if (h !== goog.iter.StopIteration) throw h;
			return !0
		}
	}
	return !1
};
goog.iter.nextOrValue = function (a, b) {
	try {
		return goog.iter.toIterator(a).next()
	} catch (c) {
		if (c != goog.iter.StopIteration) throw c;
		return b
	}
};
goog.iter.product = function (a) {
	if (goog.array.some(arguments, function (a) {
		return !a.length
	}) || !arguments.length) return new goog.iter.Iterator;
	var b = new goog.iter.Iterator,
		c = arguments,
		d = goog.array.repeat(0, c.length);
	b.next = function () {
		if (d) {
			for (var a = goog.array.map(d, function (a, b) {
				return c[b][a]
			}), b = d.length - 1; 0 <= b; b--) {
				goog.asserts.assert(d);
				if (d[b] < c[b].length - 1) {
					d[b]++;
					break
				}
				if (0 == b) {
					d = null;
					break
				}
				d[b] = 0
			}
			return a
		}
		throw goog.iter.StopIteration;
	};
	return b
};
goog.dom.iter = {};
goog.dom.iter.SiblingIterator = function (a, b, c) {
	this.node_ = a;
	this.reverse_ = !! c;
	a && !b && this.next()
};
goog.inherits(goog.dom.iter.SiblingIterator, goog.iter.Iterator);
goog.dom.iter.SiblingIterator.prototype.next = function () {
	var a = this.node_;
	if (!a) throw goog.iter.StopIteration;
	this.node_ = this.reverse_ ? a.previousSibling : a.nextSibling;
	return a
};
goog.dom.iter.ChildIterator = function (a, b, c) {
	goog.isDef(c) || (c = b && a.childNodes.length ? a.childNodes.length - 1 : 0);
	goog.dom.iter.SiblingIterator.call(this, a.childNodes[c], !0, b)
};
goog.inherits(goog.dom.iter.ChildIterator, goog.dom.iter.SiblingIterator);
goog.dom.iter.AncestorIterator = function (a, b) {
	(this.node_ = a) && !b && this.next()
};
goog.inherits(goog.dom.iter.AncestorIterator, goog.iter.Iterator);
goog.dom.iter.AncestorIterator.prototype.next = function () {
	var a = this.node_;
	if (!a) throw goog.iter.StopIteration;
	this.node_ = a.parentNode;
	return a
};
goog.editor.node = {};
goog.editor.node.BLOCK_TAG_NAMES_ = goog.object.createSet("ADDRESS", "BLOCKQUOTE", "BODY", "CAPTION", "CENTER", "COL", "COLGROUP", "DIR", "DIV", "DL", "DD", "DT", "FIELDSET", "FORM", "H1", "H2", "H3", "H4", "H5", "H6", "HR", "ISINDEX", "OL", "LI", "MAP", "MENU", "OPTGROUP", "OPTION", "P", "PRE", "TABLE", "TBODY", "TD", "TFOOT", "TH", "THEAD", "TR", "TL", "UL");
goog.editor.node.NON_EMPTY_TAGS_ = goog.object.createSet(goog.dom.TagName.IMG, goog.dom.TagName.IFRAME, "EMBED");
goog.editor.node.isStandardsMode = function (a) {
	return goog.dom.getDomHelper(a).isCss1CompatMode()
};
goog.editor.node.getRightMostLeaf = function (a) {
	for (var b; b = goog.editor.node.getLastChild(a);) a = b;
	return a
};
goog.editor.node.getLeftMostLeaf = function (a) {
	for (var b; b = goog.editor.node.getFirstChild(a);) a = b;
	return a
};
goog.editor.node.getFirstChild = function (a) {
	return goog.editor.node.getChildHelper_(a, !1)
};
goog.editor.node.getLastChild = function (a) {
	return goog.editor.node.getChildHelper_(a, !0)
};
goog.editor.node.getPreviousSibling = function (a) {
	return goog.editor.node.getFirstValue_(goog.iter.filter(new goog.dom.iter.SiblingIterator(a, !1, !0), goog.editor.node.isImportant))
};
goog.editor.node.getNextSibling = function (a) {
	return goog.editor.node.getFirstValue_(goog.iter.filter(new goog.dom.iter.SiblingIterator(a), goog.editor.node.isImportant))
};
goog.editor.node.getChildHelper_ = function (a, b) {
	return !a || a.nodeType != goog.dom.NodeType.ELEMENT ? null : goog.editor.node.getFirstValue_(goog.iter.filter(new goog.dom.iter.ChildIterator(a, b), goog.editor.node.isImportant))
};
goog.editor.node.getFirstValue_ = function (a) {
	try {
		return a.next()
	} catch (b) {
		return null
	}
};
goog.editor.node.isImportant = function (a) {
	return a.nodeType == goog.dom.NodeType.ELEMENT || a.nodeType == goog.dom.NodeType.TEXT && !goog.editor.node.isAllNonNbspWhiteSpace(a)
};
goog.editor.node.isAllNonNbspWhiteSpace = function (a) {
	return goog.string.isBreakingWhitespace(a.nodeValue)
};
goog.editor.node.isEmpty = function (a, b) {
	var c = goog.dom.getRawTextContent(a);
	if (a.getElementsByTagName)
		for (var d in goog.editor.node.NON_EMPTY_TAGS_)
			if (a.tagName == d || 0 < a.getElementsByTagName(d).length) return !1;
	return !b && c == goog.string.Unicode.NBSP || goog.string.isBreakingWhitespace(c)
};
goog.editor.node.getActiveElementIE = function (a) {
	try {
		return a.activeElement
	} catch (b) {}
	return null
};
goog.editor.node.getLength = function (a) {
	return a.length || a.childNodes.length
};
goog.editor.node.findInChildren = function (a, b) {
	for (var c = 0, d = a.childNodes.length; c < d; c++)
		if (b(a.childNodes[c])) return c;
	return null
};
goog.editor.node.findHighestMatchingAncestor = function (a, b) {
	for (var c = a.parentNode, d = null; c && b(c);) d = c, c = c.parentNode;
	return d
};
goog.editor.node.isBlockTag = function (a) {
	return !!goog.editor.node.BLOCK_TAG_NAMES_[a.tagName]
};
goog.editor.node.skipEmptyTextNodes = function (a) {
	for (; a && a.nodeType == goog.dom.NodeType.TEXT && !a.nodeValue;) a = a.nextSibling;
	return a
};
goog.editor.node.isEditableContainer = function (a) {
	return a.getAttribute && "true" == a.getAttribute("g_editable")
};
goog.editor.node.isEditable = function (a) {
	return !!goog.dom.getAncestor(a, goog.editor.node.isEditableContainer)
};
goog.editor.node.findTopMostEditableAncestor = function (a, b) {
	for (var c = null; a && !goog.editor.node.isEditableContainer(a);) b(a) && (c = a), a = a.parentNode;
	return c
};
goog.editor.node.splitDomTreeAt = function (a, b, c) {
	for (var d; a != c && (d = a.parentNode);) b = goog.editor.node.getSecondHalfOfNode_(d, a, b), a = d;
	return b
};
goog.editor.node.getSecondHalfOfNode_ = function (a, b, c) {
	for (a = a.cloneNode(!1); b.nextSibling;) goog.dom.appendChild(a, b.nextSibling);
	c && a.insertBefore(c, a.firstChild);
	return a
};
goog.editor.node.transferChildren = function (a, b) {
	goog.dom.append(a, b.childNodes)
};
goog.dom.RangeEndpoint = {
	START: 1,
	END: 0
};
goog.structs = {};
goog.structs.getCount = function (a) {
	return "function" == typeof a.getCount ? a.getCount() : goog.isArrayLike(a) || goog.isString(a) ? a.length : goog.object.getCount(a)
};
goog.structs.getValues = function (a) {
	if ("function" == typeof a.getValues) return a.getValues();
	if (goog.isString(a)) return a.split("");
	if (goog.isArrayLike(a)) {
		for (var b = [], c = a.length, d = 0; d < c; d++) b.push(a[d]);
		return b
	}
	return goog.object.getValues(a)
};
goog.structs.getKeys = function (a) {
	if ("function" == typeof a.getKeys) return a.getKeys();
	if ("function" != typeof a.getValues) {
		if (goog.isArrayLike(a) || goog.isString(a)) {
			for (var b = [], a = a.length, c = 0; c < a; c++) b.push(c);
			return b
		}
		return goog.object.getKeys(a)
	}
};
goog.structs.contains = function (a, b) {
	return "function" == typeof a.contains ? a.contains(b) : "function" == typeof a.containsValue ? a.containsValue(b) : goog.isArrayLike(a) || goog.isString(a) ? goog.array.contains(a, b) : goog.object.containsValue(a, b)
};
goog.structs.isEmpty = function (a) {
	return "function" == typeof a.isEmpty ? a.isEmpty() : goog.isArrayLike(a) || goog.isString(a) ? goog.array.isEmpty(a) : goog.object.isEmpty(a)
};
goog.structs.clear = function (a) {
	"function" == typeof a.clear ? a.clear() : goog.isArrayLike(a) ? goog.array.clear(a) : goog.object.clear(a)
};
goog.structs.forEach = function (a, b, c) {
	if ("function" == typeof a.forEach) a.forEach(b, c);
	else if (goog.isArrayLike(a) || goog.isString(a)) goog.array.forEach(a, b, c);
	else
		for (var d = goog.structs.getKeys(a), e = goog.structs.getValues(a), f = e.length, g = 0; g < f; g++) b.call(c, e[g], d && d[g], a)
};
goog.structs.filter = function (a, b, c) {
	if ("function" == typeof a.filter) return a.filter(b, c);
	if (goog.isArrayLike(a) || goog.isString(a)) return goog.array.filter(a, b, c);
	var d, e = goog.structs.getKeys(a),
		f = goog.structs.getValues(a),
		g = f.length;
	if (e) {
		d = {};
		for (var h = 0; h < g; h++) b.call(c, f[h], e[h], a) && (d[e[h]] = f[h])
	} else {
		d = [];
		for (h = 0; h < g; h++) b.call(c, f[h], void 0, a) && d.push(f[h])
	}
	return d
};
goog.structs.map = function (a, b, c) {
	if ("function" == typeof a.map) return a.map(b, c);
	if (goog.isArrayLike(a) || goog.isString(a)) return goog.array.map(a, b, c);
	var d, e = goog.structs.getKeys(a),
		f = goog.structs.getValues(a),
		g = f.length;
	if (e) {
		d = {};
		for (var h = 0; h < g; h++) d[e[h]] = b.call(c, f[h], e[h], a)
	} else {
		d = [];
		for (h = 0; h < g; h++) d[h] = b.call(c, f[h], void 0, a)
	}
	return d
};
goog.structs.some = function (a, b, c) {
	if ("function" == typeof a.some) return a.some(b, c);
	if (goog.isArrayLike(a) || goog.isString(a)) return goog.array.some(a, b, c);
	for (var d = goog.structs.getKeys(a), e = goog.structs.getValues(a), f = e.length, g = 0; g < f; g++)
		if (b.call(c, e[g], d && d[g], a)) return !0;
	return !1
};
goog.structs.every = function (a, b, c) {
	if ("function" == typeof a.every) return a.every(b, c);
	if (goog.isArrayLike(a) || goog.isString(a)) return goog.array.every(a, b, c);
	for (var d = goog.structs.getKeys(a), e = goog.structs.getValues(a), f = e.length, g = 0; g < f; g++)
		if (!b.call(c, e[g], d && d[g], a)) return !1;
	return !0
};
goog.structs.Map = function (a, b) {
	this.map_ = {};
	this.keys_ = [];
	var c = arguments.length;
	if (1 < c) {
		if (c % 2) throw Error("Uneven number of arguments");
		for (var d = 0; d < c; d += 2) this.set(arguments[d], arguments[d + 1])
	} else a && this.addAll(a)
};
goog.structs.Map.prototype.count_ = 0;
goog.structs.Map.prototype.version_ = 0;
goog.structs.Map.prototype.getCount = function () {
	return this.count_
};
goog.structs.Map.prototype.getValues = function () {
	this.cleanupKeysArray_();
	for (var a = [], b = 0; b < this.keys_.length; b++) a.push(this.map_[this.keys_[b]]);
	return a
};
goog.structs.Map.prototype.getKeys = function () {
	this.cleanupKeysArray_();
	return this.keys_.concat()
};
goog.structs.Map.prototype.containsKey = function (a) {
	return goog.structs.Map.hasKey_(this.map_, a)
};
goog.structs.Map.prototype.containsValue = function (a) {
	for (var b = 0; b < this.keys_.length; b++) {
		var c = this.keys_[b];
		if (goog.structs.Map.hasKey_(this.map_, c) && this.map_[c] == a) return !0
	}
	return !1
};
goog.structs.Map.prototype.equals = function (a, b) {
	if (this === a) return !0;
	if (this.count_ != a.getCount()) return !1;
	var c = b || goog.structs.Map.defaultEquals;
	this.cleanupKeysArray_();
	for (var d, e = 0; d = this.keys_[e]; e++)
		if (!c(this.get(d), a.get(d))) return !1;
	return !0
};
goog.structs.Map.defaultEquals = function (a, b) {
	return a === b
};
goog.structs.Map.prototype.isEmpty = function () {
	return 0 == this.count_
};
goog.structs.Map.prototype.clear = function () {
	this.map_ = {};
	this.version_ = this.count_ = this.keys_.length = 0
};
goog.structs.Map.prototype.remove = function (a) {
	return goog.structs.Map.hasKey_(this.map_, a) ? (delete this.map_[a], this.count_--, this.version_++, this.keys_.length > 2 * this.count_ && this.cleanupKeysArray_(), !0) : !1
};
goog.structs.Map.prototype.cleanupKeysArray_ = function () {
	if (this.count_ != this.keys_.length) {
		for (var a = 0, b = 0; a < this.keys_.length;) {
			var c = this.keys_[a];
			goog.structs.Map.hasKey_(this.map_, c) && (this.keys_[b++] = c);
			a++
		}
		this.keys_.length = b
	}
	if (this.count_ != this.keys_.length) {
		for (var d = {}, b = a = 0; a < this.keys_.length;) c = this.keys_[a], goog.structs.Map.hasKey_(d, c) || (this.keys_[b++] = c, d[c] = 1), a++;
		this.keys_.length = b
	}
};
goog.structs.Map.prototype.get = function (a, b) {
	return goog.structs.Map.hasKey_(this.map_, a) ? this.map_[a] : b
};
goog.structs.Map.prototype.set = function (a, b) {
	goog.structs.Map.hasKey_(this.map_, a) || (this.count_++, this.keys_.push(a), this.version_++);
	this.map_[a] = b
};
goog.structs.Map.prototype.addAll = function (a) {
	var b;
	a instanceof goog.structs.Map ? (b = a.getKeys(), a = a.getValues()) : (b = goog.object.getKeys(a), a = goog.object.getValues(a));
	for (var c = 0; c < b.length; c++) this.set(b[c], a[c])
};
goog.structs.Map.prototype.clone = function () {
	return new goog.structs.Map(this)
};
goog.structs.Map.prototype.transpose = function () {
	for (var a = new goog.structs.Map, b = 0; b < this.keys_.length; b++) {
		var c = this.keys_[b];
		a.set(this.map_[c], c)
	}
	return a
};
goog.structs.Map.prototype.toObject = function () {
	this.cleanupKeysArray_();
	for (var a = {}, b = 0; b < this.keys_.length; b++) {
		var c = this.keys_[b];
		a[c] = this.map_[c]
	}
	return a
};
goog.structs.Map.prototype.getKeyIterator = function () {
	return this.__iterator__(!0)
};
goog.structs.Map.prototype.getValueIterator = function () {
	return this.__iterator__(!1)
};
goog.structs.Map.prototype.__iterator__ = function (a) {
	this.cleanupKeysArray_();
	var b = 0,
		c = this.keys_,
		d = this.map_,
		e = this.version_,
		f = this,
		g = new goog.iter.Iterator;
	g.next = function () {
		for (;;) {
			if (e != f.version_) throw Error("The map has changed since the iterator was created");
			if (b >= c.length) throw goog.iter.StopIteration;
			var g = c[b++];
			return a ? g : d[g]
		}
	};
	return g
};
goog.structs.Map.hasKey_ = function (a, b) {
	return Object.prototype.hasOwnProperty.call(a, b)
};
goog.structs.Set = function (a) {
	this.map_ = new goog.structs.Map;
	a && this.addAll(a)
};
goog.structs.Set.getKey_ = function (a) {
	var b = typeof a;
	return "object" == b && a || "function" == b ? "o" + goog.getUid(a) : b.substr(0, 1) + a
};
goog.structs.Set.prototype.getCount = function () {
	return this.map_.getCount()
};
goog.structs.Set.prototype.add = function (a) {
	this.map_.set(goog.structs.Set.getKey_(a), a)
};
goog.structs.Set.prototype.addAll = function (a) {
	for (var a = goog.structs.getValues(a), b = a.length, c = 0; c < b; c++) this.add(a[c])
};
goog.structs.Set.prototype.removeAll = function (a) {
	for (var a = goog.structs.getValues(a), b = a.length, c = 0; c < b; c++) this.remove(a[c])
};
goog.structs.Set.prototype.remove = function (a) {
	return this.map_.remove(goog.structs.Set.getKey_(a))
};
goog.structs.Set.prototype.clear = function () {
	this.map_.clear()
};
goog.structs.Set.prototype.isEmpty = function () {
	return this.map_.isEmpty()
};
goog.structs.Set.prototype.contains = function (a) {
	return this.map_.containsKey(goog.structs.Set.getKey_(a))
};
goog.structs.Set.prototype.containsAll = function (a) {
	return goog.structs.every(a, this.contains, this)
};
goog.structs.Set.prototype.intersection = function (a) {
	for (var b = new goog.structs.Set, a = goog.structs.getValues(a), c = 0; c < a.length; c++) {
		var d = a[c];
		this.contains(d) && b.add(d)
	}
	return b
};
goog.structs.Set.prototype.getValues = function () {
	return this.map_.getValues()
};
goog.structs.Set.prototype.clone = function () {
	return new goog.structs.Set(this)
};
goog.structs.Set.prototype.equals = function (a) {
	return this.getCount() == goog.structs.getCount(a) && this.isSubsetOf(a)
};
goog.structs.Set.prototype.isSubsetOf = function (a) {
	var b = goog.structs.getCount(a);
	if (this.getCount() > b) return !1;
	!(a instanceof goog.structs.Set) && 5 < b && (a = new goog.structs.Set(a));
	return goog.structs.every(this, function (b) {
		return goog.structs.contains(a, b)
	})
};
goog.structs.Set.prototype.__iterator__ = function () {
	return this.map_.__iterator__(!1)
};
goog.debug.catchErrors = function (a, b, c) {
	var c = c || goog.global,
		d = c.onerror;
	c.onerror = function (c, f, g) {
		d && d(c, f, g);
		a({
			message: c,
			fileName: f,
			line: g
		});
		return Boolean(b)
	}
};
goog.debug.expose = function (a, b) {
	if ("undefined" == typeof a) return "undefined";
	if (null == a) return "NULL";
	var c = [],
		d;
	for (d in a)
		if (b || !goog.isFunction(a[d])) {
			var e = d + " = ";
			try {
				e += a[d]
			} catch (f) {
				e += "*** " + f + " ***"
			}
			c.push(e)
		}
	return c.join("\n")
};
goog.debug.deepExpose = function (a, b) {
	var c = new goog.structs.Set,
		d = [],
		e = function (a, g) {
			var h = g + "  ";
			try {
				if (goog.isDef(a))
					if (goog.isNull(a)) d.push("NULL");
					else if (goog.isString(a)) d.push('"' + a.replace(/\n/g, "\n" + g) + '"');
				else if (goog.isFunction(a)) d.push(("" + a).replace(/\n/g, "\n" + g));
				else if (goog.isObject(a))
					if (c.contains(a)) d.push("*** reference loop detected ***");
					else {
						c.add(a);
						d.push("{");
						for (var j in a)
							if (b || !goog.isFunction(a[j])) d.push("\n"), d.push(h), d.push(j + " = "), e(a[j], h);
						d.push("\n" + g + "}")
					} else d.push(a);
					else d.push("undefined")
			} catch (k) {
				d.push("*** " + k + " ***")
			}
		};
	e(a, "");
	return d.join("")
};
goog.debug.exposeArray = function (a) {
	for (var b = [], c = 0; c < a.length; c++) goog.isArray(a[c]) ? b.push(goog.debug.exposeArray(a[c])) : b.push(a[c]);
	return "[ " + b.join(", ") + " ]"
};
goog.debug.exposeException = function (a, b) {
	try {
		var c = goog.debug.normalizeErrorObject(a);
		return "Message: " + goog.string.htmlEscape(c.message) + '\nUrl: <a href="view-source:' + c.fileName + '" target="_new">' + c.fileName + "</a>\nLine: " + c.lineNumber + "\n\nBrowser stack:\n" + goog.string.htmlEscape(c.stack + "-> ") + "[end]\n\nJS stack traversal:\n" + goog.string.htmlEscape(goog.debug.getStacktrace(b) + "-> ")
	} catch (d) {
		return "Exception trying to expose exception! You win, we lose. " + d
	}
};
goog.debug.normalizeErrorObject = function (a) {
	var b = goog.getObjectByName("window.location.href");
	return "string" == typeof a ? {
		message: a,
		name: "Unknown error",
		lineNumber: "Not available",
		fileName: b,
		stack: "Not available"
	} : !a.lineNumber || !a.fileName || !a.stack ? {
		message: a.message,
		name: a.name,
		lineNumber: a.lineNumber || a.line || "Not available",
		fileName: a.fileName || a.filename || a.sourceURL || b,
		stack: a.stack || "Not available"
	} : a
};
goog.debug.enhanceError = function (a, b) {
	var c = "string" == typeof a ? Error(a) : a;
	c.stack || (c.stack = goog.debug.getStacktrace(arguments.callee.caller));
	if (b) {
		for (var d = 0; c["message" + d];)++d;
		c["message" + d] = "" + b
	}
	return c
};
goog.debug.getStacktraceSimple = function (a) {
	for (var b = [], c = arguments.callee.caller, d = 0; c && (!a || d < a);) {
		b.push(goog.debug.getFunctionName(c));
		b.push("()\n");
		try {
			c = c.caller
		} catch (e) {
			b.push("[exception trying to get caller]\n");
			break
		}
		d++;
		if (d >= goog.debug.MAX_STACK_DEPTH) {
			b.push("[...long stack...]");
			break
		}
	}
	a && d >= a ? b.push("[...reached max depth limit...]") : b.push("[end]");
	return b.join("")
};
goog.debug.MAX_STACK_DEPTH = 50;
goog.debug.getStacktrace = function (a) {
	return goog.debug.getStacktraceHelper_(a || arguments.callee.caller, [])
};
goog.debug.getStacktraceHelper_ = function (a, b) {
	var c = [];
	if (goog.array.contains(b, a)) c.push("[...circular reference...]");
	else if (a && b.length < goog.debug.MAX_STACK_DEPTH) {
		c.push(goog.debug.getFunctionName(a) + "(");
		for (var d = a.arguments, e = 0; e < d.length; e++) {
			0 < e && c.push(", ");
			var f;
			f = d[e];
			switch (typeof f) {
			case "object":
				f = f ? "object" : "null";
				break;
			case "string":
				break;
			case "number":
				f = "" + f;
				break;
			case "boolean":
				f = f ? "true" : "false";
				break;
			case "function":
				f = (f = goog.debug.getFunctionName(f)) ? f : "[fn]";
				break;
			default:
				f =
					typeof f
			}
			40 < f.length && (f = f.substr(0, 40) + "...");
			c.push(f)
		}
		b.push(a);
		c.push(")\n");
		try {
			c.push(goog.debug.getStacktraceHelper_(a.caller, b))
		} catch (g) {
			c.push("[exception trying to get caller]\n")
		}
	} else a ? c.push("[...long stack...]") : c.push("[end]");
	return c.join("")
};
goog.debug.getFunctionName = function (a) {
	a = "" + a;
	if (!goog.debug.fnNameCache_[a]) {
		var b = /function ([^\(]+)/.exec(a);
		goog.debug.fnNameCache_[a] = b ? b[1] : "[Anonymous]"
	}
	return goog.debug.fnNameCache_[a]
};
goog.debug.makeWhitespaceVisible = function (a) {
	return a.replace(/ /g, "[_]").replace(/\f/g, "[f]").replace(/\n/g, "[n]\n").replace(/\r/g, "[r]").replace(/\t/g, "[t]")
};
goog.debug.fnNameCache_ = {};
goog.debug.LogRecord = function (a, b, c, d, e) {
	this.reset(a, b, c, d, e)
};
goog.debug.LogRecord.prototype.sequenceNumber_ = 0;
goog.debug.LogRecord.prototype.exception_ = null;
goog.debug.LogRecord.prototype.exceptionText_ = null;
goog.debug.LogRecord.ENABLE_SEQUENCE_NUMBERS = !0;
goog.debug.LogRecord.nextSequenceNumber_ = 0;
goog.debug.LogRecord.prototype.reset = function (a, b, c, d, e) {
	goog.debug.LogRecord.ENABLE_SEQUENCE_NUMBERS && (this.sequenceNumber_ = "number" == typeof e ? e : goog.debug.LogRecord.nextSequenceNumber_++);
	this.time_ = d || goog.now();
	this.level_ = a;
	this.msg_ = b;
	this.loggerName_ = c;
	delete this.exception_;
	delete this.exceptionText_
};
goog.debug.LogRecord.prototype.getLoggerName = function () {
	return this.loggerName_
};
goog.debug.LogRecord.prototype.getException = function () {
	return this.exception_
};
goog.debug.LogRecord.prototype.setException = function (a) {
	this.exception_ = a
};
goog.debug.LogRecord.prototype.getExceptionText = function () {
	return this.exceptionText_
};
goog.debug.LogRecord.prototype.setExceptionText = function (a) {
	this.exceptionText_ = a
};
goog.debug.LogRecord.prototype.setLoggerName = function (a) {
	this.loggerName_ = a
};
goog.debug.LogRecord.prototype.getLevel = function () {
	return this.level_
};
goog.debug.LogRecord.prototype.setLevel = function (a) {
	this.level_ = a
};
goog.debug.LogRecord.prototype.getMessage = function () {
	return this.msg_
};
goog.debug.LogRecord.prototype.setMessage = function (a) {
	this.msg_ = a
};
goog.debug.LogRecord.prototype.getMillis = function () {
	return this.time_
};
goog.debug.LogRecord.prototype.setMillis = function (a) {
	this.time_ = a
};
goog.debug.LogRecord.prototype.getSequenceNumber = function () {
	return this.sequenceNumber_
};
goog.debug.LogBuffer = function () {
	goog.asserts.assert(goog.debug.LogBuffer.isBufferingEnabled(), "Cannot use goog.debug.LogBuffer without defining goog.debug.LogBuffer.CAPACITY.");
	this.clear()
};
goog.debug.LogBuffer.getInstance = function () {
	goog.debug.LogBuffer.instance_ || (goog.debug.LogBuffer.instance_ = new goog.debug.LogBuffer);
	return goog.debug.LogBuffer.instance_
};
goog.debug.LogBuffer.CAPACITY = 0;
goog.debug.LogBuffer.prototype.addRecord = function (a, b, c) {
	var d = (this.curIndex_ + 1) % goog.debug.LogBuffer.CAPACITY;
	this.curIndex_ = d;
	if (this.isFull_) return d = this.buffer_[d], d.reset(a, b, c), d;
	this.isFull_ = d == goog.debug.LogBuffer.CAPACITY - 1;
	return this.buffer_[d] = new goog.debug.LogRecord(a, b, c)
};
goog.debug.LogBuffer.isBufferingEnabled = function () {
	return 0 < goog.debug.LogBuffer.CAPACITY
};
goog.debug.LogBuffer.prototype.clear = function () {
	this.buffer_ = Array(goog.debug.LogBuffer.CAPACITY);
	this.curIndex_ = -1;
	this.isFull_ = !1
};
goog.debug.LogBuffer.prototype.forEachRecord = function (a) {
	var b = this.buffer_;
	if (b[0]) {
		var c = this.curIndex_,
			d = this.isFull_ ? c : -1;
		do d = (d + 1) % goog.debug.LogBuffer.CAPACITY, a(b[d]); while (d != c)
	}
};
goog.debug.Logger = function (a) {
	this.name_ = a
};
goog.debug.Logger.prototype.parent_ = null;
goog.debug.Logger.prototype.level_ = null;
goog.debug.Logger.prototype.children_ = null;
goog.debug.Logger.prototype.handlers_ = null;
goog.debug.Logger.ENABLE_HIERARCHY = !0;
goog.debug.Logger.ENABLE_HIERARCHY || (goog.debug.Logger.rootHandlers_ = []);
goog.debug.Logger.Level = function (a, b) {
	this.name = a;
	this.value = b
};
goog.debug.Logger.Level.prototype.toString = function () {
	return this.name
};
goog.debug.Logger.Level.OFF = new goog.debug.Logger.Level("OFF", Infinity);
goog.debug.Logger.Level.SHOUT = new goog.debug.Logger.Level("SHOUT", 1200);
goog.debug.Logger.Level.SEVERE = new goog.debug.Logger.Level("SEVERE", 1E3);
goog.debug.Logger.Level.WARNING = new goog.debug.Logger.Level("WARNING", 900);
goog.debug.Logger.Level.INFO = new goog.debug.Logger.Level("INFO", 800);
goog.debug.Logger.Level.CONFIG = new goog.debug.Logger.Level("CONFIG", 700);
goog.debug.Logger.Level.FINE = new goog.debug.Logger.Level("FINE", 500);
goog.debug.Logger.Level.FINER = new goog.debug.Logger.Level("FINER", 400);
goog.debug.Logger.Level.FINEST = new goog.debug.Logger.Level("FINEST", 300);
goog.debug.Logger.Level.ALL = new goog.debug.Logger.Level("ALL", 0);
goog.debug.Logger.Level.PREDEFINED_LEVELS = [goog.debug.Logger.Level.OFF, goog.debug.Logger.Level.SHOUT, goog.debug.Logger.Level.SEVERE, goog.debug.Logger.Level.WARNING, goog.debug.Logger.Level.INFO, goog.debug.Logger.Level.CONFIG, goog.debug.Logger.Level.FINE, goog.debug.Logger.Level.FINER, goog.debug.Logger.Level.FINEST, goog.debug.Logger.Level.ALL];
goog.debug.Logger.Level.predefinedLevelsCache_ = null;
goog.debug.Logger.Level.createPredefinedLevelsCache_ = function () {
	goog.debug.Logger.Level.predefinedLevelsCache_ = {};
	for (var a = 0, b; b = goog.debug.Logger.Level.PREDEFINED_LEVELS[a]; a++) {
		goog.debug.Logger.Level.predefinedLevelsCache_[b.value] = b;
		goog.debug.Logger.Level.predefinedLevelsCache_[b.name] = b
	}
};
goog.debug.Logger.Level.getPredefinedLevel = function (a) {
	goog.debug.Logger.Level.predefinedLevelsCache_ || goog.debug.Logger.Level.createPredefinedLevelsCache_();
	return goog.debug.Logger.Level.predefinedLevelsCache_[a] || null
};
goog.debug.Logger.Level.getPredefinedLevelByValue = function (a) {
	goog.debug.Logger.Level.predefinedLevelsCache_ || goog.debug.Logger.Level.createPredefinedLevelsCache_();
	if (a in goog.debug.Logger.Level.predefinedLevelsCache_) return goog.debug.Logger.Level.predefinedLevelsCache_[a];
	for (var b = 0; b < goog.debug.Logger.Level.PREDEFINED_LEVELS.length; ++b) {
		var c = goog.debug.Logger.Level.PREDEFINED_LEVELS[b];
		if (c.value <= a) return c
	}
	return null
};
goog.debug.Logger.getLogger = function (a) {
	return goog.debug.LogManager.getLogger(a)
};
goog.debug.Logger.prototype.getName = function () {
	return this.name_
};
goog.debug.Logger.prototype.addHandler = function (a) {
	if (goog.debug.Logger.ENABLE_HIERARCHY) {
		if (!this.handlers_) this.handlers_ = [];
		this.handlers_.push(a)
	} else {
		goog.asserts.assert(!this.name_, "Cannot call addHandler on a non-root logger when goog.debug.Logger.ENABLE_HIERARCHY is false.");
		goog.debug.Logger.rootHandlers_.push(a)
	}
};
goog.debug.Logger.prototype.removeHandler = function (a) {
	var b = goog.debug.Logger.ENABLE_HIERARCHY ? this.handlers_ : goog.debug.Logger.rootHandlers_;
	return !!b && goog.array.remove(b, a)
};
goog.debug.Logger.prototype.getParent = function () {
	return this.parent_
};
goog.debug.Logger.prototype.getChildren = function () {
	if (!this.children_) this.children_ = {};
	return this.children_
};
goog.debug.Logger.prototype.setLevel = function (a) {
	if (goog.debug.Logger.ENABLE_HIERARCHY) this.level_ = a;
	else {
		goog.asserts.assert(!this.name_, "Cannot call setLevel() on a non-root logger when goog.debug.Logger.ENABLE_HIERARCHY is false.");
		goog.debug.Logger.rootLevel_ = a
	}
};
goog.debug.Logger.prototype.getLevel = function () {
	return this.level_
};
goog.debug.Logger.prototype.getEffectiveLevel = function () {
	if (!goog.debug.Logger.ENABLE_HIERARCHY) return goog.debug.Logger.rootLevel_;
	if (this.level_) return this.level_;
	if (this.parent_) return this.parent_.getEffectiveLevel();
	goog.asserts.fail("Root logger has no level set.");
	return null
};
goog.debug.Logger.prototype.isLoggable = function (a) {
	return a.value >= this.getEffectiveLevel().value
};
goog.debug.Logger.prototype.log = function (a, b, c) {
	this.isLoggable(a) && this.doLogRecord_(this.getLogRecord(a, b, c))
};
goog.debug.Logger.prototype.getLogRecord = function (a, b, c) {
	var d = goog.debug.LogBuffer.isBufferingEnabled() ? goog.debug.LogBuffer.getInstance().addRecord(a, b, this.name_) : new goog.debug.LogRecord(a, "" + b, this.name_);
	if (c) {
		d.setException(c);
		d.setExceptionText(goog.debug.exposeException(c, arguments.callee.caller))
	}
	return d
};
goog.debug.Logger.prototype.shout = function (a, b) {
	this.log(goog.debug.Logger.Level.SHOUT, a, b)
};
goog.debug.Logger.prototype.severe = function (a, b) {
	this.log(goog.debug.Logger.Level.SEVERE, a, b)
};
goog.debug.Logger.prototype.warning = function (a, b) {
	this.log(goog.debug.Logger.Level.WARNING, a, b)
};
goog.debug.Logger.prototype.info = function (a, b) {
	this.log(goog.debug.Logger.Level.INFO, a, b)
};
goog.debug.Logger.prototype.config = function (a, b) {
	this.log(goog.debug.Logger.Level.CONFIG, a, b)
};
goog.debug.Logger.prototype.fine = function (a, b) {
	this.log(goog.debug.Logger.Level.FINE, a, b)
};
goog.debug.Logger.prototype.finer = function (a, b) {
	this.log(goog.debug.Logger.Level.FINER, a, b)
};
goog.debug.Logger.prototype.finest = function (a, b) {
	this.log(goog.debug.Logger.Level.FINEST, a, b)
};
goog.debug.Logger.prototype.logRecord = function (a) {
	this.isLoggable(a.getLevel()) && this.doLogRecord_(a)
};
goog.debug.Logger.prototype.logToSpeedTracer_ = function (a) {
	goog.global.console && goog.global.console.markTimeline && goog.global.console.markTimeline(a)
};
goog.debug.Logger.prototype.doLogRecord_ = function (a) {
	this.logToSpeedTracer_("log:" + a.getMessage());
	if (goog.debug.Logger.ENABLE_HIERARCHY)
		for (var b = this; b;) {
			b.callPublish_(a);
			b = b.getParent()
		} else
			for (var b = 0, c; c = goog.debug.Logger.rootHandlers_[b++];) c(a)
};
goog.debug.Logger.prototype.callPublish_ = function (a) {
	if (this.handlers_)
		for (var b = 0, c; c = this.handlers_[b]; b++) c(a)
};
goog.debug.Logger.prototype.setParent_ = function (a) {
	this.parent_ = a
};
goog.debug.Logger.prototype.addChild_ = function (a, b) {
	this.getChildren()[a] = b
};
goog.debug.LogManager = {};
goog.debug.LogManager.loggers_ = {};
goog.debug.LogManager.rootLogger_ = null;
goog.debug.LogManager.initialize = function () {
	if (!goog.debug.LogManager.rootLogger_) {
		goog.debug.LogManager.rootLogger_ = new goog.debug.Logger("");
		goog.debug.LogManager.loggers_[""] = goog.debug.LogManager.rootLogger_;
		goog.debug.LogManager.rootLogger_.setLevel(goog.debug.Logger.Level.CONFIG)
	}
};
goog.debug.LogManager.getLoggers = function () {
	return goog.debug.LogManager.loggers_
};
goog.debug.LogManager.getRoot = function () {
	goog.debug.LogManager.initialize();
	return goog.debug.LogManager.rootLogger_
};
goog.debug.LogManager.getLogger = function (a) {
	goog.debug.LogManager.initialize();
	return goog.debug.LogManager.loggers_[a] || goog.debug.LogManager.createLogger_(a)
};
goog.debug.LogManager.createFunctionForCatchErrors = function (a) {
	return function (b) {
		(a || goog.debug.LogManager.getRoot()).severe("Error: " + b.message + " (" + b.fileName + " @ Line: " + b.line + ")")
	}
};
goog.debug.LogManager.createLogger_ = function (a) {
	var b = new goog.debug.Logger(a);
	if (goog.debug.Logger.ENABLE_HIERARCHY) {
		var c = a.lastIndexOf("."),
			d = a.substr(0, c),
			c = a.substr(c + 1),
			d = goog.debug.LogManager.getLogger(d);
		d.addChild_(c, b);
		b.setParent_(d)
	}
	return goog.debug.LogManager.loggers_[a] = b
};
goog.Disposable = function () {};
goog.Disposable.prototype.disposed_ = !1;
goog.Disposable.prototype.isDisposed = function () {
	return this.disposed_
};
goog.Disposable.prototype.getDisposed = goog.Disposable.prototype.isDisposed;
goog.Disposable.prototype.dispose = function () {
	this.disposed_ || (this.disposed_ = !0, this.disposeInternal())
};
goog.Disposable.prototype.disposeInternal = function () {};
goog.dispose = function (a) {
	a && "function" == typeof a.dispose && a.dispose()
};
goog.dom.SavedRange = function () {
	goog.Disposable.call(this)
};
goog.inherits(goog.dom.SavedRange, goog.Disposable);
goog.dom.SavedRange.logger_ = goog.debug.Logger.getLogger("goog.dom.SavedRange");
goog.dom.SavedRange.prototype.restore = function (a) {
	this.isDisposed() && goog.dom.SavedRange.logger_.severe("Disposed SavedRange objects cannot be restored.");
	var b = this.restoreInternal();
	a || this.dispose();
	return b
};
goog.dom.SavedCaretRange = function (a) {
	goog.dom.SavedRange.call(this);
	this.startCaretId_ = goog.string.createUniqueString();
	this.endCaretId_ = goog.string.createUniqueString();
	this.dom_ = goog.dom.getDomHelper(a.getDocument());
	a.surroundWithNodes(this.createCaret_(!0), this.createCaret_(!1))
};
goog.inherits(goog.dom.SavedCaretRange, goog.dom.SavedRange);
goog.dom.SavedCaretRange.prototype.toAbstractRange = function () {
	var a = null,
		b = this.getCaret(!0),
		c = this.getCaret(!1);
	b && c && (a = goog.dom.Range.createFromNodes(b, 0, c, 0));
	return a
};
goog.dom.SavedCaretRange.prototype.getCaret = function (a) {
	return this.dom_.getElement(a ? this.startCaretId_ : this.endCaretId_)
};
goog.dom.SavedCaretRange.prototype.removeCarets = function (a) {
	goog.dom.removeNode(this.getCaret(!0));
	goog.dom.removeNode(this.getCaret(!1));
	return a
};
goog.dom.SavedCaretRange.prototype.setRestorationDocument = function (a) {
	this.dom_.setDocument(a)
};
goog.dom.SavedCaretRange.prototype.restoreInternal = function () {
	var a = null,
		b = this.getCaret(!0),
		c = this.getCaret(!1);
	if (b && c) {
		var a = b.parentNode,
			b = goog.array.indexOf(a.childNodes, b),
			d = c.parentNode,
			c = goog.array.indexOf(d.childNodes, c);
		d == a && (c -= 1);
		a = goog.dom.Range.createFromNodes(a, b, d, c);
		a = this.removeCarets(a);
		a.select()
	} else this.removeCarets();
	return a
};
goog.dom.SavedCaretRange.prototype.disposeInternal = function () {
	this.removeCarets();
	this.dom_ = null
};
goog.dom.SavedCaretRange.prototype.createCaret_ = function (a) {
	return this.dom_.createDom(goog.dom.TagName.SPAN, {
		id: a ? this.startCaretId_ : this.endCaretId_
	})
};
goog.dom.SavedCaretRange.CARET_REGEX = /<span\s+id="?goog_\d+"?><\/span>/ig;
goog.dom.SavedCaretRange.htmlEqual = function (a, b) {
	return a == b || a.replace(goog.dom.SavedCaretRange.CARET_REGEX, "") == b.replace(goog.dom.SavedCaretRange.CARET_REGEX, "")
};
goog.dom.TagWalkType = {
	START_TAG: 1,
	OTHER: 0,
	END_TAG: -1
};
goog.dom.TagIterator = function (a, b, c, d, e) {
	this.reversed = !! b;
	a && this.setPosition(a, d);
	this.depth = void 0 != e ? e : this.tagType || 0;
	this.reversed && (this.depth *= -1);
	this.constrained = !c
};
goog.inherits(goog.dom.TagIterator, goog.iter.Iterator);
goog.dom.TagIterator.prototype.node = null;
goog.dom.TagIterator.prototype.tagType = goog.dom.TagWalkType.OTHER;
goog.dom.TagIterator.prototype.started_ = !1;
goog.dom.TagIterator.prototype.setPosition = function (a, b, c) {
	if (this.node = a) this.tagType = goog.isNumber(b) ? b : this.node.nodeType != goog.dom.NodeType.ELEMENT ? goog.dom.TagWalkType.OTHER : this.reversed ? goog.dom.TagWalkType.END_TAG : goog.dom.TagWalkType.START_TAG;
	goog.isNumber(c) && (this.depth = c)
};
goog.dom.TagIterator.prototype.copyFrom = function (a) {
	this.node = a.node;
	this.tagType = a.tagType;
	this.depth = a.depth;
	this.reversed = a.reversed;
	this.constrained = a.constrained
};
goog.dom.TagIterator.prototype.clone = function () {
	return new goog.dom.TagIterator(this.node, this.reversed, !this.constrained, this.tagType, this.depth)
};
goog.dom.TagIterator.prototype.skipTag = function () {
	var a = this.reversed ? goog.dom.TagWalkType.END_TAG : goog.dom.TagWalkType.START_TAG;
	this.tagType == a && (this.tagType = -1 * a, this.depth += this.tagType * (this.reversed ? -1 : 1))
};
goog.dom.TagIterator.prototype.restartTag = function () {
	var a = this.reversed ? goog.dom.TagWalkType.START_TAG : goog.dom.TagWalkType.END_TAG;
	this.tagType == a && (this.tagType = -1 * a, this.depth += this.tagType * (this.reversed ? -1 : 1))
};
goog.dom.TagIterator.prototype.next = function () {
	var a;
	if (this.started_) {
		if (!this.node || this.constrained && 0 == this.depth) throw goog.iter.StopIteration;
		a = this.node;
		var b = this.reversed ? goog.dom.TagWalkType.END_TAG : goog.dom.TagWalkType.START_TAG;
		if (this.tagType == b) {
			var c = this.reversed ? a.lastChild : a.firstChild;
			c ? this.setPosition(c) : this.setPosition(a, -1 * b)
		} else(c = this.reversed ? a.previousSibling : a.nextSibling) ? this.setPosition(c) : this.setPosition(a.parentNode, -1 * b);
		this.depth += this.tagType * (this.reversed ? -1 : 1)
	} else this.started_ = !0;
	a = this.node;
	if (!this.node) throw goog.iter.StopIteration;
	return a
};
goog.dom.TagIterator.prototype.isStarted = function () {
	return this.started_
};
goog.dom.TagIterator.prototype.isStartTag = function () {
	return this.tagType == goog.dom.TagWalkType.START_TAG
};
goog.dom.TagIterator.prototype.isEndTag = function () {
	return this.tagType == goog.dom.TagWalkType.END_TAG
};
goog.dom.TagIterator.prototype.isNonElement = function () {
	return this.tagType == goog.dom.TagWalkType.OTHER
};
goog.dom.TagIterator.prototype.equals = function (a) {
	return a.node == this.node && (!this.node || a.tagType == this.tagType)
};
goog.dom.TagIterator.prototype.splice = function (a) {
	var b = this.node;
	this.restartTag();
	this.reversed = !this.reversed;
	goog.dom.TagIterator.prototype.next.call(this);
	this.reversed = !this.reversed;
	for (var c = goog.isArrayLike(arguments[0]) ? arguments[0] : arguments, d = c.length - 1; 0 <= d; d--) goog.dom.insertSiblingAfter(c[d], b);
	goog.dom.removeNode(b)
};
goog.dom.RangeType = {
	TEXT: "text",
	CONTROL: "control",
	MULTI: "mutli"
};
goog.dom.AbstractRange = function () {};
goog.dom.AbstractRange.getBrowserSelectionForWindow = function (a) {
	if (a.getSelection) return a.getSelection();
	var a = a.document,
		b = a.selection;
	if (b) {
		try {
			var c = b.createRange();
			if (c.parentElement) {
				if (c.parentElement().document != a) return null
			} else if (!c.length || c.item(0).document != a) return null
		} catch (d) {
			return null
		}
		return b
	}
	return null
};
goog.dom.AbstractRange.isNativeControlRange = function (a) {
	return !!a && !! a.addElement
};
goog.dom.AbstractRange.prototype.setBrowserRangeObject = function () {
	return !1
};
goog.dom.AbstractRange.prototype.getTextRanges = function () {
	for (var a = [], b = 0, c = this.getTextRangeCount(); b < c; b++) a.push(this.getTextRange(b));
	return a
};
goog.dom.AbstractRange.prototype.getContainerElement = function () {
	var a = this.getContainer();
	return a.nodeType == goog.dom.NodeType.ELEMENT ? a : a.parentNode
};
goog.dom.AbstractRange.prototype.getAnchorNode = function () {
	return this.isReversed() ? this.getEndNode() : this.getStartNode()
};
goog.dom.AbstractRange.prototype.getAnchorOffset = function () {
	return this.isReversed() ? this.getEndOffset() : this.getStartOffset()
};
goog.dom.AbstractRange.prototype.getFocusNode = function () {
	return this.isReversed() ? this.getStartNode() : this.getEndNode()
};
goog.dom.AbstractRange.prototype.getFocusOffset = function () {
	return this.isReversed() ? this.getStartOffset() : this.getEndOffset()
};
goog.dom.AbstractRange.prototype.isReversed = function () {
	return !1
};
goog.dom.AbstractRange.prototype.getDocument = function () {
	return goog.dom.getOwnerDocument(goog.userAgent.IE ? this.getContainer() : this.getStartNode())
};
goog.dom.AbstractRange.prototype.getWindow = function () {
	return goog.dom.getWindow(this.getDocument())
};
goog.dom.AbstractRange.prototype.containsNode = function (a, b) {
	return this.containsRange(goog.dom.Range.createFromNodeContents(a), b)
};
goog.dom.AbstractRange.prototype.replaceContentsWithNode = function (a) {
	this.isCollapsed() || this.removeContents();
	return this.insertNode(a, !0)
};
goog.dom.AbstractRange.prototype.saveUsingCarets = function () {
	return this.getStartNode() && this.getEndNode() ? new goog.dom.SavedCaretRange(this) : null
};
goog.dom.RangeIterator = function (a, b) {
	goog.dom.TagIterator.call(this, a, b, !0)
};
goog.inherits(goog.dom.RangeIterator, goog.dom.TagIterator);
goog.dom.AbstractMultiRange = function () {};
goog.inherits(goog.dom.AbstractMultiRange, goog.dom.AbstractRange);
goog.dom.AbstractMultiRange.prototype.containsRange = function (a, b) {
	var c = this.getTextRanges(),
		d = a.getTextRanges();
	return (b ? goog.array.some : goog.array.every)(d, function (a) {
		return goog.array.some(c, function (c) {
			return c.containsRange(a, b)
		})
	})
};
goog.dom.AbstractMultiRange.prototype.insertNode = function (a, b) {
	b ? goog.dom.insertSiblingBefore(a, this.getStartNode()) : goog.dom.insertSiblingAfter(a, this.getEndNode());
	return a
};
goog.dom.AbstractMultiRange.prototype.surroundWithNodes = function (a, b) {
	this.insertNode(a, !0);
	this.insertNode(b, !1)
};
goog.dom.TextRangeIterator = function (a, b, c, d, e) {
	var f;
	if (a && (this.startNode_ = a, this.startOffset_ = b, this.endNode_ = c, this.endOffset_ = d, a.nodeType == goog.dom.NodeType.ELEMENT && a.tagName != goog.dom.TagName.BR && (a = a.childNodes, (b = a[b]) ? (this.startNode_ = b, this.startOffset_ = 0) : (a.length && (this.startNode_ = goog.array.peek(a)), f = !0)), c.nodeType == goog.dom.NodeType.ELEMENT))(this.endNode_ = c.childNodes[d]) ? this.endOffset_ = 0 : this.endNode_ = c;
	goog.dom.RangeIterator.call(this, e ? this.endNode_ : this.startNode_, e);
	if (f) try {
		this.next()
	} catch (g) {
		if (g !=
			goog.iter.StopIteration) throw g;
	}
};
goog.inherits(goog.dom.TextRangeIterator, goog.dom.RangeIterator);
goog.dom.TextRangeIterator.prototype.startNode_ = null;
goog.dom.TextRangeIterator.prototype.endNode_ = null;
goog.dom.TextRangeIterator.prototype.startOffset_ = 0;
goog.dom.TextRangeIterator.prototype.endOffset_ = 0;
goog.dom.TextRangeIterator.prototype.getStartTextOffset = function () {
	return this.node.nodeType != goog.dom.NodeType.TEXT ? -1 : this.node == this.startNode_ ? this.startOffset_ : 0
};
goog.dom.TextRangeIterator.prototype.getEndTextOffset = function () {
	return this.node.nodeType != goog.dom.NodeType.TEXT ? -1 : this.node == this.endNode_ ? this.endOffset_ : this.node.nodeValue.length
};
goog.dom.TextRangeIterator.prototype.getStartNode = function () {
	return this.startNode_
};
goog.dom.TextRangeIterator.prototype.setStartNode = function (a) {
	this.isStarted() || this.setPosition(a);
	this.startNode_ = a;
	this.startOffset_ = 0
};
goog.dom.TextRangeIterator.prototype.getEndNode = function () {
	return this.endNode_
};
goog.dom.TextRangeIterator.prototype.setEndNode = function (a) {
	this.endNode_ = a;
	this.endOffset_ = 0
};
goog.dom.TextRangeIterator.prototype.isLast = function () {
	return this.isStarted() && this.node == this.endNode_ && (!this.endOffset_ || !this.isStartTag())
};
goog.dom.TextRangeIterator.prototype.next = function () {
	if (this.isLast()) throw goog.iter.StopIteration;
	return goog.dom.TextRangeIterator.superClass_.next.call(this)
};
goog.dom.TextRangeIterator.prototype.skipTag = function () {
	goog.dom.TextRangeIterator.superClass_.skipTag.apply(this);
	if (goog.dom.contains(this.node, this.endNode_)) throw goog.iter.StopIteration;
};
goog.dom.TextRangeIterator.prototype.copyFrom = function (a) {
	this.startNode_ = a.startNode_;
	this.endNode_ = a.endNode_;
	this.startOffset_ = a.startOffset_;
	this.endOffset_ = a.endOffset_;
	this.isReversed_ = a.isReversed_;
	goog.dom.TextRangeIterator.superClass_.copyFrom.call(this, a)
};
goog.dom.TextRangeIterator.prototype.clone = function () {
	var a = new goog.dom.TextRangeIterator(this.startNode_, this.startOffset_, this.endNode_, this.endOffset_, this.isReversed_);
	a.copyFrom(this);
	return a
};
goog.userAgent.jscript = {};
goog.userAgent.jscript.ASSUME_NO_JSCRIPT = !1;
goog.userAgent.jscript.init_ = function () {
	goog.userAgent.jscript.DETECTED_HAS_JSCRIPT_ = "ScriptEngine" in goog.global && "JScript" == goog.global.ScriptEngine();
	goog.userAgent.jscript.DETECTED_VERSION_ = goog.userAgent.jscript.DETECTED_HAS_JSCRIPT_ ? goog.global.ScriptEngineMajorVersion() + "." + goog.global.ScriptEngineMinorVersion() + "." + goog.global.ScriptEngineBuildVersion() : "0"
};
goog.userAgent.jscript.ASSUME_NO_JSCRIPT || goog.userAgent.jscript.init_();
goog.userAgent.jscript.HAS_JSCRIPT = goog.userAgent.jscript.ASSUME_NO_JSCRIPT ? !1 : goog.userAgent.jscript.DETECTED_HAS_JSCRIPT_;
goog.userAgent.jscript.VERSION = goog.userAgent.jscript.ASSUME_NO_JSCRIPT ? "0" : goog.userAgent.jscript.DETECTED_VERSION_;
goog.userAgent.jscript.isVersion = function (a) {
	return 0 <= goog.string.compareVersions(goog.userAgent.jscript.VERSION, a)
};
goog.string.StringBuffer = function (a, b) {
	this.buffer_ = goog.userAgent.jscript.HAS_JSCRIPT ? [] : "";
	null != a && this.append.apply(this, arguments)
};
goog.string.StringBuffer.prototype.set = function (a) {
	this.clear();
	this.append(a)
};
goog.userAgent.jscript.HAS_JSCRIPT ? (goog.string.StringBuffer.prototype.bufferLength_ = 0, goog.string.StringBuffer.prototype.append = function (a, b, c) {
	null == b ? this.buffer_[this.bufferLength_++] = a : (this.buffer_.push.apply(this.buffer_, arguments), this.bufferLength_ = this.buffer_.length);
	return this
}) : goog.string.StringBuffer.prototype.append = function (a, b, c) {
	this.buffer_ += a;
	if (null != b)
		for (var d = 1; d < arguments.length; d++) this.buffer_ += arguments[d];
	return this
};
goog.string.StringBuffer.prototype.clear = function () {
	if (goog.userAgent.jscript.HAS_JSCRIPT) this.bufferLength_ = this.buffer_.length = 0;
	else this.buffer_ = ""
};
goog.string.StringBuffer.prototype.getLength = function () {
	return this.toString().length
};
goog.string.StringBuffer.prototype.toString = function () {
	if (goog.userAgent.jscript.HAS_JSCRIPT) {
		var a = this.buffer_.join("");
		this.clear();
		a && this.append(a);
		return a
	}
	return this.buffer_
};
goog.dom.browserrange = {};
goog.dom.browserrange.AbstractRange = function () {};
goog.dom.browserrange.AbstractRange.prototype.containsRange = function (a, b) {
	var c = b && !a.isCollapsed(),
		d = a.getBrowserRange(),
		e = goog.dom.RangeEndpoint.START,
		f = goog.dom.RangeEndpoint.END;
	try {
		return c ? 0 <= this.compareBrowserRangeEndpoints(d, f, e) && 0 >= this.compareBrowserRangeEndpoints(d, e, f) : 0 <= this.compareBrowserRangeEndpoints(d, f, f) && 0 >= this.compareBrowserRangeEndpoints(d, e, e)
	} catch (g) {
		if (!goog.userAgent.IE) throw g;
		return !1
	}
};
goog.dom.browserrange.AbstractRange.prototype.containsNode = function (a, b) {
	return this.containsRange(goog.dom.browserrange.createRangeFromNodeContents(a), b)
};
goog.dom.browserrange.AbstractRange.prototype.getHtmlFragment = function () {
	var a = new goog.string.StringBuffer;
	goog.iter.forEach(this, function (b, c, d) {
		b.nodeType == goog.dom.NodeType.TEXT ? a.append(goog.string.htmlEscape(b.nodeValue.substring(d.getStartTextOffset(), d.getEndTextOffset()))) : b.nodeType == goog.dom.NodeType.ELEMENT && (d.isEndTag() ? goog.dom.canHaveChildren(b) && a.append("</" + b.tagName + ">") : (c = b.cloneNode(!1), c = goog.dom.getOuterHtml(c), goog.userAgent.IE && b.tagName == goog.dom.TagName.LI ? a.append(c) :
			(b = c.lastIndexOf("<"), a.append(b ? c.substr(0, b) : c))))
	}, this);
	return a.toString()
};
goog.dom.browserrange.AbstractRange.prototype.__iterator__ = function () {
	return new goog.dom.TextRangeIterator(this.getStartNode(), this.getStartOffset(), this.getEndNode(), this.getEndOffset())
};
goog.dom.browserrange.W3cRange = function (a) {
	this.range_ = a
};
goog.inherits(goog.dom.browserrange.W3cRange, goog.dom.browserrange.AbstractRange);
goog.dom.browserrange.W3cRange.getBrowserRangeForNode = function (a) {
	var b = goog.dom.getOwnerDocument(a).createRange();
	if (a.nodeType == goog.dom.NodeType.TEXT) b.setStart(a, 0), b.setEnd(a, a.length);
	else if (goog.dom.browserrange.canContainRangeEndpoint(a)) {
		for (var c, d = a;
			(c = d.firstChild) && goog.dom.browserrange.canContainRangeEndpoint(c);) d = c;
		b.setStart(d, 0);
		for (d = a;
			(c = d.lastChild) && goog.dom.browserrange.canContainRangeEndpoint(c);) d = c;
		b.setEnd(d, d.nodeType == goog.dom.NodeType.ELEMENT ? d.childNodes.length : d.length)
	} else c =
		a.parentNode, a = goog.array.indexOf(c.childNodes, a), b.setStart(c, a), b.setEnd(c, a + 1);
	return b
};
goog.dom.browserrange.W3cRange.getBrowserRangeForNodes = function (a, b, c, d) {
	var e = goog.dom.getOwnerDocument(a).createRange();
	e.setStart(a, b);
	e.setEnd(c, d);
	return e
};
goog.dom.browserrange.W3cRange.createFromNodeContents = function (a) {
	return new goog.dom.browserrange.W3cRange(goog.dom.browserrange.W3cRange.getBrowserRangeForNode(a))
};
goog.dom.browserrange.W3cRange.createFromNodes = function (a, b, c, d) {
	return new goog.dom.browserrange.W3cRange(goog.dom.browserrange.W3cRange.getBrowserRangeForNodes(a, b, c, d))
};
goog.dom.browserrange.W3cRange.prototype.clone = function () {
	return new this.constructor(this.range_.cloneRange())
};
goog.dom.browserrange.W3cRange.prototype.getBrowserRange = function () {
	return this.range_
};
goog.dom.browserrange.W3cRange.prototype.getContainer = function () {
	return this.range_.commonAncestorContainer
};
goog.dom.browserrange.W3cRange.prototype.getStartNode = function () {
	return this.range_.startContainer
};
goog.dom.browserrange.W3cRange.prototype.getStartOffset = function () {
	return this.range_.startOffset
};
goog.dom.browserrange.W3cRange.prototype.getEndNode = function () {
	return this.range_.endContainer
};
goog.dom.browserrange.W3cRange.prototype.getEndOffset = function () {
	return this.range_.endOffset
};
goog.dom.browserrange.W3cRange.prototype.compareBrowserRangeEndpoints = function (a, b, c) {
	return this.range_.compareBoundaryPoints(c == goog.dom.RangeEndpoint.START ? b == goog.dom.RangeEndpoint.START ? goog.global.Range.START_TO_START : goog.global.Range.START_TO_END : b == goog.dom.RangeEndpoint.START ? goog.global.Range.END_TO_START : goog.global.Range.END_TO_END, a)
};
goog.dom.browserrange.W3cRange.prototype.isCollapsed = function () {
	return this.range_.collapsed
};
goog.dom.browserrange.W3cRange.prototype.getText = function () {
	return this.range_.toString()
};
goog.dom.browserrange.W3cRange.prototype.getValidHtml = function () {
	var a = goog.dom.getDomHelper(this.range_.startContainer).createDom("div");
	a.appendChild(this.range_.cloneContents());
	a = a.innerHTML;
	if (goog.string.startsWith(a, "<") || !this.isCollapsed() && !goog.string.contains(a, "<")) return a;
	var b = this.getContainer(),
		b = b.nodeType == goog.dom.NodeType.ELEMENT ? b : b.parentNode;
	return goog.dom.getOuterHtml(b.cloneNode(!1)).replace(">", ">" + a)
};
goog.dom.browserrange.W3cRange.prototype.select = function (a) {
	this.selectInternal(goog.dom.getWindow(goog.dom.getOwnerDocument(this.getStartNode())).getSelection(), a)
};
goog.dom.browserrange.W3cRange.prototype.selectInternal = function (a) {
	a.removeAllRanges();
	a.addRange(this.range_)
};
goog.dom.browserrange.W3cRange.prototype.removeContents = function () {
	var a = this.range_;
	a.extractContents();
	if (a.startContainer.hasChildNodes() && (a = a.startContainer.childNodes[a.startOffset])) {
		var b = a.previousSibling;
		"" == goog.dom.getRawTextContent(a) && goog.dom.removeNode(a);
		b && "" == goog.dom.getRawTextContent(b) && goog.dom.removeNode(b)
	}
};
goog.dom.browserrange.W3cRange.prototype.surroundContents = function (a) {
	this.range_.surroundContents(a);
	return a
};
goog.dom.browserrange.W3cRange.prototype.insertNode = function (a, b) {
	var c = this.range_.cloneRange();
	c.collapse(b);
	c.insertNode(a);
	c.detach();
	return a
};
goog.dom.browserrange.W3cRange.prototype.surroundWithNodes = function (a, b) {
	var c = goog.dom.getWindow(goog.dom.getOwnerDocument(this.getStartNode()));
	if (c = goog.dom.Range.createFromWindow(c)) var d = c.getStartNode(),
	e = c.getEndNode(), f = c.getStartOffset(), g = c.getEndOffset();
	var h = this.range_.cloneRange(),
		j = this.range_.cloneRange();
	h.collapse(!1);
	j.collapse(!0);
	h.insertNode(b);
	j.insertNode(a);
	h.detach();
	j.detach();
	if (c) {
		if (d.nodeType == goog.dom.NodeType.TEXT)
			for (; f > d.length;) {
				f -= d.length;
				do d = d.nextSibling;
				while (d == a || d == b)
			}
		if (e.nodeType == goog.dom.NodeType.TEXT)
			for (; g > e.length;) {
				g -= e.length;
				do e = e.nextSibling; while (e == a || e == b)
			}
		goog.dom.Range.createFromNodes(d, f, e, g).select()
	}
};
goog.dom.browserrange.W3cRange.prototype.collapse = function (a) {
	this.range_.collapse(a)
};
goog.dom.browserrange.WebKitRange = function (a) {
	goog.dom.browserrange.W3cRange.call(this, a)
};
goog.inherits(goog.dom.browserrange.WebKitRange, goog.dom.browserrange.W3cRange);
goog.dom.browserrange.WebKitRange.createFromNodeContents = function (a) {
	return new goog.dom.browserrange.WebKitRange(goog.dom.browserrange.W3cRange.getBrowserRangeForNode(a))
};
goog.dom.browserrange.WebKitRange.createFromNodes = function (a, b, c, d) {
	return new goog.dom.browserrange.WebKitRange(goog.dom.browserrange.W3cRange.getBrowserRangeForNodes(a, b, c, d))
};
goog.dom.browserrange.WebKitRange.prototype.compareBrowserRangeEndpoints = function (a, b, c) {
	return goog.userAgent.isVersion("528") ? goog.dom.browserrange.WebKitRange.superClass_.compareBrowserRangeEndpoints.call(this, a, b, c) : this.range_.compareBoundaryPoints(c == goog.dom.RangeEndpoint.START ? b == goog.dom.RangeEndpoint.START ? goog.global.Range.START_TO_START : goog.global.Range.END_TO_START : b == goog.dom.RangeEndpoint.START ? goog.global.Range.START_TO_END : goog.global.Range.END_TO_END, a)
};
goog.dom.browserrange.WebKitRange.prototype.selectInternal = function (a, b) {
	a.removeAllRanges();
	b ? a.setBaseAndExtent(this.getEndNode(), this.getEndOffset(), this.getStartNode(), this.getStartOffset()) : a.setBaseAndExtent(this.getStartNode(), this.getStartOffset(), this.getEndNode(), this.getEndOffset())
};
goog.dom.NodeIterator = function (a, b, c, d) {
	goog.dom.TagIterator.call(this, a, b, c, null, d)
};
goog.inherits(goog.dom.NodeIterator, goog.dom.TagIterator);
goog.dom.NodeIterator.prototype.next = function () {
	do goog.dom.NodeIterator.superClass_.next.call(this); while (this.isEndTag());
	return this.node
};
goog.dom.browserrange.IeRange = function (a, b) {
	this.range_ = a;
	this.doc_ = b
};
goog.inherits(goog.dom.browserrange.IeRange, goog.dom.browserrange.AbstractRange);
goog.dom.browserrange.IeRange.logger_ = goog.debug.Logger.getLogger("goog.dom.browserrange.IeRange");
goog.dom.browserrange.IeRange.getBrowserRangeForNode_ = function (a) {
	var b = goog.dom.getOwnerDocument(a).body.createTextRange();
	if (a.nodeType == goog.dom.NodeType.ELEMENT) b.moveToElementText(a), goog.dom.browserrange.canContainRangeEndpoint(a) && !a.childNodes.length && b.collapse(!1);
	else {
		for (var c = 0, d = a; d = d.previousSibling;) {
			var e = d.nodeType;
			if (e == goog.dom.NodeType.TEXT) c += d.length;
			else if (e == goog.dom.NodeType.ELEMENT) {
				b.moveToElementText(d);
				break
			}
		}
		d || b.moveToElementText(a.parentNode);
		b.collapse(!d);
		c && b.move("character",
			c);
		b.moveEnd("character", a.length)
	}
	return b
};
goog.dom.browserrange.IeRange.getBrowserRangeForNodes_ = function (a, b, c, d) {
	var e = !1;
	a.nodeType == goog.dom.NodeType.ELEMENT && (b > a.childNodes.length && goog.dom.browserrange.IeRange.logger_.severe("Cannot have startOffset > startNode child count"), b = a.childNodes[b], e = !b, a = b || a.lastChild || a, b = 0);
	var f = goog.dom.browserrange.IeRange.getBrowserRangeForNode_(a);
	b && f.move("character", b);
	if (a == c && b == d) return f.collapse(!0), f;
	e && f.collapse(!1);
	e = !1;
	c.nodeType == goog.dom.NodeType.ELEMENT && (d > c.childNodes.length &&
		goog.dom.browserrange.IeRange.logger_.severe("Cannot have endOffset > endNode child count"), c = (b = c.childNodes[d]) || c.lastChild || c, d = 0, e = !b);
	a = goog.dom.browserrange.IeRange.getBrowserRangeForNode_(c);
	a.collapse(!e);
	d && a.moveEnd("character", d);
	f.setEndPoint("EndToEnd", a);
	return f
};
goog.dom.browserrange.IeRange.createFromNodeContents = function (a) {
	var b = new goog.dom.browserrange.IeRange(goog.dom.browserrange.IeRange.getBrowserRangeForNode_(a), goog.dom.getOwnerDocument(a));
	if (goog.dom.browserrange.canContainRangeEndpoint(a)) {
		for (var c, d = a;
			(c = d.firstChild) && goog.dom.browserrange.canContainRangeEndpoint(c);) d = c;
		b.startNode_ = d;
		b.startOffset_ = 0;
		for (d = a;
			(c = d.lastChild) && goog.dom.browserrange.canContainRangeEndpoint(c);) d = c;
		b.endNode_ = d;
		b.endOffset_ = d.nodeType == goog.dom.NodeType.ELEMENT ?
			d.childNodes.length : d.length;
		b.parentNode_ = a
	} else b.startNode_ = b.endNode_ = b.parentNode_ = a.parentNode, b.startOffset_ = goog.array.indexOf(b.parentNode_.childNodes, a), b.endOffset_ = b.startOffset_ + 1;
	return b
};
goog.dom.browserrange.IeRange.createFromNodes = function (a, b, c, d) {
	var e = new goog.dom.browserrange.IeRange(goog.dom.browserrange.IeRange.getBrowserRangeForNodes_(a, b, c, d), goog.dom.getOwnerDocument(a));
	e.startNode_ = a;
	e.startOffset_ = b;
	e.endNode_ = c;
	e.endOffset_ = d;
	return e
};
goog.dom.browserrange.IeRange.prototype.parentNode_ = null;
goog.dom.browserrange.IeRange.prototype.startNode_ = null;
goog.dom.browserrange.IeRange.prototype.endNode_ = null;
goog.dom.browserrange.IeRange.prototype.startOffset_ = -1;
goog.dom.browserrange.IeRange.prototype.endOffset_ = -1;
goog.dom.browserrange.IeRange.prototype.clone = function () {
	var a = new goog.dom.browserrange.IeRange(this.range_.duplicate(), this.doc_);
	a.parentNode_ = this.parentNode_;
	a.startNode_ = this.startNode_;
	a.endNode_ = this.endNode_;
	return a
};
goog.dom.browserrange.IeRange.prototype.getBrowserRange = function () {
	return this.range_
};
goog.dom.browserrange.IeRange.prototype.clearCachedValues_ = function () {
	this.parentNode_ = this.startNode_ = this.endNode_ = null;
	this.startOffset_ = this.endOffset_ = -1
};
goog.dom.browserrange.IeRange.prototype.getContainer = function () {
	if (!this.parentNode_) {
		var a = this.range_.text,
			b = this.range_.duplicate(),
			c = a.replace(/ +$/, "");
		(c = a.length - c.length) && b.moveEnd("character", -c);
		c = b.parentElement();
		b = goog.string.stripNewlines(b.htmlText).length;
		if (this.isCollapsed() && 0 < b) return this.parentNode_ = c;
		for (; b > goog.string.stripNewlines(c.outerHTML).length;) c = c.parentNode;
		for (; 1 == c.childNodes.length && c.innerText == goog.dom.browserrange.IeRange.getNodeText_(c.firstChild) && goog.dom.browserrange.canContainRangeEndpoint(c.firstChild);) c =
			c.firstChild;
		0 == a.length && (c = this.findDeepestContainer_(c));
		this.parentNode_ = c
	}
	return this.parentNode_
};
goog.dom.browserrange.IeRange.prototype.findDeepestContainer_ = function (a) {
	for (var b = a.childNodes, c = 0, d = b.length; c < d; c++) {
		var e = b[c];
		if (goog.dom.browserrange.canContainRangeEndpoint(e)) {
			var f = goog.dom.browserrange.IeRange.getBrowserRangeForNode_(e),
				g = goog.dom.RangeEndpoint.START,
				h = goog.dom.RangeEndpoint.END,
				j = f.htmlText != e.outerHTML;
			if (this.isCollapsed() && j ? 0 <= this.compareBrowserRangeEndpoints(f, g, g) && 0 >= this.compareBrowserRangeEndpoints(f, g, h) : this.range_.inRange(f)) return this.findDeepestContainer_(e)
		}
	}
	return a
};
goog.dom.browserrange.IeRange.prototype.getStartNode = function () {
	this.startNode_ || (this.startNode_ = this.getEndpointNode_(goog.dom.RangeEndpoint.START), this.isCollapsed() && (this.endNode_ = this.startNode_));
	return this.startNode_
};
goog.dom.browserrange.IeRange.prototype.getStartOffset = function () {
	0 > this.startOffset_ && (this.startOffset_ = this.getOffset_(goog.dom.RangeEndpoint.START), this.isCollapsed() && (this.endOffset_ = this.startOffset_));
	return this.startOffset_
};
goog.dom.browserrange.IeRange.prototype.getEndNode = function () {
	if (this.isCollapsed()) return this.getStartNode();
	this.endNode_ || (this.endNode_ = this.getEndpointNode_(goog.dom.RangeEndpoint.END));
	return this.endNode_
};
goog.dom.browserrange.IeRange.prototype.getEndOffset = function () {
	if (this.isCollapsed()) return this.getStartOffset();
	0 > this.endOffset_ && (this.endOffset_ = this.getOffset_(goog.dom.RangeEndpoint.END), this.isCollapsed() && (this.startOffset_ = this.endOffset_));
	return this.endOffset_
};
goog.dom.browserrange.IeRange.prototype.compareBrowserRangeEndpoints = function (a, b, c) {
	return this.range_.compareEndPoints((b == goog.dom.RangeEndpoint.START ? "Start" : "End") + "To" + (c == goog.dom.RangeEndpoint.START ? "Start" : "End"), a)
};
goog.dom.browserrange.IeRange.prototype.getEndpointNode_ = function (a, b) {
	var c = b || this.getContainer();
	if (!c || !c.firstChild) return c;
	for (var d = goog.dom.RangeEndpoint.START, e = goog.dom.RangeEndpoint.END, f = a == d, g = 0, h = c.childNodes.length; g < h; g++) {
		var j = f ? g : h - g - 1,
			k = c.childNodes[j],
			l;
		try {
			l = goog.dom.browserrange.createRangeFromNodeContents(k)
		} catch (n) {
			continue
		}
		var m = l.getBrowserRange();
		if (this.isCollapsed())
			if (goog.dom.browserrange.canContainRangeEndpoint(k)) {
				if (l.containsRange(this)) return this.getEndpointNode_(a,
					k)
			} else {
				if (0 == this.compareBrowserRangeEndpoints(m, d, d)) {
					this.startOffset_ = this.endOffset_ = j;
					break
				}
			} else {
				if (this.containsRange(l)) {
					if (!goog.dom.browserrange.canContainRangeEndpoint(k)) {
						f ? this.startOffset_ = j : this.endOffset_ = j + 1;
						break
					}
					return this.getEndpointNode_(a, k)
				}
				if (0 > this.compareBrowserRangeEndpoints(m, d, e) && 0 < this.compareBrowserRangeEndpoints(m, e, d)) return this.getEndpointNode_(a, k)
			}
	}
	return c
};
goog.dom.browserrange.IeRange.prototype.compareNodeEndpoints_ = function (a, b, c) {
	return this.range_.compareEndPoints((b == goog.dom.RangeEndpoint.START ? "Start" : "End") + "To" + (c == goog.dom.RangeEndpoint.START ? "Start" : "End"), goog.dom.browserrange.createRangeFromNodeContents(a).getBrowserRange())
};
goog.dom.browserrange.IeRange.prototype.getOffset_ = function (a, b) {
	var c = a == goog.dom.RangeEndpoint.START,
		d = b || (c ? this.getStartNode() : this.getEndNode());
	if (d.nodeType == goog.dom.NodeType.ELEMENT) {
		for (var d = d.childNodes, e = d.length, f = c ? 1 : -1, g = c ? 0 : e - 1; 0 <= g && g < e; g += f) {
			var h = d[g];
			if (!goog.dom.browserrange.canContainRangeEndpoint(h) && 0 == this.compareNodeEndpoints_(h, a, a)) return c ? g : g + 1
		}
		return -1 == g ? 0 : g
	}
	e = this.range_.duplicate();
	f = goog.dom.browserrange.IeRange.getBrowserRangeForNode_(d);
	e.setEndPoint(c ? "EndToEnd" :
		"StartToStart", f);
	e = e.text.length;
	return c ? d.length - e : e
};
goog.dom.browserrange.IeRange.getNodeText_ = function (a) {
	return a.nodeType == goog.dom.NodeType.TEXT ? a.nodeValue : a.innerText
};
goog.dom.browserrange.IeRange.prototype.isRangeInDocument = function () {
	var a = this.doc_.body.createTextRange();
	a.moveToElementText(this.doc_.body);
	return this.containsRange(new goog.dom.browserrange.IeRange(a, this.doc_), !0)
};
goog.dom.browserrange.IeRange.prototype.isCollapsed = function () {
	return 0 == this.range_.compareEndPoints("StartToEnd", this.range_)
};
goog.dom.browserrange.IeRange.prototype.getText = function () {
	return this.range_.text
};
goog.dom.browserrange.IeRange.prototype.getValidHtml = function () {
	return this.range_.htmlText
};
goog.dom.browserrange.IeRange.prototype.select = function () {
	this.range_.select()
};
goog.dom.browserrange.IeRange.prototype.removeContents = function () {
	if (this.range_.htmlText) {
		var a = this.getStartNode(),
			b = this.getEndNode(),
			c = this.range_.text,
			d = this.range_.duplicate();
		d.moveStart("character", 1);
		d.moveStart("character", -1);
		if (d.text != c) {
			var e = new goog.dom.NodeIterator(a, !1, !0),
				f = [];
			goog.iter.forEach(e, function (a) {
				a.nodeType != goog.dom.NodeType.TEXT && this.containsNode(a) && (f.push(a), e.skipTag());
				if (a == b) throw goog.iter.StopIteration;
			});
			this.collapse(!0);
			goog.array.forEach(f, goog.dom.removeNode);
			this.clearCachedValues_()
		} else {
			this.range_ = d;
			this.range_.text = "";
			this.clearCachedValues_();
			c = this.getStartNode();
			d = this.getStartOffset();
			try {
				var g = a.nextSibling;
				a == b && (a.parentNode && a.nodeType == goog.dom.NodeType.TEXT && g && g.nodeType == goog.dom.NodeType.TEXT) && (a.nodeValue += g.nodeValue, goog.dom.removeNode(g), this.range_ = goog.dom.browserrange.IeRange.getBrowserRangeForNode_(c), this.range_.move("character", d), this.clearCachedValues_())
			} catch (h) {}
		}
	}
};
goog.dom.browserrange.IeRange.getDomHelper_ = function (a) {
	return goog.dom.getDomHelper(a.parentElement())
};
goog.dom.browserrange.IeRange.pasteElement_ = function (a, b, c) {
	var c = c || goog.dom.browserrange.IeRange.getDomHelper_(a),
		d, e = d = b.id;
	d || (d = b.id = goog.string.createUniqueString());
	a.pasteHTML(b.outerHTML);
	(b = c.getElement(d)) && (e || b.removeAttribute("id"));
	return b
};
goog.dom.browserrange.IeRange.prototype.surroundContents = function (a) {
	goog.dom.removeNode(a);
	a.innerHTML = this.range_.htmlText;
	(a = goog.dom.browserrange.IeRange.pasteElement_(this.range_, a)) && this.range_.moveToElementText(a);
	this.clearCachedValues_();
	return a
};
goog.dom.browserrange.IeRange.insertNode_ = function (a, b, c, d) {
	var d = d || goog.dom.browserrange.IeRange.getDomHelper_(a),
		e;
	b.nodeType != goog.dom.NodeType.ELEMENT && (e = !0, b = d.createDom(goog.dom.TagName.DIV, null, b));
	a.collapse(c);
	b = goog.dom.browserrange.IeRange.pasteElement_(a, b, d);
	e && (a = b.firstChild, d.flattenElement(b), b = a);
	return b
};
goog.dom.browserrange.IeRange.prototype.insertNode = function (a, b) {
	var c = goog.dom.browserrange.IeRange.insertNode_(this.range_.duplicate(), a, b);
	this.clearCachedValues_();
	return c
};
goog.dom.browserrange.IeRange.prototype.surroundWithNodes = function (a, b) {
	var c = this.range_.duplicate(),
		d = this.range_.duplicate();
	goog.dom.browserrange.IeRange.insertNode_(c, a, !0);
	goog.dom.browserrange.IeRange.insertNode_(d, b, !1);
	this.clearCachedValues_()
};
goog.dom.browserrange.IeRange.prototype.collapse = function (a) {
	this.range_.collapse(a);
	a ? (this.endNode_ = this.startNode_, this.endOffset_ = this.startOffset_) : (this.startNode_ = this.endNode_, this.startOffset_ = this.endOffset_)
};
goog.dom.browserrange.GeckoRange = function (a) {
	goog.dom.browserrange.W3cRange.call(this, a)
};
goog.inherits(goog.dom.browserrange.GeckoRange, goog.dom.browserrange.W3cRange);
goog.dom.browserrange.GeckoRange.createFromNodeContents = function (a) {
	return new goog.dom.browserrange.GeckoRange(goog.dom.browserrange.W3cRange.getBrowserRangeForNode(a))
};
goog.dom.browserrange.GeckoRange.createFromNodes = function (a, b, c, d) {
	return new goog.dom.browserrange.GeckoRange(goog.dom.browserrange.W3cRange.getBrowserRangeForNodes(a, b, c, d))
};
goog.dom.browserrange.GeckoRange.prototype.selectInternal = function (a, b) {
	var c = b ? this.getEndNode() : this.getStartNode(),
		d = b ? this.getEndOffset() : this.getStartOffset(),
		e = b ? this.getStartNode() : this.getEndNode(),
		f = b ? this.getStartOffset() : this.getEndOffset();
	a.collapse(c, d);
	(c != e || d != f) && a.extend(e, f)
};
goog.dom.browserrange.OperaRange = function (a) {
	goog.dom.browserrange.W3cRange.call(this, a)
};
goog.inherits(goog.dom.browserrange.OperaRange, goog.dom.browserrange.W3cRange);
goog.dom.browserrange.OperaRange.createFromNodeContents = function (a) {
	return new goog.dom.browserrange.OperaRange(goog.dom.browserrange.W3cRange.getBrowserRangeForNode(a))
};
goog.dom.browserrange.OperaRange.createFromNodes = function (a, b, c, d) {
	return new goog.dom.browserrange.OperaRange(goog.dom.browserrange.W3cRange.getBrowserRangeForNodes(a, b, c, d))
};
goog.dom.browserrange.OperaRange.prototype.selectInternal = function (a) {
	a.collapse(this.getStartNode(), this.getStartOffset());
	(this.getEndNode() != this.getStartNode() || this.getEndOffset() != this.getStartOffset()) && a.extend(this.getEndNode(), this.getEndOffset());
	0 == a.rangeCount && a.addRange(this.range_)
};
goog.dom.browserrange.Error = {
	NOT_IMPLEMENTED: "Not Implemented"
};
goog.dom.browserrange.createRange = function (a) {
	return goog.userAgent.IE ? new goog.dom.browserrange.IeRange(a, goog.dom.getOwnerDocument(a.parentElement())) : goog.userAgent.WEBKIT ? new goog.dom.browserrange.WebKitRange(a) : goog.userAgent.GECKO ? new goog.dom.browserrange.GeckoRange(a) : goog.userAgent.OPERA ? new goog.dom.browserrange.OperaRange(a) : new goog.dom.browserrange.W3cRange(a)
};
goog.dom.browserrange.createRangeFromNodeContents = function (a) {
	return goog.userAgent.IE ? goog.dom.browserrange.IeRange.createFromNodeContents(a) : goog.userAgent.WEBKIT ? goog.dom.browserrange.WebKitRange.createFromNodeContents(a) : goog.userAgent.GECKO ? goog.dom.browserrange.GeckoRange.createFromNodeContents(a) : goog.userAgent.OPERA ? goog.dom.browserrange.OperaRange.createFromNodeContents(a) : goog.dom.browserrange.W3cRange.createFromNodeContents(a)
};
goog.dom.browserrange.createRangeFromNodes = function (a, b, c, d) {
	return goog.userAgent.IE ? goog.dom.browserrange.IeRange.createFromNodes(a, b, c, d) : goog.userAgent.WEBKIT ? goog.dom.browserrange.WebKitRange.createFromNodes(a, b, c, d) : goog.userAgent.GECKO ? goog.dom.browserrange.GeckoRange.createFromNodes(a, b, c, d) : goog.userAgent.OPERA ? goog.dom.browserrange.OperaRange.createFromNodes(a, b, c, d) : goog.dom.browserrange.W3cRange.createFromNodes(a, b, c, d)
};
goog.dom.browserrange.canContainRangeEndpoint = function (a) {
	return goog.dom.canHaveChildren(a) || a.nodeType == goog.dom.NodeType.TEXT
};
goog.dom.TextRange = function () {};
goog.inherits(goog.dom.TextRange, goog.dom.AbstractRange);
goog.dom.TextRange.createFromBrowserRange = function (a, b) {
	return goog.dom.TextRange.createFromBrowserRangeWrapper_(goog.dom.browserrange.createRange(a), b)
};
goog.dom.TextRange.createFromBrowserRangeWrapper_ = function (a, b) {
	var c = new goog.dom.TextRange;
	c.browserRangeWrapper_ = a;
	c.isReversed_ = !! b;
	return c
};
goog.dom.TextRange.createFromNodeContents = function (a, b) {
	return goog.dom.TextRange.createFromBrowserRangeWrapper_(goog.dom.browserrange.createRangeFromNodeContents(a), b)
};
goog.dom.TextRange.createFromNodes = function (a, b, c, d) {
	var e = new goog.dom.TextRange;
	e.isReversed_ = goog.dom.Range.isReversed(a, b, c, d);
	if ("BR" == a.tagName) var f = a.parentNode,
	b = goog.array.indexOf(f.childNodes, a), a = f;
	"BR" == c.tagName && (f = c.parentNode, d = goog.array.indexOf(f.childNodes, c), c = f);
	e.isReversed_ ? (e.startNode_ = c, e.startOffset_ = d, e.endNode_ = a, e.endOffset_ = b) : (e.startNode_ = a, e.startOffset_ = b, e.endNode_ = c, e.endOffset_ = d);
	return e
};
goog.dom.TextRange.prototype.browserRangeWrapper_ = null;
goog.dom.TextRange.prototype.startNode_ = null;
goog.dom.TextRange.prototype.startOffset_ = null;
goog.dom.TextRange.prototype.endNode_ = null;
goog.dom.TextRange.prototype.endOffset_ = null;
goog.dom.TextRange.prototype.isReversed_ = !1;
goog.dom.TextRange.prototype.clone = function () {
	var a = new goog.dom.TextRange;
	a.browserRangeWrapper_ = this.browserRangeWrapper_;
	a.startNode_ = this.startNode_;
	a.startOffset_ = this.startOffset_;
	a.endNode_ = this.endNode_;
	a.endOffset_ = this.endOffset_;
	a.isReversed_ = this.isReversed_;
	return a
};
goog.dom.TextRange.prototype.getType = function () {
	return goog.dom.RangeType.TEXT
};
goog.dom.TextRange.prototype.getBrowserRangeObject = function () {
	return this.getBrowserRangeWrapper_().getBrowserRange()
};
goog.dom.TextRange.prototype.setBrowserRangeObject = function (a) {
	if (goog.dom.AbstractRange.isNativeControlRange(a)) return !1;
	this.browserRangeWrapper_ = goog.dom.browserrange.createRange(a);
	this.clearCachedValues_();
	return !0
};
goog.dom.TextRange.prototype.clearCachedValues_ = function () {
	this.startNode_ = this.startOffset_ = this.endNode_ = this.endOffset_ = null
};
goog.dom.TextRange.prototype.getTextRangeCount = function () {
	return 1
};
goog.dom.TextRange.prototype.getTextRange = function () {
	return this
};
goog.dom.TextRange.prototype.getBrowserRangeWrapper_ = function () {
	return this.browserRangeWrapper_ || (this.browserRangeWrapper_ = goog.dom.browserrange.createRangeFromNodes(this.getStartNode(), this.getStartOffset(), this.getEndNode(), this.getEndOffset()))
};
goog.dom.TextRange.prototype.getContainer = function () {
	return this.getBrowserRangeWrapper_().getContainer()
};
goog.dom.TextRange.prototype.getStartNode = function () {
	return this.startNode_ || (this.startNode_ = this.getBrowserRangeWrapper_().getStartNode())
};
goog.dom.TextRange.prototype.getStartOffset = function () {
	return null != this.startOffset_ ? this.startOffset_ : this.startOffset_ = this.getBrowserRangeWrapper_().getStartOffset()
};
goog.dom.TextRange.prototype.getEndNode = function () {
	return this.endNode_ || (this.endNode_ = this.getBrowserRangeWrapper_().getEndNode())
};
goog.dom.TextRange.prototype.getEndOffset = function () {
	return null != this.endOffset_ ? this.endOffset_ : this.endOffset_ = this.getBrowserRangeWrapper_().getEndOffset()
};
goog.dom.TextRange.prototype.moveToNodes = function (a, b, c, d, e) {
	this.startNode_ = a;
	this.startOffset_ = b;
	this.endNode_ = c;
	this.endOffset_ = d;
	this.isReversed_ = e;
	this.browserRangeWrapper_ = null
};
goog.dom.TextRange.prototype.isReversed = function () {
	return this.isReversed_
};
goog.dom.TextRange.prototype.containsRange = function (a, b) {
	var c = a.getType();
	return c == goog.dom.RangeType.TEXT ? this.getBrowserRangeWrapper_().containsRange(a.getBrowserRangeWrapper_(), b) : c == goog.dom.RangeType.CONTROL ? (c = a.getElements(), (b ? goog.array.some : goog.array.every)(c, function (a) {
		return this.containsNode(a, b)
	}, this)) : !1
};
goog.dom.TextRange.isAttachedNode = function (a) {
	if (goog.userAgent.IE) {
		var b = !1;
		try {
			b = a.parentNode
		} catch (c) {}
		return !!b
	}
	return goog.dom.contains(a.ownerDocument.body, a)
};
goog.dom.TextRange.prototype.isRangeInDocument = function () {
	return (!this.startNode_ || goog.dom.TextRange.isAttachedNode(this.startNode_)) && (!this.endNode_ || goog.dom.TextRange.isAttachedNode(this.endNode_)) && (!goog.userAgent.IE || this.getBrowserRangeWrapper_().isRangeInDocument())
};
goog.dom.TextRange.prototype.isCollapsed = function () {
	return this.getBrowserRangeWrapper_().isCollapsed()
};
goog.dom.TextRange.prototype.getText = function () {
	return this.getBrowserRangeWrapper_().getText()
};
goog.dom.TextRange.prototype.getHtmlFragment = function () {
	return this.getBrowserRangeWrapper_().getHtmlFragment()
};
goog.dom.TextRange.prototype.getValidHtml = function () {
	return this.getBrowserRangeWrapper_().getValidHtml()
};
goog.dom.TextRange.prototype.getPastableHtml = function () {
	var a = this.getValidHtml();
	if (a.match(/^\s*<td\b/i)) a = "<table><tbody><tr>" + a + "</tr></tbody></table>";
	else if (a.match(/^\s*<tr\b/i)) a = "<table><tbody>" + a + "</tbody></table>";
	else if (a.match(/^\s*<tbody\b/i)) a = "<table>" + a + "</table>";
	else if (a.match(/^\s*<li\b/i)) {
		for (var b = this.getContainer(), c = goog.dom.TagName.UL; b;) {
			if (b.tagName == goog.dom.TagName.OL) {
				c = goog.dom.TagName.OL;
				break
			} else if (b.tagName == goog.dom.TagName.UL) break;
			b = b.parentNode
		}
		a = goog.string.buildString("<",
			c, ">", a, "</", c, ">")
	}
	return a
};
goog.dom.TextRange.prototype.__iterator__ = function () {
	return new goog.dom.TextRangeIterator(this.getStartNode(), this.getStartOffset(), this.getEndNode(), this.getEndOffset())
};
goog.dom.TextRange.prototype.select = function () {
	this.getBrowserRangeWrapper_().select(this.isReversed_)
};
goog.dom.TextRange.prototype.removeContents = function () {
	this.getBrowserRangeWrapper_().removeContents();
	this.clearCachedValues_()
};
goog.dom.TextRange.prototype.surroundContents = function (a) {
	a = this.getBrowserRangeWrapper_().surroundContents(a);
	this.clearCachedValues_();
	return a
};
goog.dom.TextRange.prototype.insertNode = function (a, b) {
	var c = this.getBrowserRangeWrapper_().insertNode(a, b);
	this.clearCachedValues_();
	return c
};
goog.dom.TextRange.prototype.surroundWithNodes = function (a, b) {
	this.getBrowserRangeWrapper_().surroundWithNodes(a, b);
	this.clearCachedValues_()
};
goog.dom.TextRange.prototype.saveUsingDom = function () {
	return new goog.dom.DomSavedTextRange_(this)
};
goog.dom.TextRange.prototype.collapse = function (a) {
	a = this.isReversed() ? !a : a;
	this.browserRangeWrapper_ && this.browserRangeWrapper_.collapse(a);
	a ? (this.endNode_ = this.startNode_, this.endOffset_ = this.startOffset_) : (this.startNode_ = this.endNode_, this.startOffset_ = this.endOffset_);
	this.isReversed_ = !1
};
goog.dom.DomSavedTextRange_ = function (a) {
	this.anchorNode_ = a.getAnchorNode();
	this.anchorOffset_ = a.getAnchorOffset();
	this.focusNode_ = a.getFocusNode();
	this.focusOffset_ = a.getFocusOffset()
};
goog.inherits(goog.dom.DomSavedTextRange_, goog.dom.SavedRange);
goog.dom.DomSavedTextRange_.prototype.restoreInternal = function () {
	return goog.dom.Range.createFromNodes(this.anchorNode_, this.anchorOffset_, this.focusNode_, this.focusOffset_)
};
goog.dom.DomSavedTextRange_.prototype.disposeInternal = function () {
	goog.dom.DomSavedTextRange_.superClass_.disposeInternal.call(this);
	this.focusNode_ = this.anchorNode_ = null
};
goog.dom.ControlRange = function () {};
goog.inherits(goog.dom.ControlRange, goog.dom.AbstractMultiRange);
goog.dom.ControlRange.createFromBrowserRange = function (a) {
	var b = new goog.dom.ControlRange;
	b.range_ = a;
	return b
};
goog.dom.ControlRange.createFromElements = function (a) {
	for (var b = goog.dom.getOwnerDocument(arguments[0]).body.createControlRange(), c = 0, d = arguments.length; c < d; c++) b.addElement(arguments[c]);
	return goog.dom.ControlRange.createFromBrowserRange(b)
};
goog.dom.ControlRange.prototype.range_ = null;
goog.dom.ControlRange.prototype.elements_ = null;
goog.dom.ControlRange.prototype.sortedElements_ = null;
goog.dom.ControlRange.prototype.clearCachedValues_ = function () {
	this.sortedElements_ = this.elements_ = null
};
goog.dom.ControlRange.prototype.clone = function () {
	return goog.dom.ControlRange.createFromElements.apply(this, this.getElements())
};
goog.dom.ControlRange.prototype.getType = function () {
	return goog.dom.RangeType.CONTROL
};
goog.dom.ControlRange.prototype.getBrowserRangeObject = function () {
	return this.range_ || document.body.createControlRange()
};
goog.dom.ControlRange.prototype.setBrowserRangeObject = function (a) {
	if (!goog.dom.AbstractRange.isNativeControlRange(a)) return !1;
	this.range_ = a;
	return !0
};
goog.dom.ControlRange.prototype.getTextRangeCount = function () {
	return this.range_ ? this.range_.length : 0
};
goog.dom.ControlRange.prototype.getTextRange = function (a) {
	return goog.dom.TextRange.createFromNodeContents(this.range_.item(a))
};
goog.dom.ControlRange.prototype.getContainer = function () {
	return goog.dom.findCommonAncestor.apply(null, this.getElements())
};
goog.dom.ControlRange.prototype.getStartNode = function () {
	return this.getSortedElements()[0]
};
goog.dom.ControlRange.prototype.getStartOffset = function () {
	return 0
};
goog.dom.ControlRange.prototype.getEndNode = function () {
	var a = this.getSortedElements(),
		b = goog.array.peek(a);
	return goog.array.find(a, function (a) {
		return goog.dom.contains(a, b)
	})
};
goog.dom.ControlRange.prototype.getEndOffset = function () {
	return this.getEndNode().childNodes.length
};
goog.dom.ControlRange.prototype.getElements = function () {
	if (!this.elements_ && (this.elements_ = [], this.range_))
		for (var a = 0; a < this.range_.length; a++) this.elements_.push(this.range_.item(a));
	return this.elements_
};
goog.dom.ControlRange.prototype.getSortedElements = function () {
	this.sortedElements_ || (this.sortedElements_ = this.getElements().concat(), this.sortedElements_.sort(function (a, b) {
		return a.sourceIndex - b.sourceIndex
	}));
	return this.sortedElements_
};
goog.dom.ControlRange.prototype.isRangeInDocument = function () {
	var a = !1;
	try {
		a = goog.array.every(this.getElements(), function (a) {
			return goog.userAgent.IE ? a.parentNode : goog.dom.contains(a.ownerDocument.body, a)
		})
	} catch (b) {}
	return a
};
goog.dom.ControlRange.prototype.isCollapsed = function () {
	return !this.range_ || !this.range_.length
};
goog.dom.ControlRange.prototype.getText = function () {
	return ""
};
goog.dom.ControlRange.prototype.getHtmlFragment = function () {
	return goog.array.map(this.getSortedElements(), goog.dom.getOuterHtml).join("")
};
goog.dom.ControlRange.prototype.getValidHtml = function () {
	return this.getHtmlFragment()
};
goog.dom.ControlRange.prototype.getPastableHtml = goog.dom.ControlRange.prototype.getValidHtml;
goog.dom.ControlRange.prototype.__iterator__ = function () {
	return new goog.dom.ControlRangeIterator(this)
};
goog.dom.ControlRange.prototype.select = function () {
	this.range_ && this.range_.select()
};
goog.dom.ControlRange.prototype.removeContents = function () {
	if (this.range_) {
		for (var a = [], b = 0, c = this.range_.length; b < c; b++) a.push(this.range_.item(b));
		goog.array.forEach(a, goog.dom.removeNode);
		this.collapse(!1)
	}
};
goog.dom.ControlRange.prototype.replaceContentsWithNode = function (a) {
	a = this.insertNode(a, !0);
	this.isCollapsed() || this.removeContents();
	return a
};
goog.dom.ControlRange.prototype.saveUsingDom = function () {
	return new goog.dom.DomSavedControlRange_(this)
};
goog.dom.ControlRange.prototype.collapse = function () {
	this.range_ = null;
	this.clearCachedValues_()
};
goog.dom.DomSavedControlRange_ = function (a) {
	this.elements_ = a.getElements()
};
goog.inherits(goog.dom.DomSavedControlRange_, goog.dom.SavedRange);
goog.dom.DomSavedControlRange_.prototype.restoreInternal = function () {
	for (var a = (this.elements_.length ? goog.dom.getOwnerDocument(this.elements_[0]) : document).body.createControlRange(), b = 0, c = this.elements_.length; b < c; b++) a.addElement(this.elements_[b]);
	return goog.dom.ControlRange.createFromBrowserRange(a)
};
goog.dom.DomSavedControlRange_.prototype.disposeInternal = function () {
	goog.dom.DomSavedControlRange_.superClass_.disposeInternal.call(this);
	delete this.elements_
};
goog.dom.ControlRangeIterator = function (a) {
	a && (this.elements_ = a.getSortedElements(), this.startNode_ = this.elements_.shift(), this.endNode_ = goog.array.peek(this.elements_) || this.startNode_);
	goog.dom.RangeIterator.call(this, this.startNode_, !1)
};
goog.inherits(goog.dom.ControlRangeIterator, goog.dom.RangeIterator);
goog.dom.ControlRangeIterator.prototype.startNode_ = null;
goog.dom.ControlRangeIterator.prototype.endNode_ = null;
goog.dom.ControlRangeIterator.prototype.elements_ = null;
goog.dom.ControlRangeIterator.prototype.getStartTextOffset = function () {
	return 0
};
goog.dom.ControlRangeIterator.prototype.getEndTextOffset = function () {
	return 0
};
goog.dom.ControlRangeIterator.prototype.getStartNode = function () {
	return this.startNode_
};
goog.dom.ControlRangeIterator.prototype.getEndNode = function () {
	return this.endNode_
};
goog.dom.ControlRangeIterator.prototype.isLast = function () {
	return !this.depth && !this.elements_.length
};
goog.dom.ControlRangeIterator.prototype.next = function () {
	if (this.isLast()) throw goog.iter.StopIteration;
	if (!this.depth) {
		var a = this.elements_.shift();
		this.setPosition(a, goog.dom.TagWalkType.START_TAG, goog.dom.TagWalkType.START_TAG);
		return a
	}
	return goog.dom.ControlRangeIterator.superClass_.next.call(this)
};
goog.dom.ControlRangeIterator.prototype.copyFrom = function (a) {
	this.elements_ = a.elements_;
	this.startNode_ = a.startNode_;
	this.endNode_ = a.endNode_;
	goog.dom.ControlRangeIterator.superClass_.copyFrom.call(this, a)
};
goog.dom.ControlRangeIterator.prototype.clone = function () {
	var a = new goog.dom.ControlRangeIterator(null);
	a.copyFrom(this);
	return a
};
goog.dom.MultiRange = function () {
	this.browserRanges_ = [];
	this.ranges_ = [];
	this.container_ = this.sortedRanges_ = null
};
goog.inherits(goog.dom.MultiRange, goog.dom.AbstractMultiRange);
goog.dom.MultiRange.createFromBrowserSelection = function (a) {
	for (var b = new goog.dom.MultiRange, c = 0, d = a.rangeCount; c < d; c++) b.browserRanges_.push(a.getRangeAt(c));
	return b
};
goog.dom.MultiRange.createFromBrowserRanges = function (a) {
	var b = new goog.dom.MultiRange;
	b.browserRanges_ = goog.array.clone(a);
	return b
};
goog.dom.MultiRange.createFromTextRanges = function (a) {
	var b = new goog.dom.MultiRange;
	b.ranges_ = a;
	b.browserRanges_ = goog.array.map(a, function (a) {
		return a.getBrowserRangeObject()
	});
	return b
};
goog.dom.MultiRange.prototype.logger_ = goog.debug.Logger.getLogger("goog.dom.MultiRange");
goog.dom.MultiRange.prototype.clearCachedValues_ = function () {
	this.ranges_ = [];
	this.container_ = this.sortedRanges_ = null
};
goog.dom.MultiRange.prototype.clone = function () {
	return goog.dom.MultiRange.createFromBrowserRanges(this.browserRanges_)
};
goog.dom.MultiRange.prototype.getType = function () {
	return goog.dom.RangeType.MULTI
};
goog.dom.MultiRange.prototype.getBrowserRangeObject = function () {
	1 < this.browserRanges_.length && this.logger_.warning("getBrowserRangeObject called on MultiRange with more than 1 range");
	return this.browserRanges_[0]
};
goog.dom.MultiRange.prototype.setBrowserRangeObject = function () {
	return !1
};
goog.dom.MultiRange.prototype.getTextRangeCount = function () {
	return this.browserRanges_.length
};
goog.dom.MultiRange.prototype.getTextRange = function (a) {
	this.ranges_[a] || (this.ranges_[a] = goog.dom.TextRange.createFromBrowserRange(this.browserRanges_[a]));
	return this.ranges_[a]
};
goog.dom.MultiRange.prototype.getContainer = function () {
	if (!this.container_) {
		for (var a = [], b = 0, c = this.getTextRangeCount(); b < c; b++) a.push(this.getTextRange(b).getContainer());
		this.container_ = goog.dom.findCommonAncestor.apply(null, a)
	}
	return this.container_
};
goog.dom.MultiRange.prototype.getSortedRanges = function () {
	this.sortedRanges_ || (this.sortedRanges_ = this.getTextRanges(), this.sortedRanges_.sort(function (a, b) {
		var c = a.getStartNode(),
			d = a.getStartOffset(),
			e = b.getStartNode(),
			f = b.getStartOffset();
		return c == e && d == f ? 0 : goog.dom.Range.isReversed(c, d, e, f) ? 1 : -1
	}));
	return this.sortedRanges_
};
goog.dom.MultiRange.prototype.getStartNode = function () {
	return this.getSortedRanges()[0].getStartNode()
};
goog.dom.MultiRange.prototype.getStartOffset = function () {
	return this.getSortedRanges()[0].getStartOffset()
};
goog.dom.MultiRange.prototype.getEndNode = function () {
	return goog.array.peek(this.getSortedRanges()).getEndNode()
};
goog.dom.MultiRange.prototype.getEndOffset = function () {
	return goog.array.peek(this.getSortedRanges()).getEndOffset()
};
goog.dom.MultiRange.prototype.isRangeInDocument = function () {
	return goog.array.every(this.getTextRanges(), function (a) {
		return a.isRangeInDocument()
	})
};
goog.dom.MultiRange.prototype.isCollapsed = function () {
	return 0 == this.browserRanges_.length || 1 == this.browserRanges_.length && this.getTextRange(0).isCollapsed()
};
goog.dom.MultiRange.prototype.getText = function () {
	return goog.array.map(this.getTextRanges(), function (a) {
		return a.getText()
	}).join("")
};
goog.dom.MultiRange.prototype.getHtmlFragment = function () {
	return this.getValidHtml()
};
goog.dom.MultiRange.prototype.getValidHtml = function () {
	return goog.array.map(this.getTextRanges(), function (a) {
		return a.getValidHtml()
	}).join("")
};
goog.dom.MultiRange.prototype.getPastableHtml = function () {
	return this.getValidHtml()
};
goog.dom.MultiRange.prototype.__iterator__ = function () {
	return new goog.dom.MultiRangeIterator(this)
};
goog.dom.MultiRange.prototype.select = function () {
	var a = goog.dom.AbstractRange.getBrowserSelectionForWindow(this.getWindow());
	a.removeAllRanges();
	for (var b = 0, c = this.getTextRangeCount(); b < c; b++) a.addRange(this.getTextRange(b).getBrowserRangeObject())
};
goog.dom.MultiRange.prototype.removeContents = function () {
	goog.array.forEach(this.getTextRanges(), function (a) {
		a.removeContents()
	})
};
goog.dom.MultiRange.prototype.saveUsingDom = function () {
	return new goog.dom.DomSavedMultiRange_(this)
};
goog.dom.MultiRange.prototype.collapse = function (a) {
	if (!this.isCollapsed()) {
		var b = a ? this.getTextRange(0) : this.getTextRange(this.getTextRangeCount() - 1);
		this.clearCachedValues_();
		b.collapse(a);
		this.ranges_ = [b];
		this.sortedRanges_ = [b];
		this.browserRanges_ = [b.getBrowserRangeObject()]
	}
};
goog.dom.DomSavedMultiRange_ = function (a) {
	this.savedRanges_ = goog.array.map(a.getTextRanges(), function (a) {
		return a.saveUsingDom()
	})
};
goog.inherits(goog.dom.DomSavedMultiRange_, goog.dom.SavedRange);
goog.dom.DomSavedMultiRange_.prototype.restoreInternal = function () {
	var a = goog.array.map(this.savedRanges_, function (a) {
		return a.restore()
	});
	return goog.dom.MultiRange.createFromTextRanges(a)
};
goog.dom.DomSavedMultiRange_.prototype.disposeInternal = function () {
	goog.dom.DomSavedMultiRange_.superClass_.disposeInternal.call(this);
	goog.array.forEach(this.savedRanges_, function (a) {
		a.dispose()
	});
	delete this.savedRanges_
};
goog.dom.MultiRangeIterator = function (a) {
	a && (this.iterators_ = goog.array.map(a.getSortedRanges(), function (a) {
		return goog.iter.toIterator(a)
	}));
	goog.dom.RangeIterator.call(this, a ? this.getStartNode() : null, !1)
};
goog.inherits(goog.dom.MultiRangeIterator, goog.dom.RangeIterator);
goog.dom.MultiRangeIterator.prototype.iterators_ = null;
goog.dom.MultiRangeIterator.prototype.currentIdx_ = 0;
goog.dom.MultiRangeIterator.prototype.getStartTextOffset = function () {
	return this.iterators_[this.currentIdx_].getStartTextOffset()
};
goog.dom.MultiRangeIterator.prototype.getEndTextOffset = function () {
	return this.iterators_[this.currentIdx_].getEndTextOffset()
};
goog.dom.MultiRangeIterator.prototype.getStartNode = function () {
	return this.iterators_[0].getStartNode()
};
goog.dom.MultiRangeIterator.prototype.getEndNode = function () {
	return goog.array.peek(this.iterators_).getEndNode()
};
goog.dom.MultiRangeIterator.prototype.isLast = function () {
	return this.iterators_[this.currentIdx_].isLast()
};
goog.dom.MultiRangeIterator.prototype.next = function () {
	try {
		var a = this.iterators_[this.currentIdx_],
			b = a.next();
		this.setPosition(a.node, a.tagType, a.depth);
		return b
	} catch (c) {
		if (c !== goog.iter.StopIteration || this.iterators_.length - 1 == this.currentIdx_) throw c;
		this.currentIdx_++;
		return this.next()
	}
};
goog.dom.MultiRangeIterator.prototype.copyFrom = function (a) {
	this.iterators_ = goog.array.clone(a.iterators_);
	goog.dom.MultiRangeIterator.superClass_.copyFrom.call(this, a)
};
goog.dom.MultiRangeIterator.prototype.clone = function () {
	var a = new goog.dom.MultiRangeIterator(null);
	a.copyFrom(this);
	return a
};
goog.dom.Range = {};
goog.dom.Range.createFromWindow = function (a) {
	return (a = goog.dom.AbstractRange.getBrowserSelectionForWindow(a || window)) && goog.dom.Range.createFromBrowserSelection(a)
};
goog.dom.Range.createFromBrowserSelection = function (a) {
	var b, c = !1;
	if (a.createRange) try {
		b = a.createRange()
	} catch (d) {
		return null
	} else if (a.rangeCount) {
		if (1 < a.rangeCount) return goog.dom.MultiRange.createFromBrowserSelection(a);
		b = a.getRangeAt(0);
		c = goog.dom.Range.isReversed(a.anchorNode, a.anchorOffset, a.focusNode, a.focusOffset)
	} else return null;
	return goog.dom.Range.createFromBrowserRange(b, c)
};
goog.dom.Range.createFromBrowserRange = function (a, b) {
	return goog.dom.AbstractRange.isNativeControlRange(a) ? goog.dom.ControlRange.createFromBrowserRange(a) : goog.dom.TextRange.createFromBrowserRange(a, b)
};
goog.dom.Range.createFromNodeContents = function (a, b) {
	return goog.dom.TextRange.createFromNodeContents(a, b)
};
goog.dom.Range.createCaret = function (a, b) {
	return goog.dom.TextRange.createFromNodes(a, b, a, b)
};
goog.dom.Range.createFromNodes = function (a, b, c, d) {
	return goog.dom.TextRange.createFromNodes(a, b, c, d)
};
goog.dom.Range.clearSelection = function (a) {
	if (a = goog.dom.AbstractRange.getBrowserSelectionForWindow(a || window))
		if (a.empty) try {
			a.empty()
		} catch (b) {} else a.removeAllRanges()
};
goog.dom.Range.hasSelection = function (a) {
	a = goog.dom.AbstractRange.getBrowserSelectionForWindow(a || window);
	return !!a && (goog.userAgent.IE ? "None" != a.type : !! a.rangeCount)
};
goog.dom.Range.isReversed = function (a, b, c, d) {
	if (a == c) return d < b;
	var e;
	if (a.nodeType == goog.dom.NodeType.ELEMENT && b)
		if (e = a.childNodes[b]) a = e, b = 0;
		else if (goog.dom.contains(a, c)) return !0;
	if (c.nodeType == goog.dom.NodeType.ELEMENT && d)
		if (e = c.childNodes[d]) c = e, d = 0;
		else if (goog.dom.contains(c, a)) return !1;
	return 0 < (goog.dom.compareNodeOrder(a, c) || b - d)
};
goog.editor.range = {};
goog.editor.range.narrow = function (a, b) {
	var c = a.getStartNode(),
		d = a.getEndNode();
	if (c && d) {
		var e = function (a) {
			return a == b
		}, c = goog.dom.getAncestor(c, e, !0),
			d = goog.dom.getAncestor(d, e, !0);
		if (c && d) return a.clone();
		if (c) return d = goog.editor.node.getRightMostLeaf(b), goog.dom.Range.createFromNodes(a.getStartNode(), a.getStartOffset(), d, goog.editor.node.getLength(d));
		if (d) return goog.dom.Range.createFromNodes(goog.editor.node.getLeftMostLeaf(b), 0, a.getEndNode(), a.getEndOffset())
	}
	return null
};
goog.editor.range.expand = function (a, b) {
	var c = goog.editor.range.expandEndPointToContainer_(a, goog.dom.RangeEndpoint.START, b),
		c = goog.editor.range.expandEndPointToContainer_(c, goog.dom.RangeEndpoint.END, b),
		d = c.getStartNode(),
		e = c.getEndNode(),
		f = c.getStartOffset(),
		c = c.getEndOffset();
	if (d == e) {
		for (; e != b && 0 == f && c == goog.editor.node.getLength(e);) d = e.parentNode, f = goog.array.indexOf(d.childNodes, e), c = f + 1, e = d;
		d = e
	}
	return goog.dom.Range.createFromNodes(d, f, e, c)
};
goog.editor.range.expandEndPointToContainer_ = function (a, b, c) {
	for (var d = (b = b == goog.dom.RangeEndpoint.START) ? a.getStartNode() : a.getEndNode(), e = b ? a.getStartOffset() : a.getEndOffset(), f = a.getContainerElement(); d != f && d != c && !(b && 0 != e || !b && e != goog.editor.node.getLength(d));) var g = d.parentNode,
	d = goog.array.indexOf(g.childNodes, d), e = b ? d : d + 1, d = g;
	return goog.dom.Range.createFromNodes(b ? d : a.getStartNode(), b ? e : a.getStartOffset(), b ? a.getEndNode() : d, b ? a.getEndOffset() : e)
};
goog.editor.range.selectNodeStart = function (a) {
	goog.dom.Range.createCaret(goog.editor.node.getLeftMostLeaf(a), 0).select()
};
goog.editor.range.placeCursorNextTo = function (a, b) {
	var c = a.parentNode,
		d = goog.array.indexOf(c.childNodes, a) + (b ? 0 : 1),
		c = goog.editor.range.Point.createDeepestPoint(c, d, b),
		c = goog.dom.Range.createCaret(c.node, c.offset);
	c.select();
	return c
};
goog.editor.range.selectionPreservingNormalize = function (a) {
	var b = goog.dom.getOwnerDocument(a),
		b = goog.dom.Range.createFromWindow(goog.dom.getWindow(b));
	(a = goog.editor.range.rangePreservingNormalize(a, b)) && a.select()
};
goog.editor.range.normalizeNodeIe_ = function (a) {
	for (var b = null, c = a.firstChild; c;) {
		var d = c.nextSibling;
		c.nodeType == goog.dom.NodeType.TEXT ? "" == c.nodeValue ? a.removeChild(c) : b ? (b.nodeValue += c.nodeValue, a.removeChild(c)) : b = c : (goog.editor.range.normalizeNodeIe_(c), b = null);
		c = d
	}
};
goog.editor.range.normalizeNode = function (a) {
	goog.userAgent.IE ? goog.editor.range.normalizeNodeIe_(a) : a.normalize()
};
goog.editor.range.rangePreservingNormalize = function (a, b) {
	if (b) var c = goog.editor.range.normalize(b),
	d = goog.editor.style.getContainer(b.getContainerElement());
	d ? goog.editor.range.normalizeNode(goog.dom.findCommonAncestor(d, a)) : a && goog.editor.range.normalizeNode(a);
	return c ? c() : null
};
goog.editor.range.getDeepEndPoint = function (a, b) {
	return b ? goog.editor.range.Point.createDeepestPoint(a.getStartNode(), a.getStartOffset()) : goog.editor.range.Point.createDeepestPoint(a.getEndNode(), a.getEndOffset())
};
goog.editor.range.normalize = function (a) {
	var b = goog.editor.range.normalizePoint_(goog.editor.range.getDeepEndPoint(a, !0)),
		c = b.getParentPoint(),
		d = b.node.previousSibling;
	b.node.nodeType == goog.dom.NodeType.TEXT && (b.node = null);
	var e = goog.editor.range.normalizePoint_(goog.editor.range.getDeepEndPoint(a, !1)),
		f = e.getParentPoint(),
		g = e.node.previousSibling;
	e.node.nodeType == goog.dom.NodeType.TEXT && (e.node = null);
	return function () {
		if (!b.node && d) {
			b.node = d.nextSibling;
			b.node || (b = goog.editor.range.Point.getPointAtEndOfNode(d))
		}
		if (!e.node &&
			g) {
			e.node = g.nextSibling;
			e.node || (e = goog.editor.range.Point.getPointAtEndOfNode(g))
		}
		return goog.dom.Range.createFromNodes(b.node || c.node.firstChild || c.node, b.offset, e.node || f.node.firstChild || f.node, e.offset)
	}
};
goog.editor.range.normalizePoint_ = function (a) {
	var b;
	if (a.node.nodeType == goog.dom.NodeType.TEXT)
		for (b = a.node.previousSibling; b && b.nodeType == goog.dom.NodeType.TEXT; b = b.previousSibling) a.offset += goog.editor.node.getLength(b);
	else b = a.node.previousSibling;
	var c = a.node.parentNode;
	a.node = b ? b.nextSibling : c.firstChild;
	return a
};
goog.editor.range.isEditable = function (a) {
	var b = a.getContainerElement();
	return a.getStartNode() != b.parentElement && goog.editor.node.isEditableContainer(b) || goog.editor.node.isEditable(b)
};
goog.editor.range.intersectsTag = function (a, b) {
	return goog.dom.getAncestorByTagNameAndClass(a.getContainerElement(), b) ? !0 : goog.iter.some(a, function (a) {
		return a.tagName == b
	})
};
goog.editor.range.Point = function (a, b) {
	this.node = a;
	this.offset = b
};
goog.editor.range.Point.prototype.getParentPoint = function () {
	var a = this.node.parentNode;
	return new goog.editor.range.Point(a, goog.array.indexOf(a.childNodes, this.node))
};
goog.editor.range.Point.createDeepestPoint = function (a, b, c) {
	for (; a.nodeType == goog.dom.NodeType.ELEMENT;) {
		var d = a.childNodes[b];
		if (!d && !a.lastChild) break;
		d ? (a = d.previousSibling, c && a ? b = goog.editor.node.getLength(a) : (a = d, b = 0)) : (a = a.lastChild, b = goog.editor.node.getLength(a))
	}
	return new goog.editor.range.Point(a, b)
};
goog.editor.range.Point.getPointAtEndOfNode = function (a) {
	return new goog.editor.range.Point(a, goog.editor.node.getLength(a))
};
goog.editor.range.saveUsingNormalizedCarets = function (a) {
	return new goog.editor.range.NormalizedCaretRange_(a)
};
goog.editor.range.NormalizedCaretRange_ = function (a) {
	goog.dom.SavedCaretRange.call(this, a)
};
goog.inherits(goog.editor.range.NormalizedCaretRange_, goog.dom.SavedCaretRange);
goog.editor.range.NormalizedCaretRange_.prototype.removeCarets = function (a) {
	var b = this.getCaret(!0),
		c = this.getCaret(!1),
		b = b && c ? goog.dom.findCommonAncestor(b, c) : b || c;
	goog.editor.range.NormalizedCaretRange_.superClass_.removeCarets.call(this);
	if (a) return goog.editor.range.rangePreservingNormalize(b, a);
	b && goog.editor.range.selectionPreservingNormalize(b)
};
goog.uri = {};
goog.uri.utils = {};
goog.uri.utils.CharCode_ = {
	AMPERSAND: 38,
	EQUAL: 61,
	HASH: 35,
	QUESTION: 63
};
goog.uri.utils.buildFromEncodedParts = function (a, b, c, d, e, f, g) {
	var h = [];
	a && h.push(a, ":");
	c && (h.push("//"), b && h.push(b, "@"), h.push(c), d && h.push(":", d));
	e && h.push(e);
	f && h.push("?", f);
	g && h.push("#", g);
	return h.join("")
};
goog.uri.utils.splitRe_ = RegExp("^(?:([^:/?#.]+):)?(?://(?:([^/?#]*)@)?([\\w\\d\\-\\u0100-\\uffff.%]*)(?::([0-9]+))?)?([^?#]+)?(?:\\?([^#]*))?(?:#(.*))?$");
goog.uri.utils.ComponentIndex = {
	SCHEME: 1,
	USER_INFO: 2,
	DOMAIN: 3,
	PORT: 4,
	PATH: 5,
	QUERY_DATA: 6,
	FRAGMENT: 7
};
goog.uri.utils.split = function (a) {
	return a.match(goog.uri.utils.splitRe_)
};
goog.uri.utils.decodeIfPossible_ = function (a) {
	return a && decodeURIComponent(a)
};
goog.uri.utils.getComponentByIndex_ = function (a, b) {
	return goog.uri.utils.split(b)[a] || null
};
goog.uri.utils.getScheme = function (a) {
	return goog.uri.utils.getComponentByIndex_(goog.uri.utils.ComponentIndex.SCHEME, a)
};
goog.uri.utils.getUserInfoEncoded = function (a) {
	return goog.uri.utils.getComponentByIndex_(goog.uri.utils.ComponentIndex.USER_INFO, a)
};
goog.uri.utils.getUserInfo = function (a) {
	return goog.uri.utils.decodeIfPossible_(goog.uri.utils.getUserInfoEncoded(a))
};
goog.uri.utils.getDomainEncoded = function (a) {
	return goog.uri.utils.getComponentByIndex_(goog.uri.utils.ComponentIndex.DOMAIN, a)
};
goog.uri.utils.getDomain = function (a) {
	return goog.uri.utils.decodeIfPossible_(goog.uri.utils.getDomainEncoded(a))
};
goog.uri.utils.getPort = function (a) {
	return Number(goog.uri.utils.getComponentByIndex_(goog.uri.utils.ComponentIndex.PORT, a)) || null
};
goog.uri.utils.getPathEncoded = function (a) {
	return goog.uri.utils.getComponentByIndex_(goog.uri.utils.ComponentIndex.PATH, a)
};
goog.uri.utils.getPath = function (a) {
	return goog.uri.utils.decodeIfPossible_(goog.uri.utils.getPathEncoded(a))
};
goog.uri.utils.getQueryData = function (a) {
	return goog.uri.utils.getComponentByIndex_(goog.uri.utils.ComponentIndex.QUERY_DATA, a)
};
goog.uri.utils.getFragmentEncoded = function (a) {
	var b = a.indexOf("#");
	return 0 > b ? null : a.substr(b + 1)
};
goog.uri.utils.setFragmentEncoded = function (a, b) {
	return goog.uri.utils.removeFragment(a) + (b ? "#" + b : "")
};
goog.uri.utils.getFragment = function (a) {
	return goog.uri.utils.decodeIfPossible_(goog.uri.utils.getFragmentEncoded(a))
};
goog.uri.utils.getHost = function (a) {
	a = goog.uri.utils.split(a);
	return goog.uri.utils.buildFromEncodedParts(a[goog.uri.utils.ComponentIndex.SCHEME], a[goog.uri.utils.ComponentIndex.USER_INFO], a[goog.uri.utils.ComponentIndex.DOMAIN], a[goog.uri.utils.ComponentIndex.PORT])
};
goog.uri.utils.getPathAndAfter = function (a) {
	a = goog.uri.utils.split(a);
	return goog.uri.utils.buildFromEncodedParts(null, null, null, null, a[goog.uri.utils.ComponentIndex.PATH], a[goog.uri.utils.ComponentIndex.QUERY_DATA], a[goog.uri.utils.ComponentIndex.FRAGMENT])
};
goog.uri.utils.removeFragment = function (a) {
	var b = a.indexOf("#");
	return 0 > b ? a : a.substr(0, b)
};
goog.uri.utils.haveSameDomain = function (a, b) {
	var c = goog.uri.utils.split(a),
		d = goog.uri.utils.split(b);
	return c[goog.uri.utils.ComponentIndex.DOMAIN] == d[goog.uri.utils.ComponentIndex.DOMAIN] && c[goog.uri.utils.ComponentIndex.SCHEME] == d[goog.uri.utils.ComponentIndex.SCHEME] && c[goog.uri.utils.ComponentIndex.PORT] == d[goog.uri.utils.ComponentIndex.PORT]
};
goog.uri.utils.assertNoFragmentsOrQueries_ = function (a) {
	if (goog.DEBUG && (0 <= a.indexOf("#") || 0 <= a.indexOf("?"))) throw Error("goog.uri.utils: Fragment or query identifiers are not supported: [" + a + "]");
};
goog.uri.utils.appendQueryData_ = function (a) {
	if (a[1]) {
		var b = a[0],
			c = b.indexOf("#");
		0 <= c && (a.push(b.substr(c)), a[0] = b = b.substr(0, c));
		c = b.indexOf("?");
		0 > c ? a[1] = "?" : c == b.length - 1 && (a[1] = void 0)
	}
	return a.join("")
};
goog.uri.utils.appendKeyValuePairs_ = function (a, b, c) {
	if (goog.isArray(b))
		for (var d = 0; d < b.length; d++) c.push("&", a), "" !== b[d] && c.push("=", goog.string.urlEncode(b[d]));
	else null != b && (c.push("&", a), "" !== b && c.push("=", goog.string.urlEncode(b)))
};
goog.uri.utils.buildQueryDataBuffer_ = function (a, b, c) {
	goog.asserts.assert(0 == Math.max(b.length - (c || 0), 0) % 2, "goog.uri.utils: Key/value lists must be even in length.");
	for (c = c || 0; c < b.length; c += 2) goog.uri.utils.appendKeyValuePairs_(b[c], b[c + 1], a);
	return a
};
goog.uri.utils.buildQueryData = function (a, b) {
	var c = goog.uri.utils.buildQueryDataBuffer_([], a, b);
	c[0] = "";
	return c.join("")
};
goog.uri.utils.buildQueryDataBufferFromMap_ = function (a, b) {
	for (var c in b) goog.uri.utils.appendKeyValuePairs_(c, b[c], a);
	return a
};
goog.uri.utils.buildQueryDataFromMap = function (a) {
	a = goog.uri.utils.buildQueryDataBufferFromMap_([], a);
	a[0] = "";
	return a.join("")
};
goog.uri.utils.appendParams = function (a, b) {
	return goog.uri.utils.appendQueryData_(2 == arguments.length ? goog.uri.utils.buildQueryDataBuffer_([a], arguments[1], 0) : goog.uri.utils.buildQueryDataBuffer_([a], arguments, 1))
};
goog.uri.utils.appendParamsFromMap = function (a, b) {
	return goog.uri.utils.appendQueryData_(goog.uri.utils.buildQueryDataBufferFromMap_([a], b))
};
goog.uri.utils.appendParam = function (a, b, c) {
	return goog.uri.utils.appendQueryData_([a, "&", b, "=", goog.string.urlEncode(c)])
};
goog.uri.utils.findParam_ = function (a, b, c, d) {
	for (var e = c.length; 0 <= (b = a.indexOf(c, b)) && b < d;) {
		var f = a.charCodeAt(b - 1);
		if (f == goog.uri.utils.CharCode_.AMPERSAND || f == goog.uri.utils.CharCode_.QUESTION)
			if (f = a.charCodeAt(b + e), !f || f == goog.uri.utils.CharCode_.EQUAL || f == goog.uri.utils.CharCode_.AMPERSAND || f == goog.uri.utils.CharCode_.HASH) return b;
		b += e + 1
	}
	return -1
};
goog.uri.utils.hashOrEndRe_ = /#|$/;
goog.uri.utils.hasParam = function (a, b) {
	return 0 <= goog.uri.utils.findParam_(a, 0, b, a.search(goog.uri.utils.hashOrEndRe_))
};
goog.uri.utils.getParamValue = function (a, b) {
	var c = a.search(goog.uri.utils.hashOrEndRe_),
		d = goog.uri.utils.findParam_(a, 0, b, c);
	if (0 > d) return null;
	var e = a.indexOf("&", d);
	if (0 > e || e > c) e = c;
	d += b.length + 1;
	return goog.string.urlDecode(a.substr(d, e - d))
};
goog.uri.utils.getParamValues = function (a, b) {
	for (var c = a.search(goog.uri.utils.hashOrEndRe_), d = 0, e, f = []; 0 <= (e = goog.uri.utils.findParam_(a, d, b, c));) {
		d = a.indexOf("&", e);
		if (0 > d || d > c) d = c;
		e += b.length + 1;
		f.push(goog.string.urlDecode(a.substr(e, d - e)))
	}
	return f
};
goog.uri.utils.trailingQueryPunctuationRe_ = /[?&]($|#)/;
goog.uri.utils.removeParam = function (a, b) {
	for (var c = a.search(goog.uri.utils.hashOrEndRe_), d = 0, e, f = []; 0 <= (e = goog.uri.utils.findParam_(a, d, b, c));) f.push(a.substring(d, e)), d = Math.min(a.indexOf("&", e) + 1 || c, c);
	f.push(a.substr(d));
	return f.join("").replace(goog.uri.utils.trailingQueryPunctuationRe_, "$1")
};
goog.uri.utils.setParam = function (a, b, c) {
	return goog.uri.utils.appendParam(goog.uri.utils.removeParam(a, b), b, c)
};
goog.uri.utils.appendPath = function (a, b) {
	goog.uri.utils.assertNoFragmentsOrQueries_(a);
	goog.string.endsWith(a, "/") && (a = a.substr(0, a.length - 1));
	goog.string.startsWith(b, "/") && (b = b.substr(1));
	return goog.string.buildString(a, "/", b)
};
goog.uri.utils.StandardQueryParam = {
	RANDOM: "zx"
};
goog.uri.utils.makeUnique = function (a) {
	return goog.uri.utils.setParam(a, goog.uri.utils.StandardQueryParam.RANDOM, goog.string.getRandomString())
};
goog.editor.Link = function (a, b) {
	this.anchor_ = a;
	this.isNew_ = b
};
goog.editor.Link.prototype.getAnchor = function () {
	return this.anchor_
};
goog.editor.Link.prototype.getCurrentText = function () {
	this.currentText_ || (this.currentText_ = goog.dom.getRawTextContent(this.getAnchor()));
	return this.currentText_
};
goog.editor.Link.prototype.isNew = function () {
	return this.isNew_
};
goog.editor.Link.prototype.initializeUrl = function (a) {
	this.getAnchor().href = a
};
goog.editor.Link.prototype.removeLink = function () {
	goog.dom.flattenElement(this.anchor_);
	this.anchor_ = null
};
goog.editor.Link.prototype.setTextAndUrl = function (a, b) {
	var c = this.getAnchor();
	c.href = b;
	var d = this.getCurrentText();
	if (a != d) {
		var e = goog.editor.node.getLeftMostLeaf(c);
		e.nodeType == goog.dom.NodeType.TEXT && (e = e.parentNode);
		goog.dom.getRawTextContent(e) != d && (e = c);
		goog.dom.removeChildren(e);
		c = goog.dom.getDomHelper(e);
		goog.dom.appendChild(e, c.createTextNode(a));
		this.currentText_ = null
	}
	this.isNew_ = !1
};
goog.editor.Link.prototype.placeCursorRightOf = function () {
	var a = this.getAnchor();
	if (goog.editor.BrowserFeature.GETS_STUCK_IN_LINKS) {
		var b;
		b = a.nextSibling;
		if (!b || !(b.nodeType == goog.dom.NodeType.TEXT && (goog.string.startsWith(b.data, goog.string.Unicode.NBSP) || goog.string.startsWith(b.data, " ")))) b = goog.dom.getDomHelper(a).createTextNode(goog.string.Unicode.NBSP), goog.dom.insertSiblingAfter(b, a);
		goog.dom.Range.createCaret(b, 1).select()
	} else goog.editor.range.placeCursorNextTo(a, !1)
};
goog.editor.Link.createNewLink = function (a, b, c) {
	var d = new goog.editor.Link(a, !0);
	d.initializeUrl(b);
	c && (a.target = c);
	return d
};
goog.editor.Link.isLikelyUrl = function (a) {
	if (/\s/.test(a) || goog.editor.Link.isLikelyEmailAddress(a)) return !1;
	var b = !1;
	/^[^:\/?#.]+:/.test(a) || (a = "http://" + a, b = !0);
	a = goog.uri.utils.split(a);
	if (-1 != goog.array.indexOf(["mailto", "aim"], a[goog.uri.utils.ComponentIndex.SCHEME])) return !0;
	var c = a[goog.uri.utils.ComponentIndex.DOMAIN];
	if (!c || b && -1 == c.indexOf(".")) return !1;
	b = a[goog.uri.utils.ComponentIndex.PATH];
	return !b || 0 == b.indexOf("/")
};
goog.editor.Link.LIKELY_EMAIL_ADDRESS_ = /^[\w-]+(\.[\w-]+)*\@([\w-]+\.)+(\d+|\w\w+)$/i;
goog.editor.Link.isLikelyEmailAddress = function (a) {
	return goog.editor.Link.LIKELY_EMAIL_ADDRESS_.test(a)
};
goog.editor.Link.isMailto = function (a) {
	return !!a && goog.string.startsWith(a, "mailto:")
};
goog.reflect = {};
goog.reflect.object = function (a, b) {
	return b
};
goog.reflect.sinkValue = new Function("a", "return a");
goog.functions = {};
goog.functions.constant = function (a) {
	return function () {
		return a
	}
};
goog.functions.FALSE = goog.functions.constant(!1);
goog.functions.TRUE = goog.functions.constant(!0);
goog.functions.NULL = goog.functions.constant(null);
goog.functions.identity = function (a) {
	return a
};
goog.functions.error = function (a) {
	return function () {
		throw Error(a);
	}
};
goog.functions.lock = function (a) {
	return function () {
		return a.call(this)
	}
};
goog.functions.compose = function (a) {
	var b = arguments,
		c = b.length;
	return function () {
		var a;
		c && (a = b[c - 1].apply(this, arguments));
		for (var e = c - 2; 0 <= e; e--) a = b[e].call(this, a);
		return a
	}
};
goog.functions.sequence = function (a) {
	var b = arguments,
		c = b.length;
	return function () {
		for (var a, e = 0; e < c; e++) a = b[e].apply(this, arguments);
		return a
	}
};
goog.functions.and = function (a) {
	var b = arguments,
		c = b.length;
	return function () {
		for (var a = 0; a < c; a++)
			if (!b[a].apply(this, arguments)) return !1;
		return !0
	}
};
goog.functions.or = function (a) {
	var b = arguments,
		c = b.length;
	return function () {
		for (var a = 0; a < c; a++)
			if (b[a].apply(this, arguments)) return !0;
		return !1
	}
};
goog.functions.create = function (a, b) {
	var c = function () {};
	c.prototype = a.prototype;
	c = new c;
	a.apply(c, Array.prototype.slice.call(arguments, 1));
	return c
};
goog.editor.Command = {
	UNDO: "+undo",
	REDO: "+redo",
	LINK: "+link",
	FORMAT_BLOCK: "+formatBlock",
	INDENT: "+indent",
	OUTDENT: "+outdent",
	REMOVE_FORMAT: "+removeFormat",
	STRIKE_THROUGH: "+strikeThrough",
	HORIZONTAL_RULE: "+insertHorizontalRule",
	SUBSCRIPT: "+subscript",
	SUPERSCRIPT: "+superscript",
	UNDERLINE: "+underline",
	BOLD: "+bold",
	ITALIC: "+italic",
	FONT_SIZE: "+fontSize",
	FONT_FACE: "+fontName",
	FONT_COLOR: "+foreColor",
	EMOTICON: "+emoticon",
	BACKGROUND_COLOR: "+backColor",
	ORDERED_LIST: "+insertOrderedList",
	UNORDERED_LIST: "+insertUnorderedList",
	TABLE: "+table",
	JUSTIFY_CENTER: "+justifyCenter",
	JUSTIFY_FULL: "+justifyFull",
	JUSTIFY_RIGHT: "+justifyRight",
	JUSTIFY_LEFT: "+justifyLeft",
	BLOCKQUOTE: "+BLOCKQUOTE",
	DIR_LTR: "ltr",
	DIR_RTL: "rtl",
	IMAGE: "image",
	EDIT_HTML: "editHtml",
	DEFAULT_TAG: "+defaultTag",
	CLEAR_LOREM: "clearlorem",
	UPDATE_LOREM: "updatelorem",
	USING_LOREM: "usinglorem",
	MODAL_LINK_EDITOR: "link"
};
goog.debug.errorHandlerWeakDep = {
	protectEntryPoint: function (a) {
		return a
	}
};
goog.debug.entryPointRegistry = {};
goog.debug.EntryPointMonitor = function () {};
goog.debug.entryPointRegistry.refList_ = [];
goog.debug.entryPointRegistry.register = function (a) {
	goog.debug.entryPointRegistry.refList_[goog.debug.entryPointRegistry.refList_.length] = a
};
goog.debug.entryPointRegistry.monitorAll = function (a) {
	for (var a = goog.bind(a.wrap, a), b = 0; b < goog.debug.entryPointRegistry.refList_.length; b++) goog.debug.entryPointRegistry.refList_[b](a)
};
goog.debug.entryPointRegistry.unmonitorAllIfPossible = function (a) {
	for (var a = goog.bind(a.unwrap, a), b = 0; b < goog.debug.entryPointRegistry.refList_.length; b++) goog.debug.entryPointRegistry.refList_[b](a)
};
goog.events.EventWrapper = function () {};
goog.events.EventWrapper.prototype.listen = function () {};
goog.events.EventWrapper.prototype.unlisten = function () {};
goog.events.BrowserFeature = {
	HAS_W3C_BUTTON: !goog.userAgent.IE || goog.userAgent.isVersion("9"),
	SET_KEY_CODE_TO_PREVENT_DEFAULT: goog.userAgent.IE && !goog.userAgent.isVersion("8")
};
goog.events.Event = function (a, b) {
	goog.Disposable.call(this);
	this.type = a;
	this.currentTarget = this.target = b
};
goog.inherits(goog.events.Event, goog.Disposable);
goog.events.Event.prototype.disposeInternal = function () {
	delete this.type;
	delete this.target;
	delete this.currentTarget
};
goog.events.Event.prototype.propagationStopped_ = !1;
goog.events.Event.prototype.returnValue_ = !0;
goog.events.Event.prototype.stopPropagation = function () {
	this.propagationStopped_ = !0
};
goog.events.Event.prototype.preventDefault = function () {
	this.returnValue_ = !1
};
goog.events.Event.stopPropagation = function (a) {
	a.stopPropagation()
};
goog.events.Event.preventDefault = function (a) {
	a.preventDefault()
};
goog.events.BrowserEvent = function (a, b) {
	a && this.init(a, b)
};
goog.inherits(goog.events.BrowserEvent, goog.events.Event);
goog.events.BrowserEvent.MouseButton = {
	LEFT: 0,
	MIDDLE: 1,
	RIGHT: 2
};
goog.events.BrowserEvent.IEButtonMap = [1, 4, 2];
goog.events.BrowserEvent.prototype.target = null;
goog.events.BrowserEvent.prototype.relatedTarget = null;
goog.events.BrowserEvent.prototype.offsetX = 0;
goog.events.BrowserEvent.prototype.offsetY = 0;
goog.events.BrowserEvent.prototype.clientX = 0;
goog.events.BrowserEvent.prototype.clientY = 0;
goog.events.BrowserEvent.prototype.screenX = 0;
goog.events.BrowserEvent.prototype.screenY = 0;
goog.events.BrowserEvent.prototype.button = 0;
goog.events.BrowserEvent.prototype.keyCode = 0;
goog.events.BrowserEvent.prototype.charCode = 0;
goog.events.BrowserEvent.prototype.ctrlKey = !1;
goog.events.BrowserEvent.prototype.altKey = !1;
goog.events.BrowserEvent.prototype.shiftKey = !1;
goog.events.BrowserEvent.prototype.metaKey = !1;
goog.events.BrowserEvent.prototype.platformModifierKey = !1;
goog.events.BrowserEvent.prototype.event_ = null;
goog.events.BrowserEvent.prototype.init = function (a, b) {
	var c = this.type = a.type;
	this.target = a.target || a.srcElement;
	this.currentTarget = b;
	var d = a.relatedTarget;
	if (d) {
		if (goog.userAgent.GECKO) try {
			goog.reflect.sinkValue(d.nodeName)
		} catch (e) {
			d = null
		}
	} else c == goog.events.EventType.MOUSEOVER ? d = a.fromElement : c == goog.events.EventType.MOUSEOUT && (d = a.toElement);
	this.relatedTarget = d;
	this.offsetX = void 0 !== a.offsetX ? a.offsetX : a.layerX;
	this.offsetY = void 0 !== a.offsetY ? a.offsetY : a.layerY;
	this.clientX = void 0 !== a.clientX ?
		a.clientX : a.pageX;
	this.clientY = void 0 !== a.clientY ? a.clientY : a.pageY;
	this.screenX = a.screenX || 0;
	this.screenY = a.screenY || 0;
	this.button = a.button;
	this.keyCode = a.keyCode || 0;
	this.charCode = a.charCode || ("keypress" == c ? a.keyCode : 0);
	this.ctrlKey = a.ctrlKey;
	this.altKey = a.altKey;
	this.shiftKey = a.shiftKey;
	this.metaKey = a.metaKey;
	this.platformModifierKey = goog.userAgent.MAC ? a.metaKey : a.ctrlKey;
	this.state = a.state;
	this.event_ = a;
	delete this.returnValue_;
	delete this.propagationStopped_
};
goog.events.BrowserEvent.prototype.isButton = function (a) {
	return goog.events.BrowserFeature.HAS_W3C_BUTTON ? this.event_.button == a : "click" == this.type ? a == goog.events.BrowserEvent.MouseButton.LEFT : !! (this.event_.button & goog.events.BrowserEvent.IEButtonMap[a])
};
goog.events.BrowserEvent.prototype.stopPropagation = function () {
	goog.events.BrowserEvent.superClass_.stopPropagation.call(this);
	this.event_.stopPropagation ? this.event_.stopPropagation() : this.event_.cancelBubble = !0
};
goog.events.BrowserEvent.prototype.preventDefault = function () {
	goog.events.BrowserEvent.superClass_.preventDefault.call(this);
	var a = this.event_;
	if (a.preventDefault) a.preventDefault();
	else if (a.returnValue = !1, goog.events.BrowserFeature.SET_KEY_CODE_TO_PREVENT_DEFAULT) try {
		if (a.ctrlKey || 112 <= a.keyCode && 123 >= a.keyCode) a.keyCode = -1
	} catch (b) {}
};
goog.events.BrowserEvent.prototype.getBrowserEvent = function () {
	return this.event_
};
goog.events.BrowserEvent.prototype.disposeInternal = function () {
	goog.events.BrowserEvent.superClass_.disposeInternal.call(this);
	this.relatedTarget = this.currentTarget = this.target = this.event_ = null
};
goog.events.Listener = function () {};
goog.events.Listener.counter_ = 0;
goog.events.Listener.prototype.key = 0;
goog.events.Listener.prototype.removed = !1;
goog.events.Listener.prototype.callOnce = !1;
goog.events.Listener.prototype.init = function (a, b, c, d, e, f) {
	if (goog.isFunction(a)) this.isFunctionListener_ = !0;
	else if (a && a.handleEvent && goog.isFunction(a.handleEvent)) this.isFunctionListener_ = !1;
	else throw Error("Invalid listener argument");
	this.listener = a;
	this.proxy = b;
	this.src = c;
	this.type = d;
	this.capture = !! e;
	this.handler = f;
	this.callOnce = !1;
	this.key = ++goog.events.Listener.counter_;
	this.removed = !1
};
goog.events.Listener.prototype.handleEvent = function (a) {
	return this.isFunctionListener_ ? this.listener.call(this.handler || this.src, a) : this.listener.handleEvent.call(this.listener, a)
};
goog.structs.SimplePool = function (a, b) {
	goog.Disposable.call(this);
	this.maxCount_ = b;
	this.freeQueue_ = [];
	this.createInitial_(a)
};
goog.inherits(goog.structs.SimplePool, goog.Disposable);
goog.structs.SimplePool.prototype.createObjectFn_ = null;
goog.structs.SimplePool.prototype.disposeObjectFn_ = null;
goog.structs.SimplePool.prototype.setCreateObjectFn = function (a) {
	this.createObjectFn_ = a
};
goog.structs.SimplePool.prototype.setDisposeObjectFn = function (a) {
	this.disposeObjectFn_ = a
};
goog.structs.SimplePool.prototype.getObject = function () {
	return this.freeQueue_.length ? this.freeQueue_.pop() : this.createObject()
};
goog.structs.SimplePool.prototype.releaseObject = function (a) {
	this.freeQueue_.length < this.maxCount_ ? this.freeQueue_.push(a) : this.disposeObject(a)
};
goog.structs.SimplePool.prototype.createInitial_ = function (a) {
	if (a > this.maxCount_) throw Error("[goog.structs.SimplePool] Initial cannot be greater than max");
	for (var b = 0; b < a; b++) this.freeQueue_.push(this.createObject())
};
goog.structs.SimplePool.prototype.createObject = function () {
	return this.createObjectFn_ ? this.createObjectFn_() : {}
};
goog.structs.SimplePool.prototype.disposeObject = function (a) {
	if (this.disposeObjectFn_) this.disposeObjectFn_(a);
	else if (goog.isObject(a))
		if (goog.isFunction(a.dispose)) a.dispose();
		else
			for (var b in a) delete a[b]
};
goog.structs.SimplePool.prototype.disposeInternal = function () {
	goog.structs.SimplePool.superClass_.disposeInternal.call(this);
	for (var a = this.freeQueue_; a.length;) this.disposeObject(a.pop());
	delete this.freeQueue_
};
goog.events.pools = {};
(function () {
	function a() {
		return {
			count_: 0,
			remaining_: 0
		}
	}

	function b() {
		return []
	}

	function c() {
		var a = function (b) {
			return g.call(a.src, a.key, b)
		};
		return a
	}

	function d() {
		return new goog.events.Listener
	}

	function e() {
		return new goog.events.BrowserEvent
	}
	var f = goog.userAgent.jscript.HAS_JSCRIPT && !goog.userAgent.jscript.isVersion("5.7"),
		g;
	goog.events.pools.setProxyCallbackFunction = function (a) {
		g = a
	};
	if (f) {
		goog.events.pools.getObject = function () {
			return h.getObject()
		};
		goog.events.pools.releaseObject = function (a) {
			h.releaseObject(a)
		};
		goog.events.pools.getArray = function () {
			return j.getObject()
		};
		goog.events.pools.releaseArray = function (a) {
			j.releaseObject(a)
		};
		goog.events.pools.getProxy = function () {
			return k.getObject()
		};
		goog.events.pools.releaseProxy = function () {
			k.releaseObject(c())
		};
		goog.events.pools.getListener = function () {
			return l.getObject()
		};
		goog.events.pools.releaseListener = function (a) {
			l.releaseObject(a)
		};
		goog.events.pools.getEvent = function () {
			return n.getObject()
		};
		goog.events.pools.releaseEvent = function (a) {
			n.releaseObject(a)
		};
		var h =
			new goog.structs.SimplePool(0, 600);
		h.setCreateObjectFn(a);
		var j = new goog.structs.SimplePool(0, 600);
		j.setCreateObjectFn(b);
		var k = new goog.structs.SimplePool(0, 600);
		k.setCreateObjectFn(c);
		var l = new goog.structs.SimplePool(0, 600);
		l.setCreateObjectFn(d);
		var n = new goog.structs.SimplePool(0, 600);
		n.setCreateObjectFn(e)
	} else goog.events.pools.getObject = a, goog.events.pools.releaseObject = goog.nullFunction, goog.events.pools.getArray = b, goog.events.pools.releaseArray = goog.nullFunction, goog.events.pools.getProxy =
		c, goog.events.pools.releaseProxy = goog.nullFunction, goog.events.pools.getListener = d, goog.events.pools.releaseListener = goog.nullFunction, goog.events.pools.getEvent = e, goog.events.pools.releaseEvent = goog.nullFunction
})();
goog.events.listeners_ = {};
goog.events.listenerTree_ = {};
goog.events.sources_ = {};
goog.events.onString_ = "on";
goog.events.onStringMap_ = {};
goog.events.keySeparator_ = "_";
goog.events.listen = function (a, b, c, d, e) {
	if (b) {
		if (goog.isArray(b)) {
			for (var f = 0; f < b.length; f++) goog.events.listen(a, b[f], c, d, e);
			return null
		}
		var d = !! d,
			g = goog.events.listenerTree_;
		b in g || (g[b] = goog.events.pools.getObject());
		g = g[b];
		d in g || (g[d] = goog.events.pools.getObject(), g.count_++);
		var g = g[d],
			h = goog.getUid(a),
			j;
		g.remaining_++;
		if (g[h]) {
			j = g[h];
			for (f = 0; f < j.length; f++)
				if (g = j[f], g.listener == c && g.handler == e) {
					if (g.removed) break;
					return j[f].key
				}
		} else j = g[h] = goog.events.pools.getArray(), g.count_++;
		f = goog.events.pools.getProxy();
		f.src = a;
		g = goog.events.pools.getListener();
		g.init(c, f, a, b, d, e);
		c = g.key;
		f.key = c;
		j.push(g);
		goog.events.listeners_[c] = g;
		goog.events.sources_[h] || (goog.events.sources_[h] = goog.events.pools.getArray());
		goog.events.sources_[h].push(g);
		a.addEventListener ? (a == goog.global || !a.customEvent_) && a.addEventListener(b, f, d) : a.attachEvent(goog.events.getOnString_(b), f);
		return c
	}
	throw Error("Invalid event type");
};
goog.events.listenOnce = function (a, b, c, d, e) {
	if (goog.isArray(b)) {
		for (var f = 0; f < b.length; f++) goog.events.listenOnce(a, b[f], c, d, e);
		return null
	}
	a = goog.events.listen(a, b, c, d, e);
	goog.events.listeners_[a].callOnce = !0;
	return a
};
goog.events.listenWithWrapper = function (a, b, c, d, e) {
	b.listen(a, c, d, e)
};
goog.events.unlisten = function (a, b, c, d, e) {
	if (goog.isArray(b)) {
		for (var f = 0; f < b.length; f++) goog.events.unlisten(a, b[f], c, d, e);
		return null
	}
	d = !! d;
	a = goog.events.getListeners_(a, b, d);
	if (!a) return !1;
	for (f = 0; f < a.length; f++)
		if (a[f].listener == c && a[f].capture == d && a[f].handler == e) return goog.events.unlistenByKey(a[f].key);
	return !1
};
goog.events.unlistenByKey = function (a) {
	if (!goog.events.listeners_[a]) return !1;
	var b = goog.events.listeners_[a];
	if (b.removed) return !1;
	var c = b.src,
		d = b.type,
		e = b.proxy,
		f = b.capture;
	c.removeEventListener ? (c == goog.global || !c.customEvent_) && c.removeEventListener(d, e, f) : c.detachEvent && c.detachEvent(goog.events.getOnString_(d), e);
	c = goog.getUid(c);
	e = goog.events.listenerTree_[d][f][c];
	if (goog.events.sources_[c]) {
		var g = goog.events.sources_[c];
		goog.array.remove(g, b);
		0 == g.length && delete goog.events.sources_[c]
	}
	b.removed = !0;
	e.needsCleanup_ = !0;
	goog.events.cleanUp_(d, f, c, e);
	delete goog.events.listeners_[a];
	return !0
};
goog.events.unlistenWithWrapper = function (a, b, c, d, e) {
	b.unlisten(a, c, d, e)
};
goog.events.cleanUp_ = function (a, b, c, d) {
	if (!d.locked_ && d.needsCleanup_) {
		for (var e = 0, f = 0; e < d.length; e++)
			if (d[e].removed) {
				var g = d[e].proxy;
				g.src = null;
				goog.events.pools.releaseProxy(g);
				goog.events.pools.releaseListener(d[e])
			} else e != f && (d[f] = d[e]), f++;
		d.length = f;
		d.needsCleanup_ = !1;
		if (0 == f && (goog.events.pools.releaseArray(d), delete goog.events.listenerTree_[a][b][c], goog.events.listenerTree_[a][b].count_--, 0 == goog.events.listenerTree_[a][b].count_ && (goog.events.pools.releaseObject(goog.events.listenerTree_[a][b]),
			delete goog.events.listenerTree_[a][b], goog.events.listenerTree_[a].count_--), 0 == goog.events.listenerTree_[a].count_)) goog.events.pools.releaseObject(goog.events.listenerTree_[a]), delete goog.events.listenerTree_[a]
	}
};
goog.events.removeAll = function (a, b, c) {
	var d = 0,
		e = null == b,
		f = null == c,
		c = !! c;
	if (null == a) goog.object.forEach(goog.events.sources_, function (a) {
		for (var g = a.length - 1; 0 <= g; g--) {
			var h = a[g];
			if ((e || b == h.type) && (f || c == h.capture)) goog.events.unlistenByKey(h.key), d++
		}
	});
	else if (a = goog.getUid(a), goog.events.sources_[a])
		for (var a = goog.events.sources_[a], g = a.length - 1; 0 <= g; g--) {
			var h = a[g];
			if ((e || b == h.type) && (f || c == h.capture)) goog.events.unlistenByKey(h.key), d++
		}
	return d
};
goog.events.getListeners = function (a, b, c) {
	return goog.events.getListeners_(a, b, c) || []
};
goog.events.getListeners_ = function (a, b, c) {
	var d = goog.events.listenerTree_;
	return b in d && (d = d[b], c in d && (d = d[c], a = goog.getUid(a), d[a])) ? d[a] : null
};
goog.events.getListener = function (a, b, c, d, e) {
	d = !! d;
	if (a = goog.events.getListeners_(a, b, d))
		for (b = 0; b < a.length; b++)
			if (a[b].listener == c && a[b].capture == d && a[b].handler == e) return a[b];
	return null
};
goog.events.hasListener = function (a, b, c) {
	var a = goog.getUid(a),
		d = goog.events.sources_[a];
	if (d) {
		var e = goog.isDef(b),
			f = goog.isDef(c);
		return e && f ? (d = goog.events.listenerTree_[b], !! d && !! d[c] && a in d[c]) : !e && !f ? !0 : goog.array.some(d, function (a) {
			return e && a.type == b || f && a.capture == c
		})
	}
	return !1
};
goog.events.expose = function (a) {
	var b = [],
		c;
	for (c in a) a[c] && a[c].id ? b.push(c + " = " + a[c] + " (" + a[c].id + ")") : b.push(c + " = " + a[c]);
	return b.join("\n")
};
goog.events.getOnString_ = function (a) {
	return a in goog.events.onStringMap_ ? goog.events.onStringMap_[a] : goog.events.onStringMap_[a] = goog.events.onString_ + a
};
goog.events.fireListeners = function (a, b, c, d) {
	var e = goog.events.listenerTree_;
	return b in e && (e = e[b], c in e) ? goog.events.fireListeners_(e[c], a, b, c, d) : !0
};
goog.events.fireListeners_ = function (a, b, c, d, e) {
	var f = 1,
		b = goog.getUid(b);
	if (a[b]) {
		a.remaining_--;
		a = a[b];
		a.locked_ ? a.locked_++ : a.locked_ = 1;
		try {
			for (var g = a.length, h = 0; h < g; h++) {
				var j = a[h];
				j && !j.removed && (f &= !1 !== goog.events.fireListener(j, e))
			}
		} finally {
			a.locked_--, goog.events.cleanUp_(c, d, b, a)
		}
	}
	return Boolean(f)
};
goog.events.fireListener = function (a, b) {
	var c = a.handleEvent(b);
	a.callOnce && goog.events.unlistenByKey(a.key);
	return c
};
goog.events.getTotalListenerCount = function () {
	return goog.object.getCount(goog.events.listeners_)
};
goog.events.dispatchEvent = function (a, b) {
	if (goog.isString(b)) b = new goog.events.Event(b, a);
	else if (b instanceof goog.events.Event) b.target = b.target || a;
	else {
		var c = b,
			b = new goog.events.Event(b.type, a);
		goog.object.extend(b, c)
	}
	var c = 1,
		d, e = b.type,
		f = goog.events.listenerTree_;
	if (!(e in f)) return !0;
	var f = f[e],
		e = !0 in f,
		g;
	if (e) {
		d = [];
		for (g = a; g; g = g.getParentEventTarget()) d.push(g);
		g = f[!0];
		g.remaining_ = g.count_;
		for (var h = d.length - 1; !b.propagationStopped_ && 0 <= h && g.remaining_; h--) b.currentTarget = d[h], c &= goog.events.fireListeners_(g,
			d[h], b.type, !0, b) && !1 != b.returnValue_
	}
	if (!1 in f)
		if (g = f[!1], g.remaining_ = g.count_, e)
			for (h = 0; !b.propagationStopped_ && h < d.length && g.remaining_; h++) b.currentTarget = d[h], c &= goog.events.fireListeners_(g, d[h], b.type, !1, b) && !1 != b.returnValue_;
		else
			for (d = a; !b.propagationStopped_ && d && g.remaining_; d = d.getParentEventTarget()) b.currentTarget = d, c &= goog.events.fireListeners_(g, d, b.type, !1, b) && !1 != b.returnValue_;
	return Boolean(c)
};
goog.events.protectBrowserEventEntryPoint = function (a) {
	goog.events.handleBrowserEvent_ = a.protectEntryPoint(goog.events.handleBrowserEvent_);
	goog.events.pools.setProxyCallbackFunction(goog.events.handleBrowserEvent_)
};
goog.events.handleBrowserEvent_ = function (a, b) {
	if (!goog.events.listeners_[a]) return !0;
	var c = goog.events.listeners_[a],
		d = c.type,
		e = goog.events.listenerTree_;
	if (!(d in e)) return !0;
	var e = e[d],
		f, g;
	if (goog.events.synthesizeEventPropagation_()) {
		f = b || goog.getObjectByName("window.event");
		var h = !0 in e,
			j = !1 in e;
		if (h) {
			if (goog.events.isMarkedIeEvent_(f)) return !0;
			goog.events.markIeEvent_(f)
		}
		var k = goog.events.pools.getEvent();
		k.init(f, this);
		f = !0;
		try {
			if (h) {
				for (var l = goog.events.pools.getArray(), n = k.currentTarget; n; n =
					n.parentNode) l.push(n);
				g = e[!0];
				g.remaining_ = g.count_;
				for (var m = l.length - 1; !k.propagationStopped_ && 0 <= m && g.remaining_; m--) k.currentTarget = l[m], f &= goog.events.fireListeners_(g, l[m], d, !0, k);
				if (j) {
					g = e[!1];
					g.remaining_ = g.count_;
					for (m = 0; !k.propagationStopped_ && m < l.length && g.remaining_; m++) k.currentTarget = l[m], f &= goog.events.fireListeners_(g, l[m], d, !1, k)
				}
			} else f = goog.events.fireListener(c, k)
		} finally {
			l && (l.length = 0, goog.events.pools.releaseArray(l)), k.dispose(), goog.events.pools.releaseEvent(k)
		}
		return f
	}
	d =
		new goog.events.BrowserEvent(b, this);
	try {
		f = goog.events.fireListener(c, d)
	} finally {
		d.dispose()
	}
	return f
};
goog.events.pools.setProxyCallbackFunction(goog.events.handleBrowserEvent_);
goog.events.markIeEvent_ = function (a) {
	var b = !1;
	if (0 == a.keyCode) try {
		a.keyCode = -1;
		return
	} catch (c) {
		b = !0
	}
	if (b || void 0 == a.returnValue) a.returnValue = !0
};
goog.events.isMarkedIeEvent_ = function (a) {
	return 0 > a.keyCode || void 0 != a.returnValue
};
goog.events.uniqueIdCounter_ = 0;
goog.events.getUniqueId = function (a) {
	return a + "_" + goog.events.uniqueIdCounter_++
};
goog.events.synthesizeEventPropagation_ = function () {
	void 0 === goog.events.requiresSyntheticEventPropagation_ && (goog.events.requiresSyntheticEventPropagation_ = goog.userAgent.IE && !goog.global.addEventListener);
	return goog.events.requiresSyntheticEventPropagation_
};
goog.debug.entryPointRegistry.register(function (a) {
	goog.events.handleBrowserEvent_ = a(goog.events.handleBrowserEvent_);
	goog.events.pools.setProxyCallbackFunction(goog.events.handleBrowserEvent_)
});
goog.events.EventTarget = function () {
	goog.Disposable.call(this)
};
goog.inherits(goog.events.EventTarget, goog.Disposable);
goog.events.EventTarget.prototype.customEvent_ = !0;
goog.events.EventTarget.prototype.parentEventTarget_ = null;
goog.events.EventTarget.prototype.getParentEventTarget = function () {
	return this.parentEventTarget_
};
goog.events.EventTarget.prototype.setParentEventTarget = function (a) {
	this.parentEventTarget_ = a
};
goog.events.EventTarget.prototype.addEventListener = function (a, b, c, d) {
	goog.events.listen(this, a, b, c, d)
};
goog.events.EventTarget.prototype.removeEventListener = function (a, b, c, d) {
	goog.events.unlisten(this, a, b, c, d)
};
goog.events.EventTarget.prototype.dispatchEvent = function (a) {
	return goog.events.dispatchEvent(this, a)
};
goog.events.EventTarget.prototype.disposeInternal = function () {
	goog.events.EventTarget.superClass_.disposeInternal.call(this);
	goog.events.removeAll(this);
	this.parentEventTarget_ = null
};
goog.editor.Plugin = function () {
	goog.events.EventTarget.call(this);
	this.enabled_ = this.activeOnUneditableFields()
};
goog.inherits(goog.editor.Plugin, goog.events.EventTarget);
goog.editor.Plugin.prototype.fieldObject = null;
goog.editor.Plugin.prototype.getFieldDomHelper = function () {
	return this.fieldObject && this.fieldObject.getEditableDomHelper()
};
goog.editor.Plugin.prototype.autoDispose_ = !0;
goog.editor.Plugin.prototype.logger = goog.debug.Logger.getLogger("goog.editor.Plugin");
goog.editor.Plugin.prototype.registerFieldObject = function (a) {
	this.fieldObject = a
};
goog.editor.Plugin.prototype.unregisterFieldObject = function () {
	this.fieldObject && (this.disable(this.fieldObject), this.fieldObject = null)
};
goog.editor.Plugin.prototype.enable = function (a) {
	this.fieldObject == a ? this.enabled_ = !0 : this.logger.severe("Trying to enable an unregistered field with this plugin.")
};
goog.editor.Plugin.prototype.disable = function (a) {
	this.fieldObject == a ? this.enabled_ = !1 : this.logger.severe("Trying to disable an unregistered field with this plugin.")
};
goog.editor.Plugin.prototype.isEnabled = function (a) {
	return this.fieldObject == a ? this.enabled_ : !1
};
goog.editor.Plugin.prototype.setAutoDispose = function (a) {
	this.autoDispose_ = a
};
goog.editor.Plugin.prototype.isAutoDispose = function () {
	return this.autoDispose_
};
goog.editor.Plugin.prototype.activeOnUneditableFields = goog.functions.FALSE;
goog.editor.Plugin.prototype.isSilentCommand = goog.functions.FALSE;
goog.editor.Plugin.prototype.disposeInternal = function () {
	this.fieldObject && this.unregisterFieldObject(this.fieldObject);
	goog.editor.Plugin.superClass_.disposeInternal.call(this)
};
goog.editor.Plugin.Op = {
	KEYDOWN: 1,
	KEYPRESS: 2,
	KEYUP: 3,
	SELECTION: 4,
	SHORTCUT: 5,
	EXEC_COMMAND: 6,
	QUERY_COMMAND: 7,
	PREPARE_CONTENTS_HTML: 8,
	CLEAN_CONTENTS_HTML: 10,
	CLEAN_CONTENTS_DOM: 11
};
goog.editor.Plugin.OPCODE = goog.object.transpose(goog.reflect.object(goog.editor.Plugin, {
	handleKeyDown: goog.editor.Plugin.Op.KEYDOWN,
	handleKeyPress: goog.editor.Plugin.Op.KEYPRESS,
	handleKeyUp: goog.editor.Plugin.Op.KEYUP,
	handleSelectionChange: goog.editor.Plugin.Op.SELECTION,
	handleKeyboardShortcut: goog.editor.Plugin.Op.SHORTCUT,
	execCommand: goog.editor.Plugin.Op.EXEC_COMMAND,
	queryCommandValue: goog.editor.Plugin.Op.QUERY_COMMAND,
	prepareContentsHtml: goog.editor.Plugin.Op.PREPARE_CONTENTS_HTML,
	cleanContentsHtml: goog.editor.Plugin.Op.CLEAN_CONTENTS_HTML,
	cleanContentsDom: goog.editor.Plugin.Op.CLEAN_CONTENTS_DOM
}));
goog.editor.Plugin.IRREPRESSIBLE_OPS = goog.object.createSet(goog.editor.Plugin.Op.PREPARE_CONTENTS_HTML, goog.editor.Plugin.Op.CLEAN_CONTENTS_HTML, goog.editor.Plugin.Op.CLEAN_CONTENTS_DOM);
goog.editor.Plugin.prototype.execCommand = function (a, b) {
	var c = this.isSilentCommand(a);
	c || (goog.userAgent.GECKO && this.fieldObject.stopChangeEvents(!0, !0), this.fieldObject.dispatchBeforeChange());
	try {
		var d = this.execCommandInternal.apply(this, arguments)
	} finally {
		c || (this.fieldObject.dispatchChange(), a != goog.editor.Command.LINK && this.fieldObject.dispatchSelectionChangeEvent())
	}
	return d
};
goog.editor.Plugin.prototype.isSupportedCommand = function () {
	return !1
};
goog.ui = {};
goog.ui.editor = {};
goog.ui.editor.messages = {};
goog.ui.editor.messages.MSG_LINK_CAPTION = goog.getMsg("Link");
goog.ui.editor.messages.MSG_EDIT_LINK = goog.getMsg("Edit Link");
goog.ui.editor.messages.MSG_TEXT_TO_DISPLAY = goog.getMsg("Text to display:");
goog.ui.editor.messages.MSG_LINK_TO = goog.getMsg("Link to:");
goog.ui.editor.messages.MSG_ON_THE_WEB = goog.getMsg("Web address");
goog.ui.editor.messages.MSG_ON_THE_WEB_TIP = goog.getMsg("Link to a page or file somewhere else on the web");
goog.ui.editor.messages.MSG_TEST_THIS_LINK = goog.getMsg("Test this link");
goog.ui.editor.messages.MSG_TR_LINK_EXPLANATION = goog.getMsg("{$startBold}Not sure what to put in the box?{$endBold} First, find the page on the web that you want to link to. (A {$searchEngineLink}search engine{$endLink} might be useful.) Then, copy the web address from the box in your browser's address bar, and paste it into the box above.", {
	startBold: "<b>",
	endBold: "</b>",
	searchEngineLink: "<a href='http://www.google.com/' target='_new'>",
	endLink: "</a>"
});
goog.ui.editor.messages.MSG_WHAT_URL = goog.getMsg("To what URL should this link go?");
goog.ui.editor.messages.MSG_EMAIL_ADDRESS = goog.getMsg("Email address");
goog.ui.editor.messages.MSG_EMAIL_ADDRESS_TIP = goog.getMsg("Link to an email address");
goog.ui.editor.messages.MSG_INVALID_EMAIL = goog.getMsg("Invalid email address");
goog.ui.editor.messages.MSG_WHAT_EMAIL = goog.getMsg("To what email address should this link?");
goog.ui.editor.messages.MSG_EMAIL_EXPLANATION = goog.getMsg("{$preb}Be careful.{$postb} Remember that any time you include an email address on a web page, nasty spammers can find it too.", {
	preb: "<b>",
	postb: "</b>"
});
goog.ui.editor.messages.MSG_IMAGE_CAPTION = goog.getMsg("Image");
goog.editor.plugins = {};
goog.editor.plugins.BasicTextFormatter = function () {
	goog.editor.Plugin.call(this)
};
goog.inherits(goog.editor.plugins.BasicTextFormatter, goog.editor.Plugin);
goog.editor.plugins.BasicTextFormatter.prototype.getTrogClassId = function () {
	return "BTF"
};
goog.editor.plugins.BasicTextFormatter.prototype.logger = goog.debug.Logger.getLogger("goog.editor.plugins.BasicTextFormatter");
goog.editor.plugins.BasicTextFormatter.COMMAND = {
	LINK: "+link",
	FORMAT_BLOCK: "+formatBlock",
	INDENT: "+indent",
	OUTDENT: "+outdent",
	STRIKE_THROUGH: "+strikeThrough",
	HORIZONTAL_RULE: "+insertHorizontalRule",
	SUBSCRIPT: "+subscript",
	SUPERSCRIPT: "+superscript",
	UNDERLINE: "+underline",
	BOLD: "+bold",
	ITALIC: "+italic",
	FONT_SIZE: "+fontSize",
	FONT_FACE: "+fontName",
	FONT_COLOR: "+foreColor",
	BACKGROUND_COLOR: "+backColor",
	ORDERED_LIST: "+insertOrderedList",
	UNORDERED_LIST: "+insertUnorderedList",
	JUSTIFY_CENTER: "+justifyCenter",
	JUSTIFY_FULL: "+justifyFull",
	JUSTIFY_RIGHT: "+justifyRight",
	JUSTIFY_LEFT: "+justifyLeft"
};
goog.editor.plugins.BasicTextFormatter.SUPPORTED_COMMANDS_ = goog.object.transpose(goog.editor.plugins.BasicTextFormatter.COMMAND);
goog.editor.plugins.BasicTextFormatter.prototype.isSupportedCommand = function (a) {
	return a in goog.editor.plugins.BasicTextFormatter.SUPPORTED_COMMANDS_
};
goog.editor.plugins.BasicTextFormatter.prototype.getRange_ = function () {
	return this.fieldObject.getRange()
};
goog.editor.plugins.BasicTextFormatter.prototype.getDocument_ = function () {
	return this.getFieldDomHelper().getDocument()
};
goog.editor.plugins.BasicTextFormatter.prototype.execCommandInternal = function (a, b) {
	var c, d, e, f, g, h = b;
	switch (a) {
	case goog.editor.plugins.BasicTextFormatter.COMMAND.BACKGROUND_COLOR:
		goog.isNull(h) || (goog.editor.BrowserFeature.EATS_EMPTY_BACKGROUND_COLOR ? this.applyBgColorManually_(h) : goog.userAgent.OPERA ? this.execCommandHelper_("hiliteColor", h) : this.execCommandHelper_(a, h));
		break;
	case goog.editor.plugins.BasicTextFormatter.COMMAND.LINK:
		g = this.toggleLink_(h);
		break;
	case goog.editor.plugins.BasicTextFormatter.COMMAND.JUSTIFY_CENTER:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.JUSTIFY_FULL:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.JUSTIFY_RIGHT:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.JUSTIFY_LEFT:
		this.justify_(a);
		break;
	default:
		goog.userAgent.IE && (a == goog.editor.plugins.BasicTextFormatter.COMMAND.FORMAT_BLOCK && h) && (h = "<" + h + ">");
		if (a == goog.editor.plugins.BasicTextFormatter.COMMAND.FONT_COLOR && goog.isNull(h)) break;
		switch (a) {
		case goog.editor.plugins.BasicTextFormatter.COMMAND.INDENT:
		case goog.editor.plugins.BasicTextFormatter.COMMAND.OUTDENT:
			goog.editor.BrowserFeature.HAS_STYLE_WITH_CSS && (goog.userAgent.GECKO && (d = !0), goog.userAgent.OPERA && (d = a == goog.editor.plugins.BasicTextFormatter.COMMAND.OUTDENT ? !this.getDocument_().queryCommandEnabled("outdent") : !0));
		case goog.editor.plugins.BasicTextFormatter.COMMAND.ORDERED_LIST:
		case goog.editor.plugins.BasicTextFormatter.COMMAND.UNORDERED_LIST:
			goog.editor.BrowserFeature.LEAVES_P_WHEN_REMOVING_LISTS && this.queryCommandStateInternal_(this.getDocument_(), a) ? e = this.fieldObject.queryCommandValue(goog.editor.Command.DEFAULT_TAG) != goog.dom.TagName.P : goog.editor.BrowserFeature.CAN_LISTIFY_BR || this.convertBreaksToDivs_(), goog.userAgent.GECKO && (goog.editor.BrowserFeature.FORGETS_FORMATTING_WHEN_LISTIFYING && !this.queryCommandValue(a)) &&
				(f |= this.beforeInsertListGecko_());
		case goog.editor.plugins.BasicTextFormatter.COMMAND.FORMAT_BLOCK:
			c = !! this.fieldObject.getPluginByClassId("Bidi");
			break;
		case goog.editor.plugins.BasicTextFormatter.COMMAND.SUBSCRIPT:
		case goog.editor.plugins.BasicTextFormatter.COMMAND.SUPERSCRIPT:
			goog.editor.BrowserFeature.NESTS_SUBSCRIPT_SUPERSCRIPT && this.applySubscriptSuperscriptWorkarounds_(a);
			break;
		case goog.editor.plugins.BasicTextFormatter.COMMAND.UNDERLINE:
		case goog.editor.plugins.BasicTextFormatter.COMMAND.BOLD:
		case goog.editor.plugins.BasicTextFormatter.COMMAND.ITALIC:
			d =
				goog.userAgent.GECKO && goog.editor.BrowserFeature.HAS_STYLE_WITH_CSS && this.queryCommandValue(a);
			break;
		case goog.editor.plugins.BasicTextFormatter.COMMAND.FONT_COLOR:
		case goog.editor.plugins.BasicTextFormatter.COMMAND.FONT_FACE:
			d = goog.editor.BrowserFeature.HAS_STYLE_WITH_CSS && goog.userAgent.GECKO
		}
		this.execCommandHelper_(a, h, c, d);
		f && this.getDocument_().execCommand("Delete", !1, !0);
		e && this.getDocument_().execCommand("FormatBlock", !1, "<div>")
	}
	goog.userAgent.GECKO && !this.fieldObject.inModalMode() && this.focusField_();
	return g
};
goog.editor.plugins.BasicTextFormatter.prototype.focusField_ = function () {
	this.getFieldDomHelper().getWindow().focus()
};
goog.editor.plugins.BasicTextFormatter.prototype.queryCommandValue = function (a) {
	var b;
	switch (a) {
	case goog.editor.plugins.BasicTextFormatter.COMMAND.LINK:
		return this.isNodeInState_(goog.dom.TagName.A);
	case goog.editor.plugins.BasicTextFormatter.COMMAND.JUSTIFY_CENTER:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.JUSTIFY_FULL:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.JUSTIFY_RIGHT:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.JUSTIFY_LEFT:
		return this.isJustification_(a);
	case goog.editor.plugins.BasicTextFormatter.COMMAND.FORMAT_BLOCK:
		return goog.editor.plugins.BasicTextFormatter.getSelectionBlockState_(this.fieldObject.getRange());
	case goog.editor.plugins.BasicTextFormatter.COMMAND.INDENT:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.OUTDENT:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.HORIZONTAL_RULE:
		return !1;
	case goog.editor.plugins.BasicTextFormatter.COMMAND.FONT_SIZE:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.FONT_FACE:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.FONT_COLOR:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.BACKGROUND_COLOR:
		return this.queryCommandValueInternal_(this.getDocument_(),
			a, goog.editor.BrowserFeature.HAS_STYLE_WITH_CSS && goog.userAgent.GECKO);
	case goog.editor.plugins.BasicTextFormatter.COMMAND.UNDERLINE:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.BOLD:
	case goog.editor.plugins.BasicTextFormatter.COMMAND.ITALIC:
		b = goog.editor.BrowserFeature.HAS_STYLE_WITH_CSS && goog.userAgent.GECKO;
	default:
		return this.queryCommandStateInternal_(this.getDocument_(), a, b)
	}
};
goog.editor.plugins.BasicTextFormatter.prototype.prepareContentsHtml = function (a) {
	goog.editor.BrowserFeature.COLLAPSES_EMPTY_NODES && a.match(/^\s*<script/i) && (a = "&nbsp;" + a);
	goog.editor.BrowserFeature.CONVERT_TO_B_AND_I_TAGS && (a = a.replace(/<(\/?)strong([^\w])/gi, "<$1b$2"), a = a.replace(/<(\/?)em([^\w])/gi, "<$1i$2"));
	return a
};
goog.editor.plugins.BasicTextFormatter.prototype.cleanContentsDom = function (a) {
	for (var a = a.getElementsByTagName(goog.dom.TagName.IMG), b = 0, c; c = a[b]; b++) goog.editor.BrowserFeature.SHOWS_CUSTOM_ATTRS_IN_INNER_HTML && (c.removeAttribute("tabIndex"), c.removeAttribute("tabIndexSet"), goog.removeUid(c), c.oldTabIndex && (c.tabIndex = c.oldTabIndex))
};
goog.editor.plugins.BasicTextFormatter.prototype.cleanContentsHtml = function (a) {
	if (goog.editor.BrowserFeature.MOVES_STYLE_TO_HEAD) {
		for (var b = this.fieldObject.getEditableDomHelper().getElementsByTagNameAndClass(goog.dom.TagName.HEAD), c = [], d = b.length, e = 1; e < d; ++e)
			for (var f = b[e].getElementsByTagName(goog.dom.TagName.STYLE), g = f.length, h = 0; h < g; ++h) c.push(f[h].outerHTML);
		return c.join("") + a
	}
	return a
};
goog.editor.plugins.BasicTextFormatter.prototype.handleKeyboardShortcut = function (a, b, c) {
	if (!c) return !1;
	var d;
	switch (b) {
	case "b":
		d = goog.editor.plugins.BasicTextFormatter.COMMAND.BOLD;
		break;
	case "i":
		d = goog.editor.plugins.BasicTextFormatter.COMMAND.ITALIC;
		break;
	case "u":
		d = goog.editor.plugins.BasicTextFormatter.COMMAND.UNDERLINE;
		break;
	case "s":
		return !0
	}
	return d ? (this.fieldObject.execCommand(d), !0) : !1
};
goog.editor.plugins.BasicTextFormatter.BR_REGEXP_ = goog.userAgent.IE ? /<br([^\/>]*)\/?>/gi : /<br([^\/>]*)\/?>(?!<\/(div|p)>)/gi;
goog.editor.plugins.BasicTextFormatter.prototype.convertBreaksToDivs_ = function () {
	if (!goog.userAgent.IE && !goog.userAgent.OPERA) return !1;
	var a = this.getRange_(),
		b = a.getContainerElement(),
		c = this.getDocument_();
	goog.editor.plugins.BasicTextFormatter.BR_REGEXP_.lastIndex = 0;
	return goog.editor.plugins.BasicTextFormatter.BR_REGEXP_.test(b.innerHTML) ? (a = a.saveUsingCarets(), b.tagName == goog.dom.TagName.P ? goog.editor.plugins.BasicTextFormatter.convertParagraphToDiv_(b, !0) : (b.innerHTML = b.innerHTML.replace(goog.editor.plugins.BasicTextFormatter.BR_REGEXP_,
		'<p$1 trtempbr="temp_br">'), b = goog.array.toArray(b.getElementsByTagName(goog.dom.TagName.P)), goog.iter.forEach(b, function (a) {
		if ("temp_br" == a.getAttribute("trtempbr")) {
			a.removeAttribute("trtempbr");
			if (goog.string.isBreakingWhitespace(goog.dom.getTextContent(a))) {
				var b = goog.userAgent.IE ? c.createTextNode(goog.string.Unicode.NBSP) : c.createElement(goog.dom.TagName.BR);
				a.appendChild(b)
			}
			goog.editor.plugins.BasicTextFormatter.convertParagraphToDiv_(a)
		}
	})), a.restore(), !0) : !1
};
goog.editor.plugins.BasicTextFormatter.convertParagraphToDiv_ = function (a, b) {
	if (goog.userAgent.IE || goog.userAgent.OPERA) {
		var c = a.outerHTML.replace(/<(\/?)p/gi, "<$1div");
		b && (c = c.replace(goog.editor.plugins.BasicTextFormatter.BR_REGEXP_, "</div><div$1>"));
		goog.userAgent.OPERA && !/<\/div>$/i.test(c) && (c += "</div>");
		a.outerHTML = c
	}
};
goog.editor.plugins.BasicTextFormatter.convertToRealExecCommand_ = function (a) {
	return 0 == a.indexOf("+") ? a.substring(1) : a
};
goog.editor.plugins.BasicTextFormatter.prototype.justify_ = function (a) {
	this.execCommandHelper_(a, null, !1, !0);
	goog.userAgent.GECKO && this.execCommandHelper_(a, null, !1, !0);
	(!goog.editor.BrowserFeature.HAS_STYLE_WITH_CSS || !goog.userAgent.GECKO) && goog.iter.forEach(this.fieldObject.getRange(), goog.editor.plugins.BasicTextFormatter.convertContainerToTextAlign_)
};
goog.editor.plugins.BasicTextFormatter.convertContainerToTextAlign_ = function (a) {
	a = goog.editor.style.getContainer(a);
	a.align && (a.style.textAlign = a.align, a.removeAttribute("align"))
};
goog.editor.plugins.BasicTextFormatter.prototype.execCommandHelper_ = function (a, b, c, d) {
	var e = null;
	c && (e = this.fieldObject.queryCommandValue(goog.editor.Command.DIR_RTL) ? "rtl" : this.fieldObject.queryCommandValue(goog.editor.Command.DIR_LTR) ? "ltr" : null);
	var a = goog.editor.plugins.BasicTextFormatter.convertToRealExecCommand_(a),
		f, g;
	goog.userAgent.IE && (g = this.applyExecCommandIEFixes_(a), f = g[0], g = g[1]);
	goog.userAgent.WEBKIT && (f = this.applyExecCommandSafariFixes_(a));
	goog.userAgent.GECKO && this.applyExecCommandGeckoFixes_(a);
	goog.editor.BrowserFeature.DOESNT_OVERRIDE_FONT_SIZE_IN_STYLE_ATTR && "fontsize" == a.toLowerCase() && this.removeFontSizeFromStyleAttrs_();
	c = this.getDocument_();
	d && goog.editor.BrowserFeature.HAS_STYLE_WITH_CSS && (c.execCommand("styleWithCSS", !1, !0), goog.userAgent.OPERA && this.invalidateInlineCss_());
	c.execCommand(a, !1, b);
	d && goog.editor.BrowserFeature.HAS_STYLE_WITH_CSS && c.execCommand("styleWithCSS", !1, !1);
	goog.userAgent.WEBKIT && (!goog.userAgent.isVersion("526") && "formatblock" == a.toLowerCase() && b && /^[<]?h\d[>]?$/i.test(b)) &&
		this.cleanUpSafariHeadings_();
	/insert(un)?orderedlist/i.test(a) && (goog.userAgent.WEBKIT && this.fixSafariLists_(), goog.userAgent.IE && (this.fixIELists_(), g && goog.dom.removeNode(g)));
	f && goog.dom.removeNode(f);
	e && this.fieldObject.execCommand(e)
};
goog.editor.plugins.BasicTextFormatter.prototype.applyBgColorManually_ = function (a) {
	var b = goog.userAgent.GECKO,
		c = this.fieldObject.getRange(),
		d, e;
	c && c.isCollapsed() && (d = this.getFieldDomHelper().createTextNode(b ? " " : ""), e = c.getStartNode(), e = e.nodeType == goog.dom.NodeType.ELEMENT ? e : e.parentNode, "" == e.innerHTML ? (e.style.textIndent = "-10000px", e.appendChild(d)) : (e = this.getFieldDomHelper().createDom("span", {
		style: "text-indent:-10000px"
	}, d), c.replaceContentsWithNode(e)), goog.dom.Range.createFromNodeContents(d).select());
	this.execCommandHelper_("hiliteColor", a, !1, !0);
	d && (b && (d.data = ""), e.style.textIndent = "")
};
goog.editor.plugins.BasicTextFormatter.prototype.toggleLink_ = function (a) {
	this.fieldObject.isSelectionEditable() || this.focusField_();
	var b = this.getRange_(),
		c = b && b.getContainerElement();
	if ((c = goog.dom.getAncestorByTagNameAndClass(c, goog.dom.TagName.A)) && goog.editor.node.isEditable(c)) goog.dom.flattenElement(c);
	else if (a = this.createLink_(b, "/", a)) {
		if (!this.fieldObject.execCommand(goog.editor.Command.MODAL_LINK_EDITOR, a))
			if (b = this.fieldObject.getAppWindow().prompt(goog.ui.editor.messages.MSG_LINK_TO,
				"http://")) a.setTextAndUrl(a.getCurrentText() || b, b), a.placeCursorRightOf();
			else return b = goog.editor.range.saveUsingNormalizedCarets(goog.dom.Range.createFromNodeContents(a.getAnchor())), a.removeLink(), b.restore().select(), null;
		return a
	}
	return null
};
goog.editor.plugins.BasicTextFormatter.prototype.createLink_ = function (a, b, c) {
	var d = null,
		e = a && a.getContainerElement();
	if (e && e.tagName == goog.dom.TagName.IMG) return null;
	if (a && a.isCollapsed()) a = a.getTextRange(0).getBrowserRangeObject(), goog.editor.BrowserFeature.HAS_W3C_RANGES ? (d = this.getFieldDomHelper().createElement(goog.dom.TagName.A), a.insertNode(d)) : goog.editor.BrowserFeature.HAS_IE_RANGES && (a.pasteHTML("<a id='newLink'></a>"), d = this.getFieldDomHelper().getElement("newLink"), d.removeAttribute("id"));
	else {
		var f = goog.string.createUniqueString();
		this.execCommandHelper_("CreateLink", f);
		goog.array.forEach(this.fieldObject.getElement().getElementsByTagName(goog.dom.TagName.A), function (a) {
			goog.string.endsWith(a.href, f) && (d = a)
		})
	}
	return goog.editor.Link.createNewLink(d, b, c)
};
goog.editor.plugins.BasicTextFormatter.brokenExecCommandsIE_ = {
	indent: 1,
	outdent: 1,
	insertOrderedList: 1,
	insertUnorderedList: 1,
	justifyCenter: 1,
	justifyFull: 1,
	justifyRight: 1,
	justifyLeft: 1,
	ltr: 1,
	rtl: 1
};
goog.editor.plugins.BasicTextFormatter.blockquoteHatingCommandsIE_ = {
	insertOrderedList: 1,
	insertUnorderedList: 1
};
goog.editor.plugins.BasicTextFormatter.prototype.applySubscriptSuperscriptWorkarounds_ = function (a) {
	if (!this.queryCommandValue(a)) {
		var a = a == goog.editor.plugins.BasicTextFormatter.COMMAND.SUBSCRIPT ? goog.editor.plugins.BasicTextFormatter.COMMAND.SUPERSCRIPT : goog.editor.plugins.BasicTextFormatter.COMMAND.SUBSCRIPT,
			b = goog.editor.plugins.BasicTextFormatter.convertToRealExecCommand_(a);
		this.queryCommandValue(a) || this.getDocument_().execCommand(b, !1, null);
		this.getDocument_().execCommand(b, !1, null)
	}
};
goog.editor.plugins.BasicTextFormatter.prototype.removeFontSizeFromStyleAttrs_ = function () {
	var a = goog.editor.range.expand(this.fieldObject.getRange(), this.fieldObject.getElement());
	goog.iter.forEach(goog.iter.filter(a, function (b, c, d) {
		return d.isStartTag() && a.containsNode(b)
	}), function (a) {
		goog.style.setStyle(a, "font-size", "");
		goog.userAgent.GECKO && (0 == a.style.length && null != a.getAttribute("style")) && a.removeAttribute("style")
	})
};
goog.editor.plugins.BasicTextFormatter.prototype.applyExecCommandIEFixes_ = function (a) {
	var b = [],
		c = null,
		d = this.getRange_(),
		e = this.getFieldDomHelper();
	if (a in goog.editor.plugins.BasicTextFormatter.blockquoteHatingCommandsIE_) {
		var f = d && d.getContainerElement();
		if (f) {
			for (var g = goog.dom.getElementsByTagNameAndClass(goog.dom.TagName.BLOCKQUOTE, null, f), h, j = 0; j < g.length; j++)
				if (d.containsNode(g[j])) {
					h = g[j];
					break
				}
			if (f = h || goog.dom.getAncestorByTagNameAndClass(f, "BLOCKQUOTE")) c = e.createDom("div", {
				style: "height:0"
			}),
			goog.dom.appendChild(f, c), b.push(c), h ? d = goog.dom.Range.createFromNodes(h, 0, c, 0) : d.containsNode(c) && (d = goog.dom.Range.createFromNodes(d.getStartNode(), d.getStartOffset(), c, 0)), d.select()
		}
	}
	h = this.fieldObject;
	!h.usesIframe() && !c && a in goog.editor.plugins.BasicTextFormatter.brokenExecCommandsIE_ && (a = h.getElement(), d && (d.isCollapsed() && !goog.dom.getFirstElementChild(a)) && (c = d.getTextRange(0).getBrowserRangeObject(), d = c.duplicate(), d.moveToElementText(a), d.collapse(!1), d.isEqual(c) && (d = e.createTextNode(goog.string.Unicode.NBSP),
		a.appendChild(d), c.move("character", 1), c.move("character", -1), c.select(), b.push(d))), c = e.createDom("div", {
		style: "height:0"
	}), goog.dom.appendChild(a, c), b.push(c));
	return b
};
goog.editor.plugins.BasicTextFormatter.prototype.cleanUpSafariHeadings_ = function () {
	goog.iter.forEach(this.getRange_(), function (a) {
		"Apple-style-span" == a.className && (a.style.fontSize = "", a.style.fontWeight = "")
	})
};
goog.editor.plugins.BasicTextFormatter.prototype.fixSafariLists_ = function () {
	var a = !1;
	goog.iter.forEach(this.getRange_(), function (b) {
		var c = b.tagName;
		if (c == goog.dom.TagName.UL || c == goog.dom.TagName.OL)
			if (a) {
				if (c = goog.dom.getPreviousElementSibling(b)) {
					var d = b.ownerDocument.createRange();
					d.setStartAfter(c);
					d.setEndBefore(b);
					if (goog.string.isEmpty(d.toString()) && c.nodeName == b.nodeName) {
						for (; c.lastChild;) b.insertBefore(c.lastChild, b.firstChild);
						c.parentNode.removeChild(c)
					}
				}
			} else a = !0
	})
};
goog.editor.plugins.BasicTextFormatter.orderedListTypes_ = {
	1: 1,
	a: 1,
	A: 1,
	i: 1,
	I: 1
};
goog.editor.plugins.BasicTextFormatter.unorderedListTypes_ = {
	disc: 1,
	circle: 1,
	square: 1
};
goog.editor.plugins.BasicTextFormatter.prototype.fixIELists_ = function () {
	for (var a = this.getRange_(), a = a && a.getContainer(); a && a.tagName != goog.dom.TagName.UL && a.tagName != goog.dom.TagName.OL;) a = a.parentNode;
	a && (a = a.parentNode);
	if (a) {
		var b = goog.array.toArray(a.getElementsByTagName(goog.dom.TagName.UL));
		goog.array.extend(b, goog.array.toArray(a.getElementsByTagName(goog.dom.TagName.OL)));
		goog.array.forEach(b, function (a) {
			var b = a.type;
			if (b && !(a.tagName == goog.dom.TagName.UL ? goog.editor.plugins.BasicTextFormatter.unorderedListTypes_ :
				goog.editor.plugins.BasicTextFormatter.orderedListTypes_)[b]) a.type = ""
		})
	}
};
goog.editor.plugins.BasicTextFormatter.brokenExecCommandsSafari_ = {
	justifyCenter: 1,
	justifyFull: 1,
	justifyRight: 1,
	justifyLeft: 1,
	formatBlock: 1
};
goog.editor.plugins.BasicTextFormatter.hangingExecCommandWebkit_ = {
	insertOrderedList: 1,
	insertUnorderedList: 1
};
goog.editor.plugins.BasicTextFormatter.prototype.applyExecCommandSafariFixes_ = function (a) {
	var b;
	goog.editor.plugins.BasicTextFormatter.brokenExecCommandsSafari_[a] && (b = this.getFieldDomHelper().createDom("div", {
		style: "height: 0"
	}, "x"), goog.dom.appendChild(this.fieldObject.getElement(), b));
	goog.editor.plugins.BasicTextFormatter.hangingExecCommandWebkit_[a] && (a = this.fieldObject.getElement(), b = this.getFieldDomHelper().createDom("div", {
		style: "height: 0"
	}, "x"), a.insertBefore(b, a.firstChild));
	return b
};
goog.editor.plugins.BasicTextFormatter.prototype.applyExecCommandGeckoFixes_ = function (a) {
	if (goog.userAgent.isVersion("1.9") && "formatblock" == a.toLowerCase()) {
		var a = this.getRange_(),
			b = a.getStartNode();
		if (a.isCollapsed() && b && b.tagName == goog.dom.TagName.BODY) {
			var c = a.getStartOffset();
			if ((b = b.childNodes[c]) && b.tagName == goog.dom.TagName.BR) a = a.getBrowserRangeObject(), a.setStart(b, 0), a.setEnd(b, 0)
		}
	}
};
goog.editor.plugins.BasicTextFormatter.prototype.invalidateInlineCss_ = function () {
	var a = [],
		b = this.fieldObject.getRange().getContainerElement();
	do a.push(b); while (b = b.parentNode);
	a = goog.iter.chain(goog.iter.toIterator(this.fieldObject.getRange()), goog.iter.toIterator(a));
	a = goog.iter.filter(a, goog.editor.style.isContainer);
	goog.iter.forEach(a, function (a) {
		var b = a.style.outline;
		a.style.outline = "0px solid red";
		a.style.outline = b
	})
};
goog.editor.plugins.BasicTextFormatter.prototype.beforeInsertListGecko_ = function () {
	var a = this.fieldObject.queryCommandValue(goog.editor.Command.DEFAULT_TAG);
	if (a == goog.dom.TagName.P || a == goog.dom.TagName.DIV) return !1;
	a = this.getRange_();
	if (a.isCollapsed() && a.getContainer().nodeType != goog.dom.NodeType.TEXT) {
		var b = this.getFieldDomHelper().createTextNode(goog.string.Unicode.NBSP);
		a.insertNode(b, !1);
		goog.dom.Range.createFromNodeContents(b).select();
		return !0
	}
	return !1
};
goog.editor.plugins.BasicTextFormatter.getSelectionBlockState_ = function (a) {
	var b = null;
	goog.iter.forEach(a, function (a, d, e) {
		if (!e.isEndTag()) {
			a = goog.editor.style.getContainer(a).tagName;
			b = b || a;
			if (b != a) throw b = null, goog.iter.StopIteration;
			e.skipTag()
		}
	});
	return b
};
goog.editor.plugins.BasicTextFormatter.SUPPORTED_JUSTIFICATIONS_ = {
	center: 1,
	justify: 1,
	right: 1,
	left: 1
};
goog.editor.plugins.BasicTextFormatter.prototype.isJustification_ = function (a) {
	a = a.replace("+justify", "").toLowerCase();
	"full" == a && (a = "justify");
	var b = this.fieldObject.getPluginByClassId("Bidi");
	if (b) return a == b.getSelectionAlignment();
	var c = this.getRange_();
	if (!c) return !1;
	for (var d = c.getContainerElement(), b = goog.array.filter(d.childNodes, function (a) {
			return goog.editor.node.isImportant(a) && c.containsNode(a, !0)
		}), b = b.length ? b : [d], d = 0; d < b.length; d++) {
		var e = goog.editor.style.getContainer(b[d]);
		if (a !=
			goog.editor.plugins.BasicTextFormatter.getNodeJustification_(e)) return !1
	}
	return !0
};
goog.editor.plugins.BasicTextFormatter.getNodeJustification_ = function (a) {
	var b = goog.style.getComputedTextAlign(a),
		b = b.replace(/^-(moz|webkit)-/, "");
	goog.editor.plugins.BasicTextFormatter.SUPPORTED_JUSTIFICATIONS_[b] || (b = a.align || "left");
	return b
};
goog.editor.plugins.BasicTextFormatter.prototype.isNodeInState_ = function (a) {
	var b = this.getRange_(),
		b = b && b.getContainerElement(),
		a = goog.dom.getAncestorByTagNameAndClass(b, a);
	return !!a && goog.editor.node.isEditable(a)
};
goog.editor.plugins.BasicTextFormatter.prototype.queryCommandStateInternal_ = function (a, b, c) {
	return this.queryCommandHelper_(!0, a, b, c)
};
goog.editor.plugins.BasicTextFormatter.prototype.queryCommandValueInternal_ = function (a, b, c) {
	return this.queryCommandHelper_(!1, a, b, c)
};
goog.editor.plugins.BasicTextFormatter.prototype.queryCommandHelper_ = function (a, b, c, d) {
	c = goog.editor.plugins.BasicTextFormatter.convertToRealExecCommand_(c);
	if (d) {
		var e = this.getDocument_();
		e.execCommand("styleWithCSS", !1, !0)
	}
	a = a ? b.queryCommandState(c) : b.queryCommandValue(c);
	d && e.execCommand("styleWithCSS", !1, !1);
	return a
};
goog.events.KeyCodes = {
	MAC_ENTER: 3,
	BACKSPACE: 8,
	TAB: 9,
	NUM_CENTER: 12,
	ENTER: 13,
	SHIFT: 16,
	CTRL: 17,
	ALT: 18,
	PAUSE: 19,
	CAPS_LOCK: 20,
	ESC: 27,
	SPACE: 32,
	PAGE_UP: 33,
	PAGE_DOWN: 34,
	END: 35,
	HOME: 36,
	LEFT: 37,
	UP: 38,
	RIGHT: 39,
	DOWN: 40,
	PRINT_SCREEN: 44,
	INSERT: 45,
	DELETE: 46,
	ZERO: 48,
	ONE: 49,
	TWO: 50,
	THREE: 51,
	FOUR: 52,
	FIVE: 53,
	SIX: 54,
	SEVEN: 55,
	EIGHT: 56,
	NINE: 57,
	QUESTION_MARK: 63,
	A: 65,
	B: 66,
	C: 67,
	D: 68,
	E: 69,
	F: 70,
	G: 71,
	H: 72,
	I: 73,
	J: 74,
	K: 75,
	L: 76,
	M: 77,
	N: 78,
	O: 79,
	P: 80,
	Q: 81,
	R: 82,
	S: 83,
	T: 84,
	U: 85,
	V: 86,
	W: 87,
	X: 88,
	Y: 89,
	Z: 90,
	META: 91,
	CONTEXT_MENU: 93,
	NUM_ZERO: 96,
	NUM_ONE: 97,
	NUM_TWO: 98,
	NUM_THREE: 99,
	NUM_FOUR: 100,
	NUM_FIVE: 101,
	NUM_SIX: 102,
	NUM_SEVEN: 103,
	NUM_EIGHT: 104,
	NUM_NINE: 105,
	NUM_MULTIPLY: 106,
	NUM_PLUS: 107,
	NUM_MINUS: 109,
	NUM_PERIOD: 110,
	NUM_DIVISION: 111,
	F1: 112,
	F2: 113,
	F3: 114,
	F4: 115,
	F5: 116,
	F6: 117,
	F7: 118,
	F8: 119,
	F9: 120,
	F10: 121,
	F11: 122,
	F12: 123,
	NUMLOCK: 144,
	SEMICOLON: 186,
	DASH: 189,
	EQUALS: 187,
	COMMA: 188,
	PERIOD: 190,
	SLASH: 191,
	APOSTROPHE: 192,
	SINGLE_QUOTE: 222,
	OPEN_SQUARE_BRACKET: 219,
	BACKSLASH: 220,
	CLOSE_SQUARE_BRACKET: 221,
	WIN_KEY: 224,
	MAC_FF_META: 224,
	WIN_IME: 229,
	PHANTOM: 255
};
goog.events.KeyCodes.isTextModifyingKeyEvent = function (a) {
	if (a.altKey && !a.ctrlKey || a.metaKey || a.keyCode >= goog.events.KeyCodes.F1 && a.keyCode <= goog.events.KeyCodes.F12) return !1;
	switch (a.keyCode) {
	case goog.events.KeyCodes.ALT:
	case goog.events.KeyCodes.CAPS_LOCK:
	case goog.events.KeyCodes.CONTEXT_MENU:
	case goog.events.KeyCodes.CTRL:
	case goog.events.KeyCodes.DOWN:
	case goog.events.KeyCodes.END:
	case goog.events.KeyCodes.ESC:
	case goog.events.KeyCodes.HOME:
	case goog.events.KeyCodes.INSERT:
	case goog.events.KeyCodes.LEFT:
	case goog.events.KeyCodes.MAC_FF_META:
	case goog.events.KeyCodes.META:
	case goog.events.KeyCodes.NUMLOCK:
	case goog.events.KeyCodes.NUM_CENTER:
	case goog.events.KeyCodes.PAGE_DOWN:
	case goog.events.KeyCodes.PAGE_UP:
	case goog.events.KeyCodes.PAUSE:
	case goog.events.KeyCodes.PHANTOM:
	case goog.events.KeyCodes.PRINT_SCREEN:
	case goog.events.KeyCodes.RIGHT:
	case goog.events.KeyCodes.SHIFT:
	case goog.events.KeyCodes.UP:
	case goog.events.KeyCodes.WIN_KEY:
		return !1;
	default:
		return !0
	}
};
goog.events.KeyCodes.firesKeyPressEvent = function (a, b, c, d, e) {
	if (!goog.userAgent.IE && (!goog.userAgent.WEBKIT || !goog.userAgent.isVersion("525"))) return !0;
	if (goog.userAgent.MAC && e) return goog.events.KeyCodes.isCharacterKey(a);
	if (e && !d || !c && (b == goog.events.KeyCodes.CTRL || b == goog.events.KeyCodes.ALT) || goog.userAgent.IE && d && b == a) return !1;
	switch (a) {
	case goog.events.KeyCodes.ENTER:
		return !0;
	case goog.events.KeyCodes.ESC:
		return !goog.userAgent.WEBKIT
	}
	return goog.events.KeyCodes.isCharacterKey(a)
};
goog.events.KeyCodes.isCharacterKey = function (a) {
	if (a >= goog.events.KeyCodes.ZERO && a <= goog.events.KeyCodes.NINE || a >= goog.events.KeyCodes.NUM_ZERO && a <= goog.events.KeyCodes.NUM_MULTIPLY || a >= goog.events.KeyCodes.A && a <= goog.events.KeyCodes.Z || goog.userAgent.WEBKIT && 0 == a) return !0;
	switch (a) {
	case goog.events.KeyCodes.SPACE:
	case goog.events.KeyCodes.QUESTION_MARK:
	case goog.events.KeyCodes.NUM_PLUS:
	case goog.events.KeyCodes.NUM_MINUS:
	case goog.events.KeyCodes.NUM_PERIOD:
	case goog.events.KeyCodes.NUM_DIVISION:
	case goog.events.KeyCodes.SEMICOLON:
	case goog.events.KeyCodes.DASH:
	case goog.events.KeyCodes.EQUALS:
	case goog.events.KeyCodes.COMMA:
	case goog.events.KeyCodes.PERIOD:
	case goog.events.KeyCodes.SLASH:
	case goog.events.KeyCodes.APOSTROPHE:
	case goog.events.KeyCodes.SINGLE_QUOTE:
	case goog.events.KeyCodes.OPEN_SQUARE_BRACKET:
	case goog.events.KeyCodes.BACKSLASH:
	case goog.events.KeyCodes.CLOSE_SQUARE_BRACKET:
		return !0;
	default:
		return !1
	}
};
goog.editor.icontent = {};
goog.editor.icontent.FieldFormatInfo = function (a, b, c, d, e) {
	this.fieldId_ = a;
	this.standards_ = b;
	this.blended_ = c;
	this.fixedHeight_ = d;
	this.extraStyles_ = e || {}
};
goog.editor.icontent.FieldStyleInfo = function (a, b) {
	this.wrapper_ = a;
	this.css_ = b
};
goog.editor.icontent.useStandardsModeIframes_ = !1;
goog.editor.icontent.forceStandardsModeIframes = function () {
	goog.editor.icontent.useStandardsModeIframes_ = !0
};
goog.editor.icontent.getInitialIframeContent_ = function (a, b, c) {
	var d = [];
	(a.blended_ && a.standards_ || goog.editor.icontent.useStandardsModeIframes_) && d.push("<!DOCTYPE HTML>");
	d.push("<html ");
	goog.editor.BrowserFeature.HAS_CONTENT_EDITABLE && !goog.editor.BrowserFeature.FOCUSES_EDITABLE_BODY_ON_HTML_CLICK && d.push("contentEditable ");
	d.push('style="background:none transparent;');
	goog.editor.BrowserFeature.HAS_CONTENT_EDITABLE && !goog.editor.BrowserFeature.FOCUSES_EDITABLE_BODY_ON_HTML_CLICK && d.push("min-height:100%;");
	a.blended_ && d.push("height:", a.fixedHeight_ ? "100%" : "auto");
	d.push('">');
	d.push("<head><style>");
	c && c.css_ && d.push(c.css_);
	goog.userAgent.GECKO && a.standards_ && d.push(" img {-moz-force-broken-image-icon: 1;}");
	d.push("</style></head>");
	d.push('<body g_editable="true" hidefocus="true" ');
	goog.editor.BrowserFeature.HAS_CONTENT_EDITABLE && goog.editor.BrowserFeature.FOCUSES_EDITABLE_BODY_ON_HTML_CLICK && d.push("contentEditable ");
	d.push('class="editable ');
	d.push('" id="', a.fieldId_, '" style="');
	goog.userAgent.GECKO &&
		a.blended_ && (d.push(";width:100%;border:0;margin:0;background:none transparent;", ";height:", a.standards_ ? "100%" : "auto"), a.fixedHeight_ ? d.push(";overflow:auto") : d.push(";overflow-y:hidden;overflow-x:auto"));
	for (var e in a.extraStyles_) d.push(";" + e + ":" + a.extraStyles_[e]);
	d.push('">', b, "</body></html>");
	return d.join("")
};
goog.editor.icontent.writeNormalInitialBlendedIframe = function (a, b, c, d) {
	if (a.blended_) {
		var e = goog.style.getPaddingBox(c.wrapper_);
		(e.top || e.left || e.right || e.bottom) && goog.style.setStyle(d, "margin", -e.top + "px " + -e.right + "px " + -e.bottom + "px " + -e.left + "px")
	}
	goog.editor.icontent.writeNormalInitialIframe(a, b, c, d)
};
goog.editor.icontent.writeNormalInitialIframe = function (a, b, c, d) {
	a = goog.editor.icontent.getInitialIframeContent_(a, b, c);
	d = goog.dom.getFrameContentDocument(d);
	d.open();
	d.write(a);
	d.close()
};
goog.editor.icontent.writeHttpsInitialIframe = function (a, b, c) {
	b = b.body;
	goog.editor.BrowserFeature.HAS_CONTENT_EDITABLE && (b.contentEditable = !0);
	b.className = "editable";
	b.setAttribute("g_editable", !0);
	b.hideFocus = !0;
	b.id = a.fieldId_;
	goog.style.setStyle(b, a.extraStyles_);
	b.innerHTML = c
};
goog.events.EventHandler = function (a) {
	this.handler_ = a
};
goog.inherits(goog.events.EventHandler, goog.Disposable);
goog.events.EventHandler.KEY_POOL_INITIAL_COUNT = 0;
goog.events.EventHandler.KEY_POOL_MAX_COUNT = 100;
goog.events.EventHandler.keyPool_ = new goog.structs.SimplePool(goog.events.EventHandler.KEY_POOL_INITIAL_COUNT, goog.events.EventHandler.KEY_POOL_MAX_COUNT);
goog.events.EventHandler.keys_ = null;
goog.events.EventHandler.key_ = null;
goog.events.EventHandler.typeArray_ = [];
goog.events.EventHandler.prototype.listen = function (a, b, c, d, e) {
	goog.isArray(b) || (goog.events.EventHandler.typeArray_[0] = b, b = goog.events.EventHandler.typeArray_);
	for (var f = 0; f < b.length; f++) this.recordListenerKey_(goog.events.listen(a, b[f], c || this, d || !1, e || this.handler_ || this));
	return this
};
goog.events.EventHandler.prototype.listenOnce = function (a, b, c, d, e) {
	if (goog.isArray(b))
		for (var f = 0; f < b.length; f++) this.listenOnce(a, b[f], c, d, e);
	else this.recordListenerKey_(goog.events.listenOnce(a, b, c || this, d || !1, e || this.handler_ || this));
	return this
};
goog.events.EventHandler.prototype.listenWithWrapper = function (a, b, c, d, e) {
	b.listen(a, c, d, e || this.handler_, this);
	return this
};
goog.events.EventHandler.prototype.recordListenerKey_ = function (a) {
	this.keys_ ? this.keys_[a] = !0 : this.key_ ? (this.keys_ = goog.events.EventHandler.keyPool_.getObject(), this.keys_[this.key_] = !0, this.key_ = null, this.keys_[a] = !0) : this.key_ = a
};
goog.events.EventHandler.prototype.unlisten = function (a, b, c, d, e) {
	if (this.key_ || this.keys_)
		if (goog.isArray(b))
			for (var f = 0; f < b.length; f++) this.unlisten(a, b[f], c, d, e);
		else if (a = goog.events.getListener(a, b, c || this, d || !1, e || this.handler_ || this)) a = a.key, goog.events.unlistenByKey(a), this.keys_ ? goog.object.remove(this.keys_, a) : this.key_ == a && (this.key_ = null);
	return this
};
goog.events.EventHandler.prototype.unlistenWithWrapper = function (a, b, c, d, e) {
	b.unlisten(a, c, d, e || this.handler_, this);
	return this
};
goog.events.EventHandler.prototype.removeAll = function () {
	if (this.keys_) {
		for (var a in this.keys_) goog.events.unlistenByKey(a), delete this.keys_[a];
		goog.events.EventHandler.keyPool_.releaseObject(this.keys_);
		this.keys_ = null
	} else this.key_ && goog.events.unlistenByKey(this.key_)
};
goog.events.EventHandler.prototype.disposeInternal = function () {
	goog.events.EventHandler.superClass_.disposeInternal.call(this);
	this.removeAll()
};
goog.events.EventHandler.prototype.handleEvent = function () {
	throw Error("EventHandler.handleEvent not implemented");
};
goog.Timer = function (a, b) {
	goog.events.EventTarget.call(this);
	this.interval_ = a || 1;
	this.timerObject_ = b || goog.Timer.defaultTimerObject;
	this.boundTick_ = goog.bind(this.tick_, this);
	this.last_ = goog.now()
};
goog.inherits(goog.Timer, goog.events.EventTarget);
goog.Timer.MAX_TIMEOUT_ = 2147483647;
goog.Timer.prototype.enabled = !1;
goog.Timer.defaultTimerObject = goog.global.window;
goog.Timer.intervalScale = 0.8;
goog.Timer.prototype.timer_ = null;
goog.Timer.prototype.getInterval = function () {
	return this.interval_
};
goog.Timer.prototype.setInterval = function (a) {
	this.interval_ = a;
	this.timer_ && this.enabled ? (this.stop(), this.start()) : this.timer_ && this.stop()
};
goog.Timer.prototype.tick_ = function () {
	if (this.enabled) {
		var a = goog.now() - this.last_;
		0 < a && a < this.interval_ * goog.Timer.intervalScale ? this.timer_ = this.timerObject_.setTimeout(this.boundTick_, this.interval_ - a) : (this.dispatchTick(), this.enabled && (this.timer_ = this.timerObject_.setTimeout(this.boundTick_, this.interval_), this.last_ = goog.now()))
	}
};
goog.Timer.prototype.dispatchTick = function () {
	this.dispatchEvent(goog.Timer.TICK)
};
goog.Timer.prototype.start = function () {
	this.enabled = !0;
	this.timer_ || (this.timer_ = this.timerObject_.setTimeout(this.boundTick_, this.interval_), this.last_ = goog.now())
};
goog.Timer.prototype.stop = function () {
	this.enabled = !1;
	this.timer_ && (this.timerObject_.clearTimeout(this.timer_), this.timer_ = null)
};
goog.Timer.prototype.disposeInternal = function () {
	goog.Timer.superClass_.disposeInternal.call(this);
	this.stop();
	delete this.timerObject_
};
goog.Timer.TICK = "tick";
goog.Timer.callOnce = function (a, b, c) {
	if (goog.isFunction(a)) c && (a = goog.bind(a, c));
	else if (a && "function" == typeof a.handleEvent) a = goog.bind(a.handleEvent, a);
	else throw Error("Invalid listener argument");
	return b > goog.Timer.MAX_TIMEOUT_ ? -1 : goog.Timer.defaultTimerObject.setTimeout(a, b || 0)
};
goog.Timer.clear = function (a) {
	goog.Timer.defaultTimerObject.clearTimeout(a)
};
goog.async = {};
goog.async.Delay = function (a, b, c) {
	this.listener_ = a;
	this.interval_ = b || 0;
	this.handler_ = c;
	this.callback_ = goog.bind(this.doAction_, this)
};
goog.inherits(goog.async.Delay, goog.Disposable);
goog.Delay = goog.async.Delay;
goog.async.Delay.prototype.id_ = 0;
goog.async.Delay.prototype.disposeInternal = function () {
	goog.async.Delay.superClass_.disposeInternal.call(this);
	this.stop();
	delete this.listener_;
	delete this.handler_
};
goog.async.Delay.prototype.start = function (a) {
	this.stop();
	this.id_ = goog.Timer.callOnce(this.callback_, goog.isDef(a) ? a : this.interval_)
};
goog.async.Delay.prototype.stop = function () {
	this.isActive() && goog.Timer.clear(this.id_);
	this.id_ = 0
};
goog.async.Delay.prototype.fire = function () {
	this.stop();
	this.doAction_()
};
goog.async.Delay.prototype.fireIfActive = function () {
	this.isActive() && this.fire()
};
goog.async.Delay.prototype.isActive = function () {
	return 0 != this.id_
};
goog.async.Delay.prototype.doAction_ = function () {
	this.id_ = 0;
	this.listener_ && this.listener_.call(this.handler_)
};
goog.editor.Field = function (a, b) {
	goog.events.EventTarget.call(this);
	this.hashCode_ = this.id = a;
	this.editableDomHelper = null;
	this.plugins_ = {};
	this.indexedPlugins_ = {};
	for (var c in goog.editor.Plugin.OPCODE) this.indexedPlugins_[c] = [];
	this.cssStyles = "";
	goog.userAgent.WEBKIT && (goog.userAgent.isVersion("525.13") && 0 >= goog.string.compareVersions(goog.userAgent.VERSION, "525.18")) && (this.workaroundClassName_ = "tr-webkit-workaround", this.cssStyles = "." + this.workaroundClassName_ + ">*{padding-right:1}");
	this.stoppedEvents_ = {};
	this.stopEvent(goog.editor.Field.EventType.CHANGE);
	this.stopEvent(goog.editor.Field.EventType.DELAYEDCHANGE);
	this.isEverModified_ = this.isModified_ = !1;
	this.delayedChangeTimer_ = new goog.async.Delay(this.dispatchDelayedChange_, goog.editor.Field.DELAYED_CHANGE_FREQUENCY, this);
	this.debouncedEvents_ = {};
	for (var d in goog.editor.Field.EventType) this.debouncedEvents_[goog.editor.Field.EventType[d]] = 0;
	goog.editor.BrowserFeature.USE_MUTATION_EVENTS && (this.changeTimerGecko_ = new goog.async.Delay(this.handleChange,
		goog.editor.Field.CHANGE_FREQUENCY, this));
	this.eventRegister = new goog.events.EventHandler(this);
	this.wrappers_ = [];
	this.loadState_ = goog.editor.Field.LoadState_.UNEDITABLE;
	this.originalDomHelper = goog.dom.getDomHelper(b || document);
	this.originalElement = this.originalDomHelper.getElement(this.id);
	this.appWindow_ = this.originalDomHelper.getWindow()
};
goog.inherits(goog.editor.Field, goog.events.EventTarget);
goog.editor.Field.prototype.field = null;
goog.editor.Field.prototype.originalElement = null;
goog.editor.Field.prototype.logger = goog.debug.Logger.getLogger("goog.editor.Field");
goog.editor.Field.EventType = {
	COMMAND_VALUE_CHANGE: "cvc",
	LOAD: "load",
	UNLOAD: "unload",
	BEFORECHANGE: "beforechange",
	CHANGE: "change",
	DELAYEDCHANGE: "delayedchange",
	BEFOREFOCUS: "beforefocus",
	FOCUS: "focus",
	BLUR: "blur",
	BEFORETAB: "beforetab",
	SELECTIONCHANGE: "selectionchange"
};
goog.editor.Field.LoadState_ = {
	UNEDITABLE: 0,
	LOADING: 1,
	EDITABLE: 2
};
goog.editor.Field.DEBOUNCE_TIME_MS_ = 500;
goog.editor.Field.activeFieldId_ = null;
goog.editor.Field.prototype.inModalMode_ = !1;
goog.editor.Field.setActiveFieldId = function (a) {
	goog.editor.Field.activeFieldId_ = a
};
goog.editor.Field.getActiveFieldId = function () {
	return goog.editor.Field.activeFieldId_
};
goog.editor.Field.prototype.inModalMode = function () {
	return this.inModalMode_
};
goog.editor.Field.prototype.setModalMode = function (a) {
	this.inModalMode_ = a
};
goog.editor.Field.prototype.getHashCode = function () {
	return this.hashCode_
};
goog.editor.Field.prototype.getElement = function () {
	return this.field
};
goog.editor.Field.prototype.getOriginalElement = function () {
	return this.originalElement
};
goog.editor.Field.prototype.addListener = function (a, b, c, d) {
	var e = this.getElement();
	!goog.editor.BrowserFeature.FOCUSES_EDITABLE_BODY_ON_HTML_CLICK && e.parentNode.contentEditable && (e = e.parentNode);
	e && goog.editor.BrowserFeature.USE_DOCUMENT_FOR_KEY_EVENTS && (e = e.ownerDocument);
	this.eventRegister.listen(e, a, b, c, d)
};
goog.editor.Field.prototype.getPluginByClassId = function (a) {
	return this.plugins_[a]
};
goog.editor.Field.prototype.registerPlugin = function (a) {
	var b = a.getTrogClassId();
	this.plugins_[b] && this.logger.severe("Cannot register the same class of plugin twice.");
	this.plugins_[b] = a;
	for (var c in goog.editor.Plugin.OPCODE) a[goog.editor.Plugin.OPCODE[c]] && this.indexedPlugins_[c].push(a);
	a.registerFieldObject(this);
	this.isLoaded() && a.enable(this)
};
goog.editor.Field.prototype.unregisterPlugin = function (a) {
	var b = a.getTrogClassId();
	this.plugins_[b] || this.logger.severe("Cannot unregister a plugin that isn't registered.");
	delete this.plugins_[b];
	for (var c in goog.editor.Plugin.OPCODE) a[goog.editor.Plugin.OPCODE[c]] && goog.array.remove(this.indexedPlugins_[c], a);
	a.unregisterFieldObject(this)
};
goog.editor.Field.prototype.setInitialStyle = function (a) {
	this.cssText = a
};
goog.editor.Field.prototype.resetOriginalElemProperties = function () {
	var a = this.getOriginalElement();
	a.removeAttribute("contentEditable");
	a.removeAttribute("g_editable");
	this.id ? a.id = this.id : a.removeAttribute("id");
	a.className = this.savedClassName_ || "";
	var b = this.cssText;
	b ? goog.dom.setProperties(a, {
		style: b
	}) : a.removeAttribute("style");
	goog.isString(this.originalFieldLineHeight_) && (goog.style.setStyle(a, "lineHeight", this.originalFieldLineHeight_), this.originalFieldLineHeight_ = null)
};
goog.editor.Field.prototype.isModified = function (a) {
	return a ? this.isEverModified_ : this.isModified_
};
goog.editor.Field.CHANGE_FREQUENCY = 15;
goog.editor.Field.DELAYED_CHANGE_FREQUENCY = 250;
goog.editor.Field.prototype.usesIframe = goog.functions.TRUE;
goog.editor.Field.prototype.isFixedHeight = goog.functions.TRUE;
goog.editor.Field.KEYS_CAUSING_CHANGES_ = {
	46: !0,
	8: !0
};
goog.userAgent.IE || (goog.editor.Field.KEYS_CAUSING_CHANGES_[9] = !0);
goog.editor.Field.CTRL_KEYS_CAUSING_CHANGES_ = {
	86: !0,
	88: !0
};
goog.userAgent.IE && (goog.editor.Field.KEYS_CAUSING_CHANGES_[229] = !0);
goog.editor.Field.isGeneratingKey_ = function (a, b) {
	return goog.editor.Field.isSpecialGeneratingKey_(a) ? !0 : !(!b || a.ctrlKey || a.metaKey || goog.userAgent.GECKO && !a.charCode)
};
goog.editor.Field.isSpecialGeneratingKey_ = function (a) {
	var b = !(a.ctrlKey || a.metaKey) && a.keyCode in goog.editor.Field.KEYS_CAUSING_CHANGES_;
	return (a.ctrlKey || a.metaKey) && a.keyCode in goog.editor.Field.CTRL_KEYS_CAUSING_CHANGES_ || b
};
goog.editor.Field.prototype.setAppWindow = function (a) {
	this.appWindow_ = a
};
goog.editor.Field.prototype.getAppWindow = function () {
	return this.appWindow_
};
goog.editor.Field.prototype.setBaseZindex = function (a) {
	this.baseZindex_ = a
};
goog.editor.Field.prototype.getBaseZindex = function () {
	return this.baseZindex_ || 0
};
goog.editor.Field.prototype.setupFieldObject = function (a) {
	this.loadState_ = goog.editor.Field.LoadState_.EDITABLE;
	this.field = a;
	this.editableDomHelper = goog.dom.getDomHelper(a);
	this.isEverModified_ = this.isModified_ = !1;
	a.setAttribute("g_editable", "true")
};
goog.editor.Field.prototype.tearDownFieldObject_ = function () {
	this.loadState_ = goog.editor.Field.LoadState_.UNEDITABLE;
	for (var a in this.plugins_) {
		var b = this.plugins_[a];
		b.activeOnUneditableFields() || b.disable(this)
	}
	this.editableDomHelper = this.field = null
};
goog.editor.Field.prototype.setupChangeListeners_ = function () {
	goog.userAgent.OPERA && this.usesIframe() ? (this.eventRegister.listen(this.getEditableDomHelper().getDocument(), goog.events.EventType.FOCUS, this.dispatchFocusAndBeforeFocus_), this.eventRegister.listen(this.getEditableDomHelper().getDocument(), goog.events.EventType.BLUR, this.dispatchBlur)) : (goog.editor.BrowserFeature.SUPPORTS_FOCUSIN ? (this.addListener(goog.events.EventType.FOCUS, this.dispatchFocus_), this.addListener(goog.events.EventType.FOCUSIN,
		this.dispatchBeforeFocus_)) : this.addListener(goog.events.EventType.FOCUS, this.dispatchFocusAndBeforeFocus_), this.addListener(goog.events.EventType.BLUR, this.dispatchBlur, goog.editor.BrowserFeature.USE_MUTATION_EVENTS));
	goog.editor.BrowserFeature.USE_MUTATION_EVENTS ? this.setupMutationEventHandlersGecko() : (this.addListener(["beforecut", "beforepaste", "drop", "dragend"], this.dispatchBeforeChange), this.addListener(["cut", "paste"], this.dispatchChange), this.addListener("drop", this.handleDrop_));
	this.addListener(goog.userAgent.WEBKIT ?
		"dragend" : "dragdrop", this.handleDrop_);
	this.addListener(goog.events.EventType.KEYDOWN, this.handleKeyDown_);
	this.addListener(goog.events.EventType.KEYPRESS, this.handleKeyPress_);
	this.addListener(goog.events.EventType.KEYUP, this.handleKeyUp_);
	this.selectionChangeTimer_ = new goog.async.Delay(this.handleSelectionChangeTimer_, goog.editor.Field.SELECTION_CHANGE_FREQUENCY_, this);
	goog.editor.BrowserFeature.FOLLOWS_EDITABLE_LINKS && this.addListener(goog.events.EventType.CLICK, goog.editor.Field.cancelLinkClick_);
	this.addListener(goog.events.EventType.MOUSEDOWN, this.handleMouseDown_);
	this.addListener(goog.events.EventType.MOUSEUP, this.handleMouseUp_)
};
goog.editor.Field.SELECTION_CHANGE_FREQUENCY_ = 250;
goog.editor.Field.prototype.clearListeners_ = function () {
	this.eventRegister && this.eventRegister.removeAll();
	this.changeTimerGecko_ && this.changeTimerGecko_.stop();
	this.delayedChangeTimer_.stop()
};
goog.editor.Field.prototype.disposeInternal = function () {
	(this.isLoading() || this.isLoaded()) && this.logger.warning("Disposing a field that is in use.");
	this.getOriginalElement() && this.execCommand(goog.editor.Command.CLEAR_LOREM);
	this.tearDownFieldObject_();
	this.clearListeners_();
	this.originalDomHelper = null;
	this.eventRegister && (this.eventRegister.dispose(), this.eventRegister = null);
	this.removeAllWrappers();
	goog.editor.Field.getActiveFieldId() == this.id && goog.editor.Field.setActiveFieldId(null);
	for (var a in this.plugins_) {
		var b =
			this.plugins_[a];
		b.isAutoDispose() && b.dispose()
	}
	delete this.plugins_;
	goog.editor.Field.superClass_.disposeInternal.call(this)
};
goog.editor.Field.prototype.attachWrapper = function (a) {
	this.wrappers_.push(a)
};
goog.editor.Field.prototype.removeAllWrappers = function () {
	for (var a; a = this.wrappers_.pop();) a.dispose()
};
goog.editor.Field.MUTATION_EVENTS_GECKO = ["DOMNodeInserted", "DOMNodeRemoved", "DOMNodeRemovedFromDocument", "DOMNodeInsertedIntoDocument", "DOMCharacterDataModified"];
goog.editor.Field.prototype.setupMutationEventHandlersGecko = function () {
	if (goog.editor.BrowserFeature.HAS_DOM_SUBTREE_MODIFIED_EVENT) this.eventRegister.listen(this.getElement(), "DOMSubtreeModified", this.handleMutationEventGecko_);
	else {
		var a = this.getEditableDomHelper().getDocument();
		this.eventRegister.listen(a, goog.editor.Field.MUTATION_EVENTS_GECKO, this.handleMutationEventGecko_, !0);
		this.eventRegister.listen(a, "DOMAttrModified", goog.bind(this.handleDomAttrChange, this, this.handleMutationEventGecko_), !0)
	}
};
goog.editor.Field.prototype.handleBeforeChangeKeyEvent_ = function (a) {
	if (a.keyCode == goog.events.KeyCodes.TAB && !this.dispatchBeforeTab_(a) || goog.userAgent.GECKO && a.metaKey && (a.keyCode == goog.events.KeyCodes.LEFT || a.keyCode == goog.events.KeyCodes.RIGHT)) return a.preventDefault(), !1;
	(this.gotGeneratingKey_ = a.charCode || goog.editor.Field.isGeneratingKey_(a, goog.userAgent.GECKO)) && this.dispatchBeforeChange();
	return !0
};
goog.editor.Field.SELECTION_CHANGE_KEYCODES_ = {
	8: 1,
	9: 1,
	13: 1,
	33: 1,
	34: 1,
	35: 1,
	36: 1,
	37: 1,
	38: 1,
	39: 1,
	40: 1,
	46: 1
};
goog.editor.Field.CTRL_KEYS_CAUSING_SELECTION_CHANGES_ = {
	65: !0,
	86: !0,
	88: !0
};
goog.editor.Field.POTENTIAL_SHORTCUT_KEYCODES_ = {
	8: 1,
	9: 1,
	13: 1,
	27: 1,
	33: 1,
	34: 1,
	37: 1,
	38: 1,
	39: 1,
	40: 1
};
goog.editor.Field.prototype.invokeShortCircuitingOp_ = function (a, b) {
	for (var c = this.indexedPlugins_[a], d = goog.array.slice(arguments, 1), e = 0; e < c.length; ++e) {
		var f = c[e];
		if ((f.isEnabled(this) || goog.editor.Plugin.IRREPRESSIBLE_OPS[a]) && f[goog.editor.Plugin.OPCODE[a]].apply(f, d)) return !0
	}
	return !1
};
goog.editor.Field.prototype.invokeOp_ = function (a, b) {
	for (var c = this.indexedPlugins_[a], d = goog.array.slice(arguments, 1), e = 0; e < c.length; ++e) {
		var f = c[e];
		(f.isEnabled(this) || goog.editor.Plugin.IRREPRESSIBLE_OPS[a]) && f[goog.editor.Plugin.OPCODE[a]].apply(f, d)
	}
};
goog.editor.Field.prototype.reduceOp_ = function (a, b, c) {
	for (var d = this.indexedPlugins_[a], e = goog.array.slice(arguments, 1), f = 0; f < d.length; ++f) {
		var g = d[f];
		if (g.isEnabled(this) || goog.editor.Plugin.IRREPRESSIBLE_OPS[a]) e[0] = g[goog.editor.Plugin.OPCODE[a]].apply(g, e)
	}
	return e[0]
};
goog.editor.Field.prototype.injectContents = function (a, b) {
	var c = {}, d = this.getInjectableContents(a, c);
	goog.style.setStyle(b, c);
	b.innerHTML = d
};
goog.editor.Field.prototype.getInjectableContents = function (a, b) {
	return this.reduceOp_(goog.editor.Plugin.Op.PREPARE_CONTENTS_HTML, a || "", b)
};
goog.editor.Field.prototype.handleKeyDown_ = function (a) {
	(goog.editor.BrowserFeature.USE_MUTATION_EVENTS || this.handleBeforeChangeKeyEvent_(a)) && !this.invokeShortCircuitingOp_(goog.editor.Plugin.Op.KEYDOWN, a) && goog.editor.BrowserFeature.USES_KEYDOWN && this.handleKeyboardShortcut_(a)
};
goog.editor.Field.prototype.handleKeyPress_ = function (a) {
	if (goog.editor.BrowserFeature.USE_MUTATION_EVENTS) {
		if (!this.handleBeforeChangeKeyEvent_(a)) return
	} else this.gotGeneratingKey_ = !0, this.dispatchBeforeChange();
	!this.invokeShortCircuitingOp_(goog.editor.Plugin.Op.KEYPRESS, a) && !goog.editor.BrowserFeature.USES_KEYDOWN && this.handleKeyboardShortcut_(a)
};
goog.editor.Field.prototype.handleKeyUp_ = function (a) {
	!goog.editor.BrowserFeature.USE_MUTATION_EVENTS && (this.gotGeneratingKey_ || goog.editor.Field.isSpecialGeneratingKey_(a)) && this.handleChange();
	this.invokeShortCircuitingOp_(goog.editor.Plugin.Op.KEYUP, a);
	this.isEventStopped(goog.editor.Field.EventType.SELECTIONCHANGE) || (goog.editor.Field.SELECTION_CHANGE_KEYCODES_[a.keyCode] || (a.ctrlKey || a.metaKey) && goog.editor.Field.CTRL_KEYS_CAUSING_SELECTION_CHANGES_[a.keyCode]) && this.selectionChangeTimer_.start()
};
goog.editor.Field.prototype.handleKeyboardShortcut_ = function (a) {
	if (!a.altKey) {
		var b = goog.userAgent.MAC ? a.metaKey : a.ctrlKey;
		if (b || goog.editor.Field.POTENTIAL_SHORTCUT_KEYCODES_[a.keyCode]) {
			var c = a.charCode || a.keyCode;
			17 != c && (c = String.fromCharCode(c).toLowerCase(), this.invokeShortCircuitingOp_(goog.editor.Plugin.Op.SHORTCUT, a, c, b) && a.preventDefault())
		}
	}
};
goog.editor.Field.prototype.execCommand = function (a, b) {
	for (var c = arguments, d, e = this.indexedPlugins_[goog.editor.Plugin.Op.EXEC_COMMAND], f = 0; f < e.length; ++f) {
		var g = e[f];
		if (g.isEnabled(this) && g.isSupportedCommand(a)) {
			d = g.execCommand.apply(g, c);
			break
		}
	}
	return d
};
goog.editor.Field.prototype.queryCommandValue = function (a) {
	var b = this.isLoaded() && this.isSelectionEditable();
	if (goog.isString(a)) return this.queryCommandValueInternal_(a, b);
	for (var c = {}, d = 0; d < a.length; d++) c[a[d]] = this.queryCommandValueInternal_(a[d], b);
	return c
};
goog.editor.Field.prototype.queryCommandValueInternal_ = function (a, b) {
	for (var c = this.indexedPlugins_[goog.editor.Plugin.Op.QUERY_COMMAND], d = 0; d < c.length; ++d) {
		var e = c[d];
		if (e.isEnabled(this) && e.isSupportedCommand(a) && (b || e.activeOnUneditableFields())) return e.queryCommandValue(a)
	}
	return b ? null : !1
};
goog.editor.Field.prototype.handleDomAttrChange = function (a, b) {
	if (!this.isEventStopped(goog.editor.Field.EventType.CHANGE)) {
		b = b.getBrowserEvent();
		try {
			if (b.originalTarget.prefix || "scrollbar" == b.originalTarget.nodeName) return
		} catch (c) {
			return
		}
		b.prevValue != b.newValue && a.call(this, b)
	}
};
goog.editor.Field.prototype.handleMutationEventGecko_ = function (a) {
	this.isEventStopped(goog.editor.Field.EventType.CHANGE) || (a = a.getBrowserEvent ? a.getBrowserEvent() : a, a.target.firebugIgnore || (this.isEverModified_ = this.isModified_ = !0, this.changeTimerGecko_.start()))
};
goog.editor.Field.prototype.handleDrop_ = function () {
	goog.userAgent.IE && this.execCommand(goog.editor.Command.CLEAR_LOREM, !0);
	goog.editor.BrowserFeature.USE_MUTATION_EVENTS && this.dispatchFocusAndBeforeFocus_();
	this.dispatchChange()
};
goog.editor.Field.prototype.getEditableIframe = function () {
	var a;
	return this.usesIframe() && (a = this.getEditableDomHelper()) ? (a = a.getWindow()) && a.frameElement : null
};
goog.editor.Field.prototype.getEditableDomHelper = function () {
	return this.editableDomHelper
};
goog.editor.Field.prototype.getRange = function () {
	var a = this.editableDomHelper && this.editableDomHelper.getWindow();
	return a && goog.dom.Range.createFromWindow(a)
};
goog.editor.Field.prototype.dispatchSelectionChangeEvent = function (a, b) {
	if (!this.isEventStopped(goog.editor.Field.EventType.SELECTIONCHANGE)) {
		var c = this.getRange(),
			c = c && c.getContainerElement();
		this.isSelectionEditable_ = !! c && goog.dom.contains(this.getElement(), c);
		this.dispatchCommandValueChange();
		this.dispatchEvent({
			type: goog.editor.Field.EventType.SELECTIONCHANGE,
			originalType: a && a.type
		});
		this.invokeShortCircuitingOp_(goog.editor.Plugin.Op.SELECTION, a, b)
	}
};
goog.editor.Field.prototype.handleSelectionChangeTimer_ = function () {
	var a = this.selectionChangeTarget_;
	this.selectionChangeTarget_ = null;
	this.dispatchSelectionChangeEvent(void 0, a)
};
goog.editor.Field.prototype.dispatchBeforeChange = function () {
	this.isEventStopped(goog.editor.Field.EventType.BEFORECHANGE) || this.dispatchEvent(goog.editor.Field.EventType.BEFORECHANGE)
};
goog.editor.Field.prototype.dispatchBeforeTab_ = function (a) {
	return this.dispatchEvent({
		type: goog.editor.Field.EventType.BEFORETAB,
		shiftKey: a.shiftKey,
		altKey: a.altKey,
		ctrlKey: a.ctrlKey
	})
};
goog.editor.Field.prototype.stopChangeEvents = function (a, b) {
	a && (this.changeTimerGecko_ && this.changeTimerGecko_.fireIfActive(), this.stopEvent(goog.editor.Field.EventType.CHANGE));
	b && (this.clearDelayedChange(), this.stopEvent(goog.editor.Field.EventType.DELAYEDCHANGE))
};
goog.editor.Field.prototype.startChangeEvents = function (a, b) {
	!a && this.changeTimerGecko_ && this.changeTimerGecko_.fireIfActive();
	this.startEvent(goog.editor.Field.EventType.CHANGE);
	this.startEvent(goog.editor.Field.EventType.DELAYEDCHANGE);
	a && this.handleChange();
	b && this.dispatchDelayedChange_()
};
goog.editor.Field.prototype.stopEvent = function (a) {
	this.stoppedEvents_[a] = 1
};
goog.editor.Field.prototype.startEvent = function (a) {
	this.stoppedEvents_[a] = 0
};
goog.editor.Field.prototype.debounceEvent = function (a) {
	this.debouncedEvents_[a] = goog.now()
};
goog.editor.Field.prototype.isEventStopped = function (a) {
	return !!this.stoppedEvents_[a] || this.debouncedEvents_[a] && goog.now() - this.debouncedEvents_[a] <= goog.editor.Field.DEBOUNCE_TIME_MS_
};
goog.editor.Field.prototype.manipulateDom = function (a, b, c) {
	this.stopChangeEvents(!0, !0);
	try {
		a.call(c)
	} finally {
		this.isLoaded() && (b ? (this.startEvent(goog.editor.Field.EventType.CHANGE), this.handleChange(), this.startEvent(goog.editor.Field.EventType.DELAYEDCHANGE)) : this.dispatchChange())
	}
};
goog.editor.Field.prototype.dispatchCommandValueChange = function (a) {
	a ? this.dispatchEvent({
		type: goog.editor.Field.EventType.COMMAND_VALUE_CHANGE,
		commands: a
	}) : this.dispatchEvent(goog.editor.Field.EventType.COMMAND_VALUE_CHANGE)
};
goog.editor.Field.prototype.dispatchChange = function (a) {
	this.startChangeEvents(!0, a)
};
goog.editor.Field.prototype.handleChange = function () {
	this.isEventStopped(goog.editor.Field.EventType.CHANGE) || (this.changeTimerGecko_ && this.changeTimerGecko_.stop(), this.isEverModified_ = this.isModified_ = !0, this.isEventStopped(goog.editor.Field.EventType.DELAYEDCHANGE) || this.delayedChangeTimer_.start())
};
goog.editor.Field.prototype.dispatchDelayedChange_ = function () {
	this.isEventStopped(goog.editor.Field.EventType.DELAYEDCHANGE) || (this.delayedChangeTimer_.stop(), this.isModified_ = !1, this.dispatchEvent(goog.editor.Field.EventType.DELAYEDCHANGE))
};
goog.editor.Field.prototype.clearDelayedChange = function () {
	this.changeTimerGecko_ && this.changeTimerGecko_.fireIfActive();
	this.delayedChangeTimer_.fireIfActive()
};
goog.editor.Field.prototype.dispatchFocusAndBeforeFocus_ = function () {
	this.dispatchBeforeFocus_();
	this.dispatchFocus_()
};
goog.editor.Field.prototype.dispatchBeforeFocus_ = function () {
	this.isEventStopped(goog.editor.Field.EventType.BEFOREFOCUS) || (this.execCommand(goog.editor.Command.CLEAR_LOREM, !0), this.dispatchEvent(goog.editor.Field.EventType.BEFOREFOCUS))
};
goog.editor.Field.prototype.dispatchFocus_ = function () {
	if (!this.isEventStopped(goog.editor.Field.EventType.FOCUS)) {
		goog.editor.Field.setActiveFieldId(this.id);
		this.isSelectionEditable_ = !0;
		this.dispatchEvent(goog.editor.Field.EventType.FOCUS);
		if (goog.editor.BrowserFeature.PUTS_CURSOR_BEFORE_FIRST_BLOCK_ELEMENT_ON_FOCUS) {
			var a = this.getElement(),
				b = this.getRange();
			if (b) {
				var c = b.getFocusNode();
				0 == b.getFocusOffset() && (!c || c == a || c.tagName == goog.dom.TagName.BODY) && goog.editor.range.selectNodeStart(a)
			}
		}!goog.editor.BrowserFeature.CLEARS_SELECTION_WHEN_FOCUS_LEAVES &&
			this.usesIframe() && this.getEditableDomHelper().getWindow().parent.getSelection().removeAllRanges()
	}
};
goog.editor.Field.prototype.dispatchBlur = function () {
	this.isEventStopped(goog.editor.Field.EventType.BLUR) || (goog.editor.Field.getActiveFieldId() == this.id && goog.editor.Field.setActiveFieldId(null), this.isSelectionEditable_ = !1, this.dispatchEvent(goog.editor.Field.EventType.BLUR))
};
goog.editor.Field.prototype.isSelectionEditable = function () {
	return this.isSelectionEditable_
};
goog.editor.Field.cancelLinkClick_ = function (a) {
	goog.dom.getAncestorByTagNameAndClass(a.target, goog.dom.TagName.A) && a.preventDefault()
};
goog.editor.Field.prototype.handleMouseDown_ = function (a) {
	goog.editor.Field.getActiveFieldId() || goog.editor.Field.setActiveFieldId(this.id);
	if (goog.userAgent.IE) {
		var b = a.target;
		b && (b.tagName == goog.dom.TagName.A && a.ctrlKey) && this.originalDomHelper.getWindow().open(b.href)
	}
};
goog.editor.Field.prototype.handleMouseUp_ = function (a) {
	this.dispatchSelectionChangeEvent(a);
	goog.userAgent.IE && (this.selectionChangeTarget_ = a.target, this.selectionChangeTimer_.start())
};
goog.editor.Field.prototype.getCleanContents = function () {
	if (this.queryCommandValue(goog.editor.Command.USING_LOREM)) return goog.string.Unicode.NBSP;
	if (!this.isLoaded()) {
		var a = this.getOriginalElement();
		a || this.logger.shout("Couldn't get the field element to read the contents");
		return a.innerHTML
	}
	a = this.getFieldCopy();
	this.invokeOp_(goog.editor.Plugin.Op.CLEAN_CONTENTS_DOM, a);
	return this.reduceOp_(goog.editor.Plugin.Op.CLEAN_CONTENTS_HTML, a.innerHTML)
};
goog.editor.Field.prototype.getFieldCopy = function () {
	var a = this.getElement(),
		b = a.cloneNode(!1),
		a = a.innerHTML;
	goog.userAgent.IE && a.match(/^\s*<script/i) && (a = goog.string.Unicode.NBSP + a);
	b.innerHTML = a;
	return b
};
goog.editor.Field.prototype.setHtml = function (a, b, c, d) {
	this.isLoading() ? this.logger.severe("Can't set html while loading Trogedit") : (d && this.execCommand(goog.editor.Command.CLEAR_LOREM), b && a && (b = "<p>" + b + "</p>"), c && this.stopChangeEvents(!1, !0), this.setInnerHtml_(b), d && this.execCommand(goog.editor.Command.UPDATE_LOREM), this.isLoaded() && (c ? (goog.editor.BrowserFeature.USE_MUTATION_EVENTS && this.changeTimerGecko_.fireIfActive(), this.startChangeEvents()) : this.dispatchChange()))
};
goog.editor.Field.prototype.setInnerHtml_ = function (a) {
	var b = this.getElement();
	if (b) {
		if (this.usesIframe() && goog.editor.BrowserFeature.MOVES_STYLE_TO_HEAD)
			for (var c = b.ownerDocument.getElementsByTagName("HEAD"), d = c.length - 1; 1 <= d; --d) c[d].parentNode.removeChild(c[d])
	} else b = this.getOriginalElement();
	b && this.injectContents(a, b)
};
goog.editor.Field.prototype.turnOnDesignModeGecko = function () {
	var a = this.getEditableDomHelper().getDocument();
	a.designMode = "on";
	goog.editor.BrowserFeature.HAS_STYLE_WITH_CSS && a.execCommand("styleWithCSS", !1, !1)
};
goog.editor.Field.prototype.installStyles = function () {
	this.cssStyles && this.shouldLoadAsynchronously() && goog.style.installStyles(this.cssStyles, this.getElement())
};
goog.editor.Field.prototype.dispatchLoadEvent_ = function () {
	var a = this.getElement();
	this.workaroundClassName_ && goog.dom.classes.add(a, this.workaroundClassName_);
	this.installStyles();
	this.startChangeEvents();
	this.logger.info("Dispatching load " + this.id);
	this.dispatchEvent(goog.editor.Field.EventType.LOAD)
};
goog.editor.Field.prototype.isUneditable = function () {
	return this.loadState_ == goog.editor.Field.LoadState_.UNEDITABLE
};
goog.editor.Field.prototype.isLoaded = function () {
	return this.loadState_ == goog.editor.Field.LoadState_.EDITABLE
};
goog.editor.Field.prototype.isLoading = function () {
	return this.loadState_ == goog.editor.Field.LoadState_.LOADING
};
goog.editor.Field.prototype.focus = function () {
	if (!goog.editor.BrowserFeature.HAS_CONTENT_EDITABLE || goog.userAgent.WEBKIT) this.getEditableDomHelper().getWindow().focus();
	else {
		if (goog.userAgent.OPERA) var a = this.appWindow_.pageXOffset,
		b = this.appWindow_.pageYOffset;
		var c = this.getElement();
		!goog.editor.BrowserFeature.FOCUSES_EDITABLE_BODY_ON_HTML_CLICK && c.parentNode.contentEditable && (c = c.parentNode);
		c.focus();
		goog.userAgent.OPERA && this.appWindow_.scrollTo(a, b)
	}
};
goog.editor.Field.prototype.focusAndPlaceCursorAtStart = function () {
	(goog.editor.BrowserFeature.HAS_IE_RANGES || goog.userAgent.WEBKIT) && this.placeCursorAtStart();
	this.focus()
};
goog.editor.Field.prototype.placeCursorAtStart = function () {
	var a = this.getElement();
	if (a) {
		var b = goog.editor.node.getLeftMostLeaf(a);
		a == b ? goog.dom.Range.createCaret(a, 0).select() : goog.editor.range.placeCursorNextTo(b, !0);
		this.dispatchSelectionChangeEvent()
	}
};
goog.editor.Field.prototype.makeEditable = function (a) {
	this.loadState_ = goog.editor.Field.LoadState_.LOADING;
	var b = this.getOriginalElement();
	this.nodeName = b.nodeName;
	this.savedClassName_ = b.className;
	this.setInitialStyle(b.style.cssText);
	b.className += " editable";
	this.makeEditableInternal(a)
};
goog.editor.Field.prototype.makeEditableInternal = function (a) {
	this.makeIframeField_(a)
};
goog.editor.Field.prototype.handleFieldLoad = function () {
	goog.userAgent.IE && goog.dom.Range.clearSelection(this.editableDomHelper.getWindow());
	goog.editor.Field.getActiveFieldId() != this.id && this.execCommand(goog.editor.Command.UPDATE_LOREM);
	this.setupChangeListeners_();
	this.dispatchLoadEvent_();
	for (var a in this.plugins_) this.plugins_[a].enable(this)
};
goog.editor.Field.prototype.makeUneditable = function (a) {
	if (this.isUneditable()) throw Error("makeUneditable: Field is already uneditable");
	this.clearDelayedChange();
	this.selectionChangeTimer_.fireIfActive();
	this.execCommand(goog.editor.Command.CLEAR_LOREM);
	var b = null;
	!a && this.getElement() && (b = this.getCleanContents());
	this.clearFieldLoadListener_();
	a = this.getOriginalElement();
	goog.editor.Field.getActiveFieldId() == a.id && goog.editor.Field.setActiveFieldId(null);
	this.clearListeners_();
	goog.isString(b) &&
		(a.innerHTML = b, this.resetOriginalElemProperties());
	this.restoreDom();
	this.tearDownFieldObject_();
	goog.userAgent.WEBKIT && a.blur();
	this.execCommand(goog.editor.Command.UPDATE_LOREM);
	this.dispatchEvent(goog.editor.Field.EventType.UNLOAD)
};
goog.editor.Field.prototype.restoreDom = function () {
	var a = this.getOriginalElement();
	if (a) {
		var b = this.getEditableIframe();
		b && goog.dom.replaceNode(a, b)
	}
};
goog.editor.Field.prototype.shouldLoadAsynchronously = function () {
	if (!goog.isDef(this.isHttps_) && (this.isHttps_ = !1, goog.userAgent.IE && this.usesIframe())) {
		for (var a = this.originalDomHelper.getWindow(); a != a.parent;) try {
			a = a.parent
		} catch (b) {
			break
		}
		a = a.location;
		this.isHttps_ = "https:" == a.protocol && -1 == a.search.indexOf("nocheckhttps")
	}
	return this.isHttps_
};
goog.editor.Field.prototype.makeIframeField_ = function (a) {
	var b = this.getOriginalElement();
	if (b) {
		var b = b.innerHTML,
			c = {}, b = this.reduceOp_(goog.editor.Plugin.Op.PREPARE_CONTENTS_HTML, b, c),
			d = this.originalDomHelper.createDom(goog.dom.TagName.IFRAME, this.getIframeAttributes());
		if (this.shouldLoadAsynchronously()) {
			var e = goog.bind(this.iframeFieldLoadHandler, this, d, b, c);
			this.fieldLoadListenerKey_ = goog.events.listen(d, goog.events.EventType.LOAD, e, !0);
			a && (d.src = a)
		}
		this.attachIframe(d);
		this.shouldLoadAsynchronously() ||
			this.iframeFieldLoadHandler(d, b, c)
	}
};
goog.editor.Field.prototype.attachIframe = function (a) {
	var b = this.getOriginalElement();
	a.className = b.className;
	a.id = b.id;
	goog.dom.replaceNode(a, b)
};
goog.editor.Field.prototype.getFieldFormatInfo = function (a) {
	var b = this.getOriginalElement(),
		b = goog.editor.node.isStandardsMode(b);
	return new goog.editor.icontent.FieldFormatInfo(this.id, b, !1, !1, a)
};
goog.editor.Field.prototype.writeIframeContent = function (a, b, c) {
	c = this.getFieldFormatInfo(c);
	if (this.shouldLoadAsynchronously()) a = goog.dom.getFrameContentDocument(a), goog.editor.icontent.writeHttpsInitialIframe(c, a, b);
	else {
		var d = new goog.editor.icontent.FieldStyleInfo(this.getElement(), this.cssStyles);
		goog.editor.icontent.writeNormalInitialIframe(c, b, d, a)
	}
};
goog.editor.Field.prototype.iframeFieldLoadHandler = function (a, b, c) {
	this.clearFieldLoadListener_();
	a.allowTransparency = "true";
	this.writeIframeContent(a, b, c);
	this.setupFieldObject(goog.dom.getFrameContentDocument(a).body);
	goog.editor.BrowserFeature.HAS_CONTENT_EDITABLE || this.turnOnDesignModeGecko();
	this.handleFieldLoad()
};
goog.editor.Field.prototype.clearFieldLoadListener_ = function () {
	this.fieldLoadListenerKey_ && (goog.events.unlistenByKey(this.fieldLoadListenerKey_), this.fieldLoadListenerKey_ = null)
};
goog.editor.Field.prototype.getIframeAttributes = function () {
	var a = "padding:0;" + this.getOriginalElement().style.cssText;
	goog.string.endsWith(a, ";") || (a += ";");
	a += "background-color:white;";
	goog.userAgent.IE && (a += "overflow:visible;");
	return {
		frameBorder: 0,
		style: a
	}
};
goog.editor.plugins.Blockquote = function (a, b) {
	goog.editor.Plugin.call(this);
	this.requiresClassNameToSplit_ = a;
	this.className_ = b || "tr_bq"
};
goog.inherits(goog.editor.plugins.Blockquote, goog.editor.Plugin);
goog.editor.plugins.Blockquote.SPLIT_COMMAND = "+splitBlockquote";
goog.editor.plugins.Blockquote.CLASS_ID = "Blockquote";
goog.editor.plugins.Blockquote.prototype.logger = goog.debug.Logger.getLogger("goog.editor.plugins.Blockquote");
goog.editor.plugins.Blockquote.prototype.getTrogClassId = function () {
	return goog.editor.plugins.Blockquote.CLASS_ID
};
goog.editor.plugins.Blockquote.prototype.isSilentCommand = goog.functions.TRUE;
goog.editor.plugins.Blockquote.isBlockquote = function (a, b, c, d) {
	if (a.tagName != goog.dom.TagName.BLOCKQUOTE) return !1;
	if (!c) return b;
	a = goog.dom.classes.has(a, d);
	return b ? a : !a
};
goog.editor.plugins.Blockquote.findAndRemoveSingleChildAncestor_ = function (a, b) {
	var c = goog.editor.node.findHighestMatchingAncestor(a, function (a) {
		return a != b && 1 == a.childNodes.length
	});
	c || (c = a);
	goog.dom.removeNode(c)
};
goog.editor.plugins.Blockquote.removeAllWhiteSpaceNodes_ = function (a) {
	for (var b = 0; b < a.length; ++b) goog.editor.node.isEmpty(a[b], !0) && goog.dom.removeNode(a[b])
};
goog.editor.plugins.Blockquote.prototype.isSetupBlockquote = function (a) {
	return goog.editor.plugins.Blockquote.isBlockquote(a, !0, this.requiresClassNameToSplit_, this.className_)
};
goog.editor.plugins.Blockquote.prototype.isSupportedCommand = function (a) {
	return a == goog.editor.plugins.Blockquote.SPLIT_COMMAND
};
goog.editor.plugins.Blockquote.prototype.execCommandInternal = function (a, b) {
	if (a == goog.editor.plugins.Blockquote.SPLIT_COMMAND && b && (this.className_ || !this.requiresClassNameToSplit_)) return goog.editor.BrowserFeature.HAS_W3C_RANGES ? this.splitQuotedBlockW3C_(b) : this.splitQuotedBlockIE_(b)
};
goog.editor.plugins.Blockquote.prototype.splitQuotedBlockW3C_ = function (a) {
	var b = a.node,
		c = goog.editor.node.findTopMostEditableAncestor(b.parentNode, goog.bind(this.isSetupBlockquote, this)),
		d, e, f = !1;
	c ? b.nodeType == goog.dom.NodeType.TEXT ? a.offset == b.length ? (d = b.nextSibling) && d.tagName == goog.dom.TagName.BR ? (b = d, d = d.nextSibling) : d = e = b.splitText(a.offset) : d = b.splitText(a.offset) : b.tagName == goog.dom.TagName.BR ? d = b.nextSibling : f = !0 : this.isSetupBlockquote(b) && (c = b, f = !0);
	f && (b = this.insertEmptyTextNodeBeforeRange_(),
		d = this.insertEmptyTextNodeBeforeRange_());
	if (!c) return !1;
	d = goog.editor.node.splitDomTreeAt(b, d, c);
	goog.dom.insertSiblingAfter(d, c);
	a = this.getFieldDomHelper();
	b = this.fieldObject.queryCommandValue(goog.editor.Command.DEFAULT_TAG) || goog.dom.TagName.DIV;
	b = a.createElement(b);
	b.innerHTML = "&nbsp;";
	c.parentNode.insertBefore(b, d);
	a.getWindow().getSelection().collapse(b, 0);
	e && goog.editor.plugins.Blockquote.findAndRemoveSingleChildAncestor_(e, d);
	goog.editor.plugins.Blockquote.removeAllWhiteSpaceNodes_([c, d]);
	return !0
};
goog.editor.plugins.Blockquote.prototype.insertEmptyTextNodeBeforeRange_ = function () {
	var a = this.fieldObject.getRange(),
		b = this.getFieldDomHelper().createTextNode("");
	a.insertNode(b, !0);
	return b
};
goog.editor.plugins.Blockquote.prototype.splitQuotedBlockIE_ = function (a) {
	var b = this.getFieldDomHelper(),
		c = goog.editor.node.findTopMostEditableAncestor(a.parentNode, goog.bind(this.isSetupBlockquote, this));
	if (!c) return !1;
	var d = a.cloneNode(!1);
	a.nextSibling && a.nextSibling.tagName == goog.dom.TagName.BR && (a = a.nextSibling);
	var e = goog.editor.node.splitDomTreeAt(a, d, c);
	goog.dom.insertSiblingAfter(e, c);
	var f = this.fieldObject.queryCommandValue(goog.editor.Command.DEFAULT_TAG) || goog.dom.TagName.DIV,
		f = b.createElement(f);
	c.parentNode.insertBefore(f, e);
	f.innerHTML = "&nbsp;";
	b = b.getDocument().selection.createRange();
	b.moveToElementText(a);
	b.move("character", 2);
	b.select();
	f.innerHTML = "";
	b.pasteHTML("");
	goog.editor.plugins.Blockquote.findAndRemoveSingleChildAncestor_(d, e);
	goog.editor.plugins.Blockquote.removeAllWhiteSpaceNodes_([c, e]);
	return !0
};
goog.editor.plugins.AbstractTabHandler = function () {
	goog.editor.Plugin.call(this)
};
goog.inherits(goog.editor.plugins.AbstractTabHandler, goog.editor.Plugin);
goog.editor.plugins.AbstractTabHandler.prototype.handleKeyboardShortcut = function (a) {
	return goog.userAgent.GECKO && this.fieldObject.inModalMode() ? !1 : a.keyCode == goog.events.KeyCodes.TAB && !a.metaKey && !a.ctrlKey ? this.handleTabKey(a) : !1
};
goog.editor.plugins.ListTabHandler = function () {
	goog.editor.plugins.AbstractTabHandler.call(this)
};
goog.inherits(goog.editor.plugins.ListTabHandler, goog.editor.plugins.AbstractTabHandler);
goog.editor.plugins.ListTabHandler.prototype.getTrogClassId = function () {
	return "ListTabHandler"
};
goog.editor.plugins.ListTabHandler.prototype.handleTabKey = function (a) {
	var b = this.fieldObject.getRange();
	return goog.dom.getAncestorByTagNameAndClass(b.getContainerElement(), goog.dom.TagName.LI) || goog.iter.some(b, function (a) {
		return a.tagName == goog.dom.TagName.LI
	}) ? (this.fieldObject.execCommand(a.shiftKey ? goog.editor.Command.OUTDENT : goog.editor.Command.INDENT), a.preventDefault(), !0) : !1
};
goog.dom.NodeOffset = function (a, b) {
	this.offsetStack_ = [];
	for (this.nameStack_ = []; a && a.nodeName != goog.dom.TagName.BODY && a != b;) {
		for (var c = 0, d = a.previousSibling; d;) d = d.previousSibling, ++c;
		this.offsetStack_.unshift(c);
		this.nameStack_.unshift(a.nodeName);
		a = a.parentNode
	}
};
goog.inherits(goog.dom.NodeOffset, goog.Disposable);
goog.dom.NodeOffset.prototype.toString = function () {
	for (var a = [], b, c = 0; b = this.nameStack_[c]; c++) a.push(this.offsetStack_[c] + "," + b);
	return a.join("\n")
};
goog.dom.NodeOffset.prototype.findTargetNode = function (a) {
	for (var b = a, c = 0; a = this.nameStack_[c]; ++c)
		if (b = b.childNodes[this.offsetStack_[c]], !b || b.nodeName != a) return null;
	return b
};
goog.dom.NodeOffset.prototype.disposeInternal = function () {
	delete this.offsetStack_;
	delete this.nameStack_
};
goog.editor.plugins.EnterHandler = function () {
	goog.editor.Plugin.call(this)
};
goog.inherits(goog.editor.plugins.EnterHandler, goog.editor.Plugin);
goog.editor.plugins.EnterHandler.prototype.getTrogClassId = function () {
	return "EnterHandler"
};
goog.editor.plugins.EnterHandler.prototype.prepareContentsHtml = function (a) {
	return !a || goog.string.isBreakingWhitespace(a) ? goog.editor.BrowserFeature.COLLAPSES_EMPTY_NODES ? this.getNonCollapsingBlankHtml() : "" : a
};
goog.editor.plugins.EnterHandler.prototype.getNonCollapsingBlankHtml = goog.functions.constant("<br>");
goog.editor.plugins.EnterHandler.prototype.handleBackspaceInternal = function (a, b) {
	var c = this.fieldObject.getElement(),
		d = b && b.getStartNode();
	c.firstChild == d && goog.editor.node.isEmpty(d) && (a.preventDefault(), a.stopPropagation())
};
goog.editor.plugins.EnterHandler.prototype.processParagraphTagsInternal = function (a, b) {
	if (goog.userAgent.IE || goog.userAgent.OPERA) this.ensureBlockIeOpera(goog.dom.TagName.DIV);
	else if (!b && goog.userAgent.WEBKIT) {
		var c = this.fieldObject.getRange();
		if (c && goog.editor.plugins.EnterHandler.isDirectlyInBlockquote(c.getContainerElement())) {
			var d = this.getFieldDomHelper(),
				e = d.createElement(goog.dom.TagName.BR);
			c.insertNode(e, !0);
			goog.editor.node.isBlockTag(e.parentNode) && !goog.editor.node.skipEmptyTextNodes(e.nextSibling) &&
				goog.dom.insertSiblingBefore(d.createElement(goog.dom.TagName.BR), e);
			goog.editor.range.placeCursorNextTo(e, !1);
			a.preventDefault()
		}
	}
};
goog.editor.plugins.EnterHandler.isDirectlyInBlockquote = function (a) {
	for (; a; a = a.parentNode)
		if (goog.editor.node.isBlockTag(a)) return a.tagName == goog.dom.TagName.BLOCKQUOTE;
	return !1
};
goog.editor.plugins.EnterHandler.prototype.handleDeleteGecko = function (a) {
	this.deleteBrGecko(a)
};
goog.editor.plugins.EnterHandler.prototype.deleteBrGecko = function (a) {
	var b = this.fieldObject.getRange();
	if (b.isCollapsed()) {
		var c = b.getEndNode();
		if (c.nodeType == goog.dom.NodeType.ELEMENT && (b = c.childNodes[b.getEndOffset()]) && b.tagName == goog.dom.TagName.BR) {
			var d = goog.editor.node.getPreviousSibling(b),
				e = b.nextSibling;
			c.removeChild(b);
			a.preventDefault();
			e && goog.editor.node.isBlockTag(e) && (d && !(d.tagName == goog.dom.TagName.BR || goog.editor.node.isBlockTag(d)) ? goog.dom.Range.createCaret(d, goog.editor.node.getLength(d)).select() :
				(a = goog.editor.node.getLeftMostLeaf(e), goog.dom.Range.createCaret(a, 0).select()))
		}
	}
};
goog.editor.plugins.EnterHandler.prototype.handleKeyPress = function (a) {
	if (goog.userAgent.GECKO && this.fieldObject.inModalMode()) return !1;
	if (a.keyCode == goog.events.KeyCodes.BACKSPACE) this.handleBackspaceInternal(a, this.fieldObject.getRange());
	else if (a.keyCode == goog.events.KeyCodes.ENTER)
		if (goog.userAgent.GECKO) a.shiftKey || this.handleEnterGecko_(a);
		else {
			this.fieldObject.dispatchBeforeChange();
			var b = this.deleteCursorSelection_(),
				c = !! this.fieldObject.execCommand(goog.editor.plugins.Blockquote.SPLIT_COMMAND,
					b);
			c && (a.preventDefault(), a.stopPropagation());
			this.releasePositionObject_(b);
			goog.userAgent.WEBKIT && this.handleEnterWebkitInternal(a);
			this.processParagraphTagsInternal(a, c);
			this.fieldObject.dispatchChange()
		} else goog.userAgent.GECKO && a.keyCode == goog.events.KeyCodes.DELETE && this.handleDeleteGecko(a);
	return !1
};
goog.editor.plugins.EnterHandler.prototype.handleKeyUp = function (a) {
	if (goog.userAgent.GECKO && this.fieldObject.inModalMode()) return !1;
	this.handleKeyUpInternal(a);
	return !1
};
goog.editor.plugins.EnterHandler.prototype.handleKeyUpInternal = function (a) {
	(goog.userAgent.IE || goog.userAgent.OPERA) && a.keyCode == goog.events.KeyCodes.ENTER && this.ensureBlockIeOpera(goog.dom.TagName.DIV, !0)
};
goog.editor.plugins.EnterHandler.prototype.handleEnterGecko_ = function (a) {
	var b = this.fieldObject.getRange(),
		c = !b || b.isCollapsed(),
		d = this.deleteCursorSelection_(),
		e = this.fieldObject.execCommand(goog.editor.plugins.Blockquote.SPLIT_COMMAND, d);
	e && (a.preventDefault(), a.stopPropagation());
	this.releasePositionObject_(d);
	e || this.handleEnterAtCursorGeckoInternal(a, c, b)
};
goog.editor.plugins.EnterHandler.prototype.handleEnterWebkitInternal = goog.nullFunction;
goog.editor.plugins.EnterHandler.prototype.handleEnterAtCursorGeckoInternal = goog.nullFunction;
goog.editor.plugins.EnterHandler.DO_NOT_ENSURE_BLOCK_NODES_ = goog.object.createSet(goog.dom.TagName.LI, goog.dom.TagName.DIV, goog.dom.TagName.H1, goog.dom.TagName.H2, goog.dom.TagName.H3, goog.dom.TagName.H4, goog.dom.TagName.H5, goog.dom.TagName.H6);
goog.editor.plugins.EnterHandler.isBrElem = function (a) {
	return goog.editor.node.isEmpty(a) && 1 == a.getElementsByTagName(goog.dom.TagName.BR).length
};
goog.editor.plugins.EnterHandler.prototype.ensureBlockIeOpera = function (a, b) {
	for (var c = this.fieldObject.getRange(), d = c.getContainer(), e = this.fieldObject.getElement(), f; d && d != e;) {
		var g = d.nodeName;
		if (g == a || goog.editor.plugins.EnterHandler.DO_NOT_ENSURE_BLOCK_NODES_[g] && (!b || !goog.editor.plugins.EnterHandler.isBrElem(d))) {
			if (goog.userAgent.OPERA && f) {
				g == a && (f == d.lastChild && goog.editor.node.isEmpty(f)) && (goog.dom.insertSiblingAfter(f, d), goog.dom.Range.createFromNodeContents(f).select());
				break
			}
			return
		}
		goog.userAgent.OPERA &&
			(b && g == goog.dom.TagName.P && g != a) && (f = d);
		d = d.parentNode
	}
	if (goog.userAgent.IE) {
		var h = !1,
			c = c.getBrowserRangeObject(),
			d = c.duplicate();
		d.moveEnd("character", 1);
		if (d.text.length && (h = d.parentElement(), d = d.duplicate(), d.collapse(!1), d = d.parentElement(), h = h != d && d != c.parentElement())) c.move("character", -1), c.select()
	}
	this.fieldObject.getEditableDomHelper().getDocument().execCommand("FormatBlock", !1, "<" + a + ">");
	h && (c.move("character", 1), c.select())
};
goog.editor.plugins.EnterHandler.prototype.deleteCursorSelection_ = function () {
	return goog.editor.BrowserFeature.HAS_W3C_RANGES ? this.deleteCursorSelectionW3C_() : this.deleteCursorSelectionIE_()
};
goog.editor.plugins.EnterHandler.prototype.releasePositionObject_ = function (a) {
	goog.editor.BrowserFeature.HAS_W3C_RANGES || a.removeNode(!0)
};
goog.editor.plugins.EnterHandler.prototype.deleteCursorSelectionIE_ = function () {
	var a = this.getFieldDomHelper().getDocument(),
		b = a.selection.createRange(),
		c = goog.string.createUniqueString();
	b.pasteHTML('<span id="' + c + '"></span>');
	a = a.getElementById(c);
	a.id = "";
	return a
};
goog.editor.plugins.EnterHandler.prototype.deleteCursorSelectionW3C_ = function () {
	var a = this.fieldObject.getRange();
	if (!a.isCollapsed()) {
		var b = !0;
		if (goog.userAgent.OPERA) {
			var c = a.getStartNode(),
				d = a.getStartOffset();
			c == a.getEndNode() && (c.lastChild && c.lastChild.tagName == goog.dom.TagName.BR && d == c.childNodes.length - 1) && (b = !1)
		}
		b && goog.editor.plugins.EnterHandler.deleteW3cRange_(a)
	}
	return goog.editor.range.getDeepEndPoint(a, !0)
};
goog.editor.plugins.EnterHandler.deleteW3cRange_ = function (a) {
	if (a && !a.isCollapsed()) {
		var b = !0,
			c = a.getContainerElement(),
			d = new goog.dom.NodeOffset(a.getStartNode(), c),
			e = a.getStartOffset(),
			f = goog.editor.plugins.EnterHandler.isInOneContainerW3c_(a),
			g = !f && goog.editor.plugins.EnterHandler.isPartialEndW3c_(a);
		a.removeContents();
		a = goog.dom.Range.createCaret(d.findTargetNode(c), e);
		a.select();
		f && (f = goog.editor.style.getContainer(a.getStartNode()), goog.editor.node.isEmpty(f, !0) && (b = "&nbsp;", goog.userAgent.OPERA &&
			f.tagName == goog.dom.TagName.LI && (b = "<br>"), f.innerHTML = b, goog.editor.range.selectNodeStart(f.firstChild), b = !1));
		g && (a = goog.editor.style.getContainer(a.getStartNode()), g = goog.editor.node.getNextSibling(a), a && g && (goog.dom.append(a, g.childNodes), goog.dom.removeNode(g)));
		b && (a = goog.dom.Range.createCaret(d.findTargetNode(c), e), a.select())
	}
};
goog.editor.plugins.EnterHandler.isInOneContainerW3c_ = function (a) {
	var b = a.getStartNode();
	goog.editor.style.isContainer(b) && (b = b.childNodes[a.getStartOffset()] || b);
	var b = goog.editor.style.getContainer(b),
		c = a.getEndNode();
	goog.editor.style.isContainer(c) && (c = c.childNodes[a.getEndOffset()] || c);
	c = goog.editor.style.getContainer(c);
	return b == c
};
goog.editor.plugins.EnterHandler.isPartialEndW3c_ = function (a) {
	var b = a.getEndNode(),
		a = a.getEndOffset(),
		c = b;
	if (goog.editor.style.isContainer(c)) {
		var d = c.childNodes[a];
		if (!d || d.nodeType == goog.dom.NodeType.ELEMENT && goog.editor.style.isContainer(d)) return !1
	}
	for (d = goog.editor.style.getContainer(c); d != c;) {
		if (goog.editor.node.getNextSibling(c)) return !0;
		c = c.parentNode
	}
	return a != goog.editor.node.getLength(b)
};

							
/*************************************************************************************************/
						
var fieldEditor = null;
							
function loadComposer() {
	fieldEditor = makeField("main-body", !0);
	var body = document.getElementById("main-body");
	fieldEditor.setupFieldObject(body);
	fieldEditor.dispatchLoadEvent_();
	for (var plugin in fieldEditor.plugins_) {
		fieldEditor.plugins_[plugin].enable(fieldEditor);
	}
	var scrollingBody = document.body
	document.body.style.overflow = "auto"
	body.style.minHeight = window.innerHeight - 20 + "px"
	window.onresize = function () {
		document.getElementById("main-body").style.minHeight = window.innerHeight - 20 + "px"
	}
}
							
function makeField(element) {
	element = new goog.editor.Field(element);
	element.registerPlugin(new goog.editor.plugins.EnterHandler);
	element.registerPlugin(new goog.editor.plugins.Blockquote(false));
	element.registerPlugin(new goog.editor.plugins.BasicTextFormatter);
	element.registerPlugin(new goog.editor.plugins.ListTabHandler);
	return element
}
