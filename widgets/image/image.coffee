class Dashing.Image extends Dashing.Widget

  ready: ->
# This is fired when the widget is done being rendered
    setInterval(@startTime, 5000)

  startTime: =>
 #   @set('image', "http://sawadacoffee.com/wp-content/uploads/Sawada-Coffee-10DEC2015-003.jpg")
    @set('image', "http://192.168.1.93:81/live/0/jpeg.jpg")
    sleep 500
    @set('image', "http://192.168.1.80:8080/index2.jpg")
 #   @set('image', "http://dashuser:passw0rd@192.168.1.93:81/live/0/mjpeg.jpg")


sleep = (ms) ->
  start = new Date().getTime()
  continue while new Date().getTime() - start < ms
