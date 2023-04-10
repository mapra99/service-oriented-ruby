require 'http'

# Plain HTTP GET request
response = HTTP.get('http://www.example.org')

puts response.status
puts response.status.success?
puts response.content_type.inspect
puts response.body

# JSON API GET call
response = HTTP.headers(accept: "application/json")
               .basic_auth(user: "smeagol", pass: "preciousss")
               .get("http://example.org/api/list")

puts response.status

# DRY up some shared configs on multiple requests
client = HTTP.headers(accept: "application/json")
             .basic_auth(user: "smeagol", pass: "preciousss")

client.get("http://example.org/api/list")
client.get("http://example.org/api/show/1")

# Persist connections
begin
  client = HTTP.persistent("http://example.org")
              .headers(accept: "application/json")
              .basic_auth(user: "smeagol", pass: "preciousss")

  client.get("/api/list").to_s
ensure
  client.close if client
end

