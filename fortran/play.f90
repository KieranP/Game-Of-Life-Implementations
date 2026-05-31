program play
  use world_mod
  use iso_fortran_env, only: real64
  implicit none

  integer, parameter :: WORLD_WIDTH = 150
  integer, parameter :: WORLD_HEIGHT = 40

  type(World) :: w
  character(len=:), allocatable :: rendered
  logical :: minimal
  real(real64) :: tick_start, tick_finish, tick_time
  real(real64) :: total_tick, lowest_tick, avg_tick
  real(real64) :: render_start, render_finish, render_time
  real(real64) :: total_render, lowest_render, avg_render
  integer :: minimal_status

  call random_seed()

  w = world_new( &
    width=WORLD_WIDTH, &
    height=WORLD_HEIGHT &
  )

  call get_environment_variable('MINIMAL', status=minimal_status)
  minimal = (minimal_status == 0)

  if (.not. minimal) then
    rendered = world_render(w)
    write(*, '(A)') rendered
  end if

  total_tick = 0.0_real64
  lowest_tick = huge(0.0_real64)
  total_render = 0.0_real64
  lowest_render = huge(0.0_real64)

  do
    call cpu_time(tick_start)
    call world_tick(w)
    call cpu_time(tick_finish)
    tick_time = (tick_finish - tick_start) * 1000.0_real64
    total_tick = total_tick + tick_time
    lowest_tick = min(lowest_tick, tick_time)
    avg_tick = total_tick / real(w%tick, real64)

    call cpu_time(render_start)
    rendered = world_render(w)
    call cpu_time(render_finish)
    render_time = (render_finish - render_start) * 1000.0_real64
    total_render = total_render + render_time
    lowest_render = min(lowest_render, render_time)
    avg_render = total_render / real(w%tick, real64)

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
  end do

end program play
