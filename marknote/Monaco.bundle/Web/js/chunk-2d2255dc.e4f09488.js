(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d2255dc"],{

/***/ "e3a9":
/***/ (function(module, exports) {

!function(e){e.languages.ejs={delimiter:{pattern:/^<%[-_=]?|[-_]?%>$/,alias:"punctuation"},comment:/^#[\s\S]*/,"language-javascript":{pattern:/[\s\S]+/,inside:e.languages.javascript}},e.hooks.add("before-tokenize",function(a){e.languages["markup-templating"].buildPlaceholders(a,"ejs",/<%(?!%)[\s\S]+?%>/g)}),e.hooks.add("after-tokenize",function(a){e.languages["markup-templating"].tokenizePlaceholders(a,"ejs")}),e.languages.eta=e.languages.ejs}(Prism);

/***/ })

}]);
//# sourceMappingURL=chunk-2d2255dc.e4f09488.js.map