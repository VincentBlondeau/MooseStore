Class {
	#name : #EJBJarXmlRetiever,
	#superclass : #PAIAAbstractFilesRetriever,
	#category : #'Famix-Ejb'
}

{ #category : #'as yet unclassified' }
EJBJarXmlRetiever >> excludedDirectories [ 
 ^ { 'target' }
]

{ #category : #'as yet unclassified' }
EJBJarXmlRetiever >> fileName [
	^ 'ejb-jar.xml'
]
