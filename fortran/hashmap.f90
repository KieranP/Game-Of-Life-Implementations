module hashmap_mod
  use iso_fortran_env, only: int32
  use cell_mod
  implicit none
  private
  public :: HashMap, CellPtr, hashmap_new, hashmap_put, hashmap_get, hashmap_get_all_values
  public :: KEY_LEN

  integer, parameter :: KEY_LEN = 32

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
    integer :: state = HASH_ENTRY_EMPTY
    integer(int32) :: hash = 0
    character(len=KEY_LEN) :: key = ''
    type(Cell), pointer :: value => null()
  end type HashEntry

  type :: HashMap
    type(HashEntry), allocatable :: entries(:)
    integer :: capacity
    integer :: count
  end type HashMap

contains

  pure function hash_full(key) result(hash)
    character(len=*), intent(in) :: key
    integer(int32) :: hash
    integer :: i
    integer(int32) :: byte_val
    integer(int32), parameter :: FNV_OFFSET = int(z'811C9DC5', kind=int32)
    integer(int32), parameter :: FNV_PRIME = int(z'01000193', kind=int32)

    hash = FNV_OFFSET

    do i = 1, len_trim(key)
      byte_val = iachar(key(i:i))
      hash = ieor(hash, byte_val)
      hash = hash * FNV_PRIME
    end do
  end function hash_full

  function hashmap_new() result(map)
    type(HashMap) :: map

    map%capacity = HASH_TABLE_SIZE
    map%count = 0
    allocate(map%entries(map%capacity))
  end function hashmap_new

  subroutine hashmap_put(map, key, value)
    type(HashMap), intent(inout) :: map
    character(len=*), intent(in) :: key
    type(Cell), pointer, intent(in) :: value
    integer(int32) :: hash
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

  pure function hashmap_get(map, key) result(value)
    type(HashMap), intent(in) :: map
    character(len=*), intent(in) :: key
    type(Cell), pointer :: value
    integer(int32) :: hash
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
