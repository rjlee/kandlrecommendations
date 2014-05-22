require 'sinatra'
require 'nokogiri'
require 'json'
require 'open-uri'
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

get '/guides/:id' do
  id = params[:id]
  url = "http://www.bbc.co.uk/guides/#{id}"
  source = open(url, &:read)

  promo = ''
  count = 0
  document = Document.find_by_url(url)
  iwonder1 = ''
  iwonder2 = ''
  gel1 = ''
  gel2 = ''
  gel3 = ''
  gel4 = ''
  document.similarities.each do |similarity|
    count+=1;
    next if count == 1

    if similarity.similar_document.url =~ /\/guides/
      if iwonder1.empty?
        p =erb :_promo_iwonder, :locals => {:id => 1, :link => similarity.similar_document.url, :image => similarity.similar_document.image, :title => similarity.similar_document.title} 
        iwonder1 = p
        next
      end
      if iwonder2.empty?
        p =erb :_promo_iwonder, :locals => {:id => 2, :link => similarity.similar_document.url, :image => similarity.similar_document.image, :title => similarity.similar_document.title} 
        iwonder2 = p
        next
      end
    else 
      if gel1.empty?
        p =erb :_promo_gel, :locals => {:id => 3, :link => similarity.similar_document.url, :image => similarity.similar_document.image, :title => similarity.similar_document.title} 
        gel1 = p
        next
      end
       if gel2.empty?
        p =erb :_promo_gel, :locals => {:id => 4, :link => similarity.similar_document.url, :image => similarity.similar_document.image, :title => similarity.similar_document.title} 
        gel2 = p
        next
      end
       if gel3.empty?
        p =erb :_promo_gel, :locals => {:id => 5, :link => similarity.similar_document.url, :image => similarity.similar_document.image, :title => similarity.similar_document.title} 
        gel3 = p
        next
      end
       if gel4.empty?
        p =erb :_promo_gel, :locals => {:id => 6, :link => similarity.similar_document.url, :image => similarity.similar_document.image, :title => similarity.similar_document.title} 
        gel4 = p
        next
      end
    end
  end

  promo = iwonder1+iwonder2+gel1+gel2+gel3+gel4
  doc = Nokogiri::HTML(source)
  doc.search("//div[contains(@class, 'promos')]").each do |node|
    node.children.remove
    node.inner_html=promo
  end


  doc.to_html
end
