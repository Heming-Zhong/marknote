(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["chunk-2d0c847f"],{

/***/ "53e0":
/***/ (function(module, exports) {

!function(t){t.languages.http={"request-line":{pattern:/^(?:POST|GET|PUT|DELETE|OPTIONS|PATCH|TRACE|CONNECT)\s(?:https?:\/\/|\/)\S+\sHTTP\/[0-9.]+/m,inside:{property:/^(?:POST|GET|PUT|DELETE|OPTIONS|PATCH|TRACE|CONNECT)\b/,"attr-name":/:\w+/}},"response-status":{pattern:/^HTTP\/1.[01] \d.*/m,inside:{property:{pattern:/(^HTTP\/1.[01] )\d.*/i,lookbehind:!0}}},"header-name":{pattern:/^[\w-]+:(?=.)/m,alias:"keyword"}};var a,e,n,i=t.languages,p={"application/javascript":i.javascript,"application/json":i.json||i.javascript,"application/xml":i.xml,"text/xml":i.xml,"text/html":i.html,"text/css":i.css},r={"application/json":!0,"application/xml":!0};for(var s in p)if(p[s]){a=a||{};var T=r[s]?(void 0,n=(e=s).replace(/^[a-z]+\//,""),"(?:"+e+"|\\w+/(?:[\\w.-]+\\+)+"+n+"(?![+\\w.-]))"):s;a[s.replace(/\//g,"-")]={pattern:RegExp("(content-type:\\s*"+T+".*)(?:\\r?\\n|\\r){2}[\\s\\S]*","i"),lookbehind:!0,inside:p[s]}}a&&t.languages.insertBefore("http","header-name",a)}(Prism);

/***/ })

}]);
//# sourceMappingURL=chunk-2d0c847f.96272887.js.map