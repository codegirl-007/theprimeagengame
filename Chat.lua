require "globals"
local love = require "love"
local lg = love.graphics


function Chat(x, y, level)
  local CHAT_SPEED = math.random(50) + (level * 2)
  local vel = -1

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

    draw = function(self)
      lg.draw(self.sprite, self.x, self.y, 0, 1, 1, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
      lg.circle("line", self.x, self.y, self.radius)
    end,

    move = function(self, dt)
      self.x = self.x + self.x_vel * dt
      self.y = self.y + self.y_vel * dt

      if self.x + self.radius < 0 then
        self.x = love.graphics.getWidth() + self.radius
      elseif self.x - self.radius > love.graphics.getWidth() then
        self.x = -self.radius
      end

      if self.y + self.radius < 0 then
        self.y = love.graphics.getHeight() + self.radius
      elseif self.y - self.radius > love.graphics.getHeight() then
        self.y = -self.radius
      end
    end,

    destroy = function(self, chat_table, index)
      table.remove(chat_table, index)
    end
  }
end

return Chat
