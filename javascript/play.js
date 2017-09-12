World_Width  = 150
World_Height = 40

$(document).ready(function() {

  var world = new World(
    World_Width,
    World_Height,
  );

  var body = $('body');
  body.html(world.render());

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
    var rendered = world.render();
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
