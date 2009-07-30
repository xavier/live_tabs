
module LiveTabsControllerMixin
    
  # Sets the tab on focus when the page is loaded
  def set_tab_focus(name, tabset = :tabs)
    @tabs_focus ||= {}
    @tabs_focus[tabset] = LiveTabs.string_to_tab_name(name)
  end
  
end