Extension { #name : #MooseModel }

{ #category : #'*Famix-Extensions' }
MooseModel >> ensureClassesAndNamespaces [
	<menuItem: 'Ensure Classes and Namespaces' category: 'Utilities'>

	self allMethods do: [ :each |
		each parentType isNil ifTrue: [
			each parentType: self unknownFAMIXClass ] ].
	self allClasses do: [ :each |
		each container ifNil: [
			each container: self unknownFAMIXNamespace ] ]
]

{ #category : #'*Famix-Extensions' }
MooseModel >> isSmalltalk [
	^ self sourceLanguage isSmalltalk
]

{ #category : #'*Famix-Extensions' }
MooseModel >> numberOfPackages [
	<MSEProperty: #numberOfPackages type: #Number>
	<MSEComment: 'Total number of packages'>

	^ self  isSmalltalk 
			ifTrue: [self privateState propertyAt: #numberOfPackages ifAbsentPut: [self allPackages size].]
			ifFalse: [self privateState propertyAt: #numberOfPackages ifAbsentPut: [self allNamespaces size].].
]

{ #category : #'*Famix-Extensions' }
MooseModel >> overviewPyramidMetrics [

	^ self privateState propertyAt: #overviewPyramidMetrics ifAbsentPut: [OverviewPyramidMetrics on: self]
]

{ #category : #'*Famix-Extensions' }
MooseModel >> unknownFAMIXClass [
	^ self allClasses 
		detect: [:each | each mooseName = #'unknownNamespace::UnknownClass'] 
		ifNone: [
			self add: (
				FAMIXClass new 
					name: 'UnknownClass'; 
					container: self unknownFAMIXNamespace; 
					isStub: true; 
					yourself)
		]
]

{ #category : #'*Famix-Extensions' }
MooseModel >> unknownFAMIXNamespace [
	^ self allNamespaces 
		detect: [:each | each mooseName = #'unknownNamespace'] 
		ifNone: [
			self add: (
				FAMIXNamespace new 
					name: 'unknownNamespace';
					isStub: true; 
					yourself)
		]
]
