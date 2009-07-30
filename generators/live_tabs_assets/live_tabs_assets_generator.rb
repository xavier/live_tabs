class LiveTabsAssetsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "live_tabs.js",  "public/javascripts/live_tabs.js"
      m.file "live_tabs.css", "public/stylesheets/live_tabs.css"
    end
  end
end