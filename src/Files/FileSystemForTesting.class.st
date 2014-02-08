"
I represent a FileSystem that can be manipulated to simulate FileReference operations in tests. This avoids coupling tests with the real file system implementation.

See the file stream simulation category for the messages I provide for this purpose.
"
Class {
	#name : #FileSystemForTesting,
	#superclass : #Object,
	#instVars : [
		'writeStreams',
		'readStreams',
		'existingPaths'
	],
	#category : #'Files-System-Tests'
}

{ #category : #public }
FileSystemForTesting >> delimiter [

	^ $/
]

{ #category : #testing }
FileSystemForTesting >> exists: aPath [ 
	
	^ existingPaths includes: aPath
]

{ #category : #printing }
FileSystemForTesting >> forReferencePrintOn: aStream [

	aStream nextPutAll: 'memory://'
]

{ #category : #initialization }
FileSystemForTesting >> initialize [

	writeStreams := Dictionary new.
	readStreams := Dictionary new.
	existingPaths := Set new.
]

{ #category : #converting }
FileSystemForTesting >> pathFromObject: anObject [ 

	^ anObject asPathWith: self
]

{ #category : #converting }
FileSystemForTesting >> pathFromString: aString [

	^ Path from: aString
]

{ #category : #printing }
FileSystemForTesting >> printPath: aPath on: out [
	"Borrowed from #printPath:on: in FileSystem"
	
	aPath isAbsolute
		ifTrue: [ out nextPut: self delimiter ].
		
	^ aPath printOn: out delimiter: self delimiter
]

{ #category : #public }
FileSystemForTesting >> readStreamOn: aPath [ 
	
	^ (readStreams at: aPath) value
]

{ #category : #public }
FileSystemForTesting >> referenceTo: aResolvable [ 
	"Borrowed from #referenceTo: in FileSystem"

	^ FileReference 
		fileSystem: self
		path: (self pathFromObject: aResolvable)
]

{ #category : #initialization }
FileSystemForTesting >> simulateDoesNotExist: aFileReference [ 

	existingPaths
		remove: aFileReference path
		ifAbsent: [  ]
]

{ #category : #'file stream simulation' }
FileSystemForTesting >> simulateExists: aFileReference [ 

	existingPaths add: aFileReference path
]

{ #category : #'file stream simulation' }
FileSystemForTesting >> simulateReadStreamFor: aFileReference with: aFileStream [
	
	readStreams
		at: aFileReference path
		put: aFileStream.
		
	self simulateExists: aFileReference
]

{ #category : #'file stream simulation' }
FileSystemForTesting >> simulateWriteStreamFor: aFileReference with: aFileStream [

	writeStreams
		at: aFileReference path
		put: aFileStream.
		
	self simulateExists: aFileReference
]

{ #category : #accessing }
FileSystemForTesting >> workingDirectory [

	^ self referenceTo: '/'
]

{ #category : #public }
FileSystemForTesting >> writeStreamOn: aPath [
	| stream |
	
	stream := (writeStreams at: aPath) value.
	existingPaths add: aPath.
	
	^ stream
]
