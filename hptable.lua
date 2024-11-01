local result = {}
local startValue = 1100
local endValue = 851
local suffixes = {3000, 4200, 1200}

for i = startValue, endValue, -1 do
    for _, suffix in ipairs(suffixes) do
        table.insert(result, tostring(i) .. "/" .. tostring(suffix))
    end
end

return result
