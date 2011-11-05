function render(world) {
  var rendering = '';
  for (y=world.boundaries()['y']['min']; y<=world.boundaries()['y']['max']; y++) {
    for (x=world.boundaries()['x']['min']; x<=world.boundaries()['x']['max']; x++) {
      var cell = world.cell_at(x, y);
      rendering += (cell ? cell.to_char() : ' ').replace(' ', '&nbsp;');
    }
    rendering += "<br />"
  }
  return rendering;
}

$(document).ready(function() {

  var world = new World;
  for (x=0; x<=150; x++) {
    for (y=0; y<=40; y++) {
      world.add_cell(x, y, (Math.random() > 0.2));
    }
  }

  var body = $('body');
  body.html(render(world));

  setInterval(function() {
    var start = new Date();
    world._tick();
    var finish = new Date();

    var output = "#"+world.tick+" - World tick took "+((finish-start)/1000)+"<br />";
    output += render(world);
    body.html(output);
  });

});
