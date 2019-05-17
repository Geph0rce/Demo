#!/usr/bin/env ruby
# encoding: utf-8

require 'find'
require 'pathname'
require 'fileutils'

# input argv
option = ARGV[0]

# config dirs
main_project_dir = '/Users/qianjie/repo/Anjuke_Pre'
pod_dir = '/Users/qianjie/repo/AnjukeMoudle/AnjukeMoudle/Classes/'
assets_dir = '/Users/qianjie/repo/AnjukeMoudle/AnjukeMoudle/Assets/AnjukeMoudle.xcassets'
common_business_dir = '/Users/qianjie/repo/AJKCommonBusiness/AJKCommonBusiness'
service_dir = '/Users/qianjie/repo/Service/AIFLegacyService'
common_common_dir = '/Users/qianjie/repo/AJKCommonBusiness/Common'
common_service_dir = '/Users/qianjie/repo/AJKCommonBusiness/Service'

# array to record path objects
main_path_list = Array.new()
pod_path_list = Array.new()
common_business_header_list = Array.new()
service_header_list = Array.new()
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
        	if extname == '.imageset'
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

                    images = line.scan(/AIF_GET_IMAGE\(@"([^""]*)"/)
                    if images.length > 0
                        images.each { |array| 
                            list << array[0]
                        }
                    end
        		}

            end
        rescue Exception => e
    
        end
    end
    puts "assets count: #{list.length}"
end

def fetch_asset(asset, path_list, to)
    path_list.each { |asset_path|
        begin
            basename = asset_path.basename
            filename = basename.to_s
            if filename == asset + '.imageset'
                puts "find asset path : #{asset_path}"
                FileUtils.mv(asset_path, to, :force => true)
            end
        rescue Exception => e
            puts "Exception: #{e}"
        end
    }
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

def duplicate_objc_file(path, list)
    list.each { |pa|
        if pa.basename == path.basename
            puts("duplicate:  #{pa.basename}")            
        end
    }
end

def find_all_imports_in_path(path, list) 
    Find.find(path) do |filename| 
        path = Pathname.new(filename)
        extname = path.extname
        begin
            if extname == '.m' || extname == '.mm' || extname == '.h' || extname == '.pch'
                file = File.open(path, 'r')
                file.each { |line|
                    images = line.scan(/<AJKCommonBusiness\/([^>]*)>/)
                    if images.length > 0
                        images.each { |array| 
                            if !list.include?(array[0])
                                list << array[0]
                            end
                        }
                    end

                    images = line.scan(/import "([^"]*)"/)
                    if images.length > 0
                        images.each { |array| 
                            if !list.include?(array[0])
                                list << array[0]
                            end
                        }
                    end

                    images = line.scan(/<AIFLegacyService\/([^>]*)>/)
                    if images.length > 0
                        images.each { |array| 
                            if !list.include?(array[0])
                                list << array[0]
                            end
                        }
                    end
                }

            end
        rescue Exception => e
    
        end
    end
end

def find_all_headers(path, header, tag, list)
    Find.find(path) do |filename| 
        path = Pathname.new(filename)
        extname = path.extname
        begin
            if extname == '.h' && path.basename.to_s == header
                list << path
                mpath = path.to_s.sub! '.h', '.m'
                list << Pathname.new(mpath)
                puts "#{tag}: #{header}"
            end
        rescue Exception => e
            puts "#{e}"
        end
    end
end

def mv_file_list(list, to) 
    begin
        list.each do |path|
            #FileUtils.mv(path, to, :force => true)
            FileUtils.chmod('+w', to)
            FileUtils.cp(path, to)
        end
    rescue Exception => e
        
    end
    
end

# pod => main
if option == 'push'
	find_all_objc_path(main_project_dir, main_path_list)
	find_all_objc_path(pod_dir, pod_path_list)

	pod_path_list.each { |path|
		cp_objc_file(path, main_path_list)
	}
# main => pod
elsif option == 'pull' 
	find_all_objc_path(main_project_dir, main_path_list)
	find_all_objc_path(pod_dir, pod_path_list)

	pod_path_list.each { |path|
		fetch_objc_file(path, main_path_list)
	}	
# main => assets
elsif  option == 'assets'
	find_all_xcassets_path(main_project_dir, assets_path_list)
	find_all_assets_in_path(pod_dir, pod_assets_list)
    pod_assets_list.each { |asset|
        fetch_asset(asset, assets_path_list, assets_dir)
    }
	puts "pod assets list: #{pod_assets_list}"
elsif  option == 'duplicate'
    find_all_objc_path(main_project_dir, main_path_list)
    find_all_objc_path(pod_dir, pod_path_list)

    pod_path_list.each { |path|
        duplicate_objc_file(path, main_path_list)
    }        

elsif option == 'anjuke'
    find_all_imports_in_path(pod_dir, pod_path_list)
    #puts "imports: #{pod_path_list}"
    pod_path_list.each { |path|
        find_all_headers(common_business_dir, path, 'CommonBusiness', assets_path_list)
    }

    if assets_path_list.length > 0
        mv_file_list(assets_path_list, common_common_dir)
    end

elsif option == 'common_common'
    find_all_imports_in_path(common_common_dir, pod_path_list)
    #puts "imports: #{pod_path_list}"
    pod_path_list.each { |path|
        find_all_headers(common_business_dir, path, 'CommonBusiness', assets_path_list)
    }

    if assets_path_list.length > 0
        mv_file_list(assets_path_list, common_common_dir)
    end

elsif option == 'common_service'
    find_all_imports_in_path(common_common_dir, pod_path_list)
    #puts "imports: #{pod_path_list}"
    pod_path_list.each { |path|
        find_all_headers(service_dir, path, 'Service', assets_path_list)
    }

    if assets_path_list.length > 0
        mv_file_list(assets_path_list, common_service_dir)
    end

elsif option == 'service'
    find_all_imports_in_path(common_service_dir, pod_path_list)
    #puts "imports: #{pod_path_list}"
    pod_path_list.each { |path|
        find_all_headers(service_dir, path, 'Service', assets_path_list)
    }

    # puts "service list: #{assets_path_list}" 
    if assets_path_list.length > 0
        mv_file_list(assets_path_list, common_service_dir)
    end

else
	puts 'invalid option: use [ cp or fetch or assets ]'
end
