require_relative '../lib/transaction'

RSpec.describe Transaction do
  let(:t_1) do
    Transaction.new({ id: 6,
                      invoice_id: 8,
                      credit_card_number: '4242424242424242',
                      credit_card_expiration_date: '0220',
                      result: 'success',
                      created_at: Time.now,
                      updated_at: Time.now })
  end
  let(:t_2) do
    Transaction.new({ id: 1,
                      invoice_id: 2,
                      credit_card_number: '4242424242424243',
                      credit_card_expiration_date: '0221',
                      result: 'failed',
                      created_at: Time.now,
                      updated_at: Time.now })
  end

  describe '#initialize' do
    it 'exist' do
      expect(t_1).to be_a(Transaction)
    end
  end

  describe '#id' do
    it 'returns the integer id ' do
      expect(t_1.id).to eq(6)
      expect(t_2.id).to eq(1)
    end
  end

  describe '#invoice_id' do
    it 'returns the invoice id' do
      expect(t_1.invoice_id).to eq(8)
      expect(t_2.invoice_id).to eq(2)
    end
  end

  describe '#credit_card_number' do
    it 'returns matches of credit card number' do
      expect(t_1.credit_card_number).to eq('4242424242424242')
      expect(t_2.credit_card_number).to eq('4242424242424243')
    end
  end

  describe '#credit_card_expiration_date' do
    it 'returns matches of credit card expiration date' do
      expect(t_1.credit_card_expiration_date).to eq('0220')
      expect(t_2.credit_card_expiration_date).to eq('0221')
    end
  end

  describe '#result' do
    it 'returns the result' do
      expect(t_1.result).to eq(:success)
      expect(t_2.result).to eq(:failed)
    end
  end

  describe '#created_at' do
    it 'returns a Time for the date the transaction was first created' do
      expect(t_1.created_at).to be_a(Time)
      expect(t_2.created_at).to be_a(Time)
    end
  end

  describe '#updated_at' do
    it 'returns a Time for the date the transaction was last modified' do
      expect(t_1.updated_at).to be_a(Time)
      expect(t_2.updated_at).to be_a(Time)
    end
  end
end
