chrome.extension.onRequest.addListener (request, sender, response) ->
    $.ajax "http://localhost:2411", {
        type: 'POST'
        data: request
    }
