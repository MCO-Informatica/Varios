#include 'totvs.ch'
/*/{Protheus.doc} MTI030NOM
Ponto de entrada no fonte MATI030O - Integracao mensagem unica do Protheus
@author TOTVS
@since 19/10/2020
@version 1.0
@return aRet, Retorna aCliente e aItem do pedido.
@type function
/*/
User Function MTI030NOM()
    Local aCliente:= {}

    aCliente := F030GetCli(aClone(PARAMIXB))
Return aCliente

Static Function F030GetCli(PARAMIXB)

    Local cJson   := ''
    Local oJson   := JsonObject():New()
    Local aRet    := {}
    Local nPos    := 0
    Local ni      := 0
    Local cCpf    := ''
    Local aCli    := {}
    Local aCliente:= {}

    If Len(PARAMIXB) < 4 // se o fonte padr?o MATI030O n?o for a vers?o correta retorna o cliente.
        Return PARAMIXB[1]
    Endif

    If  Valtype(PARAMIXB[3]) <> 'C' // se n?o vier um json return
        Return PARAMIXB[1]
    Endif

    If PARAMIXB[4] <> 3 // se for diferente de inclus?o tenho que retornar o proprio array vindo do Padr?o.
        Return PARAMIXB[1]
    Endif

    aCliente:= PARAMIXB[1]
    cJson   := PARAMIXB[3]

    oJson:FromJson(cJson)
    
    nPos := AT( Upper('Content'), Upper(cJson) )
    If nPos > 0 .and.;
            Valtype(oJson['Content']) $ 'C J'.and.;
            Valtype(oJson['Content']['GovernmentalInformation']) = 'A' .and.;
            Valtype(oJson['Content']['StoreId']) = 'C'

        aRet := oJson['Content']['GovernmentalInformation']
        aRet1:= oJson['Content']['ListOfCommunicationInformation']
        aRet2:= oJson['Content']
        aRet3:= oJson['Content']['Address']
        aRet4:= oJson['Content']['Address']['City']
        aRet5:= oJson['Content']['Address']['State']
        
        For nI := 1 to Len(aRet)
            iF Upper(aRet[ni]["Name"]) = 'CPF' .or. Upper(aRet[ni]["Name"]) = 'CNPJ' .OR.  Upper(aRet[ni]["Name"]) = 'CGC'
                cCpf := aRet[ni]["Id"]
            Endif
        Next nI

        //cStoreId := oJson['Content']['StoreId'] // Loja esta sendo inclementada pela fun??o GetCodCli
        aCli     := GetCodCli(cCpf)

        If !Empty(cCpf) .and. !Empty(aCli)
            /*
            nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_COD'})
            If nPos > 0
                aCliente[nPos][2] := aCli[1] // Codigo do Cliente no SA1 pelo CPF
            Endif

            nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_LOJA'})
            If nPos > 0
                aCliente[nPos][2] := aCli[2] // Loja Atual  + 1
            else
                aAdd(aCliente, {"A1_LOJA", aCli[2], Nil})
            Endif*/
			
			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_VEND'})
            If nPos > 0
                aCliente[nPos][2] := 'C99980' 
            else
                aAdd(aCliente, {"A1_VEND", 'C99980', Nil})
            Endif

			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_VEND1'})
            If nPos > 0
                aCliente[nPos][2] := 'S99980' 
            else
                aAdd(aCliente, {"A1_VEND1", 'S99980', Nil})
            Endif

			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_CONTATO'})
            If nPos > 0
                aCliente[nPos][2] := Upper(aRet2["Name"])
            else
                aAdd(aCliente, {"A1_CONTATO", Upper(aRet2["Name"]), Nil})
            Endif

			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_INSCR'})
            If nPos > 0
                aCliente[nPos][2] := 'ISENTO' 
            else
                aAdd(aCliente, {"A1_INSCR", 'ISENTO', Nil})
            Endif

			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_DDD'})
            If nPos > 0
                aCliente[nPos][2] := Iif(aRet1[1]["PhoneNumber"] = nil,"11",Subs(aRet1[1]["PhoneNumber"],3,2))
            else
                aAdd(aCliente, {"A1_DDD", Iif(aRet1[1]["PhoneNumber"] = nil,"11",Subs(aRet1[1]["PhoneNumber"],3,2)), Nil})
            Endif

			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_SATIV1'})
            If nPos > 0
                aCliente[nPos][2] := '000119' 
            else
                aAdd(aCliente, {"A1_SATIV1", '000119', Nil})
            Endif

			/*
            nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_ENDCOB'})
            If nPos > 0
                aCliente[nPos][2] := Upper(Alltrim(aRet3["Address"]))+", "+aRet3["Number"]
            else
                aAdd(aCliente, {"A1_ENDCOB", Upper(Alltrim(aRet3["Address"]))+", "+aRet3["Number"] , Nil})
            Endif

			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_BAIRROC'})
            If nPos > 0
                aCliente[nPos][2] := Upper(Alltrim(aRet3["District"]))
            else
                aAdd(aCliente, {"A1_BAIRROC",Upper(Alltrim(aRet3["District"])) , Nil})
            Endif

			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_CEPC'})
            If nPos > 0
                aCliente[nPos][2] := Upper(Alltrim(aRet3["ZipCode"]))
            else
                aAdd(aCliente, {"A1_CEPC", Upper(Alltrim(aRet3["ZipCode"])), Nil})
            Endif

			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_MUNC'})
            If nPos > 0
                aCliente[nPos][2] := Upper(Alltrim(aRet4["CityDescripton"]))
            else
                aAdd(aCliente, {"A1_MUNC", Upper(Alltrim(aRet4["CityDescripton"])) , Nil})
            Endif

			nPos := aScan(aCliente, {|X| Alltrim(x[1]) == 'A1_ESTC'})
            If nPos > 0
                aCliente[nPos][2] := Upper(Alltrim(aRet5["StateCode"]))
            else
                aAdd(aCliente, {"A1_ESTC",Upper(Alltrim(aRet5["StateCode"])) , Nil})
            Endif*/

        Endif
    Endif


    FreeObj(oJson)

Return aCliente

Static Function  GetCodCli(cCpf)
    Local aRet   := {}
    Local cQuery := ''

    If Empty(cCpf)
        Return aRet
    Endif

    cAliasFK1   := GetNextAlias()
    cQuery += " SELECT  A1_COD, MAX(A1_LOJA) LOJA FROM " + RetSqlName("SA1") + " SA1 "
    cQuery += " where "
    cQuery += "     A1_FILIAL = '" + xFilial("SA1") + "' "
    cQuery += " AND A1_CGC = '" + Alltrim(cCpf) + "' "
    cQuery += " AND D_E_L_E_T_ = '' "
    cQuery += " GROUP BY A1_COD "

    MPSysOpenQuery(cQuery, cAliasFK1)
    If (cAliasFK1)->(!(EoF()))
        aRet := { (cAliasFK1)->A1_COD, Soma1((cAliasFK1)->LOJA) }
	Else
		aRet := { GETSXENUM("SA1","A1_COD") , StrZero(1, (TamSX3( 'A1_LOJA' )[1]))}
    Endif

    (cAliasFK1)->(dbCloseArea())

Return aRet
