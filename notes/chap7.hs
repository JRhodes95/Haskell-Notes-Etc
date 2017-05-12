{-
Chapter 7 - Higher Order Functions

Higher-order functions allow common programming patterns to be encapsulated as
functions. This chapter starts by explaining what higher-order functions are,
and why they are useful, then introduces a number of higher order functions from
the standard prelude, and concludes by implementing a binary string transmitter
and two voting algorithms.

7.1 Basic Concepts
In Haskell it is also permissible to define functions that take functions as
arguments. For example, a function twice that takes a function and a value and
returns the result of the value with the function applied twice to it.
-}
twice :: (a -> a) -> a -> a
twice f x = f (f x)
{-
For example the following result could be obtained:
  > twice (*2) 3
  12
  > twice reverse [1,2,3,4]
  [1,2,3,4]

Using higher order functions makes Haskell a very powerful programming language.

7.2 Processing Lists
Our first example is the function map which applies a function to every
element of a list.
-}
--List comprehension definition
map'':: (a -> b) -> [a] -> [b]
map'' f [] = []
map'' f xs = [f x| x <- xs]

--Recursive definition
map' :: (a -> b) -> [a] -> [b]
map' f [] = []
map' f (x:xs) = f x : map' f xs
{-
Another useful definition is the function filter, which selects all elements of
a list that satisfy a predicate.
-}
--List comprehension defintion
filter'' :: (a -> Bool) -> [a] -> [a]
filter'' f [] = []
filter'' f xs = [x | x <- xs, f x]

--Recursion definition
filter' :: (a -> Bool) -> [a] -> [a]
filter' f [] = []
filter' f (x:xs) | f x       = x : filter' f xs
                 | otherwise = filter' f xs
{-
The functions map and filter are often used together in programs, with filter
being used to select certain elements from a list, each of which is then
transformed using map. For example, a function that returns the sum of the
squares of the even integers from a list could be defined as follows:
-}
sumsqreven :: [Int] -> Int
sumsqreven ns = sum(map (^2)(filter even ns))
{-
We conclude this section by illustrating a number of other higher order
functions for processing lists from the standard prelude.

Decide if all elements of a list satisfy a predicate:
> all even [2,4,6,8]
True

Decide if any elements of a list satisfy a predicate
> any odd [2,4,6,7]
True

Take any elements of a list if they satisfy a predicate
> takeWhile even [2,4,6,7]
[2,4,6]

Drop any elements of a list if they satisfy a predicate
> dropWhile even [2,4,6,7]
[7]

7.3 The foldr function

Many functions that take a list as their argument can be defined using the
following simple pattern of recursion on lists:
  f [] = v
  f (x:xs) = x # f xs
That is, the function maps the empty list to a value v, and any non-empty list
to an operator # applied to the head of a list and the result of recursively
processing the tail.

For example, a number of familiar library functions on lists can be defined
usign this pattern of recursion, including sum , product, or, & and.

The higher-order library function foldr (abbreviating fold right) encapsulates
this pattern of recursion. Using foldr, the definitions of the four functions
given above can be simplified to:
-}
sum' :: Num a=> [a] -> a
sum' = foldr (+) 0

product' :: Num a=> [a] -> a
product' = foldr (*) 1

or' :: [Bool] -> Bool
or' = foldr (||) False

and' :: [Bool] -> Bool
and' = foldr (&&) True
{-
The foldr function itself can be defined using recursion:
-}
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' f v [] = v
foldr' f v (x:xs) = f x (foldr' f v xs)
{-
That is, the function foldr f v maps the empty list to the value v, and any
other non-empty list to the function f applied to the head of the list and the
recursively processed tail.

In practice however, it is best to think of the behaviour of the function foldr
f v in a non-recursive manner, as simply replacing each cons operator in a list
by the function f, and the empty list at the end by the value v. For example,
applying the function f, and the empty list to the function foldr (+) 0 to the
list:
  1 : (2 : (3 : [])
gives
  1 + (2 + (3 + 0))

Even though foldr encapsulates a simple pattern of recursion, it can be applied
to many more functions than might at first be expected...

Length of a list:
  1 : (2 : (3 : [])
  1 + (1 + (1 + 0)
That is, replacing each cons with the function that adds one to its second
argument, and the empty list is just zero:
-}
length' :: [a] -> Int
length' = foldr (\_ n -> 1+n) 0
{-
Reversing a list:
  1 : (2 : (3 : [])
  ()([] ++ [3]) ++ [2]) ++ [1]
Although not immediately recognisable how we can use foldr to do this, if we
define a new function snoc that adds an element onto the end of a list, rather
than at the start, then reverse can be redefined as:
-}
snoc :: a -> [a] -> [a]
snoc x xs = xs ++ [x]

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = snoc x (reverse' xs)

--from which a definition using foldr is then immediate
reverse'' :: [a] -> [a]
reverse'' = foldr snoc []

{-
A very general real terms definition of foldr is given as:

foldr (#) v [x0, x1, ..., xn] = x0 # (x1 # (... (xn # v)...))

-}
