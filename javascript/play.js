// This is the closest thing Javascript has to
// classes, class variables, and class functions

function Play() {}

Play.World_Width  = 150;
Play.World_Height = 40;

Play.run = function() {

  let world = new World(
    Play.World_Width,
    Play.World_Height,
  );

  let body = document.getElementsByTagName('body')[0];
  body.innerHTML = world.render();

  let total_tick = 0;
  let total_render = 0;

  // Can't use while(true) because it locks the page
  setInterval(function() {
    let tick_start = new Date();
    world._tick();
    let tick_finish = new Date();
    let tick_time = (tick_finish - tick_start) / 1000;
    total_tick += tick_time;
    let avg_tick = (total_tick / world.tick);

    let render_start = new Date();
    let rendered = world.render();
    let render_finish = new Date();
    let render_time = (render_finish - render_start) / 1000;
    total_render += render_time;
    let avg_render = (total_render / world.tick);

    let output = "#"+world.tick;
    output += " - World tick took "+Play._f(tick_time)+" ("+Play._f(avg_tick)+")";
    output += " - Rendering took "+Play._f(render_time)+" ("+Play._f(avg_render)+")";
    output += "<br />"+rendered;
    body.innerHTML = output;
  }, 0);

}

Play._f = function(value) {
  return value.toFixed(5);
}

Play.run();
