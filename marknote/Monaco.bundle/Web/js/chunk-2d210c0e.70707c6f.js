(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d210c0e"],{

/***/ "b8df":
/***/ (function(module, exports) {

Prism.languages.birb = Prism.languages.extend('clike', {
	'string': {
		pattern: /r?("|')(?:\\.|(?!\1)[^\\])*\1/,
		greedy: true
	},
	'class-name': [
		/\b[A-Z](?:[\d_]*[a-zA-Z]\w*)?\b/,

		// matches variable and function return types (parameters as well).
		/\b[A-Z]\w*(?=\s+\w+\s*[;,=()])/
	],
	'keyword': /\b(?:assert|break|case|class|const|default|else|enum|final|follows|for|grab|if|nest|next|new|noSeeb|return|static|switch|throw|var|void|while)\b/,
	'operator': /\+\+|--|&&|\|\||<<=?|>>=?|~(?:\/=?)?|[+\-*\/%&^|=!<>]=?|\?|:/,
	'variable': /\b[a-z_]\w*\b/,
});

Prism.languages.insertBefore('birb', 'function', {
	'metadata': {
		pattern: /<\w+>/,
		greedy: true,
		alias: 'symbol'
	}
});


/***/ })

}]);
//# sourceMappingURL=chunk-2d210c0e.70707c6f.js.map