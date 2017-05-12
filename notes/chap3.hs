{-
Chapter 3 - Types and Classes

3.2 Basic types

Haskell includes a number of basic types. They include:
Bool - contains True or False
Char - contains all characters in the Unicode system
String - a string of characters that must be enclosed in "double quotes"
Int - contains integers with a fixed amount of memory from -2^63 to 2^63
Integer - contains integers with as much memory as is needed
Float - contains numbers with a decimal point and using a fixed memory alloc
Double - contains floats with double precision

3.3 List types
A list is a sequence of elements of the same type, with elements enclosed in
square parentheses and delimited by commas.
  [False, True, False] :: [Bool]
  ['a','b','c'] :: [Char]

We can also have lists of lists, their type being given as
  [['a','b'],['c','d']] = [[Char]]

3.4 Tuple Types
Tuples are finite sequences of components that can be of different types.

3.5 Function Types
Functions map arguments of one type to results of another type.
For example
  not :: Bool -> Bool
  even :: Int -> Bool

There is no requirement that functions must be total on their arguement type.
For example:
  >head []
  *** Exception: Prelude.head: empty list

3.6 Curried functions
Functions that take multiple arguments can also be hndled in another, perhaps
less obvious way, by exploiting the fact that functions are free to return
functions as results. For example:
-}
add' :: Int -> (Int -> Int)
add' x y = x + y
{-
This type statres that add' takes an argument of type Int and returns a result
that is a function of type Int -> Int. The definition itself states that add'
takes an integer x followed by an integer y, and returns the result of x + y.

3.7 Polymorphic types
Take the example of the library function length, it can be used on lists of any
type and has the type
  length :: [a] -> Int
That is, for any type a, the function length has type [a] -> Int.
A type that contains onre or more type variables is called polymorphic.
Hence, [a] -> Int is polymorphic and length is a polymorphic function.

3.8 Overloaded Functions
Class contraints are written in the form C a where C is the name of the class
and a is a type variable. For example:
  (+) :: Num a => a -> a -> a
This specifies that a must be of the class Num of numeric types.
A type with one or more class constraints is called overloaded.

3.9 Basic classes
Recall that a type is a collection of related values. Building on this notion, a
class is a collection of types that support certain overloaded operations called
methods.

Haskell provides a number of built in types.

Eq - equality types
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool

All the basic types are instances of the Eq class,
  >False == False
  True
  >'a' == 'b'
  False
  >[1,2] == [1,2,3]
  False

Note that function types are not in general instances of the Eq class, because
it is not feasible in general to compare two functions for equality.

Ord - ordered types
This class contains instances of the Eq class, but whose members are linearly
ordered. As such, they can be compared using the following methods.
  (<) :: a -> a -> Bool   (less than)
  (>) :: a -> a -> Bool   (more than)
  (<=) :: a -> a -> Bool   (less than or equal to) equals always used second to
  (>=) :: a -> a -> Bool   (more than or equal to) avoid confusion with => arrow
  (min) :: a -> a -> a    (true if first is minimum value)
  (max) :: a -> a -> a    (true if first is maximum value)

All the basic types can be instances of the Ord class, given that their
element and component types are instances. For example
  >False < True
  True
  >min 'a' 'b'
  True

Show - showable types
This class contains types whose values can be converted to strings using the
method:
  show :: a -> String

Again, all the basic types are instances of the Show class.
As are list types and tuple types, given that their element and component types
are instances of the Show class.
For example:
  >show ('a', False)
  "('a', False)"

Read - readable types
Readable types are the dual to showable types, i.e. their values can be
converted from strings using the method:
  read :: String -> a

Num - numeric types
This class contains types whose values are numeric, and as such can be processed
using the following six methods:
  (+) :: a -> a -> a  (addition operator)
  (-) :: a -> a -> a  (subtraction operator)
  (*) :: a -> a -> a  (multiplication operator)
  negate :: a -> a    (returns the negative of a number)
  abs :: a -> a       (returns the absolute of a number)
  signum :: a -> a    (returns the sign of a number -1, 0, 1)

Integral - integral types
This class contains types that are instances of the numeric class Num but whose
values are also integers. As such they support the methods of integer division
and integer remainder:
  div :: a -> a -> a
  mod :: a -> a -> a

In practice these operators are often written between their two arguements using
`backquotes`.
  >7 `div` 2
  3
  >7 `mod` 2
  1

Fractional - fractional types
This class contains types that are instances of the numebric class Num, but
also whose values are non-integral, as such they support fractional division and
fractional reciprocation.
  (/) :: a -> a -> a
  recip :: a -> a

  >7.0 / 2.0
  3.5
  >recip 2.0
  0.5

Exercises

1) What are the following types of value?
  ['a','b','c'] :: [Char]
  ('a','b',c') :: (Char, Char, Char)
  [(False, '0'),(True, '1')] :: [(Bool,Char)]
  ([False, True],['0','1']) :: ([Bool], [Char])
  [tail, init, reverse] :: [[a] -> [a]]

2) Dont care
3) What are the types of the following functions?
-}

second xs = head (tail xs)
-- second :: [a] -> a
swap (x,y) = (y,x)
-- swap :: (t1, t) -> (t, t2)
pair x y = (x, y)
-- pair :: t1 -> t -> (t1, t)
double x = x*2
-- double :: Num a => a -> a
palindrome xs = reverse xs == xs
-- palindrome :: Eq a => [a] -> Bool  (RMEMBER THE EQUALITY CLASS REQ)
twice f x = f (f x)
-- twice :: (t -> t) -> t -> t
