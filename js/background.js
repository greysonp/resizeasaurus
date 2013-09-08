chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    console.log(sender.tab ?
                "from a content script:" + sender.tab.url :
                "from the extension");
        if (request.win) {
            chrome.windows.create(request.win.props, function(thewin) {
                sendResponse(thewin);
            });
        }
        else if (request.removeId) {
            chrome.windows.remove(request.removeId)
        }
        else {
            chrome.windows.update(request.windowId, request.updateInfo);
        }
        return true;
  });