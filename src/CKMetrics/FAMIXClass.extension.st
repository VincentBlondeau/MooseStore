Extension { #name : #FAMIXClass }

{ #category : #'*CKMetrics-Core' }
FAMIXClass >> allInheritedMethods [
	"Retrieves a set with all methods inherited from superclasses of a class"

	| inheritedMethods |
	inheritedMethods := Set new.
	
	self superclassesDo: [ :eachSuper | 
			eachSuper	
				methodsDo: [ :method | 
					method isPublic ifTrue: [ inheritedMethods add: method ] ].
				
			eachSuper allInheritedMethods union: inheritedMethods ].
	
	^ inheritedMethods
]

{ #category : #'*CKMetrics-Core' }
FAMIXClass >> couplingBetweenClasses [
	<MSEProperty: #couplingBetweenClasses type: #Number>
	<MSEComment: 'Computes a number of coupled classes without inheritance and without stubs'>
	
	| assocClasses structuralClasses coupledClasses exceptions |
	
	assocClasses := self queryAllOutgoingAssociations 
		withoutSelfLoops atTypeScope asSet.
	
	"return {each}, parameters and local variables of methods and attributes of classes"
	structuralClasses := (self methods flatCollect: [ :each | {each}, each parameters, each localVariables]) asOrderedCollection, self attributes 
		collect: #declaredType thenSelect: [ :each | each notNil and: [each isClass]].
	
	"exceptions"
	exceptions := (self methods flatCollectAsSet: [ :each | 
		each caughtExceptions, each declaredExceptions, each thrownExceptions]) collect: #exceptionClass.
	
	"removing inheritance. TODO check StubMethodContainer"
	coupledClasses := (assocClasses, structuralClasses, exceptions)
		reject: [ :each | (self superclassHierarchy includes: each) or: [each name matches: 'StubMethodContainer']].

	^ coupledClasses size
]

{ #category : #'*CKMetrics-Core' }
FAMIXClass >> lackOfCohesionInMethods [
	"Evaluates the number related to lack of cohesion of the relation between methods of a class"

	<MSEProperty: #lackOfCohesionInMethods type: #Number>
	<MSEComment: 'Lack of Cohesion in Methods'>

	
	| p pMethods pMethodsTemp attributesUsedByM1 attributesUsedByM2 |
		
	p := 0.
	
	pMethods := (self methods select: [ :each | each isPublic and: [(each isStub not) and: [each isConstructor not]]]) asSet.
	
	pMethodsTemp := Set newFrom: pMethods.

	pMethodsTemp do: [ :eachMethod | 
			pMethods remove: eachMethod.
			attributesUsedByM1 := eachMethod queryOutgoingAccesses opposites withinMyClass asSet.
			pMethods do: [ :each | 
				attributesUsedByM2 := each queryOutgoingAccesses opposites withinMyClass asSet.
				(attributesUsedByM2 intersection: attributesUsedByM1) isEmpty
					ifTrue: [ p := p + 1 ]]].
	^ p
]

{ #category : #'*CKMetrics-Core' }
FAMIXClass >> responseForClass [
	"Computes a number of methods possibly invoked in response a message sent to an object"

	<MSEProperty: #responseForClass type: #Number>
	<MSEComment: 'Response For a Class'>
	
	| nMethodsClass nMethodsSuperClass nClassInvokedMethods |
	
	nMethodsClass := (self methods reject: [ :each | each isStub or: each isConstructor]) asSet.

	nClassInvokedMethods := self queryAllOutgoingInvocations opposites.
	"nMethodsSuperClass := self allInheritedMethods."
	
	^ (( nMethodsClass union: nClassInvokedMethods) "union: nMethodsSuperClass" ) size
]
