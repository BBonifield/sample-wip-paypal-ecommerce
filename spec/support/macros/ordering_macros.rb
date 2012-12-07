module OrderingMacros
  module ClassMethods
    def klass_should_order_by klass, field
      it "should order by #{field}" do
        factory_name = klass.name.tableize.singularize

        last_object = FactoryGirl.create factory_name, field => 3
        first_object = FactoryGirl.create factory_name, field => 1
        middle_object = FactoryGirl.create factory_name, field => 2

        klass.all.should eq [ first_object, middle_object, last_object ]
      end
    end
  end

  def self.included receiver
    receiver.extend ClassMethods
  end
end
