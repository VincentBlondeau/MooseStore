Extension { #name : #OSPlatform }

{ #category : #'*Files' }
OSPlatform >> potentialLocationsOfSourcesFile [
	"Return a collection of directories where the PharoVXX.sources should be searched."
	^ self subclassResponsibility
]
