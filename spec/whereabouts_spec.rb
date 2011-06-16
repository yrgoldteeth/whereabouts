require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Whereabouts" do
  before(:all){setup_test_db};after(:all){teardown_test_db}

  describe 'AR model Customer has_whereabouts :address and has_whereabouts :test_address with validation fields' do

    it 'sets a singleton method for address_whereabouts_validate_fields' do
      Customer.singleton_methods.include?(:address_whereabouts_validate_fields).should be true
    end

    it 'sets a singleton method for test_address_whereabouts_validate_fields' do
      Customer.singleton_methods.include?(:test_address_whereabouts_validate_fields).should be true
    end

    it 'sets a singleton method for address_whereabouts_geocode?' do
      Customer.singleton_methods.include?(:address_whereabouts_geocode?).should be true
    end

    it 'sets a singleton method for test_address_whereabouts_geocode?' do
      Customer.singleton_methods.include?(:test_address_whereabouts_geocode?).should be true
    end

    it 'returns [] on the singleton method if no list of attributes is sent for the :validate options' do
      Customer.address_whereabouts_validate_fields.should == []
    end

    it 'returns true on the singleton method if a list of attributes is sent for the :validate options' do
      Customer.test_address_whereabouts_validate_fields.should == [:line1, :city, :state, :zip]
    end
  end

  describe 'multiple AR models have the same whereabouts name with different validations' do
    before do
      address = {:city => 'Birmingham', :state => 'AL', :zip => '35205'}
      @competitor_test = Competitor.new.build_test_address(address)
      @customer_test   = Customer.new.build_test_address(address)
    end

    it 'validates correctly' do
      @competitor_test.valid?.should be true
      @customer_test.valid?.should be false
    end
  end

end
