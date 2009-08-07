require 'hole.rb'

class Level
		
	attr_accessor(:data, :rows, :cols)
	
	def initialize(win, name)
		@cols = 18
		@rows = 14
		@win = win
		
		@data = Array.new(@cols)
		@data.map! { Array.new(@rows) }
		@tile = Array.new(@cols)
		@tile.map! { Array.new(@rows) }
		
		@sheet = Gosu::Image.load_tiles(win, "resources/walls4b.png", 48, 48, true)
		
		@file = "resources/levels/#{name}.lvl"
		
		if File.exist?(@file) then
			load
		else
			create
		end
		
		cache_tiles
		
	end
	
	def create
		@cols.times do |c|
			@rows.times do |r|
				if c == 0 or c == @cols - 1 or r == 0 or r == @rows - 1 then
					@data[c][r] = 0
				else
					@data[c][r] = 1
				end
			end
		end
	end
	
	def load
		f = File.open(@file, "r")
		@data = Marshal.load(f.read)
		f.close
		cache_tiles
	end
	
	def save
		f = File.open(@file, "w")
		f.print(Marshal.dump(@data))
		f.close
	end
	
	def draw
		@cols.times do |c|
			@rows.times do |r|
				xpos = c * 48
				ypos = r * 48

				@sheet[34].draw(xpos,ypos,0) if @tile[c][r] == 29 #traps need a floor drawn for them								
				@sheet[@tile[c][r]].draw(xpos,ypos,0)

			end
		end
	end
	
	def cache_tiles
		@cols.times do |c|
			@rows.times do |r|
				calc_tile(c,r)			
			end
		end	
	end
	
	def calc_tile(c,r)
		
		#floor
		if @data[c][r] == 1 then
			@tile[c][r] = 34
			return
		end
		
		#trap
		if @data[c][r] == 2 then
			@tile[c][r] = 29
			return
		end
		
		#hole
		if @data[c][r] == 3 then
			@tile[c][r] = 52
			return
		end
		
		#walls
		if @data[c][r] == 0 then
			up = 1 if r == 0
			lt = 1 if c == 0
			dn = 1 if r == @rows-1
			rt = 1 if c == @cols-1
						
			up = @data[c][r-1] unless up	
			lt = @data[c-1][r] unless lt
			dn = @data[c][r+1] unless dn
			rt = @data[c+1][r] unless rt
						
			#treat non-walls as floor
			up = 1 unless up == 0
			lt = 1 unless lt == 0
			dn = 1 unless dn == 0
			rt = 1 unless rt == 0
			
			ar = [up,rt,dn,lt]
			
			#default value
			val = 24
			
			val = 0 if ar == [1,1,0,1]
			val = 1 if ar == [1,1,1,0]
			val = 2 if ar == [0,1,1,1]
			val = 3 if ar == [1,0,1,1]
			
			val = 5 if ar == [0,0,0,1]
			val = 6 if ar == [1,0,0,0]
			val = 7 if ar == [1,0,0,1]
			val = 8 if ar == [1,1,0,0]
			
			val = 10 if ar == [0,0,1,0]
			val = 11 if ar == [0,1,0,0]
			val = 12 if ar == [0,0,1,1]
			val = 13 if ar == [0,1,1,0]
			
			val = 24 if ar == [1,1,1,1]
			val = 45 if ar == [0,1,0,1]
			val = 46 if ar == [1,0,1,0]
			
			
			@tile[c][r] = val
		end
		
	end
	
	def load_holes
		@cols.times do |c|
			@rows.times do |r|
				Hole.new(@win,self,c,r)	if @data[c][r] == 3	
			end
		end	
	end
	
	def toggle(c,r,b)
		v = @data[c][r]
		v = (v+1) % 2 + 2 if b == 'r'
		v = (v+1) % 2 if b == 'l' or c == 0 or r == 0 or c == @cols-1 or r == @rows-1
		
		@data[c][r] = v
		
		@data[@cols-1][r] = v if c == 0
		@data[c][@rows-1] = v if r == 0
		@data[0][r] = v if c == @cols-1
		@data[c][0] = v if r == @rows-1
	end
	
	
	
end