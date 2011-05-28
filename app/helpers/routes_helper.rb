module RoutesHelper
	
	# define default heights and widths for the canvas
	# return height, width
	def canvas_size(size)
		logger.debug("canvas size: #{size.inspect}")
		case size.to_sym
			when :small
				return 100, 200
			when :medium
				return 300, 450
			when :large
				return 600, 800
			else
				return 300, 400
		end	
	end
	
end
