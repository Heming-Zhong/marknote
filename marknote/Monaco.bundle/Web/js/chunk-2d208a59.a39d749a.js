(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d208a59"],{

/***/ "a64b":
/***/ (function(module, exports) {

Prism.languages.bnf = {
	'string': {
		pattern: /"[^\r\n"]*"|'[^\r\n']*'/
	},
	'definition': {
		pattern: /<[^<>\r\n\t]+>(?=\s*::=)/,
		alias: ['rule', 'keyword'],
		inside: {
			'punctuation': /^<|>$/
		}
	},
	'rule': {
		pattern: /<[^<>\r\n\t]+>/,
		inside: {
			'punctuation': /^<|>$/
		}
	},
	'operator': /::=|[|()[\]{}*+?]|\.{3}/
};

Prism.languages.rbnf = Prism.languages.bnf;


/***/ })

}]);
//# sourceMappingURL=chunk-2d208a59.a39d749a.js.map