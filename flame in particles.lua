--using particles to simulate flame--

function _init()
  --table is essential in particles--
  parts={}
  force=-3
  focre_d=1
end

function _update()
  --direction control--
  force+=.1*force_d*rnd(1)
  if force>2 or force<-2 then
    force_d=force_d*-1
  end

  for i=1,20 do
    add(parts,{
      x=57+rnd(20)
      y=90+rnd(10)
      r=rnd(3)
      c=7,
      l=13,
      speed=rnd(2)
    })
  end

  --animation control
  for p in all(parts) do
    p.y-=p.speed
    p.l-=1
    p.r-=.1
    p.x+=force

    if p.l<11 then
      p.c=10
    end
    if p.l<8 then
      p.c=9
    end

    if p.l<0 then
      del(parts,p)
    end
  end
end

function _draw()
  --draw the particles
  cls()
  for p in all(parts) do
    circfill(p.x,p.y,p.r,p.c)
  end
end
      
