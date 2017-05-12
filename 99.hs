-- 99 Problems in Haskelll

-- 1 Find the last element of a list
myLast :: [a] -> a
myLast [x] = x
myLast (_:xs) = myLast xs

-- 2 Find the last but one element of a list
lastBut :: [a] -> a
lastBut [x,_] = x
lastBut (_:xs) = lastBut xs

-- 3 Find the Kth element of a list
findKth :: [a] -> Int -> a
findKth xs k = xs!!(k-1)

-- 4 Find the number of elements in a list
myLength :: [a] -> Int
myLength xs = sum [1 | _ <-xs]

--5 Reverse a list
myRev :: [a] -> [a]
myRev [] = []
myRev (x:xs) =  myRev xs ++ [x]


--6 Find out if a list is a palindrome
palindrome :: (Eq a) => [a] -> Bool
palindrome xs = xs == (myRev xs)

--7 Flatten a nested structure
