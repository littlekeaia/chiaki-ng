import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

import org.streetpea.chiaking

import "controls" as C

DialogView {

    buttonText: {
        if(deleteBox.visible && deleteBox.checked)
            qsTr("删除配置文件")
        else if(profileName.visible)
            qsTr("创建配置文件")
        else
            qsTr("切换配置文件")
    }
    buttonEnabled: {
        if(deleteBox.visible && deleteBox.checked)
            true
        else if(profileName.visible)
            profileName.text.trim();
        else
            !(profileComboBox.model[profileComboBox.currentIndex] == "default" && Chiaki.settings.currentProfile == "") && profileComboBox.model[profileComboBox.currentIndex] != Chiaki.settings.currentProfile
    }
    onAccepted: {
        if(deleteBox.visible && deleteBox.checked)
            Chiaki.settings.deleteProfile(profileComboBox.model[profileComboBox.currentIndex])
        else if(profileName.visible)
            Chiaki.settings.currentProfile = profileName.text.trim()
        else
            Chiaki.settings.currentProfile = profileComboBox.model[profileComboBox.currentIndex] == "default" ? "" : profileComboBox.model[profileComboBox.currentIndex]
        stack.pop()
        
    }

    Item {
        GridLayout {
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 50
            }
            columns: 2
            rowSpacing: 10
            columnSpacing: 20

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("用户配置文件：")
            }

            C.ComboBox {
                id: profileComboBox
                Layout.preferredWidth: 400
                firstInFocusChain: true
                model: Chiaki.settings.profiles
                currentIndex: Math.max(0, model.indexOf(Chiaki.settings.currentProfile))
                lastInFocusChain: model[currentIndex] == "default" || model[currentIndex] == Chiaki.settings.currentProfile
            }

            Label {
                text: qsTr("新配置文件名称")
                visible: profileComboBox.currentIndex == profileComboBox.model.indexOf("create new profile")
            }

            C.TextField {
                id: profileName
                visible: profileComboBox.currentIndex == profileComboBox.model.indexOf("create new profile")
                Layout.preferredWidth: 400
                lastInFocusChain: true
            }

            Label {
                text: qsTr("删除所选配置文件")
                visible: profileComboBox.model[profileComboBox.currentIndex] != "default" && profileComboBox.model[profileComboBox.currentIndex] != "create new profile" && profileComboBox.model[profileComboBox.currentIndex] != Chiaki.settings.currentProfile
            }

            C.CheckBox {
                id: deleteBox
                visible: profileComboBox.model[profileComboBox.currentIndex] != "default" && profileComboBox.model[profileComboBox.currentIndex] != "create new profile" && profileComboBox.model[profileComboBox.currentIndex] != Chiaki.settings.currentProfile
                lastInFocusChain: true
            }
        }
    }
}