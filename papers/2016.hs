{-2016 Programming Paradigms Haskell Section

Question 1
 a)
We study an operation  mymult that accepts two lists of integers
a0... an and b0 to bn. It returns all the products of the integer
pairs, a0 times b0 etc. Write down the signature of this function
[1 Mark]
-}
--mymult :: [Int] -> [Int] -> [Int] replaced in e)
mymult' :: Num a => [a] -> [a] -> [a]

{-
b)
name three different types of recursion
simple, multiple, mutual recusion
{unsure}

c)
Implement mymult without any list comprehension or helper functions
from the standard library besides multiplication and concatenation.
Make use of recursion as well as pattern matching in your solution.
-}
mymult' [] [] = []
mymult' [] [x] = error "Unpaired value in second list"
mymult' [x] [] = error "Unpaired value in first list"
mymult' (x:xs) (y:ys) = x * y : mymult' xs ys
{-
d)
WEIRD QUESTIOn about memory usage
e)
Rewrite the signature of mymult such that any type with a well-defined
multiplication operator should be supported.

mymult :: Num a => [a] -> [a] -> [a]

f)
What is the difference between Haskell's Int and Integer type

Int can range from -2^63 to 2^63-1, it has a definite amount of memory.
Integer can take up as much memory as needed so can go above or below these.

g) If you hace a version of mymult that works for multiple types, Haskell refers
to it as generic programming. What does overloading mean in Haskell and how does
it differ from overloading in Java?

In Haskell, overloading refers to the constraining of types or functions to one
or more classes. For example Num a constrains the type of a to anything in the
number class.

In Java, overloading is a feature that allows a class to have two or more
methods with the same name, if their argument lists are different.

h) Extend your implementation of mymult such that the result does not contain
any two equal entries any longer. You may reuse you previous version of mymult
as mymult' within your new variant.

-}
myfilter :: [a] -> [a]
myfilter (x:xs) | 

mymult :: Num a => [a] -> [a] -> [a]
mymult xs ys = myfilter'(mymult' xs ys)

{-

--------------------------------------------------------------------------------
Question 2

-}
