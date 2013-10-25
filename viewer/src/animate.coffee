root = exports ? this
offset = 300    # offset x-value

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
  i = 0           # index of current data point
  run = -> 
    window.requestAnimationFrame run
    if i < data.length
      d = data[i]
      left.moveTo d.data('left')
      right.moveTo d.data('right')
      i += 1
  run()
