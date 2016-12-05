Extension { #name : #FamixRemovalChange }

{ #category : #'*FamixDiffToOrionActions' }
FamixRemovalChange >> convertToOrionActionWithModel: anOrionModel [
	| classType actionClass actionInstance |
	classType := self entity mooseDescription name.
	actionClass := (#ORActionRemove , classType) asClass.
	actionInstance := actionClass new.
	actionInstance entity: (anOrionModel entityNamed: self entity mooseName).
	^ actionInstance
]
