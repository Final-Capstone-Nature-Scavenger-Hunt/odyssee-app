class HuntItem{
  final String huntName;
  final String description;
  final String hint;
  final String huntImage;
  final double rarityScore;
  final double endemic;
  final double predator;
  final double scavenger;
  final double decomposer;
  final double carbonHungry;

  HuntItem({this.huntName, this.description, this.hint, this.huntImage, this.rarityScore,
          this.carbonHungry, this.endemic, this.decomposer, this.predator, this.scavenger});
}