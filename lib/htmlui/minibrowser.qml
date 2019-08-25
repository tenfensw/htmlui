import QtQuick 2.0
import QtQuick.Window 2.0
import QtWebEngine 1.4
import HTMLUILogic.HTMLUIController 1.0

Window {
    id: head
    width: 1024
    height: 750
    visible: true
    HTMLUIController {
	id: uiProv
	windowConnected: head
    }
    WebEngineView {
        anchors.fill: parent
        url: uiProv.content
	id: wv
	onNavigationRequested: function(url) { 
		uiProv.decide(url.url.toString(), this); 
		if (url.url.toString().startsWith('rb:'))
			url.action = WebEngineNavigationRequest.IgnoreRequest; 
	}
	onJavaScriptDialogRequested: function(rq) { rq.accepted = false; }
    }

}
