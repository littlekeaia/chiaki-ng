import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

import org.streetpea.chiaking

Pane {
    padding: 0
    id: consolePane
    StackView.onActivated: {
        forceActiveFocus(Qt.TabFocusReason);
        if(!Chiaki.autoConnect && !root.initialAsk && !Chiaki.window.directStream)
        {
            root.initialAsk = true;
            if(Chiaki.settings.addSteamShortcutAsk && (typeof Chiaki.createSteamShortcut === "function"))
                root.showRemindDialog(qsTr("官方 Steam 封面图 + 手柄布局"), qsTr("是否为 chiaki-ng 创建新的非 Steam 游戏，\n或用官方封面图和手柄布局更新已有的非 Steam 游戏？") + "\n\n" + qsTr("（注意：若现在选否，之后想设置可点击按钮或在主菜单按 R3。）"), false, () => root.showSteamShortcutDialog(true));
            else if(Chiaki.settings.remotePlayAsk)
            {
                if(!Chiaki.settings.psnRefreshToken || !Chiaki.settings.psnAuthToken || !Chiaki.settings.psnAuthTokenExpiry || !Chiaki.settings.psnAccountId)
                    root.showRemindDialog(qsTr("通过 PSN 遥控游玩"), qsTr("是否连接 PSN？\n启用后可：\n- 自动注册\n- 在家庭网络之外游玩而无需端口转发？") + "\n\n" + qsTr("（注意：若现在选否，之后可到设置的「配置」分区开启。）"), true, () => root.showPSNTokenDialog(false));
                else
                    Chiaki.settings.remotePlayAsk = false;
            }
        }
    }
    Keys.onUpPressed: {
        if(hostsView.currentItem && hostsView.currentItem.visible)
        {
            hostsView.decrementCurrentIndex()
            while(!hostsView.currentItem.visible)
                hostsView.decrementCurrentIndex()
        }
    }
    Keys.onDownPressed: {
        if(hostsView.currentItem && hostsView.currentItem.visible)
        {
            hostsView.incrementCurrentIndex()
            while(!hostsView.currentItem.visible)
                 hostsView.incrementCurrentIndex()
        }
    }
    Keys.onMenuPressed: settingsButton.clicked()
    Keys.onReturnPressed: if (hostsView.currentItem) hostsView.currentItem.connectToHost()
    Keys.onYesPressed: if (hostsView.currentItem) hostsView.currentItem.wakeUpHost()
    Keys.onNoPressed: if (hostsView.currentItem) hostsView.currentItem.deleteHost()
    Keys.onEscapePressed: root.showConfirmDialog(qsTr("退出"), qsTr("确定要退出吗？"), () => Qt.quit())
    Keys.onPressed: (event) => {
        if (event.modifiers)
            return;
        switch (event.key) {
        case Qt.Key_PageUp:
            if (hostsView.currentItem) hostsView.currentItem.setConsolePin();
            event.accepted = true;
            break;
        case Qt.Key_PageDown:
            if (Chiaki.settings.psnAuthToken) Chiaki.refreshPsnToken();
            event.accepted = true;
            break;
        case Qt.Key_F1:
            if (typeof Chiaki.createSteamShortcut === "function") root.showSteamShortcutDialog(false);
            event.accepted = true;
            break;
        case Qt.Key_F2:
            root.showManualHostDialog();
            event.accepted = true;
            break;
        }
    }

    ToolBar {
        id: toolBar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 80

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 10
                rightMargin: 10
            }

            Button {
                Layout.fillHeight: true
                Layout.preferredWidth: 100
                flat: true
                text: "×"
                font.pixelSize: 60
                focusPolicy: Qt.NoFocus
                onClicked: Qt.quit()
                Material.roundedScale: Material.SmallScale
            }

            Item { Layout.fillWidth: true }

            Button {
                Layout.fillHeight: true
                Layout.preferredWidth: 350
                flat: true
                text: "创建 Steam 快捷方式"
                focusPolicy: Qt.NoFocus
                onClicked: root.showSteamShortcutDialog(false)
                Material.roundedScale: Material.SmallScale
                visible: typeof Chiaki.createSteamShortcut === "function"
                Image {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 12
                    }
                    width: 28
                    height: 28
                    sourceSize: Qt.size(width, height)
                    source: "qrc:/icons/l3.svg"
                }
            }

            Button {
                Layout.fillHeight: true
                Layout.preferredWidth: 400
                flat: true
                text: "刷新 PSN 主机"
                icon.source: "qrc:/icons/r1.svg"
                focusPolicy: Qt.NoFocus
                onClicked: Chiaki.refreshPsnToken();
                Material.roundedScale: Material.SmallScale
                visible: Chiaki.settings.psnAuthToken
            }

            Button {
                Layout.fillHeight: true
                Layout.preferredWidth: 400
                flat: true
                focusPolicy: Qt.NoFocus
                Material.roundedScale: Material.SmallScale
                visible: !Chiaki.settings.psnAuthToken
            }

            Button {
                Layout.fillHeight: true
                Layout.preferredWidth: 300
                flat: true
                text: "添加手动主机"
                focusPolicy: Qt.NoFocus
                onClicked: root.showManualHostDialog()
                Material.roundedScale: Material.SmallScale
                Image {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 12
                    }
                    width: 28
                    height: 28
                    sourceSize: Qt.size(width, height)
                    source: "qrc:/icons/r3.svg"
                }
            }

            Button {
                id: settingsButton
                Layout.fillHeight: true
                Layout.preferredWidth: 100
                flat: true
                icon.source: "qrc:/icons/settings-20px.svg";
                icon.width: 50
                icon.height: 50
                focusPolicy: Qt.NoFocus
                onClicked: root.showSettingsDialog()
                Material.roundedScale: Material.SmallScale
            }
        }
    }

    ListView {
        id: hostsView
        keyNavigationWraps: true
        anchors {
            top: toolBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 50
        }
        clip: true
        model: Chiaki.hosts
        onCountChanged: {
            if(!hostsView.currentItem)
                hostsView.incrementCurrentIndex();
            if(!hostsView.currentItem)
                return;
            if(!hostsView.currentItem.visible)
            {
                for(var i = 0; i < hostsView.count; i++)
                {
                    hostsView.incrementCurrentIndex()
                    if(hostsView.currentItem.visible)
                    {
                        break;
                    }
                }
            }
        }
        delegate: ItemDelegate {
            visible: modelData.display
            id: delegate
            width: parent ? parent.width : 0
            height: modelData.display ? 180 : 0
            highlighted: ListView.isCurrentItem
            onClicked: connectToHost()

            function connectToHost() {
                if(modelData.discovered)
                    Chiaki.connectToHost(index, modelData.name);
                else
                    Chiaki.connectToHost(index);
            }

            function wakeUpHost() {
                if(!modelData.discovered && !modelData.duid)
                    Chiaki.wakeUpHost(index);
            }

            function deleteHost() {
                if (modelData.manual)
                    root.showConfirmDialog(qsTr("删除主机"), qsTr("确定要删除此主机吗？"), () => {Chiaki.deleteHost(index)});
                        
                else if (modelData.discovered && !modelData.registered)
                    root.showConfirmDialog(qsTr("隐藏主机"), qsTr("确定要隐藏此主机吗？") + "\n\n" + qsTr("注意：可在设置的「主机」分区中通过「已隐藏主机」取消隐藏"), () => Chiaki.hideHost(modelData.mac, modelData.name));

            }

            function setConsolePin() {
                root.showConsolePinDialog(index);
            }

            RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 30
                    rightMargin: 10
                    topMargin: 10
                    bottomMargin: 10
                }
                spacing: 50

                Image {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 150
                    fillMode: Image.PreserveAspectFit
                    source: "image://svg/console-ps" + (modelData.ps5 ? "5" : "4") + (modelData.state == "standby" ? "#light_standby" : "#light_on")
                    sourceSize: Qt.size(width, height)
                }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: {
                        let t = "";
                        if (modelData.name)
                            t += modelData.name + "\n";
                        if (modelData.address)
                            t += qsTr("地址：%1").arg(Chiaki.settings.streamerMode ? "hidden" : modelData.address);
                        if (modelData.mac)
                            t += "\n" + qsTr("ID：%1（%2）").arg(Chiaki.settings.streamerMode ? "hidden" : modelData.mac).arg(modelData.registered ? qsTr("已注册") : qsTr("未注册"));
                        if (modelData.duid)
                        {
                            if(modelData.discovered)
                                t += "\n" + qsTr("可自动注册");
                            else
                                t += "\n" + qsTr("通过 PSN 远程连接");
                        } 
                        else
                        {
                            t += "\n";
                            if(modelData.discovered)
                            {
                                if(modelData.manual)
                                    t += qsTr("已发现 + 手动")
                                else
                                    t += qsTr("已发现");
                            }
                            else
                                t += qsTr("手动");
                        }
                        return t;
                    }
                }

                Label {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    text: {
                        let t = "";
                        if(modelData.duid)
                            return t;
                        t += qsTr("状态：%1").arg(modelData.state);
                        if(!modelData.discovered)
                            return t;
                        if (modelData.app)
                            t += "\n" + qsTr("应用：%1").arg(modelData.app);
                        if (modelData.titleId)
                            t += "\n" + qsTr("标题 ID：%1").arg(modelData.titleId);
                        return t;
                    }
                }

                Item { Layout.fillWidth: true }

                ColumnLayout {
                    Layout.fillHeight: true
                    spacing: 0

                    Button {
                        Layout.alignment: Qt.AlignCenter
                        text: modelData.manual ? qsTr("删除") : qsTr("隐藏")
                        flat: true
                        padding: 20
                        leftPadding: delegate.highlighted ? 50 : undefined
                        focusPolicy: Qt.NoFocus
                        visible: modelData.manual || (modelData.discovered && !modelData.registered)
                        onClicked: delegate.deleteHost()
                        Material.roundedScale: Material.SmallScale

                        Image {
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 12
                            }
                            width: 28
                            height: 28
                            sourceSize: Qt.size(width, height)
                            source: root.controllerButton("box")
                            visible: delegate.highlighted
                        }
                    }

                    Button {
                        Layout.alignment: Qt.AlignCenter
                        text: qsTr("唤醒")
                        flat: true
                        padding: 20
                        leftPadding: delegate.highlighted ? 50 : undefined
                        visible: modelData.registered && !modelData.duid && !modelData.discovered
                        focusPolicy: Qt.NoFocus
                        onClicked: delegate.wakeUpHost()
                        Material.roundedScale: Material.SmallScale

                        Image {
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 12
                            }
                            width: 28
                            height: 28
                            sourceSize: Qt.size(width, height)
                            source: root.controllerButton("pyramid")
                            visible: delegate.highlighted
                        }
                    }

                    Button {
                        Layout.alignment: Qt.AlignCenter
                        text: qsTr("更新主机 PIN 码")
                        flat: true
                        padding: 20
                        leftPadding: delegate.highlighted ? 50 : undefined
                        visible: modelData.registered
                        focusPolicy: Qt.NoFocus
                        onClicked: delegate.setConsolePin()
                        Material.roundedScale: Material.SmallScale

                        Image {
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 12
                            }
                            width: 28
                            height: 28
                            sourceSize: Qt.size(width, height)
                            source: "qrc:/icons/l1.svg"
                            visible: delegate.highlighted
                        }
                    }
                } 
            } 
        }
    }     

    RoundButton {
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 20
        }
        icon.source: "qrc:/icons/discover-" + (checked ? "" : "off-") + "24px.svg"
        icon.width: 50
        icon.height: 50
        padding: 20
        focusPolicy: Qt.NoFocus
        checkable: true
        checked: Chiaki.discoveryEnabled
        onToggled: Chiaki.discoveryEnabled = !Chiaki.discoveryEnabled
        Material.background: Material.accent
    }

    Label {
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }
        text: Qt.application.version
    }

    Image {
        id: logoImage
        anchors.centerIn: parent
        source: "qrc:/icons/chiaking-logo-white.svg"
        sourceSize: Qt.size(Math.min(parent.width, parent.height) / 2, Math.min(parent.width, parent.height) / 2)

        PropertyAnimation {
            target: logoImage
            property: "opacity"
            from: 0.05
            to: 0.20
            duration: 1000
            easing.type: Easing.OutCubic
            running: true
        }
    }
}
