Extension { #name : #PRExportCommandLineHandler }

{ #category : #'*Pillar-VB-Hacks' }
PRExportCommandLineHandler >> export [
	| subConfig |
	self flag: #todo.	"For now we ensure that the script is deleted here. In the future if the begining of the export is the same for all the default exporters this should be done in the PRCreationPhase. Now it is not possible because the creation phase of the second export would delete the script of the first export."
	(configuration baseDirectory / 'pillarPostExport.sh') ensureDelete.
	"configuration outputFile: self baseDirectory path."
	configuration baseDirectory: self baseDirectory path.
	[ configuration defaultExporters
		do: [ :exporter | 
			subConfig := configuration getConfigurationNamed: exporter.
			self optionAt: 'to' ifPresent: [ :each | subConfig parent: configuration ].
			subConfig export ] ]
		on: CCConfigurationError , PRNoInputFileError
		do: [ :error | self exitFailure: error messageText ]
]
