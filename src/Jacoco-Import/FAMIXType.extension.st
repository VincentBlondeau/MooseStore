Extension { #name : #FAMIXType }

{ #category : #'*Jacoco-Import' }
FAMIXType >> coverMethods [
	<MSEProperty: #coverMethods type: #FAMIXMethod opposite: #coveredByTestClasses>
	<multivalued>
	<MSEComment: 'Methods that are covered by this class'>
	^ self privateState
		attributeAt: #coverMethods
		ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #coveredByTestClasses ]
]

{ #category : #'*Jacoco-Import' }
FAMIXType >> coverMethods: aCollection [
	self coverMethods values: aCollection
]

{ #category : #'*Jacoco-Import' }
FAMIXType >> isCoveringMethods [
	<MSEProperty: #isCoveringMethods type: #Boolean>
	<multivalued>
	<MSEComment: 'True is the class covers methods'>
	^ self coverMethods isNotEmpty
]
