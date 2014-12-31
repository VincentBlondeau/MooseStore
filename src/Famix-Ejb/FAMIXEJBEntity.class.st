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
		'ejbName',
		'ejbClass'
	],
	#category : #'Famix-Ejb'
}

{ #category : #accessing }
FAMIXEJBEntity >> annotatedClass [
	^ annotatedClass
]

{ #category : #accessing }
FAMIXEJBEntity >> annotatedClass: anFAMIXClass [
	annotatedClass := anFAMIXClass
]

{ #category : #accessing }
FAMIXEJBEntity >> ejbClass [
	"ejb-jar.xml : ejb-class"

	^ ejbClass
]

{ #category : #accessing }
FAMIXEJBEntity >> ejbClass: anObject [
	ejbClass := anObject
]

{ #category : #accessing }
FAMIXEJBEntity >> ejbName [
	"ejb-jar.xml : ejb-name"

	^ ejbName
]

{ #category : #accessing }
FAMIXEJBEntity >> ejbName: aString [
	ejbName := aString
]

{ #category : #accessing }
FAMIXEJBEntity >> sessionEntityName [
	"ejb-jar.xml : business-local"

	^ self name
]
