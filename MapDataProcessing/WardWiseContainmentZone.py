import json
import numpy as np
from shapely.geometry import Polygon, Point, MultiPolygon
from constant import wardDict

# function wardWiseSeparate(data):
#  input: the colour congested files from the map/the output of the file ExtractCoordinate.py
#  output: ward wise colour congested area
#  Description: this function search if the particular colour congested area is present in particular ward.

def wardWiseSeparate(data):
    wardWiseList = []
    for i in wardDict['features']:
        tempDict = {'wardID': i['properties']}
        pointsArry = []
        addressArry = []
        wardCoordinate = i['geometry']['coordinates']
        wardCoordNp = np.array(wardCoordinate)
        if wardCoordNp.shape[0] == 1:
            polygon = Polygon(wardCoordNp[0][0])
            for j in range(len(data)):
                point = Point(data[j]['coordinate'][1],data[j]['coordinate'][0])
                if polygon.contains(point):
                    pointsArry.append(data[j]['coordinate'])
                    addressArry.append(data[j]['address'])
            tempDict['points'] = pointsArry       
            tempDict['addresses'] = addressArry
            wardWiseList.append(tempDict)
    return wardWiseList

def fileProcess(inputFile, outputFile):
    try:
        with open(inputFile) as f:
            data = json.load(f)
            Coord = wardWiseSeparate(data)
    except:
        print("file not loaded")
    
    with open(outputFile, 'w') as json_file:
        json.dump(Coord, json_file)

def main():
    fileProcess('./Data/redlist.json' , './Data/WardWiseRed.json')
    fileProcess('./Data/orangelist.json' , './Data/WardWiseOrange.json')
    fileProcess('./Data/bluelist.json' , './Data/WardWiseBlue.json')


if __name__ == '__main__':
    main()
