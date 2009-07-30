require File.join(File.dirname(__FILE__), 'test_helper.rb')
require File.join(File.dirname(__FILE__), '../lib/live_tabs.rb')

class LiveTabsTest < ActiveSupport::TestCase
  
  test "string to tab name conversion" do

    assert_equal "tab1", LiveTabs.string_to_tab_name("")
    assert_equal "tab1", LiveTabs.string_to_tab_name("é'\\§")
    assert_equal "tab35", LiveTabs.string_to_tab_name("", 35)

    assert_equal "12345", LiveTabs.string_to_tab_name("12345")
    
    assert_equal "tab", LiveTabs.string_to_tab_name("Tab")
    assert_equal "tab_name", LiveTabs.string_to_tab_name("Tab Name")
    assert_equal "tab_name", LiveTabs.string_to_tab_name("Tab-Name")
    assert_equal "project_area_51", LiveTabs.string_to_tab_name("Project 'Area 51'")
    assert_equal "franois_1er", LiveTabs.string_to_tab_name("François 1er")
  
  end
  
end
