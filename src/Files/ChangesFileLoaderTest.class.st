Class {
	#name : #ChangesFileLoaderTest,
	#superclass : #TestCase,
	#instVars : [
		'fileSystem',
		'errorMessages',
		'fileContents'
	],
	#category : #'Files-System-Tests'
}

{ #category : #'test objects' }
ChangesFileLoaderTest >> badChangesFileContents [

	^ String crlf
]

{ #category : #'test objects' }
ChangesFileLoaderTest >> changesFile [

	^ self fileSystem referenceTo: self changesName
]

{ #category : #'simulation - SmalltalkImage' }
ChangesFileLoaderTest >> changesName [
	
	^ '/home/pharo/pharo.changes'
]

{ #category : #'test objects' }
ChangesFileLoaderTest >> defaultChangesFile [

	^ self fileSystem workingDirectory / self changesFile basename
]

{ #category : #'test objects' }
ChangesFileLoaderTest >> errorMessages [

	^ errorMessages
]

{ #category : #'test objects' }
ChangesFileLoaderTest >> fileSystem [
	
	^ fileSystem
]

{ #category : #'simulation - UIManager' }
ChangesFileLoaderTest >> inform: aMessage [

	errorMessages add: aMessage
]

{ #category : #'simulation - FileStream' }
ChangesFileLoaderTest >> next: anInteger [ 
	
	^ fileContents 
]

{ #category : #'test objects' }
ChangesFileLoaderTest >> pharoFilesOpener [

	^ ChangesFileLoader smalltalkImage: self smalltalkImage
						   fileSystem: self fileSystem
						   uiManager: self
]

{ #category : #running }
ChangesFileLoaderTest >> setUp [

	fileSystem := FileSystemForTesting new.
	errorMessages := Set new.
	
	self simulateFileContents: self validChangesFileContents.
	
]

{ #category : #'simulation - FileSystem' }
ChangesFileLoaderTest >> simulateDoesNotExist: aFileReference [ 

	self fileSystem
		simulateDoesNotExist: aFileReference.
]

{ #category : #'simulation - FileStream' }
ChangesFileLoaderTest >> simulateFileContents: contents [

	fileContents := contents
]

{ #category : #'simulation - FileSystem' }
ChangesFileLoaderTest >> simulateNotReadable: aFileReference [ 

	self fileSystem
			simulateReadStreamFor: aFileReference
			with: [ self error: 'this file is non readable' ]

]

{ #category : #'simulation - FileSystem' }
ChangesFileLoaderTest >> simulateReadableOnly: aFileReference [

	self fileSystem
		simulateReadStreamFor: aFileReference
		with: self
]

{ #category : #'simulation - FileSystem' }
ChangesFileLoaderTest >> simulateReadableOnlyWithBadContents: aFileReference [ 

	self simulateFileContents: self badChangesFileContents.
	self simulateReadableOnly: aFileReference
]

{ #category : #'simulation - FileSystem' }
ChangesFileLoaderTest >> simulateWritable: aFileReference [

	self fileSystem
		simulateWriteStreamFor: aFileReference
		with: self
]

{ #category : #'simulation - FileSystem' }
ChangesFileLoaderTest >> simulateWritableWithBadContents: aFileReference [ 
	
	self simulateFileContents: self badChangesFileContents.
	self simulateWritable: aFileReference.
]

{ #category : #'test objects' }
ChangesFileLoaderTest >> smalltalkImage [

	^ self
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01aWhenTheDefaultChangesFileIsWritableTooReturnsTheWriteStreamForTheChangesFile [
	| changesFileStream |
	
	self simulateWritable: self changesFile.
	self simulateWritable: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self changesFile writeStream
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01bWhenTheDefaultChangesFileIsReadableOnlyReturnsTheWriteStreamForTheChangesFile [
	| changesFileStream |
	
	self simulateWritable: self changesFile.
	self simulateReadableOnly: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self changesFile writeStream
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01cWhenTheDefaultChangesFileIsNotReadableReturnsTheWriteStreamForTheChangesFile [
	| changesFileStream |
	
	self simulateWritable: self changesFile.
	self simulateNotReadable: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self changesFile writeStream
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01dWhenTheDefaultChangesFileDoesNotExistReturnsTheWriteStreamForTheChangesFile [
	| changesFileStream |
	
	self simulateWritable: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self changesFile writeStream
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01eWhenTheDefaultChangesFileDoesNotExistItDoesNotCreateIt [
	
	self simulateWritable: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self deny: self defaultChangesFile exists
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01fItDoesNotEvaluateTheExceptionBlock [

	self simulateWritable: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [ self fail  ].
	
	self assert: true
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01gItDoesNotInformErrors [

	self simulateWritable: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [ self fail  ].
	
	self assert: self errorMessages isEmpty
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01hWhenTheChangesFileHasBadContentsInformsChangesFileHasBadContents [
	
	self simulateWritableWithBadContents: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: self errorMessages size = 1.
	self assert: (self errorMessages includes: self pharoFilesOpener changesFileWithBadContentsMessage)
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01iWhenTheChangesFileHasBadContentsDoesNotEvaluateExceptionBlock [
	
	self simulateWritableWithBadContents: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [ self fail  ].
	
	self assert: true
]

{ #category : #'tests - 01 - changes file is writable' }
ChangesFileLoaderTest >> test01jWhenTheChangesFileHasBadContentsDoesNotCreateTheDefaultChangesFile [
	
	self simulateWritableWithBadContents: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self deny: self defaultChangesFile exists
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02aWhenTheDefaultChangesFileIsWritableReturnsTheWriteStreamForTheDefaultChangesFile [
	| changesFileStream |
	
	self simulateReadableOnly: self changesFile.
	self simulateWritable: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self defaultChangesFile writeStream
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02bWhenTheDefaultChangesFileIsReadableOnlyTooReturnsTheReadStreamForTheChangesFile [
	| changesFileStream |
	
	self simulateReadableOnly: self changesFile.
	self simulateReadableOnly: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self changesFile readStream
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02cWhenTheDefaultChangesFileIsNotReadableReturnsTheReadStreamForTheChangesFile [
	| changesFileStream |
	
	self simulateReadableOnly: self changesFile.
	self simulateNotReadable: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self changesFile readStream
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02dWhenTheDefaultChangesFileDoesNotExistReturnsTheReadStreamForTheChangesFile [
	| changesFileStream |
	
	self simulateReadableOnly: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self changesFile readStream
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02eWhenTheDefaultChangesFileDoesNotExistItDoesNotCreateIt [
	
	self simulateReadableOnly: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self deny: self defaultChangesFile exists
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02fItDoesNotEvaluateTheExceptionBlock [
	
	self simulateReadableOnly: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [ self fail ].
	
	self assert: true
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02gWhenInformAbountReadOnlyChangesIsSetInformsThatChangesFileCouldNotBeWritten [
	| filesOpener |
	
	self simulateReadableOnly: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.	
	filesOpener := self pharoFilesOpener.

	filesOpener setInformAboutReadOnlyChanges.
	filesOpener changesFileIfNone: [  ].
	
	self assert: self errorMessages size = 1.
	self assert: (self errorMessages includes: self pharoFilesOpener cannotWriteToChangesFileMessage)
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02hWhenInformAbountReadOnlyChangesIsNotSetDoesNotInformErrors [
	| filesOpener |
	
	self simulateReadableOnly: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	filesOpener := self pharoFilesOpener.
	
	filesOpener unsetInformAboutReadOnlyChanges.
	filesOpener changesFileIfNone: [  ].
	
	self assert: self errorMessages isEmpty
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02iWhenTheChangesFileHasBadContentsInformsChangesFileHasBadContents [
	
	| filesOpener |
	self simulateReadableOnlyWithBadContents: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	filesOpener := self pharoFilesOpener.
	filesOpener unsetInformAboutReadOnlyChanges.
	
	filesOpener changesFileIfNone: [  ].
	
	self assert: self errorMessages size = 1.
	self assert: (self errorMessages includes: self pharoFilesOpener changesFileWithBadContentsMessage)
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02jWhenTheChangesFileHasBadContentsDoesNotEvaluateExceptionBlock [
	
	| filesOpener |
	self simulateReadableOnlyWithBadContents: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	filesOpener := self pharoFilesOpener.
	filesOpener unsetInformAboutReadOnlyChanges.
	
	filesOpener changesFileIfNone: [ self fail ].
	
	self assert: true
]

{ #category : #'tests - 02 - changes file is readable only' }
ChangesFileLoaderTest >> test02kWhenTheChangesFileHasBadContentsDoesNotCreateTheDefaultChangesFile [
	
	| filesOpener |
	self simulateReadableOnlyWithBadContents: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	filesOpener := self pharoFilesOpener.
	filesOpener unsetInformAboutReadOnlyChanges.
	
	filesOpener changesFileIfNone: [  ].
	
	self deny: self defaultChangesFile exists
]

{ #category : #'tests - 03 - changes file is not readable' }
ChangesFileLoaderTest >> test03aWhenTheDefaultChangesFileIsWritableReturnsTheWriteStreamForTheDefaultChangesFile [
	| changesFileStream |
	
	self simulateNotReadable: self changesFile.
	self simulateWritable: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self defaultChangesFile writeStream
]

{ #category : #'tests - 03 - changes file is not readable' }
ChangesFileLoaderTest >> test03bWhenTheDefaultChangesFileIsWritableItDoesNotEvaluateTheExceptionBlock [
	
	self simulateNotReadable: self changesFile.
	self simulateWritable: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [ self fail ].
	
	self assert: true
]

{ #category : #'tests - 03 - changes file is not readable' }
ChangesFileLoaderTest >> test03cWhenTheDefaultChangesFileIsReadableReturnsTheReadStreamForTheDefaultChangesFile [
	| changesFileStream |
	
	self simulateNotReadable: self changesFile.
	self simulateReadableOnly: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self defaultChangesFile readStream
]

{ #category : #'tests - 03 - changes file is not readable' }
ChangesFileLoaderTest >> test03dWhenTheDefaultChangesFileIsReadableItDoesNotEvaluateTheExceptionBlock [
	
	self simulateNotReadable: self changesFile.
	self simulateReadableOnly: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [ self fail ].
	
	self assert: true
]

{ #category : #'tests - 03 - changes file is not readable' }
ChangesFileLoaderTest >> test03eWhenTheDefaultChangesFileIsNotReadableTooEvaluatesTheExceptionBlock [
	| changesFileStream |
	
	self simulateNotReadable: self changesFile.
	self simulateNotReadable: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [ 7 ].
	
	self assert: changesFileStream = 7
]

{ #category : #'tests - 03 - changes file is not readable' }
ChangesFileLoaderTest >> test03fWhenTheDefaultChangesFileIsNotReadableTooInformsThatChangesFilesCannotBeLocaled [
	
	self simulateNotReadable: self changesFile.
	self simulateNotReadable: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: self errorMessages size = 1.
	self assert: (self errorMessages includes: self pharoFilesOpener cannotLocateChangesFileMessage)
]

{ #category : #'tests - 03 - changes file is not readable' }
ChangesFileLoaderTest >> test03gWhenTheDefaultChangesFileDoesNotExistEvaluatesTheExceptionBlock [
	| changesFileStream |
	
	self simulateNotReadable: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [ 7 ].
	
	self assert: changesFileStream = 7
]

{ #category : #'tests - 03 - changes file is not readable' }
ChangesFileLoaderTest >> test03hWhenTheDefaultChangesFileDoesNotExistInformsThatChangesFilesCannotBeLocaled [
	
	self simulateNotReadable: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: self errorMessages size = 1.
	self assert: (self errorMessages includes: self pharoFilesOpener cannotLocateChangesFileMessage)
]

{ #category : #'tests - 03 - changes file is not readable' }
ChangesFileLoaderTest >> test03iWhenTheDefaultChangesFileDoesNotExistDoesNotCreateIt [
	
	self simulateNotReadable: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self deny: self defaultChangesFile exists
]

{ #category : #'tests - 04 - changes file does not exist' }
ChangesFileLoaderTest >> test04aDoesNotCreateTheChangesFile [
	
	self simulateDoesNotExist: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self deny: self changesFile exists
]

{ #category : #'tests - 04 - changes file does not exist' }
ChangesFileLoaderTest >> test04bWhenTheDefaultChangesFileIsWritableReturnsTheWriteStreamForTheDefaultChangesFile [
	| changesFileStream |
	
	self simulateDoesNotExist: self changesFile.
	self simulateWritable: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self defaultChangesFile writeStream.
]

{ #category : #'tests - 04 - changes file does not exist' }
ChangesFileLoaderTest >> test04cWhenTheDefaultChangesFileIsReadableOnlyReturnsTheReadStreamForTheDefaultChangesFile [
	| changesFileStream |
	
	self simulateDoesNotExist: self changesFile.
	self simulateReadableOnly: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: changesFileStream = self defaultChangesFile readStream.
]

{ #category : #'tests - 04 - changes file does not exist' }
ChangesFileLoaderTest >> test04dWhenTheDefaultChangesFileIsNotReadableEvaluatesTheExceptionBlock [
	| changesFileStream |
	
	self simulateDoesNotExist: self changesFile.
	self simulateNotReadable: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [ 7 ].
	
	self assert: changesFileStream = 7
]

{ #category : #'tests - 04 - changes file does not exist' }
ChangesFileLoaderTest >> test04eWhenTheDefaultChangesFileIsNotReadableTooInformsThatChangesFilesCannotBeLocaled [
	
	self simulateDoesNotExist: self changesFile.
	self simulateNotReadable: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: self errorMessages size = 1.
	self assert: (self errorMessages includes: self pharoFilesOpener cannotLocateChangesFileMessage)
]

{ #category : #'tests - 04 - changes file does not exist' }
ChangesFileLoaderTest >> test04fWhenTheDefaultChangesFileDoesNotExistTooEvaluatesTheExceptionBlock [
	| changesFileStream |
	
	self simulateDoesNotExist: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	changesFileStream := self pharoFilesOpener changesFileIfNone: [ 7 ].
	
	self assert: changesFileStream = 7
]

{ #category : #'tests - 04 - changes file does not exist' }
ChangesFileLoaderTest >> test04gWhenTheDefaultChangesFileDoesNotExistTooInformsThatChangesFilesCannotBeLocaled [
	
	self simulateDoesNotExist: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [  ].
	
	self assert: self errorMessages size = 1.
	self assert: (self errorMessages includes: self pharoFilesOpener cannotLocateChangesFileMessage)
]

{ #category : #'tests - 04 - changes file does not exist' }
ChangesFileLoaderTest >> test04hWhenTheDefaultChangesFileDoesNotExistTooDoesNotCreateTheDefaultChangesFile [
	
	self simulateDoesNotExist: self changesFile.
	self simulateDoesNotExist: self defaultChangesFile.
	
	self pharoFilesOpener changesFileIfNone: [ ].
	
	self deny: self defaultChangesFile exists
]

{ #category : #'test objects' }
ChangesFileLoaderTest >> validChangesFileContents [

	^ ''
]
