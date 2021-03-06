"
self open
"
Class {
	#name : #MoosePanel,
	#superclass : #GLMBrowserTemplate,
	#category : #'Moose-Finder'
}

{ #category : #'class initialization' }
MoosePanel class >> initialize [
	self registerInWorldMenu
]

{ #category : #menu }
MoosePanel class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'MoosePanel')
		order: 1.0; 
		parent: #Moose;
		label: 'Moose Panel';
		icon: (MooseIcons mooseIcon scaledToSize: 16@16);
		action:[MoosePanel open];
		withSeparatorAfter
]

{ #category : #menu }
MoosePanel class >> menuOpenGlamorousEditorOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'GlamourousEditor')
		order: 11; 
		parent: #Moose;
		label: GLMEditor new defaultTitle;
		action: [GLMEditor open]
]

{ #category : #menu }
MoosePanel class >> menuOpenGlamorousRoassalEaselOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'GlamourousRoassalEasel')
		order: 13; 
		parent: #Moose;
		label: GLMRoassal2Easel new defaultTitle;
		action: [GLMRoassal2Easel open]
]

{ #category : #menu }
MoosePanel class >> menuOpenPetitParserAllParsersBrowserOn: aBuilder [
	<worldMenu>
	(aBuilder item: #PPBrowser)
		order: 20; 
		parent: #Moose;
		label: PPBrowser new title;
		action: [PPBrowser open]
]

{ #category : #opening }
MoosePanel class >> open [
	^ self new openOn: MooseModel root
]

{ #category : #opening }
MoosePanel class >> registerInWorldMenu [
	self environment at: #TheWorldMenu ifPresent: [ :class |
		 ((class respondsTo: #registerOpenCommand:)
			and: [((class class >>#registerOpenCommand:) sendsSelector: #deprecated:) not])
 	     			ifTrue: [class registerOpenCommand: { 'Moose Panel' . {self. #open}}]]

]

{ #category : #building }
MoosePanel >> browserActionsIn: aBrowser [
	aBrowser dynamicActions: [:root | 
		MoosePanelCommand allCommands asOrderedCollection collect: [:each | 
			GLMGenericAction new
				title: each new label;
				"category: each new category;"
				action: [each new execute];
				icon: each new icon ]]		
]

{ #category : #building }
MoosePanel >> buildBrowser [
	browser := GLMTabulator new.
	browser title: 'Moose Panel'.
	browser column: #models; column: #details span: 6.
	self browserActionsIn: browser.
	browser transmit to: #models; andShow: [ :a | self modelsIn: a ].
	browser transmit to: #details; from: #models; andShowIfNone: [ :a |
		a custom: (MooseAccumulatingFinder new first noTitle) ].
	browser transmit 
		to: #details port: #entityToSelect;
		from: #models.
	browser transmit 
		from: #details port: #activeEntity;
		to: #models port: #selection.
	^ browser 
]

{ #category : #building }
MoosePanel >> modelsIn: composite [
	composite list 
			title: 'Models';
			display: [:root | root entities];
			format: #name;
			updateOn: MooseEntityAdded from: [ :root | root announcer ];
			updateOn: MooseEntityRemoved from: [ :root | root announcer ];
			updateOn: MooseEntityRenamed fromAll: [ :root | root entities collectAsSet: #announcer ];
			dynamicActionsOnSelection: [ :list | list selection mooseInterestingEntity mooseFinderActions ]
]
