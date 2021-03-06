-- ----------------------------------------------------------------------------
-- Utils.Heap.hs - An implementation of a heap structure
--                 Should be replaced later by a Hackage library
-- ----------------------------------------------------------------------------

module Utils.Heap 
   (Heap
   , hInitial
   , hAlloc
   , hUpdate
   , hFree)
   where

import Utils.Assoc

type Addr = Int

-- | Data type Heap
data Heap a = Heap Addr [Addr] [(Addr, a)]
    -- Note: Do not automatically derive Show, The free list in infinite...
 
-- | Create a Heap
hInitial :: Heap a   
hInitial = Heap 0 [1..] []

-- | Add a new element to the heap
-- Add the new elemten at the beginning of the list, and remove the address
hAlloc :: Heap a -> a -> (Heap a, Addr)
hAlloc (Heap size (next : free) xs) x =
	   (Heap (size + 1) free  ((next, x) : xs), next)
 
-- | Update an element added earlier to the heap
hUpdate :: Heap a -> Addr -> a -> Heap a
hUpdate (Heap size free xs) a x  =
         Heap size free ((a,x) : remove xs a) 

-- | Remove an address from the Heap
hFree :: Heap a -> Addr -> Heap a
hFree (Heap size free xs) a = Heap (size - 1) (a:free) (remove xs a)


-- | Helper function remove
remove :: [(Int, a)] -> Int -> [(Int, a)]
remove [] adr = error ("Heap.remove - Attemot to update or free nonexistent address"
              ++ show adr)
remove ((a, x) : xs) adr  
    | a == adr  = xs
    | otherwise = (a,x) : remove xs adr

-- Additional Functions

-- | Return the nubmer of elements in our heap
hSize :: Heap a -> Int
hSize (Heap size free xs) = size

-- | Return all addresses with data stored in our heap
hAddresses :: Heap a -> [Addr]
hAddresses (Heap size free xs) = [addr | (addr, node) <- xs]

-- | Loopkup an element with its address
hLookup :: Heap a -> Addr -> a 
hLookup (Heap size free xs) a 
    = aLookup xs a (error ("Heap.hLokup - can't find address " ++ show a))
