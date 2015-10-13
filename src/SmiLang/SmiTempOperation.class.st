Class {
	#name : #SmiTempOperation,
	#superclass : #SmiStackOperation,
	#instVars : [
		'tempIndex'
	],
	#category : #'SmiLang-compiler'
}

{ #category : #'as yet unclassified' }
SmiTempOperation >> accept: visitor [
	^ visitor visitTempOperation: self
]

{ #category : #accessing }
SmiTempOperation >> tempIndex [
	^ tempIndex
]

{ #category : #accessing }
SmiTempOperation >> tempIndex: anObject [
	tempIndex := anObject
]
