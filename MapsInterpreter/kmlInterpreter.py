from fastkml import kml
from os import path
import requests

class MapInfo: 
   def __init__(self, MR_URL, trail_el_id, lift_el_id, file_name) -> None:
      self.mountain_report_url = MR_URL
      self.trail_status_element_id = trail_el_id
      self.lift_status_element_id = lift_el_id
      self.file_name = file_name

sr = MapInfo("https://www.sundayriver.com/mountain-report", "conditions_trailstatus_16207d4019cf36fbdb184831e2ae3054", "conditions_lifts_e75ceb523c30353d18fb54207af864f9", "Sunday-River.kml")

sugarloaf = MapInfo("https://www.sugarloaf.com/mountain-report", "conditions_trailstatus_fd4ed0a91d27736243553866f5ab6f8e", "conditions_lifts_dee2e4a816064ad8b3df04324de73500", "Sugarloaf.kml")

def save_mountain_to_database(mapInfo: MapInfo):
    with open(path.join(mapInfo.file_name)) as f:
          doc = kml.KML()
          doc.from_string(f.read())

    mountainReportUrl = mapInfo.mountain_report_url
    trailStatusElementId = mapInfo.trail_status_element_id
    liftStatusElementId = mapInfo.lift_status_element_id

    document = list(doc.features())
    name = document[0].name
    initialLocation = list(list(document[0].features())[0].features())[0].geometry.coords[0]
    iniitalLocationLatitude = initialLocation[1]
    initialLocationLongitude = initialLocation[0]
    jsonMap = {'name': name, 'initialLocationLatitude': iniitalLocationLatitude, 'initialLocationLongitude': initialLocationLongitude, 'mountainReportUrl': mountainReportUrl,
'trailStatusElementId': trailStatusElementId, 'liftStatusElementId': liftStatusElementId}
    #35.172.135.117
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
                mapConnectorPoint = {'latitude': lat, 'longitude': long, 'time': [0.0], 'mapConnectorId': mapConnector.json().get('id'), 'order': idx}
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
                mapTrailPoint = {'latitude': lat, 'longitude': long, 'time': [0.0], 'mapTrailId': mapTrail.json().get('id'), 'order': idx}
                mt = requests.post(mapPointURL, json= mapTrailPoint)
          print("Completed " + str(index) + " out of " + str(len(list(folder.features()))) + " " + folder.name + " trails")

mountains = [sugarloaf, sr]

for mountain in mountains:
   save_mountain_to_database(mountain)