module Reverse where

rvs :: String -> String
rvs x = drop 9 x ++ " is " ++ take 5 x


main :: IO ()
main = print $ rvs "curry is awesome"