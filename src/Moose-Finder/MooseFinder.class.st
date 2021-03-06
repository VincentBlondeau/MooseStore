"
self new openOn: MooseModel root
"
Class {
	#name : #MooseFinder,
	#superclass : #GLMCompositePresentation,
	#category : #'Moose-Finder'
}

{ #category : #utils }
MooseFinder class >> announcerFor: anObject [
	^ (anObject respondsTo: #announcer) 
		ifTrue: [anObject announcer] 
		ifFalse: [Announcer new]
]

{ #category : #building }
MooseFinder >> compose [
	self pager 
		title: [:each | 'Moose Finder on ', each mooseInterestingEntity mooseDisplayString];
		show: [ :a :each |
			a 	
				title: ((each mooseInterestingEntity mooseDisplayString), ' (', 
							each mooseInterestingEntity class name, ')');
				dynamicActions: [ :list | list entity mooseInterestingEntity mooseFinderActions ].
			each mooseInterestingEntity mooseFinderPresentationsIn: a inContext: self.
			a 
				updateOn: MooseEntityAdded 
				from: [ each isNil ifFalse: [each announcer] ifTrue: [nil] ].
			a 
				updateOn: MooseEntityRemoved 
				from: [ each isNil ifFalse: [each announcer] ifTrue: [nil] ].
			a	
				updateOn: MooseEntityRenamed 
				from: [ each isNil ifFalse: [each announcer] ifTrue: [nil] ]].

]

{ #category : #accessing }
MooseFinder >> panes [
	^ self first panes
]
