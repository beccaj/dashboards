class Dashing.Feed extends Dashing.Widget
  @accessor 'description', ->
    "#{@get('current_headline')?.description}"
  @accessor 'headline', ->
    "#{@get('current_headline')?.headline}"

  ready: ->
    @currentIndex = 0
    @feedElem = $(@node).find('.feed-container')
    @nextHeadline()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0



  startCarousel: ->
    setInterval(@nextHeadline, 8000)

  fade_func: ->
    @currentIndex = (@currentIndex + 1) % headlines.length
    @set 'current_headline', headlines[@currentIndex]
    @feedElem.fadeIn 800   

  nextHeadline: =>
    headlines = @get('headlines')
    if headlines
      #@feedElem.fadeOut(400, @fade_func)
      @currentIndex = (@currentIndex + 1) % headlines.length
      @set 'current_headline', headlines[@currentIndex]
      #@feedElem.fadeIn 800   
