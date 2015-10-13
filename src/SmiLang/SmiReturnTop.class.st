Class {
	#name : #SmiReturnTop,
	#superclass : #SmiStackOperation,
	#category : #'SmiLang-compiler'
}

{ #category : #'as yet unclassified' }
SmiReturnTop >> accept: visitor [
	^ visitor visitReturnTop: self
]

{ #category : #printing }
SmiReturnTop >> printOn: s [
	s << 'returnTop'
]
