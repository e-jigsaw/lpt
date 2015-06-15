require! {
  \./urls.json
  request
  fs: {writeFileSync}
}

download = (list)->
  target = list[0]
  splitedUrl = target.split \/
  filename = splitedUrl[splitedUrl.length - 1]
  request do
    url: target
    encoding: null
    (err, res, body)->
      writeFileSync "images/#{filename}", body
      slicedUrls = list.slice 1
      if slicedUrls.length > 0 then download slicedUrls

console.log "Photos length: #{urls.length}"
download urls
