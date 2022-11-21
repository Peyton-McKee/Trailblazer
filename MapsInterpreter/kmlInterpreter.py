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
   for e in list(folder.features()):
      if folder.name.lower() == 'trails' or folder.name.lower() == 'lifts':
         styleURL = e.styleUrl
         difficulty = "easy"
         for style in list(document[0].styles()):
            if style.id == styleURL[1:] + '-normal':
               if list(style.styles())[0].color == 'ff1427a5':
                  difficulty = "intermediate"
               elif list(style.styles())[0].color == 'ff757575':
                  difficulty = "advanced"
               elif list(style.styles())[0].color == 'ff000000':
                  difficulty = "experts only"
               elif list(style.styles())[0].color == 'ffd18802':
                  difficulty = "lift" 
               break
         mapTrail = {
            'name': e.name,
            'mapId': map.json().get('id'),
            'difficulty': difficulty
         }
         lats = []
         longs = []
         url = 'http://35.172.135.117/api/map-trails'
         mapTrail = requests.post(url, json= mapTrail)

         for coordinate in list(e.geometry._coordinates):
            if len(coordinate.split(',')) > 1:
               lat = float(coordinate.split(',')[0])
               long = float(coordinate.split(',')[1])
               lats.append(lat)
               longs.append(long)
               mapTrailPoint = {'latitude': lat, 'longitude': long, 'mapTrailID': mapTrail.json().get('id')}
               url = 'http://35.172.135.117/api/points'
               mt = requests.post(url, json= mapTrailPoint)
      else :
         mapConnector = {
            'name': e.name,
            'mapId': map.json().get('id'),
         }
         url = 'http://35.172.135.117/api/map-connectors'
         mapConnector = requests.post(url, json= mapConnector)
         lats = []
         longs = []
         for coordinate in e.geometry._coordinates:
            if len(coordinate.split(',')) > 1:
               lat = float(coordinate.split(',')[0])
               long = float(coordinate.split(',')[1])
               mapConnectorPoint = {'latitude': lat, 'longitude': long, 'mapConnectorID': mapConnector.json().get('id')}
               url = url = 'http://35.172.135.117/api/points'
               mc = requests.post(url, json= mapConnectorPoint)
               print(mc.json())
   



