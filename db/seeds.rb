# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Profile.create([{ name: 'Décideur', shortcut: 'DEC' }, { name: 'Entreprise', shortcut: 'ENT' }, { name: 'Administrateur', shortcut: 'ADM' }])

SalesArea.create([{name: "Informatique / Télécoms", user_id: 1}, {name: "Marketing", user_id: 1}])

Sector.create([{name: "Privé", user_id: 1}, {name: "Public", user_id: 1}, {name: "Diaspora", user_id: 1}])

SocialStatus.create([{name: "SA", user_id: 1}, {name: "SARL", user_id: 1}, {name: "SNC", user_id: 1}, {name: "SCS", user_id: 1}])

UpdateType.create([{name: "create", user_id: 1}, {name: "update", user_id: 1}])

HiringType.create([{name: "CDD"}, {name: "CDI"}])

HiringStatus.create([{name: "Salarié"}])

Membership.create([{name: "Comité de Direction"}, {name: "Comité d'Administration"}, {name: "Comité d'Audit"}, {name: "Aucun"}])

Civility.create([{name: "M."}, {name: "Mme"}])

MaritalStatus.create([{name: "Marié(e)"}, {name: "Célibataire"}, {name: "Divorcé(e)"}, {name: "Veuf(ve)"}])

