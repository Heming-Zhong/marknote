(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d208e58"],{

/***/ "a76b":
/***/ (function(module, exports) {

!function(e){var a=/\{[^\r\n\[\]{}]*\}/,n={"quoted-string":{pattern:/"(?:[^"\\]|\\.)*"/,alias:"operator"},"command-param-id":{pattern:/(\s)\w+:/,lookbehind:!0,alias:"property"},"command-param-value":[{pattern:a,alias:"selector"},{pattern:/([\t ])\S+/,lookbehind:!0,greedy:!0,alias:"operator"},{pattern:/\S(?:.*\S)?/,alias:"operator"}]};function t(e){return"string"==typeof e?e:Array.isArray(e)?e.map(t).join(""):t(e.content)}e.languages.naniscript={comment:{pattern:/^([\t ]*);.*/m,lookbehind:!0},define:{pattern:/^>.+/m,alias:"tag",inside:{value:{pattern:/(^>\w+[\t ]+)(?!\s)[^{}\r\n]+/,lookbehind:!0,alias:"operator"},key:{pattern:/(^>)\w+/,lookbehind:!0}}},label:{pattern:/^([\t ]*)#[\t ]*\w+[\t ]*$/m,lookbehind:!0,alias:"regex"},command:{pattern:/^([\t ]*)@\w+(?=[\t ]|$).*/m,lookbehind:!0,alias:"function",inside:{"command-name":/^@\w+/,expression:{pattern:a,greedy:!0,alias:"selector"},"command-params":{pattern:/\s*\S[\s\S]*/,inside:n}}},"generic-text":{pattern:/(^[ \t]*)[^#@>;\s].*/m,lookbehind:!0,alias:"punctuation",inside:{"escaped-char":/\\[{}\[\]"]/,expression:{pattern:a,greedy:!0,alias:"selector"},"inline-command":{pattern:/\[[\t ]*\w[^\r\n\[\]]*\]/,greedy:!0,alias:"function",inside:{"command-params":{pattern:/(^\[[\t ]*\w+\b)[\s\S]+(?=\]$)/,lookbehind:!0,inside:n},"command-param-name":{pattern:/^(\[[\t ]*)\w+/,lookbehind:!0,alias:"name"},"start-stop-char":/[\[\]]/}}}}},e.languages.nani=e.languages.naniscript,e.hooks.add("after-tokenize",function(e){e.tokens.forEach(function(e){if("string"!=typeof e&&"generic-text"===e.type){var a=t(e);(function(e){for(var a=[],n=0;n<e.length;n++){var t=e[n],r="[]{}".indexOf(t);if(-1!==r)if(r%2==0)a.push(r+1);else if(a.pop()!==r)return!1}return 0===a.length})(a)||(e.type="bad-line",e.content=a)}})})}(Prism);

/***/ })

}]);
//# sourceMappingURL=chunk-2d208e58.21f5872b.js.map