(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d230091"],{

/***/ "eb20":
/***/ (function(module, exports) {

!function(s){var n=["([\"'])(?:\\\\[^]|\\$\\([^)]+\\)|\\$(?!\\()|`[^`]+`|(?!\\1)[^\\\\`$])*\\1","<<-?\\s*([\"']?)(\\w+)\\2\\s[^]*?[\r\n]\\3"].join("|");s.languages["shell-session"]={command:{pattern:RegExp('^(?:[^\\s@:$#*!/\\\\]+@[^\\s@:$#*!/\\\\]+(?::[^\0-\\x1F$#*?"<>:;|]+)?)?[$#](?:[^\\\\\r\n\'"<]|\\\\.|<<str>>)+'.replace(/<<str>>/g,function(){return n}),"m"),greedy:!0,inside:{info:{pattern:/^[^#$]+/,alias:"punctuation",inside:{path:{pattern:/(:)[\s\S]+/,lookbehind:!0},user:/^[^:]+/,punctuation:/:/}},bash:{pattern:/(^[$#]\s*)\S[\s\S]*/,lookbehind:!0,alias:"language-bash",inside:s.languages.bash},"shell-symbol":{pattern:/^[$#]/,alias:"important"}}},output:/.(?:.*(?:[\r\n]|.$))*/},s.languages["sh-session"]=s.languages.shellsession=s.languages["shell-session"]}(Prism);

/***/ })

}]);
//# sourceMappingURL=chunk-2d230091.71cc4286.js.map