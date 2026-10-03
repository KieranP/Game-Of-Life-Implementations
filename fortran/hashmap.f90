module hashmap_mod
  use iso_fortran_env, only: int64
  use cell_mod
  implicit none
  private
  public :: HashMap, CellPtr, hashmap_new, hashmap_free, hashmap_put, hashmap_get, hashmap_get_all_values
  public :: KEY_LEN

  integer, parameter :: KEY_LEN = 32

  integer, parameter :: HASH_ENTRY_EMPTY = 0
  integer, parameter :: HASH_ENTRY_OCCUPIED = 1

  type :: CellPtr
    type(Cell), pointer :: ptr
  end type CellPtr

  type :: HashEntry
    integer :: state = HASH_ENTRY_EMPTY
    integer(int64) :: hash = 0
    character(len=KEY_LEN) :: key = ''
    type(Cell), pointer :: value => null()
  end type HashEntry

  type :: HashMap
    type(HashEntry), allocatable :: entries(:)
    integer :: capacity
    integer :: count
    type(CellPtr), pointer :: values(:) => null()
  end type HashMap

contains

  pure function hash_full(key) result(hash)
    character(len=*), intent(in) :: key
    integer(int64) :: hash
    integer :: i
    integer(int64) :: byte_val
    integer(int64), parameter :: FNV_OFFSET = int(z'811C9DC5', kind=int64)
    integer(int64), parameter :: FNV_PRIME = int(z'01000193', kind=int64)
    ! int32 overflow is undefined, so the 32-bit hash is computed in int64 and masked
    integer(int64), parameter :: FNV_MASK = int(z'FFFFFFFF', kind=int64)

    hash = FNV_OFFSET

    do i = 1, len_trim(key)
      byte_val = iachar(key(i:i))
      hash = ieor(hash, byte_val)
      hash = iand(hash * FNV_PRIME, FNV_MASK)
    end do
  end function hash_full

  ! Doubles the expected count to decrease hash collisions, then rounds up to a
  ! power of two for masking (150 * 40 = 6,000 gives 16,384)
  function hashmap_new(expected_count) result(map)
    integer, intent(in) :: expected_count
    type(HashMap) :: map

    map%capacity = 1
    do while (map%capacity < expected_count * 2)
      map%capacity = map%capacity * 2
    end do
    map%count = 0
    allocate(map%entries(map%capacity))
  end function hashmap_new

  ! Frees the entry table only; the caller owns the values
  subroutine hashmap_free(map)
    type(HashMap), intent(inout) :: map

    deallocate(map%entries)
    if (associated(map%values)) deallocate(map%values)
    map%count = 0
  end subroutine hashmap_free

  ! Doubles the table, reusing each entry's stored hash
  subroutine hashmap_grow(map)
    type(HashMap), intent(inout) :: map
    type(HashEntry), allocatable :: entries(:)
    integer :: capacity, mask, idx, i

    capacity = map%capacity * 2
    mask = capacity - 1
    allocate(entries(capacity))

    do i = 1, map%capacity
      if (map%entries(i)%state == HASH_ENTRY_OCCUPIED) then
        idx = int(iand(map%entries(i)%hash, int(mask, kind=int64))) + 1
        do while (entries(idx)%state == HASH_ENTRY_OCCUPIED)
          idx = iand(idx, mask) + 1
        end do
        entries(idx) = map%entries(i)
      end if
    end do

    call move_alloc(entries, map%entries)
    map%capacity = capacity
  end subroutine hashmap_grow

  subroutine hashmap_put(map, key, value)
    type(HashMap), intent(inout) :: map
    character(len=*), intent(in) :: key
    type(Cell), pointer, intent(in) :: value
    integer(int64) :: hash
    integer :: mask, idx, i

    ! Past half full, probe chains lengthen and a full table drops inserts
    if ((map%count + 1) * 2 > map%capacity) then
      call hashmap_grow(map)
    end if

    if (associated(map%values)) deallocate(map%values)

    hash = hash_full(key)
    mask = map%capacity - 1
    idx = int(iand(hash, int(mask, kind=int64))) + 1

    do i = 1, map%capacity
      associate(entry => map%entries(idx))
        if (entry%state == HASH_ENTRY_OCCUPIED) then
          if (entry%hash == hash .and. &
              trim(entry%key) == trim(key)) then
            entry%value => value
            return
          end if
          idx = iand(idx, mask) + 1
        else
          entry%key = key
          entry%value => value
          entry%hash = hash
          entry%state = HASH_ENTRY_OCCUPIED
          map%count = map%count + 1
          return
        end if
      end associate
    end do
  end subroutine hashmap_put

  pure function hashmap_get(map, key) result(value)
    type(HashMap), intent(in) :: map
    character(len=*), intent(in) :: key
    type(Cell), pointer :: value
    integer(int64) :: hash
    integer :: mask, idx, i

    nullify(value)

    hash = hash_full(key)
    mask = map%capacity - 1
    idx = int(iand(hash, int(mask, kind=int64))) + 1

    do i = 1, map%capacity
      associate(entry => map%entries(idx))
        if (entry%state == HASH_ENTRY_OCCUPIED) then
          if (entry%hash == hash .and. &
              trim(entry%key) == trim(key)) then
            value => entry%value
            return
          end if
          idx = iand(idx, mask) + 1
        else
          return
        end if
      end associate
    end do
  end function hashmap_get

  ! The map owns the returned array, which stays valid until the next put
  function hashmap_get_all_values(map) result(values)
    type(HashMap), intent(inout) :: map
    type(CellPtr), pointer :: values(:)
    integer :: i, j

    if (.not. associated(map%values)) then
      allocate(map%values(map%count))

      j = 1
      do i = 1, map%capacity
        if (map%entries(i)%state == HASH_ENTRY_OCCUPIED) then
          map%values(j)%ptr => map%entries(i)%value
          j = j + 1
        end if
      end do
    end if

    values => map%values
  end function hashmap_get_all_values

end module hashmap_mod
