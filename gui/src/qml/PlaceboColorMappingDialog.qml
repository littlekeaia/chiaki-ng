import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs

import org.streetpea.chiaking

import "controls" as C

DialogView {
    enum GamutMappingFunction {
        Clip,
        Perceptual,
        SoftClip,
        Relative,
        Saturation,
        Absolute,
        Desaturate,
        Darken,
        Highlight,
        Linear
    }
    enum ToneMappingFunction {
        Clip,
        Spline,
        St209440,
        St209410,
        Bt2390,
        Bt2446a,
        Reinhard,
        Mobius,
        Hable,
        Gamma,
        Linear,
        LinearLight
    }
    id: dialog
    title: qsTr("色彩映射设置")
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
                text: qsTr("色域映射 1")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("色域映射 2")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("色调映射 1")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("色调映射 2")
                focusPolicy: Qt.NoFocus
            }

           TabButton {
                text: qsTr("色调映射 3")
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
                // Gamut Mapping 1
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
                        text: qsTr("色域映射函数：")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("截断"), qsTr("感知"), qsTr("软截断"), qsTr("相对"), qsTr("饱和度"), qsTr("绝对"), qsTr("去饱和"), qsTr("变暗"), qsTr("高光"), qsTr("线性")]
                        currentIndex: Chiaki.settings.placeboGamutMappingFunction
                        onActivated: index => Chiaki.settings.placeboGamutMappingFunction = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（感知）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("感知死区：")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Perceptual
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingPerceptualDeadzone
                        onMoved: Chiaki.settings.placeboGamutMappingPerceptualDeadzone = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Perceptual
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（0.30）")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Perceptual
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("感知强度：")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Perceptual
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingPerceptualStrength
                        onMoved: Chiaki.settings.placeboGamutMappingPerceptualStrength = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Perceptual

                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（0.80）")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Perceptual
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("比色伽马：")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Relative || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Absolute || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Darken
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 10.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingColorimetricGamma
                        onMoved: Chiaki.settings.placeboGamutMappingColorimetricGamma = value
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Relative || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Absolute || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Darken

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
                        text: qsTr("（1.80）")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Relative || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Absolute || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Darken
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("软截断拐点：")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Perceptual || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftClip
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingSoftClipKnee
                        onMoved: Chiaki.settings.placeboGamutMappingSoftClipKnee = value
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Perceptual || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftClip

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
                        text: qsTr("（0.70）")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Perceptual || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftClip
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("软截断去饱和：")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftClip
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingSoftClipDesat
                        onMoved: Chiaki.settings.placeboGamutMappingSoftClipDesat = value
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftClip

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
                        text: qsTr("（0.35）")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftClip
                    }
                }
            }

            Item {
                // Gamut Mapping 2
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
                        text: qsTr("LUT 3D 尺寸 I：")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 1024
                        stepSize: 1
                        value: Chiaki.settings.placeboGamutMappingLut3dSizeI
                        onMoved: Chiaki.settings.placeboGamutMappingLut3dSizeI = value

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
                        text: qsTr("（48）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("LUT 3D 尺寸 C：")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 1024
                        stepSize: 1
                        value: Chiaki.settings.placeboGamutMappingLut3dSizeC
                        onMoved: Chiaki.settings.placeboGamutMappingLut3dSizeC = value

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
                        text: qsTr("（32）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("LUT 3D 尺寸 h：")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 1024
                        stepSize: 1
                        value: Chiaki.settings.placeboGamutMappingLut3dSizeH
                        onMoved: Chiaki.settings.placeboGamutMappingLut3dSizeH = value

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
                        text: qsTr("（256）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("LUT 3D 三三次插值启用：")
                    }

                    C.CheckBox {
                        text: qsTr("为 3DLUT 启用三三次插值")
                        checked: Chiaki.settings.placeboGamutMappingLut3dTricubicEnabled
                        onToggled: Chiaki.settings.placeboGamutMappingLut3dTricubicEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（未勾选）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("色域扩展启用：")
                    }

                    C.CheckBox {
                        text: qsTr("启用色域扩展")
                        checked: Chiaki.settings.placeboGamutMappingGamutExpansionEnabled
                        onToggled: Chiaki.settings.placeboGamutMappingGamutExpansionEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（未勾选）")
                    }
                }
            }

            Item {
                // Tone-mapping 1
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
                        text: qsTr("色调映射函数：")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("截断"), qsTr("样条"), qsTr("St2094-40"), qsTr("St-2094-10"), qsTr("Bt2390"), qsTr("Bt2446a"), qsTr("Reinhard"), qsTr("Mobius"), qsTr("Hable"), qsTr("伽马"), qsTr("线性"), qsTr("线性光")]
                        currentIndex: Chiaki.settings.placeboToneMappingFunction
                        onActivated: index => Chiaki.settings.placeboToneMappingFunction = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（样条）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("拐点自适应：")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209440 || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209410
                    }

                    C.Slider {
                        id: kneeadaptation
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeAdaptation
                        onMoved: Chiaki.settings.placeboToneMappingKneeAdaptation = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209440 || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209410

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
                        text: qsTr("（0.40）")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209440 || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209410
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("拐点下限：")
                        visible: kneeadaptation.visible
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 0.50
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeMinimum
                        onMoved: Chiaki.settings.placeboToneMappingKneeMinimum = value
                        visible: kneeadaptation.visible

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
                        text: qsTr("（0.10）")
                        visible: kneeadaptation.visible
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("拐点上限：")
                        visible: kneeadaptation.visible
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.50
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeMaximum
                        onMoved: Chiaki.settings.placeboToneMappingKneeMaximum = value
                        visible: kneeadaptation.visible

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
                        text: qsTr("（0.80）")
                        visible: kneeadaptation.visible
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("拐点默认值：")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeDefault
                        onMoved: Chiaki.settings.placeboToneMappingKneeDefault = value

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
                        text: qsTr("（0.40）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("拐点偏移：")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Bt2390
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.50
                        to: 2.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeOffset
                        onMoved: Chiaki.settings.placeboToneMappingKneeOffset = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Bt2390

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
                        text: qsTr("（1.00）")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Bt2390
                    }
                }
            }

            Item {
                // Tone-mapping 2
                GridLayout {
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 20
                    }
                    columns: 3
                    rowSpacing: 10
                    columnSpacing: 100

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("斜率调优：")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 10.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboToneMappingSlopeTuning
                        onMoved: Chiaki.settings.placeboToneMappingSlopeTuning = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline

                        Label {
                            id: slopeTuningLabel
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
                        text: qsTr("（1.5）")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("斜率偏移：")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingSlopeOffset
                        onMoved: Chiaki.settings.placeboToneMappingSlopeOffset = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline

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
                        text: qsTr("（0.20）")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("样条对比度：")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.50
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingSplineContrast
                        onMoved: Chiaki.settings.placeboToneMappingSplineContrast = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline

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
                        text: qsTr("（0.50）")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Reinhard 对比度：")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Reinhard
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingReinhardContrast
                        onMoved: Chiaki.settings.placeboToneMappingReinhardContrast = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Reinhard

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
                        text: qsTr("（0.50）")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Reinhard
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("线性拐点：")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Mobius || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Gamma
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingLinearKnee
                        onMoved: Chiaki.settings.placeboToneMappingLinearKnee = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Mobius || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Gamma

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
                        text: qsTr("（0.3）")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Mobius || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Gamma
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("曝光：")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Linear || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.LinearLight
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 10.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboToneMappingExposure
                        onMoved: Chiaki.settings.placeboToneMappingExposure = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Linear || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.LinearLight

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
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Linear || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.LinearLight
                    }
                }
            }
            
            Item {
                // Tone-mapping 3
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
                        text: qsTr("逆色调映射启用：")
                    }

                    C.CheckBox {
                        text: qsTr("启用逆色调映射")
                        checked: Chiaki.settings.placeboToneMappingInverseToneMappingEnabled
                        onToggled: Chiaki.settings.placeboToneMappingInverseToneMappingEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（未勾选）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("色调映射元数据：")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("任意"), qsTr("无"), qsTr("HDR10"), qsTr("HDR10 Plus"), qsTr("Cie_y")]
                        currentIndex: Chiaki.settings.placeboToneMappingMetadata
                        onActivated: index => Chiaki.settings.placeboToneMappingMetadata = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("（任意）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("色调 LUT 尺寸：")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 4096
                        stepSize: 1
                        value: Chiaki.settings.placeboToneMappingToneLutSize
                        onMoved: Chiaki.settings.placeboToneMappingToneLutSize = value

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
                        text: qsTr("（256）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("对比度恢复：")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 2.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingContrastRecovery
                        onMoved: Chiaki.settings.placeboToneMappingContrastRecovery = value

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
                        text: qsTr("（0.30）")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("对比度平滑度：")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 1.0
                        to: 32.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboToneMappingContrastSmoothness
                        onMoved: Chiaki.settings.placeboToneMappingContrastSmoothness = value

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
                        text: qsTr("（3.5）")
                    }
                }
            }
        }
    }
}