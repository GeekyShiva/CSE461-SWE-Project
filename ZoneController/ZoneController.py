import os,sys,string
import collections
import itertools
import regex as re
import numpy as np
import pickle
import time
import json
import pandas as pd
from sklearn.cluster import MiniBatchKMeans,Birch,AgglomerativeClustering,KMeans,SpectralClustering
from sklearn.cluster import MeanShift,DBSCAN,AffinityPropagation,OPTICS
from sklearn.cluster import estimate_bandwidth
from sklearn.neighbors import kneighbors_graph
from sklearn.preprocessing import StandardScaler
from sklearn import mixture
from matplotlib import pyplot as plt
import time
import warnings
from itertools import cycle, islice

#	class ZoneController:
# 		Main class for machine learning based zone categorization. We use clustering to assign clusters to given
# 		locations with known positive cases. We then compute severity of outbreak in a cluster and accordingly
# 		assign the threat level. To compute this, we use patient data such as positive cases along with cluster data such as 
# 		population count in a cluster.

class ZoneController:
	def __init__(self):
		self.location_coordinates=[]
		self.patient_data=[]
		self.location_clusters=[]
		self.clusters_details=[]
		self.clustering_algorithm_parameters={'quantile': .1,
											'eps': .0095,
											'damping': .98,
											'n_clusters': 10}
		self.clustering_algorithms=['DBSCAN','MeanShift','AffinityPropagation','KMeans']

	# function getClusteringObject(cluster_algo):
	# 	input: clustering algorithm to use
	# 	output: object for given clustering algorithm
	# 	Description:
	# 	The function is used to create a object corresponding to the clustering algorithm. The parameters needed are
	#	stored in global variable clustering_algorithm_parameters

	def getClusteringObject(self,cluster_algo):

		if cluster_algo == 'DBSCAN':
			clust_object = DBSCAN(eps=self.clustering_algorithm_parameters['eps'])		
		elif cluster_algo == 'MeanShift':
			bandwidth = estimate_bandwidth(self.location_coordinates, quantile=self.clustering_algorithm_parameters['eps'])
			clust_object = MeanShift(bandwidth=bandwidth, bin_seeding=True)		
		elif cluster_algo == 'AffinityPropagation':
			clust_object = AffinityPropagation(damping=self.clustering_algorithm_parameters['damping'])		
		elif cluster_algo == 'KMeans':
			clust_object = KMeans(n_clusters=self.clustering_algorithm_parameters['n_clusters'], random_state=0)
		else:
			print("Clustering algorithm not available")
			return null
		return clust_object

	# function plotClusters(cluster_algo):
	# 	input: clustering algorithm to use
	# 	output: plot for given cluster assignment
	# 	Description:
	# 	The function is used to plot the cluster assignment for location coordinates. Every cluster is assigned a colour and 
	#	all points in that cluster are plotted using corresponding colour.

	def plotClusters(self,cluster_algo):
		plt.title(cluster_algo, size=18)
		colors = np.array(list(islice(cycle(['#377eb8', '#ff7f00', '#4daf4a',
			'#f781bf', '#a65628', '#984ea3',
			'#999999', '#e41a1c', '#dede00']),
			int(max(self.location_clusters[:,2]) + 1))))
		# add black color for outliers (if any)
		colors = np.append(colors, ["#000000"])
		# plt.scatter(self.location_clusters[:, 0], self.location_clusters[:, 1])
		plt.scatter(self.location_clusters[:, 0], self.location_clusters[:, 1], s=10, color=colors[self.location_clusters[:, 2].astype(int)])
		plt.show()


	# function createClusters(cluster_algo):
	# 	input: clustering algorithm to use
	# 	output: cluster assignment to locations
	# 	Description:
	# 	The function is used to cluster given set of location coordinates. The location ordinates depict
	# 	known positive cases at a location.  

	def createClusters(self,cluster_algo):
		clustering_object=self.getClusteringObject(cluster_algo)
		clustering_object.fit(self.location_coordinates)
		predicated_clusters = clustering_object.labels_.astype(np.int)
		assigned_clusters=np.hstack((self.location_coordinates,predicated_clusters.reshape(-1,1)))

		# if hasattr(clustering_object, 'labels_'):
		# 	y_pred = clustering_object.labels_.astype(np.int)
		# else:
		# 	y_pred = clustering_object.predict(self.location_coordinates)
		
		return assigned_clusters

if ( __name__ == "__main__"):
	zone_object=ZoneController()

	location_data_path="../MLData/Mumbai/mumbai_combined.csv"
	location_data=pd.read_csv(location_data_path)
	zone_object.location_coordinates=location_data[["latitude","longitude"]].values


	patient_data_path="../MLData/Mumbai/positive_case.csv"
	zone_object.patient_data=pd.read_csv(patient_data_path)

	zone_object.location_clusters=zone_object.createClusters("DBSCAN")
	zone_object.plotClusters("DBSCAN")