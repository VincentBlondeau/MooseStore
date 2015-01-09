"
visualization := EjbVisu new
		refs: (MooseModel root first allWithType: FAMIXEJBReference);
		yourself.
	visualization open.
	

self allWithType: FAMIXEJBReference 
"
Class {
	#name : #EjbVisu,
	#superclass : #TLVisualization,
	#instVars : [
		'refs'
	],
	#category : #'Famix-Ejb'
}

{ #category : #'as yet unclassified' }
EjbVisu >> buildVisualization [
	| inspectAction |
	"	recursiveNodeBuilder := TLCompositeNodeBuilder childrenProperty: #belongsTo.
	self nodeBuilder: recursiveNodeBuilder."
	self title: 'Ejb usage'.
	self nodeBuilder nodeLabel: #mooseName.
	self
		layout:
			(RTHorizontalLineLayout new
				gapSize: 60;
				alignCenter).
	self > #left layout: RTVerticalLineLayout new alignRight.
	self > #right layout: RTVerticalLineLayout new alignTop.
	inspectAction := TLCustomAction block: [ :aNode | aNode entity inspect ].
	self nodeBuilder
		addInteraction: (inspectAction withMenu: 'Inspect');
		addInteraction: TLNodeBasicInteraction draggable.
	self > #left addNodesFromEntities: (self refs collect: #from) asSet.
	self > #right addNodesFromEntities: ((self refs collect: #to) asSet sorted: [ :a :b | a name > b name ]).
	self > #left connectFollowingProperty: #relatedEJBsEntities context: self > #right
]

{ #category : #accessing }
EjbVisu >> refs [
	^ refs
]

{ #category : #accessing }
EjbVisu >> refs: anObject [
	refs := anObject
]
