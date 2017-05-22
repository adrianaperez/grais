class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :comment_text,  presence: true, length: { maximum: 140 }

  attr_accessor :user_name, :user_img

  # Sobreescribir la funcion as_json
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:user_name, :user_img])
    super options
  end
end
