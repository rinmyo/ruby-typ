#let _ruby(rt, rb, size, dy, alignment, shift: (false, false)) = {
    if not ("center", "start", "between", "around").contains(alignment) {
      panic("'" + repr(alignment) + "' is not a valid ruby alignment")
    }

    let gutter = if (alignment=="center" or alignment=="start") {
        h(0pt)
      } else if (alignment=="between" or alignment=="around") {
        h(1fr)
      }
    
    let chars = if(alignment=="around") {
        [#h(0.5fr)#rt.clusters().join(gutter)#h(0.5fr)]
    } else {
        rt.clusters().join(gutter)
    }
    style(st=> {
        let bodysize = measure(rb, st)
        let rt_plain_width = measure(text(size: size, rt), st).width
        let width = if rt_plain_width > bodysize.width {rt_plain_width} else {bodysize.width}
        let rubytext = box(width: width, align(if(alignment=="start"){left}else{center}, text(size: size, chars)))
        let textsize = measure(rubytext, st)
        let dx = textsize.width - bodysize.width
        let (t_dx, l_dx, r_dx) = if(alignment=="start"){(0pt, 0pt, dx)}else{(-dx/2, dx/2, dx/2)}
        let (l, r) = shift
        box[#place(top+left, dx: if l {0pt} else {t_dx}, dy: -1.5*textsize.height + dy, rubytext) #if l {h(l_dx)} #rb #if r {h(r_dx)}]
    })
}

#let auto_ruby(rt, rb, size, dy, alignment, delimeter, fn: it => it) = {  
    let t_array = rt.split(delimeter)

    if type(rb) == "content" {
      let func = rb.func()
      let next = if func == text or func == raw { rb.text } else { rb.body }            
       return auto_ruby(rt, next, size, dy, alignment, delimeter, fn: it => func(fn(it)))
    } 

    if type(rb) == "string" {
      let b_array = rb.split(delimeter)
      if  b_array.len() == t_array.len() {
        return auto_ruby(rt, b_array.map(fn), size, dy, alignment, delimeter)
      }
    } 

    if type(rb) == "array" {
      let i = 0
      let result = []
      while i < t_array.len() {
        result += _ruby(
          t_array.at(i), rb.at(i), 
          size, dy, alignment, 
          shift: (i != 0,  i != t_array.len() - 1)
        )
        i += 1
      }
      return result
    }

    _ruby(rt, rb, size, dy, alignment)
}

#let get_ruby(size: .5em, dy: 0pt, alignment: "center", delimeter: "|") = (rt, rb, alignment: alignment) => {
  auto_ruby(rt, rb, size, dy, alignment, delimeter)
}