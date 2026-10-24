data Pair a = Pair a a deriving Show

swap :: Pair a -> Pair a
swap (Pair x y) = Pair y x

same :: Eq a => Pair a -> Bool
same (Pair x y) = x == y

data Shape a = Square a | Rect a a deriving Show

area :: Num a => Shape a -> a
area (Square s) = s * s
area (Rect w h) = w * h
