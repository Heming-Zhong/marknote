(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d0c86b6"],{

/***/ "5599":
/***/ (function(module, exports) {

Prism.languages.insertBefore('php', 'variable', {
	'this': /\$this\b/,
	'global': /\$(?:_(?:SERVER|GET|POST|FILES|REQUEST|SESSION|ENV|COOKIE)|GLOBALS|HTTP_RAW_POST_DATA|argc|argv|php_errormsg|http_response_header)\b/,
	'scope': {
		pattern: /\b[\w\\]+::/,
		inside: {
			keyword: /static|self|parent/,
			punctuation: /::|\\/
		}
	}
});

/***/ })

}]);
//# sourceMappingURL=chunk-2d0c86b6.6e14c9e0.js.map