class Dashing.Version extends Dashing.Widget
  
  w = 300
  h = 300
  r = 100
  color = d3.scale.category20c()



  ready: ->

    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))





    @set('title', "Users per Version Number")


    func = (d) ->
      d.value



    data = [{"label":"one", "value":20}, 
      {"label":"two", "value":50}, 
      {"label":"three", "value":30}]


    #vis = d3.select("body")
    #vis = d3.select("li").select("div") #$(@node).parent()
    vis = d3.select(@node)
      .append("svg:svg")
      .data([data])
      .attr("width", w)
      .attr("height", h)
      .append("svg:g")
      .attr("transform", "translate(" + r + "," + r + ")")

    arc = d3.svg.arc().outerRadius(r)
    pie = d3.layout.pie().value(func)
    arcs = vis.selectAll("g.slice")
      .data(pie)
      .enter()
      .append("svg:g")
      .attr("class", "slice")


    colors = ["#f00", "#0f0", "#00f"]
    color_func = (d, i) ->
      color(i)  
      #colors[i]

    arcs.append("svg:path")
      .attr("fill", color_func)
      .attr("d", arc)
      
    label_func = (d, i) ->
      data[i].label
    
    radius_func = (d) ->
      d.innerRadius = 0
      d.outerRadius = r
      "translate(" + arc.centroid(d) + ")"


    arcs.append("svg:text")
      .attr("transform", radius_func)
      .attr("text-anchor", "middle")
      .text(label_func)










  onData: (data) ->
    @set('title', data.line)
    if @graph
      @graph.series[0].data = data.points
      #@graph.render()




