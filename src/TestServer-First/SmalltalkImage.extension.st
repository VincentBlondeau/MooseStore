Extension { #name : #SmalltalkImage }

{ #category : #'*TestServer-First' }
SmalltalkImage >> addToShutDownList: aClass [
	SessionManager default 	
		registerUserClassNamed: self name
]
