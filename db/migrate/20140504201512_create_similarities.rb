class CreateSimilarities < ActiveRecord::Migration
  def up
  	create_table :similarities do |t|
  		t.integer :document_id
  		t.integer :similar_document_id
  		t.float :score
  	end
  end

  def down
  	drop_table :similarities
  end
end
