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
	<MSEProperty: #ejbClass type: #FAMIXClass> 
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
FAMIXEJBEntity >> ejbName [
	<MSEProperty: #ejbName type: #String> 
	<MSEComment: 'ejb-jar.xml : ejb-name'>
	"ejb-jar.xml : ejb-name"

	^ ejbName
]

{ #category : #accessing }
FAMIXEJBEntity >> ejbName: aString [
	ejbName := aString
]

{ #category : #accessing }
FAMIXEJBEntity >> sessionEntityName [
	<MSEProperty: #sessionEntityName type: #String> <derived>
	<MSEComment: 'ejb-jar.xml : business-local'>
	"ejb-jar.xml : business-local"

	^ self name
]
