require_relative '../lib/transaction'

RSpec.describe Transaction do
  let(:t_1) { Transaction.new({ :id => 6,
                  :invoice_id => 8,
                  :credit_card_number => "4242424242424242",
                  :credit_card_expiration_date => "0220",
                  :result => "success",
                  :created_at => Time.now,
                  :updated_at => Time.now
                }) }
  let(:t_2) { Transaction.new({ :id => 1, 
                  :invoice_id => 2,
                  :credit_card_number => "4242424242424243",
                  :credit_card_expiration_date => "0221",
                  :result => "failed",
                  :created_at => Time.now,
                  :updated_at => Time.now
                }) }  
 
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
end
  