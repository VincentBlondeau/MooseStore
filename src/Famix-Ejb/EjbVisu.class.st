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
	| fromClasses toEjbClasses packagesFrom packagesTo modulesFrom modulesTo |
	self title: 'Ejb usage'.
	self addInteraction: TLNodeBasicInteraction draggable.
	fromClasses := self refs collectAsSet: #from.
	toEjbClasses := self refs collectAsSet: #to.
	packagesFrom := fromClasses collectAsSet: #belongsTo.
	packagesTo := toEjbClasses collectAsSet: [ :c | c annotatedClass belongsTo ].
	modulesFrom := packagesFrom collectAsSet: #mavenModule.
	modulesTo := packagesTo collectAsSet: #mavenModule.
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
				removeDefaultInteractions;
				nodeLabel: #mooseName;
				yourself).
	(self > #left) nodeBuilder childrenNodeBuilder
		addInteraction: TLNodeBasicInteraction draggable;
		addInteraction: (TLNodeBasicInteraction popup: #mooseName).
		
	self > #right
		nodeBuilder:
			((TLCompositeNodeBuilder
				childrenProperty: [ :entity | toEjbClasses select: [ :class | class annotatedClass belongsTo = entity ] ])
				removeDefaultInteractions;
				nodeLabel: #mooseName;
				addInteraction: TLNodeBasicInteraction draggable;
				yourself).
	(self > #right) nodeBuilder childrenNodeBuilder
		addInteraction: TLNodeBasicInteraction draggable;
		addInteraction: (TLNodeBasicInteraction popup: #mooseName).
		
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
