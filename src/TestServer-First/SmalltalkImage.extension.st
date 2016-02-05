Extension { #name : #SmalltalkImage }

{ #category : #'*TestServer-First' }
SmalltalkImage >> addToStartUpList: aClass [
	SessionManager default 	
		registerUserClassNamed: self name
]
