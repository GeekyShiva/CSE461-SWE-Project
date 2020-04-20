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
		self.clusters_details={}
		self.clustering_algorithm_parameters={'quantile': .1,
											'eps': .0095,
											'damping': .98,
											'n_clusters': 10}
		self.clustering_algorithms=['DBSCAN','MeanShift','AffinityPropagation','KMeans']
		self.wards=[]
		self.population_intensity=[]
		self.population_intensity_weights=[]

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

	# function generate_A(data,path to ward neighbors file):
	# 	input: given data having latitude longitude assigned with ward ids and corresponding population intensity
	# 	output: A matrix to be used for weights computation
	# 	Description:
	# 	The function is used to compile matrix A that is used furthen in weights computation. The formulation is Ax=b 
	# 	to be used to fit a given cluster data according to three variables for population intensity.

	def generate_A(self,X,path_data):
		A_rows=len(self.wards)
		A_columns=len(self.population_intensity)
		A=np.zeros((A_rows,A_columns))
		missing_wards=[]
		for ww in range(A_rows):
			if self.wards[ww] in X["ward_id"].unique():
				for cc in range(A_columns):
					A[ww,cc]=len(X[(X["ward_id"]==self.wards[ww]) & (X["color_marker"]==self.population_intensity[cc])])
			else:
				missing_wards.append(ww)
		#for missing wards fill the details by averaging neighboring wards
		if len(missing_wards)>0:
			wards_neighbors=pd.read_csv(path_data)
			for mw in missing_wards:
				mw_neighbors=wards_neighbors[wards_neighbors["ward_name"]==self.wards[mw]]["neighbours"].values[0].replace("[","").replace("]","").split(",")
				for cc in range(A_columns):
					for mwn in mw_neighbors:
						A[mw,cc]+=len(X[(X["ward_id"]==mwn) & (X["color_marker"]==self.population_intensity[cc])])
					A[mw,cc]= np.ceil(A[mw,cc]/len(mw_neighbors))
		return A

	# function get_b(data ,date):
	# 	input: data with ward and intensity information
	#		   date for which the count has to be considered to fit the model
	# 	output: b vector describing total cases in every word
	# 	Description:
	#	This function is used to create the b vector needed for solving Ax=b

	def get_b(self,X,date_string):
		b=np.zeros((len(self.wards)))
		for ww in range(len(self.wards)):
			b[ww]=X[X["ward_name"]==self.wards[ww]][date_string].values[0]
		return b

	# function get_weights(Amatrix ,b vector):
	# 	input: A matrix depicting count of cases for every population intensity in every ward,
	#		   b vector depicting total no of cases per ward
	# 	output: weight vector for population intensity
	# 	Description:
	# 	The function is used to find the weights for different population intensity. There are different population intensity which 
	#	are grouped as "Red": for congested areas, "Orange" : medium level congested area  and "Blue": stanalone structure depicting
	#	very less crowd.
	#	Given total number of cases are combined for all these three. We find the weights in which these areas contribute to final count
	
	def get_weights(self,X,b):
		Xt=np.linalg.inv(np.matmul(X.T,X))
		weights=np.matmul(np.matmul(Xt,X.T),b)
		return weights


	# function get_cases(data ):
	# 	input: data with cluster and intensity assignment
	# 	output: matrix filled with no of cases per cluster per population intensity
	# 	Description:
	#	This function is used to find patient distribution in every cluster and use weights to find total cases in cluster

	def get_cases(self,X):
		clusters=X["cluster_assignment"].unique()
		cluster_cases=np.zeros((len(clusters),len(self.population_intensity)))
		for cl in range(len(clusters)):
			for cc in range(len(self.population_intensity)):
				cluster_cases[cl,cc]=len(X[(X["cluster_assignment"]==clusters[cl]) & (X["color_marker"]==self.population_intensity[cc])])
		return cluster_cases

if ( __name__ == "__main__"):
	zone_object=ZoneController()


	#hard-coded values or input to be asked to user
	location_data_path="../MLData/Mumbai/mumbai_combined.csv"
	patient_data_path="../MLData/Mumbai/ward_wise_positive_cases.csv"
	neighbours_data_path="../MLData/Mumbai/ward_neighbors.csv"
	date_to_filter="14.04.20"
	clustering_algorithm_to_use="DBSCAN"

	#location data for clustering
	location_data=pd.read_csv(location_data_path)
	zone_object.location_coordinates=location_data[["latitude","longitude"]].values

	#total patient data 
	zone_object.patient_data=pd.read_csv(patient_data_path)

	zone_object.location_clusters=zone_object.createClusters(clustering_algorithm_to_use)
	zone_object.plotClusters(clustering_algorithm_to_use)
	
	#assign patient data to clusters along with population in the cluster.
	zone_object.wards=zone_object.patient_data["ward_name"].unique()
	zone_object.population_intensity=["Red","Orange","Blue"]
	
	#Regression in three dimensions (Red,Blue,Orange)
	#variables are weights assigned to every dimension w1,w2,w3
	#the formulation becomes of the form Ax=b 
	#where A is matrix with counts for red,blue and orange for each ward
	#b is total cases in the ward
	#x is vector w1,w2 and w3
	#we generate A matrix, if transpose(A)*A is invertible we can directly solve this using closed form solution for x
	A_mat=zone_object.generate_A(location_data,neighbours_data_path)
	b_vec=zone_object.get_b(zone_object.patient_data,date_to_filter)
	weights=zone_object.get_weights(A_mat,b_vec)
	print("Weights for population intensity:\n",weights)

	#find case distribution in every cluster and use weights to find total cases in cluster
	location_data["cluster_assignment"]=zone_object.location_clusters[:,2]
	clusters=np.unique(zone_object.location_clusters[:,2])
	print("clusters:\n",clusters)
	cases_per_cluster_per_intensity=zone_object.get_cases(location_data)
	print("Matrix depicted cases per cluster per intensity:\n",cases_per_cluster_per_intensity)
	# #predict total cases per cluster using weights of intensity colors
	total_cases_per_cluster=np.round(np.matmul(cases_per_cluster_per_intensity,weights))
	print("Total cases per cluster:\n",total_cases_per_cluster)
