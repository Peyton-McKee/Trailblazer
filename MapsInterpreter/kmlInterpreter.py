from pykml import parser
from os import path
import json
import requests

kml_file = path.join('testMap.kml')

with open(kml_file) as f:
   doc = parser.parse(f).getroot()

name = doc.Document.name.text
jsonMap = {'name': name}

url = 'http://35.172.135.117/api/maps'
map = requests.post(url, json= jsonMap)

for e in doc.Document.Folder.Placemark:
   coordinates = e.LineString.coordinates.text.split(',0')
   lats = []
   longs = []
   mapTrail = {
      'name': e.name.text,
      'mapId': map.json().get('id'),
   }
   url = 'http://35.172.135.117/api/map-trails'
   mapTrail = requests.post(url, json= mapTrail)
   for coordinate in coordinates:
      if len(coordinate.split(',')) > 1:
         lat = float(coordinate.split(',')[0])
         long = float(coordinate.split(',')[1])
         lats.append(lat)
         longs.append(long)
         mapTrailPoint = {'latitude': lat, 'longitude': long, 'mapTrailId': mapTrail.json().get('id')}
         url = 'http://35.172.135.117/api/points'
         requests.post(url, json= mapTrailPoint)
   


