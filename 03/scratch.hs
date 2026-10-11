
{-
d out of scope example
area d = pi * (r * r)
r = d / 2
-}

area d = pi * (r * r)
    where
        r = d / 2
