#!/usr/bin/env ruby

# Iterates over files in the PanjoraJam directory (most recent first)
# and opens a preview window. When the preview window is closed, offers
# a choice to either:
# - (s)kip the file (nothing happens)
# - (k)eep the file (file is copied to Google Drive folder)
# - (d)elete 

require 'fileutils'

pandora = "/Users/twoqubed/Music/PandoraJam"
google_drive = "/Users/twoqubed/Google Drive/Music/."

files = Dir.glob("#{pandora}/*.mp3").sort_by { |f| File.mtime(f) }
files.reverse().each do | file |
  `qlmanage -p "#{file}"`
  puts "(k)eep, (d)elete, (s)kip"
  choice = gets 
  case choice
    when /d/
      puts "Deleting #{file}"
      File.delete(file)
    when /k/
      FileUtils.move file, google_drive
  end
end