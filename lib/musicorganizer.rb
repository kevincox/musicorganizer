require 'pp'
require 'pathname'
require 'set'

require 'taglib'
require 'active_support/all'

require_relative 'version'

class MusicOrganizer
	class Song
		def initialize file, fmt
			@src = file
			@fmt = fmt
			
			fetch_tags
		end
		
		attr_accessor :src
		
		def dst
			@dst
		end
		
		def happy?
			src == dst
		end
		
		private
		def dst_calc tags
			return @src unless tags
			
			r = @fmt.gsub /\{(\{+)|\{([^}]*)\}/ do |m|
				next $1 if $1
				
				case $2
				when 'title'
					safe tags.title, m
				when 'artist'
					safe tags.artist, m
				else
					m
				end
			end
			
			Pathname.new r+@src.extname
		end
		
		def safe seg, fb
			if seg
				seg.gsub /[\\\/\0<>:'"|?*]/, '_'
			else
				fb
			end
		end
		
		def fetch_tags
			TagLib::FileRef.open @src.to_s do |file|
				if file.null?
					tags = nil
				else
					tags = file.tag
				end
				
				@dst = dst_calc tags
			end
		end
	end
	
	def initialize dir, fmt: '{title} - {artist}'
		raise Exception.new "Must provide a directory" unless dir
		
		@dir = Pathname.new dir
		@fmt = fmt
		
		@files = Pathname.glob @dir+'**/*'
		@files.reject!{|f| f.directory? }
		@files.map!   {|f| Song.new f, "#@dir/#@fmt" }
	end
	
	def run!
		@fs = {}
		
		@files.each do |f|
			@fs[f.src] = f;
		end
		
		@files.each do |f|
			move! f
		end
	end
	
	private
	def move! f, pending=Set.new
		if f.happy?
			# puts "#{f.src} already correct."
		else
			t = @fs[f.dst]
			if t && !t.happy?
				pending.add self
				move! t, pending
				pending.delete self
			end
			
			if @fs[f.dst]
				puts "#{f.src} name collision, skipping."
			else
				puts "#{f.src} -> #{f.dst}"
				
				f.dst.dirname.mkpath
				f.src.rename f.dst
				if f.src.dirname.children.empty?
					puts "#{f.src.dirname} removing empty directory."
					f.src.dirname.rmdir
				end
				
				@fs.delete f.src
				@fs[f.dst] = f
				f.src = f.dst
			end
		end
	end
end
