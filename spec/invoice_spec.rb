require_relative '../lib/invoice'

RSpec.describe Invoice do
  let(:invoice_1) do
    Invoice.new({ id: 6,
                  customer_id: 7,
                  merchant_id: 8,
                  status: 'pending',
                  created_at: Time.now,
                  updated_at: Time.now })
  end

  let(:invoice_2) do
    Invoice.new({ id: 1,
                  customer_id: 2,
                  merchant_id: 3,
                  status: 'shipped',
                  created_at: Time.now,
                  updated_at: Time.now })
  end

  describe '#id' do
    it 'returns the integer id ' do
      expect(invoice_1.id).to eq(6)
      expect(invoice_2.id).to eq(1)
    end
  end

  describe '#customer_id' do
    it 'returns the customer id' do
      expect(invoice_1.customer_id).to eq(7)
      expect(invoice_2.customer_id).to eq(2)
    end
  end

  describe '#merchant_id' do
    it 'returns the merchant id' do
      expect(invoice_1.merchant_id).to eq(8)
      expect(invoice_2.merchant_id).to eq(3)
    end
  end

  describe '#status' do
    it 'returns the status' do
      expect(invoice_1.status).to eq(:pending)
      expect(invoice_2.status).to eq(:shipped)
    end
  end

  describe '#created_at' do
    it 'returns a Time instance for the date the item was first created' do
      expect(invoice_1.created_at).to be_a(Time)
      expect(invoice_2.created_at).to be_a(Time)
    end
  end

  describe '#updated_at' do
    it 'returns a Time instance for the date the item was last modified' do
      expect(invoice_1.updated_at).to be_a(Time)
      expect(invoice_2.updated_at).to be_a(Time)
    end
  end
end
