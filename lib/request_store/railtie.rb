module RequestStore
  class Railtie < ::Rails::Railtie
    initializer "request_store.insert_middleware" do |app|
      binding.pry
      unless app.config.middleware.map(&:name).include? 'RequestStore::Middleware'
        if ActionDispatch.const_defined? :RequestId
          app.config.middleware.insert_after ActionDispatch::RequestId, RequestStore::Middleware
        else
          app.config.middleware.insert_after Rack::MethodOverride, RequestStore::Middleware
        end
      end

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
