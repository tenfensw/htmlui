import QtQuick 2.0
import QtQuick.Window 2.0
import QtWebEngine 1.4
import QtQuick.Dialogs 1.1
import HTMLUILogic.HTMLUIController 1.0

Window {
    id: head
    width: 1024
    height: 750
    visible: true
    FileDialog {
	id: fdialogBrowser
	title: "Please select a file to continue"
	onAccepted: uiProv.fdialogFileName = fileDialog.fileUrl;
	onRejected: uiProv.fdialogFileName = "";
    }
    HTMLUIController {
	id: uiProv
	windowConnected: head
	onOpenFileDialog: fdialogBrowser.visible = true
    }
    WebEngineView {
        anchors.fill: parent
        url: uiProv.content
	id: wv
	onNavigationRequested: function(url) { 
		let urlp = url.url.toString();
		if (!(urlp.endsWith('.css') || urlp.endsWith('.js') || urlp.endsWith('.png') || urlp.endsWith('.jpg') || urlp.endsWith('.jpeg') ||  urlp.endsWith('.map')))
			uiProv.decide(urlp, this); 
		if (urlp.startsWith('rb:'))
			url.action = WebEngineNavigationRequest.IgnoreRequest; 
	}
	onJavaScriptDialogRequested: function(rq) { rq.accepted = false; }
	onLinkHovered: function(rq) { this.runJavaScript("allEl = document.getElementsByTagName('*'); outEl = {}; for (let i = 0; i < allEl.length; i++) if (allEl[i].id) outEl[allEl[i].id] = allEl[i].value; outEl;", function(arr) { uiProv.cache_objects(arr); }) }
    }

}
