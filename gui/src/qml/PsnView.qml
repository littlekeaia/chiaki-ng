import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import org.streetpea.chiaking

Rectangle {
    id: view
    property bool allowClose: false
    property bool cancelling: false
    property bool textVisible: true
    property bool registOnly: false
    property list<Item> restoreFocusItems
    color: "black"

    StackView.onActivated: infoLabel.visible = false

    function stop() {
        if (!allowClose)
            return;
        allowClose = false;
        cancelling = true;
        infoLabel.text = qsTr("正在通过 PSN 取消与主机的连接…");
        Chiaki.psnCancel(false);
    }

    function grabInput(item) {
        Chiaki.window.grabInput();
        restoreFocusItems.push(Window.window.activeFocusItem);
        if (item)
            item.forceActiveFocus(Qt.TabFocusReason);
    }

    function releaseInput() {
        Chiaki.window.releaseInput();
        let item = restoreFocusItems.pop();
        if (item && item.visible)
            item.forceActiveFocus(Qt.TabFocusReason);
    }

    Keys.onEscapePressed: view.stop()

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: view.stop()
    }

    MouseArea {
        anchors.fill: parent
        enabled: view.allowClose
        acceptedButtons: Qt.RightButton
        onClicked: view.stop()
    }

    Label {
        id: infoLabel
        anchors.centerIn: parent
        opacity: textVisible ? 1.0: 0.0
        visible: opacity
        text: qsTr("正在通过 PSN 建立与主机的连接…")
        Behavior on opacity { NumberAnimation { duration: 250 } }
    }

    Item {
        anchors {
            top: parent.verticalCenter
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        BusyIndicator {
            id: spinner
            anchors.centerIn: parent
            width: 70
            height: width
        }

        Label {
            id: closeMessageLabel
            anchors {
                top: spinner.bottom
                horizontalCenter: spinner.horizontalCenter
                topMargin: 30
            }
            opacity: (textVisible && !cancelling) ? 1.0: 0.0
            visible: opacity
            text: {
                var typeString = registOnly ? qsTr("自动注册") : qsTr("通过 PSN 远程连接")
                qsTr("按 %1 取消 %2").arg(Chiaki.controllers.length ? (root.controllerButton("circle").includes("deck") ? "B" : "Circle") : "escape or right-click").arg(typeString)
            }
        }

        Label {
            id: errorTitleLabel
            anchors {
                bottom: spinner.top
                horizontalCenter: spinner.horizontalCenter
            }
            font.pixelSize: 24
            visible: text
            onVisibleChanged: {
                if (visible) {
                    textVisible = false
                    view.allowClose = false
                    view.grabInput(errorTitleLabel)
                }
            }
            Keys.onReturnPressed: root.showMainView()
            Keys.onEscapePressed: root.showMainView()
        }

        Label {
            id: errorTextLabel
            anchors {
                top: errorTitleLabel.bottom
                horizontalCenter: errorTitleLabel.horizontalCenter
                topMargin: 10
            }
        }
    }

    Timer {
        id: closeTimer
        interval: 1500
        running: true
        onTriggered: {
            view.allowClose = true
            infoLabel.visible = infoLabel.opacity
        }
    }

    Timer {
        id: failTimer
        interval: 2000
        running: false
        onTriggered: root.showMainView()
    }

    Dialog {
        id: sessionPinDialog
        parent: Overlay.overlay
        x: Math.round((root.width - width) / 2)
        y: Math.round((root.height - height) / 2)
        title: qsTr("主机登录 PIN 码")
        modal: true
        closePolicy: Popup.NoAutoClose
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAboutToShow: {
            standardButton(Dialog.Ok).enabled = Qt.binding(function() {
                return pinField.acceptableInput;
            });
            textVisible = false
            view.grabInput(pinField);
        }
        onClosed: {
            textVisible = true
            view.releaseInput()
        }
        onAccepted: Chiaki.enterPin(pinField.text)
        onRejected: Chiaki.stopSession(false)
        Material.roundedScale: Material.MediumScale

        TextField {
            id: pinField
            echoMode: Chiaki.settings.streamerMode ? TextInput.Password : TextInput.Normal
            implicitWidth: 200
            validator: RegularExpressionValidator { regularExpression: /[0-9]{4}/ }
            Keys.onReturnPressed: {
                if(sessionPinDialog.standardButton(Dialog.Ok).enabled)
                    sessionPinDialog.standardButton(Dialog.Ok).clicked()
            }
        }
    }

    Connections {
        target: Chiaki

        function onConnectStateChanged() 
        {
            switch(Chiaki.connectState)
            {
                case Chiaki.PsnConnectState.LinkingConsole:
                    infoLabel.text = registOnly ? qsTr("正在向 PlayStation 主机注册 chiaki-ng…") : qsTr("正在将 chiaki-ng 与 PlayStation 主机配对…")
                    view.allowClose = false
                    break
                case Chiaki.PsnConnectState.RegisteringConsole:
                    view.registOnly = true;
                    break
                case Chiaki.PsnConnectState.RegistrationFinished:
                    infoLabel.text = qsTr("主机注册成功")
                    failTimer.restart()
                    break
                case Chiaki.PsnConnectState.DataConnectionStart:
                    infoLabel.text = qsTr("主机已配对…正在通过 PSN 建立数据连接…")
                    view.allowClose = true
                    break
                case Chiaki.PsnConnectState.DataConnectionFinished:
                    view.allowClose = false
                    break
                case Chiaki.PsnConnectState.ConnectFailed:
                    if(!cancelling)
                        infoLabel.text = qsTr("通过 PSN 连接失败，正在关闭…")
                    failTimer.running = true
                    break
                case Chiaki.PsnConnectState.ConnectFailedStart:
                    if(!cancelling)
                        infoLabel.text = qsTr("PSN 无法与 PlayStation 建立连接，请重试…")
                    failTimer.running = true
                    break
                case Chiaki.PsnConnectState.ConnectFailedConsoleUnreachable:
                    if(!cancelling)
                        infoLabel.text = qsTr("无法通过已建立的连接联系 PlayStation，可能是网络类型不受支持")
                    failTimer.running = true
                    break
                case Chiaki.PsnConnectState.WaitingForInternet:
                    infoLabel.text = qsTr("正在建立到 PSN 的互联网连接…")
                    break
            }
        }

        function onSessionChanged() 
        {
            if (!Chiaki.session) {
                if (errorTitleLabel.text)
                    failTimer.start();
                else if(!failTimer.running)
                    root.showMainView();
            }
        }

        function onSessionError(title, text)
        {
            errorTitleLabel.text = title;
            errorTextLabel.text = text;
            closeTimer.start();
        }

        function onSessionPinDialogRequested() 
        {
            if (sessionPinDialog.opened)
                return;
            sessionPinDialog.open();
        }
    }
}
