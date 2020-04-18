import geopy
import json
import pandas as pd
import time
from geopy.geocoders import Nominatim

def getCoordinate(coordinate):
    if '[' in coordinate and ']' in coordinate:
        coordinate = coordinate.replace('[', '').replace(']', '').replace('\n', '')
        coordinate = coordinate[0:-1]
        latitudeLongitude = [float(idx) for idx in coordinate.split(', ')]
        return latitudeLongitude
    else:
        return "coordinate not found"

def getAddress(latlong): 
    locator = Nominatim(user_agent = "myGeocoder")
    coordinates = str(latlong[0]) + ',' + str(latlong[1])
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
    with open ('index.html', 'rt') as myfile:  
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
        if '#FA1A1A' in data[i] and not 'return' in data[i]:    
            latlong = getCoordinate(data[i-6])
            if type(latlong) == list:
                address = getAddress(latlong)
                print(latlong)
                print(address)
                redList.append({'coordinate' : latlong, 'address' : address })
            else:
                print("something is wrong in red")

        if '#F67803' in data[i] and not 'return' in data[i]:    
            latlong = getCoordinate(data[i-6])
            if type(latlong) == list:
                address = getAddress(latlong)
                print(latlong)
                print(address)
                orangeList.append({'coordinate' : latlong, 'address' : address })
            else:
                print("something is wrong in orange")

        if 'blue' in data[i] and not 'return' in data[i]:    
            latlong = getCoordinate(data[i-6])
            if type(latlong) == list:
                address = getAddress(latlong)
                print(latlong)
                print(address)
                blueList.append({'coordinate' : latlong, 'address' : address })
            else:
                print("something is wrong in blue")

    with open('redlist.json', 'w') as json_file:
        json.dump(redList, json_file)

    with open('orangelist.json', 'w') as json_file:
        json.dump(orangeList, json_file)

    with open('bluelist.json', 'w') as json_file:
        json.dump(blueList, json_file)        
        

if __name__ == '__main__':
    main()

