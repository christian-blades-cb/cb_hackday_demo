require 'sinatra'

get '/' do
  File.read('mapbox.html');
end

get '/assets/:asset' do
  asset = File.absolute_path("assets/#{params[:asset]}")
  puts asset
  File.read asset
end
