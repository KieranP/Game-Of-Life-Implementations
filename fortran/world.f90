module world_mod
  use cell_mod
  use hashmap_mod
  implicit none
  private
  public :: World, world_new, world_tick, world_render

  type :: World
    integer :: width
    integer :: height
    integer :: tick
    type(HashMap) :: cells
  end type World

  integer, parameter :: DIRECTIONS(2,8) = reshape([ &
    -1,  1,  0,  1,  1,  1, &
    -1,  0,          1,  0, &
    -1, -1,  0, -1,  1, -1  &
  ], shape(DIRECTIONS))

contains

  function world_new(width, height) result(w)
    integer, intent(in) :: width, height
    type(World) :: w

    w%width = width
    w%height = height
    w%tick = 0
    w%cells = hashmap_new()

    call populate_cells(w)
    call prepopulate_neighbours(w)
  end function world_new

  subroutine world_tick(w)
    type(World), intent(inout) :: w
    integer :: i, alive_neighbours
    type(Cell), pointer :: c
    type(CellPtr), allocatable :: cells(:)

    cells = hashmap_get_all_values(w%cells)

    ! First determine the action for all cells
    do i = 1, size(cells)
      c => cells(i)%ptr
      alive_neighbours = cell_alive_neighbours(c)
      if (.not. c%alive .and. alive_neighbours == 3) then
        c%next_state = .true.
      else if (alive_neighbours < 2 .or. alive_neighbours > 3) then
        c%next_state = .false.
      else
        c%next_state = c%alive
      end if
    end do

    ! Then execute the determined action for all cells
    do i = 1, size(cells)
      c => cells(i)%ptr
      c%alive = c%next_state
    end do

    deallocate(cells)
    w%tick = w%tick + 1
  end subroutine world_tick

  function world_render(w) result(rendering)
    type(World), intent(in) :: w
    type(Cell), pointer :: c
    integer :: x, y, idx, render_size, i
    character(len=:), allocatable :: rendering

    render_size = w%width * w%height + w%height
    allocate(character(len=render_size) :: rendering)

    ! The following is slower
    ! do y = 0, w%height - 1
    !   do x = 0, w%width - 1
    !     c => cell_at(w, x, y)
    !     rendering = rendering // cell_to_char(c)
    !   end do
    !   rendering = rendering // new_line('a')
    ! end do

    ! The following is the fastest
    idx = 1
    do y = 0, w%height - 1
      do x = 0, w%width - 1
        c => cell_at(w, x, y)
        rendering(idx:idx) = cell_to_char(c)
        idx = idx + 1
      end do
      rendering(idx:idx) = new_line('a')
      idx = idx + 1
    end do
  end function world_render

  function cell_at(w, x, y) result(c)
    type(World), intent(in) :: w
    integer, intent(in) :: x, y
    type(Cell), pointer :: c
    character(len=32) :: key

    call make_key(x, y, key)
    c => hashmap_get(w%cells, key)
  end function cell_at

  subroutine populate_cells(w)
    type(World), intent(inout) :: w
    integer :: x, y
    real :: random
    logical :: alive

    do y = 0, w%height - 1
      do x = 0, w%width - 1
        call random_number(random)
        alive = (random <= 0.2)
        call add_cell(w, x, y, alive)
      end do
    end do
  end subroutine populate_cells

  subroutine add_cell(w, x, y, alive)
    type(World), intent(inout) :: w
    integer, intent(in) :: x, y
    logical, intent(in) :: alive
    type(Cell), pointer :: existing
    character(len=32) :: key

    existing => cell_at(w, x, y)
    if (associated(existing)) then
      write(*, '(A,I0,A,I0,A)') 'LocationOccupied(', x, '-', y, ')'
      stop 1
    end if

    call make_key(x, y, key)
    call hashmap_put(w%cells, key, cell_new(x, y, alive))
  end subroutine add_cell

  subroutine prepopulate_neighbours(w)
    type(World), intent(inout) :: w
    integer :: i, d, x, y, nx, ny
    type(Cell), pointer :: c, neighbour
    type(CellPtr), allocatable :: cells(:)

    cells = hashmap_get_all_values(w%cells)

    do i = 1, size(cells)
      c => cells(i)%ptr
      x = c%x
      y = c%y

      do d = 1, 8
        nx = x + DIRECTIONS(1, d)
        ny = y + DIRECTIONS(2, d)

        if (nx < 0 .or. ny < 0) cycle
        if (nx >= w%width .or. ny >= w%height) cycle

        neighbour => cell_at(w, nx, ny)
        if (associated(neighbour)) then
          c%neighbour_count = c%neighbour_count + 1
          c%neighbours(c%neighbour_count)%ptr => neighbour
        end if
      end do
    end do

    deallocate(cells)
  end subroutine prepopulate_neighbours

  subroutine make_key(x, y, key)
    integer, intent(in) :: x, y
    character(len=32), intent(out) :: key

    write(key, '(I0,A,I0)') x, '-', y
  end subroutine make_key

end module world_mod
