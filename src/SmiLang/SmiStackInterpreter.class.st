"
Interpret using a theoretically infinite stackPage the SmiFunctions
	
	programCounter <Smi> index in currentFunction stackOperations of the operation being executed
	currentFunction <SmiFunction> function being executed
	framePointer <Smi> index in the stack page of the active framePointer 
	stackPointer <Smi> index in the stack page of the active stack pointerArity 	currentStackPage <Array> theoritacally infinite stack page
"
Class {
	#name : #SmiStackInterpreter,
	#superclass : #Object,
	#instVars : [
		'programCounter',
		'currentFunction',
		'framePointer',
		'stackPointer',
		'currentStackPage'
	],
	#category : #'SmiLang-stack interpreter'
}

{ #category : #private }
SmiStackInterpreter >> activateFunction: func [
	"Sets up a new stack frame:
	push and update function, programCounter, framePointer and allocate space for temporaries"
	self shouldBeImplemented.
]

{ #category : #initialization }
SmiStackInterpreter >> initialize [

	super initialize.

	currentStackPage := self newStackPage.
	stackPointer := 0.
]

{ #category : #initialization }
SmiStackInterpreter >> initializeStackFor: function [
	programCounter := #programCounterFlag.
	currentFunction := #functionFlag.
	framePointer := #framePointerFlag.
	self activateFunction: function
]

{ #category : #private }
SmiStackInterpreter >> interpret [
	[ currentFunction == #functionFlag ] whileFalse: [ 
		programCounter := programCounter + 1. 
		self interpretNextInstruction ]
]

{ #category : #public }
SmiStackInterpreter >> interpret: function [
	self initializeStackFor: function.
	self interpret.
	^ currentStackPage first
]

{ #category : #private }
SmiStackInterpreter >> interpretNextInstruction [
	"Asks the currentInstruction to accept self"
	self shouldBeImplemented.
	
	Halt onCount: 1000. "You may use this code to halt on infinite loops"
]

{ #category : #initialization }
SmiStackInterpreter >> newStackPage [
	^ Array new: self stackPageSize
]

{ #category : #stack }
SmiStackInterpreter >> pop [
	"should pop top of stack and return it"
	self shouldBeImplemented.
]

{ #category : #stack }
SmiStackInterpreter >> push: elem [ 
	"should push elem on top of stack"
	self shouldBeImplemented.
]

{ #category : #initialization }
SmiStackInterpreter >> stackPageSize [
	^ 50
]

{ #category : #stack }
SmiStackInterpreter >> top [
	"should answer top of stack"
	self shouldBeImplemented.
]

{ #category : #visiting }
SmiStackInterpreter >> visitCallFunction: node [
	"probably calls activateFunction:"
	self shouldBeImplemented.
]

{ #category : #visiting }
SmiStackInterpreter >> visitPop: node [
	self shouldBeImplemented.
]

{ #category : #visiting }
SmiStackInterpreter >> visitPrimitiveOperation: node [
	"Use perform:with: to get the primitive result"
	self shouldBeImplemented.
]

{ #category : #visiting }
SmiStackInterpreter >> visitPushSmi: node [
	self shouldBeImplemented.
]

{ #category : #visiting }
SmiStackInterpreter >> visitPushTemp: node [
	"Pushes the temp value relatively to the frame pointer.
	Depending if the index corresponds to an argument or a temporary,
	fetches the value before or after the framePointer"
	self shouldBeImplemented.
]

{ #category : #visiting }
SmiStackInterpreter >> visitReturnTop: node [
	"Pop the current frame and push the function result.
	Restores programCounter, currentFunction and framePointer to sender frame"
	self shouldBeImplemented.
]

{ #category : #visiting }
SmiStackInterpreter >> visitStoreTemp: node [
	"the temp referenced is necessarily a temporary and not an argument (language constraint).
	Store the top of stack relatively to a location relative to the framePointer.
	Does not pop the stack (stack pointer is the same at the end of this instruction than at the beginning)"
	self shouldBeImplemented.
]
