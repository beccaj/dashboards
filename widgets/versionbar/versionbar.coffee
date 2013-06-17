class Dashing.Versionbar extends Dashing.Widget



  ready: ->

    container = $(@node).parent()

    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: 'bar'
      series: [
        {
        color: "#4811AE",
        data: [{x:0, y:200}, {x:1, y:100}, {x:2, y:10}, {x:3, y: 30}, {x:4, y:40}]
        }
      ]
    )

    #@graph.series[0].data = @get('points') if @get('points')
    #x_labels = data.x_labels

    format = (x) ->
      switch x
        when 0 then "v. 1"
        when 1 then "v. 2"
        when 2 then "v. 3"
        when 3 then "v. 4"
        when 4 then "v. 5"
        when 5 then "v. 6"
        when 6 then "v. 7"


    x_axis = new Rickshaw.Graph.Axis.X(graph: @graph, tickFormat: format)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()


    @set('title', "Users per Version Number")








  onData: (data) ->
    #@set('title', data.line)
    if @graph
      @graph.series[0].data = data.points
      @graph.render()





