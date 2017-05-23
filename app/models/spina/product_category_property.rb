module Spina
  class ProductCategoryProperty < ApplicationRecord
    belongs_to :product_category
    has_many :property_options, dependent: :destroy

    scope :product_type, -> { where(property_type: 'product') }
    scope :item_type, -> { where(property_type: 'item') }

    validates :name, :label, :property_type, :field_type, presence: true

    accepts_nested_attributes_for :property_options, allow_destroy: true, reject_if: :all_blank
  end
end