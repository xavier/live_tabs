# Include hook code here
require 'live_tabs'

ActionView::Base.send       :include, LiveTabsHelper
ActionController::Base.send :include, LiveTabsControllerMixin
