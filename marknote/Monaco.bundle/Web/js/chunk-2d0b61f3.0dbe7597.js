(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d0b61f3"],{

/***/ "1c8c":
/***/ (function(module, exports) {

!function(a){a.languages.flow=a.languages.extend("javascript",{}),a.languages.insertBefore("flow","keyword",{type:[{pattern:/\b(?:[Nn]umber|[Ss]tring|[Bb]oolean|Function|any|mixed|null|void)\b/,alias:"tag"}]}),a.languages.flow["function-variable"].pattern=/(?!\s)[_$a-z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*(?=\s*=\s*(?:function\b|(?:\([^()]*\)(?:\s*:\s*\w+)?|(?!\s)[_$a-z\xA0-\uFFFF](?:(?!\s)[$\w\xA0-\uFFFF])*)\s*=>))/i,delete a.languages.flow.parameter,a.languages.insertBefore("flow","operator",{"flow-punctuation":{pattern:/\{\||\|\}/,alias:"punctuation"}}),Array.isArray(a.languages.flow.keyword)||(a.languages.flow.keyword=[a.languages.flow.keyword]),a.languages.flow.keyword.unshift({pattern:/(^|[^$]\b)(?:type|opaque|declare|Class)\b(?!\$)/,lookbehind:!0},{pattern:/(^|[^$]\B)\$(?:await|Diff|Exact|Keys|ObjMap|PropertyType|Shape|Record|Supertype|Subtype|Enum)\b(?!\$)/,lookbehind:!0})}(Prism);

/***/ })

}]);
//# sourceMappingURL=chunk-2d0b61f3.0dbe7597.js.map