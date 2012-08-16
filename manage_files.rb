#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'

def consolidate_files(pandora_jam)
  Dir["#{pandora_jam}/*/**"].each do | from |
    to = "#{pandora_jam}/#{File.basename(from)}"
    if File.exists? to
      File.delete from
    else
      FileUtils.move from, to
    end
  end
end

def remove_duplicates(pandora_jam, target)
  Dir.foreach(pandora_jam) do | each |
    if File.exists?("#{target}/#{each}") and File.file?("#{target}/#{each}")
      file_to_delete = "#{pandora_jam}/#{each}"
      puts "deleting #{file_to_delete}"
      File.delete(file_to_delete)
    end
  end
end

def pick_songs(pandora_jam, target)
  files = Dir.glob("#{pandora_jam}/*.mp3").sort_by { |f| File.mtime(f) }
  files.reverse().each do | file |
    puts "Playing #{file}"
    pid = spawn "afplay \"#{file}\""
    puts "(k)eep, (d)elete, (s)kip, or (q)uit"
    choice = gets
    spawn "kill #{pid}"
    case choice
      when /d/
        puts "Deleting #{file}"
        File.delete(file)
      when /k/
        FileUtils.move file, target
      when /q/
        exit
    end
  end
end

def load_cache_file(file_name)
  if File.exists? file_name
    return IO.readlines file_name
  else
    File.new file_name, 'w'
    return []
  end
end

config = YAML.load_file("config/directories.yml")

pandora_jam = config['pandora_jam']
target = config['target']

skipped_cache = load_cache_file "config/.skipped"
deleted_cache = load_cache_file "config/.deleted"

consolidate_files pandora_jam
remove_duplicates pandora_jam, target
pick_songs pandora_jam, target
