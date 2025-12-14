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
