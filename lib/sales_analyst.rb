# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

class SalesAnalyst
  include MakeTime
  attr_reader :items,
              :merchants,
              :invoices,
              :customers,
              :invoice_items,
              :transactions

  def initialize(items, merchants, invoices, customers, invoice_items, transactions)
    @items = items
    @merchants = merchants
    @invoices = invoices
    @customers = customers
    @invoice_items = invoice_items
    @transactions = transactions
  end

  def average_items_per_merchant
    (@items.all.size.to_f / @merchants.all.size).round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    sum = array_of_items_per_merchant.sum(0.0) { |element| (element - mean)**2 }
    variance = sum / (@merchants.all.size - 1)
    Math.sqrt(variance).round(2)
  end

  def array_of_items_per_merchant
    @merchants.all.map do |merchant|
      @items.find_all_by_merchant_id(merchant.id).size
    end
  end

  def merchants_with_high_item_count
    one_std_dev_above_avg = avg_plus_std_dev
    @merchants.all.select do |merchant|
      @items.find_all_by_merchant_id(merchant.id).size > one_std_dev_above_avg
    end
  end

  def avg_plus_std_dev
    (average_items_per_merchant + average_items_per_merchant_standard_deviation).to_i
  end

  def average_item_price_for_merchant(merchant_id)
    sum_of_items = @items.find_all_by_merchant_id(merchant_id).sum(&:unit_price)
    number_of_items = @items.find_all_by_merchant_id(merchant_id).size
    (sum_of_items / number_of_items).round(2)
  end

  def average_average_price_per_merchant
    total_of_averages = @merchants.all.sum do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    (total_of_averages / @merchants.all.size).floor(2)
  end

  def average_item_price
    sum_of_items = @items.all.sum(&:unit_price)
    sum_of_items / @items.all.size
  end

  def average_item_price_std_dev
    mean = average_item_price
    sum = array_of_items_price.sum(0.0) { |element| (element - mean)**2 }
    variance = sum / (@items.all.size - 1)
    Math.sqrt(variance).round(2)
  end

  def array_of_items_price
    @items.all.map(&:unit_price)
  end

  def golden_items
    two_std_devs_above_avg = (average_item_price + (average_item_price_std_dev * 2))
    @items.all.select do |item|
      item.unit_price > two_std_devs_above_avg
    end
  end

  def average_invoices_per_merchant
    (@invoices.all.size / @merchants.all.size.to_f).round(2)
  end

  def invoices_for_each_of_the_merchants
    @merchants.all.map do |merchant|
      @invoices.find_all_by_merchant_id(merchant.id).size
    end
  end

  def average_invoices_per_merchant_standard_deviation
    mean = average_invoices_per_merchant
    sum = invoices_for_each_of_the_merchants.sum(0.00) { |element| (element - mean)**2 }
    variance = sum / (@merchants.all.size - 1)
    Math.sqrt(variance).round(2)
  end

  def top_merchants_by_invoice_count
    two_std_devs_above_avg = average_invoices_per_merchant + (average_invoices_per_merchant_standard_deviation * 2)
    @merchants.all.find_all do |merchant|
      @invoices.find_all_by_merchant_id(merchant.id).size >= two_std_devs_above_avg
    end
  end

  def bottom_merchants_by_invoice_count
    two_std_devs_below_avg = average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2)
    @merchants.all.find_all do |merchant|
      @invoices.find_all_by_merchant_id(merchant.id).size <= two_std_devs_below_avg
    end
  end

  def invoice_days
    @invoices.all.map do |invoice|
      invoice.created_at.strftime('%A')
    end.tally
  end

  def max_invoices_in_a_day
    invoice_days.max_by do |_key, value|
      value
    end[1]
  end

  def top_days_by_invoice_count
    invoice_days.select do |_key, value|
      value == max_invoices_in_a_day
    end.keys
  end

  def invoice_status(status)
    invoices_with_status = @invoices.find_all_by_status(status).size
    (invoices_with_status / @invoices.all.size.to_f * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    results = @transactions.find_all_by_invoice_id(invoice_id).select do |transaction|
      transaction.result == :success
    end
    !results.empty?
  end

  def invoice_total(invoice_id)
    return 0 unless invoice_paid_in_full?(invoice_id)

    @invoice_items.find_all_by_invoice_id(invoice_id).sum do |invoice_item|
      invoice_item.unit_price * invoice_item.quantity
    end
  end

  def merchant_paid_in_full?(merchant_id)
    @invoices.find_all_by_merchant_id(merchant_id).all? do |invoice|
      invoice_paid_in_full?(invoice.id)
    end
  end

  def merchants_with_pending_invoices
    @merchants.all.find_all do |merchant|
      !merchant_paid_in_full?(merchant.id)
    end.uniq
  end

  def items_and_quantities_sold_for(merchant_id)
    item_quantities = Hash.new(0)

    @items.find_all_by_merchant_id(merchant_id).each do |item|
      @invoice_items.find_all_by_item_id(item.id).each do |invoice_item|
        item_quantities[item] += invoice_item.quantity if invoice_paid_in_full?(invoice_item.invoice_id)
      end
    end
    item_quantities
  end

  def most_sold_items_for_merchant(merchant_id)
    item_quantities = items_and_quantities_sold_for(merchant_id)
    highest_quantity = item_quantities.max_by { |_item, quantity| quantity }
    item_quantities.select do |_key, value|
      value == highest_quantity[1]
    end.keys
  end

  def items_and_dollar_amount_sold_for(merchant_id)
    item_quantities = Hash.new(0)

    @items.find_all_by_merchant_id(merchant_id).each do |item|
      @invoice_items.find_all_by_item_id(item.id).each do |invoice_item|
        if invoice_paid_in_full?(invoice_item.invoice_id)
          item_quantities[item] += (invoice_item.quantity * invoice_item.unit_price)
        end
      end
    end
    item_quantities
  end

  def best_item_for_merchant(merchant_id)
    item_dollar_amounts = items_and_dollar_amount_sold_for(merchant_id)
    item_dollar_amounts.max_by { |_item, dollar_amount| dollar_amount }[0]
  end

  def revenue_by_merchant(merchant_id)
    merchant_invoices = @invoices.find_all_by_merchant_id(merchant_id)
    merchant_invoices.sum do |invoice|
      invoice_total(invoice.id)
    end
  end

  def top_revenue_earners(number_of_top_earners = 20)
    sorted_merchants = @merchants.all.sort_by do |merchant|
      revenue_by_merchant(merchant.id)
    end
    sorted_merchants.reverse[0...number_of_top_earners]
  end

  def merchants_with_only_one_item
    @merchants.all.find_all do |merchant|
      @items.find_all_by_merchant_id(merchant.id).size == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_with_only_one_item.find_all do |merchant|
      merchant.created_at.month == Time.parse(month).month
    end
  end

  def total_revenue_by_date(date)
    invoices_by_date = @invoices.all.find_all do |invoice|
      invoice.created_at == return_time_from(date)
    end
    invoices_by_date.sum do |invoice|
      invoice_total(invoice.id)
    end
  end
end
