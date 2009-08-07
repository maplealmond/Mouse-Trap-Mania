require 'sprite.rb'

class Car < Sprite	
	
	attr_accessor(:arrowdir, :radio)
	attr_reader(:life)
	
	def initialize(win,level,c,r)
		super(win,level,c,r)
		@sheet = Gosu::Image.load_tiles(win, "resources/car.png", 48, 48, false)
		@speed = 4
		@life = 6
		@dir = 2
		@radio = 2
		
		@win = win
		@level = level
		@arrowdir = nil
	end
	
	def move
		if ((@pos[0] + @pos[1]) % 48) == 0 then
			redirect
			drop_arrow
		end
		super
	end
	
	def life=(x)
		@life = x
		@life = 0 if @life < 0
	end
	
	#inputs from player
	def steer(dir)
		@radio = dir
	end
	
	def draw 
		col = [1,2,0,3].at(@dir)
		row = @life
		frame = 4*row + col
		@sheet[frame].draw(@pos[0],@pos[1],1)
	end
	
	#car tries to follow radio, unless there is wall
	#failing that, car keeps current dir
	def redirect
		c = @pos[0] / 48
		r = @pos[1] / 48
		
		
		radiocol = c + @delta[@radio][0]
		radiorow = r + @delta[@radio][1]
		@dir = @radio if @level.data[radiocol][radiorow] > 0
		
		nextcol = c + @delta[@dir][0]
		nextrow = r + @delta[@dir][1]
		
		if @level.data[nextcol][nextrow] > 0
			@speed = 4
		else
			@speed = 0
		end
		
	end
	
	def drop_arrow
		if @arrowdir then
			c = @pos[0] / 48
			r = @pos[1] / 48
			Arrow.new(@win,@level,c,r,@arrowdir)
			@arrowdir = nil
		end
	end
	
end
