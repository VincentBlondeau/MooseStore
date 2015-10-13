Class {
	#name : #SmiContextInterpreterTests,
	#superclass : #TestCase,
	#category : #'SmiLang-tests'
}

{ #category : #helper }
SmiContextInterpreterTests >> compileAndRun: numExample [
	| func |
	func := SmiCompiler new compileSmiExample: numExample.
	^ self interpreterClass new interpret: func
	
	
]

{ #category : #helper }
SmiContextInterpreterTests >> interpreterClass [
	^ SmiContextInterpreter
	
	
]

{ #category : #tests }
SmiContextInterpreterTests >> testExample1 [
	| result |
	result := self compileAndRun: 1.
	self assert: result equals: 1.
]

{ #category : #tests }
SmiContextInterpreterTests >> testExample2 [
	| result |
	result := self compileAndRun: 2.
	self assert: result equals: 3.
]

{ #category : #tests }
SmiContextInterpreterTests >> testExample4 [
	| result |
	result := self compileAndRun: 4.
	self assert: result equals: 6.
]

{ #category : #tests }
SmiContextInterpreterTests >> testExample5 [
	| result |
	result := self compileAndRun: 5.
	self assert: result equals: 1.
]

{ #category : #tests }
SmiContextInterpreterTests >> testExample6 [
	| result |
	result := self compileAndRun: 6.
	self assert: result equals: 5.
]

{ #category : #tests }
SmiContextInterpreterTests >> testExample7 [
	| result |
	result := self compileAndRun: 7.
	self assert: result equals: 3.
]

{ #category : #tests }
SmiContextInterpreterTests >> testExample8 [
	| result |
	result := self compileAndRun: 8.
	self assert: result equals: 4.
]
