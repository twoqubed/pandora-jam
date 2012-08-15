#!/usr/bin/env ruby

# Consolidates and de-dupes files in the PandoraJam subdirectories.

require 'fileutils'

pandora = File.expand_path "~/Music/PandoraJam"

Dir["#{pandora}/*/**"].each do | file |
  file_name = file.split("/").last
  target = "#{pandora}/#{file_name}"
  if File.exists? target
    File.delete file
  else
    FileUtils.move file, target
  end
end
