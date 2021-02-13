(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d2080f8"],{

/***/ "a2d5":
/***/ (function(module, exports) {

Prism.languages.dart = Prism.languages.extend('clike', {
	'string': [
		{
			pattern: /r?("""|''')[\s\S]*?\1/,
			greedy: true
		},
		{
			pattern: /r?("|')(?:\\.|(?!\1)[^\\\r\n])*\1/,
			greedy: true
		}
	],
	'keyword': [
		/\b(?:async|sync|yield)\*/,
		/\b(?:abstract|assert|async|await|break|case|catch|class|const|continue|covariant|default|deferred|do|dynamic|else|enum|export|extension|external|extends|factory|final|finally|for|Function|get|hide|if|implements|interface|import|in|library|mixin|new|null|on|operator|part|rethrow|return|set|show|static|super|switch|sync|this|throw|try|typedef|var|void|while|with|yield)\b/
	],
	'operator': /\bis!|\b(?:as|is)\b|\+\+|--|&&|\|\||<<=?|>>=?|~(?:\/=?)?|[+\-*\/%&^|=!<>]=?|\?/
});

Prism.languages.insertBefore('dart','function',{
	'metadata': {
		pattern: /@\w+/,
		alias: 'symbol'
	}
});


/***/ })

}]);
//# sourceMappingURL=chunk-2d2080f8.026c00f7.js.map