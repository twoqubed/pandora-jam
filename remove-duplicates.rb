#!/usr/bin/env ruby

# Removes files that already exist in the the Google Drive folder

pandora = "/Users/twoqubed/Music/PandoraJam"
google_drive = "/Users/twoqubed/Google Drive/Music"

Dir.foreach(pandora) do | each |
  if File.exists?("#{google_drive}/#{each}") and File.file?("#{google_drive}/#{each}")
    file_to_delete = "#{pandora}/#{each}"
    puts "deleting #{file_to_delete}"
    File.delete(file_to_delete)
  end
end