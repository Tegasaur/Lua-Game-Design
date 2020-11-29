VictoryState = Class{__includes = BaseState}

function VictoryState:init() 
end

function VictoryState:enter(params)
    self.paddle = params.paddle
    self.level = params.level
    self.health = params.health
    self.score = params.score
    self.ball = params.ball 
end

function VictoryState:exit() 
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    self.ball.x =  self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            paddle = self.paddle,
            bricks = LevelMaker.createMap(self.level + 1),
            health = self.health,
            score = self.score,
            level = self.level + 1
        })
    end
end

function VictoryState:render() 
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " Complete!",
        0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve', 0, VIRTUAL_HEIGHT,
        VIRTUAL_WIDTH, 'center')
end