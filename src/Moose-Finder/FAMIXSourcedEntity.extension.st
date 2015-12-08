Extension { #name : #FAMIXSourcedEntity }

{ #category : #'*moose-finder' }
FAMIXSourcedEntity >> mooseFinderSourceTextIn: composite [
	<moosePresentationOrder: 10>
	composite text
			title: 'Source';
			titleIcon: MooseIcons mooseSourceText;
			format: [ self mooseInterestingEntity formattedSourceText ];
			when: [ self mooseInterestingEntity sourceText notEmpty ]
]
