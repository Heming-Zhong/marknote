(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d2218a2"],{

/***/ "cb7d":
/***/ (function(module, exports) {

Prism.languages.wiki=Prism.languages.extend("markup",{"block-comment":{pattern:/(^|[^\\])\/\*[\s\S]*?\*\//,lookbehind:!0,alias:"comment"},heading:{pattern:/^(=+)[^=\r\n].*?\1/m,inside:{punctuation:/^=+|=+$/,important:/.+/}},emphasis:{pattern:/('{2,5}).+?\1/,inside:{"bold-italic":{pattern:/(''''').+?(?=\1)/,lookbehind:!0,alias:["bold","italic"]},bold:{pattern:/(''')[^'](?:.*?[^'])?(?=\1)/,lookbehind:!0},italic:{pattern:/('')[^'](?:.*?[^'])?(?=\1)/,lookbehind:!0},punctuation:/^''+|''+$/}},hr:{pattern:/^-{4,}/m,alias:"punctuation"},url:[/ISBN +(?:97[89][ -]?)?(?:\d[ -]?){9}[\dx]\b|(?:RFC|PMID) +\d+/i,/\[\[.+?\]\]|\[.+?\]/],variable:[/__[A-Z]+__/,/\{{3}.+?\}{3}/,/\{\{.+?\}\}/],symbol:[/^#redirect/im,/~{3,5}/],"table-tag":{pattern:/((?:^|[|!])[|!])[^|\r\n]+\|(?!\|)/m,lookbehind:!0,inside:{"table-bar":{pattern:/\|$/,alias:"punctuation"},rest:Prism.languages.markup.tag.inside}},punctuation:/^(?:\{\||\|\}|\|-|[*#:;!|])|\|\||!!/m}),Prism.languages.insertBefore("wiki","tag",{nowiki:{pattern:/<(nowiki|pre|source)\b[^>]*>[\s\S]*?<\/\1>/i,inside:{tag:{pattern:/<(?:nowiki|pre|source)\b[^>]*>|<\/(?:nowiki|pre|source)>/i,inside:Prism.languages.markup.tag.inside}}}});

/***/ })

}]);
//# sourceMappingURL=chunk-2d2218a2.eca2a15e.js.map