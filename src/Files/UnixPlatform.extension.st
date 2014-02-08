Extension { #name : #UnixPlatform }

{ #category : #'*Files' }
UnixPlatform >> potentialLocationsOfSourcesFile [
	^ { Smalltalk vm directory. FileLocator userData }
]
