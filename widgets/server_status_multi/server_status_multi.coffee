class Dashing.ServerStatusMulti extends Dashing.Widget
  
  ready: ->
    unless @get("updatedAt")?
      this.resetExpiration({ updatedAt: 0 })

  onData: (data) ->
    this.resetExpiration(data)
