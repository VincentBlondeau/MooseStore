Class {
	#name : #FamixDiffToOrionActionsConverter,
	#superclass : #MooseOperator,
	#instVars : [
		'entityChanges',
		'assocChanges',
		'result'
	],
	#category : #FamixDiffToOrionActions
}

{ #category : #accessing }
FamixDiffToOrionActionsConverter >> assocChanges [
	^ assocChanges
]

{ #category : #accessing }
FamixDiffToOrionActionsConverter >> assocChanges: aCollection [
	assocChanges := aCollection
]

{ #category : #private }
FamixDiffToOrionActionsConverter >> basicRun [
	| diff sortedDiff |
	diff := self argAt: #diff.
	sortedDiff := diff sort reject: #isVersion.
	self convertActions: sortedDiff.
	self halt.
	"self entityChanges: diff changes values.
	self assocChanges: diff assocChanges.
	self convertEntityChanges.
	self convertAssocChanges.
	self shouldBeImplemented."
	^ result
]

{ #category : #converting }
FamixDiffToOrionActionsConverter >> convertActions: listOfActions [
	| action |
	listOfActions
		do: [ :aChange | 
			action := aChange convertToOrionActionWithModel: self model.
			action
				ifNotNil: [ action orionModel: self model.
					result add: action.
					action run ] ]
]

{ #category : #converting }
FamixDiffToOrionActionsConverter >> convertAssocChanges [
	self convertActions: self assocChanges
]

{ #category : #converting }
FamixDiffToOrionActionsConverter >> convertEntityChanges [
	self convertActions: self entityChanges
]

{ #category : #accessing }
FamixDiffToOrionActionsConverter >> entityChanges [
	^ entityChanges
]

{ #category : #accessing }
FamixDiffToOrionActionsConverter >> entityChanges: someEntityChanges [
	entityChanges := someEntityChanges
]

{ #category : #initialization }
FamixDiffToOrionActionsConverter >> initialize [
	super initialize.
	result := OrderedCollection new
]
