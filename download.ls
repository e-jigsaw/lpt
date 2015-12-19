require! {
  \./urls.json
  request
  fs: {writeFileSync}
}

download = (list)->
  target = list.shift!
  filename = target.split \/ |> -> it[*-1]
  err, res, body <- request do
    url: target
    encoding: null
  writeFileSync "images/#{filename}", body
  if list.length > 0 then download list

console.log "Photos length: #{urls.length}"
download urls
