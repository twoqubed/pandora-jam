#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'

def consolidate_files(pandora_jam)
  Dir["#{pandora_jam}/*/**"].each do | from |
    to = "#{pandora_jam}/#{File.basename(from)}"
    if File.exists? to
      puts "Updating timestamp on #{to}"
      File.delete to
    end
    FileUtils.move from, to
  end
end

def remove_duplicates(pandora_jam, target)
  Dir.foreach(pandora_jam) do | each |
    if File.exists?("#{target}/#{each}") and File.file?("#{target}/#{each}")
      file_to_delete = "#{pandora_jam}/#{each}"
      puts "#{file_to_delete} already exists in target directory. Deleting."
      File.delete(file_to_delete)
    end
  end
end

def cached?(file, skipped_cache, deleted_cache)
  if skipped_cache.include? file
    puts "skipping #{file}"
    return true
  end

  if deleted_cache.include? file
    puts "Deleting #{file}"
    File.delete(file)
    return true
  end
  return false
end

def prompt_for_choice(file)
  puts "Playing #{file}"
  pid = spawn "afplay \"#{file}\""
  puts "(k)eep, (d)elete, (s)kip, or (q)uit"
  choice = gets
  spawn "kill #{pid}"
  return choice
end

def process_choice(choice, file, skipped_cache, target)
  case choice
    when /d/
      puts "Deleting #{file}"
      File.delete(file)
    when /k/
      FileUtils.move file, target
    when /s/
      skipped_cache.push file
      File.open("config/.skipped", 'a') {|f| f.puts file }
    when /q/
      exit
    end
end

def pick_songs(pandora_jam, target, skipped_cache, deleted_cache)
  files = Dir.glob("#{pandora_jam}/*.mp3").sort_by { |f| File.mtime(f) }
  files.reverse().each do | file |
    if (!cached? file, skipped_cache, deleted_cache)
      choice = prompt_for_choice file
      process_choice choice, file, skipped_cache, target
    end
  end
end

def load_cache_file(file_name)
  if File.exists? file_name
    cache = IO.readlines file_name
    cache.each { |line| line.strip! }
    return cache
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
pick_songs pandora_jam, target, skipped_cache, deleted_cache
