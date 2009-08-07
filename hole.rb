require 'sprite.rb'

class Hole < Sprite
			
	def initialize(win,level,c,r)
		super(win,level,c,r)
		
		#We'll need these to spawn other mice
		@win = win
		@level = level
		@c = c
		@r = r
		
		@sheet = Gosu::Image.load_tiles(win, "resources/walls4b.png", 48, 48, true)
		
		@time = 0	
		@goal = 1
		@cycle = 100
		@spawned = 0		
		
	end
	
	def draw
		frame = 50 + (4 * @time / @goal)
		@sheet[frame].draw(@pos[0],@pos[1],1)
	end
	
	def update
		#return if @spawned > 100
		
		@time = @time + 1
		if @time >= @goal then
			
			roll = rand(20) + 1
			
			WhiteMouse.new(@win,@level,@c,@r) if roll <= 15
			BlackMouse.new(@win,@level,@c,@r) if roll <= 18 and roll > 15
			RobotMouse.new(@win,@level,@c,@r) if roll == 19
			Goat.new(@win,@level,@c,@r) if roll == 20
			@spawned += 1
			
			@cycle -= 1
			@cycle = 1 if @cycle < 0
			
			@goal = @cycle * (rand(6) + 1) + 1
			@time = 0

		end
	end
	
	def move
	end
	
end
