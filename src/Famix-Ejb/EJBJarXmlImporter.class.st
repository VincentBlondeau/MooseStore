Class {
	#name : #EJBJarXmlImporter,
	#superclass : #PAIAAbstractXMLImporterInModel,
	#category : #'Famix-Ejb'
}

{ #category : #private }
EJBJarXmlImporter >> basicRun [
	| name impl session names |
	names := (self xmlDocument allElementsNamed: 'session')
		collect: [ :aSessionXmlElement | 
			name := (aSessionXmlElement elementAt: 'ejb-name') nodes first string.
			impl := (aSessionXmlElement elementAt: 'ejb-class') nodes first string.
			session := (aSessionXmlElement elementAt: 'business-local') nodes first string.
			((model allWithType: FAMIXEJBEntity) select: [ :famixEjbEntity | famixEjbEntity name = session ])
				ifNotEmpty: [ :famixEjbEntity | 
					famixEjbEntity size > 1 ifTrue: [ "1 halt." ].
					famixEjbEntity first
						ejbClass: impl;
						addEjbName: name ] ].
"	(names flatten asOrderedCollection
		intersection: ((model allWithType: FAMIXEJBEntity) collect: #name) asOrderedCollection) ifNotEmpty: [ self halt ]"
]
