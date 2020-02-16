class Category < ApplicationRecord
  belongs_to :category_type
  has_and_belongs_to_many :posts

  attr_reader :category_type_desc

  def set_type
    @category_type_desc = CategoryType.where(id: category_type_id).first.cat_type
  end
end
