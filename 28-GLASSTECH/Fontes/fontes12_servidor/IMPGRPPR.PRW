#include "PROTHEUS.CH"
#include 'topconn.ch'

Static cBDGSTQ	:= "" //Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= "" //GetMv("MV_TWINENV")
Static cBVGstq	:= "" //Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)

Static cProd	:= ""
/*/{Protheus.doc} IMPGRPPR
//TODO Rotina de sincronização do Grupo de Produtos do Gestoq com o Protheus.
@author Pirolo
@since 02/06/2020
@return return, return_description
/*/
User Function IMPGRPPR(aParam)
Local aPergs    := {}
Local aRet 		:= {}
Local lForceEnv	:= Empty(FunName())
Default aParam  := {"01", "0101"}

If lForceEnv
	RpcSetType(3)
	RpcSetEnv(aParam[1], aParam[2])
Else
	cProd := Space(TamSX3("B1_COD")[1])

	aAdd( aPergs ,{1, "Produto", cProd,"@!",'',,'.T.',40,.F.})

	If ParamBox(aPergs ,"Sincronizar Produtos Gestoq",aRet)
		cProd := aRet[1]
	EndIf
EndIf



cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
cBDPROT	:= GetMv("MV_TWINENV")
cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)

Processa({|| Importa() })

Return

/*/{Protheus.doc} IMPGRPPR
//TODO Rotina de sincronização do Grupo de Produtos do Gestoq com o Protheus.
@author Pirolo
@since 02/06/2020
@return return, return_description
/*/
Static function Importa()
Local nCount 	:= 0
Local cCodGrp	:= ""

//Atualiza cadastro de Produtos
Processa({|| U_IMPPROD() })

//Grupos de Produtos
DbSelectArea("SBM")
SBM->(DbOrderNickName("CODGESTQ"))

//Produtos
DbSelectArea("SB1")
SB1->(DbSetOrder(1))

DbSelectArea("PA0")
PA0->(DbSetOrder(1))

cQry := "SELECT DISTINCT A.CODIGO, Ltrim(B.COD_GRUPO) COD_GRUPO, B.DESCRICAO "+CRLF
cQry += "FROM "+cBDGSTQ+"..MATERIAL A                           "+CRLF
cQry += "			INNER JOIN "+cBDGSTQ+"..GRUPO B             "+CRLF
cQry += "				ON(    A.ID_GRUPO    = B.ID_GRUPO)      "

If !Empty(cProd)
	cQry += "WHERE A.CODIGO = '"+cProd+"' "
EndIf

Iif(Select("QRY")>0, QRY->(DbCloseArea()) , Nil ) 

TcQuery cQry New Alias "QRY"

Count to nCount

ProcRegua(nCount)

QRY->(DbGoTop())

//Sincroniza o cadastro de grupos do GESTOQ no Protheus
While QRY->(!Eof())
	INCPROC("Analisando Grupo "+AllTrim(QRY->COD_GRUPO))
	
	//Pesquisa pelo código do gestoq
	If SBM->(!DbSeek(xFilial("SBM")+PADR(QRY->COD_GRUPO, TamSX3( "BM_CODGEST" )[1])))
		cCodGrp := PegaNum()
		
		RecLock("SBM", .T.)
			BM_FILIAL	:= xFilial("SBM")
			BM_GRUPO	:= cCodGrp
			BM_CODGEST	:= QRY->COD_GRUPO
			BM_DESC		:= QRY->DESCRICAO
		SBM->(MsUnLock())
		
		ConfirmSX8()
	EndIf
	
	INCPROC("Analisando amarração do Produto "+AllTrim(QRY->CODIGO))
	//Atualiza o grupo de produtos se necessário
	If SB1->(DbSeek(xFilial("SB1")+PADR(QRY->CODIGO, TamSX3( "B1_COD" )[1])))
		If SBM->BM_GRUPO <> SB1->B1_GRUPO 
			RecLock("SB1", .F.)
				SB1->B1_GRUPO	:= SBM->BM_GRUPO
			SB1->(MsUnLock())
		EndIf
	EndIf	
	
	QRY->(DbSkip())
EndDo

cQry := "select distinct Y1_COD, Ltrim(COD_GRUPO) COD_GRUPO "+CRLF
cQry += "from "+cBDGSTQ+"..grupo a                          "+CRLF
cQry += "		inner join "+cBDGSTQ+"..COMPRADOR b         "+CRLF
cQry += "			on(    A.ID_COMPRADOR = B.ID_COMPRADOR) "+CRLF
cQry += "		INNER JOIN "+RetSqlname("SY1")+"            "+CRLF
cQry += "			ON(    A.ID_COMPRADOR = Y1_IDGSTOQ)     "+CRLF

Iif(Select("QRY")>0, QRY->(DbCloseArea()) , Nil ) 

//Executa a query
TcQuery cQry New Alias "QRY"

//Verifica o Total de registros da query
Count to nCount

//Informa o novo tamanho da régua
ProcRegua(nCount)

//Reposiciona no primeiro registro
QRY->(DbGoTop())

While QRY->(!Eof())
	INCPROC("Criando amarração Grupo x Comprador")
	
	//Localiza o Grupo do Produto
	If SBM->(DbSeek(xFilial("SBM")+PADR(QRY->COD_GRUPO, TamSX3( "BM_CODGEST" )[1])))
		
		If PA0->(DbSeek(xFilial("PA0")+SBM->BM_GRUPO))
			RecLock("PA0", .F.)
		Else
			RecLock("PA0", .T.)
		EndIf
		
			PA0->PA0_FILIAL	:= xFilial("PA0")
			PA0->PA0_CODCOM	:= QRY->Y1_COD
			PA0->PA0_GRUPO	:= SBM->BM_GRUPO
		
		PA0->(Msunlock())
	EndIf
	
	QRY->(DbSkip())
EndDo

RelacGrupCom()

Return

Static Function PegaNum
Local cNum 		:= GetSxeNum("SBM", "BM_GRUPO")
Local aAreaSBM	:= SBM->(GetArea())

DbSelectArea("SBM")
SBM->(DbSetOrder(1))

//Enquanto encontrar o numero, pega o proximo
While SBM->(DbSeek(xFilial("SBM") + cNum))
	//Confirma o numero retornado
	ConfirmSX8()
	
	//Pega o proximo numero
	cNum 		:= GetSxeNum("SBM", "BM_GRUPO")
EndDo

RestArea(aAreaSBM)
Return cNum

Static Function RelacGrupCom
Local cQry := ""

cQry := "UPDATE C                                       "+CRLF
cQry += "SET B1_GRUPCOM = AJ_GRCOM                      "+CRLF
cQry += "from PA0010 A                                  "+CRLF
cQry += "		INNER JOIN SY1010 B                   	"+CRLF
cQry += "			ON(    PA0_FILIAL = Y1_FILIAL 		"+CRLF
cQry += "			   AND PA0_CODCOM = Y1_COD    		"+CRLF
cQry += "			   AND A.D_E_L_E_T_ = ' '     		"+CRLF
cQry += "			   AND B.D_E_L_E_T_ = ' ')    		"+CRLF
cQry += "		INNER JOIN SB1010 C                   	"+CRLF
cQry += "			ON(    PA0_FILIAL = B1_FILIAL 		"+CRLF
cQry += "			   AND PA0_GRUPO  = B1_GRUPO  		"+CRLF
cQry += "			   AND C.D_E_L_E_T_ = ' ')    		"+CRLF
cQry += "		INNER JOIN SAJ010 D                   	"+CRLF
cQry += "			ON(    AJ_FILIAL = Y1_FILIAL  		"+CRLF
cQry += "			   AND AJ_USER   = Y1_USER    		"+CRLF
cQry += "			   AND D.D_E_L_E_T_ = ' ')    		"+CRLF

TcSqlExec( cQry )

Return


User Function IMPPROD()
Local cQry 	:= ""
Local cUM	:= ""

cQry := "select	A.CODIGO B1_COD, A.DESCRICAO B1_DESC, B.UN B1_UM, RTRIM(C.COD_GRUPO) BM_CODGEST, A.CLASS_FISCAL B1_POSIPI, '01' B1_LOCPAD, "+CRLF
cQry += "		CASE                                                                                                           "+CRLF
cQry += "			WHEN C.COD_GRUPO LIKE '  100_' OR C.COD_GRUPO LIKE '  700_' THEN 'MC'                                      "+CRLF
cQry += "			ELSE ''                                                                                                    "+CRLF
cQry += "		END B1_TIPO,                                                                                                   "+CRLF
cQry += "'2' B1_GARANT                                                                                                         "+CRLF
cQry += "from "+cBDGSTQ+"..MATERIAL A                                                                                          "+CRLF
cQry += "		INNER JOIN "+cBDGSTQ+"..UN_MEDIDA B                                                                            "+CRLF
cQry += "			ON(    A.ID_UN_MEDIDA = B.ID_UN_MEDIDA)                                                                    "+CRLF
cQry += "		INNER JOIN "+cBDGSTQ+"..GRUPO C                                                                                "+CRLF
cQry += "			ON(    A.ID_GRUPO = C.ID_GRUPO)                                                                            "+CRLF

If !Empty(cProd)
	cQry += "WHERE A.CODIGO = '"+cProd+"' "
EndIf

Iif(Select("QRY")>0, QRY->(DbCloseArea()) , Nil ) 

//Executa a query
TcQuery cQry New Alias "QRY"

//Verifica o Total de registros da query
Count to nCount

//Informa o novo tamanho da régua
ProcRegua(nCount)

//Reposiciona no primeiro registro
QRY->(DbGoTop())

DbSelectArea("SB1")
SB1->(DbSetOrder(1))

While QRY->(!Eof())
	INCPROC("Atualizando cadastro de Produtos")

	//Efetua de para da unidade de medida
	cUM := AllTrim(DeParaUM(QRY->B1_UM))
	
	If SB1->(DbSeek(xFilial("SB1")+Upper(QRY->B1_COD)))
		
		//Verifica se os campos atualizaveis foram alterados
		If AllTrim(SB1->B1_DESC) <> AllTrim(QRY->B1_DESC) .OR. AllTrim(SB1->B1_UM) <> cUM
			RecLock("SB1", .F.)
				SB1->B1_DESC := QRY->B1_DESC
				SB1->B1_UM	 := cUM
			SB1->(MsUnlock())
		EndIf
	Else
		RecLock("SB1", .T.)
			SB1->B1_FILIAL	:= xFilial("SB1")
			SB1->B1_COD		:= UPPER(QRY->B1_COD)
			SB1->B1_DESC 	:= QRY->B1_DESC
			SB1->B1_UM		:= cUM
			SB1->B1_POSIPI	:= QRY->B1_POSIPI
			SB1->B1_LOCPAD	:= QRY->B1_LOCPAD
			SB1->B1_TIPO	:= QRY->B1_TIPO
			SB1->B1_GARANT	:= QRY->B1_GARANT
		SB1->(MsUnlock())
	
	EndIf
	
	QRY->(DbSkip())
EndDo
Return

Static Function DeParaUM(cUnGstq)
Local cRet := ""
Local aUnDepara := {{"%          ", "UN"},;
					{"BB         ", "BB"},;
					{"BD         ", "BD"},;
					{"BL         ", "BL"},;
					{"           ", "BO"},;
					{"BR         ", "BR"},;
					{"CDA        ", "UN"},;
					{"CENTO      ", "CT"},;
					{"           ", "CC"},;
					{"CHP        ", "CH"},;
					{"CJ         ", "CJ"},;
					{"           ", "CM"},;
					{"CX         ", "CX"},;
					{"DIA        ", "DM"},;
					{"           ", "DZ"},;
					{"           ", "EM"},;
					{"FDO        ", "FD"},;
					{"           ", "FL"},;
					{"FRS        ", "FR"},;
					{"           ", "FT"},;
					{"           ", "G "},;
					{"GL         ", "GL"},;
					{"           ", "GZ"},;
					{"HR         ", "HR"},;
					{"JG         ", "JG"},;
					{"KG         ", "KG"},;
					{"           ", "KT"},;
					{"           ", "L "},;
					{"LAT        ", "LA"},;
					{"           ", "LB"},;
					{"LT         ", "LT"},;
					{"M2         ", "M2"},;
					{"M3         ", "M3"},;
					{"           ", "MH"},;
					{"MIL        ", "MI"},;
					{"ML         ", "ML"},;
					{"           ", "MM"},;
					{"           ", "PA"},;
					{"MT         ", "MT"},;
					{"MTS        ", "M3"},;
					{"MWH        ", "MW"},;
					{"           ", "  "},;
					{"PC         ", "PC"},;
					{"           ", "PL"},;
					{"PAR        ", "PR"},;
					{"PCT        ", "PT"},;
					{"RL         ", "RL"},;
					{"SC         ", "SC"},;
					{"SERV       ", "SE"},;
					{"           ", "SS"},;
					{"           ", "SV"},;
					{"           ", "TL"},;
					{"TON        ", "TO"},;
					{"UN         ", "UN"},;
					{"           ", "YD"},;
					{"VD         ", "  "}}

Local nPos    := aScan( aUnDepara,{ |x| AllTrim(x[1]) == AllTrim(cUnGstq) } )  

If nPos == 0 .OR. Empty(aUnDepara[nPos, 2])
	If IsBlind()
		QOUT("Não localizada uma unidade de medida no protheus para o código "+cUnGstq)
	else
		MsgAlert("Não localizada uma unidade de medida no protheus para o código "+cUnGstq)
	EndIf
Else 
	cRet := aUnDepara[nPos, 2]
EndIf

Return cRet
