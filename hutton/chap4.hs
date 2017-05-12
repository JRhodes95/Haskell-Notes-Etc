-- Hutton chapter 4
-- Defining functions

--define the following library fuctions

--even
myEven :: Integral a => a -> Bool
myEven n = n `mod` 2 == 0

--split at nth element
mySplit :: Int -> [a] -> ([a], [a])
mySplit n xs = (take n xs, drop n xs)

-- reciprocation
myRecip :: Fractional a => a -> a
myRecip n = 1/n

-- absolute
myAbs :: Int -> Int
myAbs n =
  if n >= 0 then n
    else -n

-- signum returns sign of the Int
mySignum :: Int -> Int
mySignum n =
  if n > 0 then 1 else
    if n ==0 then 0
    else -1

-- using guarded equations instead of conditionals
-- guarded absolute function
myAbs' n | n >= 0 = n
         | otherwise = -n

--guarded signum
mySignum' n | n < 0 = -1
            | n == 0 = 0
            | n > 0 = 1


--lambda functions
-- the character \ represents the greek letter lambda

--for example the function
-- add :: Int -> Int -> Int
-- add x y = x + y
-- can be understood as
-- add :: Int -> (Int -> Int)
-- add \x -> (\y -> x + y)


-- define a fucntion halve that splits a list into two een lengthed lists
halve :: [a] -> ([a],[a])
halve xs = ( x, y ) where
  n = length xs `div` 2
  x = take n xs
  y = drop n xs

-- define functions to return the third element in a list using
-- a) head and tail
third1 :: [a] -> a
third1 xs = head( tail( tail(xs)))

-- b) indexing using !!
third2 :: [a] -> a
third2 xs = xs !! 2

-- c) pattern matching
third3 :: [a] -> a
third3 (_:_:x:_) = x

-- Safetail
--condtional
safetail1 xs =
  if null xs then []
    else tail xs

-- operator equations
safetail2 xs | null xs = []
             | otherwise tail xs

--pattern matching
safetail3 [] =[]
safetail3 (_:xs) = xs
