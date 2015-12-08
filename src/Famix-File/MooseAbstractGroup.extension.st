Extension { #name : #MooseAbstractGroup }

{ #category : #'*Famix-File' }
MooseAbstractGroup >> allFiles [
	<navigation: 'All files'>
	^ (self allWithType: FAMIXFile) sorted: [:c1 :c2 | c1 name < c2 name]; yourself 
]

{ #category : #'*Famix-File' }
MooseAbstractGroup >> allFolders [
	
	<navigation: 'All folders'>
	^ (self allWithType: FAMIXFolder)  sorted: [:c1 :c2 | c1 name < c2 name]; yourself
]
