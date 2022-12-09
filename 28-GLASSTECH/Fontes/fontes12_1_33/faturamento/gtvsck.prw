User function gtvsck()

	Local cCodUsr := RetCodUsr()
	Local aUsuGrps := UsrRetGrp(cCodUsr)
	Local aAllGrps := AllGroups()
	Local aGrupos := {}
	Local nI	  := 0
	Local nO	  := 0

	for nI := 1 to len(aUsuGrps)
		for nO := 1 to len(aAllGrps)
			if aUsuGrps[nI] == aAllGrps[nO,1,1] 
				aadd(aGrupos,aAllGrps[nO,1,2])
			endif
		next
	next

    _lRet := .f.

	//aEval(aGrupos, {|x| lVen := iif(!lVen.and.alltrim(x)=="VEN",.t.,.f.) })

	for nI := 1 to len(aGrupos)
		if !lVen .and. alltrim(aGrupos[nI]) == "VEN"
			lVen := .t.
		endif
	next

	if lVen
		_lRet := .f.
    else
        _lRet := .t.
    endif

    RETURN(_lRet)
