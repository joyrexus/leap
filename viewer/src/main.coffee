w = 960         # width
h = 800         # height
axis = h/2      # place x-axis halfway down
clicks = 0      # number of clicks on plot (0, 1, or 2)
draw = 'graph'  # global var for SVG graph
points = []     # plotted velocity data points
clicked = []    # clicked data points

colors =        # color conventions
  position: 'steelblue'
  velocity: '#777'
  highlight: 'orange'

selection =     # range of selected data points
  active: false
  begin: null
  end: null

animateSelection = -> animate points[selection.begin..selection.end]

# highlight and get info on the data point under the cursor
focus = ->
  @stroke colors.highlight
  time.innerHTML = @data 'time'
  value.innerHTML = @data 'value'

# reset selection
reset= ->
  for p in points[selection.begin..selection.end]
    p.stroke(colors.velocity)
    p.data('selected', false)
  selection.active = false
  selection.end = null
  end.innerHTML = 'End'

# click handler for each data point
clickSelector = -> 
  clicks += 1
  if clicks is 1                        # first click to begin
    reset()
    clicked.push @data('clicked', true) # track clicked data points
    selection.begin = @data 'index'
    begin.innerHTML = @data 'time'
    viewer.style.visibility = 'visible'
  else                                  # click second time to end
    selection.active = true
    if @data('index') < selection.begin
      selection.end = selection.begin
      end.innerHTML = begin.innerHTML
      selection.begin = @data 'index'
      begin.innerHTML = @data 'time'
    else
      selection.end = @data 'index'
      end.innerHTML = @data 'time'
    for p in clicked
      p.data('clicked', false)    # reset click status
      p.stroke(p.data 'color')    # set back to original color
    for p in points[selection.begin..selection.end]
      p.stroke(colors.highlight)
      p.data('selected', true)
    clicks = 0                          # reset count
    animateSelection()

drawLine = (time, value, tick, color='steelblue') ->
    draw.line(tick, axis, tick, axis - value)
      .stroke(color)
      .data('time', time)
      .data('value', value)
      .data('color', color)             # original color
      .mouseover(focus)
      .mouseout(-> 
        if not (@data('clicked') or @data('selected'))
          @stroke do -> color
      )
      .click(clickSelector)   # handle click-selection

mockLine =  # null line object with mock attrs
  stroke: -> @
  data: (key, value) -> 
    @[key] = value
    @

# plot the position and velocity of the y-coord in each frame of data
plot = (data) -> 
  tick = 0                    # ticks along x-axis of plot
  skip = false                # uncaptured data to skip?
  start = data[0].timestamp
  draw = SVG('graph').size(w, h)

  # iterate over each frame/data-point `d`
  for i, d of data              # `i` is the index of each data point
    time = (d.timestamp - start) / 1000000    # in seconds
    position = d.left.pos.y     # y-coord position of left hand
    velocity = d.left.vel.y     # y-coord velocity of left hand (mm/s)
    if position
      skip = false              # don't skip next empty value
      tick += 1                 # move over 1 tick on axis
      drawLine(time, position, tick)
        .data('index', i)       # add index for making selections
      v = drawLine(time, velocity, tick, color="#777")
        .data('index', i)       # add index for making selections
        .data('left', d.left.pos)     # left position coords
        .data('right', d.right.pos)   # right position coords
        .opacity(.8)
      points.push v             # add data point for velocity
    else
      tick += 10 if not skip    # create empty space
      skip = true               # skip additional empty values
      points.push mockLine

  w = tick                      # reset width to tick count
  draw.size(w, h)
  draw.rect(w, h).back().attr("class", "border")

velocity = (d) -> d.left.vel.y  # y-coord position of left hand
position = (d) -> d.left.pos.y  # y-coord velocity of left hand

# load handler invoked on change event
load = -> 
  File = @files[0]
  return if not File.type.match '\.json$'
  file.textContent = File.name
  reader = new FileReader()
  reader.onload = (file) -> plot JSON.parse @result
  reader.readAsText File
  cursor.style.visibility = 'visible'

# click and choose a file to load
chooser.addEventListener('change', load)
file.addEventListener('click', -> chooser.click())
hands.addEventListener('click', animateSelection)
