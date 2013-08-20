observer = new MutationObserver (objects, self) ->
    owner_id = window.location.search.match(/owner=(\d+)/)[1]
    for object in objects
        for node in object.addedNodes
            if node.id == "externalswf"
                chrome.extension.sendRequest {url: node.src, owner_id: owner_id}
observer.observe $("#flashWrap").get(0), {childList: true}
