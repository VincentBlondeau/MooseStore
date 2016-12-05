Extension { #name : #FamixAddChange }

{ #category : #'*FamixDiffToOrionActions' }
FamixAddChange >> convertToOrionAction [
	| classType actionClass actionInstance |
	classType := self entity mooseDescription name.
	actionClass := (#ORActionAdd , classType) asClass.
	actionInstance := actionClass new.
	actionInstance newName: self entity name.
	actionInstance container: self entity belongsTo.
	classType = #Method
		ifTrue: [ actionInstance classScope: self entity hasClassScope ].
	^ actionInstance
]

{ #category : #'*FamixDiffToOrionActions' }
FamixAddChange >> convertToOrionActionWithModel: anOrionModel [
	| classType actionClass actionInstance |
	classType := self entity mooseDescription name.
	actionClass := (#ORActionAdd , classType) asClass.
	actionInstance := actionClass new.
	self isForAssociation
		ifFalse: [ actionInstance newName: self name.
			actionInstance container: (anOrionModel entityNamed: self belongsTo mooseName ifAbsent: [ self halt ]).
			classType = #Method
				ifTrue: [ actionInstance classScope: self entity hasClassScope ] ]
		ifTrue: [ actionInstance to: (anOrionModel entityNamed: self to mooseName).
			actionInstance from: (anOrionModel entityNamed: self from mooseName).
			classType = #Invocation
				ifTrue: [ self entity.
					actionInstance
						candidates: (self candidates collect: [ :candidate | anOrionModel entityNamed: candidate mooseName ] as: OrderedCollection).
					actionInstance receiver: (anOrionModel entityNamed: self receiver mooseName).
					actionInstance signature: self signature ] ].
	^ actionInstance
]
