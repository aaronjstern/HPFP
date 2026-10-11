-- 2
funcA x =  x ++ "!"

funcB x = x !! 4

funcC x = drop 9 x

-- 3
thirdLetter :: String -> Char
thirdLetter x = x !! 2

--4
letterIndex :: Int -> Char
letterIndex x = "Curry is awesome!" !! x

--5

rvs :: String -> String
rvs x = drop 9 x ++ " is " ++ take 5 x