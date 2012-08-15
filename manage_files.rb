#!/usr/bin/env ruby

require 'fileutils'

def consolidate_files(pandora)
  Dir["#{pandora}/*/**"].each do | file |
    file_name = file.split("/").last
    target = "#{pandora}/#{file_name}"
    if File.exists? target
      File.delete file
    else
      FileUtils.move file, target
    end
  end
end

def remove_duplicates(pandora, google_drive)
  Dir.foreach(pandora) do | each |
    if File.exists?("#{google_drive}/#{each}") and File.file?("#{google_drive}/#{each}")
      file_to_delete = "#{pandora}/#{each}"
      puts "deleting #{file_to_delete}"
      File.delete(file_to_delete)
    end
  end
end

def pick_songs(pandora, google_drive)
  files = Dir.glob("#{pandora}/*.mp3").sort_by { |f| File.mtime(f) }
  files.reverse().each do | file |
    puts "Playing #{file}"
    pid = spawn "afplay \"#{file}\""
    puts "(k)eep, (d)elete, (s)kip"
    choice = gets
    spawn "kill #{pid}"
    case choice
      when /d/
        puts "Deleting #{file}"
        File.delete(file)
      when /k/
        FileUtils.move file, google_drive
    end
  end
end

pandora = File.expand_path "~/Music/PandoraJam"
google_drive = File.expand_path "~/Google Drive/Music"

consolidate_files pandora
remove_duplicates pandora, google_drive
pick_songs pandora, google_drive
