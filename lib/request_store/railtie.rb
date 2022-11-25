module RequestStore
  class Railtie < ::Rails::Railtie
    initializer "request_store.insert_middleware" do |app|
      if ActiveSupport.const_defined?(:Reloader) && ActiveSupport::Reloader.respond_to?(:to_complete)
        ActiveSupport::Reloader.to_complete do
          RequestStore.clear!
        end
      elsif ActionDispatch.const_defined?(:Reloader) && ActionDispatch::Reloader.respond_to?(:to_cleanup)
        ActionDispatch::Reloader.to_cleanup do
          RequestStore.clear!
        end
      end
    end
  end
end
