/*
 * Copyright (C) 2021  Pavel Prosto
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * openweatermapwidget is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'openweatermapwidget.pavelprosto'
    automaticOrientation: true
    property real minS: if (width>height) {height} else {width}
    width: units.gu(45)
    height: units.gu(75)

    Component.onCompleted: {
    i18n.domain = "openweatermapwidget.pavelprosto"
    }

    PageStack {
    id: pageStack
    anchors.fill: parent
    Component.onCompleted: push(mainView)
    }

    Page {
        id: mainView
        visible: false

        header: PageHeader {
            id: header
            title: i18n.tr('Weather widget')
        }
    Flickable {
        id: imgslider
    clip: true
    anchors{
          top: header.bottom
          left: parent.left
          right: parent.right
        }
        height: parent.height/2
        contentWidth: rectRoot.width
        contentHeight: rectRoot.height
    
    Rectangle {
    id :rectRoot
        width: {childrenRect.width+units.gu(6)}
        height: root.height/2
        color: theme.palette.normal.background
        Repeater{
        model: ["../src/screenshot1.jpg","../src/screenshot2.jpg"]
        delegate: Image{
            y: units.gu(1)
            x: (minS-width)/2*(index+1)+width*index*0.8
            height: parent.height-units.gu(2)
            width: height/16*9
            source: modelData
        }
    }
    }}
    Flickable {
    clip: true
    anchors{
          top: imgslider.bottom
          left: parent.left
          right: parent.right
          bottom: installbut.top
          margins : units.gu(1)
        }
        contentWidth: txt.width
        contentHeight: txt.height
    Column {
        id:txt
        spacing: units.gu(0.5)
    Text{
        id: label1
        width: root.width-units.gu(2)
        text: i18n.tr("<b>OpenWeatherMap widget for uHome.</b>")
        color: theme.palette.normal.backgroundText
        font.pixelSize: units.gu(2)
        wrapMode: Text.WordWrap
    }
    Text{
        id: label2
        width: root.width-units.gu(2)
        text: i18n.tr("Add this widget to your home screen and stay up to date with the current weather.")
        color: theme.palette.normal.backgroundText
        font.pixelSize: units.gu(2)
        wrapMode: Text.WordWrap
    }
    Text{
        id: label3
        width: root.width-units.gu(2)
        text: i18n.tr("OpenWeatherMap is an online service, owned by OpenWeather Ltd, that provides global weather data via API, including current weather data, forecasts, nowcasts and historical weather data for any geographical location.")
        color: theme.palette.normal.backgroundText
        font.pixelSize: units.gu(2)
        wrapMode: Text.WordWrap
    }
    Text{
        id: label4
        width: root.width-units.gu(2)
        text: i18n.tr("<b>You can uninstall this application after successfully installing the widget.<b>")
        color: theme.palette.normal.backgroundText
        font.pixelSize: units.gu(2)
        wrapMode: Text.WordWrap
    }
    }
    }
    Button {
        id: installbut
        anchors{
            bottom: parent.bottom
            horizontalCenter : parent.horizontalCenter 
            margins: units.gu(1)
        }
        color : "green"
        text: i18n.tr("Install widget")
        onClicked: pageStack.push(exportpage)
    }
    }
    ExportPage{
        id: exportpage
        visible:false
        url:"../src/OpenWeatherMap.tar.xz"
    }
}
