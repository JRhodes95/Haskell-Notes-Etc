doubleMe x = x + x

doubleUs x y = x*2 + y*2

doubleUsToo x y = doubleMe x + doubleMe y

doubleSmall x = if x > 100
  then x
  else x*2

lucky :: (Integral a) => a -> String
lucky 7 = "Lucky number 7"
lucky x = "sorry, you're not a winner"

length' xs = sum [1| _ <- xs]
