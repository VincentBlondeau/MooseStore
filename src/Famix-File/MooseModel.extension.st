Extension { #name : #MooseModel }

{ #category : #'*Famix-File' }
MooseModel >> addRootDirectory: aFAMIXFolder [
	self rootDirectories add: aFAMIXFolder
]

{ #category : #'*Famix-File' }
MooseModel >> rootDirectories [
	<MSEProperty: #rootDirectories type: #FAMIXFolder opposite: #containerModel>
	<multivalued>
	<derived>
	<MSEComment: 'The file references which one is referenced by FAMIXFile or FAMIXFolder as their root directory'>
	<package: #File>
	^ self privateState attributeAt: #rootDirectories ifAbsentPut: [ FAMIXFolderGroup new ]
]

{ #category : #'*Famix-File' }
MooseModel >> rootDirectories: aCollectionOfFAMIXFolders [
	self privateState attributeAt: #rootDirectory put: aCollectionOfFAMIXFolders
]
