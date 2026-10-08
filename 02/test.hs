sayHello :: String -> IO ()
sayHello x =
    putStrLn ("Hello, " ++ x ++ "!")
    
triple x = x * 3

piFunction x = 3.14 * (x * x)
