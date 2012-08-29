Script for managing songs downloaded by PandoraJam.

## Features

* Consolidates and de-dupes songs recorded from different Pandora playlists.
* Plays recorded songs and lets you:
  1. Delete the song
  2. Keep the song (moves it to your music library directory)
  3. Skip the song (and evaluate another time)
* The most recently recorded songs are played first
* Remembers songs that you have previously skipped or deleted.

## Configuration

In the `config` directory, you will need to create a `directories.yml`
file and configure to directories, `pandora_jam` and `target`

## Executing

Once you have configured your directories, you simply execute the manage_files
ruby script.

## Caching

Any skipped or deleted files are "remembered" in the `config/.skipped` 
or `config/.deleted` files, respectively. If you want to stop skipping
or deleting a song, simply remove it from the cache file. To reset the 
cache entirely, simply delete the file.