Extension { #name : #MooseModel }

{ #category : #'*Famix-Ejb' }
MooseModel >> allEJB [
	<navigation: 'All EJB'>
	^ self allWithType: FAMIXEJBEntity
]

{ #category : #'*Famix-Ejb' }
MooseModel >> allEJBReferences [
	<navigation: 'All EJB references'>
	^ self allWithType: FAMIXEJBReference
]

{ #category : #'*Famix-Ejb' }
MooseModel >> removeEJBEntities [
	self silentlyRemoveAll: (self allWithType: FAMIXEJBEntity)
]
