function _init()
  --tweak--
  flap_amt=8
  gravity=2

  --set initial vars--
  flap=0
  px=63
  py=63
  pspr=2

  --score--
  score==0

  --collide--
  col=false

  --state--
  state="start"

  --sub function--
  i_pipes()
end

function _update()
  --call 30tps--
  if state=="game" then
    update_game()
  elseif state=="game over" then
    update_game_over()
  elseif state=="start" then
    update_start()
  end
end

function _draw()
  --call 30tps after update--
  if state=="game" then
    draw_game()
  elseif state=="game over" then
    draw_game_over()
  elseif state=="start" then
    draw_start()
  end
end

function update_game()
  py+=gravity
  if btnp(x) then
    flap=flap_amt
  end

  if flap>0 then
    flap-=1
    pspr=1
  else
    pspr=2
  end

  py-=flap

  if py>=120 then
    py=120
  elseif py<0 then
    py=0
  end

  u_pipes()
  u_score()
  collide()
end


function draw_game()
  cls()
  map()
  d_pipes()
  spr(pspr,px,py)
  print("scores: "..score)
  print(col)
end


function update_game_over()
  if btnp(z) then
    _init()
  end
end

function draw_game_over()
  cls()
  print("game over",44,60)
  print("press z to restart",28,68)
end

function update_start()
  if btnp(z) then
    state="game"
  end
end

function draw_start()
  cls()
  map()
  print("flappy bird",44,60)
  print("press z to start",28,68)
end


--pipes--
function i_pipes()
  --set up pipes
  gap=30
  p1bx=129
  p1by=rnd(128)
end

function u_pipes()
  --update pipes
  p1bx-=1
  if p1bx<-16 then
    p1by=8+gap+rnd(128-gap-8)  --set random height
    p1bx=128
  end
end

function d_pipes()
  --draw bottom pipes--
  spr(7,p1bx,p1by-128-gap,2,16)
  --draw top pipes--
  spr(7,p1bx,p1by,2,16)
end

--score/collision--
function u_score()
  if p1bx==px then
    score+=1
  end
end

function collide()
  if abs(px-p1bx)<4 then
    if py<p1by then
      --collide--
      col=true
      state="game over"
    elseif py<p1by-gap then
      col=true
      state="game over"
    else
      col=false
    end
  end
end
