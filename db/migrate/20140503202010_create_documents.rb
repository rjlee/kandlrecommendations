class CreateDocuments < ActiveRecord::Migration
  def up
  	create_table :documents do |t|
  		t.string :title
  		t.string :url
  		t.string :image
  	end
  end
 
  def down
  	drop_table :documents
  end
end
