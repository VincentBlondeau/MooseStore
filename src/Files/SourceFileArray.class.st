"
This is a variation on StandardSourceFileArray that provides a larger maximum changes file size.

The available address space for source pointers in a traditional CompiledMethod is 16r1000000 through 16r4FFFFFF. StandardSourceFileArray maps positions in the sources file to address range 16r1000000 through 16r1FFFFFF and 16r3000000 through 16r3FFFFFF, and positions in the changes file to address range 16r2000000 through 16r2FFFFFF and 16r4000000 through 16r4FFFFFF. This permits a maximum file size of 16r2000000 (32MB) for both the sources file and the changes file. 

This implementation extends the source pointer address space using bit 25 of the source pointer to identify the external sources and changes files, with the remaining high order bits treated as address extension. This limits the number of external file references to two (the traditional sources and changes files). If additional external file references are needed in the future, some higher order bits in the source pointer address space should be allocated for that purpose.

The use of bit 25 of the source pointer for file references permits backward compatibility with StandardSourceFileArray, with essentially unlimited address space expansion for the sources and changes files.

"
Class {
	#name : #SourceFileArray,
	#superclass : #SequenceableCollection,
	#instVars : [
		'files'
	],
	#category : #'Files-System'
}

{ #category : #'initialize-release' }
SourceFileArray class >> install [
	"Replace SourceFiles by an instance of me with the standard sources and changes files.
	This only works if SourceFiles is either an Array or an instance of this class"

	"SourceFileArray install"

	^ SourceFiles := self new
]

{ #category : #'instance creation' }
SourceFileArray class >> new: nFiles [
	^self new initialize: nFiles.
]

{ #category : #accessing }
SourceFileArray >> at: index [
	^files at: index
]

{ #category : #accessing }
SourceFileArray >> at: index put: aFile [
	^ files at: index put: aFile
]

{ #category : #'source code management' }
SourceFileArray >> changeRecordsFor: aMethodDefinition detect: aUnaryBlock [
	"Try to detect the most recent ChangeRecord that satisfies aUnaryBlock. Answer nil if none satisfies."

	self
		changeRecordsFor: aMethodDefinition
		do: [ :changeRecord | 
			(aUnaryBlock value: changeRecord category) 
				ifTrue: [ ^ changeRecord ] ].
	^ nil
]

{ #category : #'source code management' }
SourceFileArray >> changeRecordsFor: aMethodDefinition do: aUnaryBlock [
	"Evaluate aUnaryBlock with each of the ChangeRecords of aMethodDefinition. Most recent changes are evaluated first."

	| method |
	method := aMethodDefinition actualClass 
		compiledMethodAt: aMethodDefinition selector
		ifAbsent: [ ^ self ].

	self 
		changeRecordsFrom: method sourcePointer 
		className: aMethodDefinition theNonMetaClassName
		isMeta: aMethodDefinition classIsMeta
		do: aUnaryBlock
]

{ #category : #'source code management' }
SourceFileArray >> changeRecordsFrom: initialSourcePointer className: theNonMetaClassName isMeta: classIsMeta do: aUnaryBlock [
	"Evaluate aUnaryBlock with each of the ChangeRecords of a method, starting from the initialSourcePointer. 
	Most recent changes are evaluated first."

	| filePosition fileIndex |
	fileIndex := self fileIndexFromSourcePointer: initialSourcePointer.
	filePosition := self filePositionFromSourcePointer: initialSourcePointer.	

	self readOnlyDo: [ :sourceFilesCopy | 
		| file previousFilePosition previousFileIndex preamble stamp protocol preambleTokens |
		file := sourceFilesCopy 
			at: fileIndex 
			ifAbsent: [ ^ self ].
		
		[ filePosition notNil & file notNil ]
			whileTrue: [ 
				file position: (0 max: filePosition - 150).	"Skip back to before the preamble"
				[ file position < (filePosition - 1) ] whileTrue: [ preamble := file nextChunk ].	"then pick it up from the front"	
					"Preamble is likely a linked method preamble, if we're in
					a changes file (not the sources file).  Try to parse it
					for prior source position and file index"

				previousFilePosition := nil.
				stamp := ''.
				(preamble includesSubstring: 'methodsFor:')
					ifTrue: [ preambleTokens := preamble parseLiterals ]
					ifFalse: [ preambleTokens := Array new	"ie cant be back ref" ].

				((preambleTokens size between: 7 and: 8) and: [ (preambleTokens at: preambleTokens size - 5) = #methodsFor: ])
					ifTrue: [ 
						(preambleTokens at: preambleTokens size - 3) = #stamp:
							ifTrue: [ 
								"New format gives change stamp and unified prior pointer"
								stamp := preambleTokens at: preambleTokens size - 2.
								previousFilePosition := preambleTokens last.
								previousFileIndex := self fileIndexFromSourcePointer: previousFilePosition.
								previousFilePosition := self filePositionFromSourcePointer: previousFilePosition ]
							ifFalse: [ 
								"Old format gives no stamp; prior pointer in two parts"
								previousFilePosition := preambleTokens at: preambleTokens size - 2.
								previousFileIndex := preambleTokens last ].
						(previousFilePosition = 0 or: [ previousFileIndex = 0 ])
							ifTrue: [ previousFilePosition := nil ] ].

				((preambleTokens size between: 5 and: 6) and: [ (preambleTokens at: preambleTokens size - 3) = #methodsFor: ])
					ifTrue: [ 
						(preambleTokens at: preambleTokens size - 1) = #stamp:
							ifTrue: [ 
								"New format gives change stamp and unified prior pointer"
								stamp := preambleTokens at: preambleTokens size ] ].
						
				protocol := preambleTokens 
					after: #methodsFor: 
					ifAbsent: [ Protocol unclassified ].

				aUnaryBlock value: (
					ChangeRecord new
						file: file
						position: filePosition
						type: #method
						class: theNonMetaClassName
						category: protocol
						meta: classIsMeta
						stamp: stamp).

				filePosition := previousFilePosition.
				previousFilePosition ifNotNil: [ 
					file := sourceFilesCopy 
						at: previousFileIndex
						ifAbsent: [  ^ self ] ] ] ]
]

{ #category : #'file system' }
SourceFileArray >> ensureOpen [
	"Ensure that the source and changes files are opened."

	files :=
		Array
			with: PharoFilesOpener default sourcesFileOrNil
			with: PharoFilesOpener default changesFileOrNil
]

{ #category : #'sourcepointer conversion' }
SourceFileArray >> fileIndexFromSourcePointer: anInteger [
	"Return the index of the source file which contains the source chunk addressed by anInteger"

	(anInteger bitAnd: 16r1000000) ~= 0
		ifTrue: [^1 "sources file"]
		ifFalse: [anInteger >= 16r1000000
			ifTrue: [^2 "changes file"]
			ifFalse: [^0 "compatibility with StandardSourceFileArray"]]
]

{ #category : #'sourcepointer conversion' }
SourceFileArray >> filePositionFromSourcePointer: anInteger [ 
	"Return the position of the source chunk addressed by anInteger"

	| hi lo |
	hi := anInteger // 33554432.
	lo := anInteger \\ 16777216.
	((anInteger bitAnd: 16777216) ~= 0
			or: [anInteger < 16777216 "compatibility with StandardSourceFileArray"])
		ifTrue: [^ hi * 16777216 + lo"sources file"]
		ifFalse: [^ hi - 1 * 16777216 + lo"changes file"]
]

{ #category : #'source code management' }
SourceFileArray >> getPreambleFrom: aFileStream at: position [

	|  writeStream |
	writeStream := String new writeStream.
	position to: 0 by: -1 do: [ :p | 
			| c | 
			aFileStream position: p.
			c := aFileStream basicNext.
			c == $!
				ifTrue: [^ writeStream contents reversed]
				ifFalse: [writeStream nextPut: c]]
]

{ #category : #initialization }
SourceFileArray >> initialize [
	files := Array new: 2.
	files at: 1 put: (SourceFiles at: 1).
	files at: 2 put: (SourceFiles at: 2)
]

{ #category : #'initialize-release' }
SourceFileArray >> initialize: nFiles [
	files := Array new: nFiles
]

{ #category : #'source code management' }
SourceFileArray >> protocolAt: sourcePointer [
	"Answer the protocol for a given method, retrieved from the sources or changes file. Answer unfound protocol if no protocol is available"
				
	^ self protocolAt: sourcePointer for: self sourceDataPointers
]

{ #category : #'source code management' }
SourceFileArray >> protocolAt: sourcePointer for: sourceDataPointers [
	"Answer the protocol for a given method, retrieved from the sources or changes file. Answer unfound protocol if no protocol is available."	
				
	| preamble protocol tokens protocolPosition |
	protocol := 'unfound protocol'.
	"this is to indicate that the tagging in the source does not use the correct format.
	We will have to fix that. For example some traits methods are wrongly tagged.
	see http://code.google.com/p/pharo/issues/detail?id=4581"
	preamble := self sourcedDataAt: sourcePointer.	
	preamble = 'Trait method' ifTrue: [ ^nil ].
	(preamble includesSubstring: (sourceDataPointers key))
			ifTrue: [ tokens := preamble parseLiterals.
				     	protocolPosition := tokens indexOf: sourceDataPointers key.
					protocolPosition = 0
						ifFalse: [
							"New format gives change protocol and unified prior pointer"
							protocol := tokens at: protocolPosition + 1] ].
 	^protocol
]

{ #category : #accessing }
SourceFileArray >> readOnlyDo: aBlock [
	| sourceFilesCopy |
	"get a read only copy of each file"
	sourceFilesCopy := self collect: [:aFile | aFile ifNotNil: [ aFile readOnlyCopy ] ].

	[ aBlock value: sourceFilesCopy ] ensure: [
		"close the files"
		sourceFilesCopy do: [ :aFile | aFile ifNotNil: [ aFile close ] ] ]
]

{ #category : #accessing }
SourceFileArray >> size [
	^files size
]

{ #category : #'source code management' }
SourceFileArray >> sourceCodeAt: sourcePointer [ 
	"Retrieves the source code for the pointer received as argument"
	
	| fileIndex filePosition |
	filePosition := self filePositionFromSourcePointer: sourcePointer.
	^filePosition = 0
		ifTrue: [ '' ]
		ifFalse:[ fileIndex := self fileIndexFromSourcePointer: sourcePointer.
				(RemoteString newFileNumber: fileIndex position: filePosition) string ]
]

{ #category : #private }
SourceFileArray >> sourceDataPointers [
	"Retrieves the combination key to look for information of the receiver in the source file"
	"'Point methodsFor: ''point functions'' stamp: ''lr 7/4/2009 10:42'''."
	
	^'methodsFor:' -> #stamp:
]

{ #category : #'sourcepointer conversion' }
SourceFileArray >> sourcePointerFromFileIndex: index andPosition: position [
	"Return a sourcePointer encoding the given file index and position"

	| hi lo |
	(index = 1 or: [index = 2])
		ifFalse: [self error: 'invalid source file index'].
	position < 0 ifTrue: [self error: 'invalid source code pointer'].
	hi := position // 16r1000000 *2 + index.
	lo := position \\ 16r1000000.
	^ hi * 16r1000000 + lo

]

{ #category : #'source code management' }
SourceFileArray >> sourcedDataAt: sourcePointer [

	| index position file preamble |
	index:= self fileIndexFromSourcePointer: sourcePointer.
	index = 0 ifTrue: [ ^'' ].  "no source pointer for this element"
	position := self filePositionFromSourcePointer: sourcePointer.
	file := self at: index.
	file ifNil: [ ^'' ].  "sources file not available"
	"file does not exist happens in secure mode"
	file := [file readOnlyCopy] 
			on: FileDoesNotExistException 
			do:[:ex| ^'' ].
	self flag: 'I do not know why 3 is a good number'.
	preamble :=  self getPreambleFrom: file at: (0 max: position - 3).
	file close.
	^preamble
]

{ #category : #'source code management' }
SourceFileArray >> timeStampAt: sourcePointer [ 
	"Answer the authoring time-stamp for the given method, retrieved from the sources or changes file. Answer the empty string if no time stamp is available."		
				
	^ self timeStampAt: sourcePointer for: self  sourceDataPointers 
]

{ #category : #'source code management' }
SourceFileArray >> timeStampAt: sourcePointer for: sourceDataPointers [
	"Answer the authoring time-stamp for the given method, retrieved from the sources or changes file. Answer the empty string if no time stamp is available."		
				
	| preamble stamp tokens stampPosition |
	stamp := ''.
	preamble := self sourcedDataAt: sourcePointer.
	(preamble includesSubstring: sourceDataPointers key)
			ifTrue: [ tokens := preamble parseLiterals.
				     	stampPosition := tokens indexOf: sourceDataPointers value.
					stampPosition = 0
						ifFalse: [
							"New format gives change stamp and unified prior pointer"
							stamp := tokens at: stampPosition + 1]].
 	^stamp
]
