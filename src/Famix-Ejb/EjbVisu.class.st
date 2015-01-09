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
	| fromClasses toEjbClasses packagesFrom packagesTo |
	"	recursiveNodeBuilder := TLCompositeNodeBuilder childrenProperty: #belongsTo.
	self nodeBuilder: recursiveNodeBuilder."
	self title: 'Ejb usage'.
	fromClasses := self refs collectAsSet: #from.
	toEjbClasses := self refs collectAsSet: #to.
	packagesFrom := fromClasses collectAsSet: #belongsTo.
	packagesTo := toEjbClasses collectAsSet: [ :c | c annotatedClass belongsTo ].
	self
		layout:
			(RTHorizontalLineLayout new
				gapSize: 60;
				alignCenter).
	self > #left layout: RTVerticalLineLayout new alignRight.
	self > #right layout: RTVerticalLineLayout new alignTop.
	self > #left
		nodeBuilder:
			((TLCompositeNodeBuilder childrenProperty: #classes)
				nodeLabel: #mooseName;
				yourself).
	self > #right
		nodeBuilder:
			((TLCompositeNodeBuilder
				childrenProperty: [ :entity | toEjbClasses select: [ :class | class annotatedClass belongsTo = entity ] ])
				nodeLabel: #mooseName;
				yourself).
	self > #left addNodesFromEntities: packagesFrom.
	self > #right addNodesFromEntities: packagesTo.
	(self > #left flatCollect: #childrenNodes)
		connectFollowingProperty: [ :e | e relatedEJBsEntities ]
		context: (self > #right flatCollect: #childrenNodes)
]

{ #category : #accessing }
EjbVisu >> refs [
	^ refs
]

{ #category : #accessing }
EjbVisu >> refs: anObject [
	refs := anObject
]
