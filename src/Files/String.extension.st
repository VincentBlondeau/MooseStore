Extension { #name : #String }

{ #category : #'*files' }
String >> asFileName [
	"Answer a String made up from the receiver that is an acceptable file 
	name."

	| string checkedString |
	string := FileSystem disk checkName: self fixErrors: true.
	checkedString := FilePathEncoder encode: string.
	^ FilePathEncoder decode: checkedString
]

{ #category : #'*files' }
String >> asVmPathName [
	^ FilePathEncoder encode: self
]
