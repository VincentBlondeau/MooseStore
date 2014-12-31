Class {
	#name : #FAMIXEJBReference,
	#superclass : #FAMIXReference,
	#category : #'Famix-Ejb'
}

{ #category : #'as yet unclassified' }
FAMIXEJBReference >> source [
	<MSEProperty: #source type: #FAMIXContainerEntity opposite: #relatedEJBs>
	<MSEComment: 'Source entity making the reference. from-side of the association'>
	
	^source
]

{ #category : #'as yet unclassified' }
FAMIXEJBReference >> source: aContainerEntity [
	source := FMMultivalueLink on: self
					update: #relatedEJBs
					from: self source
					to: aContainerEntity
]

{ #category : #'as yet unclassified' }
FAMIXEJBReference >> target [
	<MSEProperty: #target type: #FAMIXEJBEntity opposite: #userClasses>
	<MSEComment: 'Target entity referenced. to-side of the association'>
	
	^target
]

{ #category : #'as yet unclassified' }
FAMIXEJBReference >> target: aContainerEntity [
	target := FMMultivalueLink on: self
					update: #userClasses
					from: self target
					to: aContainerEntity
]
