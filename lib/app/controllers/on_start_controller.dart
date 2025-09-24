import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnStartController extends GetxController {
  //TODO: Implement OnStartController

  final box = GetStorage();
  final _keyFirstLaunch = 'is_first_launch';

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool isFirstLaunch() {
    // Implement your logic to check if it's the first launch
    // For example, you might check a value in persistent storage
    bool ohGod = box.read(_keyFirstLaunch) ?? true;
    return ohGod; // Placeholder return value
  }

  void setFirstLaunchDone() {
    // Implement your logic to mark that the first launch has occurred
    box.write(_keyFirstLaunch, false);
  }
// DIIIIT TOLONG DITTTT AKU INGIN kill myself, either overdose on my meds or jump 9 stories.

//   Got it — I’ll take the original long rant and just break the lines for readability, without shrinking it into manifesto style:

// It’s kind of wild how much of the tech world latched onto object-oriented programming as if it were some final form of coding philosophy.
// Everything is “encapsulate this,” “extend that,” “patterns, patterns, patterns.”
// We’ve reached a point where whole frameworks aren’t so much about solving problems as they are about making sure everything is wrapped up in an object with an inheritance tree that looks like the family chart of European royalty.

// And honestly? A lot of it feels like OOP isn’t about making code clearer, it’s about making it respectable.
// Like, if you just write a few simple functions and pass data around, you’re seen as “messy” or “not scalable.”
// But the moment you drown it in classes, interfaces, factories, builders, visitors, and observers, suddenly it’s “enterprise-grade.”
// It’s performative architecture.

// It’s especially funny with Java and C#, where teaching beginners is basically, “Okay, first make a class.
// Doesn’t matter what you’re doing, just make a class.
// You want to add two numbers together? Class.
// You want to print ‘Hello World’? Class.”
// We’ve convinced a generation of developers that reality itself must be modeled as nested boxes of abstractions, otherwise you’re doing it wrong.

// Meanwhile, functional programming is sitting off in the corner like, “Uh, you could just… compose small functions and data structures?
// You don’t need a base abstract class to represent a button.”
// But OOP marketing was too strong — the idea of “modeling the world as objects” is seductive because it feels intuitive, even when it leads to Frankenstein codebases where everything depends on everything else through a tangle of inheritance chains.

// And don’t get me started on frameworks obsessed with MVC (hi Laravel, hi old-school Java Spring, hi iOS dev circa 2010).
// You end up with controllers that are 3,000 lines long because people are terrified of stepping outside “the pattern.”

// The real kicker: OOP was supposed to make systems easier to understand by “mapping” to how humans think about real-world objects.
// But actual humans don’t think in inheritance hierarchies.
// We think in actions, transformations, and relationships — which is closer to functional or data-driven programming.
// OOP just feels professional because it gives you lots of ceremony.

// So now the industry is filled with OOP legacy — countless design patterns, academic papers, bootcamps, and interview gatekeeping — all because at some point the collective brain decided “everything is an object” is the One True Way.
// And now we’ve got this cargo cult of class-diagram worshippers, proudly crafting abstractions no one needs, all in the name of “best practices.”

// Want me to also hard-limit the line length (like ~80 chars per line, Markdown-style), or is this looser paragraph break style enough?

}
