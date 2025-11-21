module cell_mod
  implicit none
  private
  public :: Cell, NeighbourPtr, cell_new, cell_to_char, cell_alive_neighbours

  type :: NeighbourPtr
    type(Cell), pointer :: ptr
  end type NeighbourPtr

  type :: Cell
    integer :: x
    integer :: y
    logical :: alive
    logical :: next_state
    type(NeighbourPtr), allocatable :: neighbours(:)
    integer :: neighbour_count
  end type Cell

contains

  function cell_new(x, y, alive) result(new_cell)
    integer, intent(in) :: x, y
    logical, intent(in) :: alive
    type(Cell), pointer :: new_cell

    allocate(new_cell)
    new_cell%x = x
    new_cell%y = y
    new_cell%alive = alive
    new_cell%next_state = alive
    new_cell%neighbour_count = 0
    allocate(new_cell%neighbours(8))
  end function cell_new

  function cell_to_char(c) result(ch)
    type(Cell), pointer, intent(in) :: c
    character(len=1) :: ch

    if (c%alive) then
      ch = 'o'
    else
      ch = ' '
    end if
  end function cell_to_char

  function cell_alive_neighbours(c) result(alive_neighbours)
    type(Cell), pointer, intent(in) :: c
    type(NeighbourPtr) :: neighbour
    integer :: alive_neighbours
    integer :: i

    ! The following is the fastest
    alive_neighbours = 0
    do i = 1, c%neighbour_count
      neighbour = c%neighbours(i)
      if (neighbour%ptr%alive) then
        alive_neighbours = alive_neighbours + 1
      end if
    end do
  end function cell_alive_neighbours

end module cell_mod
