{-
Chapter 1 - Introduction

1.1 Functions
Functions are a mapping that takes one or more arguments and produces a single
result.

1.2 Functional Programming
A functional programming language is one that supports and encourages the
functional style

1.3 Features of Haskell
Concise programs
Powerful type system - little information required from the user to infer type
List comprehensions - powerful comprehension notation for list manipulation
Recursive functions

1.4 Historical Background - Who cares

1.5 A taste of Haskell
Summing numbers can be defined using the following code
-}
mySum :: Num a => [a] -> a
mySum [] = 0
mySum (n:ns) = n + sum ns
{-
This says that a function mySum has takes a list of anonymous type a
where a is of the type Number.
Then the sum of the empty list is equal to 0
Then it sums any non empty lists by recursion down the tails of the list and
adding

Sorting numbers can be done using the following qsort function
-}
qsort [] = []
qsort (x:xs) = qsort(smaller) ++ [x] ++ qsort(larger)
  where
    smaller = [a | a <- xs, a <= x]
    larger = [b | b <- xs, b > x]
{-
This makes use of the append (++) operator,
where is an operator that introduces local definitions.

How does qsort work?
qsort [] returns [] - empty list
qsort [x] returns [x] - no effect

lets look at how it would work for an example calculation

qsort [3,5,1,4,2]
= qsort[1,2] ++ [3] ++ qsort[5,4]
= (qsort[] ++ [1] ++ qsort [2]) ++ [3] ++ (qsort[4] ++ [5] ++ qsort[])
= ([] ++ [1] ++ [2]) ++ [3] ++ ([4] ++ [5] ++ [])
= [1,2] ++ [3] ++ [4,5]
= [1,2,3,4,5]

qsort is useful for any type of ordered values as it has the type
qsort :: Ord a => [a] -> [a]

1.7 Exercises

1) Give another possible calculation for the result of double(double 2)
-}
quadruple :: Num a => a -> a
quadruple x = x * 4

{-
2) Show that sum [x] = x for any number x
head [x] = x, tail [x] = []
sum[x] = x + sum [] = x + 0 = x

3) Define a function myProduct that gives the product of a list of numbers
-}
myProduct :: Num a => [a] -> a
myProduct [] = 1
myProduct (x:xs) = x * myProduct(xs)
{-
4) How should the definintion of qsort be changed so that it produces the
reverse ordered list?
-}
qsort' [] = []
qsort' (x:xs) = qsort'(larger) ++ [x] ++ qsort'(smaller)
  where
    smaller = [a | a <- xs, a <= x]
    larger = [b | b <- xs, b > x]
{-
put the larger terms before and recursion sorts the rest

5) What would be the effect of replacing <= with < in the original definiton of
qsort?

Gets rid of all duplicates whilst sorting as they fot neither of the guard
functions
-}
qsort'' [] = []
qsort'' (x:xs) = qsort''(smaller) ++ [x] ++ qsort''(larger)
  where
    smaller = [a | a <- xs, a < x]
    larger = [b | b <- xs, b > x]
