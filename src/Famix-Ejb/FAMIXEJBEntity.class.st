"
A FAMIXEJBEntity is a representation of a Java EJB.
Has a @Stateless or @Statefull annotation

Instance Variables
	annotatedClass:		<Object>

annotatedClass
	- xxxxx

"
Class {
	#name : #FAMIXEJBEntity,
	#superclass : #FAMIXNamedEntity,
	#instVars : [
		'annotatedClass',
		'ejbClass',
		'ejbNames'
	],
	#category : #'Famix-Ejb'
}

{ #category : #'initialize-release' }
FAMIXEJBEntity class >> annotation [
	<MSEClass: #FAMIXEJBEntity super: #FAMIXNamedEntity>
	<package: #'FAMIX-EJB'>
	^self
]

{ #category : #accessing }
FAMIXEJBEntity >> addEjbName: aString [
	ejbNames add: aString
]

{ #category : #accessing }
FAMIXEJBEntity >> annotatedClass [
	<MSEProperty: #annotatedClass type: #FAMIXClass> 
	<MSEComment: 'The class that is the ejb'>
	^ annotatedClass
]

{ #category : #accessing }
FAMIXEJBEntity >> annotatedClass: anFAMIXClass [
	annotatedClass := anFAMIXClass
]

{ #category : #accessing }
FAMIXEJBEntity >> belongsTo [
	^ self annotatedClass
]

{ #category : #accessing }
FAMIXEJBEntity >> ejbClass [
	<MSEProperty: #ejbClass type: #String> 
	<MSEComment: 'ejb-jar.xml : ejb-class'>
	"ejb-jar.xml : ejb-class"

	^ ejbClass
]

{ #category : #accessing }
FAMIXEJBEntity >> ejbClass: anObject [
	ejbClass := anObject
]

{ #category : #accessing }
FAMIXEJBEntity >> ejbNames [
	<MSEProperty: #ejbNames type: #String> 
	<MSEComment: 'ejb-jar.xml : ejb-name'>
	<multivalued>
	"ejb-jar.xml : ejb-name"

	^ ejbNames asSet
]

{ #category : #accessing }
FAMIXEJBEntity >> ejbNames: aCollectionOfStrings [
	ejbNames := aCollectionOfStrings
]

{ #category : #accessing }
FAMIXEJBEntity >> initialize [
	super initialize.
	ejbNames := Set new.
	
]

{ #category : #accessing }
FAMIXEJBEntity >> sessionEntityName [
	<MSEProperty: #sessionEntityName type: #String> <derived>
	<MSEComment: 'ejb-jar.xml : business-local'>
	"ejb-jar.xml : business-local"

	^ self name
]
