Class {
	#name : #FAMIXClassGroup,
	#superclass : #FAMIXTypeGroup,
	#category : #'Famix-Extensions'
}

{ #category : #meta }
FAMIXClassGroup class >> annotation [

	<MSEClass: #ClassGroup super: #FAMIXTypeGroup>
	<package: #FAMIX>

]

{ #category : #navigation }
FAMIXClassGroup >> asSmalltalkClassCollection [
	^(self
		collect:
			[:each | 
			MooseUtilities
				smalltalkClassFromFamixClassName: each mooseName
				ifAbsent: [nil]]) select: #notNil
]
