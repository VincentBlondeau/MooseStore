Class {
	#name : #MooseScriptsTest,
	#superclass : #TestCase,
	#category : #'Moose-Tests-Core'
}

{ #category : #util }
MooseScriptsTest >> getAllWindows [
	^ World submorphs select: #isSystemWindow

]

{ #category : #tests }
MooseScriptsTest >> testCreateLightModels [
	| models lanModel |
	#(#createLightModelForLAN #createLightModelForMorphic #createLightModelForNetwork)
		do: [ :k | 
			models := MooseModel root entities copy.
			MooseScripts perform: k.
			self assert: MooseModel root entities size equals: models size + 1.
			lanModel := (MooseModel root entities copyWithoutAll: models) first.
			lanModel remove.
			self assert: MooseModel root entities size equals: models size ]
]

{ #category : #tests }
MooseScriptsTest >> testOpenDoitWorkspaceWith [
	| ws |
	ws := { MooseScripts openDoitWorkspaceWith: {'a'. 'b'. 'c'}. 
	  MooseScripts openMooseReleaseWorkspace }.
	self getAllWindows 
		do: [ :win | (ws includes: (win model)) ifTrue: [ win delete ]]
]
