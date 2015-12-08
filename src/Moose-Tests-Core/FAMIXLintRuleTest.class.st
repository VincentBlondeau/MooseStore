Class {
	#name : #FAMIXLintRuleTest,
	#superclass : #TestCase,
	#category : #'Moose-Tests-Core'
}

{ #category : #tests }
FAMIXLintRuleTest >> testRules [

	| instances  badClass goodClass   |
	instances := {
		FAMIXMetaModelClassesNotDeclaredInFameRule new.
		FAMIXMetaModelClassesShouldNotOverrideRule new }.
	
	"Run the rule"
	instances do: [ :rule | RBSmalllintChecker runRule: rule ].

	"Build the classes to test"
	badClass := Class new.
	badClass layout: MooseEntity layout copy.
	badClass compile: 'mooseNameOn: stream ^ 10'.

	goodClass := Class new.
	goodClass layout: MooseEntity layout copy.
	goodClass compile: 'foo: stream ^ 10'.

	"Check the classes"
	"We cannot check this properly. Pity"
"	instances allButFirst do: [ :rule | 
		rule checkClass: contextBad.
		self assert: rule result isEmpty not ].
"	instances do: [ :rule | 

		rule checkClass: goodClass.
		self assert: rule result isEmpty].
]
