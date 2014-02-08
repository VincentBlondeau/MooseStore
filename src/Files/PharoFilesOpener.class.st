"
My role is to open the .sources and .changes files. My only public methods are in the 'public' protocol. The most important method is #checkAndOpenSourcesAndChanges.
"
Class {
	#name : #PharoFilesOpener,
	#superclass : #Object,
	#instVars : [
		'shouldInformAboutReadOnlyChanges',
		'changesFileLoader'
	],
	#classVars : [
		'Default'
	],
	#category : #'Files-System'
}

{ #category : #singleton }
PharoFilesOpener class >> default [

	^ Default ifNil: [ Default := self withChangesFileLoader ]
]

{ #category : #'class initialization' }
PharoFilesOpener class >> initialize [
	super initialize.
	self reset
]

{ #category : #singleton }
PharoFilesOpener class >> reset [
	Default := nil
]

{ #category : #'instance creation' }
PharoFilesOpener class >> withChangesFileLoader [

	^ self new
		    initializeChangesFileLoader: ChangesFileLoader default
]

{ #category : #messages }
PharoFilesOpener >> cannotLocateMsg [
	^ 'Pharo cannot locate &fileRef.

Please check that the file is named properly and is in the
same directory as this image.'
]

{ #category : #public }
PharoFilesOpener >> changesFileOrNil [
	
	^ changesFileLoader changesFileIfNone: [  nil ]
]

{ #category : #delegated }
PharoFilesOpener >> changesName [
	^ Smalltalk changesName
]

{ #category : #helper }
PharoFilesOpener >> ignoreIfFail: aBlock [
	^ [ aBlock value ] ifError: [  ]
]

{ #category : #'user interaction' }
PharoFilesOpener >> inform: msg withRef: fileRef [
	self inform: (msg copyReplaceAll: '&fileRef' with: fileRef)
]

{ #category : #'user interaction' }
PharoFilesOpener >> inform: msg withSourceRef: fileRef [
	self inform: msg withRef: 'the sources file named ' , fileRef
]

{ #category : #'open sources' }
PharoFilesOpener >> informCannotLocateSources [
	| msg |
	msg := self cannotLocateMsg.
	Smalltalk os isMacOS
		ifTrue: [ 
			msg := msg
				,
					'
Make sure the sources file is not an Alias.' ].
	self inform: msg withSourceRef: self sourcesName
]

{ #category : #'initialize-release' }
PharoFilesOpener >> initializeChangesFileLoader: aChangesFileLoader [ 
	
	changesFileLoader := aChangesFileLoader
]

{ #category : #delegated }
PharoFilesOpener >> lastImagePath [
	^ Smalltalk lastImagePath
]

{ #category : #'open sources' }
PharoFilesOpener >> openOrDownloadSources [
	| sources |
	(sources := self openSources)
		ifNil: [ 
			[ Smalltalk downloadSources	"this method only exists when Zinc is loaded" ]
				on: MessageNotUnderstood
				do: [ ^ nil ].
			sources := self openSources ].
	^ sources
]

{ #category : #'open sources' }
PharoFilesOpener >> openSources [
	^ self openSources: self sourcesName forImage: self lastImagePath
]

{ #category : #'open sources' }
PharoFilesOpener >> openSources: fullSourcesName forImage: imagePath [
	"We first do a check to see if a compressed version ofthe sources file is present.
Open the .sources file read-only after searching in:
a) the directory where the VM lives
b) the directory where the image came from
c) the DefaultDirectory (which is likely the same as b unless the SecurityManager has changed it).
"

	| sourcesFile sourcesName |
	sourcesFile := fullSourcesName asFileReference.
	sourcesName := sourcesFile basename.
	
	"look for the sources file or an alias to it in the VM's directory"
	OSPlatform current potentialLocationsOfSourcesFile
		do: [ :dir | 
			(sourcesFile := dir / sourcesName) exists
				ifTrue: [ sourcesFile readStream ifNotNilDo: [ :stream | ^ stream ] ] ].
			
	"look for the sources file or an alias to it in the image directory"
	(sourcesFile := imagePath asFileReference parent / sourcesName) exists
		ifTrue: [ ^ sourcesFile readStream ifNotNilDo: [ :stream | ^ stream ] ].
		
	"look for the sources in the current directory"
	(sourcesFile := sourcesName asFileReference) exists
		ifTrue: [ ^ sourcesFile readStream ifNotNilDo: [ :stream | ^ stream ] ].
	^ nil
]

{ #category : #public }
PharoFilesOpener >> setInformAboutReadOnlyChanges [
	"Make sure the user is informed when the .changes file can not be written to."
	shouldInformAboutReadOnlyChanges := true
]

{ #category : #public }
PharoFilesOpener >> shouldInformAboutReadOnlyChanges [
	"Answer true if and only if the user must be informed when the .changes file can not be written to."
	^ shouldInformAboutReadOnlyChanges ifNil: [ shouldInformAboutReadOnlyChanges := true ]
]

{ #category : #public }
PharoFilesOpener >> sourcesFileOrNil [
	| sources |
	sources := self openOrDownloadSources.
	^ (sources isNil or: [ sources atEnd ])
		ifTrue: [ 
			self informCannotLocateSources.
			nil ]
		ifFalse: [ sources ]
]

{ #category : #delegated }
PharoFilesOpener >> sourcesName [
	^ Smalltalk sourcesName
]

{ #category : #public }
PharoFilesOpener >> unsetInformAboutReadOnlyChanges [
	"Make sure the user is *not* informed when the .changes file can not be written to."
	shouldInformAboutReadOnlyChanges := false
]
