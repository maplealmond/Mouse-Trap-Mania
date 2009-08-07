class Sprite
	attr_accessor(:pos, :dir)

	def initialize(win, level, c, r)
		@delta = [[0,-1],[1,0],[0,1],[-1,0]]
		@pos = [48*c , 48*r]
		@dir = 2
		@level = level
		@stuff = win.stuff
		@stuff.push(self)
	end
	
	def die 
		@stuff.delete(self)
	end
	
	def update
		move
	end
	
	def move
		@pos[0] = ( @pos[0] + @delta[@dir][0] * @speed ) % ( (@level.cols - 1) * 48 )
		@pos[1] = ( @pos[1] + @delta[@dir][1] * @speed ) % ( (@level.rows - 1) * 48 )
	end
	

	
end
