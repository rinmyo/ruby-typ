#let _ruby(rt, rb, size, dy, alignment, delimeter) = {
    if not ("center", "start", "between", "around").contains(alignment) {
      panic("'" + repr(alignment) + "' is not a valid ruby alignment")
    }

    let extract_content(content, fn: it => it) = {
      let func = content.func()
      return if func == text or func == raw { 
        (content.text, func)
      } else {
        extract_content(content.body, it => func(fn(it)))
      }  
    }

    let rb_array = if type(rb) == "content" {
        let (inner, func) = extract_content(rb)
        inner.split(delimeter).map(func)
    } else if type(rb) == "string" {
        rb.split(delimiter)
    } else {(rb,)}
    assert(type(rb_array) == "array")

    let rt_array = rt.split(delimeter)

    if rt_array.len() != rb_array.len() {
        rt_array = (rt,)
        rb_array = (rb,)
    }

    let gutter = if (alignment=="center" or alignment=="start") {
        h(0pt)
      } else if (alignment=="between" or alignment=="around") {
        h(1fr)
      }
    
    box(style(st=> {
        let i = 0
        let sum_body = []
        let sum_width = 0pt
        assert(rt_array.len() == rb_array.len())
        while i < rb_array.len() {
            let (body, ruby) = (rb_array.at(i), rt_array.at(i))
            let bodysize = measure(body, st)
            let rt_plain_width = measure(text(size: size, ruby), st).width
            let width = if rt_plain_width > bodysize.width {rt_plain_width} else {bodysize.width}
            let chars = if(alignment=="around") {
                h(0.5fr) + ruby.clusters().join(gutter) + h(0.5fr)
            } else {
                ruby.clusters().join(gutter)
            }
            let rubytext = box(width: width, align(if(alignment=="start"){left}else{center}, text(size: size, chars)))
            let textsize = measure(rubytext, st)
            let dx = textsize.width - bodysize.width
            let (t_dx, l_dx, r_dx) = if(alignment=="start"){(0pt, 0pt, dx)}else{(-dx/2, dx/2, dx/2)}
            let (l, r) = (i != 0,  i != rb_array.len() - 1)
            place(
                top+left, 
                dx: sum_width + t_dx, 
                dy: -1.5*textsize.height + dy, 
                rubytext
            )
            sum_width += width 
            sum_body += if l {h(l_dx)} + body + if r {h(r_dx)}
            i += 1
        }
        sum_body
    }))
}

#let get_ruby(
  size: .5em, 
  dy: 0pt, 
  alignment: "center", 
  delimeter: "|"
) = (rt, rb, alignment: alignment) => _ruby(
    rt, rb, 
    size: .5em, dy: 0pt, 
    alignment: "center",
    delimeter: "|"
)