Extension { #name : #PRCocoonConfigurationTest }

{ #category : #'*Pillar-VB-Hacks' }
PRCocoonConfigurationTest >> testSupportFilesWithFolderInsideOutputDirectoryAreNotExported [
	"I check that, when someone created a new subconfiguration, the defaults configurations still exists."

	| ston folder config |
	folder := FileSystem memory root.
	(folder / 'bar') ensureCreateDirectory.
	(folder / 'bar' / 'foo.html') ensureCreateFile.
	ston := '{
		"support": [ "bar/foo.html" ],
		"outputDirectory": "bar"
}'.
	config := PRPillarConfiguration new
		baseDirectory: folder;
		yourself.
	CCMagritteDictionaryReader
		writeDictionary: (STON fromString: ston)
		toConfiguration: config.
	config
		inputString: 'Test';
		outputStream: String new writeStream;
		export: #text.
	self assert: (folder / 'bar' / 'bar' / 'foo.html') exists not --> false
]
