{-
Chapter 2 -First steps
This chapter gives a brief intro to the GHCI and standard prelude, as well
as commenting and formatting conditions

Exercises
2) Parenthesise the following numeric expressions
2^3*4
(2^3)*4

2*3+4*5
(2*3)+(4*5)

2+3*4^5
2+(3*(4^5))

3) This script contains three syntactic errors, correct them and check the
solution works

N = a `div` length xs
  where
    a = 10
    xs = [1,2,3,4,5]
-}
n' = a `div` length xs
  where
    a = 10
    xs = [1,2,3,4,5]
{-
4) The function last selects the last element of a non-empty list. Show a way
of defining last using library functions.
-}
myLast :: [a] -> a
myLast [x] = x
myLast (x:xs) =  myLast xs

myLast' :: [a] -> a
myLast' [x] = x
myLast' xs = myLast'(tail xs)

myLast'' :: [a] -> a
myLast'' xs = head(reverse(xs))

myLast''' :: [a] -> a
myLast''' xs = xs !! (length xs - 1)
{-
5) init removes the last element from a non-empty list. Show a way of defining
this using library functions.
-}
myInit :: [a] -> [a]
myInit xs = reverse(tail(reverse(xs)))
{-
This works as follows
myInit [1,2,3,4,5]
= reverse(tail(reverse([1,2,3,4,5])))
= reverse(tail([5,4,3,2,1]))
= reverse([4,3,2,1])
= [1,2,3,4]
-}
