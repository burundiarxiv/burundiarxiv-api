categories = ['POPULATION',
'HABITAT ET CONDITIONS DE VIE',
'ENVIRONNEMENT',
'SANTE ET NUTRITION',
'PROTECTION SOCIALE',
'EMPLOI',
'ENSEIGNEMENT',
'TOURISME ET HOTELLERIE',
'PRODUCTION',
'TRANSPORT ET TELECOMMUNICATION',
'EAU, ENERGIE ET MINES',
'PRIX ET INDICES DES PRIX',
'COMMERCE EXTERIEUR ET AIDES',
'BALANCE DES PAIEMENTS',
'FINANCES PUBLIQUES',
'MONNAIE ET CREDITS',
'COMPTES ECONOMIQUES',
'BANQUES ET ASSURANCES COMMERCIALES',
'JUSTICE',
'SECURITE PUBLIQUE',
'DIPLOMATIE']

datasets = []

categories.first(10).each do |category|
  rand(5..15).times do
    dataset =   {
      "category": category,
      "name": Faker::Book.unique.title,
      "path": "api.burundiarxiv.org/datasets/isteebu-annuaire-2018-19-02.csv"
    }

    datasets << dataset
  end
end


pp datasets
