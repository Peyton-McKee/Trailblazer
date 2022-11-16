from pykml import parser
from os import path
import json

kml_file = path.join('testMap.kml')

with open(kml_file) as f:
   doc = parser.parse(f).getroot()

name = doc.Document.name.text
jsonObjects = []
for e in doc.Document.Folder.Placemark:
   coordinates = e.LineString.coordinates.text.split(',0')
   lats = []
   longs = []
   for coordinate in coordinates:
      if len(coordinate.split(',')) > 1:
         lat = float(coordinate.split(',')[0])
         long = float(coordinate.split(',')[1])
         lats.append(lat)
         longs.append(long)

   dictionary = {
      'name': e.name.text,
      'latitudes': lats,
      'longitudes': longs
   }
   jsonObjects.append(dictionary)

jsonObject = {'name': name, 'trails': jsonObjects}
with open('testMap.json', 'w') as f:
   json.dump(jsonObject, f)

