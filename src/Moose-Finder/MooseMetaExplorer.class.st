Class {
	#name : #MooseMetaExplorer,
	#superclass : #GLMBrowserTemplate,
	#category : #'Moose-Finder'
}

{ #category : #fame }
MooseMetaExplorer >> abstractFormattedNameOf: each [
	^ each isAbstract 
		ifTrue: [ Text string: each fullName attribute: TextEmphasis italic ]
		ifFalse: [ Text fromString: each fullName ]
]

{ #category : #building }
MooseMetaExplorer >> buildBrowser [
	browser := GLMTabulator new.
	browser title: 'Famix Explorer' translated.
	browser
		column: #hierarchy;
		column: #attributes.
	(browser transmit)
		to: #hierarchy;
		andShow: [ :a | self hierarchyIn: a ].
	(browser transmit)
		to: #attributes;
		from: #hierarchy;
		andShow: [ :a | 
					self relationsIn: a.
					self propertiesIn: a ].
	(browser transmit)
		from: #attributes port: #strongSelection;
		toOutsidePort: #propertyToSelect.
	(browser transmit)
		fromOutsidePort: #propertyToSelect;
		to: #hierarchy port: #selection;
		transformed: [ :property | property owner ].
	(browser transmit)
		fromOutsidePort: #propertyToSelect;
		to: #attributes port: #selection.
	(browser transmit)
		from: #hierarchy;
		toOutsidePort: #selectedEntity.
	(browser transmit)
		fromOutsidePort: #entityToSelect;
		to: #hierarchy port: #selection.
	(browser transmit)
		from: #attributes;
		toOutsidePort: #selectedAttribute.
	^ browser
]

{ #category : #private }
MooseMetaExplorer >> hierarchyIn: a [
	^ (a tree)
		title: 'Entities';
		display: [ :all | (all classes select: [ :each | each superclass = FM3 object ]) sorted: [:x :y | x fullName < y fullName] ];
		children: [ :c | c subclasses sorted: [:x :y | x fullName < y fullName] ];
		format: [ :each | self abstractFormattedNameOf: each ];
		tags: [ :each | 
					each package isNil
						ifTrue: [ #() ]
						ifFalse: [ each package name ] ];
		morphicSelectionAct: [ :list | list selection implementingClass browse ] 
							icon: GLMUIThemeExtraIcons glamorousBrowse 
							on: $b
							entitled: 'Browse implementation';
		morphicSelectionAct: [ :list | list selection inspect ] entitled: 'Inspect'
]

{ #category : #private }
MooseMetaExplorer >> propertiesIn: a [
	^ a table
		title: [ :aFM3Class | aFM3Class allPrimitiveAttributes size asString , ' Properties' translated ];
		display: [ :aFM3Class | aFM3Class allPrimitiveAttributes ];
		sorted: [:attribute1 :attribute2 | attribute1 name < attribute2 name];
		column: 'name' evaluated: [:each | each name ] tags: [ :each :aFM3Class | 
					each mmClass ~= aFM3Class
						ifTrue: [ each mmClass name ]
						ifFalse: [ OrderedCollection new ] ];
		column: 'type' evaluated: [:each | each type name , (each isMultivalued ifTrue: [' *'] ifFalse: ['']) , (each isDerived ifTrue: [' /'] ifFalse: [''])];
		
		morphicSelectionAct: [ :list | 
							Smalltalk tools browser 
								fullOnClass: list selection mmClass implementingClass 
								selector: list selection implementingSelector ] 
							icon: GLMUIThemeExtraIcons glamorousBrowse 
							on: $b
							entitled: 'Browse implementation';
		morphicSelectionAct: [ :list | list selection inspect ] icon: MooseIcons mooseInspect entitled: 'Inspect'
]

{ #category : #private }
MooseMetaExplorer >> relationsIn: a [
	a table
		title: [ :aFM3Class | aFM3Class allComplexAttributes size asString , ' Relations' translated ];
		display: [ :aFM3Class | aFM3Class allComplexAttributes ];
		sorted: [:attribute1 :attribute2 | attribute1 name < attribute2 name];
		column: 'name' evaluated: [:each | each name ] tags: [ :each :aFM3Class | 
					each mmClass ~= aFM3Class
						ifTrue: [ each mmClass name ]
						ifFalse: [ OrderedCollection new ] ];
		column: 'type' evaluated: [:each | each type name , (each isMultivalued ifTrue: [' *'] ifFalse: ['']) , (each isDerived ifTrue: [' /'] ifFalse: [''])];
		column: 'opposite' evaluated: [:each | each opposite ifNil: [ '' ] ifNotNil: [:opposite | opposite name ] ];
		selectionPopulate: #strongSelection
							on: $o
							entitled: 'Open'
							with: [ :list | list selection opposite ];
		morphicSelectionAct: [ :list | 
							Smalltalk tools browser 
								fullOnClass: list selection mmClass implementingClass 
								selector: list selection implementingSelector ] 
							icon: GLMUIThemeExtraIcons glamorousBrowse 
							on: $b
							entitled: 'Browse implementation';
		morphicSelectionAct: [ :list | list selection inspect ] 
							icon: GLMUIThemeExtraIcons glamorousInspect 
							on: $i
							entitled: 'Inspect';
		morphicSelectionAct: [ :list | list selection explore ] 
							icon: GLMUIThemeExtraIcons glamorousInspect 
							on: $I
							entitled: 'Explore'
]
