"
A FAMIXRootFolder contains all the FAMIXAbstractFile that have for root folder itself. Can be changed easily and several can exist by model allowing to import a collection of folder. 

Is accessed by rootDirectories on the mooseModel.

Instance Variables
	contents:		<FAMIXAbstractFiles>

contents
	- xxxxx

"
Class {
	#name : #FAMIXRootFolder,
	#superclass : #FAMIXAbstractFile,
	#category : #'Famix-File'
}

{ #category : #accessing }
FAMIXRootFolder >> belongsTo [
	^ nil
]

{ #category : #accessing }
FAMIXRootFolder >> belongsTo: anUndefinedObject [ 
	
]

{ #category : #accessing }
FAMIXRootFolder >> resolveReference: aFileReference [
	^ self fileReference parent resolveReference: aFileReference
]
