"
SmiCompiler compiles SmiLang function to SmiFunction
	<func> SmiFunction being compiled
	<tempNames> used to map tempNames to temp indexes 
	<stackSize> current stack depth 
	<maxStackSize> maximum size of the stack used
"
Class {
	#name : #SmiCompiler,
	#superclass : #Object,
	#instVars : [
		'func',
		'tempNames',
		'stackSize',
		'maxStackSize'
	],
	#category : #'SmiLang-compiler'
}

{ #category : #private }
SmiCompiler >> arithmeticSelectors [
	^ #(#+ #- #< #> #'<=' #'>=' #= #'~=' #* #/ #'\\' #@ #bitShift: #'//' #bitAnd: #bitOr:)
]

{ #category : #private }
SmiCompiler >> astFor: method [
	^ RBParser parseMethod: method sourceCode
]

{ #category : #private }
SmiCompiler >> callFunctionFor: selector [
	^ SmiCallFunction new
		function: (SmiCompiler new compileAST: (self astFor: SmiExamples>>selector));
		yourself 
]

{ #category : #private }
SmiCompiler >> compileAST: ast [
	func := SmiFunction new.
	func funcName: ast selector.
	ast arguments do: [ :arg | tempNames add: arg name ].
	ast body statements do: [ :each | each acceptVisitor: self ].
	func numArguments: ast selector numArgs.
	func numTemps: tempNames size - func numArguments.
	func stackSize: maxStackSize + tempNames size.
	^ func
]

{ #category : #public }
SmiCompiler >> compileSmiExample: numExample [
	| ast |
	ast := self astFor: (SmiExamples methods detect: [ :m | m selector beginsWith: 'example' , numExample printString ]).
	^ self compileAST: ast
]

{ #category : #initialization }
SmiCompiler >> initialize [

	super initialize.

	tempNames := OrderedCollection new.
	stackSize := 0.
	maxStackSize := 0.
]

{ #category : #stack }
SmiCompiler >> pop [
	self pop: 1
]

{ #category : #stack }
SmiCompiler >> pop: n [
	stackSize := stackSize - n
]

{ #category : #stack }
SmiCompiler >> push [
	stackSize := stackSize + 1.
	stackSize > maxStackSize ifTrue: [ maxStackSize := stackSize ]
]

{ #category : #private }
SmiCompiler >> tempIndexFor: tempName [
	^ tempNames 
		indexOf: tempName 
		ifAbsent: [ tempNames add: tempName. tempNames size ]
]

{ #category : #visiting }
SmiCompiler >> visitAssignmentNode: assign [	
	assign value acceptVisitor: self.
	func addStackOperation: (SmiStoreTemp new tempIndex: (self tempIndexFor: assign variable name)).
	func addStackOperation: SmiPop new.
	self pop
]

{ #category : #visiting }
SmiCompiler >> visitLiteralNode: litValue [ 
	func addStackOperation: (SmiPushSmi new smi: litValue value).
	self push.
]

{ #category : #visiting }
SmiCompiler >> visitMessageNode: msg [	
	(self arithmeticSelectors includes: msg selector) 
		ifTrue: [ ^ self visitPrimitiveNode: msg ].
	msg arguments do: [ :arg | arg acceptVisitor: self ].
	func addStackOperation: (self callFunctionFor: msg selector).
	self pop: msg arguments size.
	self push
	
]

{ #category : #visiting }
SmiCompiler >> visitPrimitiveNode: msg [	
	msg receiver acceptVisitor: self.
	msg arguments do: [ :arg | arg acceptVisitor: self ].
	func addStackOperation: (SmiPrimitiveOperation new selector: msg selector).
	self pop: msg arguments size.
]

{ #category : #visiting }
SmiCompiler >> visitReturnNode: return [	
	return value acceptVisitor: self.
	func addStackOperation: SmiReturnTop new.
]

{ #category : #visiting }
SmiCompiler >> visitVariableNode: var [	
	func addStackOperation: (SmiPushTemp new tempIndex: (self tempIndexFor: var name)).
	self push.
]
