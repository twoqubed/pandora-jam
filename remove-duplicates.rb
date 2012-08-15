#!/usr/bin/env ruby

# Removes files that already exist in the the Google Drive folder

pandora = File.expand_path "~/Music/PandoraJam"
google_drive = File.expand_path "~/Google Drive/Music"

Dir.foreach(pandora) do | each |
  if File.exists?("#{google_drive}/#{each}") and File.file?("#{google_drive}/#{each}")
    file_to_delete = "#{pandora}/#{each}"
    puts "deleting #{file_to_delete}"
    File.delete(file_to_delete)
  end
end