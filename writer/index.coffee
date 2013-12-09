readline = require 'readline'
ws = require('websocket-stream')
thru = require 'through'


filter = ->

  write = (data) -> 
    if data
      data = JSON.parse(data)
      d =                               # queue attributes of interest
        id: data.id
        hands: data.hands
      @queue JSON.stringify(d) + '\n'

  end = -> @queue null                  # append EOF string if desired

  thru(write, end)

prompt = readline.createInterface(
  input: process.stdin
  output: process.stdout
)

prompt.question 'Hit return to start recording ', ->
  ws('ws://localhost:6437')
    .pipe(filter())
    .pipe(process.stdout)
  prompt.question('Hit return again to stop recording ', -> prompt.close())
