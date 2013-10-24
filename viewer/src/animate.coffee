root = exports ? this
paused = false
offset = 300

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

root.animate = (data) -> 
  hands.style.visibility = 'visible'
  run = -> 
    if data.length and not paused
      window.requestAnimationFrame run
      d = data.shift()
      left.moveTo d.data('left')
      right.moveTo d.data('right')
  run()

