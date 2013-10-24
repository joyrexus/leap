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

animate = (data) -> 
  last = data.length - 1
  duration = (data[last].timestamp - data[0].timestamp) / 1000
  step = duration / data.length
  run = -> 
    window.requestAnimationFrame run
    if data.length and not paused
      frame = data.shift()
      left.moveTo frame.left.pos
      right.moveTo frame.right.pos
  run()

# load handler invoked on change event
load = -> 
  File = @files[0]
  return if not File.type.match '\.json$'
  file.textContent = File.name
  reader = new FileReader()
  reader.onload = (file) ->
    data = JSON.parse @result
    animate data
  reader.readAsText File

# click and choose a file to load
chooser.addEventListener('change', load)
file.addEventListener('click', -> chooser.click())
canvas.addEventListener('click', -> paused = not paused)
