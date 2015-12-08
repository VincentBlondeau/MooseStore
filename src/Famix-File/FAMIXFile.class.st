"
It represents a file in the file system.
"
Class {
	#name : #FAMIXFile,
	#superclass : #FAMIXAbstractFile,
	#category : #'Famix-File'
}

{ #category : #'initialize-release' }
FAMIXFile class >> annotation [
	<MSEClass: #File super: #FAMIXAbstractFile>
	<package: #FILE>
]

{ #category : #properties }
FAMIXFile >> averageNumberOfCharactersPerLine [
	<MSEProperty: #averageNumberOfCharactersPerLine type: #Number> <derived>
	<MSEComment: 'Average number of characters per line of text in a file.'>
	^ self
		lookUpPropertyNamed: #averageNumberOfCharactersPerLine
		computedAs: [ 
			self numberOfLinesOfText isZero
				ifFalse: [ (self numberOfCharacters / self numberOfLinesOfText) asFloat ]
				ifTrue: [ 0 ] ]
]

{ #category : #accessing }
FAMIXFile >> belongsTo [
	<MSEProperty: #belongsTo type: #FAMIXFolder opposite: #files>
	<MSEComment: 'Container of this file'>
	^ belongsTo
]

{ #category : #accessing }
FAMIXFile >> belongsTo: anObject [
	belongsTo := FMMultivalueLink
		on: self
		update: #files
		from: self belongsTo
		to: anObject.
	self resetMooseName
]

{ #category : #accessing }
FAMIXFile >> contents [
	^ self absoluteFileReference binaryReadStreamDo: [ :aStream | aStream contents asString ]
]

{ #category : #accessing }
FAMIXFile >> entitiesGroup [
	<navigation: 'Entities'>
	
	^ MooseGroup withAll: self entities withDescription: 'Entities defined in a file'
]

{ #category : #testing }
FAMIXFile >> exists [
	^ self fileExists 
]

{ #category : #testing }
FAMIXFile >> fileExists [
	^ self absoluteFileReference ifNil: [ ^ false ] ifNotNil: [ :file | file exists ]
]

{ #category : #testing }
FAMIXFile >> ifFileExistsDo: aBlock [
	^ self fileExists
		ifTrue: [ aBlock value ]
]

{ #category : #testing }
FAMIXFile >> isFolder [
	^ false
]

{ #category : #accessing }
FAMIXFile >> isSourceCodeLoaded [
	self propertyNamed: #sourceText ifAbsentPut: [ ^ false ].
	^ true
]

{ #category : #properties }
FAMIXFile >> numberOfBytes [
	<MSEProperty: #numberOfBytes type: #Number> <derived>
	<MSEComment: 'Number of bytes in a file.'>
	^ self
		lookUpPropertyNamed: #numberOfBytes
		computedAs: [ 
			self fileExists
				ifTrue: [ self absoluteFileReference size ]
				ifFalse: [ 0 ] ]
]

{ #category : #properties }
FAMIXFile >> numberOfCharacters [
	<MSEProperty: #numberOfCharacters type: #Number> <derived>
	<MSEComment: 'Number of characters in a file.'>
	
	^self lookUpPropertyNamed: #numberOfCharacters computedAs: [
		| result | 
		result := self fileExists ifTrue: [
			self sourceText size - (self totalNumberOfLinesOfText) + 1
		] ifFalse: [0]. 
		result max: 0
	]
]

{ #category : #properties }
FAMIXFile >> numberOfEmptyLinesOfText [
	<MSEProperty: #numberOfEmptyLinesOfText type: #Number>
	<MSEComment: 'Number of empty lines of text'>
	^ self
		lookUpPropertyNamed: #numberOfEmptyLinesOfText
		computedAs: [ 
			| text elot |
			elot := 0.
			self
				ifFileExistsDo: [ 
					text := self sourceText.
					1 to: text size - 1 do: [ :index | 
						((text at: index) = Character cr and: [ (text at: index + 1) = Character cr ])
							ifTrue: [ elot := elot + 1 ].
						((text at: index) = Character space and: [ (text at: index + 1) = Character cr ])
							ifTrue: [ elot := elot + 1 ] ].
					(text isNotEmpty and: [ text last = Character cr ])
						ifTrue: [ elot := elot + 1 ] ].
			elot ]
]

{ #category : #properties }
FAMIXFile >> numberOfKiloBytes [
	<MSEProperty: #numberOfKiloBytes type: #Number> <derived>
	<MSEComment: 'Number of kilo bytes in a file.'>		
	
	^ self lookUpPropertyNamed: #numberOfKiloBytes computedAs: [(self numberOfBytes / 1024) asFloat]
]

{ #category : #properties }
FAMIXFile >> numberOfLinesOfText [
	<MSEProperty: #numberOfLinesOfText type: #Number> <derived>
	<MSEComment: 'Number of lines of text which are not empty in a file '>
	
	^self lookUpPropertyNamed: #numberOfLinesOfText computedAs: [self totalNumberOfLinesOfText - self numberOfEmptyLinesOfText]
]

{ #category : #accessing }
FAMIXFile >> readStream [
	^ self absoluteFileReference readStream
]

{ #category : #accessing }
FAMIXFile >> sourceText [
	^ self
		lookUpPropertyNamed: #sourceText
		computedAs: [ 
			self fileExists
				ifTrue: [ self contents ]
				ifFalse: [ '' ] ]
]

{ #category : #accessing }
FAMIXFile >> sourceText: aString [
	^self
		propertyNamed: #sourceText
		put: aString
]

{ #category : #properties }
FAMIXFile >> totalNumberOfLinesOfText [
	<MSEProperty: #totalNumberOfLinesOfText type: #Number>
	<MSEComment: 'Number of lines of text'>
	^ self
		lookUpPropertyNamed: #totalNumberOfLinesOfText
		computedAs: [ 
			self sourceText isEmpty
				ifFalse: [ self sourceText lineCount ]
				ifTrue: [ 
					self exists
						ifTrue: [ (self sourceText select: [ :each | each = Character cr ]) size + 1 ]
						ifFalse: [ 0 ] ] ]
]
