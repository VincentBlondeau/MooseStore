Class {
	#name : #JacocoImport,
	#superclass : #MooseOperator,
	#instVars : [
		'testClass'
	],
	#category : #'Jacoco-Import'
}

{ #category : #'as yet unclassified' }
JacocoImport >> basicRun [
	| files |
	files := self coverageXmlfolder asFileReference allFiles.
	files do: [ :file | self importFile: file. self increment ]
]

{ #category : #'as yet unclassified' }
JacocoImport >> coverageXmlfolder [
	^ 'C:\Data\Cedicam\WS\git\wlp-product-master-pom\wlp-product-test\XML Coverages'
]

{ #category : #'as yet unclassified' }
JacocoImport >> description [
	^ 'XML coverage import'
]

{ #category : #'as yet unclassified' }
JacocoImport >> importClassXml: aXMLElement [
	| name className classCovered className2 |
	name := aXMLElement attributeAt: 'name'.
	className := name replaceAll: $/ with: $..
	className2 := ('::' join: (className substrings: '.')).
	classCovered := model allClasses select: [ :c | c mooseName = className2 ].
	classCovered
		ifEmpty: [ self logCr: 'Class covered: ' , name , ' notFound.' ]
		ifNotEmpty: [ 
			self assert: classCovered size = 1.
			classCovered := classCovered first.
			self importMethodFromXml: aXMLElement fromContainedClass: classCovered ]
]

{ #category : #'as yet unclassified' }
JacocoImport >> importFile: aFileReference [
	| name className xml className2 |
	name := aFileReference basename.
	className := aFileReference basename copyFrom: 1 to: name size - 9.
	className2 := '::' join: (className substrings: '.').
	testClass := model allClasses select: [ :c | c mooseName = className2 ].
	self assert: testClass size = 1.
	testClass := testClass first.
	xml := XMLDOMParser parse: aFileReference readStream.
	self importXML: xml.
	
]

{ #category : #'as yet unclassified' }
JacocoImport >> importMethodFromXml: aXMLElement fromContainedClass: aFAMIXClass [
	| name constructor description methodCovered constructorTemp |
	aXMLElement
		allElementsNamed: 'method'
		do: [ :aMethodXmlElement | 
			name := aMethodXmlElement attributeAt: 'name'.
			description := self parseDescription: (aMethodXmlElement attributeAt: 'desc').
			name = '<init>'
				ifTrue: [ 
					constructor := aFAMIXClass methods
						select: [ :m | m isConstructor and: [ m numberOfArgsFromSignature = (description size - 1) ] ].
					constructor
						ifEmpty: [ self logCr: 'Method ' , name , 'in Class ' , aFAMIXClass mooseName , 'notFound.' ]
						ifNotEmpty: [ 
							constructor size = 1
								ifFalse: [ 
									constructorTemp := constructor reject: #isStub.
									constructorTemp size ~= 1
										ifTrue: [ 
											self logCr: 'Random selection in ' , constructor printString.
											constructor := {"Should resolve signature matching"
											"Should resolve signature matching"
											(constructor first)}	"Should resolve signature matching"	"Should resolve signature matching" ]
										ifFalse: [ constructor := constructorTemp ] ].
							self assert: constructor size = 1.
							constructor := constructor first.
							constructor addCoveredByTestClass: testClass ] ]
				ifFalse: [ 
					methodCovered := aFAMIXClass methods
						select: [ :m | m name = name and: [ m numberOfArgsFromSignature = (description size - 1) ] ].
					methodCovered
						ifEmpty: [ self logCr: 'Method ' , name , 'in Class ' , aFAMIXClass mooseName , 'notFound.' ]
						ifNotEmpty: [ 
							methodCovered size = 1
								ifFalse: [ self logCr: 'Several method found...' , methodCovered printString ].
							methodCovered := methodCovered first.
							methodCovered addCoveredByTestClass: testClass ] ] ]
]

{ #category : #'as yet unclassified' }
JacocoImport >> importXML: aXMLDocument [
	| packageName pckName |
	aXMLDocument
		allElementsNamed: 'package'
		do: [ :aPackageXmlNode | 
			packageName := aPackageXmlNode attributeAt: 'name'.
			pckName := packageName replaceAll: $/ with: $..
			aPackageXmlNode
				allElementsNamed: 'class'
				do: [ :aClassXmlNode | self importClassXml: aClassXmlNode ] ]
]

{ #category : #'as yet unclassified' }
JacocoImport >> length [
	^ self coverageXmlfolder asFileReference allFiles size
]

{ #category : #'as yet unclassified' }
JacocoImport >> parseDescription: aString [
	| cut args returnVal  |
	cut := aString subStrings: ')'.
	args := cut first allButFirst subStrings: ';'.
	returnVal := cut second.
	^{returnVal} , args.

]
