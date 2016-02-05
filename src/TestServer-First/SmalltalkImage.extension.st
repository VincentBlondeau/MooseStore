Extension { #name : #SmalltalkImage }

{ #category : #'*TestServer-First' }
SmalltalkImage >> addToShutDownList: aClass [
	SessionManager default 	
		registerUserClassNamed: aClass name
]

{ #category : #'*TestServer-First' }
SmalltalkImage >> addToStartUpList: aClass [
	SessionManager default 	
		registerUserClassNamed: aClass name
]
