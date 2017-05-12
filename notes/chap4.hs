{-
Chapter 4 - Defining Functions

This section covers defining functions, starting with conditional expressions
and guarded equations, then moving onto pattern matching and lambda expression.

4.1 New from old
A simple way of making new functions is through re-use of old ones. For example:
-}
-- Decide if an integer is odd or even
even' :: Integral a => a-> Bool
even' n = n `mod` 2 == 0

--Split a list at the nth element:
splitAt' :: Int -> [a] -> ([a],[a])
splitAt' n xs = (take n xs, drop n xs)

-- Reciprocation
recip' :: Fractional a => a -> a
recip' n = 1/n

{-
4.2 Conditional Expressions
if else statements etc, basic init
for example signum function from standard prelude can be defined as:
-}
signum' :: Int -> Int
signum' n = if n<0 then -1 else
              if n>0 then 1 else
                0
{-
4.3 Guarded Equations
An alternative to conditional expressions, guarded equations have a simpler
notation, using the | guard operatoe which can be read as "such that".
For example:
-}
signum'' :: Int -> Int
signum'' n | n < 0 = 1
           | n > 0 = -1
           | otherwise = 0
{-
4.4 Pattern Matching
Many functions have a simple and intuitive definition using pattern matching.
For example, the library function not could be defined as:
-}
not' :: Bool -> Bool
not' False = True
not' True = False
{-
or the logical operator && could be defined as
  (&&) :: Bool -> Bool -> Bool
  True && True = True
  _ && _ = False

This also has the benefit that under lazy evaluation, if the first value is
read as false then the system will return false without checking the second.
In reality, the system uses a slightly different definition:
  True && b = b
  False && _ = False

Tuple Patterns
A tuple of patterns is itself a pattern, for example, the library functions fst
and snd are defined as follows
  fst :: (a,b) -> a
  fst (x,_) = x

  snd :: (a,b) -> b
  snd (_,y) = y

List Patterns
Similarly, a list of patterns is itself a pattern. For example, a function test
which tests decides if a list containst precisely three characters, beginning
with the letter a, can be defined as:
-}
test :: [Char] -> Bool
test ['a',_,_] = True
test _ = False

{-
Up to this point, we have viewed lists as a primitive notion in Haskell. In fact
they are not primitive as such, but are constructed one element at a time
starting at the empty list.
  [1,2,3]
= {list notation}
  1: [2,3]
= {list notation}
  1 :(2 :[3])
= {list notation}
  1:(2:(3:[]))

As well as being used to construct lists, the cons operator  : can be used to
construct patterns, for example, we can now define a more general verson of the
function test  that decides if a list containing any number of characters starts
with the character 'a':
-}
test' :: [Char] -> Bool
test' ('a':_) = True
test' _ = False
{-
Now test ['a'..'z'] returns False but test' ['a'..'z'] returns True.

Similarly, the library functions of head and tail can be similarly defined:
-}
head' :: [a] -> a
head' (x:_) = x

tail' :: [a] -> [a]
tail' (_:xs) = xs
{-
Note that cons patterns must be parenthesised, because function application has
higher priority than all other operators in the language.

4.5 Lambda expressions
Functions can also be defined using lambda expressions. They comprise of a
pattern for each of the arguments, a body that specifies how the result can be
calculated in terms of the arguments, but do not give a name for the function
itself.
In other words, lambda functions are nameless functions.
For example, the nameless function that doubles x is given by
  >(\x -> x + x) 2
= 4
They can be used to formalise the meaning of curried function definitions, for
example, the definition
  add :: Int -> Int -> Int
  add x y = x + y
can be understood as meaning
  add :: Int -> (Int -> Int)
  add = \x -> (\y -> x + y)
which makes precise that add is a function that takes an integer x and returns a
function which in turn takes an integer y and returns the result x + y.

Secondly, lambda expressions are useful for defining functions that return
functions as results by their nature rather than as a result of currying.
For example, the library function const that always returns a constant function
  const :: a -> b -> a
  const x _ = x
however it is preferred to define it so that it is explicit that it returns a
function, and to use lambdas as the definition
  const :: a -> (b -> a)
  const x = \_ -> x
an example of this function's use could be to create a list of zeros with length
n.
  map (const 0) [0..n-]

Finally, a lambda expression can be used to avoid having to name a function that
is only referred to once in a program. For example:  the function odds that
returns the first n odd integers can be defined as follows:
-}
odds :: Int -> [Int]
odds n = map f [0..n-1]
         where f x = x*2 +1
{-
This could be similarly defined without the need for the local function f:
-}
odds' :: Int -> [Int]
odds' n = map (\x -> x*2 +1)[0..n-1]
{-
4.6 Operator Sections
Functions such as  + that are written between their two arguments are called
operators. We have seen that aniy function with two arguments can be conberted
to an operator by enclosing it in `backquotes`.
However, the converse is also possible, for example:
  >(+) 1 2
= 3
By enclosing the operator in parentheses, we can place it at the start of the
expression.

In general, if (#) is an operator, then expressions of the form (#), (x #) and
(# y) for arguments x and y are called sections, whose meaning as functions can
be formalised using lambda expressions as follows:

  (#) = \x -> (\y -> x # y)
  (x #) = \y -> x # y
  (# y) = \x -> x # y

Sections have three primary applications. First of all, they can be used to
construct simple but useful functions in a particularly compact way, as shown
in the following examples:

  (+) = \x ->(\y -> x + y) addition function
  (1+) = \y -> (1 + y) successor function
  (1/) = \y -> (1 / y) reciprocal function
  (*2) = \x -> (x *2) doubling function
  (/2) = \x -> (x /2) halving function

Secondly, sections are necessary when stating the type of operators, because an
operator itself is not a valid expression in Haskell. For example, the type of
the addition operator + for integers is stated as follows:
  (+) :: Int -> Int -> Int

Finally, sections are also necessary when using operators as arguments to other
functions. For example, the library function sum that calculates the sum of a
list of integers cam be defined by using the operator + as an argument to the
library function foldl, which is itself discussed in chap 7:
  sum :: [Int] -> Int
  sum = foldl (+) 0

Exercises
1) Using library functions, define a function halve :: [a]-> ([a],[a]) that
splits an even lengthened list into two halves.
-}
halve :: [a] -> ([a],[a])
halve xs = (take n xs, drop n xs)
          where
            n = length xs `div` 2
{-
2) Define a function third :: [a] -> a that returns the third member of a list,
ensuring it contains at least that many elements.
-}
-- a) using head and tail library functions
third :: [a] -> a
third [] = error "List must have three elements"
third [_] = error "List must have three elements"
third [_,_] = error "List must have three elements"
third xs = head(tail(tail(xs)))

-- b) using list indexing !!
third' :: [a] -> a
third' [] = error "List must have three elements"
third' [_] = error "List must have three elements"
third' [_,_] = error "List must have three elements"
third' xs = xs !! 2

-- c) using pattern matching
third'' :: [a] -> a
third'' [] = error "List must have three elements"
third'' [_] = error "List must have three elements"
third'' [_,_] = error "List must have three elements"
third'' (_:_:x:_) = x
{-
3) Consider a function safetail :: [a] -> [a] that behaves in the same way as
tail except that it maps the empty list to itself rather than producing an
error. Using tail and the function null : [a] -> Bool that decides if a list is
empty or not, define safetail using:
-}
-- a) a conditional expression
safetail :: [a] -> [a]
safetail xs = if null xs then xs
              else tail(xs)

-- b) guarded equations
safetail' :: [a] -> [a]
safetail' xs | null xs = xs
             | otherwise = tail xs

-- c) pattern matching
safetail'' [] =[]
safetail'' xs = tail xs
{-
4) In a similar way to && in 4.4, show how the disjunction operator || can be
defined in four different ways using pattern matching.
|| tests to see if there is a true  in the two arguments

(||) :: Bool -> Bool -> Bool
True || True = True
True || False = True
False || True = True
False || False = False

False || False = False
_ || _ = True

True || b = True
a || True = True
False || False = False

b || b = b
a || b = True

5) Without using any other library functions or operators, show how the meaning
of the following pattern matching definition for logical conjunction && can be
formalised using conditional expressions:
  True && True = True
  _ && _ = False

(&&) a b = if a = True
              then if b = True then = True
           else False

6) Do the same for the following alternative definition, and not the difference
in the number of conditional expressions that are required:
  True && b = b
  False && _ = False

(&&) a b = if a = True then b
           else False

7) Show how the meaning of the following curried function definition can be
formalised in terms of lambda expressions:
  mult :: Int -> Int -> Int -> Int
  mult x y z  = x * y* z
-}
mult :: Int -> (Int -> (Int -> Int))
mult  = \x ->(\y -> (\z -> x * y * z))
{-
8) The Luhn algorithm is used to check bank card numbers for simple typing
errors such as mistyping a digit, and proceeds as follows:
  > consider each digit as a separate number;
  > moving left, double every other number from the second last;
  > subtract 9 from each number that is now greater than 9;
  > add all the resulting numbers together;
  > if the total is divisible by 10, the card number is valid.

Define a function luhnDouble :: Int -> Int that doubles a digit and subtracts 9
if the result is greater than 9.
-}
luhnDouble :: Int -> Int
luhnDouble x | (x * 2) > 9 = (x*2)-9
             | otherwise = (x*2)
{-
Using luhnDouble and the integer remainder function mod, define a function
luhn :: Int -> Int -> Int -> Int -> Bool that decides if a four digit bank card
number is valid.
-}
luhn :: Int -> Int -> Int -> Int -> Bool
luhn a b c d | (luhnDouble a +  b + luhnDouble c +  d) `mod`10 == 0 =True
             | otherwise = False
