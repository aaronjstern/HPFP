
-- 8 isPalindrome
isPalindrome :: (Eq a) => [a] -> Bool
isPalindrome x = x == reverse x

-- 9 myAbs
myAbs :: Integer -> Integer
myAbs x = if x > 0 then x else x + (-2) * x

-- 10
f :: (a, b) -> (c, d) -> ((b, d), (a, c))
f (a, b) (c, d) = ((snd (a, b), snd (c, d)), (fst (a, b), fst (c, d)))

--correcting syntax

-- 1
x = (+)

q xs = x w 1
    where w = length xs

-- 2
a z = z

-- 3
c (a, b) = fst (a, b)
