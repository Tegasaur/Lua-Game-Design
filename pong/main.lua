-- constants----------
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
push = require 'push'
Class = require 'class'
require("Ball")
require("Paddle")
----------------------

-- Load --------------
function love.load()
    math.randomseed(os.time())

    -- Set up fonts styles
    love.graphics.setDefaultFilter('nearest','nearest')


    love.window.setTitle('Pong')
    smallFont = love.graphics.newFont('04B_03__.TTF', 8)
    scoreFont = love.graphics.newFont('04B_03__.TTF', 32)
    victoryFont = love.graphics.newFont('04B_03__.TTF', 24)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('Blip_Select.wav', 'static'),
        ['point_scored'] = love.audio.newSource('Explosion.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('Hit_Hurt.wav','static')
    }

    -- Set up screen
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen = false,
        vsync = true,
        resizable = false
    })

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 5, 5)
    -- Set up variables
    player1Score = 0
    player2Score = 0

    servingPlayer =  math.random(2) == 1 and 1 or 2

    playState = 'ai'
    gameState = 'start'
end
---------------------------------------

-- Update -----------------------------
function love.update(dt)

    paddle1:update(dt)
    paddle2:update(dt)

    if ball:collides(paddle1) then
        ball.dx = - ball.dx
        sounds['paddle_hit']:play()
    end

    if ball:collides(paddle2) then
        ball.dx = - ball.dx
        sounds['paddle_hit']:play()
    end

    if ball.y <= 0 then
        ball.dy = -ball.dy
        ball.y = 0
        sounds['wall_hit']:play()
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
        sounds['wall_hit']:play()
    end

    if ball.x <= 0 then
        player2Score = player2Score + 1
        servingPlayer = 1
        ball:reset()

        if player2Score >= 10 then
            gameState = 'victory'
            winningPlayer = 2
        else
            gameState = 'serve'
        end

        ball.dx = 100
        sounds['point_scored']:play()
    end

    if ball.x >= VIRTUAL_WIDTH - 4 then
        player1Score = player1Score + 1
        servingPlayer = 2
        ball:reset()

        if player1Score >= 10 then
            gameState = 'victory'
            winningPlayer = 1
        else
            gameState = 'serve'
        end

        ball.dx = -100
        sounds['point_scored']:play()
    end
    


    -- Movement Ish
    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED 
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if playState == 'co-op' then
        if love.keyboard.isDown('up') then
            paddle2.dy = -PADDLE_SPEED 
        elseif love.keyboard.isDown('down') then
            paddle2.dy = PADDLE_SPEED 
        else 
            paddle2.dy = 0
        end
    elseif playState == "ai" then
        if gameState == "play" then
            if math.fmod( math.floor(ball.x/dt), 10) == 0 then 
                paddle2.y = math.random(ball.y - 15, ball.y + 15)
            end
        end
    end

    -- Ball movement
    if gameState == 'play' then
        ball:update(dt)
    end
end
--------------------------------------

-- Update ----------------------------
function love.draw()
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 1)
    ball:render()
    paddle1:render()
    paddle2:render()
   
    love.graphics.setFont(smallFont)

    if gameState == "start" then
        love.graphics.printf("Welcome to Pong", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Play", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf("Player" .. tostring(servingPlayer) .. "'s turn!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to serve", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player" .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter to serve", 0, 42, VIRTUAL_WIDTH, 'center')
    end

    if playState == "ai" then
        love.graphics.printf("AI mode", 0, 60, VIRTUAL_WIDTH, 'center')
    elseif playState == "co-op" then
        love.graphics.printf("Co-op mode", 0, 60, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score,
        VIRTUAL_WIDTH/2 - 50, 
        VIRTUAL_HEIGHT/3)
    love.graphics.print(player2Score,
        VIRTUAL_WIDTH/2 + 30, 
        VIRTUAL_HEIGHT/3) 
    
    displayFPS()

    push:apply('end')     
end
-------------------------------------





function love.resize(w,h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'victory' then
            gameState = 'start'
            player1Score = 0
            player2Score = 0
        end
    end

    if gameState == 'start' then
        if key == 'b' then
            playState = 'ai'
        elseif key == 'n' then
            playState = 'co-op'
        end
    end
end


function displayFPS()
    love.graphics.setColor(0,1,0,1) 
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20 )
    love.graphics.setColor(1,1,1,1)
end


