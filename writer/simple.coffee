readline = require 'readline'
WebSocket = require 'ws'


filter = ->

  write = (data) -> 
    if data
      data = JSON.parse(data)
      if data.id
        d =                               # queue attributes of interest
          id: data.id
          hands: data.hands
        @queue JSON.stringify(d) + '\n'

  end = -> @queue null                    # append EOF string if desired

  thru(write, end)

prompt = readline.createInterface(
  input: process.stdin
  output: process.stdout
)

prompt.question 'Hit return to start recording ', ->
  stream = new WebSocket 'ws://localhost:6437'
  stream.on 'message', (data, flags) ->
    if data
      data = JSON.parse(data)

  prompt.question 'Hit return again to stop recording ', -> 
    stream.close()
    prompt.close()
