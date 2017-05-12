add' :: Int -> (Int -> Int)
add' x y = x+y

myLast :: [a] -> a
myLast [] = error "No end for empty lists!"
myLast [x] = x
myLast (_:xs) = myLast xs
