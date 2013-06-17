class Dashing.Country extends Dashing.Widget



  ready: ->
    setInterval(@startTime, 500)


    @set('title', "Users by Country")

























  onData: (data) ->

    format = (x) ->
      switch x
        when 0 then "0-19"
        when 1 then "20-99"
        when 2 then "100-249"
        when 3 then "250-499"
        when 4 then "500-999"
        when 5 then ">=1000"

    y_format = (y) ->
      switch y
        when 100000 then "100000!"
        when 200000 then "200000!"
        when 300000 then "300000!"
        when 400000 then "400000!"
        else "A LOT"




    $(@node).empty()
    container = $(@node).parent()
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: 'bar'
      series: data.series
    )

    x_axis = new Rickshaw.Graph.Axis.X(graph: @graph, tickFormat: format, orientation: 'top')    
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)


    x_axis.render()
    y_axis.render()
    


    @graph.render() 
 
 
    @set('title', data.line)








