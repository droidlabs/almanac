class AddSlugToAlmanacPosts < ActiveRecord::Migration
  def up
    change_table :almanac_posts do |t|
      t.string :slug
    end
  end

  def down
    remove_column :almanac_posts, :slug
  end
end
