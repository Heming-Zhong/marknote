(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d0b6185"],{

/***/ "1c63":
/***/ (function(module, exports) {

// Django/Jinja2 syntax definition for Prism.js <http://prismjs.com> syntax highlighter.
// Mostly it works OK but can paint code incorrectly on complex html/template tag combinations.

(function (Prism) {

	Prism.languages.django = {
		'comment': /^{#[\s\S]*?#}$/,
		'tag': {
			pattern: /(^{%[+-]?\s*)\w+/,
			lookbehind: true,
			alias: 'keyword'
		},
		'delimiter': {
			pattern: /^{[{%][+-]?|[+-]?[}%]}$/,
			alias: 'punctuation'
		},
		'string': {
			pattern: /("|')(?:\\.|(?!\1)[^\\\r\n])*\1/,
			greedy: true
		},
		'filter': {
			pattern: /(\|)\w+/,
			lookbehind: true,
			alias: 'function'
		},
		'test': {
			pattern: /(\bis\s+(?:not\s+)?)(?!not\b)\w+/,
			lookbehind: true,
			alias: 'function'
		},
		'function': /\b[a-z_]\w+(?=\s*\()/i,
		'keyword': /\b(?:and|as|by|else|for|if|import|in|is|loop|not|or|recursive|with|without)\b/,
		'operator': /[-+*/%=]=?|!=|\*\*?=?|\/\/?=?|<[<=>]?|>[=>]?|[&|^~]/,
		'number': /\b\d+(?:\.\d+)?\b/,
		'boolean': /[Tt]rue|[Ff]alse|[Nn]one/,
		'variable': /\b\w+?\b/,
		'punctuation': /[{}[\](),.:;]/
	};


	var pattern = /{{[\s\S]*?}}|{%[\s\S]*?%}|{#[\s\S]*?#}/g;
	var markupTemplating = Prism.languages['markup-templating'];

	Prism.hooks.add('before-tokenize', function (env) {
		markupTemplating.buildPlaceholders(env, 'django', pattern);
	});
	Prism.hooks.add('after-tokenize', function (env) {
		markupTemplating.tokenizePlaceholders(env, 'django');
	});

	// Add an Jinja2 alias
	Prism.languages.jinja2 = Prism.languages.django;
	Prism.hooks.add('before-tokenize', function (env) {
		markupTemplating.buildPlaceholders(env, 'jinja2', pattern);
	});
	Prism.hooks.add('after-tokenize', function (env) {
		markupTemplating.tokenizePlaceholders(env, 'jinja2');
	});

})(Prism);


/***/ })

}]);
//# sourceMappingURL=chunk-2d0b6185.8ab1aaf0.js.map