function _init()
	exps={}
	clrs={5,9,10,7} --clrs start from 7->10->9->5
end

function _update()
	for p in all(exps) do
		p.x+=p.spdx
		p.y+=p.spdy
		p.scale-=.1
		p.l-=.1
		p.c=flr(p.l)
		if p.l<=0 then
			del(exps,p)
		end
	end
		
	if btnp(❎) then
		xp=rnd(128)	--set location
		yp=rnd(128)
		for i=0,20 do
			add(exps,{
				x=xp,
				y=yp,
				spdx=1-rnd(2),
				spdy=1-rnd(2),
				scale=2+rnd(2),
				l=5
			})
		end
		sfx(0)
	end
end


function _draw()
	cls()
	for p in all(exps) do
		circfill(p.x,p.y,p.scale,clrs[flr(rnd(#clrs))+1])
	end
end
