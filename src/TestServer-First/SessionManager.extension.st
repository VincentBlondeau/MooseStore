Extension { #name : #SessionManager }

{ #category : #'*TestServer-First' }
SessionManager >> registerUserClassNamed: aClassName [ 
	self 
		register: (ClassSessionHandler forClassNamed: aClassName)
		inCategory: self userCategory 
		atPriority: self defaultPriority
]
