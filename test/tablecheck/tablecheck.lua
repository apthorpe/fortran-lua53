-- Locals

-- v1 is a table
local lv1 = {}

-- Globals

-- gv1 is an empty table
gv1 = {}

-- gv2a is an integer array
gv2a = { 5, 4, 3, 2, 1 }

-- gv2b is an integer array identical to gv2a
gv2b = { 5; 4; 3; 2; 1 }

-- gv2c is an integer array identical to gv2a
gv2c = { 5, 4; 3; 2, 1; }

-- gv2d is an integer array identical to gv2a
gv2d = { 5; 4; 3, 2, 1, }

-- gv3a is a dict
gv3a = { ["a"] = 5, ["b"] = 4, ["c"] = 3, ["d"] = 2, ["e"] = 1 }

-- gv3b is a dict identical to gv3a
gv3b = { a = 5, b = 4, c = 0, d = 2, e = 1 }
gv3b.c = 3

-- -- gv3c is a dict identical to gv3a
-- gv3c = { ["a"] = 5, b = 4; "c" = 3, d = 2; ["e"] = 1; }

-- gv4a is a mixed array
gv4a = { "Hydraulic pump", 124.95, -2, "Backordered", { bearings = 2, seals = 8, impeller = 1 }, false }

-- gv4b is a mixed array
gv4b = { "Hydraulic pump", 124.95, -2, status = "Backordered", partslist = {bearings = 20, seals = 8, impeller = 1 }, false }
gv4b.partslist.bearings = 2


