from fastkml import kml
from os import path
import requests

with open(path.join('Sunday River.kml')) as f:
      doc = kml.KML()
      doc.from_string(f.read())

document = list(doc.features())
name = document[0].name
jsonMap = {'name': name}
baseURL = "http://localhost:8080/api"
mapUrl = baseURL + '/maps'
mapConnectorURL = baseURL + '/map-connectors'
mapTrailURL = baseURL + '/map-trails'
mapPointURL = baseURL + '/points'

map = requests.post(mapUrl, json= jsonMap)

for folder in list(document[0].features()):
   index = 0
   for e in list(folder.features()):
      index += 1
      if folder.name.lower() == 'connector':
         mapConnector = {
            'name': e.name,
            'mapId': map.json().get('id'),
         }
         mapConnector = requests.post(mapConnectorURL, json= mapConnector)
         for idx, coordinate in enumerate(e.geometry.coords):
            lat = coordinate[1]
            long = coordinate[0]
            mapConnectorPoint = {'latitude': lat, 'longitude': long, 'time': [], 'mapConnectorId': mapConnector.json().get('id'), 'order': idx}
            mc = requests.post(mapPointURL, json= mapConnectorPoint)
      else :
         print(e.name)
         difficulty = folder.name
         mapTrail = {
            'name': e.name,
            'mapId': map.json().get('id'),
            'difficulty': difficulty
         }
         mapTrail = requests.post(mapTrailURL, json= mapTrail)
         for idx, coordinate in enumerate(e.geometry.coords):
            print(coordinate, idx)
            lat = coordinate[1]
            long = coordinate[0]
            mapTrailPoint = {'latitude': lat, 'longitude': long, 'time': [], 'mapTrailId': mapTrail.json().get('id'), 'order': idx}
            mt = requests.post(mapPointURL, json= mapTrailPoint)
      print("Completed " + str(index) + " out of " + str(len(list(folder.features()))) + " " + folder.name + " trails")