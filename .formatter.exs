# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  line_length: 128,
  export: [
    locals_without_parens: [expect: 2, expect: 3, expect: 4]
  ]
]
