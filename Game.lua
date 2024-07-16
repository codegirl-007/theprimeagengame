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

      local chat_x = math.floor(math.random(love.graphics.getWidth()  ))
      local chat_y = math.floor(math.random(love.graphics.getHeight()))

      table.insert(chats, 1, Chat(chat_x, chat_y, self.level))
      table.insert(chats, 2, Chat(chat_x, chat_y, self.level))
      table.insert(chats, 3, Chat(chat_x, chat_y, self.level))
      table.insert(chats, 4, Chat(chat_x, chat_y, self.level))

    end
  }
end

return Game