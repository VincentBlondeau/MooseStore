Extension { #name : #PRScript }

{ #category : #'*Pillar-VB-Hacks' }
PRScript >> evaluate [
	| content |
	content := self evaluationString.
	^ [ 
	self isRaw
		ifTrue: [ {(PRRaw content: content trim )} ]
		ifFalse: [ 
			self isInline
				ifTrue: [ {(PRText content: content trim)} ]
				ifFalse: [ (PRDocument parser parse: content) children ] ] ]
		on: Error
		do: [ :e | PRBoldFormat with: (PRText content: e messageText) ]
]

{ #category : #'*Pillar-VB-Hacks' }
PRScript >> isInline [
	^ self parameters at: 'inline' ifPresent: [ :inline | inline = 'true' or: [ inline = true ] ] ifAbsent: [ false ]
]

{ #category : #'*Pillar-VB-Hacks' }
PRScript >> isRaw [
	^ self parameters at: 'raw' ifPresent: [ :raw | raw = 'true' or: [ raw = true ] ] ifAbsent: [ false ]
]
