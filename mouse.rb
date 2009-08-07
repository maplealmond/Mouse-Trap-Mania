require 'sprite.rb'

class Mouse < Sprite
		
	def initialize(win,level,c,r)
		
		@@chomp = Gosu::Sample.new(win, "resources/sound/chomp.wav")		
		super(win,level,c,r)
		@target = win.car
	end
	
	def update
		eat
		super
	end

	def eat
		dx = (@target.pos[0] - @pos[0])
		dy = (@target.pos[1] - @pos[1])
		
		if dx.abs < 24 and dy.abs < 24 then
			@target.life -= 1
			@@chomp.play
			die
		end
		
	end
	
	def move
		#avoid hitting a wall
		if ((@pos[0] + @pos[1]) % 48) == 0 then
			seek
			arrows
			redirect
		end
		super
	end
	
	#mice turn when they hit walls
	def redirect
		c = @pos[0] / 48
		r = @pos[1] / 48
		
		die if @level.data[c][r] == 2
		
		tc = c + @delta[@dir][0]
		tr = r + @delta[@dir][1]
				
		if @level.data[tc][tr] == 0 then
			@dir = ( @dir + rand(2) + 1 ) % 4
			@charge = 0
			redirect
		end
	end
	
	def draw 
		row = [1,2,0,3].at(@dir)
		step = [1,0,1,2].at(((@pos[0] + @pos[1]) % 48) / 12 % 4)
		frame = 3*row + step
		@sheet[frame].draw(@pos[0],@pos[1],1)
	end
	
	#follow the arrows
	def arrows
		@stuff.each do |x|
			if x.class == Arrow then
				c = @pos[0] / 48
				r = @pos[1] / 48
				
				if c == x.c && r == x.r then
					@dir = x.dir
					x.die
				end
			end
		end
	end
	
end

class WhiteMouse < Mouse
	def initialize(win,level,c,r)
		super(win,level,c,r)
		@sheet = Gosu::Image.load_tiles(win, "resources/mouse1_2x.png", 48, 48, false)
		@speed = 2
	end
	
	def seek
		dx = @target.pos[0] - @pos[0]
		dy = @target.pos[1] - @pos[1]
	
		if dx.abs + dy.abs < 5*48 then
			 if dy.abs > dx.abs
				@dir = 0
				@dir = 2 if dy > 0
			 else
				@dir = 1
				@dir = 3 if dx < 0
			 end
		end 

	end
	
end

class BlackMouse < Mouse
	def initialize(win,level,c,r)
		super(win,level,c,r)
		@sheet = Gosu::Image.load_tiles(win, "resources/mouse2_2x.png", 48, 48, false)
		@speed = 2
		@charge = 0
	end
	
	def seek
		dx = ( @target.pos[0] - @pos[0] )
		dy = ( @target.pos[1] - @pos[1] )
		
		if @charge > 0 then
			@charge -= 1
		else
		
			#meh, close enough
			dx = 0 if dx.abs < 48
			dy = 0 if dy.abs < 48	
			@charge = 5 if dx == 0 or dy == 0
				
			@dir = 0 if dx == 0 and dy < 0
			@dir = 2 if dx == 0 and dy > 0
			@dir = 1 if dy == 0 and dx > 0
			@dir = 3 if dy == 0 and dx < 0
		end
		
		@speed = 2
		@speed = 4 if @charge > 0
		
	end
	
	
end

class RobotMouse < Mouse
	def initialize(win,level,c,r)
		super(win,level,c,r)
		@sheet = Gosu::Image.load_tiles(win, "resources/mouse3_2x.png", 48, 48, false)
		@speed = 3
	end
	
	def seek
		@dir = rand(4) if rand(100) == 0
	end
end
