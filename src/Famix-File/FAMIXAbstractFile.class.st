"
The abstract file system class. It is subclassed by File and Folder. It uses the file references has references to the files and directories.
"
Class {
	#name : #FAMIXAbstractFile,
	#superclass : #FAMIXEntity,
	#instVars : [
		'belongsTo',
		'entities',
		'fileReference'
	],
	#category : #'Famix-File'
}

{ #category : #'initialize-release' }
FAMIXAbstractFile class >> annotation [
	<MSEClass: #AbstractFile super: #FAMIXEntity>
	<package: #FILE>
]

{ #category : #'instance creation' }
FAMIXAbstractFile class >> fromReference: aFileReference filedIn: aFolder [
	^ self new
		fileReference: aFileReference;
		belongsTo: aFolder;
		yourself
]

{ #category : #'instance creation' }
FAMIXAbstractFile class >> named: aName filedIn: aFolder [
	self deprecated: 'Use fromReference:filedIn: instead'.
	^ self fromReference: aName asFileReference filedIn: aFolder
]

{ #category : #accessing }
FAMIXAbstractFile >> absoluteFileReference [

	^ self rootContainerFolder  resolveReference: (self fileReference ifNil: [ ^ nil ])
]

{ #category : #accessing }
FAMIXAbstractFile >> addEntity: famixEntity [
	self entities add: famixEntity
]

{ #category : #accessing }
FAMIXAbstractFile >> belongsTo [
	^ self subclassResponsibility
]

{ #category : #accessing }
FAMIXAbstractFile >> belongsTo: anObject [
	self subclassResponsibility
]

{ #category : #accessing }
FAMIXAbstractFile >> entities [
	"a file such as a C file or a Java file contain one or more conceptual entities.
	For a C file the entity will be an implementation entity containing all the C functions.
	For a Java file, the entities are classes defined in a file"
	
	^ entities 
]

{ #category : #accessing }
FAMIXAbstractFile >> fileReference [ 
	<MSEProperty: #fileReference type: #Object>
	<MSEComment: 'File reference of this file'>
	^ fileReference 
]

{ #category : #accessing }
FAMIXAbstractFile >> fileReference: aFileReference [
	fileReference := aFileReference
]

{ #category : #accessing }
FAMIXAbstractFile >> fullName [ 
	<MSEProperty: #fullName type: #String>
	<MSEComment: 'Full reference name. Can be used to rebuild the file reference.'>
	"It is a relative path name"
	^ self fileReference relativePathString
]

{ #category : #accessing }
FAMIXAbstractFile >> fullName: aString [
	self fileReference: aString asFileReference
]

{ #category : #testing }
FAMIXAbstractFile >> hasUniqueMooseNameInModel [
	" all subclasses should call the method: 'resetMooseName' if a change causes the moosename to change "
	^true
]

{ #category : #testing }
FAMIXAbstractFile >> ifFolder: aBlock [
	^ self isFolder ifTrue: [ aBlock value ]
]

{ #category : #testing }
FAMIXAbstractFile >> ifFolder: aBlock1 ifNotFolder: aBlock2 [
	^ self isFolder ifTrue: [ aBlock1 value ] ifFalse: [ aBlock2 value ]
]

{ #category : #testing }
FAMIXAbstractFile >> ifNotFolder: aBlock [
	^ self isFolder ifFalse: [ aBlock value ]
]

{ #category : #testing }
FAMIXAbstractFile >> ifNotFolder: aBlock1 ifFolder: aBlock2 [
	^ self isFolder ifFalse: [ aBlock1 value ] ifTrue: [ aBlock2 value ]
]

{ #category : #initialization }
FAMIXAbstractFile >> initialize [
	super initialize.
	entities := OrderedCollection new.
]

{ #category : #testing }
FAMIXAbstractFile >> isFolder [
	^ true
]

{ #category : #printing }
FAMIXAbstractFile >> mooseNameOn: aStream [
	| parent |
	parent := self belongsTo.
	parent
		ifNotNil: [ 
			parent mooseNameOn: aStream.
			aStream nextPutAll: '/' ].
	self name ifNotNil: [ aStream nextPutAll: self name ]
]

{ #category : #accessing }
FAMIXAbstractFile >> name [
	<MSEProperty: #name type: #String>
	<MSEComment: 'Basic name of the entity, not full reference.'>
	^ self fileReference basename
]

{ #category : #accessing }
FAMIXAbstractFile >> rootContainerFolder [
	"Contains a file reference and not a string."

	<MSEProperty: #rootContainerFolder type: #FAMIXFolder>
	<MSEComment: 'The root container'>
	^ self privateState
		attributeAt: #rootContainerFolder
		ifAbsent: [ FAMIXRootFolder fromReference: '' asFileReference filedIn: nil ]
]

{ #category : #accessing }
FAMIXAbstractFile >> rootContainerFolder: aFamixFolder [
	"Contains a file reference and not a string."
	^ self privateState attributeAt: #rootContainerFolder put: aFamixFolder
]
