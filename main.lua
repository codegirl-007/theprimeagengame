local love = require "love"
local lg = love.graphics
local lk = love.keyboard
local Ban = require "Ban"
local Game = require "Game"
local Player = require "Player"
local Menu = require "menu"

math.randomseed(os.time())
function love.load()
  local BAN_DISTANCE = 0.6
  local BAN_SPEED = 500 

  player = Player()
  game = Game()
  game:startNewGame(player)
  menu = Menu(game, player)
end

function love.keypressed(key)
  if game.state.running then
    if key == "escape" then
      game:changeGameState("paused")
    end
    if key == "m" then
      game:changeGameState("menu")
    end
  elseif game.state.paused then
    if key == "escape" then  
      game:changeGameState("running")
    end
  elseif game.state.menu then
    if key == "m" then
      game:changeGameState("running")
    end
  end -- endif for gamestate

  if key == "up" then
    player.thrusting = true
  end

  if key == "space" then
    player:shootBan()
  end

end

function love.keyreleased(key)
  if key == "up" then
    player.thrusting = false
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  
  if button == 1 then
    clickedMouse = true
  end
end

function love.update(dt)
  if game.state.running then 
    player:movePlayer(dt)

    for chat_index, chat in pairs(chats) do
      if not player.exploding then 
        if calculateDistance(player.x, player.y, chat.x, chat.y) < chat.radius then 
          player:explode() -- delete ban
          destroy_ast = true
        end
      else
        player.explode_time = player.explode_time - 1
      end

      -- we new check to see for ban collision detection
      for _, ban in pairs(player.bans) do
          if calculateDistance(ban.x, ban.y, chat.x, chat.y) < chat.radius then 
            ban:explode() -- delete ban
            chat:destroy(chats, chat_index, game)
          end
      end

      if destroy_ast then
        destroy_ast = false
        chat:destroy(chats, chat_index, game)
      end

      chat:move(player.x, player.y, dt)
  end

  elseif game.state.menu then
    menu:run(clickedMouse)
    clickedMouse = false
  end
end

function love.draw()
  if game.state.running then
    player:draw()

  for _, chat in pairs(chats) do
    chat:draw()
  end
    
  elseif game.state.paused then
    game:draw(game.state.paused)
  elseif game.state.menu then
    menu:draw()
  end

  local ammo = player.max_bans
  if player.max_bans > 0 then
    ammo = player.max_bans
  else 
    ammo = 0
  end

  love.graphics.print("AMMO: " .. ammo, 10, 10)

  if ammo == 0 then
    love.graphics.print("OUT OF AMMO", love.graphics.getWidth() / 2, love.graphics.getHeight() / 4)
  end
end
