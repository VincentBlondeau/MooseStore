"
Given a file and a default file (in that order), my instances returns the write stream for the first file that is writable. When it cannot be done, they return the read stream for the first file that can be read.

Example:
======

| filesOpener | 

filesOpener := FilesOpenerPrioritizedByMode
					file: aFile
					defaultFile: aDefaultFile.

fileStream := filesOpener streamIfReadOnly: readOnlyBlock
						    ifNone: exceptionBlock.

Description:
========

When there is at least a writable file:						
	If aFile is writable, the write stream for aFile is returned.
	If not, but aDefaultFile is writable, the write stream for aDefaultFile is returned.

When neither of the files are writable: 
	Returns the read stream for aFile and evaluates readOnlyBlock, if it can be read.
	Otherwise, returns the read stream for aDefaultFile and evaluates readOnlyBlock, if it can be read.
	
Finally, when neither of the files are writable nor readable:
	Evaluate exceptionBlock
"
Class {
	#name : #FileOpenerPrioritizedByMode,
	#superclass : #Object,
	#instVars : [
		'file',
		'defaultFile'
	],
	#classVars : [
		'Default'
	],
	#category : #'Files-System'
}

{ #category : #'instance creation' }
FileOpenerPrioritizedByMode class >> file: aFile defaultFile: aDefaultFile [

	^ self new
		    initializeFile: aFile
		    defaultFile: aDefaultFile
]

{ #category : #testing }
FileOpenerPrioritizedByMode >> anyFileExist [

	^ file exists or: [ defaultFile exists ]
]

{ #category : #streams }
FileOpenerPrioritizedByMode >> forReading: readOnlyBlock IfNone: exceptionBlock [

	self ignoreIfFail: [ ^ self readStreamFor: file
			     			       ifSuccess: readOnlyBlock ].
						
	self ignoreIfFail: [ ^ self readStreamFor: defaultFile
							 ifSuccess: readOnlyBlock ].

	^ exceptionBlock value

]

{ #category : #streams }
FileOpenerPrioritizedByMode >> forWritingIfNone: exceptionBlock [

	self ignoreIfFail: [ ^ file writeStream ].
	
	self ignoreIfFail: [ ^ defaultFile writeStream ].
	
	^ exceptionBlock value
]

{ #category : #'error handing' }
FileOpenerPrioritizedByMode >> ignoreIfFail: aBlock [

	^ [ aBlock value ] ifError: [ ]
]

{ #category : #'initialize-release' }
FileOpenerPrioritizedByMode >> initializeFile: aFile defaultFile: aDefaultFile [
	
	file := aFile.
	defaultFile := aDefaultFile
]

{ #category : #streams }
FileOpenerPrioritizedByMode >> readStreamFor: aFile ifSuccess: aBlock [
	| stream |

	stream := aFile readStream.
	aBlock value.
	
	^ stream
	
]

{ #category : #streams }
FileOpenerPrioritizedByMode >> streamifReadOnly: readOnlyBlock ifNone: exceptionBlock [
	"Try the references of all possible paths where to search for the .changes file."

	"We first try to open a writeStream and, if we can't, we open a readStream.
	We have to use #ignoreIfFail: here because Pharo has no way to really tell us beforehand if opening a writeStream will work.
	Sending #isWritable is not enough because #isWritable does not check if the current user is the owner of the file or not."

	self anyFileExist
		ifFalse: [ ^ exceptionBlock value ].
		
	^ self forWritingIfNone: [ self forReading: readOnlyBlock
								    IfNone: exceptionBlock ]
]
