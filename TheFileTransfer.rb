#!/usr/bin/env ruby
# encoding: utf-8

require 'find'
require 'pathname'
require 'fileutils'

# input argv
option = ARGV[0]

# config dirs
main_project_dir = '/Users/roger/Desktop/WBAnjuke/WBAnjuke'
pod_dir = '/Users/roger/Desktop/WBAnjuke2/WBAnjuke/Community'
assets_dir = '/Users/roger/Desktop/WBAnjuke2/WBAnjuke/Community/assets'

# array to record path objects
main_path_list = Array.new()
pod_path_list = Array.new()
assets_path_list = Array.new()
pod_assets_list = Array.new()

# fetch all objc source files  @from => @list
def find_all_objc_path(from, list) 
	Find.find(from) do |filename| 
    	path = Pathname.new(filename)
    	extname = path.extname
    	begin
        	if extname == '.m' || extname == '.h' || extname == '.mm'
    			list << path
        	end
    	rescue Exception => e
    
    	end
	end
end


def find_all_xcassets_path(from, list) 
	Find.find(from) do |filename| 
    	path = Pathname.new(filename)
    	extname = path.extname
    	begin
        	if extname == '.xcassets'
    			list << path
        	end
    	rescue Exception => e
    
    	end
	end
end

def find_all_assets_in_path(from, list)
	Find.find(from) do |filename| 
    	path = Pathname.new(filename)
    	extname = path.extname
    	begin
        	if extname == '.m' || extname == '.mm'
            	file = File.open(path, 'r')
        		file.each { |line|
        			images = line.scan(/imageNamed:@"([^"]*)"/)
        			if images.length > 0
        				images.each { |array| 
        					list << array[0]
        				}
        			end
        			#image = line[/AIF_GET_IMAGE\(@"[^"]*"/]
        			#if image.length > 0
        			#	list << image
        			#end
        		}

        	end
    	rescue Exception => e
    
    	end
	end
end


def cp_objc_file(path, list)
	list.each { |pa|
		if pa.basename == path.basename
			FileUtils.chmod('+w', pa)
			FileUtils.cp(path, pa)
		end
	}
end

def fetch_objc_file(path, list)
	list.each { |pa|
		if pa.basename == path.basename
			FileUtils.chmod('+w', path)
			FileUtils.cp(pa, path)
		end
	}
end

# pod => main
if option == 'cp'
	find_all_objc_path(main_project_dir, main_path_list)
	find_all_objc_path(pod_dir, pod_path_list)

	pod_path_list.each { |path|
		cp_objc_file(path, main_path_list)
	}
# main => pod
elsif option == 'fetch' 
	find_all_objc_path(main_project_dir, main_path_list)
	find_all_objc_path(pod_dir, pod_path_list)

	pod_path_list.each { |path|
		fetch_objc_file(path, main_path_list)
	}	
# main => assets
elsif  option == 'assets'
	find_all_xcassets_path(main_project_dir, assets_path_list)
	find_all_assets_in_path(pod_dir, pod_assets_list)
	puts "pod assets list: #{pod_assets_list}"
else 
	puts 'invalid option: use [ cp or fetch or assets ]'
end




