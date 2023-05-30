; extends
(
 (string_fragment) @lua
 (#match? @lua "-- lua")
 )

(
 (string_fragment) @vim
 (#match? @vim "\" vim")
 )

(binding attrpath: (attrpath (identifier) @field (#eq? @field "extraLuaConfig"))
         expression: [(string_expression (string_fragment) @lua)
                      (indented_string_expression (string_fragment) @lua)
                     ])

(binding attrpath: (attrpath (identifier) @_field (#eq? @_field "extraConfig"))
         expression: [(string_expression (string_fragment) @viml)
                      (indented_string_expression (string_fragment) @viml)
                     ])

( binding_set
   ( binding
     attrpath: (attrpath (identifier) @_ppath) (#eq? @_ppath "plugin"))
   ( binding
     attrpath: (attrpath (identifier) @_tpath) (#eq? @_tpath "type")
     expression: (string_expression (string_fragment) @language))
   ( binding
     attrpath: (attrpath (identifier) @_cpath) (#eq? @_cpath "config")
     expression: [(indented_string_expression (string_fragment) @content)
                  (string_expression (string_fragment) @content)
                 ])
)
