Extension { #name : #FAMIXContainerEntity }

{ #category : #'*Famix-Ejb' }
FAMIXContainerEntity >> dottedNotation [
	^ self mooseName ifNotNil: [ '.' join: (self mooseName substrings: '::') ]
]

{ #category : #'*Famix-Ejb' }
FAMIXContainerEntity >> relatedEJBs [
	<MSEProperty: #relatedEJBs type: #FAMIXEJBEntity opposite: #userClasses>
	<multivalued>
	<derived>
	<MSEComment: 'Java EJBs used in this container module, if any.'>
	^ self privateState attributeAt: #relatedEJBs ifAbsentPut: [ FMMultivalueLink on: self opposite: #source: ]
]

{ #category : #'*Famix-Ejb' }
FAMIXContainerEntity >> relatedEJBs: aCollectionOfFamixContainers [
	self relatedEJBs value: aCollectionOfFamixContainers 
]

{ #category : #'*Famix-Ejb' }
FAMIXContainerEntity >> relatedEJBsEntities [
	^ (self relatedEJBs collect: #to) asSet
]
