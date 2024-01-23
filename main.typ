#let authors = (
	(
		name: "Carson McManus",
		email: "cmcmanus@stevens.edu",
		department: [School of Systems and Enterprises],
		organization: [Stevens Institute of Technology],
		location: [Hoboken, NJ],
	),
)

// import and use whatever document format you want here


#import "lib/glossary.typ": glossary, glossaryWords, glossaryShow
#show glossaryWords("glossary.yml"): word => glossaryShow("glossary.yml", word)
// Index-Entry hiding : this rule makes the index entries in the document invisible.
#show figure.where(kind: "jkrb_index"): it => {}
#metadata("!glossary:disable")

// put outlines, title pages, etc here

#metadata("!glossary:enable")

// include chapters here


#metadata("!glossary:disable")
#glossary("glossary.yml")
#pagebreak()
#include "index.typ"
#pagebreak()
#bibliography("bibfile.bib")
