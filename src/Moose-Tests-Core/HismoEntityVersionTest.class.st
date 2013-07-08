Class {
	#name : #HismoEntityVersionTest,
	#superclass : #TestCase,
	#category : #'Moose-Tests-Core'
}

{ #category : #tests }
HismoEntityVersionTest >> testIsStub [
	| versionEntity version |
	versionEntity := FAMIXClass new. 
	version := HismoEntityVersion new.
	version versionEntity: versionEntity.
	self assert: version isStub not.
	
	versionEntity isStub: true.
	self assert: version isStub
]
