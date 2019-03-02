#!/usr/bin/ruby -w
require 'io/console'

def colourize(str, colour=[92, 129, 164, 198, 203, 208, 184, 154], width=0)
	final_str = ''
	colour = colour.to_a if colour.is_a?(Range)

	str.each_line do |l|
		final_str.concat(' ' * (width / 2))
		index, colour_length = 0, colour.length
		div = l.length/colour_length
		div = 1 if div == 0

		l.each_char.with_index do |c, i|
			index += 1 if (i % div == 0) && (index < colour_length && c != ' ') && (i != 0 || i != 1)
			final_str.concat("\e[38;5;#{colour[index]}m#{c}")
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
	if ARGV[0]
		dance = ARGF.read
	else
		puts colourize("No file provided. Usage:\n\t#{__FILE__} a_text_file.txt\n\n")
	end

	anim = %w(| / - \\)

	dance_colour = [92, 129, 164, 198, 203, 208, 184, 154]
	anim_colour = (70..75).to_a

	equal_colour = [40,41,42,43,211, 210, 209, 208]
	equal_colour2 = equal_colour.dup.reverse

	val = ''

	loop do
		anim.each do |x|
			height, width = STDOUT.winsize

			val.clear
			val.concat(
				<<~EOF
					\e[2J\e[H\e[3J
					#{(height/4).times.map { |i| colourize(x * width, anim_colour.rotate!) }.join}
					#{colourize('=' * (width - 1) , equal_colour.rotate!)}
					#{colourize(dance, dance_colour.rotate!, (width / 2))}
					#{colourize('=' * (width - 1), equal_colour2.rotate!(-1))}
					#{(height/4).times.map { |i| colourize(x * width, anim_colour.rotate!) }.join}
				EOF
			)

			print val
			sleep 0.13
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
