program play
  use world_mod
  implicit none

  integer, parameter :: WORLD_WIDTH = 150
  integer, parameter :: WORLD_HEIGHT = 40

  type(World) :: w
  character(len=:), allocatable :: rendered
  logical :: minimal
  real(8) :: tick_start, tick_finish, tick_time
  real(8) :: total_tick, lowest_tick, avg_tick
  real(8) :: render_start, render_finish, render_time
  real(8) :: total_render, lowest_render, avg_render
  character(len=256) :: minimal_env

  call random_seed()

  w = world_new( &
    width=WORLD_WIDTH, &
    height=WORLD_HEIGHT &
  )

  call get_environment_variable('MINIMAL', minimal_env)
  minimal = (len_trim(minimal_env) > 0)

  if (.not. minimal) then
    rendered = world_render(w)
    write(*, '(A)') rendered
    deallocate(rendered)
  end if

  total_tick = 0.0d0
  lowest_tick = huge(1.0d0)
  total_render = 0.0d0
  lowest_render = huge(1.0d0)

  do while (.true.)
    call cpu_time(tick_start)
    call world_tick(w)
    call cpu_time(tick_finish)
    tick_time = (tick_finish - tick_start) * 1000.0d0
    total_tick = total_tick + tick_time
    lowest_tick = min(lowest_tick, tick_time)
    avg_tick = total_tick / real(w%tick, 8)

    call cpu_time(render_start)
    rendered = world_render(w)
    call cpu_time(render_finish)
    render_time = (render_finish - render_start) * 1000.0d0
    total_render = total_render + render_time
    lowest_render = min(lowest_render, render_time)
    avg_render = total_render / real(w%tick, 8)

    if (.not. minimal) then
      write(*, '(A)') achar(27) // '[H' // achar(27) // '[2J'
    end if

    write(*, '(A,I0,A,F5.3,A,F5.3,A,F5.3,A,F5.3,A)') &
      '#', w%tick, &
      ' - World Tick (L: ', lowest_tick, &
      '; A: ', avg_tick, &
      ') - Rendering (L: ', lowest_render, &
      '; A: ', avg_render, ')'

    if (.not. minimal) then
      write(*, '(A)') rendered
    end if

    deallocate(rendered)
  end do

end program play
