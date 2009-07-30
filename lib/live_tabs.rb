# LiveTabs

# Configure load paths
%w{ helpers controllers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

module LiveTabs
  
  VERSION = "0.1.0"
  
  # This method is used both in the View helper and the controller mixin
  # I don't know why but I dont feel like adding it to String
  # Code is adapted from Rick Olsen's permalink_fu at http://github.com/technoweenie/permalink_fu/tree/master
  def self.string_to_tab_name(s, tab_index = 1)
     result = s.to_s
     result.gsub!(/[^\x00-\x7F]+/, '')  # Remove anything non-ASCII entirely (e.g. diacritics).
     result.gsub!(/[^\w_ \-]+/i,   '')  # Remove unwanted chars.
     result.gsub!(/[ \-]+/i,       '_') # No more than one of the separator in a row.
     result.gsub!(/^\-|\-$/i,      '')  # Remove leading/trailing separator.
     result.downcase!
     result.size.zero? ? "tab#{tab_index}" : result
   end
  
end