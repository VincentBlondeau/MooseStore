"
I'm the root for the new importer.
This way my subclasses share error logging and importerContext
"
Class {
	#name : #MooseAbstractImporter,
	#superclass : #MooseTask,
	#instVars : [
		'importingContext',
		'loggingStream',
		'model'
	],
	#category : #'Moose-GenericImporter'
}

{ #category : #public }
MooseAbstractImporter class >> model: aMooseModel [
	"Create an instance of myself and assign the current model. This model is filled up during the import"

	^ self new model: aMooseModel; yourself
]

{ #category : #public }
MooseAbstractImporter class >> targetModel: aMooseModel [ 
	self 
		deprecated: 'Use model: instead'
		on: 	'1 February 2015' 
		in: 'Moose-GenericImporter'.
	^ self model: aMooseModel 
]

{ #category : #'Moose deprecated' }
MooseAbstractImporter >> closeLog [ 
	 
	Transcript == self errorLog ifFalse: [self errorLog close]
]

{ #category : #accessing }
MooseAbstractImporter >> defaultImportingContext [
	^ MooseImportingContext new importMaximum
]

{ #category : #'Moose deprecated' }
MooseAbstractImporter >> errorLog [ 
	 
	^ loggingStream
]

{ #category : #'Moose deprecated' }
MooseAbstractImporter >> errorLog: aStream [ 

	loggingStream := aStream
	 

]

{ #category : #'Moose deprecated' }
MooseAbstractImporter >> errorLogFileNamed: aString [ 

	self errorLog: (FileSystem disk referenceTo: aString) writeStream
]

{ #category : #accessing }
MooseAbstractImporter >> importingContext [ 
	 
	^importingContext
]

{ #category : #accessing }
MooseAbstractImporter >> importingContext: anObject [ 
	 
	importingContext := anObject
]

{ #category : #'initialize-release' }
MooseAbstractImporter >> initialize [
	super initialize.
	model := MooseModel new.
	importingContext := self defaultImportingContext
]

{ #category : #'Moose deprecated' }
MooseAbstractImporter >> logFileSuffix [ 
	 
	^'.log'
]

{ #category : #'Moose deprecated' }
MooseAbstractImporter >> logInitialize [ 
	 
	self errorLog: Transcript
]

{ #category : #accessing }
MooseAbstractImporter >> model [
	^ model ifNil: [ model := MooseModel new ]
]

{ #category : #accessing }
MooseAbstractImporter >> model: mooseModel [ 
	 
	model := mooseModel
]

{ #category : #'accessing - deprecated' }
MooseAbstractImporter >> targetModel [
	self 
		deprecated: 'Use model instead'
		on: 	'1 February 2015' 
		in: 'Moose-GenericImporter'.
	^ self model
]

{ #category : #'accessing - deprecated' }
MooseAbstractImporter >> targetModel: aMooseModel [ 
	self 
		deprecated: 'Use model: instead'
		on: 	'1 February 2015' 
		in: 'Moose-GenericImporter'.
	^ self model: aMooseModel 
]

{ #category : #'Moose deprecated' }
MooseAbstractImporter >> writeLog: aString [ 
	 
	(self errorLog) 
		nextPutAll: aString; 
		cr
]
