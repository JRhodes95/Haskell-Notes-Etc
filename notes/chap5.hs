import Data.Char
{-
Chapter 5 - List comprehensions
List comprehensions allow many functions on lists to be defined in a simple
manner. We start by explaining generators, and guards then introduce the
function zip and the idea of string comprehensions, and conclude by developing
a program to crack the Caesar cipher.

5.1 Basic Concepts
Comprehension notation can be used to develop new sets from existing sets.
For example
  {x^2 |x E {1..5}} produces the set {1,4,9,16,25}
In Haskell, similar notation can be used to construct new lists from existing
lists. For example:
  >[x^2|x <- [1..5]]
  [1,4,9,16,25]
The | is read as 'such that', and the <-  is read as 'is drawn from'. The
expression x<-[1..5] is called a 'generator'.
A list comprehension can have multiple generators, with successive generators
separated by commas.
For example, all the possible pairings of a list [1,2,3] with list [4,5] can be
found using:
  > [(x,y) | x <- [1,2,3], y<-[4,5]]
  [(1,4),(1,5),(2,4),(2,5),(3,4),(3,5)]
Changing the order of the generators produces a the same set of pairs, just
in a different order.
  > [(x,y) |  y<-[4,5],x <- [1,2,3]]
  [(1,4),(2,4),(3,4),(1,5),(2,5),(3,5)]
The later generator are to be thought of as being more deeply nested.

A more practical example of this can be found in the library function concat
that concatenates a list of lists and can be defined using a generator to select
each list in turn, and another to select each element from each list:
-}
concat' ::[[a]] -> [a]
concat' xss = [x |xs <-xss, x<- xs]
{-
The wild card pattern _ is sometimes useful in generators to discard certain
elements from a list. For example, a function that selects all the first
components from a list of pairs can be defined as follows.
-}
firsts :: [(a,b)] -> [a]
firsts ps = [x | (x,_) <- ps]
{-
Similarly, the library function length that calculates the length of a list can
be defined as:
-}
length' :: [a] -> Int
length' xs = sum [1 | _ <-xs]
{-
In this case, the _ simply serves as a counter to govern the production of the
number ones.

5.2 Guards
List comprehsions can also use logical expressions called guards to filter the
values produced by earlier generators. For example, the generator:
  >[x|x<-[0..10], even x]
  [0,2,4,6,8,10]
This produces the even numbers in the range 0 to 10.
Similarly, a function can be defined that maps a positive integer to its list of
positive factors can be defined by:
-}
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]
{-
Recall that an integer greater than one is prime if its only postive factors are
one and the number itself. Hence, by using the function above, a simple function
that tests if an integer is a prime can be defined:
-}
prime :: Int -> Bool
prime n = factors n == [1,n]
{-
Using the function prime we can now define a function primes which produces all
prime numbers in a range up to a given limit:
-}
primes :: Int -> [Int]
primes n = [x | x <- [2..n], prime x]
{-
There are more efficient ways of doing this, they are covered in chapter 7.

As a final example concerning guards, suppose we represent a lookup table by a
list of pairs or keys and values. Then for any type of keys that supports
equality, a function find that returns the list of all value that are associated
with a given key in a table can be defined as follows:
-}
find :: Eq a => a -> [(a,b)] -> [b]
find k t = [v | (k', v) <- t, k ==k']
{-
This is saying that for search key k and table t, find the list of vs in t such
that k = k'
  >find 'b' [('a',4), ('b',2), ('b', 4), ('c', 12)]
  [2,4]

5.3 The Zip Function
The library function zip produces a new list by pairing successive elements
from two existing lists until one or both are exhausted.
  > zip ['a','b','c'] [1,2,3,4]
  [('a',1),('b',2),('c',3)]
The function zip is useful when working with list comprehensions. For example:
suppose that we define a function that returns the list of all pair of adjacent
elements:
-}
pairs :: [a] -> [(a,a)]
pairs xs = zip xs (tail xs)
{-
  > pairs [1,2,3,4]
  [(1,2),(2,3),(3,4)]

Then using pairs we can now define a function that decides if a list is sorted
by simply checking that all pairs of adjacent elements from the list are in the
correct order:
-}
sorted :: Ord a => [a] -> Bool
sorted xs = and [x <= y |(x,y) <- pairs xs]
{-
Using zip we can also define a function that returns the list of all positions
at which a value occurs in a list, by pairing each element with its position,
and selecting those positions at which the desired value occurs:
-}
positions ::Eq a => a -> [a] -> [Int]
positions x xs = [i |(x', i) <- zip xs [0..], x==x']
{-
  >positions 1 [1,2,3,4,1,2,3,4]
  [0,4]
this function reads as:
  The function 'positions' takes two variables, x, a value to be found, and xs
  the list in which x is to be found.
  It returns a list, produced using list comprehension notation as follows:
    > The list contains values i which are the positions of x in xs.
    > i is found by zipping xs with the numbers [0..] which will naturally end
    when xs is exhausted, but never before, due to the infinite definition of
    the second list, denoting the indices.
    >'i's are then found by looking for values where x == x' in the zipped lists
    and returning the zipped position indices.

We can use these infinite list definitions, as lazy evaluation means that the
infinte terms are not created unless needed, in which case Haskell returns an
error.

5.4 String Comprehensions
Up until this point, we have viewed strings in Haskell as a primitive notion.
They are actually lists of characters. For example
  "abc" :: String  is just abbreviation of
  ['a','b','c'] :: [Char]
Because strings are just lists, any polymorphic function on lists can also be
used on strings, for example:
  > "abcde" !! 2
  'c'
  zip "abcde" [0..]
  [('a',0),('b',1),('c',2),('d',3),('e',4)]

For the same reason, list comprehensions can also be used to define functions on
strings, such as functions that return the number of lower-case letters and
particular characters that occur in a string, respectively:
-}
lowers :: String -> Int
lowers xs = length [x | x <- xs, x >= 'a' && x <= 'z']

count :: Char -> String -> Int
count x xs = length [x' | x'<-xs, x == x']
{-
  > lowers "thuhnTUYLndfb"
  9
  > count 'a' "onomatopoeia"
  2

5.5 The Caesar Cipher
To encode a string, Caesar simply replaced each letter of the string with the
letter three places down in the alphabet, wrapping around at the ends.
We are going to make a function to do this with variable 'shift factors'.
To do this we are going to import a number of standard functions.
-}
-- import Data.Char at top of script
{-
For simplicity, we shall only encode lower case letters in a string, leaving
upper case letters as they are.

We begin by defining two functions to swap between the lower case letters and
numbers.
-}
let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

{-
Now define a function shift that shifts the value of a letter accounting for
wraparound, taking a leter and shift factor as arguments
-}
shift :: Int -> Char -> Char
shift n c | isLower c = int2let((let2int c + n) `mod` 26)
          | otherwise = c
{-
  > shift 2 'a'
  'c'
  > shift 4 'y'
  'c'
  > shift 4 'x'
  'b'

  Using shift with a list comprehension, it is now easy to define a function
  that encodes a string using a given shift factor:
-}
encode :: Int -> String -> String
encode n xs = [shift n x| x <- xs]
{-
  > encode 12 "Charlotte smells"
  "Ctmdxaffq eyqxxe"

These can be cracked using frequency tables.

Exercises
1) Using a list comprehension, given an expression that calculates the sum
1^2 + 2^2+ ... 100^2 of the first hundred integer squares.
  >[x^2 | x <- [1..100]]

2) Suppose that a coordinate grid of size m x n is given by the list of all pairs
(x, y) of integers such that 0<=x<=m and 0<=y<=n. Using a list comprehension,
define a function grid :: Int -> Int -> [(Int, Int)] that returns a
coordinate grid of a given size. For example:
 >grid 1 2
 [(0,0),(0,1),(0,2),(1,0),(1,1),(1,2)]
-}
grid :: Int -> Int -> [(Int, Int)]
grid m n = [(x,y) | x <-[0..m], y<-[0..n]]
{-
3) Using a list comprehension and the function grid from the past question,
define a function square :: Int -> [(Int,Int)] that returns a coordinate grid of
a given size n, excluding the diagonal from (0,0) to (n,n).
-}
-- using grid
square :: Int -> [(Int, Int)]
square n = [(x,y)| (x,y) <- grid n n, x /=y]

-- not using grid
square' :: Int -> [(Int, Int)]
square' n = [(x,y)| x <-[0..n], y<-[0..n], x /=y]
{-
4) In a similar way to the function length, show how the library function
replicate :: Int -> a -> [a] that produces a list of identical elements can be
defined using list comprehension.
-}
replicate' :: Int -> a -> [a]
replicate' n x = [x |_ <-[1..n]]
{-
Here _ just acts as a counter in the same way as in length.

5) A triple (x,y,z) of positive integers is Pythagorean if it satisfies the
equation a^2 + b^2 = c^2. Using a list comprehension with three generators,
define a fuction pyths :: Int -> [(Int,Int,Int)] that returns a list of all
such triples, whose components are at most a given limit.
-}
pyths :: Int -> [(Int,Int,Int)]
pyths d = [(a,b,c)| a <- [1..d], b <- [1..d], c <- [1..d], a^2 + b^2 == c^2]

{-
6) A positive integer is perfect if it equals the sum of all its factors,
excluding the number itself. Using a list comprehension and the function factors
define a function perfects :: Int -> [Int] that returns a list of all the
perfect numbers up to a given limit.
-}
perfects :: Int -> [Int]
perfects n = [p | p <-[1..n], sum( factors p) -p == p]
{-
7) Show how the list comprehension:
  [(x,y)| x <-[1,2], y <- [3,4]]
  could be re-expressed using two comprehensions, each using one generator, and
  the use of the library function concat :: [[a]] ->[a]
  concat [[ (x,y) | y <- [4,5,6]] | x <- [1,2,3] ]
-}
