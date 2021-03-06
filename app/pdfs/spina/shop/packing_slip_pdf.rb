require 'prawn/measurement_extensions'

module Spina::Shop
  class PackingSlipPdf < Prawn::Document
    def initialize(order)
      super(page_size: "A4", margin: 15.mm, print_scaling: :none)
      @order = order

      # Base font size
      font_families.update(
        "Proxima Nova" => {
          normal: "#{Rails.root}/app/assets/fonts/proximanova-regular-webfont.ttf",
          semibold: "#{Rails.root}/app/assets/fonts/proximanova-semibold-webfont.ttf",
          bold: "#{Rails.root}/app/assets/fonts/proximanova-bold-webfont.ttf",
          italic: "#{Rails.root}/app/assets/fonts/proximanova-regitalic-webfont.ttf"
        },
        "Icons" => {
          normal: "#{Rails.root}/app/assets/fonts/plango-next.ttf"
        }
      )
      font "Proxima Nova"
      font_size 10
      default_leading 3

      mr_hop()
      header()
      order_title()
      order_details()

      number_pages "<page> / <total>", 
       {:at => [bounds.right - 50, 0],
        :align => :right,
        :size => 14}
    end

    def mr_hop
      float do
        indent(12.cm) do
          text "Mr Hop", style: :semibold, size: 14
          text "Keizersveld 1"
          text "1234 AB, Venray"
          move_down 13
          text "www.mrhop.nl"
          text "info@mrhop.nl"
        end
      end
    end

    def header
      text "Pakbon", style: :semibold, size: 28
      fill_color '999999'
      text "#{I18n.l @order.order_prepared_at, format: '%d %B %Y - %H:%M'}"
      fill_color '000000'
      move_down 5.cm
    end

    def order_title
      text "Bestelling ##{@order.number}", style: :semibold, size: 18
      text "#{@order.order_items.sum(:quantity)} producten", size: 14
    end

    def order_details
      lines = [["Aantal", "Omschrijving", "Locatie", "Controle"]]

      @order.order_items.includes(:orderable).sort_by{|o| (o.orderable.try(:location).present? ? "0" : "1") + o.orderable.try(:location).to_s}.each do |order_item|

        if order_item.is_product_bundle?
          order_item.orderable.bundled_products.each do |bundled_product|
            lines << ["#{bundled_product.quantity * order_item.quantity} x", bundled_product.product.name, bundled_product.product.location, ""]
          end
        else
          lines << ["#{order_item.quantity} x", order_item.description, order_item.orderable.location, ""]
        end
      end

      table lines, header: true, column_widths: {0 => 2.cm, 1 => 10.cm}, width: bounds.width, cell_style: {borders: [:top], border_color: "DDDDDD", padding: 10} do |t|
        t.before_rendering_page do |page|
          page.row(0).border_top_width = 0
          page.row(0).font_style = :bold
          page.row(1).border_top_width = 2
          page.column(0).align = :right
          page.column(3).align = :right
        end
      end
    end
  end
end