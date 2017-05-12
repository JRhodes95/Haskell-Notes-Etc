-- 2015 PP Paper

-- Question 1
-- a)
-- given is the following code fragment
positives = 1 : map (+1) positives

myFunc :: Int -> Int
myFunc n = foldr (*) 1 ( take n positives )

-- write down a signature for the function positives


--------------------------------------------------------------------------------

-- Question 2
-- a) Haskell provides the function zip. The inverse of zip is unzip.
-- Give the signature of the function unzip.

unzip' ::  [(a,b)] -> ([a],[b])

-- b) give an implementation of the function unzip

unzip' [] = ([],[])
unzip' ((a,b):xs) = (a: fst rest b: snd rest)
  where rest = unzip xs
