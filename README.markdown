Hive
====
Versioned YAML-backed database

Hive was designed for centralized storage of user data orthogonal but related to the shove\_auth centralized
authentication system.  It uses git (through grit) to provide versioning and change tracking.

API
---

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

