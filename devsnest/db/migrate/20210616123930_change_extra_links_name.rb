class ChangeExtraLinksName < ActiveRecord::Migration[6.0]
  def change
    rename_column :contents, :extra_link1, :youtube_link
    rename_column :contents, :extra_link2, :reference_link
  end
end
