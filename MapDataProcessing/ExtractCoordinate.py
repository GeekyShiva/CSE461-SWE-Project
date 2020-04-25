import geopy
import json
import time
from geopy.geocoders import Nominatim

    # function getCoordinate(coordinate):
	# 	input: as per the HTML file of the map(index.html), the lines where the colour codes were found, 6 lines before
    #          those lines has the corresponding coordinates. That was the input here.
	# 	output: latitude and longitude of that particular coloured congested area
	# 	Description: The function is used to extract the latitude and longitude after processing the HTML file

def getCoordinate(coordinate):
    if '[' in coordinate and ']' in coordinate:
        coordinate = coordinate.replace('[', '').replace(']', '').replace('\n', '')
        coordinate = coordinate[0:-1]
        latitudeLongitude = [float(idx) for idx in coordinate.split(', ')]
        return latitudeLongitude
    else:
        return "coordinate not found"

    # function getAddress(latlong):
	# 	input: the latitudes and longitudes found from getCoordinate function.
	# 	output: addresses of the corresponding latitudes and longitudes
	# 	Description: The function is used to give the addresses of every coloured congested area we have in that map


def getAddress(latlong): 
    locator = Nominatim(user_agent = "myGeocoder")
    coordinates = str(latlong[0]) + ',' + str(latlong[1])
    #this while loop is to handle service time out error
    while True:
        try:
            location = locator.reverse(coordinates, timeout=5)
            break
        except:
            print("Time out exception happened")

    address = location.raw["display_name"]   
    return address

def main():
    data = []                             
    with open ('./Data/index.html', 'rt') as myfile:  
        for line in myfile:                   
            data.append(line)  
            
    i=0
    redList = []
    orangeList = []
    blueList = []
    counter = 0
    for i in range(len(data)):
        print("counter: ", counter)
        if counter == 14468:
            break
        else:
            counter += 1
        # FA1A1A is the colour code for red congested area
        if '#FA1A1A' in data[i] and not 'return' in data[i]:    
            latlong = getCoordinate(data[i-6])
            if type(latlong) == list:
                address = getAddress(latlong)
                print(latlong)
                print(address)
                redList.append({'coordinate' : latlong, 'address' : address })
            else:
                print("something is wrong in red")
        # F67803 is the colour code for orange congested area
        if '#F67803' in data[i] and not 'return' in data[i]:    
            latlong = getCoordinate(data[i-6])
            if type(latlong) == list:
                address = getAddress(latlong)
                print(latlong)
                print(address)
                orangeList.append({'coordinate' : latlong, 'address' : address })
            else:
                print("something is wrong in orange")
        # blue is the colour code for blue independent area
        if 'blue' in data[i] and not 'return' in data[i]:    
            latlong = getCoordinate(data[i-6])
            if type(latlong) == list:
                address = getAddress(latlong)
                print(latlong)
                print(address)
                blueList.append({'coordinate' : latlong, 'address' : address })
            else:
                print("something is wrong in blue")

    with open('./Data/redlist.json', 'w') as json_file:
        json.dump(redList, json_file)

    with open('./Data/orangelist.json', 'w') as json_file:
        json.dump(orangeList, json_file)

    with open('./Data/bluelist.json', 'w') as json_file:
        json.dump(blueList, json_file)        
        

if __name__ == '__main__':
    main()

