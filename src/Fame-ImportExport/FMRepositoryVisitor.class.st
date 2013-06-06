Class {
	#name : #FMRepositoryVisitor,
	#superclass : #Object,
	#instVars : [
		'repository',
		'wrapperDict',
		'printer',
		'index',
		'nb',
		'progBar',
		'roots'
	],
	#category : #'Fame-ImportExport'
}

{ #category : #'instance creation' }
FMRepositoryVisitor class >> new [
	^self basicNew initialize
]

{ #category : #exporting }
FMRepositoryVisitor >> basicRun [

	self exportHeader.
	self roots do: [ :each |
		self exportElement: each ].
	self exportFooter.
]

{ #category : #exporting }
FMRepositoryVisitor >> exportElement: each [ 
	
	| meta serial properties |

	meta := repository metaDescriptionOf: each.
	self flag: 'ideally, there should be no nil check here. Currently, we need it to accommodate the case in which we export a model based on a partial meta-model'. 
	meta ifNotNil: [
		serial := self indexOf: each.
		printer beginElement: meta fullName.
		printer serial: serial.
		properties := self sortAttributes: meta allAttributes.
		properties do: [ :property | 
			| values |
			values := repository 
				get: property
				element: each.
			self 
				exportProperty: property
				withAll: values ].
		printer endElement: meta fullName
		].
	self increment. "UI stuff"
]

{ #category : #exporting }
FMRepositoryVisitor >> exportFooter [
	printer endDocument
]

{ #category : #exporting }
FMRepositoryVisitor >> exportHeader [

	printer beginDocument.
]

{ #category : #exporting }
FMRepositoryVisitor >> exportProperty: property withAll: values [

	(self ignoreProperty: property withAll: values) ifTrue: [ ^nil ].
	printer beginAttribute: property name.
	property type isPrimitive
		ifTrue: [
			values do: [ :each | printer primitive: each ]]
		ifFalse: [
			property isComposite 
				ifTrue: [
					values do: [ :each | self exportElement: each ]]
				ifFalse: [
					values do: [ :each | 
						(self isPrimitiveTypeOrObject: each)
							ifTrue: [
								printer referenceName: each name ]	
							ifFalse: [
								printer referenceNumber: (self indexOf: each) ]]]].
	printer endAttribute: property name.
]

{ #category : #exporting }
FMRepositoryVisitor >> ignoreProperty: property withAll: values [
	
	^ (repository metamodel includes: property) not or: [
		values isEmpty or: [
			property isDerived or: [
				property type == FM3MetaDescription boolean and: [
					values size == 1 and: [ 
						values first == false ]]]]]
]

{ #category : #exporting }
FMRepositoryVisitor >> increment [

	nb := nb + 1.
	progBar ifNotNil: [ progBar value: nb ]
]

{ #category : #private }
FMRepositoryVisitor >> indexOf: each [
	each isNil ifTrue: [ self error ].
	^index at: each ifAbsentPut: [ index size + 1 ]
]

{ #category : #'initialize-release' }
FMRepositoryVisitor >> initialize [
	"Gofer new squeaksource: 'ht'; addPackage: 'Hashtable'; load."
	index := IdentityHashTable new.
]

{ #category : #private }
FMRepositoryVisitor >> isPrimitiveTypeOrObject: each [

	^each == FM3MetaDescription object or: [
		each == FM3MetaDescription string or: [
			each == FM3MetaDescription number or: [
				each == FM3MetaDescription boolean]]]
]

{ #category : #accessing }
FMRepositoryVisitor >> model: aRepository [
	repository := aRepository.
	roots := nil. "reset cache for roots"
]

{ #category : #accessing }
FMRepositoryVisitor >> printer: aPrinter [
	printer := aPrinter
]

{ #category : #private }
FMRepositoryVisitor >> roots [

	^ roots ifNil: [ roots := repository elements select: [ :each |
						(self isPrimitiveTypeOrObject: each) not
						and: [ (repository containerOf: each) isNil ]] ]
]

{ #category : #exporting }
FMRepositoryVisitor >> run [

	nb := 0.
	UIManager default
		displayProgress: 'Writing ', printer stream localName
		at: Sensor cursorPoint
		from: 0 
		to: self roots size 
		during: [ :bar | progBar := bar. self basicRun]

]

{ #category : #private }
FMRepositoryVisitor >> sortAttributes: properties [

	| names composites sorted |
	sorted := properties asArray sorted: [:n1 :n2 | n1 name < n2 name ].
	names := sorted select: [ :each | each name == #name ].
	composites := sorted select: [ :each | each isComposite ].
	^names, (sorted copyWithoutAll: (names union: composites)), composites
]
