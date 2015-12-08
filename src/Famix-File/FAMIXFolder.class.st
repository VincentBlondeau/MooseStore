"
It represents a folder in the file system. It can contain other files or folders.
"
Class {
	#name : #FAMIXFolder,
	#superclass : #FAMIXAbstractFile,
	#instVars : [
		'files',
		'folders'
	],
	#category : #'Famix-File'
}

{ #category : #'initialize-release' }
FAMIXFolder class >> annotation [
	<MSEClass: #Folder super: #FAMIXAbstractFile>
	<package: #FILE>
]

{ #category : #'add/remove' }
FAMIXFolder >> addFile: aFamixFile [
	self files add: aFamixFile
]

{ #category : #'add/remove' }
FAMIXFolder >> addFiles: famixFiles [
	self files addAll: famixFiles
]

{ #category : #'add/remove' }
FAMIXFolder >> addFolder: aFamixFolder [
	self folders add: aFamixFolder
]

{ #category : #'computed accessing' }
FAMIXFolder >> allRecursiveFiles [
	| result |
	result := MooseGroup withAll: self files withDescription: 'All recursive files in ' , self mooseName.
	^ self folders
		inject: result
		into: [ :res :each | 
			res addAll: each allRecursiveFiles.
			res ]
]

{ #category : #'computed accessing' }
FAMIXFolder >> allRecursiveFolders [
	| result |
	result := MooseGroup withAll: self folders withDescription: 'All recursive folders in ' , self mooseName.
	^ self folders
		inject: result
		into: [ :res :each | 
			res addAll: each allRecursiveFolders.
			res ]
]

{ #category : #accessing }
FAMIXFolder >> belongsTo [
	<MSEProperty: #belongsTo type: #FAMIXFolder opposite: #folders>
	<MSEComment: 'Container of this folder. Is nil if it is the root'>
	^ belongsTo
]

{ #category : #accessing }
FAMIXFolder >> belongsTo: anObject [
	belongsTo := FMMultivalueLink
		on: self
		update: #folders
		from: self belongsTo
		to: anObject.
	self resetMooseName
]

{ #category : #accessing }
FAMIXFolder >> files [
	<MSEProperty: #files type: #FAMIXFile opposite: #belongsTo>
	<multivalued>
	<derived>
	<MSEComment: 'List of the files contained in this folder'>
	^ files
]

{ #category : #accessing }
FAMIXFolder >> files: aCollection [
	files value: aCollection
]

{ #category : #accessing }
FAMIXFolder >> filesGroup [
	<navigation: 'Files Group'>
	^FAMIXFileGroup withAll: self files withDescription: 'Files'
]

{ #category : #accessing }
FAMIXFolder >> folders [
	<MSEProperty: #folders type: #FAMIXFolder opposite: #belongsTo>
	<multivalued>
	<derived>
	<MSEComment: 'List of the folders contained in this folder'>
	^ folders
]

{ #category : #accessing }
FAMIXFolder >> folders: aCollection [
	folders value: aCollection
]

{ #category : #accessing }
FAMIXFolder >> foldersGroup [
	<navigation: 'Folders Group'>
	^ FAMIXFolderGroup withAll: self folders withDescription: 'Folders'
]

{ #category : #initialization }
FAMIXFolder >> initialize [

	super initialize.
	files := FMNullMultivalueLink on: self opposite: #belongsTo: selector: #files.
	folders := FMNullMultivalueLink on: self opposite: #belongsTo: selector: #folders.
]

{ #category : #testing }
FAMIXFolder >> isRoot [
	^self belongsTo isNil
]

{ #category : #properties }
FAMIXFolder >> numberOfEmptyLinesOfText [
	<MSEProperty: #numberOfEmptyLinesOfText type: #Number>
	<MSEComment: 'Number of empty lines of text'>

	^ self lookUpPropertyNamed: #numberOfEmptyLinesOfText computedAs: [ 
		self files, self folders sum: #numberOfEmptyLinesOfText
	]
]

{ #category : #properties }
FAMIXFolder >> numberOfFiles [
	<MSEProperty: #numberOfFiles type: #Number>
	<MSEComment: 'The number of files in a folder'>
	
	^self
		lookUpPropertyNamed: #numberOfFiles
		computedAs: [self files size]
]

{ #category : #properties }
FAMIXFolder >> numberOfFolders [
	<MSEProperty: #numberOfFolders type: #Number>
	<MSEComment: 'The number of folders in a folder'>
	
	^self
		lookUpPropertyNamed: #numberOfFolders
		computedAs: [self folders size]
]

{ #category : #properties }
FAMIXFolder >> numberOfLinesOfText [
	<MSEProperty: #numberOfLinesOfText type: #Number>
	<MSEComment: 'Number of lines of text which are not empty in a folder '>

	^ self 
		lookUpPropertyNamed: #numberOfLinesOfText 
		computedAs: [self totalNumberOfLinesOfText - self numberOfEmptyLinesOfText]
]

{ #category : #properties }
FAMIXFolder >> totalNumberOfLinesOfText [
	<MSEProperty: #totalNumberOfLinesOfText type: #Number>
	<MSEComment: 'Number of lines of text'>

	^self lookUpPropertyNamed: #totalNumberOfLinesOfText computedAs: [
		self files, self folders sum: #totalNumberOfLinesOfText
	]
]

{ #category : #'computed accessing' }
FAMIXFolder >> withAllRecursiveFolders [
	| result |
	result := MooseGroup with: self withDescription: 'All recursive folders in ' , self mooseName.
	result addAll: self folders.
	^ self folders inject: result into: [ :res :each | res addAll: each allRecursiveFolders ]
]
