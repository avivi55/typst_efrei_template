/// This program is free software. It comes without any warranty, to
///   the extent permitted by applicable law. You can redistribute it
///   and/or modify it under the terms of the Do What The Fuck You Want
///   To Public License, Version 2, as published by Sam Hocevar. See
///   http://www.wtfpl.net/ for more details.

#import "@preview/showybox:2.0.4": showybox
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot, chart
#import "@preview/splash:0.5.0": xcolor
#import "@preview/mannot:0.3.0": *
#import "@local/shapemaker:0.1.0":*

#let courses = (
  default: (name: "", color: black),
  eco_conception: (name: "Éco-Conception Électronique", color: olive),
  sys_emb_av: (name: "Systèmes Embarqués Avancés", color: xcolor.jungle-green),
  
  innovation_prj: (name: "Innovation Project", color: black),
  parcours_recherche: (name: "Parcours recherche", color: xcolor.cadet-blue),
  
  buisness: (name: "Business model & Business plan", color: xcolor.dandelion),
  management: (name: "Management", color: xcolor.melon),
  marketing: (name: "Innovation et Marketing", color: xcolor.apricot),
  anglais: (name: "Anglais", color: xcolor.peach),

  ai_ros: (name: "AI & ROS", color: xcolor.lavender),
  ctrl_cmd: (name: "Contrôle commande", color: xcolor.mahogany),
  robo_mobile: (name: "Robotique mobile avancée", color: xcolor.plum),
  vision_robot: (name: "Vision robotique et analyse", color: xcolor.wild-strawberry),
)

#let theme_color = state("theme-color", luma(0))

#let theme_box = state("theme-box", "old")
#let custom_box(color) = (
  gauss: (
    title-style: (
      color: color.darken(30%),
      sep-thickness: 0pt,
      align: center,
    ),
    frame: (
      title-color: color.lighten(85%),
      border-color: color,
      thickness: (left: 2pt),
      radius: 0pt,
    ),
  ),
  old: (
    title-style: (
      sep-thickness: 0pt,
    ),
    frame: (
      title-color: color,
      thickness: 0pt,
      radius: 4pt,
      body-color: color.lighten(90%),
    ),
  )
)

#let exercise_counter = counter("exercise-counter")
#let question_counter = counter("question-counter")

#let report(
  title: "",
  subtitle: "",
  subject: courses.default,
  authors: (),
  theme: "old",
  doc,
) = {

  if type(subject.color) != color {
    panic([subject.color is not a color but a #type(subject.color)])
  }

  // setup

  show math.equation:it => {
    if it.has("label") {
      // Don't forget to change your numbering style in `numbering`
      // to the one you actually want to use.
      math.equation(block: true, numbering: "(1)", it)
    } else {
      it
    }
  }

  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      link(el.location(), numbering(
        // don't forget to change the numbering according to the one
        // you are actually using (e.g. section numbering)
        "(1)",
        counter(math.equation).at(el.location()).at(0) + 1
      ))
    } else {
      it
    }
  }

  codly(
    languages: codly-languages,
    zebra-fill: luma(248),
    fill: luma(255)
  )
  show: codly-init.with()

  exercise_counter.update(1)

  theme_color.update(subject.color)
  theme_box.update(theme)

  set text(font: "Arev Sans")

  if type(title) == str and type(subtitle) == str  {
    state("shape_seed").update(title+subtitle)
  }

  let color_palette = generate-palette(subject.color)

  ////

  // title page

  set align(center)
  
  shape_strip(
    number: 15,
    color_theme: color_palette,
    image_options: (
      height: 2.5em
    )
  )
  v(1fr)

  image("logo_efrei.png", height: 10%)

  v(1fr)

  text(size: 15pt, strong(subject.name))
  linebreak()
  line(length: 80%, stroke: 2pt + subject.color)

  text(17pt, title)
  linebreak()
  text(13pt, subtitle)

  line(length: 80%, stroke: 2pt + subject.color)

  v(1fr);v(1fr)



  if type(authors) == array {

    let chunks = authors.chunks(3)

    grid(
      columns: 1,
      row-gutter: 40pt,
      ..chunks.map(
        chunk => [
          #grid(
            columns: (1fr,) * chunk.len(),
            ..chunk.map(author => [ #author ]),
          )
        ]
      )
    )
  }

  if type(authors) == str {
    authors
  }

  v(1fr)

  shape_strip(
    number: 15,
    color_theme: color_palette,
    image_options: (
      height: 2.5em
    )
  )

  set align(left)
  pagebreak()

  ////

  set page(numbering: "1")

  doc
}


#let exercise(title) = context {
  [== #exercise_counter.display() --- #title]


  exercise_counter.step()
  question_counter.update(1)
}

#let question(raw_title, overwrite_counter: none, unnumbered: false, ..body) = context {
  let title = []
  let counter = []

  // let stats = word-count-of([#body])
  // state("total-words").update(state("total-words").get() + stats.words)
  // state("total-characters").update(state("total-characters").get() + stats.characters)

  if overwrite_counter != none and type(overwrite_counter) == int {
    question_counter.update(overwrite_counter)
  }

  question_counter.step()

  title = if raw_title == "" or raw_title == [] { [] } else { raw_title }

  // as the ex. counter is incremented when called,
  // the current value is a step above the one we want  
  counter = if unnumbered [] 
  else if (overwrite_counter != none and type(overwrite_counter) == int) [
    #(exercise_counter.get().at(0)-1).#overwrite_counter
  ]
  else [#(exercise_counter.get().at(0)-1).#question_counter.display()]
  
  let stylized_title = if counter == [] or title == [] {[#counter#title]} else {[#counter -- #title]} 
  let colored_box_theme = custom_box(theme_color.get())

  showybox(
    ..colored_box_theme.at(theme_box.get(), default: colored_box_theme.old),
    breakable: true,
    title: text(9pt, v(-0.3em) + heading(stylized_title, depth: 3) + v(-0.3em)),
    ..body,
  )
}

#let response_part_stroke = stroke(paint: gray, dash: "dashed")
#let partial(body) = markrect(body, stroke: response_part_stroke)