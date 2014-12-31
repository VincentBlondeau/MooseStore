Extension { #name : #FAMIXAnnotationInstance }

{ #category : #'*Famix-Ejb' }
FAMIXAnnotationInstance >> attributeAt: aString [ 

	^ self attributes detect: [ :attribute | attribute name = aString ]
]

{ #category : #'*Famix-Ejb' }
FAMIXAnnotationInstance >> attributeAt: aString ifAbsent: aBlock [
	^ self attributes detect: [ :attribute | attribute name = aString ] ifNone: aBlock
]
