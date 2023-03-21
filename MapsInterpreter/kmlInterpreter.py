from fastkml import kml
from os import path
import requests


# https://www.sundayriver.com/mountain-report : Sunday River Mountain Report
# conditions_lifts_e75ceb523c30353d18fb54207af864f9 : Lift Status Id Sunday River
# conditions_trailstatus_16207d4019cf36fbdb184831e2ae3054 : Trail Status Id Sunday River
# https://www.sugarloaf.com/mountain-report : Sugarloaf Mountain Report
# conditions_lifts_dee2e4a816064ad8b3df04324de73500 : Lift Status Id Sugarloaf
# conditions_trailstatus_fd4ed0a91d27736243553866f5ab6f8e : Trail Status Id Sugarloaf

with open(path.join('Sugarloaf.kml')) as f:
      doc = kml.KML()
      doc.from_string(f.read())

mountainReportUrl = "https://www.sugarloaf.com/mountain-report"
trailStatusElementId = "conditions_trailstatus_fd4ed0a91d27736243553866f5ab6f8e"
liftStatusElementId = "conditions_lifts_dee2e4a816064ad8b3df04324de73500"

document = list(doc.features())
name = document[0].name
initialLocation = list(list(document[0].features())[0].features())[0].geometry.coords[0]
iniitalLocationLatitude = initialLocation[1]
initialLocationLongitude = initialLocation[0]
jsonMap = {'name': name, 'initialLocationLatitude': iniitalLocationLatitude, 'initialLocationLongitude': initialLocationLongitude, 'mountainReportUrl': mountainReportUrl,
'trailStatusElementId': trailStatusElementId, 'liftStatusElementId': liftStatusElementId}
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
            lat = coordinate[1]
            long = coordinate[0]
            mapTrailPoint = {'latitude': lat, 'longitude': long, 'time': [], 'mapTrailId': mapTrail.json().get('id'), 'order': idx}
            mt = requests.post(mapPointURL, json= mapTrailPoint)
      print("Completed " + str(index) + " out of " + str(len(list(folder.features()))) + " " + folder.name + " trails")