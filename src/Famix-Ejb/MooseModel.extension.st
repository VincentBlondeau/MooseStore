Extension { #name : #MooseModel }

{ #category : #'*Famix-Ejb' }
MooseModel >> removeEJBEntities [
	self silentlyRemoveAll: (self allWithType: FAMIXEJBEntity)
]
