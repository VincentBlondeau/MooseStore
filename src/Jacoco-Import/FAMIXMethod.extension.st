Extension { #name : #FAMIXMethod }

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> addCoveredByTestClass: aFAMIXClass [ 
	self coveredByTestClasses add: aFAMIXClass 
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> allIncomingInvocations [
	^ self deepCollect: [ :entity | entity incomingInvocations collect: [ :inv | inv from ] ]
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> allOutgoingInvocations [
	^ self deepCollect: [ :entity | entity outgoingInvocations collect: [ :inv | inv to ] ]
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> callingCoveredTestsClasses [
	^ (self
		deepCollect: [ :entity | 
			entity incomingInvocations
				collect: [ :inv | 
					inv from	"isStub
				ifFalse: [ inv from ]
				ifTrue: [ nil ] " ]
				thenSelect: #isNotNil ]) select: #isCoveringMethods
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> callingTestsClasses [
	^ (self
		deepCollect: [ :entity | 
			entity incomingInvocations
				collect: [ :inv | 
					inv from	"isStub
				ifFalse: [ inv from ]
				ifTrue: [ nil ] " ]
				thenSelect: #isNotNil ]) select: #isTest
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> coveredByTestClasses [
	<MSEProperty: #coveredByTestClasses type: #FAMIXClass opposite: #coverMethods>
	<multivalued>
	<MSEComment: 'Classes whose tests cover this method'>
	^ self privateState
		attributeAt: #coveredByTestClasses
		ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #coverMethods ]
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> coveredByTestClassesWithoutSomeClasses [

	^ self coveredByTestClasses reject: [ :c | c mooseName = 'net::atos::wlp::cedicam::AbstractTest' ]
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> isCallingCoveredTestsClasses [
	^ (self
		deepCollect: [ :entity | 
			entity incomingInvocations
				collect: [ :inv | 
					inv from	"isStub
				ifFalse: [ inv from ]
				ifTrue: [ nil ] " ]
				thenSelect: #isNotNil ]) anySatisfy: #isCoveringMethods
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> isCallingTestsClasses [
	^ (self
		deepCollect: [ :entity | 
			entity incomingInvocations
				collect: [ :inv | 
					inv from	"isStub
				ifFalse: [ inv from ]
				ifTrue: [ nil ] " ]
				thenSelect: #isNotNil ]) anySatisfy: #isTest
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> isCoveredByTestClasses [
	<MSEProperty: #isCoveredByTestClasses type: #Boolean>
	<multivalued>
	<derived>
	<MSEComment: 'If the method is covered by tests'>
	^ self coveredByTestClasses isNotEmpty
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> isCoveringMethods [
	^ self belongsTo isCoveringMethods
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> isIgnored [
	<MSEProperty: #isIgnored type: #Boolean>
	<multivalued>
	<derived>
	<MSEComment: 'If the method is a test'>
	^ self privateState
		attributeAt: #isIgnored
		ifAbsentPut: [ self annotationInstances contains: [ :instance | instance annotationType name = 'Ignore' ] ]
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> isNotIgnoredTest [
	<MSEProperty: #isNotIgnoredTest type: #Boolean>
	<multivalued>
	<derived>
	<MSEComment: 'If the method is a not ignored test'>
	^ self isTest and: [ self isIgnored not ]
]

{ #category : #'*Jacoco-Import' }
FAMIXMethod >> isTest [
	<MSEProperty: #isTest type: #Boolean>
	<multivalued>
	<derived>
	<MSEComment: 'If the method is a test'>
	^ self privateState
		attributeAt: #isTest
		ifAbsentPut: [ self annotationInstances contains: [ :instance | instance annotationType name = 'Test' ] ]
]
