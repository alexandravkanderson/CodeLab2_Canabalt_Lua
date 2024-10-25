building = { -- the class table
  tileSize = 16, -- size of each tile

  screen_height, -- height of the screen

  x = 0, -- x position of the building
  y = 0, -- y position of the building
  width = 0, -- width of the building
  height = 0, -- height of the building
  body, -- physics body
  shape -- physics
} -- the table representing the class, which will double as the metatable for the instances
-- initializing the class table

building.__index = building -- failed table lookups on the instances should fallback to the class table, to get methods

function building:makeBuilding(x, y, tileSize)
-- create a new instance of the building class

  local self = setmetatable({}, building)
-- set the metatable of the new instance to the class table
  self:setupBuilding(x, y, tileSize)
-- return the new instance
  return self
end

function building:setupBuilding(x, tileSize)
-- set up the building's properties
  self.tileSize = tileSize  -- tile size
  self.x = x                -- x position
  self.y = 300              -- y position

  self.width  = math.ceil((love.math.random( ) * 10) + 20) -- width of the building 20-30
  self.height = math.ceil(5 + love.math.random( ) * 7) -- height of the building 5-12
  --self.height = 7
  self.body = love.physics.newBody(world, 0, 0, "static") -- create a new physics body
  self.shape = love.physics.newRectangleShape(self.x, self.y, 
                                              self.tileSize * self.width, 
                                              self.tileSize * self.height) -- create a new rectangle shape
  fixture = love.physics.newFixture(self.body, self.shape) -- create a new fixture for the body
  fixture:setUserData("Building") -- set the user data for the fixture
end

function building:update(body, dt, other_building)
-- update the building's position
  if self.x + self.width/2 * self.tileSize < body:getX() then -- if the building is to the left of the player
      self:setupBuilding( -- create a new building
          other_building.x + other_building.width  * self.tileSize + 150, 
          16) -- set the tile size
  end
end

function building:draw(tilesetBatch, tileQuads) -- draw the building
  x1, y1 = self.shape:getPoints() -- get the points of the shape

  tilesetBatch:add(tileQuads[0], self.x, self.y, 0) -- add the base tile
  for x=self.width - 1, 0, -1 do  -- loop through the width of the building
    for y=0,self.height - 1, 1 do -- loop through the height of the building
      if x == 0 and y == 0 then -- if it's the bottom left corner
        tilesetBatch:add(tileQuads[1], x1 + x * tileSize, y1 + y * tileSize, 0) -- add the bottom left corner tile
      else
        if y == 0 and x == self.width - 1 then -- if it's the bottom right corner
          tilesetBatch:add(tileQuads[3], x1 + x * tileSize, y1 + y * tileSize, 0) -- add the bottom right corner tile
        else 
          if y == 0 then
            tilesetBatch:add(tileQuads[2], x1 + x * tileSize, y1 + y * tileSize, 0) -- add the bottom tile
          else 
            num = math.floor(x + y + x1 + y1) -- calculate the number for the tile
            if (num)%5 == 0 then
              --tilesetBatch:add(tileQuads[5], x1 + x * tileSize, y1 + y * tileSize, 0)
            else
              tilesetBatch:add(tileQuads[4], x1 + x * tileSize, y1 + y * tileSize, 0) -- add the middle tile
            end
          end
        end
      end
    end
  end
end
