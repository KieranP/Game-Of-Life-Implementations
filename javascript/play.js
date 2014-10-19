function render(world) {
  var rendering = '';
  for (var y = world.boundaries()['y']['min']; y <= world.boundaries()['y']['max']; y++) {
    for (var x = world.boundaries()['x']['min']; x <= world.boundaries()['x']['max']; x++) {
      var cell = world.cell_at(x, y);
      rendering += (cell ? cell.to_char() : ' ').replace(' ', '&nbsp;');
    }
    rendering += "<br />"
  }
  return rendering;
}

$(document).ready(function() {

  var world = new World;

  // Prepopulate the cells
  for (var x = 0; x <= 150; x++) {
    for (var y = 0; y <= 40; y++) {
      world.add_cell(x, y, (Math.random() <= 0.2));
    }
  }

  // Prepopulate the neighbours
  for (var x = 0; x <= 150; x++) {
    for (var y = 0; y <= 40; y++) {
      world.neighbours_around(world.cell_at(x, y));
    }
  }

  var body = $('body');
  body.html(render(world));

  var total_tick = 0;
  var total_render = 0;

  setInterval(function() {
    var tick_start = new Date();
    world._tick();
    var tick_finish = new Date();
    var tick_time = parseFloat(((tick_finish-tick_start)/1000).toFixed(5));
    total_tick += tick_time;
    var avg_tick = parseFloat((total_tick / world.tick).toFixed(5));

    var render_start = new Date();
    var rendered = render(world);
    var render_finish = new Date();
    var render_time = parseFloat(((render_finish-render_start)/1000).toFixed(5));
    total_render += render_time;
    var avg_render = parseFloat((total_render / world.tick).toFixed(5));

    var output = "#"+world.tick;
    output += " - World tick took "+tick_time+" ("+avg_tick+")";
    output += " - Rendering took "+render_time+" ("+avg_render+")";
    output += "<br />"+rendered;
    body.html(output);
  }, 0);

});
