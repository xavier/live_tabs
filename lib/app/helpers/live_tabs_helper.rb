
module LiveTabsHelper
    
  def tabset(tabset_id = :tabs, tabset_options = {}, &b)
    tab_list = []
    
    def tab_list.tab(label, options = {}, html_options = {}, &block)
      self << [label, options, html_options, block]
    end
    
    b.call(tab_list)
    
    tabset_html = []
    callbacks = []
  
    tab_list.each_with_index do |tab_data, i|
      
      label, options, html_options, block = tab_data
      
      tab_html = content_tag(:legend, label, :class => 'title')
      tab_classes = [html_options[:class], 'tab']
      
      tab_name = LiveTabs.string_to_tab_name(label)
      
      if options[:partial] || options[:file] || options[:template]
        tab_html += render(options) || ''
      elsif options[:html]
        tab_html += options[:html]
      elsif options[:url]
        tab_html += %(<div id="inner_#{tab_name}"></div>)
        callbacks << [tab_name, options]
        tab_classes << 'callback'
      else
        tab_html += capture(&block)
      end
      
      html_options[:id] = tab_name
      html_options[:class] = tab_classes.compact.join(' ')
      
      tabset_html << content_tag(:fieldset, tab_html, html_options)
      
    end

    # Wrap contents
    html = content_tag(:div, tabset_html.join("\n"), 
                         :id => tabset_id, 
                         :class => tabset_options[:class] ? (tabset_options[:class] + ' tabs') : 'tabs',
                         :style => tabset_options[:style])
                             
    tab_focus = @tabs_focus && @tabs_focus[tabset_id]
    
    # Add local Javascript when required
    if callbacks.any? || tab_focus
        # Open tab with focus
        local_js = tab_focus ? "document.observe('dom:loaded',function(){if(window.location.hash!=''){Event.fire('tab_'+window.location.hash.substring(1, window.location.hash.length), 'tabs:tabfocus');}else{#{open_tab(tab_focus)};};});" : ''
        # Add callbacks for AJAX tabs
        local_js += callbacks.map do |tab_name, options|
          options[:update] = target = "inner_#{tab_name}"
          options[:method] ||= :get
          if (placeholder = (options.delete(:placeholder) || tabset_options[:placeholder]))
            placeholder_js = "$('#{target}').update('#{escape_javascript(placeholder)}');"
          end
          "var tab_callback_#{tabset_id}_#{tab_name} = function(){ #{placeholder_js}#{remote_function(options)} };"
        end.join("\n")
        html += javascript_tag(local_js)
    end
  
    concat(html)
  end
  
  # Returns the JavaScript code to set the focus on the given tab
  def open_tab(tab_id)
    "Event.fire('tab_#{tab_id}', 'tabs:tabfocus');"
  end
  
  # Generates a link to open the given tab, the :options: hash accepts all parameters available to link_to_function
  def link_to_tab_with_id(label, tab_id, options = {})
    link_to_function(label, open_tab(tab_id), options)
  end

  def link_to_tab_with_name(label, tab_name, options = {})
    link_to_tab_with_id(label, LiveTabs.string_to_tab_name(tab_name), options)
  end
  
end