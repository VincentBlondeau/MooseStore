"
Interprets SmiFunction using contexts.

	currentContext <SmiContext> Context being executed
"
Class {
	#name : #SmiContextInterpreter,
	#superclass : #Object,
	#instVars : [
		'currentContext'
	],
	#category : #'SmiLang-context interpreter'
}

{ #category : #private }
SmiContextInterpreter >> initialContext [
	^ SmiContext new
		programCounter: 0;
		function: #stopFlag;
		initialContext;
		yourself
]

{ #category : #private }
SmiContextInterpreter >> interpret [
	[ currentContext function == #stopFlag ] whileFalse: [ 
		currentContext programCounter: currentContext programCounter + 1. 
		self interpretNextInstruction ]
]

{ #category : #public }
SmiContextInterpreter >> interpret: function [
	currentContext := self initialContext.
	self newContextFor: function.
	self interpret.
	^ currentContext top
]

{ #category : #private }
SmiContextInterpreter >> interpretNextInstruction [
	"should ask the current instruction to 'accept: self' to dispatch"

	currentContext function stackOperations size >= currentContext programCounter
		ifTrue: [ (currentContext function stackOperations at: currentContext programCounter) accept: self ].
	Halt onCount: 1000	"You may use this code to halt on infinite loops"
]

{ #category : #private }
SmiContextInterpreter >> newContextFor: function [
	| stack oldContext |
	oldContext := currentContext.
	currentContext := SmiContext new.

	"should set up a new currentContext:
	sender
	function
	programCounter
	stack and stackPointer
	arguments and temporaries"
	stack := Array new: function stackSize.
	currentContext initializeWithFunc: function.
	currentContext sender: oldContext.
	currentContext programCounter: 0.
	currentContext stackPointer: function numArgs + function numTemps
]

{ #category : #visiting }
SmiContextInterpreter >> visitCallFunction: node [
	"calls newContextFor:"

	| argValue |
	self newContextFor: node function.
	0 to: node function numArgs - 1 do:
		[ :index | 
		argValue := currentContext sender stackAt: currentContext sender stackPointer - index.
		currentContext stackAt: index + 1 put: argValue ].
	currentContext sender
		stackPointer: currentContext sender stackPointer - node function numArgs
]

{ #category : #visiting }
SmiContextInterpreter >> visitPop: node [
	currentContext stackPointer: currentContext stackPointer -1.
]

{ #category : #visiting }
SmiContextInterpreter >> visitPrimitiveOperation: node [
	"Use perform:with: to get the primitive result"

	| arg1 arg2 |
	arg1 := currentContext stackAt: currentContext stackPointer.
	currentContext stackPointer: currentContext stackPointer - 1.
	arg2 := currentContext stackAt: currentContext stackPointer.
	currentContext stackAt: currentContext stackPointer put: (arg1 perform: node selector with: arg2)
]

{ #category : #visiting }
SmiContextInterpreter >> visitPushSmi: node [
	currentContext stackPointer: currentContext stackPointer + 1.
	currentContext stackAt: currentContext stackPointer put: node smi
]

{ #category : #visiting }
SmiContextInterpreter >> visitPushTemp: node [
	"Fetches the value from the stack based on node tempIndex"

	| tmp |
	tmp := currentContext stackAt: node tempIndex.
	currentContext stackPointer: currentContext stackPointer + 1.
	currentContext stackAt: currentContext stackPointer put: tmp
]

{ #category : #visiting }
SmiContextInterpreter >> visitReturnTop: node [
	"Push the top of the stack on the currentContext sender stack
	and resume execution in the sender."

	| oldContext |
	oldContext := currentContext sender.
	oldContext stackPointer: oldContext stackPointer + 1.
	oldContext stackAt: oldContext stackPointer put: (currentContext stackAt: currentContext stackPointer).
	currentContext := currentContext sender
]

{ #category : #visiting }
SmiContextInterpreter >> visitStoreTemp: node [
	"There should be a location on stack to store this value"
	currentContext stackAt: node tempIndex put: (currentContext stackAt: currentContext stackPointer)

]
