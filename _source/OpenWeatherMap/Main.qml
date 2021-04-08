//start_size: 2x2
import QtQuick 2.5
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import io.thp.pyotherside 1.3
import QtGraphicalEffects 1.0

Item {
    id: root
    anchors.fill : parent
    anchors.margins : units.gu(1)
    property var settings: ["#55E95420", "-1", "No"]
    property string backgroundcolor: "#55E95420"
    property string cityId: "-1"
    property bool invertColor: false
    property string cityName: "No city set"
    property string iconsource: "img/error.png"
    property string tempsource: "? C°"
    property string fontcolor: "#FFFFFF"
    property string conditionssource: ""
    onSettingsChanged:{
        if (settings.length>0) backgroundcolor=settings[0]
        if (settings.length>1) {
            cityId=settings[1]
            weatherpython.updateWeather()
        }
        if (settings.length>2) {
            if (settings[2]=="No") 
        {
            invertColor=false
            fontcolor="#FFFFFF"
        } else {
            invertColor=true
            fontcolor="#222222"
        }}
    }
Rectangle{
    id: background_source
    anchors.fill: parent
    radius: units.gu(1)
    color: backgroundcolor

Rectangle{
    id: background_title
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }
    height: parent.height*0.25
    radius: units.gu(1)
    color: if (invertColor) {"#55FFFFFF"} else {"#55000000"}

    Text{
        anchors.fill: parent
        anchors.margins: parent.height*0.1
        fontSizeMode: Text.Fit;
        color: fontcolor
        text: cityName
        font.pixelSize: parent.height*0.8
        verticalAlignment : Text.AlignVCenter
        horizontalAlignment : Text.AlignHCenter
    }
}
Image{
    id: ico_source
    visible: false
    anchors {
        fill: parent
        topMargin: parent.height*0.05
        leftMargin: -parent.height*0.1
    }
    source: iconsource
    smooth: true
    antialiasing: true
    fillMode: Image.PreserveAspectFit
    horizontalAlignment: Image.AlignLeft
}
Blend
{
    anchors.fill: ico_source
    source: ico_source
    foregroundSource: ico_source
    mode: {if (invertColor) {"negation"} else {"normal"}}
}
Text{
    anchors{
        fill: ico_source
        bottomMargin: parent.height*0.05
    }
    text: tempsource
    color: fontcolor
    font.pixelSize: parent.height*0.2
    horizontalAlignment : Text.AlignRight
    verticalAlignment : Text.AlignVCenter
}

Text{
    anchors {
        bottom: ico_source.bottom
        bottomMargin: parent.height*0.01
        left: parent.left
        leftMargin: parent.height*0.05
        right: parent.right
        rightMargin: parent.height*0.05
    }
    text: conditionssource
    color: fontcolor
    horizontalAlignment : Text.AlignHCenter
    font.pixelSize: parent.height*0.15
    fontSizeMode: Text.Fit;

}
MouseArea{
    anchors.fill: parent
    onClicked: {
        Qt.openUrlExternally("weather://")
    }
}
}
Python {
    id: weatherpython
    property bool ready: false
    Component.onCompleted: {
        addImportPath(Qt.resolvedUrl('./'));
        setHandler('error', function(returnValue) {
                myDialog.text = returnValue
                myDialog.visible = true;
            });
        setHandler('weatherset', function(returnValue) {
                conditionssource = returnValue[0]
                tempsource = returnValue[1]
                iconsource = returnValue[2]
                cityName = returnValue[3]
            });
        importModule('weather', function() {
            ready=true
            updateWeather()
        });
        }
    onError: {
        myDialog.text = 'python error: ' + traceback
        myDialog.visible = true;
        console.log('python error: ' + traceback);
    }
    function updateWeather(){
        if (weatherpython.ready) call('weather.weather.get', [cityId], function() {});
    }
}
Timer {
        running: true
        interval: 1000*60*30
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            weatherpython.updateWeather()
        }
    }
}