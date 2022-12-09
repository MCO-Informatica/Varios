#Include 'Protheus.ch'
#Include 'TbiConn.ch'
#Include 'Fileio.ch'
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

±±ºPrograma  ³ REN00002 ºAutor  ³DanIlo José Grodzickiº Data³  20/10/2015 º±±

±±ºDesc.     ³ Ler os registros da tabela ZZT000 e gerar o registro       º±±
±±º          ³ na SE2 (contas a pagar).                                   º±±

±±ºUso       ³ Renova Energia S.A.                                        º±±

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function REN00002()

Local nRet
Local lErro
Local cQuery
local nHandler
Local cAliasTmp
Local cPrefixo   := "BPM"
Local dBaixaCmp  := Date()
Local aVetor     := {}
Local aRecPA     := {}
Local aRecSE2    := {}
Local cNomeFor   := ""
Local nA         := 0

Public _aDados     := {}  //ALTERADO PARA PUBLIC POIS SER�O UTILIZADO NO PE FA050UPD QUANDO O TITULO FOR PA
Public __nI

//FB - 16/03/14
Private aAuxEv :={} // array auxiliar do rateio multinaturezas
Private aRatEvEz:={} //array do rateio multinaturezas
Private aAuxEz :={} // Array auxiliar de multiplos centros de custo
Private aRatEz:={} //Array do rateio de centro de custo em multiplas naturezas

ConOut("U_REN00002 - "+DtoC(Date())+" "+Time()+" - ROTINA INICIADA")

//Alert("Inicio de Rotina")

MakeDir("\SEMAFORO\FUSION\")

if ( nHandler := FCREATE( "\SEMAFORO\FUSION\INFUSION.LCK", FC_NORMAL ) ) <> -1
	FClose( nHandler )
	nHandler := FOPEN( "\SEMAFORO\FUSION\INFUSION.LCK", FO_READWRITE + FO_EXCLUSIVE )
endif

if nHandler == -1
	Return nIl
endif

PREPARE ENVIRONMENT EMPRESA "00" FILIAL "0030001" TABLES "SM0"

cAliasTmp := GetNextAlias()

/*
if MSGYESNO("Limpa Tabelas?","Limpa")
cQrLimpa := "UPDATE ZZR000 SET ZZR_STATUS = '',ZZR_DTLEIT = '',ZZR_HRLEIT='',ZZR_LOGERR = '' "
nRet   := TCSqlExec(cQrLimpa)
cQrLimpa := "UPDATE ZZT000 SET ZZT_STATUS = '',ZZT_DTLEIT = '',ZZT_HRLEIT='' ,ZZT_LOGERR = '' "
nRet   := TCSqlExec(cQrLimpa)
if nRet < 0
msgalelert("Erro na grava��o")
Endif
Endif
*/
cQuery := "SELECT ZZT_FILIAL, "
cQuery += "       ZZT_PREFIX, "
cQuery += "       ZZT_NUM, "
cQuery += "       ZZT_TIPO, "
cQuery += "       ZZT_PARCEL, "
cQuery += "       ZZT_FORNEC, "
cQuery += "       ZZT_LOJA, "
cQuery += "       ZZT_EMISSA, "
cQuery += "       ZZT_VENCTO, "
cQuery += "       ZZT_VENREA, "
cQuery += "       ZZT_VALOR, "
cQuery += "       ZZT_NATURE, "
cQuery += "       ZZT_CCD, "
cQuery += "       ZZT_CLASSE, "
cQuery += "       ZZT_CAMADA, "
cQuery += "       ZZT_PROJET, "
cQuery += "       ZZT_CONTAD, "
cQuery += "       ZZT_USUARI, "
cQuery += "       ZZT_GERACH, "
cQuery += "       ZZT_BCCOD,  "
cQuery += "       ZZT_BCAG,   "
cQuery += "       ZZT_BCCC,   "
cQuery += "       ZZT_RELACIONADO, " //Ronaldo Bicudo /\ Incluido - 07/07/2016
cQuery += "       ZZT_SOLITANTEID, "
cQuery += "       ZZT_SOLICITANTE "
cQuery += "FROM ZZT000 ZZT "
//cQuery += "WHERE ZZT.ZZT_STATUS IS NULL OR TRIM(ZZT.ZZT_STATUS) IS NULL "
cQuery += "WHERE ZZT.ZZT_STATUS IS NULL "
cQuery += "ORDER BY ZZT_TIPO DESC"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.F.,.T.)
(cAliasTmp)->(DbGoTop())
While (cAliasTmp)->(!Eof())
	aAdd( _aDados, { (cAliasTmp)->ZZT_FILIAL, (cAliasTmp)->ZZT_PREFIX, (cAliasTmp)->ZZT_NUM, (cAliasTmp)->ZZT_TIPO, (cAliasTmp)->ZZT_PARCEL,;
	(cAliasTmp)->ZZT_FORNEC, (cAliasTmp)->ZZT_LOJA, (cAliasTmp)->ZZT_EMISSA, (cAliasTmp)->ZZT_VENCTO, (cAliasTmp)->ZZT_VENREA,;
	(cAliasTmp)->ZZT_VALOR, (cAliasTmp)->ZZT_NATURE, (cAliasTmp)->ZZT_CCD, (cAliasTmp)->ZZT_CLASSE, (cAliasTmp)->ZZT_CAMADA,;
	(cAliasTmp)->ZZT_PROJET, (cAliasTmp)->ZZT_CONTAD, (cAliasTmp)->ZZT_USUARI, (cAliasTmp)->ZZT_GERACH, (cAliasTmp)->ZZT_BCCOD,;
	(cAliasTmp)->ZZT_BCAG, (cAliasTmp)->ZZT_BCCC, (cAliasTmp)->ZZT_RELACIONADO, (cAliasTmp)->ZZT_SOLITANTEID, (cAliasTmp)->ZZT_SOLICITANTE })
	(cAliasTmp )->(DbSkip())
Enddo
(cAliasTmp)->( dbCloseArea() )
If Select(cAliasTmp) == 0
	Ferase(cAliasTmp+GetDBExtension())
Endif

if Len(_aDados) <= 0
	ConOut("U_REN00002 - "+DtoC(Date())+" "+Time()+" - ROTINA FINALIZADA")
	FClose(nHandler)
	Return nIl
endif

For nA = 1 to Len(_aDados)
	__nI := nA

	if Empty(AllTrim(_aDados[__nI][1]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"FILIAL ESTA EM BRANCO")
		loop
	endif

	RESET ENVIRONMENT
	RPCSetType(3)  // Nao usar licença
	//PREPARE ENVIRONMENT EMPRESA Left(AllTrim(_aDados[__nI][1]),2) FILIAL AllTrim(_aDados[__nI][1]) TABLES "SM0" MODULO "FIN"
	PREPARE ENVIRONMENT EMPRESA "00" FILIAL AllTrim(_aDados[__nI][1]) TABLES "SM0" MODULO "FIN"

	if Select("SM0") <= 0
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"FILIAL NAO CADASTRADA NO PROTHEUS")
		loop
	endif
	DbSelectArea("SM0")
	SM0->(DbSetOrder(01))
	//if !SM0->(DbSeek(Left(AllTrim(_aDados[__nI][1]),2)+AllTrim(_aDados[__nI][1])))
	if !SM0->(DbSeek("00"+AllTrim(_aDados[__nI][1])))

		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"FILIAL NAO CADASTRADA NO PROTHEUS")
		loop
	endif

	Private lMsErroAuto    := .F.
	Private lMsHelpAuto    := .T.
	Private lAutoErrNoFile := .T.

	Private __aArea     := GetArea()
	Private __aAreaSX5  := SX5->(GetArea())
	Private __aAreaSA2  := SA2->(GetArea())
	Private __aAreaSED  := SED->(GetArea())
	Private __aAreaCTT  := CTT->(GetArea())
	Private __aAreaCV0  := CV0->(GetArea())
	Private __aAreaCTH  := CTH->(GetArea())
	Private __aAreaCTD  := CTD->(GetArea())
	Private __aAreaCT1  := CT1->(GetArea())
	Private __aAreaSE2  := SE2->(GetArea())
	Private __aAreaSEV  := SEV->(GetArea())
	Private __aAreaSEZ  := SEZ->(GetArea())


	DbSelectArea("SX5")
	SX5->(DbSetOrder(01))

	DbSelectArea("FIL")
	FIL->(DbSetOrder(01))

	DbSelectArea("SA2")
	SA2->(DbSetOrder(01))

	DbSelectArea("SED")
	SED->(DbSetOrder(1))

	DbSelectArea("CTT")
	CTT->(DbSetOrder(1))

	DbSelectArea("CV0")
	CV0->(DbSetOrder(1))

	DbSelectArea("CTH")
	CTH->(DbSetOrder(1))

	DbSelectArea("CTD")
	CTD->(DbSetOrder(1))

	DbSelectArea("CT1")
	CT1->(DbSetOrder(1))

	DbSelectArea("SE2")
	SE2->(DbSetOrder(01))
	SE2->(DBGOTOP())

	DbSelectArea("SEV")
	SEV->(DbSetOrder(01))

	DbSelectArea("SEZ")
	SEZ->(DbSetOrder(01))

	if Empty(AllTrim(_aDados[__nI][3]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],_aDados[__nI][6],_aDados[__nI][7],"ZZT_NUM - NUMERO DO TITULO ESTA EM BRANCO")
		loop
	endif
	if Empty(AllTrim(_aDados[__nI][4]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_TIPO - TIPO DO TITULO ESTA EM BRANCO")
		loop
	else
	//	if !SX5->(DbSeek(xFilial("SX5")+"05"+ALLTRIM(_aDados[__nI][4])))      // ESTAVA COMPROMENTENDO A INTEGRACAO 
	  //		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_TIPO - TIPO DO TITULO NAO CADASTRADO: "+AllTrim(_aDados[__nI][4]))
		//	loop
	//	endif
	endif
	if Empty(AllTrim(_aDados[__nI][6]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_FORNEC - CODIGO DO FORNECEDOR ESTA EM BRANCO")
		loop
	endif
	if Empty(AllTrim(_aDados[__nI][7]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_LOJA - LOJA DO FORNECEDOR ESTA EM BRANCO")
		loop
	endif
	if !SA2->(DbSeek(xFilial("SA2")+_aDados[__nI][6]+_aDados[__nI][7]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_FORNEC/ZZT_LOJA - FORNECEDOR/LOJA NAO CADASTRADO: "+AllTrim(_aDados[__nI][6])+"/"+AllTrim(_aDados[__nI][7]))
		loop
	else
		cNomeFor := SA2->A2_NREDUZ
	endif
	if Empty(AllTrim(_aDados[__nI][8]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_EMISSA - DATA DE EMISSAO DO TITULO ESTA EM BRANCO")
		loop
	else
		_aDados[__nI][8] := StoD(_aDados[__nI][8])
	endif
	if Empty(AllTrim(_aDados[__nI][9]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_VENCTO - VENCIMENTO DO TITULO ESTA EM BRANCO")
		loop
	else
		_aDados[__nI][9] := StoD(_aDados[__nI][9])
	endif
	if Empty(AllTrim(_aDados[__nI][10]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_VENREA - VENCIMENTO REAL DO TITULO ESTA EM BRANCO")
		loop
	else
		_aDados[__nI][10] := StoD(_aDados[__nI][10])
	endif
	if _aDados[__nI][11] <= 0
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_VALOR - VALOR DO TITULO ESTA EM BRANCO OU IGUAL A ZERO")
		loop
	endif
	if Empty(AllTrim(_aDados[__nI][12]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_NATURE - CODIGO DA NATUREZA ESTA EM BRANCO")
		loop
	else
		if !SED->(DbSeek(xFilial("SED")+_aDados[__nI][12]))
			GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_NATURE - CODIGO DA NATUREZA NAO CADASTRADO: "+AllTrim(_aDados[__nI][12]))
			loop
		endif
	endif
	if !Empty(AllTrim(_aDados[__nI][13]))
		if !CTT->(DbSeek(xFilial("CTT")+_aDados[__nI][13]))
			GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_CCD - C.CUSTO A DEBITO NAO CADASTRADO: "+AllTrim(_aDados[__nI][13]))
			loop
		endif
	endif
	if !Empty(AllTrim(_aDados[__nI][14]))
		//		if !CV0->(DbSeek(xFilial("CV0")+_aDados[__nI][14]))
		if !CV0->(DbSeek(xFilial("CV0")+"05"+AllTrim(_aDados[__nI][14])))
			GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_CLASSE - ENT.CONTABIL DEBITO 05 NAO CADASTRADO: "+AllTrim(_aDados[__nI][14]))
			loop
		endif
	endif
	if !Empty(AllTrim(_aDados[__nI][15]))
		if !CTH->(DbSeek(xFilial("CTH")+_aDados[__nI][15]))
			GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_CAMADA - CAMADA DEBITO NAO CADASTRADO: "+AllTrim(_aDados[__nI][15]))
			loop
		endif
	endif
	if !Empty(AllTrim(_aDados[__nI][16]))
		if !CTD->(DbSeek(xFilial("CTD")+_aDados[__nI][16]))
			GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_PROJET - ITEM CONTABIL DEBITO NAO CADASTRADO: "+AllTrim(_aDados[__nI][16]))
			loop
		endif
	endif
	if !Empty(AllTrim(_aDados[__nI][17]))
		if !CT1->(DbSeek(xFilial("CT1")+_aDados[__nI][17]))
			GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZT_CONTAD - CONTA CONTABIL NAO CADASTRADO: "+AllTrim(_aDados[__nI][17]))
			loop
		endif
	endif

	if SE2->(MsSeek(xFilial("SE2")+cPrefixo+_aDados[__nI][3]+_aDados[__nI][5]+_aDados[__nI][4]+_aDados[__nI][6]+_aDados[__nI][7]))
		GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"TITULO JA EXISTE NA TABELA SE2: "+xFilial("SE2")+"/"+cPrefixo+"/"+_aDados[__nI][3]+"/"+_aDados[__nI][5]+"/"+_aDados[__nI][4]+"/"+_aDados[__nI][6]+"/"+_aDados[__nI][7])
		loop
	endif
	//Begin Transaction
	aVetor := {}
	Aadd(aVetor,{"E2_FILIAL" ,xFilial("SE2")            ,nIl})
	Aadd(aVetor,{"E2_PREFIXO",cPrefixo                  ,nIl})
	Aadd(aVetor,{"E2_NUM"    ,AllTrim(_aDados[__nI][03]),nIl})
	Aadd(aVetor,{"E2_PARCELA",AllTrim(_aDados[__nI][05]),nIl})
	Aadd(aVetor,{"E2_TIPO"   ,AllTrim(_aDados[__nI][04]),nIl})
	Aadd(aVetor,{"E2_NATUREZ",AllTrim(_aDados[__nI][12]),nIl})
	Aadd(aVetor,{"E2_FORNECE",AllTrim(_aDados[__nI][06]),nIl})
	Aadd(aVetor,{"E2_LOJA"   ,AllTrim(_aDados[__nI][07]),nIl})
	Aadd(aVetor,{"E2_NOMFOR" ,cNomeFor                  ,nIl})
	Aadd(aVetor,{"E2_EMISSAO",_aDados[__nI][08]         ,nIl})
	Aadd(aVetor,{"E2_VENCTO" ,_aDados[__nI][09]         ,nIl})
	Aadd(aVetor,{"E2_VALOR"  ,_aDados[__nI][11]         ,nIl})
	aadd(aVetor,{"E2_ITEMD"  ,AllTrim(_aDados[__nI][16]),nIl})
	Aadd(aVetor,{"E2_CLVLDB" ,AllTrim(_aDados[__nI][15]),nIl})
	Aadd(aVetor,{"E2_CCD"    ,AllTrim(_aDados[__nI][13]),nIl})
	Aadd(aVetor,{"E2_EC05DB" ,AllTrim(_aDados[__nI][14]),nIl})
	Aadd(aVetor,{"E2_CONTAD" ,AllTrim(_aDados[__nI][17]),nIl})
	//Aadd(aVetor,{"E2_NUM" ,AllTrim(_aDados[__nI][23]),nIl})// Gravar dados do relacionamento  andre couto 09/03/2021
	Aadd(aVetor,{"E2_XCODUSR"  ,AllTrim(_aDados[__nI][24]),nIl})// ALTERADO PARA GRAVAR C�DIGO SOLICITANTE
	Aadd(aVetor,{"E2_XUSER"  ,AllTrim(_aDados[__nI][25]),nIl})// ALTERADO PARA GRAVAR NOME SOLICITANTE
	Aadd(aVetor,{"E2_EC07DB" ,SUBSTR(AllTrim(_aDados[__nI][14]),3,5),nIl})    //TIPO DE CUSTO



	if AllTrim(_aDados[__nI][04]) == "PA"
		Aadd(aVetor,{"AUTBANCO"  ,AllTrim(_aDados[__nI][20]),nIL}) //BANCO
		Aadd(aVetor,{"AUTAGENCIA",AllTrim(_aDados[__nI][21]),nIL}) //AG
		Aadd(aVetor,{"AUTCONTA"  ,AllTrim(_aDados[__nI][22]),nIL}) //CONTA
	endif

	//Inicio - Monta Rateio de Centro de Custo por Natureza
	//FB     - 21/03/2016

	IF AllTrim(_aDados[__nI][04])<>'PA' //adiantamento n�o tem rateio.

		_cQry := "SELECT * "
		_cQry += " FROM "
		_cQry += " ZZR000 "
		_cQry += " WHERE "
		_cQry += " ZZR_FILIAL = '"+ALLTRIM(_aDados[__nI][1])+"' "
		//_cQry += " AND TRIM(ZZR_PREFIX) = '"+ALLTRIM(_aDados[__nI][02])+"' "
		_cQry += " AND ZZR_NUM    = '"+AllTrim(_aDados[__nI][03])+"' "
		_cQry += " AND ZZR_TIPO   = '"+AllTrim(_aDados[__nI][04])+"' "
		_cQry += " AND ZZR_FORNEC = '"+AllTrim(_aDados[__nI][06])+"' "
		_cQry += " AND ZZR_LOJA   = '"+AllTrim(_aDados[__nI][07])+"' "
		_cQry += " AND ZZR_PARCEL = '"+AllTrim(_aDados[__nI][05])+"' " //UTILIZADO PARA TITULO PARCELADO
		_cQry += " AND TRIM(ZZR_STATUS) IS NULL "

		TCQUERY _cQry NEW ALIAS "RATEIO"

		aRatEz   := {}
		aAuxEv   := {}
		aAuxEz   := {}
		ARatEvEz := {}
		nSomaRat := 0

		IF RATEIO->(!EOF())
  //			_cParcela:= RATEIO->ZZR_PARCEL //parcela do titulo
			//Tratativa para multiplas naturezas
			aadd( aVetor ,{"E2_RATEIO" , 'N', Nil })//rateio Centro de Custo = N�om
			aadd( aVetor ,{"E2_MULTNAT", '1', Nil })//rateio multinaturezs = sim

			//Adicionando o vetor da natureza

			aadd(aAuxEv,{"EV_NATUREZ" , AllTrim(_aDados[__nI][12]) , Nil })//natureza a ser rateada
			aadd(aAuxEv,{"EV_VALOR"   , _aDados[__nI][11]          , Nil })//valor do rateio na natureza
			aadd(aAuxEv,{"EV_PERC"    , 1		                      , Nil })//percentual do rateio na natureza
			aadd(aAuxEv,{"EV_RATEICC" ,"1", Nil })//indicando que há rateio por centro de custo
//			IF !EMPTY(_cParcela) //	s� adiciona se vier parcela
 //				aadd(aAuxEv,{"EV_PARCELA" ,_cParcela, Nil })//	s� adiciona se vier parcela
 //			ENDIF
			Aadd(aAuxEv,{"EV_RECPAG"   ,'P',nIl})
			//aAuxEz := {}

			WHILE RATEIO->(!EOF())                              /////////////////////////

				//Adicionando multiplos centros de custo e Parcela

				_cCCD    := RATEIO->ZZR_CCD  //centro de custo da natureza
				_nValor  := RATEIO->ZZR_VALOR  // Valor
				_cContaD := RATEIO->ZZR_CONTAD  // Conta Debito    , Nil })//valor do rateio neste centro de custo
				_cClasse := RATEIO->ZZR_CLASSE  // Rateio
				_cProjeto:= RATEIO->ZZR_PROJET  //Projeto
				_cCamada := RATEIO->ZZR_CAMADA // Camada
				_cNature := RATEIO->ZZR_NATURE //natureza

				aadd(aAuxEz,{"EZ_CCUSTO",_cCCD,Nil})//centro de custo da natureza
				aadd(aAuxEz,{"EZ_VALOR",_nValor, Nil})//valor do rateio neste centro de custo
				aadd(aAuxEz,{"EZ_PERC",(_nValor/_aDados[__nI][11])*100, Nil})//valor do rateio neste centro de custo
				aadd(aAuxEz,{"EZ_CONTA",_cContaD,Nil})//valor do rateio neste centro de custo
				aadd(aAuxEz,{"EZ_ITEMCTA",_cProjeto,Nil})//valor do rateio neste centro de custo
				aadd(aAuxEz,{"EZ_CLVL",_cCamada,Nil})//valor do rateio este centro de custo
				aadd(aAuxEz,{"EZ_NATUREZ" , _cNature , Nil })//natureza a ser rateada
				aadd(aAuxEz,{"EZ_EC05DB",_cClasse,Nil})//valor do rateio neste centro de custo
				aadd(aAuxEz,{"EZ_EC07DB",SUBSTR(_cClasse,3,5),Nil})//valor do rateio neste centro de custo
				aadd(aRatEz,aAuxEz)
				aAuxEz := {}
				//Soma rateio para compara��o
				nSomaRat+=RATEIO->ZZR_VALOR

				RATEIO->(dbSkip())
			ENDDO

			aadd(aAuxEv,{"AUTRATEICC",aRatEz,Nil})//recebendo dentro do array da natureza os multiplos centros de custo
			aadd(aRatEvEz,aAuxEv)//adicionando a natureza ao rateio de multiplas naturezas
			aadd(aVetor,{"AUTRATEEV",ARatEvEz,Nil})//adicionando ao vetor aVetor o vetor do rateio

		ELSE

			GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZR - RATEIO DE CENTRO DE CUSTO NAO LOCALIZADO"+"")
			RATEIO->(dbCloseArea())
			loop   // se nao encontrar ZZR para o titulo da ZZT pula para o proximo registro
		ENDIF

		RATEIO->(dbCloseArea())
		//Fim - Monta Rateio de Centro de Custo por Natureza


		// Valida totais do rateio
		lRatOK := .T.
		if ( nSomaRat <> _aDados[__nI][11])
			GravaErro(1,_aDados[__nI][1],cPrefixo,_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"ZZR - SOMA DO RATEIO INVALIDA"+"")
			lRatOK := .F.
		Endif

		if lRatOK
			lErro       := .F.
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z| FINA050(x,y,z)},aVetor,,3)
			//  MsExecAuto({|x,y,z| FINA050(x,y,z)},aArray,,4) - exemplo TDN
			//MSExecAuto({|x,y,z,w| FINA050(x,y,z,w)},aVetor,3,,aRatEvEz)
			if lMsErroAuto
				//MostraErro()
				LerLogErro(_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7])
				lErro := .T.
				DisarmTransaction()
				break

			endif

			if !lErro
				GravaOk(_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7])
				if AllTrim(_aDados[__nI][04]) <> "PA"
					If !Empty(_aDados[__nI][23]) // Se estiver vazio n�o teve adiantamento, n�o tem compensa��o.
						cAliasTmp := GetNextAlias()
						cQuery    := "SELECT SE2.R_E_C_N_O_ AS RECNO "
						cQuery    += "FROM SE2000 SE2 "
						//cQuery    += "WHERE SE2.E2_FILIAL = '"+xFilial("SE2")+"' "
						cQuery    += "WHERE SE2.E2_FILIAL = '"+AllTrim(_aDados[__nI][01])+"' "
						//						If AllTrim(_aDados[__nI][04]) = 'BPM' .AND. Len(AllTrim(_aDados[__nI][23])) <= 9   //PARA COMPENSAR COM ADIANTAMENTO DO COLABORADOR
						If Len(AllTrim(_aDados[__nI][23])) <= 9   //PARA COMPENSAR COM ADIANTAMENTO DO COLABORADOR
							cQuery    += "    AND SE2.E2_PREFIXO = 'BPM' "
							cQuery    += "    AND TRIM(SE2.E2_NUM) = '"+AllTrim(_aDados[__nI][23])+"' "
						Else
							cQuery    += "    AND SE2.E2_PREFIXO <> 'BPM' "  //PARA COMPENSAR ADIANTAMENTO DO CART�O
							cQuery    += "    AND TRIM(SE2.E2_NUM) = '"+Alltrim(Substr(_aDados[__nI][23],11,9))+"' "
							If Substr(_aDados[__nI][23],20,3) == '   '
								cQuery    += "    AND TRIM(SE2.E2_PARCELA) IS NULL "
							Else
								cQuery    += "    AND TRIM(SE2.E2_PARCELA) = '"+Alltrim(Substr(_aDados[__nI][23],20,3))+"' "
							Endif
							cQuery    += "    AND TRIM(SE2.E2_TIPO) = '"+Alltrim(Substr(_aDados[__nI][23],23,2))+"' "
							cQuery    += "    AND TRIM(SE2.E2_FORNECE) = '"+Alltrim(Substr(_aDados[__nI][23],26,6))+"' "
							cQuery    += "    AND TRIM(SE2.E2_LOJA) = '"+Alltrim(Substr(_aDados[__nI][23],32,2))+"' "
						EndIf

						cQuery    += "    AND SE2.E2_TIPO = 'PA' "
						cQuery    += "    AND SE2.E2_SALDO > 0 "
						//cQuery    += "    AND SE2.E2_FORNECE = '"+AllTrim(_aDados[__nI][06])+"' "
						//cQuery    += "    AND SE2.E2_LOJA = '"+AllTrim(_aDados[__nI][07])+"' "
						cQuery    += "    AND SE2.D_E_L_E_T_ <> '*'"
						cQuery    := ChangeQuery(cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.F.,.T.)
						(cAliasTmp)->(DbGoTop())
						While (cAliasTmp)->(!Eof())
							//				aadd( aRecPA, { (cAliasTmp)->RECNO })
							aadd( aRecPA, (cAliasTmp)->RECNO )
							(cAliasTmp)->(DbSkip())
						Enddo
						(cAliasTmp)->( dbCloseArea() )
						If Select(cAliasTmp) == 0
							Ferase(cAliasTmp+GetDBExtension())
						Endif
						if Len(aRecPA) > 0  // Compensação automática. _aDados[__nI][02]
							dbSelectArea("SE2")
							SE2->( dbSetOrder( 1 ) )
							If SE2->(DbSeek(xFilial("SE2")+cPrefixo+_aDados[__nI][3]+_aDados[__nI][5]+_aDados[__nI][4]+_aDados[__nI][6]+_aDados[__nI][7]))
								aadd(aRecSE2,SE2->(Recno()))
								//					PERGUNTE("AFI340",.F.)
								//lContabili := .T.
								//lAglutina  := .F.
								//lDigita    := .F.
								//lDigita    := .T.
								//if MaIntBxCP(2,aRecSE2,,aRecPA,,{_lContabili,_lAglutina,_lDigita,.F.,.F.,.F.},,,,,dBaixaCmp)
								if MaIntBxCP(2,aRecSE2,,aRecPA,,{.T.,.F.,.F.,.F.,.F.,.F.},,,,,dBaixaCmp)
									GravaOk(_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7])
								else
									GravaErro(1,_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7],"COMPENSACAO AUTOMATICA NAO EFETUADA")
								endif
							Endif
						endif
					endif
				endif
			Endif
		EndIf

		aRecSE2 := {}   //zera a variaveis locais
		aRecPA  := {}   //zera a variaveis locais

	Else // Se For PA gera somente SE2 sem Rateio

		lErro       := .F.
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z| FINA050(x,y,z)},aVetor,,3)

		if lMsErroAuto
			//	MostraErro()
			LerLogErro(_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7])
			lErro := .T.
			DisarmTransaction()
			break
		endif

		if !lErro
			GravaOk(_aDados[__nI][1],_aDados[__nI][2],_aDados[__nI][3],_aDados[__nI][4],_aDados[__nI][5],_aDados[__nI][6],_aDados[__nI][7])
		Endif
	Endif
Next __nI

RestArea(__aAreaSX5)
RestArea(__aAreaSA2)
RestArea(__aAreaSED)
RestArea(__aAreaCTT)
RestArea(__aAreaCV0)
RestArea(__aAreaCTH)
RestArea(__aAreaCTD)
RestArea(__aAreaCT1)
RestArea(__aAreaSE2)
RestArea(__aAreaSEV)
RestArea(__aAreaSEZ)

ConOut("U_REN00002 - "+DtoC(Date())+" "+Time()+" - ROTINA FINALIZADA")
FClose(nHandler)

Alert("Rotina Finalizada")

_aDados := {}   //zera a variaveis publicas
__nI := 0



Return nIl

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

±±ºPrograma  ³ GRAVAERRO ºAutor ³DanIlo José Grodzickiº Data³  20/10/2015 º±±

±±ºDesc.     ³ Grava erro na tabela ZZT000.                               º±±
±±º          ³                                                            º±±

±±ºUso       ³ Renova Energia S.A.                                        º±±

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaErro(_CORIGEM, cE2Filial, cE2Prefixo, cE2Num, cE2Tipo, cE2Parcela, cE2Fornece, cE2Loja, cDescrErro)

Local nRet
Local cQuery
Local cQueryRat

cE2Filial  := AllTrim(cE2Filial)
cE2Prefixo := AllTrim(cE2Prefixo)
cE2Num     := AllTrim(cE2Num)
cE2Tipo    := AllTrim(cE2Tipo)
cE2Parcela := AllTrim(cE2Parcela)
cE2Fornece := AllTrim(cE2Fornece)
cE2Loja    := AllTrim(cE2Loja)
cDescrErro := AllTrim(cDescrErro)

if Empty(cE2Filial)
	cE2Filial := "IS NULL"
else
	cE2Filial := "= '"+cE2Filial+"'"
endif
if Empty(cE2Prefixo)
	cE2Prefixo := "IS NULL"
else
	cE2Prefixo := "= '"+cE2Prefixo+"'"
endif
if Empty(cE2Num)
	cE2Num := "IS NULL"
else
	cE2Num := "= '"+cE2Num+"'"
endif
if Empty(cE2Tipo)
	cE2Tipo := "IS NULL"
else
	cE2Tipo := "= '"+cE2Tipo+"'"
endif
if Empty(cE2Parcela)
	cE2Parcela := "IS NULL"
else
	cE2Parcela := "= '"+cE2Parcela+"'"
endif
if Empty(cE2Fornece)
	cE2Fornece := "IS NULL"
else
	cE2Fornece := "= '"+cE2Fornece+"'"
endif
if Empty(cE2Loja)
	cE2Loja := "IS NULL"
else
	cE2Loja := "= '"+cE2Loja+"'"
endif

IF _CORIGEM == 1 //Com rateio
	if AllTrim(cDescrErro) == "COMPENSACAO AUTOMATICA NAO EFETUADA"
		cQuery := "UPDATE ZZT000 SET ZZT_STACOM = 'NOK' "
		cQuery += "WHERE ZZT_FILIAL "+cE2Filial+" AND ZZT_PREFIX "+cE2Prefixo+" AND ZZT_NUM "+cE2Num+" AND ZZT_TIPO "+cE2Tipo+;
		" AND ZZT_PARCEL "+cE2Parcela+" AND ZZT_FORNEC "+cE2Fornece+" AND ZZT_LOJA "+cE2Loja
	else
		cQuery := "UPDATE ZZT000 SET ZZT_STATUS = 'NOK', ZZT_LOGERR = '"+cDescrErro+"', ZZT_DTLEIT = '"+DtoS(Date())+"', ZZT_HRLEIT = '"+Time()+"' "
		cQuery += "WHERE ZZT_FILIAL "+cE2Filial+" AND ZZT_PREFIX "+cE2Prefixo+" AND ZZT_NUM "+cE2Num+" AND ZZT_TIPO "+cE2Tipo+;
		" AND ZZT_PARCEL "+cE2Parcela+" AND ZZT_FORNEC "+cE2Fornece+" AND ZZT_LOJA "+cE2Loja
	endif
	cQueryRat := "UPDATE ZZR000 SET ZZR_STATUS = 'NOK', ZZR_LOGERR = '"+cDescrErro+"', ZZR_DTLEIT = '"+DtoS(Date())+"', ZZR_HRLEIT = '"+Time()+"' "
	cQueryRat += "WHERE ZZR_FILIAL "+cE2Filial+" AND ZZR_PREFIX "+cE2Prefixo+" AND ZZR_NUM "+cE2Num+" AND ZZR_TIPO "+cE2Tipo+;
	" AND ZZR_PARCEL "+cE2Parcela+" AND ZZR_FORNEC "+cE2Fornece+" AND ZZR_LOJA "+cE2Loja
ELSE //Sem Rateio
	if AllTrim(cDescrErro) == "COMPENSACAO AUTOMATICA NAO EFETUADA"
		cQuery := "UPDATE ZZT000 SET ZZT_STACOM = 'NOK' "
		cQuery += "WHERE ZZT_FILIAL "+cE2Filial+" AND ZZT_PREFIX "+cE2Prefixo+" AND ZZT_NUM "+cE2Num+" AND ZZT_TIPO "+cE2Tipo+;
		" AND ZZT_PARCEL "+cE2Parcela+" AND ZZT_FORNEC "+cE2Fornece+" AND ZZT_LOJA "+cE2Loja
	else
		cQuery := "UPDATE ZZT000 SET ZZT_STATUS = 'NOK', ZZT_LOGERR = '"+cDescrErro+"', ZZT_DTLEIT = '"+DtoS(Date())+"', ZZT_HRLEIT = '"+Time()+"' "
		cQuery += "WHERE ZZT_FILIAL "+cE2Filial+" AND ZZT_PREFIX "+cE2Prefixo+" AND ZZT_NUM "+cE2Num+" AND ZZT_TIPO "+cE2Tipo+;
		" AND ZZT_PARCEL "+cE2Parcela+" AND ZZT_FORNEC "+cE2Fornece+" AND ZZT_LOJA "+cE2Loja
	endif
ENDIF

nRet   := TCSqlExec(cQuery)
nRet2  := TCSqlExec(cQueryRat)

if nRet < 0
	ConOut("U_REN00002 - "+DtoC(Date())+" "+Time()+" - ERRO AO GRAVAR NA TABELA ZZT000: "+cQuery)
	FClose(nHandler)
	Return nIl
endif

if nRet2 < 0
	ConOut("U_REN00002 - "+DtoC(Date())+" "+Time()+" - ERRO AO GRAVAR NA TABELA ZZR000: "+cQueryRat)
	FClose(nHandler)
	Return nIl
endif


Return nIl

/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

±±ºPrograma  ³ GRAVAOK   ºAutor ³DanIlo José Grodzickiº Data³  17/11/2015 º±±

±±ºDesc.     ³ Grava erro na tabela ZZT000.                               º±±
±±º          ³                                                            º±±

±±ºUso       ³ Renova Energia S.A.                                        º±±

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaOk(cE2Filial, cE2Prefixo, cE2Num, cE2Tipo, cE2Parcela, cE2Fornece, cE2Loja)

Local nRet
Local cQuery

cE2Filial  := AllTrim(cE2Filial)
cE2Prefixo := AllTrim(cE2Prefixo)
cE2Num     := AllTrim(cE2Num)
cE2Tipo    := AllTrim(cE2Tipo)
cE2Parcela := AllTrim(cE2Parcela)
cE2Fornece := AllTrim(cE2Fornece)
cE2Loja    := AllTrim(cE2Loja)

if Empty(cE2Filial)
	cE2Filial := "IS NULL"
else
	cE2Filial := "= '"+cE2Filial+"'"
endif
if Empty(cE2Prefixo)
	cE2Prefixo := "IS NULL"
else
	cE2Prefixo := "= '"+cE2Prefixo+"'"
endif
if Empty(cE2Num)
	cE2Num := "IS NULL"
else
	cE2Num := "= '"+cE2Num+"'"
endif
if Empty(cE2Tipo)
	cE2Tipo := "IS NULL"
else
	cE2Tipo := "= '"+cE2Tipo+"'"
endif
if Empty(cE2Parcela)
	cE2Parcela := "IS NULL"
else
	cE2Parcela := "= '"+cE2Parcela+"'"
endif
if Empty(cE2Fornece)
	cE2Fornece := "IS NULL"
else
	cE2Fornece := "= '"+cE2Fornece+"'"
endif
if Empty(cE2Loja)
	cE2Loja := "IS NULL"
else
	cE2Loja := "= '"+cE2Loja+"'"
endif

cQuery := "UPDATE ZZT000 SET ZZT_STATUS = 'OK', ZZT_DTLEIT = '"+DtoS(Date())+"', ZZT_HRLEIT = '"+Time()+"' "
cQuery += "WHERE ZZT_FILIAL "+cE2Filial+" AND ZZT_PREFIX "+cE2Prefixo+" AND ZZT_NUM "+cE2Num+" AND ZZT_TIPO "+cE2Tipo+;
" AND ZZT_PARCEL "+cE2Parcela+" AND ZZT_FORNEC "+cE2Fornece+" AND ZZT_LOJA "+cE2Loja
nRetZZT   := TCSqlExec(cQuery)
if nRetZZT < 0
	ConOut("U_REN00002 - "+DtoC(Date())+" "+Time()+" - ERRO AO GRAVAR NA TABELA ZZT000: "+cQuery)
endif

cQuery := "UPDATE ZZR000 SET ZZR_STATUS = 'OK', ZZR_DTLEIT = '"+DtoS(Date())+"', ZZR_HRLEIT = '"+Time()+"' "
cQuery += "WHERE ZZR_FILIAL "+cE2Filial+" AND ZZR_PREFIX "+cE2Prefixo+" AND ZZR_NUM "+cE2Num+" AND ZZR_TIPO "+cE2Tipo+;
" AND ZZR_PARCEL "+cE2Parcela+" AND ZZR_FORNEC "+cE2Fornece+" AND ZZR_LOJA "+cE2Loja
nRetZZR   := TCSqlExec(cQuery)
if nRetZZR < 0
	ConOut("U_REN00002 - "+DtoC(Date())+" "+Time()+" - ERRO AO GRAVAR NA TABELA ZZT000: "+cQuery)
endif

IF nRetZZT < 0 .OR. nRetZZR < 0
	FClose(nHandler)
ENDIF

Return nIl

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

±±ºPrograma  ³ LERLOGERROºAutor ³DanIlo José Grodzickiº Data³  20/10/2015 º±±

±±ºDesc.     ³ Ler erro do MsExecAuto.                                    º±±
±±º          ³                                                            º±±

±±ºUso       ³ Renova Energia S.A.                                        º±±

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LerLogErro(cE2Filial, cE2Prefixo, cE2Num, cE2Tipo, cE2Parcela, cE2Fornece, cE2Loja)

Local nI
Local aRet     := {}
Local aAux     := {}
Local lHelp    := .T.
Local cLinha   := ''
Local lTabela  := .F.
Local lThread  := .F.
Local lGravou	 := .F.
Local aErroLog := GetAutoGRLog()

For nI = 1 to Len(aErroLog)
	lGravou := .F.
	cLinha  := Upper(aErroLog[nI])
	If SubStr( cLinha, 1, 4 ) == 'HELP'
		lHelp := .T.
	EndIf
	If SubStr( cLinha, 1, 11 ) == 'ERRO THREAD'
		lHelp   := .F.
		lThread := .T.
	EndIf                                                                                                                               ?
	If SubStr( cLinha, 1, 6 ) == 'TABELA'
		lHelp   := .F.
		lTabela := .T.
	EndIf
	If SubStr( cLinha, 1, 6 ) == 'TOTVS'
		lThread := .F.
		aEval( aRet, { |x| IIf( !Empty( x ), aAdd( aAux, x ), ) } )
		aRet := aClone( aAux )
		Exit
	EndIf
	If SubStr( cLinha, 1, 12 ) == 'ERRO NO ITEM'
		lThread := .T.
	EndIf
	If !lGravou
		If  lHelp .OR. lThread .OR. lThread .OR. ( lTabela .AND. '< -- INVALIDO' $  cLinha )
			aAdd( aRet, aErroLog[nI] )
			lThread := .F.
		EndIf
	EndIf
Next nI

If Len(aRet) == 0
	GravaErro(1,cE2Filial, cE2Prefixo, cE2Num, cE2Tipo, cE2Parcela, cE2Fornece, cE2Loja, "ERRO INCLUSÃO")
Else
	GravaErro(1,cE2Filial, cE2Prefixo, cE2Num, cE2Tipo, cE2Parcela, cE2Fornece, cE2Loja, AllTrim(aRet[1]))
EndIf

Return nIl
