#!/usr/bin/ruby -w
require 'io/console'

def colourize(str, colour=[92, 129, 164, 198, 203, 208, 184, 154])
	colour = colour.to_a if colour.is_a?(Range)

	final_str = ''
	str.each_line do |l|
		index, colour_length = 0, colour.length
		div, i = l.length/colour_length, 0
		div = 1 if div == 0

		while i < l.length do
			ch = l[i]
			index += 1 if (i % div == 0) && (index < colour_length && ch != ' ') && (i != 0 || i != 1)
			final_str.concat("\e[38;5;#{colour[index]}m#{ch}")
			i += 1
		end
	end
	final_str + "\e[0m"
end

def printemo(emo=':)', message='::', colour=[92, 129, 164, 198, 203, 208, 184, 154])
	colour.reverse! if [true, false].sample
	print colourize(message, colour)
	puts ' ' * (STDOUT.winsize[1] - message.length - emo.length) + colourize(emo)
end

def main
	ARGV[0] ? (content = ARGF.read) : (puts colourize("No file provided. Usage:\n\t#{__FILE__} a_text_file.txt\n\n"))

	anim, val = %w(| / - \\), ''

	anim_colour = [63, 33, 39, 44, 49, 83, 118]
	content_colour = [92, 129, 164, 198, 203, 208, 184, 154]
	equal_colour = [40,41,42,43,211, 210, 209, 208]
	equal_colour2 = equal_colour.dup

	loop do
		anim.each do |x|
			height, width = STDOUT.winsize

			val.clear
			val.concat(
				<<~EOF
					\e[2J\e[H\e[3J
					#{(height/3).times.map { colourize(x * width, anim_colour.rotate!) }.join}
					#{colourize('=' * width, equal_colour.rotate!)}
					#{colourize(content, content_colour.rotate!)}
					#{colourize('=' * width, equal_colour2.rotate!(-1))}
					#{(height/3).times.map { colourize(x * width, anim_colour.rotate!) }.join}
				EOF
			)

			print val
			sleep 0.1
		end
	end
end

begin
	main
rescue Interrupt, SystemExit
	puts
	printemo('Thanks! ;)')
rescue Errno::ENOENT
	printemo('The File is not found :(')
rescue Exception
	printemo(':(', '::Bye World')
end
