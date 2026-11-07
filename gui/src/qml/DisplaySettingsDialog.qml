import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs

import org.streetpea.chiaking

import "controls" as C

DialogView {
    id: dialog
    property alias gridHeight: displayGrid.height
    title: qsTr("显示设置")
    header: qsTr("* 括号内为默认值，或标注为（默认）")
    buttonVisible: false

    Item {
        // Stream Display Settings
        GridLayout {
            id: displayGrid
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 20
            }
            columns: 3
            rowSpacing: 10
            columnSpacing: 20

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("目标基色：")
            }

            C.ComboBox {
                firstInFocusChain: true
                Layout.preferredWidth: 600
                model: [qsTr("自动"), qsTr("ITU-R Rec. BT.601 NTSC（标准色域）"), qsTr("ITU-R Rec. BT.601 PAL（标准色域）"), qsTr("ITU-R Rec. BT.709（标准色域）"), qsTr("ITU-R Rec. BT.470 M（标准色域）"), qsTr("EBU Tech. 3213-E（标准色域）"), qsTr("ITU-R Rec. BT.2020（广色域）"), qsTr("Apple RGB（广色域）"), qsTr("Adobe RGB（广色域）"), qsTr("ProPhoto RGB（广色域）"), qsTr("CIE 1931 RGB 基色（广色域）"), qsTr("DCI-P3（广色域）"), qsTr("D65 白点 DCI-P3（广色域）"), qsTr("Panasonic V-Gamut（广色域）"), qsTr("Sony S-Gamut（广色域）"), qsTr("Illuminant C 传统胶片基色（广色域）"), qsTr("ACES 基色 #0（广色域）"), qsTr("ACES 基色 #1（广色域）")]
                currentIndex: Chiaki.settings.displayTargetPrim
                onActivated: index => Chiaki.settings.displayTargetPrim = index
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("（自动）")
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("目标传输特性：")
            }

            C.ComboBox {
                Layout.preferredWidth: 600
                model: [qsTr("自动"), qsTr("ITU-R Rec. BT.1886（SDR）"), qsTr("IEC 61966-2-4 sRGB（SDR）"), qsTr("线性光内容（SDR）"), qsTr("纯幂 gamma 1.8（SDR）"), qsTr("纯幂 gamma 2.0（SDR）"), qsTr("纯幂 gamma 2.2（SDR）"), qsTr("纯幂 gamma 2.4（SDR）"), qsTr("纯幂 gamma 2.6（SDR）"), qsTr("纯幂 gamma 2.8（SDR）"), qsTr("ProPhoto RGB（SDR）"), qsTr("数字影院发行母版（SDR）"), qsTr("ITU-R BT.2100 PQ / SMPTE ST2048（HDR）"), qsTr("ITU-R BT.2100 HLG / ARIB STD-B67（HDR）"), qsTr("Panasonic V-Log（HDR）"), qsTr("Sony S-Log1（HDR）"), qsTr("Sony S-Log2（HDR）")]
                currentIndex: Chiaki.settings.displayTargetTrc
                onActivated: index => Chiaki.settings.displayTargetTrc = index
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("（自动）")
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("目标峰值：")
            }

            C.ComboBox {
                id: targetPeakChoice
                Layout.preferredWidth: 400
                model: [qsTr("自动"), qsTr("数值")]
                currentIndex: {
                    if(Chiaki.settings.displayTargetPeak == 0)
                        0;
                    else
                        1;
                }
                onActivated: index => {
                    if(index == 0)
                        Chiaki.settings.displayTargetPeak = 0;
                    else if(index == 1)
                        Chiaki.settings.displayTargetPeak = 1000;
                }
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("（自动）")
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("目标峰值数值：")
                visible: targetPeakChoice.currentIndex == 1
            }
            
            C.Slider {
                id: targetPeakValue
                Layout.preferredWidth: 250
                from: 10
                to: 10000
                stepSize: 10
                value: Chiaki.settings.displayTargetPeak
                onMoved: Chiaki.settings.displayTargetPeak = value

                Label {
                    anchors {
                        left: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 10
                    }
                    text: parent.value + qsTr(" 尼特")
                }
                visible: targetPeakChoice.currentIndex == 1
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("（1000 尼特）")
                visible: targetPeakChoice.currentIndex == 1
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("目标对比度：")
            }

            C.ComboBox {
                id: targetContrastChoice
                Layout.preferredWidth: 400
                lastInFocusChain: currentIndex != 2
                model: [qsTr("自动"), qsTr("无限"), qsTr("数值")]
                currentIndex: {
                    if(Chiaki.settings.displayTargetContrast == -1)
                        1;
                    else if(Chiaki.settings.displayTargetContrast == 0)
                        0;
                    else
                        2;
                }
                onActivated: index => {
                    if(index == 0)
                        Chiaki.settings.displayTargetContrast = 0;
                    else if(index == 1)
                        Chiaki.settings.displayTargetContrast = -1;
                    else if(index == 2)
                        Chiaki.settings.displayTargetContrast = 1000;
                }
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("（自动）")
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("目标对比度数值：")
                visible: targetContrastChoice.currentIndex == 2
            }
            
            C.Slider {
                id: targetContrastValue
                Layout.preferredWidth: 250
                from: 10
                to: 1000000
                stepSize: 1000
                value: Chiaki.settings.displayTargetContrast
                onMoved: Chiaki.settings.displayTargetContrast = value

                Label {
                    anchors {
                        left: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 10
                    }
                    text: parent.value
                }
                visible: targetContrastChoice.currentIndex == 2
                lastInFocusChain: true
            }

            Label {
                Layout.alignment: Qt.AlignRight
                visible: targetContrastChoice.currentIndex == 2
                text: qsTr("（1000）")
            }
        }
    }
}