class Dashing.Version extends Dashing.Widget
  makeGraph: (data) ->
    d3.select(@node).select("svg").remove()

    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))

    #w = 300
    #h = 300
    #r = 100

    #alert "Heigth" + height
    #alert "Width" + width


    w = height + height/3.6# 200#+ 330
    h = w 
    r = w/3.0
    color = d3.scale.category20c()

    tx = (width)/2.0
    ty = height/2.0 + height/24 #30 #height/2.0



    @set('title', "Users per Version Number")


    func = (d) ->
      d.value

    comp_func = (a,b) ->
      d3.ascending(a, b)


    #data.sort(comp_func)  

    vis = d3.select(@node)
      .append("svg:svg")
      .data([data])
      .attr("width", w)
      .attr("height", h)
      .append("svg:g")
      .attr("transform", "translate(" + tx + "," + ty + ")")

    arc = d3.svg.arc().outerRadius(r)
    pie = d3.layout.pie().value(func)
    pie.sort(null)
    arcs = vis.selectAll("g.slice")
      .data(pie)

      .enter()
      .append("svg:g")
      .attr("class", "slice")


    color_func = (d, i) ->
      color(i)  

    arcs.append("svg:path")
      .attr("fill", color_func)
      .attr("d", arc)

    label_func = (d, i) ->
      data[i].label
    
    angle_func = (d) ->
      a = (d.startAngle + d.endAngle) * 90 / 3.14 - 90
      if a > 90 then a = a-180

      a + ""

    radius_func = (d) ->
      d.innerRadius = 0
      d.outerRadius = r
      angle = "60"
      "translate(" + arc.centroid(d) + ")rotate(" + angle_func(d) + ")translate(-5,5)"


    arcs.append("svg:text")
      .attr("transform", radius_func)
      .attr("text-anchor", "middle")
      .text(label_func)



  



  ready: ->
    data = [{"label":"--", "value":20}, 
    {"label":"--", "value":50}, 
    {"label":"--", "value":30}]

    this.makeGraph(data)






  onData: (data) ->
    this.makeGraph(data.new_data)

    #@set('title', data.line)

  

