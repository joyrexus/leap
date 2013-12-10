thru = require 'through'

module.exports = (->
  start = null                            # starting timestamp

  write = (data) -> 
    if data
      data = JSON.parse(data)
      if data.id
        start = data.timestamp if not start
        d =                               # queue attributes of interest
          id: data.id
          time: data.timestamp - start
          hands: data.hands
        @queue JSON.stringify(d) + '\n'

  end = -> @queue null                    # append EOF string if desired

  thru(write, end)
)()
