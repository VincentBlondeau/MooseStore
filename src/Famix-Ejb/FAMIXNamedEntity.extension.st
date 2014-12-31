Extension { #name : #FAMIXNamedEntity }

{ #category : #'*Famix-Ejb' }
FAMIXNamedEntity >> userClasses [
	<MSEProperty: #userClasses type: #FAMIXContainerEntity opposite: #relatedEJBs>
	<multivalued>
	<derived>
	<MSEComment: 'The classes using this EJB'>
	^ self privateState cacheAt: #userClasses ifAbsentPut: [ FMMultivalueLink on: self opposite: #target: ]
]

{ #category : #'*Famix-Ejb' }
FAMIXNamedEntity >> userClasses: aCollectionOfFamixContainers [
	self userClasses value: aCollectionOfFamixContainers 
]
