(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d0c48a4"],{

/***/ "3aee":
/***/ (function(module, exports) {

!function(n){n.languages.erb=n.languages.extend("ruby",{}),n.languages.insertBefore("erb","comment",{delimiter:{pattern:/^<%=?|%>$/,alias:"punctuation"}}),n.hooks.add("before-tokenize",function(e){n.languages["markup-templating"].buildPlaceholders(e,"erb",/<%=?(?:[^\r\n]|[\r\n](?!=begin)|[\r\n]=begin\s[\s\S]*?^=end)+?%>/gm)}),n.hooks.add("after-tokenize",function(e){n.languages["markup-templating"].tokenizePlaceholders(e,"erb")})}(Prism);

/***/ })

}]);
//# sourceMappingURL=chunk-2d0c48a4.fac040c4.js.map