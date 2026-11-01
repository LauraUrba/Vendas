class AddAttachmentAvatarToProdutos < ActiveRecord::Migration[8.1]
  def change
    add_attachment :produtos, :avatar
  end
end
