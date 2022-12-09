#Include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma: CRPA037    ºAutor  ³Renato Ruy Bernardo º Data ³  29/03/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para atualizar dados da campanha e clube.			  º±±
±±º          ³ 			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CRPA037()

Local aPergs 	:= {}
Local cCodRec 	:= space(08)
Local lRet

Private aPedidos:= {}
Private aRet 	:= {}
Private cPedIn	:= ""
Private cPerg   := "CRP037"

//ValidPerg()
//pergunte(cPerg,.T.)  

aAdd( aPergs ,{11,"Pedidos"		,"",'.T.','.T.',.F.})
aAdd( aPergs ,{ 1,"Percentual"	,0 ,"@E 999.99","","","",50,.F.})
aAdd( aPergs ,{ 1,"Link"			,Space(100) ,"@!","","","",200,.F.})
aAdd( aPergs ,{ 1,"Cod.Parceiro",Space(6) ,"@!","","","",50,.F.})
aAdd( aPergs ,{ 1,"Desc.Parceiro",Space(100) ,"@!","","","",200,.F.})
aAdd( aPergs ,{ 1,"Cod.Vendedor",Space(6) ,"@!","","","",50,.F.})
aAdd( aPergs ,{ 1,"Desc.Vendedor",Space(100) ,"@!","","","",200,.F.})

If !ParamBox(aPergs ,"Atualiza Campanha",aRet)
	Alert("A atualizacao foi cancelada!")
	Return
EndIf

//Cria um array para não estourar a quantidade de pedidos
aPedidos := StrToArray(aRet[1],chr(13)+chr(10))

Processa( {|| GerReg() }, "Selecionando registros...")

Return

//Processamento do relatório

Static Function GerReg

For nI := 1 To Len(aPedidos)
	SZ5->(DbSetOrder(1))
	If SZ5->(DbSeek(xFilial("SZ5")+aPedidos[nI])) .And. Val(aPedidos[nI]) > 0
		
		If ZZ3->(Reclock("ZZ3",.T.))
			ZZ3->ZZ3_FILIAL 	:= xFilial("ZZ3")
			ZZ3->ZZ3_DTIMP 		:= dDataBase
			ZZ3->ZZ3_PEDGAR 	:= aPedidos[nI]
			ZZ3->ZZ3_LOG    	:= cUserName+"-"+DtoC(dDataBase)+" -CRPA037- PERCENTUAL DE: " + Transform(SZ5->Z5_COMSW,"@E 999.99") + " PARA: " + Transform(aRet[2],"@E 999.99")
			ZZ3->(MsUnlock())
		EndIf
	
		RecLock("SZ5",.F.) // Define que será realizada uma alteração no registro posicionado
			SZ5->Z5_COMISS := " "
			SZ5->Z5_COMSW  := aRet[2]
			SZ5->Z5_PROCRET:= "M"
			SZ5->Z5_BLQVEN := "1"
			SZ5->Z5_DESCST := Iif(Empty(aRet[2]),SZ5->Z5_DESCST ," ")
			SZ5->Z5_DESREDE:= Iif(Empty(aRet[3]),SZ5->Z5_DESREDE,aRet[3])
			SZ5->Z5_CODPAR := Iif(Empty(aRet[4]),SZ5->Z5_CODPAR,aRet[4])
			SZ5->Z5_NOMPAR := Iif(Empty(aRet[5]),SZ5->Z5_NOMPAR,aRet[5])
			SZ5->Z5_CODVEND:= Iif(Empty(aRet[6]),SZ5->Z5_CODVEND,aRet[6])
			SZ5->Z5_NOMVEND:= Iif(Empty(aRet[7]),SZ5->Z5_NOMVEND,aRet[7])
		SZ5->(MsUnLock()) // Confirma e finaliza a operação
		
	Endif
Next

MsgInfo("A atualização dos percentuais foi finalizada!")

Return 