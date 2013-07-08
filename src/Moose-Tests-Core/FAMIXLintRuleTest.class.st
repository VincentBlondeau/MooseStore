Class {
	#name : #FAMIXLintRuleTest,
	#superclass : #TestCase,
	#category : #'Moose-Tests-Core'
}

{ #category : #tests }
FAMIXLintRuleTest >> testRules [

	| instances cls badClass goodClass contextBad contextGood |
	instances := {
		FAMIXMetaModelClassesNotDeclaredInFameRule new.
		FAMIXMetaModelClassesShouldNotOverrideRule new.
		FAMIXMetaModelClassesShouldOverrideRule new }.
	
	"Run the rule"
	instances do: [ :rule | RBSmalllintChecker runRule: rule ].

	"Build the classes to test"
	badClass := Class new.
	badClass compile: 'mooseNameOn: stream ^ 10'.

	goodClass := Class new.
	goodClass compile: 'foo: stream ^ 10'.

	"Build the smalllint contexts"
	contextBad := RBSmalllintContext newNoCache.
	contextBad selectedClass: badClass.

	contextGood := RBSmalllintContext newNoCache.
	contextGood selectedClass: goodClass.

	"Check the classes"
	"We cannot check this properly. Pity"
"	instances allButFirst do: [ :rule | 
		rule checkClass: contextBad.
		self assert: rule result isEmpty not ].
"	instances do: [ :rule | 

		rule checkClass: contextGood.
		self assert: rule result isEmpty].
]
