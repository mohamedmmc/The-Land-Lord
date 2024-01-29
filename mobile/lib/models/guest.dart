class Guest {
  int adults;
  int children;
  int infants;
  int pets;

  Guest({this.adults = 1, this.children = 0, this.infants = 0, this.pets = 0});

  String get total => '${adults + children + infants + pets} Guests';
}
