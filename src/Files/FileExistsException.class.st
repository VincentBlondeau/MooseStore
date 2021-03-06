"
Notify when file exists
"
Class {
	#name : #FileExistsException,
	#superclass : #FileStreamException,
	#instVars : [
		'fileClass'
	],
	#category : #'Files-Kernel'
}

{ #category : #exceptioninstantiator }
FileExistsException class >> fileName: aFileName fileClass: aClass [ 
	^ self new
		fileName: aFileName;
		fileClass: aClass
]

{ #category : #exceptiondescription }
FileExistsException >> defaultAction [
	"The default action taken if the exception is signaled."

	^ UIManager default fileExistsDefaultAction: self

]

{ #category : #accessing }
FileExistsException >> fileClass [
	^ fileClass ifNil: [StandardFileStream]
]

{ #category : #accessing }
FileExistsException >> fileClass: aClass [
	fileClass := aClass
]
