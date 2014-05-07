require 'sinatra'
require 'json'
require 'pp'
require 'sinatra/activerecord'
require './config/environments'
Dir.glob('./models/*.rb').each { |r| require r}

get '/' do

end

get '/similar' do
  content_type :json

  url = params[:url]
  document = Document.find_by_url(url)
  
  halt 404 unless document
  
  # Tidy response
  similar = []
  document.similarities.each do |similarity| 
  	similar << {    :title => similarity.similar_document.title, 
  					:url => similarity.similar_document.url, 
  					:image => similarity.similar_document.image, 
  					:score => similarity.score }
  end
  
  JSON.pretty_generate(similar)
end
