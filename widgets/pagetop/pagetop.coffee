class Dashing.PageTop extends Dashing.Widget
  
  @accessor "headerValue", ->
    header = @get("header")
    if $(@node).data("handle-escapes")
      # Cheaty way of replacing correctly. TODO - Find a better method.
      header = JSON.parse("{ \"header\": \"" + header + "\" }").header
    return header
  
  ready: ->
    # This is fired when the widget is done being rendered
  
  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
