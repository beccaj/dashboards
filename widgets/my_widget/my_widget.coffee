class Dashing.MyWidget extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)

    container = $(@node).parent()
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: 'area'
      stroke: true
      series: [
        {
        color: "#fff",
        data: [{ x: 0, y: 40 }, { x: 1, y: 49 }, {x: 2, y: 44}, {x: 3, y: 67}]
        stroke: "#ff0"
        },

        {
          color: "#aaa"
          data: [{x: 3, y: 67}, {x: 2, y: 44}, { x: 1, y: 49 },  {x: 0, y: 40 }]
          stroke: "#aa0"
        }
      ]
    )

    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    
    @graph.render()       
    @set('line1', "This is")
    @set('line2', "My Widget")


  onData: (data) ->
    @set('line1', data.hello)
    @set('line2', data.line)  

    if @graph
      @graph.series[0].data = data.points
      @graph.render()






