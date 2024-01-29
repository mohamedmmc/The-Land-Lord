enum PropertyFilterSteps {
  where('Where to?'),
  checkin('Check In'),
  checkout('Check Out'),
  guest('Who?');

  final String value;

  const PropertyFilterSteps(this.value);
}
