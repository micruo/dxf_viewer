import 'set.dart';
import '../dxf.dart';

/// CLASSES Section
///
/// The CLASSES section of a DXF file stores data for application-defined classes.
/// These class definitions are fixed within the class hierarchy and are used to represent objects
/// in the BLOCKS, ENTITIES, and OBJECTS sections of the database.
/// All fields in this section are mandatory.
class ClassesSection extends Section {
  ClassesSection();

  factory ClassesSection.from(List<Code> codes) {
    var section = ClassesSection();
    section.from(codes);
    return section;
  }
}
