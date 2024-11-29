local plr = game.Players.LocalPlayer
local whitelist = {
	105111491,
	2981703917,
}

if not (table.find(whitelist, plr.Name) or table.find(whitelist, plr.UserId)) then
	plr:Kick("mmm... i can feel them wriggling .., <3")
end
