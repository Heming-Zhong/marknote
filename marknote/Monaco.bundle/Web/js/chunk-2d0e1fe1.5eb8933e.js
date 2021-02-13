(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d0e1fe1"],{

/***/ "7d97":
/***/ (function(module, exports) {

!function(e){e.languages.etlua={delimiter:{pattern:/^<%[-=]?|-?%>$/,alias:"punctuation"},"language-lua":{pattern:/[\s\S]+/,inside:e.languages.lua}},e.hooks.add("before-tokenize",function(a){e.languages["markup-templating"].buildPlaceholders(a,"etlua",/<%[\s\S]+?%>/g)}),e.hooks.add("after-tokenize",function(a){e.languages["markup-templating"].tokenizePlaceholders(a,"etlua")})}(Prism);

/***/ })

}]);
//# sourceMappingURL=chunk-2d0e1fe1.5eb8933e.js.map