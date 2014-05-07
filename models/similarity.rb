class Similarity < ActiveRecord::Base

	belongs_to :document, class_name: 'Document', foreign_key: 'document_id'
	belongs_to :similar_document, class_name: 'Document', foreign_key: 'similar_document_id'

end