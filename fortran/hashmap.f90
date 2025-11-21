module hashmap_mod
  use iso_c_binding
  use cell_mod
  implicit none
  private
  public :: HashMap, CellPtr, hashmap_new, hashmap_put, hashmap_get, hashmap_get_all_values

  ! Start with the expected size of the hash table (150 * 40 = 6,000)
  ! Then round up to a power of two (2**ceil(log2(6000))) = 8,192
  ! Then double it in order to decrease hash collisions = 16,384
  integer, parameter :: HASH_TABLE_SIZE = 16384
  integer, parameter :: HASH_ENTRY_EMPTY = 0
  integer, parameter :: HASH_ENTRY_OCCUPIED = 1

  type :: CellPtr
    type(Cell), pointer :: ptr
  end type CellPtr

  type :: HashEntry
    integer :: state
    integer(c_int32_t) :: hash
    character(len=32) :: key
    type(Cell), pointer :: value
  end type HashEntry

  type :: HashMap
    type(HashEntry), allocatable :: entries(:)
    integer :: capacity
    integer :: count
  end type HashMap

contains

  function hash_full(key) result(hash)
    character(len=*), intent(in) :: key
    integer(c_int32_t) :: hash
    integer :: i
    integer(c_int32_t) :: byte_val
    integer(c_int32_t), parameter :: FNV_OFFSET = int(z'811C9DC5', c_int32_t)
    integer(c_int32_t), parameter :: FNV_PRIME = int(z'01000193', c_int32_t)

    hash = FNV_OFFSET

    do i = 1, len_trim(key)
      byte_val = ichar(key(i:i))
      hash = ieor(hash, byte_val)
      hash = hash * FNV_PRIME
    end do
  end function hash_full

  function hashmap_new() result(map)
    type(HashMap) :: map
    integer :: i

    map%capacity = HASH_TABLE_SIZE
    map%count = 0
    allocate(map%entries(map%capacity))

    do i = 1, map%capacity
      map%entries(i)%state = HASH_ENTRY_EMPTY
      nullify(map%entries(i)%value)
    end do
  end function hashmap_new

  subroutine hashmap_put(map, key, value)
    type(HashMap), intent(inout) :: map
    character(len=*), intent(in) :: key
    type(Cell), pointer, intent(in) :: value
    integer(c_int32_t) :: hash
    integer :: mask, idx, i

    hash = hash_full(key)
    mask = map%capacity - 1
    idx = iand(int(hash), mask) + 1

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

  function hashmap_get(map, key) result(value)
    type(HashMap), intent(in) :: map
    character(len=*), intent(in) :: key
    type(Cell), pointer :: value
    integer(c_int32_t) :: hash
    integer :: mask, idx, i

    nullify(value)

    hash = hash_full(key)
    mask = map%capacity - 1
    idx = iand(int(hash), mask) + 1

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

  function hashmap_get_all_values(map) result(values)
    type(HashMap), intent(in) :: map
    type(CellPtr), allocatable :: values(:)
    integer :: i, j

    allocate(values(map%count))

    j = 1
    do i = 1, map%capacity
      if (map%entries(i)%state == HASH_ENTRY_OCCUPIED) then
        values(j)%ptr => map%entries(i)%value
        j = j + 1
      end if
    end do
  end function hashmap_get_all_values

end module hashmap_mod
