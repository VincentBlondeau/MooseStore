"
All the methods here cannot be executed in Smalltalk, they are SmiLang methods
"
Class {
	#name : #SmiExamples,
	#superclass : #Object,
	#instVars : [
		'call'
	],
	#category : #'SmiLang-tests'
}

{ #category : #calls }
SmiExamples >> add: x to: y [
	^ y + x
]

{ #category : #examples }
SmiExamples >> example1Return [
	^ 1
]

{ #category : #examples }
SmiExamples >> example2Add [
	^ 1 + 2
]

{ #category : #examples }
SmiExamples >> example3Minus [
	^ 1 - 2
]

{ #category : #examples }
SmiExamples >> example4Temp [ 
	| t |
	t := 1 + 2.
	^ t + 3
]

{ #category : #examples }
SmiExamples >> example5Call [
	^ call one
]

{ #category : #examples }
SmiExamples >> example6CallArgs [
	^ call add: 3 to: 2
]

{ #category : #examples }
SmiExamples >> example7TempAndCallAndCallArgs [
	| t |
	t := call one.
	^ call add: t to: 2
]

{ #category : #examples }
SmiExamples >> example8NestedCall [
	^ call nestedCall
]

{ #category : #calls }
SmiExamples >> nestedCall [
	| var |
	var := call one + 2.
	^ call add: var to: call one
]

{ #category : #calls }
SmiExamples >> one [
	^ 1
]
