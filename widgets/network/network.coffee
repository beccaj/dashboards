class Dashing.Network extends Dashing.Widget
  makeGraph: (data) ->
    d3.select(@node).select("svg").remove()

    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width - 40
      height: height - 40
      renderer: 'bar'
      series: data.series
    )

    format = (x) ->
      data.x_labels[x]



    x_axis = new Rickshaw.Graph.Axis.X(graph: @graph, tickFormat: format)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()

    # make the svg container fill the whole widget so we have room under the graph for an x-axis label
    d3.select("svg")
      .attr("height", height)
      #.attr("width", width)

    x_label_y = 0.936 * height + "" 

    # a hack to get the x labels to line up better with the bars
    attr_str = d3.select("g.x_ticks_d3").attr("transform")
    attr_str = attr_str.replace("(0", "(40")
    d3.select("g.x_ticks_d3").attr("transform", attr_str)


    # add a label to the x-axis
    d3.select(@node).select("svg")
      .append("g")
      .attr("class", "x_label")
      .attr("transform", "translate(40, " + 730 +")") # 730
      .append("g")
      .attr("transform", "translate(0,0)")
      .append("text")
      .attr("y", -20)
      .attr("x", width/2.0)
      .attr("dy", "0em")
      .attr("text-anchor", "middle")
      .text("Network Size")


    @set('title', "Users per Network Size")








  ready: ->
    # dummy data if the graph hasn't received any yet
    data = {x_labels: ["--", "--", "--", "--", "--"], series: [{color: "#555", data: [{x:0, y:1000}, {x:1, y:100}, {x:2, y:100}, {x:3, y:100}, {x:4, y:100}] }]}
    this.makeGraph( data )
    #this.makeGraphSVG(data)


  makeGraphSVG: (dataObj) -> 
    data = [4, 8, 15, 16, 23, 42]

    width = d3.select(@node).attr("width")
    height = d3.select(@node).attr("height") #20 * data.length

    bar_thickness = height / data.length

    #width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    #height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    #w = 420
    #h = 20 * data.length

    #d3.select(@node).remove()

    chart = d3.select(@node)
      .append("svg")
      .attr("class", "chart")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .attr("transform", "translate(10,200)")

    x = d3.scale.linear()
      .domain([0, d3.max(data)])
      .range([0, 420])

    y_func = (d, i) ->
      i * 20  
    y = d3.scale.ordinal()
      .domain(data)
      .rangeBands([0, 120])  

    chart.selectAll("rect")
      .data(data)
      .enter()
      .append("rect")
      .attr("y", y_func)
      .attr("width", x)
      .attr("height", y.rangeBand())


    text_func = (d) ->
      y(d) + y.rangeBand() / 2.0

    chart.selectAll("text")
      .data(data)
      .enter().append("text")
      .attr("x", x)
      .attr("y", text_func)
      .attr("dx", -3)
      .attr("dy", ".35em")
      .attr("text-anchor", "end")
      .text(String)


    chart.selectAll("line")
      .data(x.ticks(10))
      .enter().append("line")
      .attr("x1", x)
      .attr("x2", x)
      .attr("y1", 0)
      .attr("y2", 120)
      .style("stroke", "#ccc")
    chart.selectAll(".rule")
      .data(x.ticks(10))
      .enter().append("text")
      .attr("class", "rule")
      .attr("x", x)
      .attr("y", 0)
      .attr("dy", -3)
      .attr("text-anchor", "middle")
      .text(String)

    chart.append("line")
      .attr("y1", 0)
      .attr("y2", 120)
      .style("stroke", "#0ff")



  onData: (data) ->
    this.makeGraph( data )
    #this.makeGraphSVG(data)




