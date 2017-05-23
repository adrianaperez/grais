class Post < ApplicationRecord
  belongs_to :course
  belongs_to :user
  has_many :comments, dependent: :destroy #Elimina todos los comentarios al eliminar el post

  validates :post_text,  presence: true, length: { maximum: 140 }

  attr_accessor :user_id, :user_name, :user_img

  # Sobreescribir la funcion as_json
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:user_id, :user_name, :user_img])
    super options
  end
end
