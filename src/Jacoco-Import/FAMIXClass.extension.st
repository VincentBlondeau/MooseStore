Extension { #name : #FAMIXClass }

{ #category : #'*Jacoco-Import' }
FAMIXClass >> coverMethods [
	<MSEProperty: #coverMethods type: #FAMIXMethod opposite: #coveredByTestClasses>
	<multivalued>
	<MSEComment: 'Methods that are covered by this class'>
	^ self privateState
		attributeAt: #coverMethods
		ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #coveredByTestClasses ]
]

{ #category : #'*Jacoco-Import' }
FAMIXClass >> coverMethods: aCollection [
	self coverMethods values: aCollection
]
