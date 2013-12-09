#!/usr/bin/env coffee 
thru = require 'through'
split = require 'split'

filter = ->

  write = (data) -> 
    if data
      d =                               # queue attributes of interest
        id: data.id
        hands: data.hands         
      @queue JSON.stringify(d) + "\n"

  end = -> @queue null                  # append EOF string if desired

  thru(write, end)

process.stdin
  .pipe(split(JSON.parse))
  .pipe(filter())
  .pipe(process.stdout)
