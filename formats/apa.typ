#import "util.typ": *

// BUG: there is a bug in typst that prevents paragraphs following a heading from being indented
// see: https://github.com/typst/typst/issues/311
// as a workaround, just add a #h(2em) in front of the paragraph to indent it
#let apa(
	title: "Paper Title",

	// A list of authors, each with a name and an optional affiliation:
	// { name: "Author Name", affiliation: "Affiliation" }
	// or an affiliation can be derived from department and organization:
	// { name: "Author Name", department: "Department", organization: "Organization" }
	authors: (),

	running-head: none,

	course: none,

	instructor: none,

	due-date: none,

	abstract: none,

	paper-size: "us-letter",

	bibliography-file: none,

	body,
) = {
	assert(running-head == none or running-head.len() <= 50, message: "running-head must be 50 characters or less")

	set document(title: title, author: authors.map(author => author.name))

	let font-size = 12pt
	// "STIX Two Text" is a non-proprietary version of Times New Roman
	set text(font: "STIX Two Text", size: font-size)

	// APA style requires double-spacing
	set par(
		leading: 2em,
		first-line-indent: 2em,
	)

	// set par(
	// 	hanging-indent:-2em,
	// )
	// show par: set block(
	// 	inset: (
	// 		left: 3in,
	// 	)
	// )

	set page(
		paper: paper-size,
		margin: 1in,
		header: {
			if (running-head != none) {
				upper(running-head)
			} else {
				none
			}
			h(1fr)
			counter(page).display("1")
		},
		footer: none,
		numbering: "1",
		number-align: right + top,
	)

	show heading: it => {
		set text(size: font-size, weight: "bold")
		if it.level == 1 {
			set align(center)
			it
		} else if it.level == 2 {
			it
		} else {
			set align(left)
			if it.level == 3 {
				set text(style: "oblique")
				it
			} else {
				panic("unsupported heading level -- level 4 and 5 headings are supposed to be inline headings. Just make the text bold for level 4, and additionally italic for level 5 manually.")
				// if it.level == 5 {
				// 	set text(style: "oblique")
				// 	it.body
				// } else {
				// 	it.body
				// }
			}
		}

		// HACK: there is a bug in typst that prevents paragraphs following a heading from being indented
		// see: https://github.com/typst/typst/issues/311
		par()[#text(size:1em)[#h(0.0em)]]
	}

	// APA style has this really annoying requirement for how authors and affiliations are displayed.
	// https://apastyle.apa.org/style-grammar-guidelines/paper-format/title-page
	authors = authors.map(author => {
		if "affiliation" in author {
			author
		} else {
			author.affiliation = (author.department, author.organization).join(", ")
			author
		}
	})
	let unique_affiliations = unique(authors.map(author => author.affiliation))
	let show_affiliation_refs = unique_affiliations.len() > 1

	set align(center)
	v(6em)
	heading(title)
	v(2em)

	block()[
		#authors.map(author => {
			author.name
			if show_affiliation_refs {
				super(str(unique_affiliations.position(aff => aff == author.affiliation) + 1))
			}
		}).join(", ", last: " and ")
	]

	for (i, aff) in unique_affiliations.enumerate() {
		block()[
			#if show_affiliation_refs {
				super(str(i + 1))
				aff
			} else {
				aff
			}
		]
	}

	if (course != none) {
		block()[
			#course
		]
	}

	if (instructor != none) {
		block()[
			#instructor
		]
	}

	if (due-date != none) {
		block()[
			#due-date.display("[month repr:long] [day], [year repr:full]")
		]
	}

	pagebreak()

	set align(left)
	if (abstract != none) {
		heading("Abstract")
		abstract
		pagebreak()
	}

	heading(title)
	body

	if (bibliography-file != none) {
		bibliography(
			bibliography-file,
			title: "References",
			style: "apa",
		)
	}
}

