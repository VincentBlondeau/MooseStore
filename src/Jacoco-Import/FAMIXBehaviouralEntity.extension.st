Extension { #name : #FAMIXBehaviouralEntity }

{ #category : #'*Jacoco-Import' }
FAMIXBehaviouralEntity >> numberOfArgsFromSignature [
	<MSEProperty: #numberOfArgsFromSignature type: #Number>
	<MSEComment: 'numberOfArgsFromSignature'>
	
	| cut args |
	cut := self signature subStrings: '('.
	args := cut second allButLast subStrings: ','.
	"Just  good to have the number of args. 
	Ex :  'createPersistenceXml(Map<String,String>)'
	"
	
	^ args size - (cut second occurrencesOf: $<)
]
