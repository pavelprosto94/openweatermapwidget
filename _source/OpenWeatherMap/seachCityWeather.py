import requests
appid = "35129c3b68d0012d3ef823187750bf7d"
def SeachCity(s_city = ""):
    rez=[]
    if (s_city!=""):
        try:
            res = requests.get("http://api.openweathermap.org/data/2.5/find",
                        params={'q': s_city, 'type': 'like', 'units': 'metric', 'APPID': appid})
            data = res.json()
            for d in data['list']:
                rez.append(str(d['name'])+" ["+str(d['id'])+"]")
        except Exception as e:
            print("Exception (find):", e)
            pass
    return rez
#print(SeachCity("Москва"))