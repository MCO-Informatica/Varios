 

User Function LocNfe()
Local lRet    := .T. 
Local cLocal  := &(ReadVar())
Local nPosCod := aScan(aHeader,{|x|Alltrim(x[2])=="D1_COD"})
Local cProduto := Acols[n][nPosCod]
Local aArea   := GetArea()
Local cLiberados := Alltrim(GetMv("ES_LOCNFE"))+"/000000"

// Verifica se Almoxarifado é S1 e usuario DOUGLAS MIGUEL/Administrador/TOTALIT2015
if cLocal = 'S1' 
	if ! __cUserId $ cLiberados //<> '000000' .and. __cUserId <> '000011'.and. __cUserId <> '000491'
 		Aviso("Atenção", "O usuario não tem permissão para este almoxarifado",{"Ok"})
 		lRet := .F.
 	endif
endif

if lRet .and. ! __cUserId $ cLiberados //.and. __cUserId <> '000000' .and. __cUserId <> '000011'.and. __cUserId <> '000491' 
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !MsSeek(xFilial("SB2")+cProduto+cLocal,.F.)
 		Aviso("Atenção", "O produto "+Alltrim(cProduto)+" não existe neste almoxarifado, escolha outro almoxarifado ou crie o saldo no almoxarifado desejado!",{"Ok"})
 		lRet := .F.
	endIf
endif

RestArea(aArea)    

  
Return lRet