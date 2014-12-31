Extension { #name : #MooseAbstractGroup }

{ #category : #'*Famix-Ejb' }
MooseAbstractGroup >> ifEmpty: aBlock [
	^ self isEmpty
		ifTrue: [ ^ aBlock value ]
		ifFalse: [ self ]
]

{ #category : #'*Famix-Ejb' }
MooseAbstractGroup >> ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock [
	self isEmpty
		ifTrue: [ ^ emptyBlock value ].
	^ notEmptyBlock cull: self
]

{ #category : #'*Famix-Ejb' }
MooseAbstractGroup >> ifNotEmpty: aBlock [ 
	 ^self isEmpty
          ifTrue: [self]
          ifFalse: [aBlock cull: self]
]

{ #category : #'*Famix-Ejb' }
MooseAbstractGroup >> ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock [
	self isEmpty
		ifFalse: [ ^ notEmptyBlock cull: self ].
	^ emptyBlock value
]
