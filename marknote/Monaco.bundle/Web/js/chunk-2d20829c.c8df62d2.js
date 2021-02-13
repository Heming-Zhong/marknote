(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d20829c"],{

/***/ "a42e":
/***/ (function(module, exports) {

(function (Prism) {

	var typeExpression = /(?:\b[a-zA-Z]\w*|[|\\[\]])+/.source;

	Prism.languages.phpdoc = Prism.languages.extend('javadoclike', {
		'parameter': {
			pattern: RegExp('(@(?:global|param|property(?:-read|-write)?|var)\\s+(?:' + typeExpression + '\\s+)?)\\$\\w+'),
			lookbehind: true
		}
	});

	Prism.languages.insertBefore('phpdoc', 'keyword', {
		'class-name': [
			{
				pattern: RegExp('(@(?:global|package|param|property(?:-read|-write)?|return|subpackage|throws|var)\\s+)' + typeExpression),
				lookbehind: true,
				inside: {
					'keyword': /\b(?:callback|resource|boolean|integer|double|object|string|array|false|float|mixed|bool|null|self|true|void|int)\b/,
					'punctuation': /[|\\[\]()]/
				}
			}
		],
	});

	Prism.languages.javadoclike.addSupport('php', Prism.languages.phpdoc);

}(Prism));


/***/ })

}]);
//# sourceMappingURL=chunk-2d20829c.c8df62d2.js.map