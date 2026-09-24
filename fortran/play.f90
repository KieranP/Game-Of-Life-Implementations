program play
  use world_mod
  use iso_fortran_env, only: int64, real64
  implicit none

  integer, parameter :: WORLD_WIDTH = 150
  integer, parameter :: WORLD_HEIGHT = 40

  character(len=*), parameter :: CLEAR_SCREEN = achar(27) // '[?2026h' // achar(27) // '[H' // achar(27) // '[2J'
  character(len=*), parameter :: SHOW_SCREEN = achar(27) // '[?2026l'

  type(World) :: w
  character(len=:), allocatable :: rendered
  logical :: minimal
  integer(int64) :: clock_rate
  integer(int64) :: tick_start, tick_finish
  real(real64) :: tick_time, total_tick, lowest_tick, avg_tick
  integer(int64) :: render_start, render_finish
  real(real64) :: render_time, total_render, lowest_render, avg_render
  integer :: minimal_status

  call random_seed()
  call system_clock(count_rate=clock_rate)

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
    call system_clock(tick_start)
    call world_tick(w)
    call system_clock(tick_finish)
    tick_time = real(tick_finish - tick_start, real64) / real(clock_rate, real64) * 1000.0_real64
    total_tick = total_tick + tick_time
    lowest_tick = min(lowest_tick, tick_time)
    avg_tick = total_tick / real(w%tick, real64)

    call system_clock(render_start)
    rendered = world_render(w)
    call system_clock(render_finish)
    render_time = real(render_finish - render_start, real64) / real(clock_rate, real64) * 1000.0_real64
    total_render = total_render + render_time
    lowest_render = min(lowest_render, render_time)
    avg_render = total_render / real(w%tick, real64)

    if (.not. minimal) then
      write(*, '(A)', advance='no') CLEAR_SCREEN
    end if

    write(*, '(A,I0,A)') &
      '#', w%tick, &
      ' - World Tick (L: ' // f(lowest_tick) // '; A: ' // f(avg_tick) // ')' // &
      ' - Rendering (L: ' // f(lowest_render) // '; A: ' // f(avg_render) // ')'

    if (.not. minimal) then
      write(*, '(A)') rendered // SHOW_SCREEN
    end if
  end do

  call world_free(w)

contains

  ! Fortran identifiers cannot start with an underscore,
  ! so `f` instead of the conventional `_f`
  function f(value) result(formatted)
    real(real64), intent(in) :: value
    character(len=:), allocatable :: formatted
    character(len=32) :: buffer

    write(buffer, '(F20.3)') value
    formatted = trim(adjustl(buffer))
  end function f

end program play
