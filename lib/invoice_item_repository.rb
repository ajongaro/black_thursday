# frozen_string_literal: true

require_relative 'repository'

class InvoiceItemRepository < Repository
  def find_all_by_item_id(item_id)
    @all.find_all do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @all.find_all do |invoice_item|
      invoice_item.invoice_id == invoice_id
    end
  end

  def update(id, attributes)
    sanitized_attributes = {
      quantity: attributes[:quantity],
      unit_price: attributes[:unit_price],
      updated_at: Time.now
    }.compact
    super(id, sanitized_attributes)
  end
end
