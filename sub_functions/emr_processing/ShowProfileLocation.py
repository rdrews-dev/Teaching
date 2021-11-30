#command-shif-p set interpreter to anaconda
import shapefile as shp #shp
import numpy as np
import matplotlib.pyplot as plt
import geopandas as gpd
from pyproj import Proj, transform
import os   

def GetPointsFromShp(ShpFileLocation):
    listx=[]
    listy=[]
    test = shp.Reader(ShpFileLocation)
    for sr in test.shapeRecords():
        for xNew,yNew in sr.shape.points:
            listx.append(xNew)
            listy.append(yNew)
    return (listx, listy)
def PlotShpFile(ShpFileLocation):
    gl = gpd.read_file(ShpFileLocation)
    gl.plot(figsize=(12,8), edgecolor="purple", facecolor="None")
    fig = plt.gcf()
    ax = plt.gca()
    #plt.show()
    return (fig,ax)

def ll2ps(lat,lon):
    outProj = Proj(init='epsg:3031')
    inProj = Proj(init='epsg:4326')
    psx,psy = transform(inProj,outProj,lat,lon)
    return psx,psy

def GetIDsFromDir(Directory):
    lIDs =[]
    for files in os.listdir(Directory):
        if files.endswith('table'):
            lIDs.append(files[0:6]) 
        else:
            continue
    return lIDs

IDs = ("983055","993023", "033007", "033023","033024","033036","033141","043047","043074","043146","063001","063102","063104")
RootData = "/Users/rdrews/Nextcloud/esd_group/Reinhard/AWI_Exploration/"
GLShpFilePath = "/Users/rdrews/Desktop/QGis/Quantarctica3/Glaciology/ASAID/ASAID_GroundingLine_Simplified.shp" 

IDs2 = GetIDsFromDir("antr2001/product-shp/")
IDs2 = ("983055","993023")
fix, ax  =  PlotShpFile(GLShpFilePath)

for CoordsId in IDs2:
    CoordsDir = f"{RootData}antr19{CoordsId[0:2]}/product-shp/"
    #CoordsDir = f"{RootData}antr20{CoordsId[0:2]}/product-shp/"
    CoordsAnnex  = "_koord.table"
    try:
        lTable = np.genfromtxt(f'{CoordsDir}{CoordsId}{CoordsAnnex}',skip_header=1)
        print(f'Found coordinates for {CoordsDir}{CoordsId}{CoordsAnnex}')
        lpsx,lpsy = ll2ps(lTable[:,0],lTable[:,1])
        plt.plot(lpsx,lpsy,'.',label=CoordsId)
    except:
        print(f'There is nothing for {CoordsId}')
        
        
    

ax.legend()
ax.set_xlim([-450000,-150000])
ax.set_ylim([1800000,2200000])
plt.show()


