#import "@local/efrei:0.1.0": *


#show: report.with(
  title: [Title],
  subtitle: [subtitle],
  subject: (name: "Example", color: eastern),
  authors: ("This guy", "That gal"),
  theme: "gauss"
)


#exercise[Concepts of encapsulation, inheritance, and polymorphism]

#question[Encapsulation][
  Encapsulation is the way, in Java, the user can assign an *access modifier* to limit the visibility of certain attributes or methods
]

#question[Setter and Getter][
  #columns(2)[
    *Setter*

    The setter method is a method used to make a private attribute writable by users. 

    #colbreak()

    *Getter*

    The getter method is a method used to make a private attribute readable by users.

  ]
]

#question[`this`][
  *this*

  `this` is an implicit parameter passed when calling a method of an object
]

#question(lorem(2), unnumbered: true)[
  #lorem(10)
]

#question("")[
  #lorem
]