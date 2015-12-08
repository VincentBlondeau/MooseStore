Extension { #name : #FileReference }

{ #category : #'*Famix-File' }
FileReference >> relativePathString [
	"Return the relative path name of the receiver."

	^ filesystem stringFromPath: path
]
