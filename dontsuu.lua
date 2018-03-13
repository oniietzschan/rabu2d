local Dontsuu = {}

function Dontsuu.calculateFriction(maxSpeed, timeToStop, cutoffSpeed)
  assert(type(maxSpeed)    == 'number' and maxSpeed    > 0)
  assert(type(timeToStop)  == 'number' and timeToStop  > 0)
  assert(type(cutoffSpeed) == 'number' and cutoffSpeed > 0)
  return math.pow(10, (math.log10(cutoffSpeed / maxSpeed) / timeToStop))
end

function Dontsuu.getVelocity(dt, acceleration, maxSpeed, velocity, move)
  -- Dampen speed if: (1) stopped; or (2) walking in opposite direction of momentum.
  if (move == 0) or ((move > 0 and velocity < 0) or (move < 0 and velocity > 0)) then
    velocity = velocity * math.pow(WALK_DAMPEN_FACTOR, dt)
    if math.abs(velocity) < DAMPEN_CUTOFF_SPEED then
      velocity = 0
    end
  end

  -- Increase speed.
  local maxSpeedDimension = move * maxSpeed
  local deltaSpeed = move * dt * acceleration
  if deltaSpeed > 0 and velocity >= 0 then
    deltaSpeed = math.min(deltaSpeed, maxSpeedDimension - velocity)
  elseif deltaSpeed < 0 and velocity <= 0 then
    deltaSpeed = math.max(deltaSpeed, maxSpeedDimension - velocity)
  end
  velocity = velocity + deltaSpeed

  return velocity
end

return Dontsuu
