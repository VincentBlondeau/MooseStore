Class {
	#name : #MooseModelDescriptionTest,
	#superclass : #TestCase,
	#category : #'Moose-Tests-Core'
}

{ #category : #tests }
MooseModelDescriptionTest >> testAsMooseDescription [	
	self assert: (FAMIXClass asMooseDescription isKindOf: FM3MetaDescription).
]

{ #category : #tests }
MooseModelDescriptionTest >> testAsMooseDescriptionAttributes [
	| fc ft |
	fc := FAMIXClass asMooseDescription.
	ft := FAMIXType asMooseDescription.
	self assert: (ft attributes anySatisfy: [:each | each name = #methods]).
	self assert: (fc allAttributes anySatisfy: [:each | each name = #methods])
]

{ #category : #tests }
MooseModelDescriptionTest >> testAsMooseDescriptionWithResetting [	
	self assert: (FAMIXClass asMooseDescription isKindOf: FM3MetaDescription).
	MooseModel resetMeta.
	self assert: (FAMIXClass asMooseDescription isKindOf: FM3MetaDescription).
]
