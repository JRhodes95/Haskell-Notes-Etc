{-
Chapter 6 - Recursive Functions

Recursion is the basic mechanism for looping in Haskell. We start by looking at
looping on integers, then lists, then consider multiple arguments, multiple
recursion and mutual recursion, concluding with some advice on defining
recursive functions.

6.1 Basic Concepts
In the same way that we can define functions in terms of other functions, we can
also define functions in terms of themselves. For example, the factorial
function can be defined as:
-}
fac :: Int -> Int
fac n = product [1..n]
 -- or it can be defined recursively:
fac' :: Int -> Int
fac' 0 = 1
fac' n = n * fac (n-1)
{-
The first definition states that the factorial of 0 is 1 and is called a base
case. The second one states that the factorial of a number is the number timesed
by the factorial of its predecessor.
Note that although the fac' function is defined in terms of itself, it does not
loop forever. The actual library function for factorial is defined without using
recursion.

Another example of a function that can be written using recursion is the *
operator, if considering only non-negative integers:

(*) :: Int -> Int -> Int
m * 0 = 0
m * n = m + (m * (n - 1))

This example just takes advantage of the fact that multiplication can be
reduced to repeated addition.

6.2 Recursion on Lists
The library function product can be defined as follows using recursion on lists:
-}
product' :: Num a => [a] -> a
product' [] = 1
product' (x:xs) = x * product xs
{-
The library function length can be defined similarly:
-}
length' :: [a] -> Int
length' [] = 0
length' (_:xs) = 1 + length' xs
{-
And the function to reverse a list:
-}
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]
{-
In turn the append operator ++ can be defined in terms recusive terms.

(++) :: [a] -> [a] -> [a]
[] ++ ys = ys
(x:xs) ++ ys = x : (xs ++ ys)

Now let's look at two examples of recursion on sorted lists. First, a function
that inserts a new element of any ordered type into a sorted list to give
another sorted list can be define as follows:
-}
insert :: Ord a => a -> [a] -> [a]
insert x []                 = [x]
insert x (y:ys) | x <=y     = x : y :ys
                | otherwise = y : insert x ys
{-
Using insert we can now define a function that implements insertion sort, in
which the empty list is alreadt sorted, and any non empty list is sorted by
inserting its head into the list that results from sorting its tail:
-}
isort :: Ord a => [a] -> [a]
isort [] = []
isort (x:xs) = insert x (isort xs)
{-

6.3 Multiple Arguments
Functions with multiple arguments can also make use of recursion, for example
the library function zip can be defined as follows:
-}
zip' :: [a] -> [b] -> [(a,b)]
zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys
{-
Note that two base cases are required in the definition of zip, as either of the
two argument lists may be empty.

Another example of of recursion with multiple arguments is the library function
drop that removes the first n elements from the start of a list:
-}
drop' :: Int -> [a] -> [a]
drop' 0 xs = xs
drop' _ [] = []
drop' n (_:xs) = drop' (n-1) xs
{-
Again two base cases are required, one for removing zero elements and another
for dropping elements from the empty list.

6.5 Mutual Recursion
Functions can also be defined through mutual recusrion, in which two or more
functions are all defined recursively in terms of each other. For example,
consider the library functions even and odd,. For efficiency, these functions
are normally defined using the remainder after dividing by two. However, for
non-negative integers they can also be defined suing mutual recursion:
-}
even' :: Int -> Bool
even' 0 = True
even' n = odd (n-1)

odd' :: Int -> Bool
odd' 0 = False
odd' n = even (n-1)
{-
Similarly, functions that select the elements from a list at all even and odd
positions (counting from zero) can be defined as follows:
-}
evens :: [a] -> [a]
evens [] = []
evens (x:xs) = x : odds xs

odds :: [a] -> [a]
odds [] = []
odds (_:xs) = evens xs
{-

6.6 Advice on Recursion
Defining recursive functions is a bit like riding a bicycle:
  > It looks easy when someone else is doing it,
  > It may seem impossible when you first try to do it yourself,
  > It becomes simple and natural with practice.
This section defines a simple 5 step process to define recursive functions
reliably.

STEP 1: DEFINE THE TYPE
It is good practice to define the type of a function before starting to define
the function itself.
-}
product'' :: [Int] -> Int
{-
This states that the function product'' takes a list of integers and returns a
singe integer.

STEP 2: ENUMERATE THE CASES
For most types of argument, there are a number of standard cases to consider.
For lists, the standard cases are the empty list and non-empty lists, so we can
write down the following skeleton definition using pattern matching:

  product'' [] =
  product'' (x:xs) =

Standard Cases:
  > Non-negative integers => 0 and n
  > Logical values => False and True
  >
As with the type we my need to refine the cases later on, but it is useful to
begin with with the standard cases.

STEP 3: DEFINE THE SIMPLE CASES
By definintion the product of zero integers is one, because one is the
identity for multiplication. Hence, it is straight forward to define the empty
list case:
-}
product'' [] = 1
{-
As in this example, the simple cases often become base cases.

STEP 4: DEFINE THE OTHER CASES
How can we calculate the product of a non-empty list of integers? For this step
it is useful to first consider the ingredients that can be used, such as the
function itself (product''), the arguments (n and ns), and library functions of
relevant types (+, -, * and so on.) In this case, we simply multiply the first
integer and the product of the remaining list of integers:
-}
-- product'' [] = 1
product'' (n:ns) = n * product'' ns
{-
As in this example, the simple cases often become the recursive cases.

STEP 5: GENERALISE AND SIMPLIFY
Once a function has been defined using the steps above, it often becomes clear
that it can be generalised and simplified. For example, the function product
does not depend on the precise kind of numbers on which it is applied, so its
type can be generalised from integers to any numeric type:

  product'' :: Num a => [a] -> a

In terms of simplification, we will see in chapter 7 that the pattern of
recursion used here is found in the library function foldr, using which product
can be redefined into a single equation:
-}
product''' :: Num a => [a] -> a
product''' = foldr (*) 1
{-
The book then goes through the same process for the function drop.

Exercises

1) How does the recursive version of the factorial function behave if applied to
a negative arguement such as (-1)? Modify the definition to prohibit negative
arguments by adding a guard to the recursive case.
  > fac (-1)
  1
  > fac (-3)
  1
-}
fac'' :: Int -> Int
fac'' 0 = 1
fac'' n | n <= 0    = error "factorial of a negative int not included"
       | otherwise = n * fac'' (n-1)
{-
2) Define a recursive function sumdown :: Int -> Int that returns the sum of the
non-negative integers from a given value down to zero. For example:
  >sumdown 3
  {3+2+1=} 6
-}
-- 1 Define the type
sumdown :: Int -> Int
-- 2 Enumerate the cases
--sumdown 0 =
--sumdown n =
-- 3 Define the simple cases
sumdown 0 = 0
-- 4 Define the other cases
sumdown n = n + sumdown (n-1)
-- 5 Generalise and simplify
-- works fine
{-
3) Define the exponentiation operator for non-negative integers using the same
pattern of recursion as the multiplication operator, and show that how the
expression 2^3 is evaluated by your expression.

(^) :: Int -> Int -> Int
_ ^ 0 = 1
x ^ 1 = x
x ^ n = x * (x ^ (n-1))
-}
power :: Int -> Int -> Int
_ `power` 0 = 1
x `power` 1 = x
x `power` n = x * (x `power` (n-1))
{-
  >2 ^ 3
{2 * 2 ^ (3-1)}
applying (-)
{2 * 2 ^ 2}
applying (^)
{2 * 2 * 2 ^ (2-1)}
applying (-)
{2 * 2 * 2 ^ 1}
applying power base case x^1 =x
{2 * 2 * 2 }
applying *
>8

4) Define a recursive function euclid Int -> Int -> Int that implements Euclid's
algorithm for calculating the greatest common divisor of two non-negative
integers:
  > If two numbers are equal, this number is the result;
  > otherwise, the smaller number is subtracted from the larger, and the same
  process is then repeated.
-}
-- 1 define the type
euclid :: Int -> Int -> Int
-- 2 enumerate the cases
euclid 0 _             = error "wassup"
euclid _ 1             = 1
euclid x y | x == y    = x
           | x > y     = euclid y (x - y)
           | otherwise = euclid x (y - x)
{-
euclid 6 27
euclid 6 21
euclid 6 15
euclid 6 9
euclid 6 3
euclid 3 3

5) Using the recursive definitions given in this chapter, show how
length [1,2,3], drop 3 [1,2,3,4,5], init [1,2,3] are evaluated.

>length [1,2,3]
{applying length}
1 + length [2,3]
{applying length}
1 + 1 + length[3]
{applying length}
1 + 1 + 1 + length[]
{applying length}
1 + 1 + 1 + 0
{applying +}
3

>drop 3 [1,2,3,4,5]
{applying drop}
drop (3-1) [2,3,4,5]
{applying - }
drop 2 [2,3,4,5]
{applying drop}
drop (2-1) [3,4,5]
{applying - }
drop 1 [3,4,5]
{applying drop}
drop (1-1) [4,5]
{applying - }
drop 0 [4,5]
{applying drop and using base case}
[4,5]


init :: [a] -> [a]
init [_] =  []
init (x:xs) = x : init xs

> init [1,2,3]
{applying init}
1 : init [2,3]
{applying init}
1 :( 2 : init[3])
{applying init using base case}
1 : ( 2 : [])
{applying : }
1 : ([2])
{applying : }
[1,2]


6) Without looking at the definitions in the standard prelude, define the
following library functions on lists using recursion.

  a)  Decide if all logical values in a list are True:
      and :: [Bool] -> Bool
-}
and' :: [Bool] -> Bool
and' [True] = True
and' (x:xs) | x == True = and' xs
            | otherwise = False
{-
  b)  Concatenate a list of lists
      concat :: [[a]] -> [a]
-}
concat' :: [[a]] -> [a]
concat' [] = []
concat' (xs:xss) = xs ++ concat' xss
{-
  c)  produce a list of n identical elements
      replicate :: Int -> a -> [a]
-}
replicate' :: Int -> a -> [a]
replicate' 0 _ = []
replicate' n x = x : replicate' (n-1) x
{-
  d)  Select the nth element of a list:
      (!!) :: [a] -> Int -> a
-}
nth :: [a] -> Int -> a
nth [] _ = error "cannot find the nth element of the empty list"
nth (x:_) 1 = x
nth (x:xs) n = nth xs (n-1)
{-
  e)  Decide if a value is an element of a list:
      elem :: Eq a => a -> [a] -> Bool
-}
elem' :: Eq a => a -> [a] -> Bool
elem' a [] = False
elem' a (x:xs) | a == x    = True
               | otherwise = elem' a xs
{-
7)  Define a recursive function merge :: Ord a => [a] -> [a] -> [a] that merges
two sorted lists to give a single sorted list.
-}
merge :: Ord a => [a] -> [a] -> [a]
merge [] [ys] = [ys]
merge [xs] [] = [xs]
merge [] [] = []
merge (x:xs) (y:ys) = x :( y : merge xs ys)
{-
8) Using merge, define a function msort :: Ord a=> [a] -> [a] that implements
merge sort, in which an empty list and singleton lists are already sorted, and
any other list is sorted by merging together the two lists that result from
sorting the two halves of the list separately.

Hint: First define a function halve :: [a] -> ([a],[a]) that splits a list into
two halves whose lengths differ by at most one.
-}
halve :: [a] -> ([a],[a])
halve xs = (splitAt hl xs) where hl = (length xs) `div` 2

msort :: Ord a => [a] -> [a]
msort [] = []
msort [x] = [x]
msort xs = merge (msort first) (msort second)
  where
    first = fst (halve xs)
    second = snd (halve xs)

-- INCOMPLETE
{-
9)  Using the 5 step process, construct the library functions that:
  a)  calculate the sum of a list of numbers
-}
sum' :: Num a => [a] -> a
sum' [] = 0
sum' [x] = x
sum' (x:xs) = x + sum' xs
{-
  b)  take the given number of elements from the start of a list
-}
take' :: Int -> [a] -> [a]
take' 1 (x:_) = [x]
take' n (x:xs) = x : (take' (n-1) xs)
{-
  c)  select the last element from a non-empty list
-}
last' :: [a] -> a
last' [x] = x
last' (x:xs) = last' xs
