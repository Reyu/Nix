; extend
(
 (string_fragment) @lua
 (#match? @lua "-- lua")
 )

(
 (string_fragment) @vim
 (#match? @vim "\" vim")
 )

( binding_set
   ( binding
     attrpath: (attrpath (identifier) @_ppath) (#eq? @_ppath "plugin"))
   ( binding
     attrpath: (attrpath (identifier) @_tpath) (#eq? @_tpath "type")
     expression: (string_expression (string_fragment) @language))
   ( binding
     attrpath: (attrpath (identifier) @_cpath) (#eq? @_cpath "config")
     expression: [
                  (indented_string_expression (string_fragment) @content)
                  (string_expression (string_fragment) @content)
                 ])
)
