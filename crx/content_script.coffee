observer = new MutationObserver (objects, self) ->
    for object in objects
        for node in object.addedNodes
            if node.id == "externalswf"
                chrome.extension.sendRequest {url: node.src}

observer.observe $("#flashWrap").get(0), {childList: true}
