require! {
  lson: {parseFile}
  \tumblr.js : tumblr
  fs: {writeFile}
}

client = tumblr.createClient parseFile \./.config.lson
targetMonth = new Date!.getMonth! - 1
urls = []

get = (offset = 0)-> client.posts do
  \tumblr.jgs.me
  type: \photo
  offset: offset
  (err, res)->
    console.log offset
    isFinish = false
    for post in res.posts
      postedMonth = new Date post.date .getMonth!
      if postedMonth is targetMonth then post.photos.forEach (photo)-> urls.push photo.original_size.url
      isFinish = postedMonth < targetMonth
    if isFinish then writeFile \urls.json, JSON.stringify urls else get offset + 20

get!
