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
