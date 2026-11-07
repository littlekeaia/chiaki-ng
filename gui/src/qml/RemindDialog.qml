import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "controls" as C

import org.streetpea.chiaking

Dialog {
    id: dialog
    property alias text: label.text
    property var remotePlay
    property var callback
    property bool newDialogOpen: false
    property Item restoreFocusItem
    parent: Overlay.overlay
    x: Math.round((root.width - width) / 2)
    y: Math.round((root.height - height) / 2)
    modal: true
    Material.roundedScale: Material.MediumScale
    onOpened: label.forceActiveFocus(Qt.TabFocusReason)
    onAccepted: {
        newDialogOpen = true;
        restoreFocus();
        callback();
    }
    onRejected: {
        if(dialog.remotePlay)
            Chiaki.settings.remotePlayAsk = false;
        else
            Chiaki.settings.addSteamShortcutAsk = false;
    }
    onClosed: {
        if(newDialogOpen)
            return;
        restoreFocus();
        if(!remotePlay && Chiaki.settings.remotePlayAsk)
        {
            if(!Chiaki.settings.psnRefreshToken || !Chiaki.settings.psnAuthToken || !Chiaki.settings.psnAuthTokenExpiry || !Chiaki.settings.psnAccountId)
                root.showRemindDialog(qsTr("通过 PSN 遥控游玩"), qsTr("是否连接 PSN？\n启用后可：\n- 自动注册\n- 在家庭网络之外游玩而无需端口转发？") + "\n\n" + qsTr("（注意：若现在选否，之后可到设置的「配置」分区开启。）"), true, () => root.showPSNTokenDialog(false));
            else
                Chiaki.settings.remotePlayAsk = false;
        }
    }

    function restoreFocus() {
        if (restoreFocusItem)
            restoreFocusItem.forceActiveFocus(Qt.TabFocusReason);
        label.focus = false;
    }

    Component.onCompleted: {
        header.horizontalAlignment = Text.AlignHCenter;
        // Qt 6.6: Workaround dialog background becoming immediately transparent during close animation
        header.background = null;
    }

    ColumnLayout {
        spacing: 20

        Label {
            id: label
            Keys.onEscapePressed: dialog.reject()
            Keys.onReturnPressed: dialog.accept()
            Keys.onYesPressed: dialog.close()
        }

        RowLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 20

            Button {
                text: qsTr("是")
                Material.background: Material.accent
                flat: true
                leftPadding: 50
                onClicked: dialog.accept()
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
                    source: root.controllerButton("cross")
                }
            }

            Button {
                Material.background: Material.accent
                text: qsTr("否")
                flat: true
                leftPadding: 50
                onClicked: dialog.reject()
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
                    source: root.controllerButton("moon")
                }
            }

            Button {
                Material.background: Material.accent
                text: qsTr("稍后提醒我")
                flat: true
                leftPadding: 50
                onClicked: dialog.close()
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
                }
            }
        }
    }
}