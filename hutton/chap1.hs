--Hutton Chapter 1

--double a number
double x = x + x
double' x = x*2

--quadruple a number
quadruple x = double (double x)
quadruple' x = double' (double' x)
quadruple'' x = x*4

--sum a list of numbers
mySum [] = 0
mySum (n:ns) = n + sum ns


-- qsort sorts a list in numerical order
-- it has no effect on a single numbered list
qsort [] = []
qsort(x:xs) = qsort smaller ++ [x] ++ qsort larger
  where
    --smaller a is a set of the numbers in xs which smaller than or equal to x
    smaller = [a | a <-xs, a<=x]
    --larger is a set numbers in xs which has numbers larger than x
    larger = [b | b <- xs, b>x]
--qsort then concatenates the lists

--the product of an empty list is 0
myProduct [] = 0
--the product of a list x:xs is x times the product of xs
myProduct (x:xs) = 1 * x * product xs

--sort numbers into reverse order
rev_qsort [] = []
rev_qsort (x:xs) = rev_qsort smaller ++ [x] ++ rev_qsort larger
  where
    --smaller a is a set of the numbers in xs which larger than or equal to x
    smaller = [a | a <-xs, a>=x]
    --larger is a set numbers in xs which has numbers smaller than x
    larger = [b | b <- xs, b<x]
    --qsort then concatenates the lists
