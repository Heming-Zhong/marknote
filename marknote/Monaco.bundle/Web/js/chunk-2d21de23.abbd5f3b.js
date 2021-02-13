(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d21de23"],{

/***/ "d2cb":
/***/ (function(module, exports) {

(function (Prism) {
	Prism.languages.ignore = {
		// https://git-scm.com/docs/gitignore
		'comment': /^#.*/m,
		'entry': {
			pattern: /\S(?:.*(?:(?:\\ )|\S))?/,
			alias: 'string',
			inside: {
				'operator': /^!|\*\*?|\?/,
				'regex': {
					pattern: /(^|[^\\])\[[^\[\]]*\]/,
					lookbehind: true
				},
				'punctuation': /\//
			}
		}
	};

	Prism.languages.gitignore = Prism.languages.ignore
	Prism.languages.hgignore = Prism.languages.ignore
	Prism.languages.npmignore = Prism.languages.ignore

}(Prism));


/***/ })

}]);
//# sourceMappingURL=chunk-2d21de23.abbd5f3b.js.map