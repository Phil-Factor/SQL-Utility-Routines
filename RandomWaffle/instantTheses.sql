DECLARE @jsonData nvarchar(MAX)=N'{
    "adjective":[
      "carnivalesque", "rhetorical","divided","new","neoliberal", "sustainable","socially-responsible",
	  "multimedia","historical","formalist","gendered","historical","heterotopian", "collective",
	  "cultural","female","transformative","Intersectional","Political","queer","critical","social",
	  "spiritual","visual","Jungian","unwanted","Pre-raphaelite","acquired","gender",
	  "midlife","emotional","coded"
   ],
   "doesSomethingWith":[
      "evokes","explores","describes","summarises","deliniates","traces","relates","characterises","depicts",
	  "focuses on","narrates","educes","draws inspiration from", "tracks the many influences on","meditates on"
   ],
   "interaction":[
      "relationship","affinity","resonance","narrative","interaction"
   ],
   "something":[
      "the body","experiences","archetypes","queerness","gifts","tenets","synesthesia","politics",
	  "subcultures","memories","Oppression","Spaces","Abjection","Telesthesia","Transnationalism",
	  "care","Ambivalence","Neoliberalism","^adjective Identity","Transcendence","Resistance",
	  "performance","Masochism","Spectatorship","play","Masculinity","Aesthetics","Phenomenology",
	  "Blaxpoitation","Plasticity","Annihilation","Identity","Regeneration","Narratives",
	  "Metaphysics","Normativity","Progress","Erasure","gender perception"
   ],
   "note":[
      "This ^book ^doesSomethingWith the ^interaction between ^something and ^something. ^inspiredby, and by ^thinking, new ^feelings are ^made ^terminator","the ^interaction between ^something and ^something in this ^book is ^pretty.  ^inspiredby, new ^feelings which dominate the early chapters ^doesSomethingWith ^something ^terminator.",
	  "It is ^likely that this will ^remain the most ^positive ^book on the subject, balancing as it does the ^interaction between ^something and ^something. ^inspiredby, it ^doesSomethingWith ^something ^terminator.",
       "^tracing influences from ^something, ^something and ^something, the ^book ^doesSomethingWith ^noun through time",
 	  "This ^book provides a ^positive, ^positive introduction to ^adjective ^something ^terminator, with a focus on ^noun., By ^thinking, new ^feelings are ^made ^terminator",
 	  "^verbing ^adjective ^something is ^positive, ^positive and ^positive. This ^book ^doesSomethingWith the ^adjective and ^adjective imperatives of ^adjective ^noun.",
 	  "^positive, ^positive and yet ^positive, this ^book is unusual in that it is ^inspiredby. It will make you appreciate ^verbing ^something ^terminator"
   ],
   "book":[
	   "book","book","^positive book","^positive exposition","booklet","republished series of lectures",
	   "dissertation","^positive compilation","^positive work","volume","^positive monograph","tract",
	   "thesis"
   ],
   "likely":["probable","likely","quite possible","debatable","inevitable","a done deal",
       "probably just a matter of time","in the balance","to be expected"
   ],
   "tracing":["Tracing","tracking","following","uncovering","trailing","investigatiing","exploring"
   ],
   "remain":["estabilsh itself as","be accepted as","remain","be hailed as","be received by the public as",
      "be recommended as","become"
   ],
   "pretty":["a source of ^positive insights","a ^positive reference","a ^positive statement",
      "demanding but ^positive"
   ],
   "positive":["comprehensive","challenging","exciting","discoursive","interesting","stimulating","evocative",
      "nostalgic","heartwarming","penetrating","insightful","gripping","unusual","didactic","instructive",
	  "educative","informative","edifying","enlightening","illuminating","accessible","effective"
   ],
   "thinking":["methodical structuring of the ^something and ^something",
      "balancing the intricate issues, especially the ^adjective ^something",
      "steering clear of the obvious fallacies in their thinking about ^adjective ^something"
   ],
   "inspiredby":[
      "with a nod to both ^source and ^source",
	  "It draws inspiration from influences as diverse as ^source and ^source",
	  "With influences as diverse as as ^source and ^source",
	  "Drawing from sources such as ^source, ^source and ^source as inspiration",
	  "Taking ideas from writers as diverse as as ^writer and ^writer"
   ],
   "source":[
      "Impressionism","Nihilism","left-bank decedence","Surrealism","Psycholinguistics",
      "Post-modermnism","Deconstructionism","Empiricism","Existentialism",
      "dialectical materialism","feminist philosophy","deontological ethics","Critical Realism",
      "Christian Humanism","Anarchist schools of thought","Eleatics","Latino philosophy",
      "the Marburg School","the Oxford Franciscan school","platonic epistemology","process philosophy",
      "Shuddhadvaita"
   ],
   "writer":["Edward Abbey","JG Ballard","Henry James","Kurt Vonnegut","Evelyn Waugh","Wyndham Lewis",
      "T E Lawrence","Timothy Leary","Hugh MacDiarmid","William Faulkner","Gabriel Garcia Marquez",
	  "Henrik Ibsen","Franz Kafka","Mary Wollstonecraft","Henry David Thoreau"
   ],
   "terminator":[
      "as a means of ^adjective and ^adjective ^something","representing ^adjective claims to ^something",
	  "as a site of ^something","as ^something","without a connection","as ^adjective ^something",
	  "as ^adjective ^something and ^something","as ^adjective mediators",
	  "and the gendering of space in the gilded age","as ^adjective justice","as violence",
	  "in the digital streaming age","in an ^adjective framework",
	  "in new ^adjective media","and the violence of ^something","as a form of erasure",
	  "and the negotiation of ^something","signifying ^adjective relationships in ^adjective natures",
	  "as a site of ^adjective contestation","in crisis","as ^adjective devices","through a ^adjective lens"
   ],
   "title":[
      "^verbing ^something ^terminator.","^noun ^terminator.",
	  "^verbing ^adjective ^something: The ^adjective ^noun."
   ],
   "verbing":[
      "situating","transforming","disempowering","reinterpreting","critiquing","a reading of",
	  "activating","the politics of","representations of","interrogating","erasing","redefining",
	  "identifying","reimagining","performing","the legibility of","democratizing","de-centering",
	  "gender and","debating","signaling","embodying","building","the role of","historicizing",
	  "repositioning","destabilizing","mapping","eliminating"
   ],
   "noun":[
      "Genre and Justice","^verbing Uncertainty","Identity","^something and ^something of ^something",
	  "Bodies and Static Worlds","^noun of ^adjective Spaces","^something as resistance,",
	  "Modes of witnessing","representations of trauma","concept of freedom","multimedia experiences",
	  "bodies","theory and empirical evidence","ecology of ^something","^adjective Labor Migration",
	  "^something and ^something","^adjective possibilities","^adjective limitations",
	  "aesthetic exchange","Immersion","abstraction","Revolutionary Sexuality","politics and power",
	  "aesthetics","aepresentation","^adjective categories","pluralities","gender","gaze",
	  "forms of ^something","silences","power structures","dissent","^adjective approach","self",
	  "queerness","modes of being","ontology","agency","epistemologies","intertextuality",
	  "Hyper-Extensionality","fields of belonging","hybridization"
   ],
   "feelings":[
      "combinations","tensions","synergies","resonances","harmonies","contradictions","paradoxes",
	  "superimpositions","amalgamations","syntheses"
   ],
   "made":[
      "distilled","manufactured","woven","synthesised","uncovered","determined","observed","portrayed"
   ]
}'


SELECT TOP 2000 dbo.TitleCase(dbo.SentenceFrom(@jsonData, '$.title', 5)) AS title,
  dbo.SentenceFrom(@jsonData, '$.note', 5) AS notes
  FROM sys.objects;

