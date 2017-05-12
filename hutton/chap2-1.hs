-- chap2-1.hs
myLast' :: [a] -> a
myLast' [a] = a
myLast' xs = myLast'(tail xs)
