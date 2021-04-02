-- Locals

-- v1 is an integer
local lv1 = -12
-- v2 is a real
local lv2 = 0.25
-- v3 is a string
local lv3 = "onion"
-- v4 is a table
local lv4 = {}
-- v5 is a function
local lv5 = function () print("onion") end
-- v6 is a boolean
local lv6 = false
-- v7 is nil
local lv7 = nil

lv5()

-- Globals

-- gv1 is an integer
gv1 = -12
-- gv2 is a real
gv2 = 0.25
-- gv3 is a string not translateable as a number
gv3 = "parfait"
-- gv4 is a table
gv4 = {}
-- gv5 is a function
gv5 = function () print("parfait") end
-- gv6 is a boolean
gv6 = false
-- gv7 is nil
gv7 = nil

-- gv8 doesn't exist; treated as nil

-- gv9 is a string translatable as a (real) number
gv9 = "-0.5"
-- gv10 is a string translatable as a number (integer)
gv10 = "+7"
-- gv11 is a string translatable as a number (integer formatted as a real)
gv11 = "262.00000"

-- fibonacci.lua
function fib(n)
    if n == 1 or n == 2 then
       return 1, 1
    end
    prev, prevPrev = fib(n - 1)
    return prev + prevPrev, prev
 end
gv12 = fib

gv5()
