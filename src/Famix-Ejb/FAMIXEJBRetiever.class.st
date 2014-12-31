Class {
	#name : #FAMIXEJBRetiever,
	#superclass : #MooseOperator,
	#category : #'Famix-Ejb'
}

{ #category : #private }
FAMIXEJBRetiever >> basicRun [
	self createEJBEntities.
	self parseEjbJarXml.
	self createLinksToEntities

]

{ #category : #private }
FAMIXEJBRetiever >> createEJBEntities [
	| interressingAnnotations |
	interressingAnnotations := model allAnnotationTypes
		select: [ :annotationType | 
			{"'Stateless'.
			'Stateful'."
			'Local'.
			'Remote'} anySatisfy: [ :annotationName | annotationType name = annotationName ] ].
	interressingAnnotations
		do: [ :type | 
			type instances
				do: [ :anAnnotationInstance | 
					| newEntity |
					newEntity := FAMIXEJBEntity new
						name: (anAnnotationInstance attributeAt: 'name' ifAbsent: [ anAnnotationInstance annotatedEntity dottedNotation ]) value;
						annotatedClass: anAnnotationInstance annotatedEntity;
						yourself.
					model silentlyAdd: newEntity ] ]
]

{ #category : #private }
FAMIXEJBRetiever >> createLinksToEntities [
	| class methods ref assocs |
	class := model allClasses entityNamed: 'net::atos::xa::resourcelocator::ResourceLocator'.
	methods := class methods select: [ :m | m name = 'lookup' ].
	methods add: ((model allClasses entityNamed: '<Default Package>::<StubMethodContainer>')
	 methods detect: [ :m | m name = 'lookup' ]).
	assocs := methods
		collect: [ :m | m incomingInvocations collect: [ :invocation | invocation from typeScope -> (self parseSignature: invocation signature) ] ].	"made in 2 passes beacause some associations are not found..."
	self halt.
	assocs flatten
		do: [ :assoc | 
			assoc value
				ifNotNil: [ 
					ref := FAMIXEJBReference new
						source: assoc key;
						target: assoc value;
						yourself.	"the link should be done at class level"
					model silentlyAdd: ref ] ]
]

{ #category : #'as yet unclassified' }
FAMIXEJBRetiever >> parseEjbJarXml [
	| files |
	files := (EJBJarXmlRetiever runOn: model rootFolder asFileReference) select: [ :file | file size > 500 ].	"remove the almost empty files"
	files do: [ :file | EJBJarXmlImporter runOnXmlFileNamed: file inRootDirectory: '' with: model ].

]

{ #category : #'as yet unclassified' }
FAMIXEJBRetiever >> parseSignature: aString [
	| name ejbEntities |
	
	(aString includes: $")
		ifFalse: [ 
			self logCr: 'Not a string ' , aString.
			^ nil ].	"(model allClasses)
		select: [ :e | e name asString = 'WlpCurrencyMangerBean' ]."
	name := (aString copyAfter: $") copyUpTo: $".
	name ifEmpty: [ ^ nil ].	" (name includesSubstring: 'net.atos.wlp.ics.contract.VisaIssuerClearingInformationService') ifTrue: [ self halt ]."
	self halt.
	ejbEntities := (model allWithType: FAMIXEJBEntity)
		select: [ :e | e name asString = name or: [ e ejbNames halt asString = name ] ].
	ejbEntities isEmpty
		ifTrue: [ 
			self inform: 'FAMIXEJBRetriever-Not Found...'.
			self logCr: 'Not found: ' , aString.
			self halt.
			^ nil ].
	^ ejbEntities first
]
