module Print3Flipped where

myGreeting :: String
myGreeting = (++) "hellow" " world!"

hello :: String
hello = "hello"

world :: String
world = "world!"

main :: IO ()
main = do
    putStrLn myGreeting
    putStrLn secondGreeting
    where secondGreeting =
            (++) hello ((++) " " world)
