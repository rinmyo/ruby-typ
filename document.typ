// Set the document's basic properties.
#set document(author: ("rinmyo"), title: "ruby-typ")
#set page(numbering: "1", number-align: center)
#set text(font: "Linux Libertine", lang: "jp")
#show link: underline

// Title row.
#align(center)[
  #block(text(weight: 700, 1.75em, "ruby-typ"))
]

// Author information.
#pad(
  top: 0.5em,
  bottom: 0.5em,
  x: 2em,
  align(center)[rinmyo]
)

// Main body.
#set par(justify: true)

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#import "ruby.typ": get_ruby

#let ruby = get_ruby()

= Introduction
A library to implement ruby just like this:

#ruby(alignment:"between", "レールガン")[超電磁砲]、#ruby("ページ")[頁]、#ruby("きょう")[今日]もいい#ruby("てん|き")[天|気]、

= Usage 

To use ruby-typ, you should import the `get_ruby` from `ruby.typ` at first.

```typc
#import "ruby.typ": get_ruby 
```

`get_ruby` is a higher-order function which be used to configure ruby-typ. and it will return a funtion for ruby. and its function signature is
```typc
get_ruby(
  size: .5em,              // the font size of ruby text
  dy: 0pt,                 // to add a shifting space on y axis
  alignment: "center",     // can be ("center", "start", "between", "around")
  delimeter: "|"           // the delimeter used in mono-ruby
)
```

to get a ruby function with default setting
```typc
#let ruby = get_ruby()
```

for example, if you'd like to use a `start` alignment.
```typc
#let ruby = get_ruby(alignment: "start")
#ruby("しずく")[雫]
```
which the result will be
#let ruby = get_ruby(alignment: "start")
#align(center, ruby("しずく")[雫])

#let ruby = get_ruby()

== mono/group ruby

ruby-typ supports mono-ruby and group-ruby automatically, which depends on wether the inputs are seperated by a delimiter.

```typc
  #ruby("とうきょうこうぎょうだいがく")[東京工業大学]
  #ruby("とう|きょう|こう|ぎょう|だい|がく")[東|京|工|業|大|学]
```
will generate respectively

#align(center)[
  #ruby("とうきょうこうぎょうだいがく")[東京工業大学]

  #ruby("とう|きょう|こう|ぎょう|だい|がく")[東|京|工|業|大|学]
]

As you see, ruby-typ is able to adjust the spaces of the body texts automatically in mono-ruby mode.

= Thanks
this project is based on #link("https://github.com/SaitoAtsush")[Saito Atsush]'s great idea and the #link("https://zenn.dev/saito_atsushi/articles/ff9490458570e1")[original source codes] posted on their blog

= Changelog
 - [20230425] Release the initial version.