// Copyright (c) 2015 Ableton AG, Berlin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import QtQuick 2.3
import QtTest 1.0
import QtQuick.Layouts 1.1

import Aqt.StyleSheets 1.1
import Aqt.StyleSheets.Tests 1.0 as AqtTests

Item {
    /*! ensure minimum width to be larger than the minimum allowed width on
     * Windows */
    implicitWidth: 124
    /*! there are no constraints on the height, but it is convenient to have a
     *  default size */
    implicitHeight: 116

    id: scene

    function withComponent(componentClass, parent, args, proc) {
        var obj = componentClass.createObject(parent, args);
        if (obj == null) {
            console.warn("Could not create object of class " + componentClass);
        }

        try {
            return proc(obj);
        }
        finally {
            obj.destroy();
        }
    }

    AqtTests.TestUtils {
        id: msgTracker
    }

    StyleEngine {
        id: styleEngine
        styleSheetSource: "tst_Paths.css"
    }


    Component {
        id: minimalScene

        Item {
            property var obj: QtObject {
                StyleSet.name: "foo"
                property var value: StyleSet.props.get("text")
            }

            Rectangle {
                StyleSet.name: "root"
                anchors.fill: parent

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: obj.value ? obj.value : "N"
                    font.pixelSize: 72
                }
            }
        }
    }

    TestCase {
        name: "path to hierarchy objects"
        when: windowShown

        function test_basePropertyLookup() {
            msgTracker.expectMessage(AqtTests.TestUtils.Debug,
                                     /^INFO:.*Hierarchy changes.*detected.*/);
            withComponent(minimalScene, scene, {},
                          function(comp) {
                              compare(comp.obj.value, "B")
                          });
        }
    }
}