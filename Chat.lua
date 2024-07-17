require "globals"
local love = require "love"
local lg = love.graphics


function Chat(x, y, level)
  local CHAT_SPEED = math.random(30) + (level * 2)
  local vel = -1
  local life = 5

  if math.random() < 0.5 then
    vel = 1
  end

  return {
    sprite = lg.newImage("assets/chat.png"),
    x = x,
    y = y,
    x_vel = math.random() * CHAT_SPEED * vel,
    y_vel = math.random() * CHAT_SPEED * vel,
    radius = 30,
    life = 5,

    draw = function(self)
      lg.draw(self.sprite, self.x, self.y, 0, 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
      lg.circle("line", self.x, self.y, self.radius)
    end,

    move = function(self, player_x, player_y, dt)
      -- direction is the vector from the enemy to the player
      local direction_x = player_x - self.x
      local direction_y = player_y - self.y
      local distance = math.sqrt(direction_x * direction_x + direction_y * direction_y)

      if dist ~= 0 then -- avoid division by zero
          self.x = self.x + direction_x / distance * CHAT_SPEED * dt
          self.y = self.y + direction_y / distance * CHAT_SPEED * dt
      end
    end,

    decreaseLife = function(self)
      self.life = self.life - 1
    end,

    destroy = function(self, chat_table, index)
      table.remove(chat_table, index)
    end
  }
end

return Chat
