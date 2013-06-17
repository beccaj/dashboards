class Dashing.Myweather extends Dashing.Widget
  makeGraph: (data) ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width - 40
      height: height - 40
      renderer: 'line'
      series: data.series
    )
    format = (x) ->
      data.x_labels[x]

    x_axis = new Rickshaw.Graph.Axis.X(graph: @graph, tickFormat: format)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph)
    @graph.render()

    d3.select("svg")
      .attr("height", height)
      #.attr("width", width)

    x_label_y = 730 + "" 
    #height - 40 + ""

    d3.select(@node).select("svg")
      .append("g")
      .attr("class", "x_label")
      .attr("transform", "translate(40, " + 730 +")") # 730
      .append("g")
      .attr("translate", "transform(0,0)")
      .append("text")
      .attr("y", -20)
      .attr("x", width/2.0)
      .attr("dy", "0em")
      .attr("text-anchor", "middle")
      .text("Network Size")


    @set('title', "Average Temperature")

  ready: ->
    data = {x_labels: ["--", "--", "--", "--", "--"], series: [{color: "#555", data: [{x:0, y:1000}, {x:1, y:100}, {x:2, y:100}, {x:3, y:100}, {x:4, y:100}] }]}
    this.makeGraph( data )
    #this.makeGraphSVG(data)


  


  onData: (data) ->
    #d3.select(@node).remove()

    d3.select(@node).select("svg").remove()
    #series = {series: [{color: "#5aa", data: [{x:0, y:1000}, {x:1, y:100}, {x:2, y:100}, {x:3, y:100}, {x:4, y:100}] }]}
    this.makeGraph( data )
    #this.makeGraphSVG(data)




