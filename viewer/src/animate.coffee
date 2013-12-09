root = exports ? this
w = 300   # default width of interaction box
h = 300   # default height of interaction box

moveTo = (pos) -> 
  {x, y, z} = pos
  dy = y - 240                      # y-coord minus y-center point
  cy = (h/2) - ((dy/260) * (h/2))   # center y-coord at
  cx = ((x/260) * (w/2)) + (w/2)    # center x-coord at
  r  = 15 + (z/10)                  # scale radius based on z-coord
  if x and y
    @style.visibility = 'visible'
    @cx.baseVal.value = cx
    @cy.baseVal.value = cy
    @r.baseVal.value  = r
  else
    @style.visibility = 'hidden'

left.moveTo = moveTo
right.moveTo = moveTo

root.animate = (data, width, height) -> 
  w = width if width?
  h = height if height?
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
