hive
    by Bryce Kerley
    http://worldmedia.net/

== DESCRIPTION:

Hive is a versioned store for hashes and other yamlizable ruby objects.

== FEATURES/PROBLEMS:

Stores 

== SYNOPSIS:

  >> public = Hive.new('public.hive', 'console_user')
  #=> public.inspect
  >> bryce = public['bryce']
  #=> bryce hash
  >> bryce['awesome'] = true
  #=> true
  >> bryce.save
  #=> bryce hash
  >> bryce.history
  #=> array of history items
  >> bryce.history.first
  #=> grit.commit.inspect
  >> newguy = public['newguy']
  #=> empty newguy hash

== REQUIREMENTS:

* git (Built and tested with 1.5.5)
* shoulda (Bundled in vendor/shoulda)
* grit (Bundled in vendor/grit)

== INSTALL:

clone from git?

== LICENSE:

dunno