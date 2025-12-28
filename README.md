__Nod__ is a new object-oriented language designed from the start to be a fresh and practical alternative to the _status quo_. The goal is to balance real-world trade-offs in a language that is uniquely regular (consistent), efficient (fast), reliable (precautious), and convenient (automatic).  While __Nod__ respects the past, it's not beholden to it. You might say that __Nod__ sidesteps its predecessors with a respectful _nod_.

__Nod__ has wide applicability, but it's particularly well-suited for building low-level infrastructure that runs on multiple platforms.  A keen awareness of portability issues allows many applications to be written without regard to runtime platform, while kernel abstraction and access to the native kernel provide the ultimate ability to go low. Furthermore, built-in modularity provides a simple and robust path for evolution and expansion of the __Nod__ universe.  

This repository contains the __Nod Standard Library__ which is a collection of reference books that encode essential types and resources that all __Nod__ applications will find useful.  

__Alpha__ contains pages in a book of fundamental and opaque types. All __Nod__ applications are based on alpha types.

__Kernel__ contains pages in a book of system routines.  Kernel routines provide a low-level interface to the runtime platform.

__Stock__ contains pages in a book of useful and indispensable types and objects. Stock pages are written in __Nod__ and provide a good look into __Nod__ programming.

You can find the __Nod PDF Design Reference__ here:  https://drive.google.com/file/d/11m9IEDjXCbyudYy4i_SpdtwWF2pQ4n59/view?usp=drive_link

To orient for a quick peek, here are some notes to help make sense of the code:

1.  Single-line side remarks start with a double-hyphen -- (they're ignored).
2.  Multi-line narratives are enclosed by matching double-curly brackets {{&nbsp;}} (they're also ignored).
3.  A literal is a string of characters enclosed by single-quotes.  Literals are hard-coded application strings that mostly represent original object values, but they have other purposes.  In __Nod__, literals are generally opaque to the compiler and they might not be evaluated until runtime.
4. An expression delimited by square brackets [] usually encloses one or more keywords that qualify a nearby definition. These expressions are always optional and often aren't written when defaults are sufficient. 
5.  There are two kinds of procedures: method and subroutine.  Methods are associated with a particular object type while subroutines aren't.
6.  A procedure interface definition can be elaborate, but the most important feature to recognize is enumeration of inputs and outputs in separate parenthesized lists. The key take-away: inputs have proper value when the procedure starts and outputs don't. Outputs are generally initialized before the procedure returns, but not always.
7.  At the most basic level, writing a procedure amounts to creating (instantiating) objects and calling methods that initialize, evaluate, and update the value of those objects.  These basic operations can be combined with other familiar forms to branch in various ways (__if__/__else__, __loop__, __select__).  You'll also see other imperative expressions like __return__, __escape__, __quit__, __for each__, and __isolate__/__trap__.
8.  Every type has at least one standard method named _begin_.  Furthermore, any method named _begin_ is presumed to initialize the object for which it's called.
9.  To create an object, write its type followed by its name:&nbsp;&nbsp;&nbsp;&nbsp;  _int_ _x_
10.  To call a method, reference an object and method by name separated by a colon, passing inputs and outputs as required:&nbsp;&nbsp;&nbsp;&nbsp; _x_:_begin_( '0' )
11.  Method calls can be chained. This works because calling a method results in a reference to the object that led the call. Combining the previous examples and another call in one flow:&nbsp;&nbsp;&nbsp;&nbsp;_int_ _x_:_begin_( '0' ):_add_( '1' )
12.  _io_ is a common reference to a method's __implicit object__ (similar to _this_ or _self_ in other OO languages).  When followed by a dot (.), the reference refers to a sub-object in the implicit object.  Sub-objects are enumerated in a type's __instance__ definition.
13.  A proxy is a kind of reference entity that joins an object at runtime.  A proxy isn't an object, but it has a name, and that name becomes an alias for the object. Thus, a proxy reference is an indirect reference to the joined object. By convention, proxy names have a leading squiggle.  For example, _~thing_. 
14.  A formula is an expression enclosed by double-quotes.  Formulas "calculate" objects using syntax that follows traditional operator and function call syntax.  Formulas are translated into equivalent method calls and the language of formulas is completely extensible. Here is a formula that calculates the tangent of _x_ using _sin_ and _cos_ function calls, where the functions are backed by methods of the same name:&nbsp;&nbsp;&nbsp;&nbsp;"_sin_(_x_)/_cos_(_x_)" .  Formulas are very common in conditional expressions:&nbsp;&nbsp;&nbsp;&nbsp;if ( "a |=| b" )   
15. Formula operators are extensible and delimited by vertical bars ||.  Non-formula operators are mostly eschewed, but __Nod__ has 3 intrinsic operators:  _join_ ( lexical token -> ), _assign_ ( lexical token := ), and _as_ ( lexical keyword ). Of the three, only _join_ can't be written as an equivalent method call sequence.
16. __Nod__ supports generic programming using special rules for names and references.  An identifier that has embedded angle brackets <> is a generic name or adhoc reference that incorporates configurable definition factors.  This is an advanced topic that resists summary, but the main take-away is that angle-brackets in the code indicate generic definition or compile-time configuration. 

That's it.  For more information, dive into the Design Reference. It's all there.  

