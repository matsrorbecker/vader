var lineData = [{
  x: 1,
  y: 0
}, {
  x: 2,
  y: 0
}, {
  x: 3,
  y: 0
}, {
  x: 4,
  y: 0
}, {
  x: 5,
  y: 0
}, {
  x: 6,
  y: 15
}];

var vis = d3.select('#visualisation'),
    WIDTH = 600,
    HEIGHT = 300,
    MARGINS = {
      top: 20,
      right: 20,
      bottom: 20,
      left: 50
    },
    xRange = d3.scale.linear().range([MARGINS.left, WIDTH - MARGINS.right]).domain([d3.min(lineData, function(d) {
      return d.x;
    }), d3.max(lineData, function(d) {
      return d.x;
    })]),
    yRange = d3.scale.linear().range([HEIGHT - MARGINS.top, MARGINS.bottom]).domain([d3.min(lineData, function(d) {
      return d.y;
    }), d3.max(lineData, function(d) {
      return d.y;
    })]),
    xAxis = d3.svg.axis()
      .scale(xRange)
      .tickSize(5)
      .tickSubdivide(true),
    yAxis = d3.svg.axis()
      .scale(yRange)
      .tickSize(5)
      .orient('left')
      .tickSubdivide(true);

//Create axis
vis.append('svg:g')
  .attr('class', 'x axis')
  .attr('transform', 'translate(0,' + (HEIGHT - MARGINS.bottom) + ')')
  .call(xAxis);

vis.append('svg:g')
  .attr('class', 'y axis')
  .attr('transform', 'translate(' + (MARGINS.left) + ',0)')
  .call(yAxis);


function getWeatherData(callback){

  jQuery.ajax({
    type: 'GET',
    url: '/weather',
    success: callback,
    error: callback
  });

}

function getWeather(){
  jQuery.ajax({
    type: 'POST',
    url: '/weather',
    data: {city:'Stockholm'},
    success: handleResponse
  });
}

function handleResponse(data){

  lineData= [{
    x: 1,
    y: 5
  }, {
    x: 2,
    y: 6
  }, {
    x: 3,
    y: data.afternoon.temperature
  }, {
    x: 4,
    y: data.evening.temperature
  }, {
    x: 5,
    y: data.night.temperature
  }, {
    x: 6,
    y: 2
  }];

  var lineFunc = d3.svg.line()
  .x(function(d) {
    return xRange(d.x);
  })
  .y(function(d) {
    return yRange(d.y);
  })
  .interpolate('linear');

  vis.append('svg:path')
  .attr('d', lineFunc(lineData))
  .attr('stroke', 'blue')
  .attr('stroke-width', 2)
    
}

$( document ).ready(function() {
    //getWeatherData(handleResponse);
});

