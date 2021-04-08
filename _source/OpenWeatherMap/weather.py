import requests
import os
import urllib.request
import threading
import pyotherside

appid = "35129c3b68d0012d3ef823187750bf7d"
CACHEPATH = "/home/phablet/.cache/uhome.pavelprosto"

def GetWeather(city_id=-1):
    rez=["", "?", "img/error.png", "No city set"]
    if int(city_id)>-1:
        try:
            res = requests.get("http://api.openweathermap.org/data/2.5/weather",
                        params={'id': city_id, 'units': 'metric', 'lang': 'ru', 'APPID': appid})
            data = res.json()
            #print(data)
            name=(data['name'])
            conditions=data['weather'][0]['description']
            temp=str(int(data['main']['temp']))+" C°"
            if temp[0]!="-" and temp!="0": temp="+"+temp
            icon=CACHEPATH+"/{}.png".format(data['weather'][0]['icon'])
            iconURL="http://openweathermap.org/img/wn/{}@4x.png".format(data['weather'][0]['icon'])
            if not os.path.exists(icon):
                try:
                    with urllib.request.urlopen(iconURL) as url_data:
                        with open(icon, 'wb') as f:
                            f.write(url_data.read()) 
                except Exception as e:
                    print(iconURL)
                    print(str(e))
                    icon="img/error.png"
            rez=[conditions,temp,icon,name]
            #print(rez)
            pyotherside.send('weatherset', rez)
        except Exception as e:
            print("Exception (weather):", e)

class Weather:
    def __init__(self):
        self.bgthread = threading.Thread()

    def get(self, city_id):
        if self.bgthread.is_alive():
            return
        self.bgthread = threading.Thread(target=GetWeather(city_id))
        self.bgthread.start()

weather = Weather()
#weather.get(524311)