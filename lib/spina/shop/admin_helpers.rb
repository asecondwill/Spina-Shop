module Spina
  module Shop
    module AdminHelpers

      def link_to_add_price_exception(f, &block)
        new_object = OpenStruct.new({price: "", customer_group_id: ""})
        id = new_object.object_id
        fields = render(partial: 'price_exception_fields', locals: {f: f, price_exception: new_object})
        link_to '#', class: "add_price_exception button button-link pull-right", style: "margin: 0; padding-right: 0", data: {id: id, fields: fields.gsub("\n", "")} do
          block.yield
        end
      end

      def link_to_add_address(f, association, &block)
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
          render("address_fields", f: builder)
        end
        link_to '#', class: "add_address_fields button button-link", data: {id: id, fields: fields.gsub("\n", "")} do
          block.yield
        end
      end

      def link_to_add_product_fields(f, association, &block)
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
          render("bundled_products_fields", f: builder)
        end
        link_to '#', class: "add_product_fields button button-link button-block", data: {id: id, fields: fields.gsub("\n", "")} do
          block.yield
        end
      end

      def link_to_add_property_option_fields(f, association, &block)
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
          render partial: "spina/shop/admin/settings/product_category_properties/property_options_fields", locals: {f: builder}
        end
        link_to '#', class: "add_property_option_fields button button-link button-block", data: {id: id, fields: fields.gsub("\n", "")} do
          block.yield
        end
      end

    end
  end
end