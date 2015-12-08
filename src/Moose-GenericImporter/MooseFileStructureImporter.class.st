"
A MooseFileStructureImporter is a importer of file system to a Moose model. That can be used by the 


Instance Variables
	folders:		a collection of string or file reference
	rootDirectory:	a FileReference

folders
	- all the folders that will be imported in the model

rootDirectory
	- private variable that represent the current root directory of the folders and files
"
Class {
	#name : #MooseFileStructureImporter,
	#superclass : #MooseAbstractImporter,
	#instVars : [
		'folders',
		'rootDirectory',
		'parentFolder'
	],
	#category : #'Moose-GenericImporter'
}

{ #category : #running }
MooseFileStructureImporter class >> runOn: aModel withFolders: aCollectionOfFolders [
	^ (self model: aModel)
		folders: aCollectionOfFolders;
		run
]

{ #category : #importing }
MooseFileStructureImporter >> basicRun [
	self folders do: [ :aStringOraFileReference | self importRootFolder: aStringOraFileReference ].
	self model sourceLanguage: FAMIXUnknownSourceLanguage new
]

{ #category : #'importing - depecated' }
MooseFileStructureImporter >> completeImport: aCollectionOfFolders [
	self deprecated: 'Use class side method or run instead' on: '31 January 2015' in: 'Moose-GenericImporter'.
	^ self
		folders: aCollectionOfFolders;
		run
]

{ #category : #accessing }
MooseFileStructureImporter >> folders [
	^ folders
]

{ #category : #accessing }
MooseFileStructureImporter >> folders: anObject [
	folders := anObject
]

{ #category : #importing }
MooseFileStructureImporter >> importContentsFromFolder: aFileReferenceToAFolder filedIn: aContainerFolder [
	| absoluteFolder |
	absoluteFolder := self makeAbsolute: aFileReferenceToAFolder.
	absoluteFolder files do: [ :each | self importFile: each filedIn: aContainerFolder ].
	absoluteFolder directories do: [ :each | self importFolder: each filedIn: aContainerFolder ]
]

{ #category : #importing }
MooseFileStructureImporter >> importFile: anAbsoluteFileReference filedIn: aContainerFolder [
	| file |
	file := FAMIXFile fromReference: (self makeRelative: anAbsoluteFileReference) filedIn: aContainerFolder.
	file rootContainerFolder: rootDirectory.
	self model add: file
]

{ #category : #importing }
MooseFileStructureImporter >> importFolder: anAbsoluteFileReference filedIn: aContainerFolder [
	| folder |
	folder := FAMIXFolder fromReference: (self makeRelative: anAbsoluteFileReference) filedIn: aContainerFolder.
	folder rootContainerFolder: rootDirectory.
	self model add: folder.
	self importContentsFromFolder: anAbsoluteFileReference filedIn: folder
]

{ #category : #importing }
MooseFileStructureImporter >> importRootFolder: aStringOraFileReference [
	| aFileReference |
	aFileReference := aStringOraFileReference asFileReference.
	rootDirectory := FAMIXRootFolder fromReference: aFileReference filedIn: nil.
	parentFolder := aFileReference parent.
	self importFolder: (self makeAbsolute: aFileReference) filedIn: nil.
	self model addRootDirectory: rootDirectory
]

{ #category : #private }
MooseFileStructureImporter >> makeAbsolute: aFileReference [
	^ parentFolder resolveReference: aFileReference
]

{ #category : #private }
MooseFileStructureImporter >> makeRelative: aFileReference [
	^ (aFileReference relativeTo: parentFolder) asFileReference
]
