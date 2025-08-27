__Nod__ is a new object-oriented programming language that gives a _nod_ to predecessors without being trapped by their legacy. It strives to be a fresh and practical language suitable for systems programming and beyond.  The goal is to balance real-world trade-offs in a language that is uniquely regular (consistent), efficient (fast), reliable (precautious), and convenient (automatic).

This repository contains the __Nod Standard Library__ which is a collection of reference "books" that encode essential types and resources that all __Nod__ applications will find useful.  

__Alpha__ contains pages in a book of fundamental and opaque types. All __Nod__ applications are based on alpha types.

__Kernel__ contains pages in a book of system routines.  Kernel routines provide a low-level interface to the runtime platform.

__Stock__ contains pages in a book of useful and indispensable types and objects. Stock pages are written in __Nod__ and provide a good look into __Nod__ programming.

You can find the __Nod PDF Design Reference__ here:  https://drive.google.com/file/d/1Kv6-Jv9uvsKS8tQcFzsryOwvN0Fr_EH-/view?usp=drive_link

To orient you for a quick peek, here are some notes to help make sense of the code:

1.  A literal is a string of characters enclosed by single-quotes.  Literals are hard-coded application strings that mostly represent original object values, but they have other purposes.  In __Nod__, literals are generally opaque to the compiler and they might not be evaluated until runtime.
2.  Side remarks start with a double-hyphen -- and they're ignored. 
3.  There are two kinds of procedures: method and subroutine.  Methods are associated with a particular object type while subroutines aren't.
4.  A procedure interface definition can be elaborate, but the most important feature to recognize is enumeration of inputs and outputs in separate parenthesized lists. The key take-away: inputs are initialized on entry and outputs aren't.
5.  At the most basic level, writing a procedure amounts to creating (instantiating) objects and calling methods that initialize, evaluate, and update the value of those objects.  These basic operations can be combined with other familiar forms to branch in various ways (__if__/__else__, __loop__, __select__).  You'll also see other imperative expressions like __return__, __escape__, __quit__, __for each__, and __isolate__/__trap__.
6.  Every type has at least one standard method named _begin_.  Furthermore, any method named _begin_ is presumed to initialize the object for which it's called.
7.  To create an object, write it's type followed by it's name:&nbsp;&nbsp;&nbsp;&nbsp;  _int_ _x_
8.  To call a method, reference an object and method by name separated by a colon, passing inputs and outputs as required:&nbsp;&nbsp;&nbsp;&nbsp; _x_:_begin_( '0' )
9.  Method calls can be chained. This works because the "result" of calling a method is the same object that led the previous call. Combining  previous examples and another call in one flow:&nbsp;&nbsp;&nbsp;&nbsp;_int_ _x_:_begin_( '0' ):_add_( '1' )
10.  A proxy is a kind of reference entity that joins to an object at runtime.  A proxy isn't an object, it's an alias, and as an alias it can generally be used wherever it's joined object can be used.
11.  A formula is an expression enclosed by double-quotes.  A formula "calculates" a single object value using syntax that follows traditional operator and function call syntax.  Formulas are translated into equivalent method calls and the language of formulas is completely extensible. Here is a formula that calculates the tangent of x using sine and cosine methods:&nbsp;&nbsp;&nbsp;&nbsp;"sin(x)/cos(x)" 
12. Operators in formulas are delimited by vertical bars ||.  __Nod__ has 3 intrinsic (non-formula) operators:  _join_, _assign_, and _as_.  _join_ is associated with the lexical token ->.  _assign_ is associated with the lexical token <=.  _as_ is associated with the same lexical keyword.  Of the three, only _join_ can't be written as an equivalent method call sequence.
13. __Nod__ supports generic programming using special rules for names and references.  An identifier that has embedded angle brackets <> is a generic name or adhoc reference that incorporates configurable definition factors.  This is an advanced topic that resists summary, but the main take-away is that angle-brackets in the code indicate generic definition or compile-time configuration. 

That's it.  For more information, dive into the Design Reference. It's all there.  

