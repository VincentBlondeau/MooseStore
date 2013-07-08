Class {
	#name : #MoosePropertyGroupTest,
	#superclass : #TestCase,
	#category : #'Moose-Tests-Core'
}

{ #category : #utility }
MoosePropertyGroupTest >> model [
	" to debug and avoid caching behavior: LANPackageTestResource reset."
	^ LANPackageTestResource current model 
]

{ #category : #tests }
MoosePropertyGroupTest >> testBasic [
	| model allClasses aMooseGroup propertyGroup |
	model := self model.
	allClasses := model allClasses.
	propertyGroup := MoosePropertyGroup
		withAll: (allClasses copyFrom: 1 to: 2)
		from: allClasses
		using: #numberOfLinesOfCode.
	self assert: propertyGroup originalGroup == allClasses.
	self assert: propertyGroup property == #numberOfLinesOfCode.
	self assert: propertyGroup propertyRatio isNumber.
	self assert: propertyGroup propertyTotal isNumber.
	self assert: propertyGroup asMooseGroup class == FAMIXClassGroup.
	self assert: propertyGroup propertyTotalOriginal equals: 380.
	self assert: (propertyGroup sizeRatio * 100) asInteger equals: 4.
	self assert: propertyGroup sizeOriginal equals: allClasses size
]
