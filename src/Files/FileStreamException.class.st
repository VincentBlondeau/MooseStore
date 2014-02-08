"
Common superclass for exceptions while using file streams
"
Class {
	#name : #FileStreamException,
	#superclass : #Error,
	#instVars : [
		'fileName'
	],
	#category : #'Files-Kernel'
}

{ #category : #exceptioninstantiator }
FileStreamException class >> fileName: aFileName [
	^self new fileName: aFileName
]

{ #category : #exceptiondescription }
FileStreamException >> fileName [
	^fileName
]

{ #category : #exceptionbuilder }
FileStreamException >> fileName: aFileName [
	fileName := aFileName
]

{ #category : #exceptiondescription }
FileStreamException >> isResumable [
	"Determine whether an exception is resumable."

	^true
]

{ #category : #exceptiondescription }
FileStreamException >> messageText [
	
	"Return an exception's message text."

	^messageText == nil
		ifTrue: [fileName printString]
		ifFalse: [messageText]
]
