from fastkml import kml
from os import path
import requests

with open(path.join('Sunday River.kml')) as f:
      doc = kml.KML()
      doc.from_string(f.read())

document = list(doc.features())
name = document[0].name
jsonMap = {'name': name}

url = 'http://35.172.135.117/api/maps'
map = requests.post(url, json= jsonMap)

for folder in list(document[0].features()):
   index = 0
   for e in list(folder.features()):
      index += 1
      if folder.name.lower() == 'connector':
         mapConnector = {
            'name': e.name,
            'mapId': map.json().get('id'),
         }
         url = 'http://35.172.135.117/api/map-connectors'
         mapConnector = requests.post(url, json= mapConnector)
         for coordinate in e.geometry.coords:
            lat = coordinate[1]
            long = coordinate[0]
            mapConnectorPoint = {'latitude': lat, 'longitude': long, 'time': 0, 'mapConnectorId': mapConnector.json().get('id')}
            url = url = 'http://35.172.135.117/api/points'
            mc = requests.post(url, json= mapConnectorPoint) 
      else :
         difficulty = folder.name
         mapTrail = {
            'name': e.name,
            'mapId': map.json().get('id'),
            'difficulty': difficulty
         }
         url = 'http://35.172.135.117/api/map-trails'
         mapTrail = requests.post(url, json= mapTrail)
         for coordinate in list(e.geometry.coords):
            lat = coordinate[1]
            long = coordinate[0]
            mapTrailPoint = {'latitude': lat, 'longitude': long, 'time': 0, 'mapTrailId': mapTrail.json().get('id')}
            url = 'http://35.172.135.117/api/points'
            mt = requests.post(url, json= mapTrailPoint)
      print("Completed " + str(index) + " out of " + str(len(list(folder.features()))) + " " + folder.name + " trails")



