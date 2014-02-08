"
My instances provide a way to get the stream for the changes file, throught the #changesFileIfNone: message.
"
Class {
	#name : #ChangesFileLoader,
	#superclass : #Object,
	#instVars : [
		'shouldInformAboutReadOnlyChanges',
		'smalltalkImage',
		'fileSystem',
		'uiManager'
	],
	#classVars : [
		'Default'
	],
	#category : #'Files-System'
}

{ #category : #'instance creation' }
ChangesFileLoader class >> default [

	^ self smalltalkImage: Smalltalk
		    fileSystem: FileSystem disk
		    uiManager: self
]

{ #category : #'instance creation' }
ChangesFileLoader class >> smalltalkImage: aSmalltalkImage fileSystem: aFileSystem uiManager: anUIManager [

	^ self new
		    initializeSmalltalkImage: aSmalltalkImage
		    fileSystem: aFileSystem
		    uiManager: anUIManager
]

{ #category : #messages }
ChangesFileLoader >> cannotLocateChangesFileMessage [

	^ 'Pharo cannot locate the changes file named ', self changesName, '.

Please check that the file is named properly and is in the
same directory as this image.'
]

{ #category : #messages }
ChangesFileLoader >> cannotWriteToChangesFileMessage [

	^ 'Pharo cannot write to the changes file named ', self changesName, '.

Please check that you have write permission for this file.

You won''t be able to save this image correctly until you fix this.'
]

{ #category : #public }
ChangesFileLoader >> changesFileIfNone: exceptionBlock [
	| changes |
	
	changes := self changesFileIfReadOnly: [ self handleReadOnlyChangesFile ]
				       				 ifNone: [ self handleMissingChangesFile.
											   ^ exceptionBlock value ].

	(self hasBadContents: changes)
		ifTrue: [ self handleChangesFileWithBadContents ].
		
	^ changes
]

{ #category : #'open changes' }
ChangesFileLoader >> changesFileIfReadOnly: readOnlyBlock ifNone: noneBlock [

	^ self filesOpener streamifReadOnly: readOnlyBlock
					     ifNone: noneBlock
]

{ #category : #messages }
ChangesFileLoader >> changesFileWithBadContentsMessage [

	^ 'the changes file named ', self changesName, '
has been injured by an unpacking utility.  Crs were changed to CrLfs.
Please set the preferences in your decompressing program to 
"do not convert text files" and unpack the system again.'
]

{ #category : #'image, changes names' }
ChangesFileLoader >> changesName [

	^ smalltalkImage changesName
]

{ #category : #'image, changes names' }
ChangesFileLoader >> currentChangesFile [

	^ fileSystem referenceTo: self changesName
]

{ #category : #'image, changes names' }
ChangesFileLoader >> defaultChangesFile [

	^ fileSystem workingDirectory / self currentChangesFile basename
]

{ #category : #'open changes' }
ChangesFileLoader >> filesOpener [

	^ FileOpenerPrioritizedByMode
		file: self currentChangesFile
		defaultFile: self defaultChangesFile.
]

{ #category : #'error handing' }
ChangesFileLoader >> handleChangesFileWithBadContents [

	self inform: self changesFileWithBadContentsMessage
]

{ #category : #'error handing' }
ChangesFileLoader >> handleMissingChangesFile [

	self inform: self cannotLocateChangesFileMessage.
	
	^ nil
]

{ #category : #'error handing' }
ChangesFileLoader >> handleReadOnlyChangesFile [

	^ self shouldInformAboutReadOnlyChanges
		ifTrue: [ self inform: self cannotWriteToChangesFileMessage ]
]

{ #category : #testing }
ChangesFileLoader >> hasBadContents: aFileStream [

	^ (aFileStream next: 200)
		includesSubstring: String crlf
]

{ #category : #'user interaction' }
ChangesFileLoader >> inform: aMessage [

	uiManager inform: aMessage
]

{ #category : #'initialize-release' }
ChangesFileLoader >> initializeSmalltalkImage: aSmalltalkImage fileSystem: aFileSystem uiManager: anUIManager [

	smalltalkImage := aSmalltalkImage.
	fileSystem := aFileSystem.
	uiManager := anUIManager
]

{ #category : #public }
ChangesFileLoader >> setInformAboutReadOnlyChanges [

	"Make sure the user is informed when the .changes file can not be written to."
	shouldInformAboutReadOnlyChanges := true
]

{ #category : #testing }
ChangesFileLoader >> shouldInformAboutReadOnlyChanges [

	"Answer true if and only if the user must be informed when the .changes file can not be written to."
	^ shouldInformAboutReadOnlyChanges
		ifNil: [ shouldInformAboutReadOnlyChanges := true ]
]

{ #category : #public }
ChangesFileLoader >> unsetInformAboutReadOnlyChanges [

	"Make sure the user is *not* informed when the .changes file can not be written to."
	shouldInformAboutReadOnlyChanges := false
]
