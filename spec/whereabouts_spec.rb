require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Whereabouts" do
  before(:all){setup_test_db};after(:all){teardown_test_db}

  describe 'AR model Customer has_whereabouts :address and has_whereabouts :test_address with validation fields' do

    it 'sets a singleton method for address_whereabouts_validate_fields' do
      expect(Customer.singleton_methods.include?(:address_whereabouts_validate_fields)).to be true
    end

    it 'sets a singleton method for test_address_whereabouts_validate_fields' do
      expect(Customer.singleton_methods.include?(:test_address_whereabouts_validate_fields)).to be true
    end

    it 'sets a singleton method for address_whereabouts_geocode?' do
      expect(Customer.singleton_methods.include?(:address_whereabouts_geocode?)).to be true
    end

    it 'sets a singleton method for test_address_whereabouts_geocode?' do
      expect(Customer.singleton_methods.include?(:test_address_whereabouts_geocode?)).to be true
    end

    it 'returns [] on the singleton method if no list of attributes is sent for the :validate options' do
      expect(Customer.address_whereabouts_validate_fields).to eq []
    end

    it 'returns true on the singleton method if a list of attributes is sent for the :validate options' do
      expect(Customer.test_address_whereabouts_validate_fields).to eq [:line1, :city, :state, :zip]
    end
  end

  describe 'multiple AR models have the same whereabouts name with different validations' do
    before do
      address = {:city => 'Birmingham', :state => 'AL', :zip => '35205'}
      @competitor_test = Competitor.new.build_test_address(address)
      @customer_test   = Customer.new.build_test_address(address)
    end

    it 'validates correctly' do
      expect(@competitor_test.valid?).to be true
      expect(@customer_test.valid?).to be false
    end
  end

end
