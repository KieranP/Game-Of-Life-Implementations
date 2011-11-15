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
  for (var x = 0; x <= 150; x++) {
    for (var y = 0; y <= 40; y++) {
      world.add_cell(x, y, (Math.random() > 0.2));
    }
  }

  var body = $('body');
  body.html(render(world));

  setInterval(function() {
    var tick_start = new Date();
    world._tick();
    var tick_finish = new Date();
    var tick_time = ((tick_finish-tick_start)/1000).toFixed(3);

    var render_start = new Date();
    var rendered = render(world);
    var render_finish = new Date();
    var render_time = ((render_finish-render_start)/1000).toFixed(3);

    var output = "#"+world.tick;
    output += " - World tick took "+tick_time;
    output += " - Rendering took "+render_time;
    output += "<br />"+rendered;
    body.html(output);
  }, 0);

});
