
Tabset = Class.create();

Object.extend(Tabset, {

	initialize: function(autoactivate) {
		autoactivate = typeof(autoactivate) != 'undefined' ? autoactivate : true;
		// Find all tabset containers
		$$('.tabs').each(function(container){
			var tabs = container.select('.tab');//Panes
			var tablist_id = 'tablist_'+container.id;	
			var tabList, activeTab;
			//(Re)Create a list to contain the tab elements, remember the active tab
			if (tabList = $(tablist_id)) { 
				activeTab = tabList.down('.active')
				//alert("Found activeTab of "+tablist_id+" = " + activeTab)
				tabList.remove(); 
			}
			tabList = new Element('ul', {'class':'tablist', 'id':tablist_id});
			//Go through each tab panes
			tabs.each(function(tab){
				var li = new Element('li', {id:'tab_'+tab.id});//A tab
				// Reactive tab
				if (activeTab && activeTab.id == li.id) {
					li.addClassName('active');
				}
				li.update(tab.down('.title').innerHTML);
				//Observe the click event, this changes the active tab
				if (!tab.hasClassName('notabhandler')) {
					var handler;
					if (tab.hasClassName('callback')) {
						// has callback
						handler = function(){
							_handler = eval('tab_callback_'+container.id+'_'+tab.id);
							_handler();					
							//First, inactivate all tabs, then activate this tab
							tabList.select('li').invoke('removeClassName', 'active');
							li.addClassName('active');
							//Inactivate all tab panes, the activate the associated tab pane
							tabs.invoke('removeClassName', 'active');
							tab.addClassName('active');
							window.location.hash = '#'+tab.id;
						}
					} else {
						// default handler
						handler = function(){
							//First, inactivate all tabs, then activate this tab
							tabList.select('li').invoke('removeClassName', 'active');
							li.addClassName('active');
							//Inactivate all tab panes, the activate the associated tab pane
							tabs.invoke('removeClassName', 'active');
							tab.addClassName('active');
							window.location.hash = '#'+tab.id;
						}
					}
					li.observe('click', handler);
					li.observe('tabs:tabfocus', handler);
				}
				tabList.insert({bottom:li});//Add the tab to the list
			});
			container.addClassName('enhanced');//Make it targetable with CSS
			container.insert({top:tabList});//Add the tablist to the top of the container
			//Activate first tab if present and none already active
			if (autoactivate && (t = tabs.first())) {
				t.addClassName('active');
				tabList.down('li').addClassName('active');
			}    
		});

		if (window.location.hash != '') {
			tab_with_focus = 'tab_'+window.location.hash.substring(1, window.location.hash.length);
		  Event.fire(tab_with_focus, 'tabs:tabfocus'); 
		}

	}

});

document.observe('dom:loaded', Tabset.initialize);