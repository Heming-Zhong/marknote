(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d0b37df"],{

/***/ "2935":
/***/ (function(module, exports) {

Prism.languages.scala = Prism.languages.extend('java', {
	'triple-quoted-string': {
		pattern: /"""[\s\S]*?"""/,
		greedy: true,
		alias: 'string'
	},
	'string': {
		pattern: /("|')(?:\\.|(?!\1)[^\\\r\n])*\1/,
		greedy: true
	},
	'keyword': /<-|=>|\b(?:abstract|case|catch|class|def|do|else|extends|final|finally|for|forSome|if|implicit|import|lazy|match|new|null|object|override|package|private|protected|return|sealed|self|super|this|throw|trait|try|type|val|var|while|with|yield)\b/,
	'number': /\b0x(?:[\da-f]*\.)?[\da-f]+|(?:\b\d+(?:\.\d*)?|\B\.\d+)(?:e\d+)?[dfl]?/i,
	'builtin': /\b(?:String|Int|Long|Short|Byte|Boolean|Double|Float|Char|Any|AnyRef|AnyVal|Unit|Nothing)\b/,
	'symbol': /'[^\d\s\\]\w*/
});
delete Prism.languages.scala['class-name'];
delete Prism.languages.scala['function'];


/***/ })

}]);
//# sourceMappingURL=chunk-2d0b37df.875cfa1b.js.map