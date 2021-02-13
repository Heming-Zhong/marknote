(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d0f0da6"],{

/***/ "9daf":
/***/ (function(module, exports) {

Prism.languages.bison=Prism.languages.extend("c",{}),Prism.languages.insertBefore("bison","comment",{bison:{pattern:/^(?:[^%]|%(?!%))*%%[\s\S]*?%%/,inside:{c:{pattern:/%\{[\s\S]*?%\}|\{(?:\{[^}]*\}|[^{}])*\}/,inside:{delimiter:{pattern:/^%?\{|%?\}$/,alias:"punctuation"},"bison-variable":{pattern:/[$@](?:<[^\s>]+>)?[\w$]+/,alias:"variable",inside:{punctuation:/<|>/}},rest:Prism.languages.c}},comment:Prism.languages.c.comment,string:Prism.languages.c.string,property:/\S+(?=:)/,keyword:/%\w+/,number:{pattern:/(^|[^@])\b(?:0x[\da-f]+|\d+)/i,lookbehind:!0},punctuation:/%[%?]|[|:;\[\]<>]/}}});

/***/ })

}]);
//# sourceMappingURL=chunk-2d0f0da6.f6dd05a8.js.map