module Spina::Shop
  class StockLevelAdjustment < ApplicationRecord
    belongs_to :product
    belongs_to :order_item, optional: true

    scope :additions, -> { where('adjustment > ?', 0) }
    scope :sales, -> { joins(:order_item).where('adjustment < ?', 0) }
    scope :ordered, -> { order(created_at: :desc) }

    validates :adjustment, presence: true
    
    def expiration_date
      "#{expiration_month || '–'}/#{expiration_year.to_s.last(2).presence || '–'}"
    end

  end
end