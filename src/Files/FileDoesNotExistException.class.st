"
Notify when fie does not exist
"
Class {
	#name : #FileDoesNotExistException,
	#superclass : #FileStreamException,
	#instVars : [
		'readOnly'
	],
	#category : #'Files-Kernel'
}

{ #category : #examples }
FileDoesNotExistException class >> example [
	"FileDoesNotExistException example"

	| result |
	result := [(StandardFileStream readOnlyFileNamed: 'error42.log') contentsOfEntireFile]
		on: FileDoesNotExistException
		do: [:ex | 'No error log'].
	Transcript show: result; cr
]

{ #category : #exceptiondescription }
FileDoesNotExistException >> defaultAction [
	"The default action taken if the exception is signaled."

	^ UIManager default fileDoesNotExistsDefaultAction: self

]

{ #category : #accessing }
FileDoesNotExistException >> readOnly [
	^readOnly == true
]

{ #category : #accessing }
FileDoesNotExistException >> readOnly: aBoolean [
	readOnly := aBoolean
]
