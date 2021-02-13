(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d217630"],{

/***/ "c706":
/***/ (function(module, exports) {

Prism.languages.ebnf = {
	'comment': /\(\*[\s\S]*?\*\)/,
	'string': {
		pattern: /"[^"\r\n]*"|'[^'\r\n]*'/,
		greedy: true
	},
	'special': {
		pattern: /\?[^?\r\n]*\?/,
		greedy: true,
		alias: 'class-name'
	},

	'definition': {
		pattern: /^(\s*)[a-z]\w*(?:[ \t]+[a-z]\w*)*(?=\s*=)/im,
		lookbehind: true,
		alias: ['rule', 'keyword']
	},
	'rule': /\b[a-z]\w*(?:[ \t]+[a-z]\w*)*\b/i,

	'punctuation': /\([:/]|[:/]\)|[.,;()[\]{}]/,
	'operator': /[-=|*/!]/
};


/***/ })

}]);
//# sourceMappingURL=chunk-2d217630.52a2ac2e.js.map