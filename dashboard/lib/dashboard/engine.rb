module Dashboard
  class Engine < ::Rails::Engine
    isolate_namespace Dashboard

    initializer 'activeservice.autoload', :before => :set_autoload_paths do |app|
      app.config.autoload_paths << "#{config.root}/lib"
      app.config.paths["db/migrate"] << "#{config.root}/db/migrate"
    end
  end
end
