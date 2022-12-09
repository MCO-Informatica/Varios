User Function TK271FIL(cAlias)

    Local _aArea  := GetArea()
    Local _aGrupo := UsrRetGrp(,RetCodUsr())
    Local _cGrupo := IIF(__cUserID$"000000","000003",IIF(Empty(_aGrupo), " ",_aGrupo[1])) //Iif(__cUserID$"000000","000003",_aGrupo[1])
    Local _cFiltro:= ""

//Alert("SUA="+str(len(AllTrim(SUA->UA_X_USERS)))+"  "+SUA->UA_X_USERS)
//Alert("cUserName"+str(len(AllTrim(cUserName)))+"  "+cUserName)

//----> GRUPO OPERACIONAL / GRUPO CALL CENTER
    If cAlias == "SUA" .And. Alltrim(_cGrupo)$"000002.000004"
        _cFiltro := "SUA->UA_NUM > ''"	//"Alltrim(SUA->UA_X_USERS) $ '"+Alltrim(cUserName)+"'"
    Elseif cAlias == "SUA" .And. Alltrim(_cGrupo) = " "
        _cFiltro := "SUA->UA_NUM > ''"
    else
        _cFiltro := "SUA->UA_NUM > ''"
    EndIf

Return (_cFiltro)
