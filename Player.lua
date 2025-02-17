require "globals"
local love = require "love"


function Player(debugging)
  local lg = love.graphics
  local EXPLODE_DUR = 3

  return {
    sprite = lg.newImage('assets/prime.png'),
    x = 300,
    y = 300,
    angle = 0,
    facing = 0, -- get the angle the player is facing so we know how to shoot the ban hammers
    speed = 80,
    rotation_speed = 1,
    thrusting = false,
    bans = {}, 
    max_bans = 60,
    explode_time = 0,
    exploding = false,
    thrust = {
      x = 0,
      y = 0,
      speed = 1
    },
    draw = function(self)
      if not self.exploding then
        lg.draw(player.sprite, player.x, player.y, player.angle, 0.5, 0.5, player.sprite:getWidth() / 2, player.sprite:getHeight() / 2)
      else
        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", self.x, self.y, player.sprite:getWidth() / 2 * 1.5)

        love.graphics.setColor(1, 158/255, 0)
        love.graphics.circle("fill", self.x, self.y, player.sprite:getWidth() / 2 * 1)

        love.graphics.setColor(1, 234/255, 0)
        love.graphics.circle("fill", self.x, self.y, player.sprite:getWidth() / 2 * 0.5)
      end

      -- draw ban hammers
      for _, ban in pairs(self.bans) do
        ban:draw()
      end
    end,
    shootBan = function (self)
      self.max_bans = self.max_bans - 1
      if (#self.bans <= self.max_bans) then
          table.insert(self.bans, Ban(
              self.x,
              self.y,
              player.facing
          ))
      end
    end,
    destroyBan = function (self, index)
      table.remove(self.bans, index)
    end,

    movePlayer = function (self, dt)
      self.exploding = self.explode_time > 0

      if not self.exploding then 
        local FPS = love.timer.getFPS()
        local friction = 0.7

        if love.keyboard.isDown('left') then
          self.angle = self.angle - self.rotation_speed * dt
          self.facing = self.angle
        end
        if love.keyboard.isDown('right') then
          self.angle = self.angle + self.rotation_speed * dt
          self.facing = self.angle
        end  

        if self.thrusting then 
          self.thrust.x = self.thrust.x + self.thrust.speed * math.sin(self.angle) / FPS
          self.thrust.y = self.thrust.y - self.thrust.speed * math.cos(self.angle) / FPS
        else
          -- applies friction to stop the player
          if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
            self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
            self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
          end
        end

        self.x = self.x + self.thrust.x
        self.y = self.y + self.thrust.y

        -- make sure the player can't go off screen on x axis
        if self.x + (self.sprite:getWidth() / 2) < 0 then
          self.x = love.graphics.getWidth() + (self.sprite:getWidth() / 2)
        elseif self.x - (self.sprite:getWidth() / 2) > love.graphics.getWidth() then
          self.x = -(self.sprite:getWidth() / 2)
        end

        -- make sure the player can't go off screen on y axis
        if self.y + (self.sprite:getHeight() / 2) < 0 then
          self.y = love.graphics.getHeight() + (player.sprite:getHeight() / 2)
        elseif self.y - (self.sprite:getHeight() / 2) > love.graphics.getHeight() then
          self.y = -(self.sprite:getHeight() / 2)
        end
      end

      -- this will move the ban
      for index, ban in pairs(self.bans) do
        ban:move()

        BAN_DISTANCE = 0.6

        if (ban.distance > BAN_DISTANCE * love.graphics.getWidth()) and ban.exploding == 0 then
          ban:explode(self, index)
        end -- endif

        if ban.exploding == 0 then -- 0 -> ban not exploding
          ban:move()
        elseif ban.exploding == 2 then -- 2 -> ban is done exploding
          self.destroyBan(self, index)
        end
      end -- endfor
    end, --end movePlayer

    explode = function (self) -- player can now expload
      self.explode_time = math.ceil(EXPLODE_DUR * love.timer.getFPS())
    end
  } -- end player 
end

return Player