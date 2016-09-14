class Dashing.Banner extends Dashing.Widget
  ready: ->
    setInterval(@startTime, 1000)

  startTime: =>
    today = new Date()

    h = today.getHours()
    m = today.getMinutes()
#    s = today.getSeconds()
    m = @formatTime(m)
    s = @formatTime(s)
    @set('time', h + ":" + m)
    @set('date', today.toDateString())

  formatTime: (i) ->
    if i < 10 then "0" + i else i
