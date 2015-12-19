require! {
  \child_process : {exec-sync}
  \./files.json
}

set-exif = (name, timestamp)->
  year = timestamp.get-full-year!
  month = timestamp.get-month! + 1
  date = timestamp.get-date!
  hour = timestamp.get-hours!
  minute = timestamp.get-minutes!
  second = timestamp.get-seconds!
  exec-sync "exiftool \"-AllDates=#{year}:#{month}:#{date} #{hour}:#{minute}:#{second}\" -overwrite_original converted-images/#{name}.jpg"

jpg = (name, _, timestamp)->
  exec-sync "cp images/#{name}.jpg converted-images/#{name}.jpg"
  set-exif name, timestamp

png = (name, _, timestamp)->
  exec-sync "convert images/#{name}.png converted-images/#{name}.jpg"
  set-exif name, timestamp

gif = (name, _, timestamp)->
  exec-sync "cp images/#{name}.gif converted-images/#{name}.gif"

other = (name, ext, timestamp)->
  console.log "Not found: #{name}.#{ext}: #{timestamp}"

Object
  .keys files
  .forEach (filename)->
    [name, ext] = filename.split \.
    timestamp = new Date files[filename] * 1000
    fn =
      switch ext
      | \jpg => jpg
      | \png => png
      | \gif => gif
      | otherwise => other
    try
      fn name, ext, timestamp
    catch err
      console.log err
