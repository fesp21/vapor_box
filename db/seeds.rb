# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Accessory.create(:name => 'Coils', :cost => 500, :image => 'assets/checkout/coils.jpg')
Accessory.create(:name => 'Protank 2', :cost => 2000, :image => 'assets/checkout/protank2.jpg')
Accessory.create(:name => 'Protank Mini', :cost => 1500, :image => 'assets/checkout/protank1.jpg')
Flavor.create(:name => 'Fruit', :level => 'Low (6mg)', :image => 'assets/checkout/fruit.jpg')
Flavor.create(:name => 'Dessert', :level => 'Low (6mg)', :image => 'assets/checkout/dessert.jpg')
Flavor.create(:name => 'Tobacco', :level => 'Low (6mg)', :image => 'assets/checkout/tobacco.jpg')
Flavor.create(:name => 'Menthol', :level => 'Low (6mg)', :image => 'assets/checkout/menthol.jpg')
Flavor.create(:name => 'Fruit', :level => 'High (12mg)', :image => '')
Plan.create(:name => 'Two Flavors', :cost => 1900, :flavor_count => '2', :image => 'assets/checkout/box-small-transparent.png')
Plan.create(:name => 'Three Flavors', :cost => 2900, :flavor_count => '3', :image => 'assets/checkout/box-medium-transparent.png')
Plan.create(:name => 'Four Flavors', :cost => 3900, :flavor_count => '4', :image => 'assets/checkout/box-big-transparent.png')