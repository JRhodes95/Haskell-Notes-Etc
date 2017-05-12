--Hutton Ch2

--test.hs

-- check these work in the ghci
-- double x = x + x
--quadruple x = double(double x)
-- factorial n = product [1..n]
-- average ns = sum ns `div` length ns

--fix the syntax to make the function work
num = a `div` length xs
  where
    a = 10
    xs = [1,2,3,4,5]


-- make a new function to find the last element in a list
myLast [] = []
myLast x = drop y x
  where
    y = length x - 1

--myLast' [] = []
--myLast' xs = myLast'(tail xs)


-- remake init in two other ways
myInit reverse.drop 1.reverse
myInit' xs = take (length xs - 1) xs
