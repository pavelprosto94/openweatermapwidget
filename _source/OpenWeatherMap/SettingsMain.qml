import QtQuick 2.7
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.3
import Ubuntu.Components.Themes 1.3
import io.thp.pyotherside 1.3
import Ubuntu.Content 1.3

Page {
        id:root
        header: PageHeader {
            id: header
            title: ""
            Image{
              anchors{
              fill: parent
              leftMargin: units.gu(2)
              }
            source: "img/openweathermap_logo.png"
            smooth: true
            antialiasing: true
            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Image.AlignLeft
            }
        }
    
    Rectangle{
        id: widget_thumbnail
        anchors{
            top: header.bottom
            left: parent.left
            right: parent.right
        }
        height: units.gu(15)
        radius: units.gu(2)
        clip: true
        color: theme.palette.normal.base
        
        Image {
            anchors{
                left: parent.left
                top: parent.top
                topMargin: - header.bottom
                }
            width: background.width
            height: background.height
            source: settings.background_source
            fillMode: Image.PreserveAspectCrop
        }
        Item{
            anchors{
                top: parent.top
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                margins: units.gu(1)
            }
            width:height
        Main{
            id: widgetMain
        }}
    }
    Flickable {
    clip: true
    anchors{
          top: widget_thumbnail.bottom
          left: parent.left
          right: parent.right
          bottom: okButton.top
        }
      contentWidth: rectRoot.width
      contentHeight: rectRoot.height
    
    Rectangle {
    id :rectRoot
        width: root.width
        height: {childrenRect.height+units.gu(4)}
        color: theme.palette.normal.background

Text {
        id: label1
        text: "Location:"
        color: theme.palette.normal.backgroundText
        font.pixelSize: units.gu(2)
        anchors{
          top: parent.top
          topMargin: units.gu(3)
          left: parent.left
          leftMargin: units.gu(2)
          right: parent.right
          rightMargin: units.gu(2)
        }
      }

    TextField{
      id: tx1
      text: widgetMain.cityName
      anchors{
          top: label1.bottom
          topMargin: units.gu(1)
          left: parent.left
          leftMargin: units.gu(2)
          right: parent.right
          rightMargin: units.gu(2)
        }
        onAccepted: {
          citygetpython.call('seachCityWeather.SeachCity', [tx1.text], function(returnValue) {
            os1.model=returnValue
            os1.selectedIndex=-1
          });
        }
    }
    OptionSelector{
      id: os1
      expanded: true
      anchors{
          top: tx1.bottom
          topMargin: units.gu(0.5)
          left: parent.left
          leftMargin: units.gu(2)
          right: parent.right
          rightMargin: units.gu(2)
        }
        model: []
        containerHeight: itemHeight*4
        onDelegateClicked:{
          if (index>-1){
            var cityID=model[index].toString()
            cityID=cityID.substr(cityID.indexOf("[")+1,cityID.indexOf("]")-cityID.indexOf("[")-1)
            var newSet = [widgetMain.backgroundcolor, cityID, widgetMain.settings[2]]
            widgetMain.settings=newSet
            os1.model=[]
          }
        }
    }

  Text {
        id: label2
        text: "BackgroundColor:"
        color: theme.palette.normal.backgroundText
        font.pixelSize: units.gu(2)
        anchors{
          top: os1.bottom
          topMargin: units.gu(3)
          left: parent.left
          leftMargin: units.gu(2)
          right: parent.right
          rightMargin: units.gu(2)
        }

        Rectangle{
          border.width: units.gu(0.2); 
          border.color: theme.palette.normal.base
          color: "transparent"
          anchors{
            right: parent.right
            top: parent.top
            topMargin: -units.gu(0.5)
            bottom: parent.bottom
            bottomMargin: -units.gu(0.5)
          }
          width: units.gu(5)
          Checkerboard{
            cellSide: units.gu(0.5)
          }
          Rectangle{
            id: color1
            anchors.fill: parent
            border.width: units.gu(0.2); 
            border.color: theme.palette.normal.base
            onColorChanged: {
              var newSet = [color.toString().toUpperCase(), widgetMain.cityId, widgetMain.settings[2]]
              widgetMain.settings=newSet
            }
         }
          MouseArea{
            anchors.fill: parent
            onClicked:{
              colorPicker.obj_target=color1
              colorPicker.visible=true
            }
          }
        }
    } 
Text {
        id: label3
        text: "Dark mode:"
        color: theme.palette.normal.backgroundText
        font.pixelSize: units.gu(2)
        anchors{
          top: label2.bottom
          topMargin: units.gu(3)
          left: parent.left
          leftMargin: units.gu(2)
        }
      }
      Switch {
        id: sw1
        anchors{
          top: label2.bottom
          topMargin: units.gu(3)
          left: label3.right
          leftMargin: units.gu(2)
        }
        onCheckedChanged:{
          if (checked){
            var newSet = [widgetMain.backgroundcolor, widgetMain.cityId, "Yes"]
            widgetMain.settings=newSet
          }else{
            var newSet = [widgetMain.backgroundcolor, widgetMain.cityId, "No"]
            widgetMain.settings=newSet
          }
        }
      }
    }
    }

    OpenButton{
  id: okButton
  anchors{
    left: parent.left
    leftMargin: units.gu(2)
    bottom: parent.bottom
    bottomMargin: units.gu(1.5)
  }
  width: units.gu(16)
  colorBut: UbuntuColors.green
  colorButText: "white"
  iconOffset: true
  iconName: "document-save"
  text: "Save"
    onPressed: {
        waitScreen.visible=true
    }
    
    onReleased: {
      var tosend = widgets.get(widgets.target_obj).snd
      var newSet = widgetMain.settings
      tosend.settings = newSet
      widgets.get(widgets.target_obj).snd=tosend
      waitScreen.visible=false
      stack.pop()
    }
  }

OpenButton{
  id: cancelButton
  anchors{
    right: parent.right
    rightMargin: units.gu(2)
    bottom: parent.bottom
    bottomMargin: units.gu(1.5)
  }
  width: units.gu(16)
  iconOffset: true
  iconName: "close"
  text: "Cancel"
    onClicked: {
      stack.pop()
    }
  }

    ColorPicker{
        id: colorPicker
        property var obj_target
        visible: false
        anchors.centerIn: parent
        width: {if (parent.width>parent.height){parent.height-units.gu(2)}else{parent.width-units.gu(2)}}
        height: width
        onConfirm:{
          obj_target.color=colorValue
        }
    }

    Component.onCompleted: {
      var tmp=widgets.get(widgets.target_obj).snd
      if (tmp.settings.length>0){ widgetMain.settings=tmp.settings}
      color1.color=widgetMain.backgroundcolor
      if (widgetMain.settings[2]=="No"){
        sw1.checked=false
      }else{
        sw1.checked=true
      }
      }
Python {
    id: citygetpython
    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('./'));
        setHandler('error', function(returnValue) {
                myDialog.text = returnValue
                myDialog.visible = true;
            });
        importModule('seachCityWeather', function() {});
        }
    onError: {
        myDialog.text = 'python error: ' + traceback
        myDialog.visible = true;
        console.log('python error: ' + traceback);
    }
}
}