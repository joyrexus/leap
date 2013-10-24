root = exports ? this
offset = 300
$ = (select) -> document.querySelector select

left = $('#left')
right = $('#right')
  
moveTo = (pos) -> 
  {x, y, z} = pos
  if x and y
    @style.visibility = 'visible'
    @cx.baseVal.value = x + offset
    @cy.baseVal.value = y
    @r.baseVal.value = 25 + z/10
  else
    @style.visibility = 'hidden'

left.moveTo = moveTo
right.moveTo = moveTo

animate = (data) -> 
  last = data.length - 1
  duration = (data[last].timestamp - data[0].timestamp) / 1000
  step = duration / data.length
  run = -> 
    if data.length
      frame = data.shift()
      left.moveTo frame.left.pos
      right.moveTo frame.right.pos
      setTimeout (-> window.requestAnimationFrame run), step
  run()

load = (path, done) ->
  xhr = new XMLHttpRequest()
  xhr.onreadystatechange = ->
    if (xhr.readyState is 4) and (xhr.status is 200)
      done JSON.parse(xhr.responseText)
  xhr.open("GET", path, true)
  xhr.send()

root.render = (file) -> load file, animate
