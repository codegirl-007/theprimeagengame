local love = require "love"

function Ban(x, y, angle)
    local BAN_SPEED = 300 -- ban hammer speed in pixel/second
    local EXPLODE_DURATION = 0.2
   
    return {
        sprite = love.graphics.newImage("assets/ban.png"),
        x = x,
        y = y,
        x_vel = BAN_SPEED *  math.sin(angle) / love.timer.getFPS(),
        y_vel = -BAN_SPEED * math.cos(angle) / love.timer.getFPS(),
        distance = 0, -- distance traveled
        exploding = 0, -- 0 not exploding, 1 exploding, 2 done exploding
        explode_time = 0,


        draw = function (self, faded)
            if self.exploding < 1 then
                love.graphics.draw(self.sprite, self.x, self.y, angle, 0.4, 0.4, self.sprite:getWidth() / 2, self.sprite:getHeight() / 2)
            end
        end,

        move = function (self)
            self.x = self.x + self.x_vel
            self.y = self.y + self.y_vel

            if self.explode_time > 0 then
                self.exploding = 1
            end
            -- increase the distance traveled
            self.distance = self.distance + math.sqrt((self.x_vel ^ 2) + (self.y_vel ^ 2))
        end,

        explode = function(self) 
            self.explode_time = math.ceil(EXPLODE_DURATION * love.timer.getFPS() / 100)

            if self.explode_time > EXPLODE_DURATION then
                self.exploding = 2
            end
        end
    }
end

return Ban