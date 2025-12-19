pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	cls(0)
	mode="start"
	blinkt=1	--blink time
	
	star_red={x=40,y=60,col=8}	--objects
end


function _update()
	blinkt+=1

	if mode=="game" then
		update_game()
	elseif mode=="start" then
		--start screen--
		update_start()
	elseif mode=="over" then
		update_over()
	end
end


function _draw()
	if mode=="game" then
		draw_game()
	elseif mode=="start" then
		--start screen--
		draw_start()
	elseif mode=="over" then
		draw_over()
	end
end


function startgame()
	mode="game"
	
	ship={}
	ship.x=64
	ship.y=64
	ship.spdx=0
	ship.spdy=0
	ship.spr=2	--⬅️➡️ sprite shift

	flamespr=5	--backward flame
	
	bulx=64
	buly=-10
	
	muzzle=0	--shooting flame
	
	score=0
	
	lives=3
	
	--star stuff--
	--[[
	starx={}
	stary={}
	starspd={}
	for i=1,100 do
		add(starx,flr(rnd(128)))
		add(stary,flr(rnd(128)))
		add(starspd,rnd(1.5)+.5)
	end
	]]
	
	stars={}	--star obj
	for i=1,100 do
		local newstar={}
		newstar.x=flr(rnd(128))
		newstar.y=flr(rnd(128))
		newstar.spd=rnd(1.5)+.5
		add(stars,newstar)
	end
	
	buls={}	--bullet obj
	
	enemies={}	--enemy obj
	
	spawnen()
end

-->8
--helpers--

function starfield()
	--old stuff--
	--[[
	for i=1,#starx do
		local scol=6	--star color
		if starspd[i]<1 then
			scol=1
		elseif starspd[i]<1.5 then
			scol=13
		end
		pset(starx[i],stary[i],scol)
	end
	]]
	
	--new stuff--
	for i=1,#stars do
		local mystar=stars[i]
		local scol=6
		
		if mystar.spd<1 then
			scol=1
		elseif mystar.spd<1.5 then
			scol=13
		end
		pset(mystar.x,mystar.y,scol)
	end
end

function animatestars()
	--old way--
	--[[
	for i=1,#stary do
		local sy=stary[i] 
		sy+=starspd[i]
		
		if sy>128 then
			sy-=128
		end
		stary[i]=sy
	end
	]] 
	
	--new way--
	for i=1,#stars do
		local mystar=stars[i]
		mystar.y+=mystar.spd
		if mystar.y>128 then
			mystar.y-=128
		end
	end
	
end


function blink()
	--use the tabe to control blink time--
	local banim={5,5,5,5,5,6,6,7,7,6,6,5,5}
	
	if blinkt>#banim then
		blinkt=1
	end
	return banim[blinkt]
end


function drwmyspr(myspr)
	spr(myspr.spr,myspr.x,myspr.y)
end


function col(a,b)
	--lots of math
	local a_left=a.x
	local a_top=a.y
	local a_right=a.x+7
	local a_bottom=a.y+7
	
	
	local b_left=b.x
	local b_top=b.y
	local b_right=b.x+7
	local b_bottom=b.y+7
	
	if a_top>b_bottom then
		return false
	end
	if b_top>a_bottom then
		return false
	end
	if a_left>b_right then
		return false
	end
	if b_left>a_right then
		return false
	end
	
	return true
end

function spawnen()
	local myen={}
	myen.x=rnd(120)
	myen.y=-8
	myen.spr=21
	add(enemies,myen)
end
-->8
--update--

function update_game()
	--controls--
	ship.spdx=0
	ship.spdy=0
	ship.spr=2
	
	if btn(⬅️) then
		ship.spdx=-2
		ship.spr=1
	end
	if btn(➡️) then
		ship.spdx=2
		ship.spr=3
	end
	if btn(⬆️) then
		ship.spdy=-2
	end
	if btn(⬇️) then
		ship.spdy=2
	end
	if btnp(🅾️) then
		local newbul={}
		newbul.x=ship.x
		newbul.y=ship.y-3
		--==newbul={x=shipx,y=shipy-3}
		newbul.spr=16
		add(buls,newbul)
		
		--bulx=shipx
		--buly=shipy-3
		sfx(0)
		muzzle=6
	end
	
	--moving the ship--
	ship.x+=ship.spdx
	ship.y+=ship.spdy
	
	--checking if we hit the edge
	if ship.x>120 then
		ship.x=120
	end
	if ship.x<0 then
		ship.x=0
	end
	if ship.y>120 then
		ship.y=120
	end
	if ship.y<0 then
		ship.y=0
	end
	
	--moving the bullet--
	for i=#buls,1,-1 do
		local mybul=buls[i]
			--buly-=4
		mybul.y-=4
		
		if mybul.y<-8 then	--remove the bullet avoid piling up
			del(buls,mybul)
		end
	end
	
	--moving the enemies
	for myen in all(enemies) do
		myen.y+=1
		--myen.x+=rnd()
		myen.spr+=.4
		if myen.spr>=25 then
			myen.spr=21
		end
		
		if myen.y>128 then
			del(enemies,myen)
		end
	end
	
	--collision bullet x enemies
	for myen in all(enemies) do
		for mybul in all(buls) do
			if col(myen,mybul) then
				del(enemies,myen)
				del(buls,mybul)
				sfx(2)
				spawnen()
			end
		end
	end
	
	--collision ship x enemies
	for myen in all(enemies) do
		if col(myen,ship) then
			lives-=1
			sfx(1)
			del(enemies,myen)
		end
	end
	
	if lives<=0 then
		mode="over"
		return
	end
	
	--animate flame--
	flamespr+=1
	if flamespr>9 then
		flamespr=5
	end
	
	--animate muzzle flash--
	if muzzle>0 then
		muzzle-=1
	end

	
	animatestars()
end	


function update_start()
	if btnp(🅾️) then
		startgame()
	end
end

function update_over()
	if btnp(🅾️) then
		mdde="start"
	end
end
-->8
--draw--

function draw_game()
	cls(0)
	starfield()
	drwmyspr(ship)
	--spr(shipspr,shipx,shipy)	--ship
	spr(flamespr,ship.x,ship.y+8)	--backward flame
	
	--drawing enemies--
	for myen in all(enemies) do
		drwmyspr(myen)	--enemies
	end
	
	--drawing bullet--
	for mybul in all(buls) do
		drwmyspr(mybul)	--bullet
	end
	
	if muzzle>0 then
		circfill(ship.x+3,ship.y-2,muzzle,7)
	end
	
	print("score:"..score,40,1,12)
	
	for i=1,4 do
		if lives>=i then
			spr(13,i*9-8,1)
		else 
			spr(14,i*9-8,1)
		end
	end
	
	print(#buls,5,5,7)
end


function draw_start()
	cls(1)
	print("awesome shump",34,40,12)
	print("press 🅾️ to start",30,80,blink())
end

function draw_over()
	cls(1)
	print("game over",50,40,2)
	print("press 🅾️ to restart",30,80,blink())
end
__gfx__
00000000000220000002200000022000000000000000000000000000000000000000000000000000000000000000000000000000088008800880088000000000
000000000028820000288200002882000000000000077000000770000007700000c77c0000077000000000000000000000000000888888888008800800000000
007007000028820000288200002882000000000000c77c000007700000c77c000cccccc000777700000000000000000000000000888888888000000800000000
0007700002888e2002e88e2002e88e200000000000cccc00000cc00000cccc0000cccc0000c77c00000000000000000000000000888888888000000800000000
00077000027c88202e87c8e20288c72000000000000cc000000cc000000cc00000000000000cc000000000000000000000000000088888800800008000000000
007007000211882028811882028811200000000000000000000cc000000000000000000000000000000000000000000000000000008888000080080000000000
00000000025522200285582002225520000000000000000000000000000000000000000000000000000000000000000000000000000880000008800000000000
00000000002992000029920000299200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000330033003300330033003300330033000000000000000000000000000000000000000000000000000000000
09aaaa900000000000000000000000000000000033b33b3333b33b3333b33b3333b33b3300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000003bbbbbb33bbbbbb33bbbbbb33bbbbbb300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000003b7717b33b7717b33b7717b33b7717b300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000b7117b00b7117b00b7117b00b7117b000000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000037730000377300003773000037730000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000303303003033030030330300303303000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000300003030000003030000300330033000000000000000000000000000000000000000000000000000000000
__sfx__
000100003555033550305502d5502a5502755023550215501f5501c5501a550185501655015550145501255011550105500f5500e5500c5500a55008550065500555003550015500055000550290002a0002a000
00010000000002d6502d6402c640296502564018630116200d6300964007650056500465004650046500465004650066500965000000000000000000000000000000000000000000000000000000000000000000
00010000357500c750326501a6400b520056200352001520005100271000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
