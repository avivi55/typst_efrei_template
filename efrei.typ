/// This program is free software. It comes without any warranty, to
///   the extent permitted by applicable law. You can redistribute it
///   and/or modify it under the terms of the Do What The Fuck You Want
///   To Public License, Version 2, as published by Sam Hocevar. See
///   http://www.wtfpl.net/ for more details.

#import "@preview/showybox:2.0.4": showybox

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#import "@preview/cetz:0.3.4"



#let courses = (
  default: (name: [], color: black),
  eco_conception: (name: [Éco-Conception Électronique], color: olive),
  sys_emb_av: (name: [Systèmes Embarqués Avancés], color: black),
  
  innovation_prj: (name: [Innovation Project], color: black),
  parcours_recherche: (name: [Parcours recherche], color: black),
  
  buisness: (name: [Business model & Business plan], color: black),
  management: (name: [Management], color: black),
  marketing: (name: [Innovation et Marketing], color: black),
  anglais: (name: [Anglais], color: black),

  ai_ros: (name: [AI & ROS], color: black),
  ctrl_cmd: (name: [Contrôle commande], color: black),
  robo_mobile: (name: [Robotique mobile avancée], color: black),
  vision_robot: (name: [Vision robotique et analyse], color: black),
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
  title: [],
  subtitle: [],
  subject: courses.default,
  authors: (),
  theme: "old",
  doc,
) = {

  if type(subject.color) != color {
    panic([subjet.color is not a color but a #type(subject.color)])
  }

  // setup

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

  ////

  // title page

  set align(center)
  image("logo_efrei.png", height: 80pt)

  v(1fr)

  text(size: 15pt, strong(subject.name))
  linebreak()
  line(length: 80%, stroke: 2pt + subject.color)

  text(17pt, title)
  linebreak()
  text(13pt, subtitle)

  line(length: 80%, stroke: 2pt + subject.color)

  v(1fr);v(1fr)

  let count = authors.len()
  if type(authors) == array {
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 24pt,
      ..authors.map(author => [
        #author
      ]),
    )
  }

  if type(authors) == str {
    authors
  }

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

  if overwrite_counter != none and type(overwrite_counter) == int {
    question_counter.update(overwrite_counter)
  } else {
    question_counter.step()
  }

  // as the ex. counter is incremented when called,
  // the current value is a step above the one we want
  let counter = [#(exercise_counter.get().at(0)-1).#question_counter.display()]
  
  title = if raw_title == "" or raw_title == [] { [] } else { raw_title }
  counter = if unnumbered [] else [ #exercise_counter.display().#question_counter.display() ]
  
  let stylized_title = if counter == [] or title == [] {[#counter#title]} else {[#counter -- #title]} 
  let colored_box_theme = custom_box(theme_color.get())

  showybox(
    ..colored_box_theme.at(theme_box.get(), default: colored_box_theme.old),
    breakable: true,
    title: text(9pt, v(-0.3em) + heading(stylized_title, depth: 3) + v(-0.3em)),
    ..body,
  )
}
