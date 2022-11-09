import requests
userLocationResponse = requests.get('http://localhost:8080/api/user-locations')

f = open("userLocations.json", "w")
f.write(userLocationResponse.text)
f.close()

userRouteResponse = requests.get('http://localhost:8080/api/user-routes')

f = open("userRoutes.json", "w")
f.write(userRouteResponse.text)
f.close()

trailReportResponse = requests.get('http://localhost:8080/api/trail-reports')

f = open("trailReports.json", "w")
f.write(trailReportResponse.text)
f.close()


