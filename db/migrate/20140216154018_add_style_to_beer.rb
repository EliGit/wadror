class AddStyleToBeer < ActiveRecord::Migration
  def change
    add_column :beers, :style_id, :integer

    Beer.all.each {|b| b.style=Style.find_by(name: b.old_style)}
  end
end
