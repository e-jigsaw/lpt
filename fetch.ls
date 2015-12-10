require! {
  lson: {parseFile}
  \tumblr.js : tumblr
  fs: {writeFile}
}

client = tumblr.createClient parseFile \./.config.lson
targetMonth = new Date!.getMonth! - 1
urls = []
files = {}

get = (offset = 0)->
  err, res <- client.posts do
    \tumblr.jgs.me
    type: \photo
    offset: offset

  console.log "Fetching: #{offset}"
  isFinish = false
  for post in res.posts
    postedMonth = new Date post.date .getMonth!
    if postedMonth is targetMonth
      post.photos.forEach (photo)->
        {url} = photo.original_size
        filename = url.split \/ |> -> it[*-1]
        urls.push url
        files[filename] = post.timestamp
    isFinish = postedMonth < targetMonth
  if isFinish
    writeFile \urls.json, JSON.stringify urls
    writeFile \files.json, JSON.stringify files
  else get offset + 20

get!
