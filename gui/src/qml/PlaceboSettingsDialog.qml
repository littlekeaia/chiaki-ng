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
    property string options_url: ""
    title: qsTr("Placebo 渲染器设置")
    header: qsTr("* 括号内为默认值，或标注为（默认）")
    buttonVisible: false
    Keys.onPressed: (event) => {
        if (event.modifiers)
            return;
        switch (event.key) {
        case Qt.Key_PageUp:
            bar.decrementCurrentIndex();
            event.accepted = true;
            break;
        case Qt.Key_PageDown:
            bar.incrementCurrentIndex();
            event.accepted = true;
            break;
        }
    }

    Item {
        TabBar {
            id: bar
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 5
            }

            TabButton {
                text: qsTr("配置")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("缩放")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("去隔行")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("去色带")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("S 形化")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("色彩")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("峰值检测")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("色彩映射")
                focusPolicy: Qt.NoFocus
            }
        }

        StackLayout {
            anchors {
                top: bar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            currentIndex: bar.currentIndex
            onCurrentIndexChanged: nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)

            Item {
                // Config
                GridLayout {
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 20
                    }
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 20

                    Label {
                        text: qsTr("Libplacebo 渲染器选项详情")
                        visible: !options_url
                    }

                    C.Button {
                        id: openwebpage
                        text: qsTr("打开文档")
                        onClicked: {
                            options_url = Chiaki.openPlaceboOptionsLink()
                        }
                        visible: !options_url
                    }

                    Label {
                        text: qsTr("在浏览器中打开已复制 URL 的文档")
                        visible: options_url
                    }

                    TextField {
                        id: openurl
                        echoMode: Chiaki.settings.streamerMode ? TextInput.Password : TextInput.Normal
                        text: options_url
                        visible: false
                        Layout.preferredWidth: 400
                    }

                    C.Button {
                        id: copyUrl
                        text: qsTr("点击重新复制 URL")
                        onClicked: {
                            openurl.selectAll()
                            openurl.copy()
                        }
                        visible: options_url
                    }

                    Label {
                        text: qsTr("导出渲染设置到文件")
                    }

                    C.Button {
                        id: exportButton
                        text: qsTr("导出")
                        onClicked: {
                            Chiaki.settings.exportPlaceboSettings();
                        }
                        Material.roundedScale: Material.SmallScale
                        KeyNavigation.down: importButton
                        KeyNavigation.right: importButton
                    }

                    Label {
                        text: qsTr("从文件导入渲染设置")
                    }

                    C.Button {
                        id: importButton
                        lastInFocusChain: true
                        text: qsTr("导入")
                        onClicked: {
                            Chiaki.settings.importPlaceboSettings();
                        }
                        Material.roundedScale: Material.SmallScale
                        KeyNavigation.up: exportButton
                        KeyNavigation.left: exportButton
                    }
                }
            }

            Item {
                // Scaling
                GridLayout {
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
                        text: qsTr("上采样器：")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("自定义"), qsTr("最近邻"), qsTr("双线性"), qsTr("过采样"), qsTr("双三次"), qsTr("高斯"), qsTr("Catmull-Rom"), qsTr("Lanczos"), qsTr("EwaLanczos"), qsTr("EwaLanczosSharp"), qsTr("EwaLanczosSharpest"), qsTr("FSR"), qsTr("FSRCNNX x2 8-0-4-1"), qsTr("FSRCNNX x2 16-0-4-1")]
                        currentIndex: Chiaki.settings.placeboUpscaler
                        onActivated: index => Chiaki.settings.placeboUpscaler = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（EwaLanczos）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("平面上采样器：")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("所选上采样器"), qsTr("最近邻"), qsTr("双线性"), qsTr("过采样"), qsTr("双三次"), qsTr("高斯"), qsTr("Catmull-Rom"), qsTr("Lanczos"), qsTr("EwaLanczos"), qsTr("EwaLanczosSharp"), qsTr("EwaLanczosSharpest")]
                        currentIndex: Chiaki.settings.placeboPlaneUpscaler
                        onActivated: index => Chiaki.settings.placeboPlaneUpscaler = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（所选上采样器）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("下采样器：")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("自定义"), qsTr("盒式"), qsTr("Hermite"), qsTr("双线性"), qsTr("双三次"), qsTr("高斯"), qsTr("Catmull-Rom"), qsTr("Mitchell"), qsTr("Lanczos")]
                        currentIndex: Chiaki.settings.placeboDownscaler
                        onActivated: index => Chiaki.settings.placeboDownscaler = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（Hermite）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("平面下采样器：")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("所选下采样器"), qsTr("盒式"), qsTr("Hermite"), qsTr("双线性"), qsTr("双三次"), qsTr("高斯"), qsTr("Catmull-Rom"), qsTr("Mitchell"), qsTr("Lanczos")]
                        currentIndex: Chiaki.settings.placeboPlaneDownscaler
                        onActivated: index => Chiaki.settings.placeboPlaneDownscaler = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（所选下采样器）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("抗振铃强度：")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboAntiringingStrength
                        onMoved: Chiaki.settings.placeboAntiringingStrength = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（0.00）")
                    }
                }
            }

            Item {
                // Deinterlace
                GridLayout {
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
                        text: qsTr("启用去隔行：")
                    }

                    C.CheckBox {
                        checked: Chiaki.settings.placeboDeinterlaceEnabled
                        onToggled: Chiaki.settings.placeboDeinterlaceEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（否）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("预设：")
                        visible: Chiaki.settings.placeboDeinterlaceEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("默认")]
                        currentIndex: Chiaki.settings.placeboDeinterlacePreset
                        enabled: Chiaki.settings.placeboDeinterlaceEnabled
                        visible: Chiaki.settings.placeboDeinterlaceEnabled
                        onActivated: index => Chiaki.settings.placeboDeinterlacePreset = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（默认）")
                        visible: Chiaki.settings.placeboDeinterlaceEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("算法：")
                        visible: Chiaki.settings.placeboDeinterlaceEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("Weave"), qsTr("Bob"), qsTr("Yadif"), qsTr("Bwdif")]
                        currentIndex: Chiaki.settings.placeboDeinterlaceAlgorithm
                        enabled: Chiaki.settings.placeboDeinterlaceEnabled
                        visible: Chiaki.settings.placeboDeinterlaceEnabled
                        onActivated: index => Chiaki.settings.placeboDeinterlaceAlgorithm = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（Yadif）")
                        visible: Chiaki.settings.placeboDeinterlaceEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("跳过空间检查：")
                        visible: Chiaki.settings.placeboDeinterlaceEnabled
                    }

                    C.CheckBox {
                        checked: Chiaki.settings.placeboDeinterlaceSkipSpatial
                        enabled: Chiaki.settings.placeboDeinterlaceEnabled
                        visible: Chiaki.settings.placeboDeinterlaceEnabled
                        onToggled: Chiaki.settings.placeboDeinterlaceSkipSpatial = checked
                        Material.roundedScale: Material.SmallScale
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（否）")
                        visible: Chiaki.settings.placeboDeinterlaceEnabled
                    }
                }
            }

            Item {
                // Debanding
                GridLayout {
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
                        text: qsTr("去色带启用：")
                    }

                    C.CheckBox {
                        text: qsTr("启用去色带")
                        checked: Chiaki.settings.placeboDebandEnabled
                        onToggled: Chiaki.settings.placeboDebandEnabled = checked
                    }


                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（已勾选）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("去色带预设：")
                        visible: Chiaki.settings.placeboDebandEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("自定义"), qsTr("默认")]
                        currentIndex: Chiaki.settings.placeboDebandPreset
                        onActivated: index => Chiaki.settings.placeboDebandPreset = index
                        visible: Chiaki.settings.placeboDebandEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（自定义）")
                        visible: Chiaki.settings.placeboDebandEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("去色带迭代次数：")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 16
                        stepSize: 1
                        value: Chiaki.settings.placeboDebandIterations
                        onMoved: Chiaki.settings.placeboDebandIterations = value
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr("%1").arg(parent.value)
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（1）")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("去色带阈值：")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 1000.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboDebandThreshold
                        onMoved: Chiaki.settings.placeboDebandThreshold = value
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（3.0）")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("去色带半径：")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 1000.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboDebandRadius
                        onMoved: Chiaki.settings.placeboDebandRadius = value
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（16.0）")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("去色带颗粒：")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 1000.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboDebandGrain
                        onMoved: Chiaki.settings.placeboDebandGrain = value
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（4.0）")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }
                }
            }

            Item {
                // Sigmoidization
                GridLayout {
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
                        text: qsTr("S 形化启用：")
                    }

                    C.CheckBox {
                        text: qsTr("启用 S 形化")
                        checked: Chiaki.settings.placeboSigmoidEnabled
                        onToggled: Chiaki.settings.placeboSigmoidEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（已勾选）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("S 形化预设：")
                        visible: Chiaki.settings.placeboSigmoidEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("自定义"), qsTr("默认")]
                        currentIndex: Chiaki.settings.placeboSigmoidPreset
                        onActivated: index => Chiaki.settings.placeboSigmoidPreset = index
                        visible: Chiaki.settings.placeboSigmoidEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（自定义）")
                        visible: Chiaki.settings.placeboSigmoidEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("S 形中心：")
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboSigmoidCenter
                        onMoved: Chiaki.settings.placeboSigmoidCenter = value
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（0.75）")
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("S 形斜率：")
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 1.0
                        to: 20.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboSigmoidSlope
                        onMoved: Chiaki.settings.placeboSigmoidSlope = value
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（6.5）")
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)
                    }
                }
            }

            Item {
                // Color
                GridLayout {
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
                        text: qsTr("色彩调整启用：")
                    }

                    C.CheckBox {
                        text: qsTr("启用色彩调整")
                        checked: Chiaki.settings.placeboColorAdjustmentEnabled
                        onToggled: Chiaki.settings.placeboColorAdjustmentEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（已勾选）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("色彩调整预设：")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("自定义"), qsTr("中性")]
                        currentIndex: Chiaki.settings.placeboColorAdjustmentPreset
                        onActivated: index => Chiaki.settings.placeboColorAdjustmentPreset = index
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（自定义）")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("亮度：")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: -1.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboColorAdjustmentBrightness
                        onMoved: Chiaki.settings.placeboColorAdjustmentBrightness = value
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（0.00）")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("对比度：")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboColorAdjustmentContrast
                        onMoved: Chiaki.settings.placeboColorAdjustmentContrast = value
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（1.0）")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("饱和度：")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboColorAdjustmentSaturation
                        onMoved: Chiaki.settings.placeboColorAdjustmentSaturation = value
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（1.0）")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("色相：")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 6.28
                        stepSize: 0.01
                        value: Chiaki.settings.placeboColorAdjustmentHue
                        onMoved: Chiaki.settings.placeboColorAdjustmentHue = value
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（0.00）")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("伽马：")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboColorAdjustmentGamma
                        onMoved: Chiaki.settings.placeboColorAdjustmentGamma = value
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（1.0）")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("色温：")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: -1.143
                        to: 5.286
                        stepSize: 0.001
                        value: Chiaki.settings.placeboColorAdjustmentTemperature
                        onMoved: Chiaki.settings.placeboColorAdjustmentTemperature = value
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(3))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（0.000）")
                        visible: Chiaki.settings.placeboColorAdjustmentEnabled && (Chiaki.settings.placeboColorAdjustmentPreset == 0)
                    }
                }
            }

            Item {
                // Peak Detection
                GridLayout {
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
                        text: qsTr("HDR 峰值检测启用：")
                    }

                    C.CheckBox {
                        text: qsTr("启用 HDR 峰值检测")
                        checked: Chiaki.settings.placeboPeakDetectionEnabled
                        onToggled: Chiaki.settings.placeboPeakDetectionEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（已勾选）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("峰值检测预设：")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("自定义"), qsTr("默认"), qsTr("高质量")]
                        currentIndex: Chiaki.settings.placeboPeakDetectionPreset
                        onActivated: index => Chiaki.settings.placeboPeakDetectionPreset = index
                        visible: Chiaki.settings.placeboPeakDetectionEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（高质量）")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("峰值平滑周期：")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 1000.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboPeakDetectionPeakSmoothingPeriod
                        onMoved: Chiaki.settings.placeboPeakDetectionPeakSmoothingPeriod = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（20.0）")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("场景阈值下限：")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboPeakDetectionSceneThresholdLow
                        onMoved: Chiaki.settings.placeboPeakDetectionSceneThresholdLow = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（1.0）")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("场景阈值上限：")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboPeakDetectionSceneThresholdHigh
                        onMoved: Chiaki.settings.placeboPeakDetectionSceneThresholdHigh = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（3.0）")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("峰值百分位：")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.001
                        value: Chiaki.settings.placeboPeakDetectionPeakPercentile
                        onMoved: Chiaki.settings.placeboPeakDetectionPeakPercentile = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(3))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（99.995）")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("黑位截止：")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboPeakDetectionBlackCutoff
                        onMoved: Chiaki.settings.placeboPeakDetectionBlackCutoff = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（1.0）")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("允许延迟峰值：")
                    visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }   

                    C.CheckBox {
                        text: qsTr("启用延迟 1 帧峰值")
                        checked: Chiaki.settings.placeboPeakDetectionAllowDelayedPeak
                        onToggled: Chiaki.settings.placeboPeakDetectionAllowDelayedPeak = checked
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（未勾选）")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }
                }
            }

            Item {
                // Color Mapping
                GridLayout {
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
                        text: qsTr("色彩映射启用：")
                    }

                    C.CheckBox {
                        text: qsTr("使用色彩映射设置")
                        checked: Chiaki.settings.placeboColorMappingEnabled
                        onToggled: Chiaki.settings.placeboColorMappingEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（已勾选）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("色彩映射预设：")
                        visible: Chiaki.settings.placeboColorMappingEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("自定义"), qsTr("默认"), qsTr("高质量")]
                        currentIndex: Chiaki.settings.placeboColorMappingPreset
                        onActivated: index => Chiaki.settings.placeboColorMappingPreset = index
                        visible: Chiaki.settings.placeboColorMappingEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（高质量）")
                        visible: Chiaki.settings.placeboColorMappingEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("色彩映射设置：")
                        visible: Chiaki.settings.placeboColorMappingEnabled && Chiaki.settings.placeboColorMappingPreset == 0
                    }

                    C.Button {
                        text: qsTr("打开")
                        onClicked: root.showPlaceboColorMappingDialog()
                        visible: Chiaki.settings.placeboColorMappingEnabled && Chiaki.settings.placeboColorMappingPreset == 0
                        Material.roundedScale: Material.SmallScale
                    }
                }
            }
        }
    }
}
