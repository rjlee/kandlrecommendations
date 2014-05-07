class Document < ActiveRecord::Base

  has_many :similarities, -> { order "score DESC" }, foreign_key: 'document_id', class_name: 'Similarity'
  has_many :similar_documents, through: :similarities

  def self.load_data
  	similarity = self.load_similarity_data
  	docindex = self.load_document_index
  	docdata = self.load_document_data

  	# Load docs
  	docdata.each do |doc|
  		document = doc[1].symbolize_keys
                data = {:title => document[:title], :url => document[:url]}
                data[:image] = document[:images].first unless document[:images].nil? || document[:images].empty?
  		self.new(data).save!
  	end

  	# Load similarities
  	similarity.each do |id|
  		parent_id = id[0]
  		parent_doc = Document.find_by_url(docdata[docindex[parent_id.to_i]][:url])
  		id[1].each do |similar|
  			similar_doc = Document.find_by_url(docdata[docindex[similar[:id].to_i]][:url])
  			Similarity.create!(:document => parent_doc, :similar_document => similar_doc,  :score => similar[:score])
  		end
  	end

  end

  protected
  def self.load_similarity_data(file = File.join(File.dirname(__FILE__), '../../kandlcontentpipeline', 'recommendations/processed/similarity.txt'))
    sfile = File.open file, "r"
    similarity = {}
    sfile.each_line do |line|
      next unless line =~ /Key: (.+?): Value: (.+)/
      key = $1
      similarity[key] = []
      value = $2
      value =~ /{(.+)}/
      $1.split(/,/).each do |kv|
        kv =~ /(.+):(.+)/
        similarity[key] << {:id => $1, :score => $2}
      end
    end
    similarity
  end

  def self.load_document_index(file = File.join(File.dirname(__FILE__), '../../kandlcontentpipeline', 'recommendations/processed/docIndex.txt'))
    dfile = File.open file, "r"
    docindex = []
    dfile.each_line do |dline|
      next unless dline =~ /Key: (.+?): Value: (.+)/
      id = $2
      id.slice!(0)
      docindex[$1.to_i] = id
    end
    docindex
  end

  def self.load_document_data(dir = File.join(File.dirname(__FILE__), '../../kandlcontentpipeline', 'content/processed/'))
  	linkindex = {}
    Dir.foreach(dir) do |id|
      next if id == '.' or id == '..'
      data = File.open File.join(dir, id), "r"
      meta = JSON.parse(data.first)
      linkindex[id] = meta.symbolize_keys
      data.close
    end
    linkindex
  end


end
