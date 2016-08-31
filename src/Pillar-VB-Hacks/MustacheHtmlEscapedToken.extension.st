Extension { #name : #MustacheHtmlEscapedToken }

{ #category : #'*Pillar-VB-Hacks' }
MustacheHtmlEscapedToken >> valueInContext: anObject [

^ (super valueInContext: anObject) asString 
]
