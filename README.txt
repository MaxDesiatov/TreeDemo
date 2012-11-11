Primitive tree control based on UITableView.  At the moment it is embeded in
its own demo app.  It permits deletion, insertion, renaming and reordering of 
nodes.  The app itself also (de)serializes its state between launches.

KNOWN ISSUES:
    * collapse/expand indicators not rendered correctly after data was reloaded
      if node was in collapsed state.  This stems from not so tight connection
      between MDTreeViewCell and MDTreeNode.  Maybe could be done properly with
      a separate delegate.
    * reordering children of the same parent doesn't always preserve order of
      children.  This is an inherent problem "making a tree control from a table
      control" approach.  I guess it's better to implement a tree view basing on 
      a Collection View, which was introduced in iOS 6.
      
Application icon is CC Attribution-Noncommercial-No Derivative Works 3.0 
taken from here http://www.1000vectors.com/download-icons-free/application-icons/upojenie-iphone-ipod-icon-set.htm