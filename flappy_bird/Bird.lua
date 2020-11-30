Bird = Class{}

local GRAVITY = 10

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = (VIRTUAL_WIDTH / 2) - (self.width / 2)
    self.y = (VIRTUAL_HEIGHT / 2) - (self.height / 2)
    self.dx = 0
    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy
    if love.keyboard.wasPressed('space') then
        self.dy = -3
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + pipe.width  then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <=pipe.y + pipe.height then
            return true
        end
    end

    return false
end