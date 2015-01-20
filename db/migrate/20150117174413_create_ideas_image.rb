class CreateIdeasImage < ActiveRecord::Migration
  def change
    create_table :ideas_images do |t|
      t.references :idea, index: true
      t.references :image, index: true
    end
    add_foreign_key :ideas_images, :ideas
    add_foreign_key :ideas_images, :images
  end
end
