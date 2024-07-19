local love = require "love"

local Chat = require "chat"
function Game()
  return {
    state = {
      menu = false,
      paused = false,
      running = true,
      ended = false,
    },

    level = 5,

    changeGameState = function(self, state)
      self.state.menu = state == "menu"
      self.state.paused = state == "paused"
      self.state.running = state == "running"
      self.state.ended = state == "ended"
    end,

    startNewGame = function (self, player)
      self:changeGameState("running")

      chats = {}

      for i = 1, 1 do
        local chat_x = math.floor(math.random(love.graphics.getWidth()))
        local chat_y = math.floor(math.random(love.graphics.getHeight()))
        table.insert(chats, i, Chat(chat_x, chat_y, self.level))
      end

    end,

    draw = function (self, faded)
      if faded then
          Text(
              "PAUSED",
              0,
              love.graphics.getHeight() * 0.4,
              "h1",
              false,
              false,
              love.graphics.getWidth(),
              "center",
              1
          ):draw()
      end
    end,
  }
end

return Game