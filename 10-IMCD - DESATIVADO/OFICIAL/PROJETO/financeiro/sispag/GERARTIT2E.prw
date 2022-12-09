#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INCDESPEIC º Autor ³  Junior Carvalho   º Data ³ 04/02/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função para gerar custos das despesas de importação          º±±
±±º          ³ em movimentação internas modelo 2                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GERARTIT2E()

Local aCpos		:= {}
Local cTitBrow	:= OemToAnsi( "Notas de Custos" )
Private cArq     := " "
Private cNomeUser := Alltrim(UsrRetName(__CUSERID))
Private oBrowse
Private cAliasTRB := GetNextAlias()
Private aRotina   := {{"Gerar TITULOS","U_GRVEICD3()", 0,4}}
Private oMark
Private cMarca    := GetMark()
Private aSeek     := {}

Private cArqTrab 

cTitBrow := " IMPORTAÇÃO TITULOS 2 EASY "

aCpos := {}
//aAdd(aCpos,{'Filial' ,'D1_FILIAL','C',7,0,"@!"})
aAdd(aCpos,{'Filial','E2_FILIAL','C',2,0,"@!"})
aAdd(aCpos,{'Prefixo'	   ,'E2_PREFIXO','C',3,0,"@!"})
aAdd(aCpos,{'Numero'	   ,'E2_NUM','C',9,0,"@!"})
aAdd(aCpos,{'Tipo','E2_TIPO','C',3,0,"@!"})
aAdd(aCpos,{'Natureza','E2_NATUREZ','C',20,0,"@!"})
aAdd(aCpos,{'Fornecedor','E2_FORNECE','C',8,0,"@!"})
aAdd(aCpos,{'Dt.Emissão','E2_EMISSAO','D',10,0,""})
aAdd(aCpos,{'Dt.Digitação','E2_VENCTO','D',10,0,""})
aAdd(aCpos,{'Dt.Digitação','E2_VENCREA','D',10,0,""})
aAdd(aCpos,{'Valor','E2_VALOR','N',15,4,PesqPict('SE2','E2_VALOR')})
aAdd(aCpos,{'Historico','E2_HIST','C',100,0,"@!"})	

//aAdd(aSeek,{"Filial+Numero" , {},1,.T.})

cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório que está o arquivo"), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

PROCESSA( { || BSCDADOS() }, "BUSCANDO DADOS","IMCD")

cAliasTRB := (cArqTrab) // remover pos-testes.

//????????????????????????????
//?Construcao do MarkBrowse?
//????????????????????????????
oMark:= FWMarkBrowse():NEW()   // Cria o objeto oMark - MarkBrowse
oMark:SetAlias(cAliasTRB)      // Define a tabela do MarkBrowse
oMark:SetDescription(cTitBrow) // Define o titulo do MarkBrowse
//oMark:SetFieldMark("MRKOK")    // Define o campo utilizado para a marcacao
oMark:SetFilterDefault()       // Define o filtro a ser aplicado no MarkBrowse
oMark:SetFields(aCpos)         // Define os campos a serem mostrados no MarkBrowse
oMark:SetSemaphore(.F.)        // Define se utiliza marcacao exclusiva
oMark:SetTemporary(.T.)
//oMark:DisableDetails()         // Desabilita a exibicao dos detalhes do MarkBrowse
//oMark:DisableConfig()          // Desabilita a opcao de configuracao do MarkBrowse
//oMark:DisableReport()          // Desabilita a opcao de imprimir
oMark:SetUseFilter(.T.)
//oMark:SetSeek(.T.,aSeek)

oMark:AddMarkColumns ({|| Iif(MRKOK == cMarca,'LBOK','LBNO')},{|| MARCAR() },{|| .F. })
//define as legendas
//oMark:AddLegend('EMPTY(MRKOK) ',"BR_VERDE" ,"OK")

oMark:Activate()

dbSelectArea(cAliasTRB)
(cAliasTRB)->(dbCloseArea())

Return()

Static Function BSCDADOS()


cArqTrab := GetNextAlias()

oTemptable := FWTemporaryTable():New(cArqTrab)
oTemptable:SetFields(aCols)

oTempTable:Create()

Return 

Static Function MARCAR()

Local nReg := (cAliasTRB)->(Recno())

dbSelectArea(cAliasTRB)

RecLock(cAliasTRB,.F.)
If (cAliasTRB)->MRKOK <> cMarca
	(cAliasTRB)->MRKOK := cMarca
	
Else
	(cAliasTRB)->MRKOK := Space(Len( (cAliasTRB)->MRKOK ) )
	
EndIf
(cAliasTRB)->(MsUnlock())
oMark:oBrowse:Refresh(.T.)

Return()


User Function GRVEICD3()
Local nTotSrv := 0
Local nX := 0
aPrdSv := {}
dbSelectArea(cAliasTRB)
dbGoTop()
ProcRegua(RecCount())

While !(cALiasTRB)->(Eof())
	IncProc( OemToAnsi( (cAliasTRB)->D1_DOC ) )
	
	if (cAliasTRB)->MRKOK == cMarca
		aAdd(aPrdSv, {(cAliasTRB)->CHVSD1, (cAliasTRB)->D1_DOC,(cAliasTRB)->D1_SERIE,(cAliasTRB)->D1_CUSTO,(cAliasTRB)->D1RECNO,.F.})
		
		dbSelectArea(cALiasTRB)
		RecLock(cAliasTRB , .F.)
		(cAliasTRB)->MRKOK := ' '
		dbDelete()
		MsUnLock()
		
	Endif
	(cALiasTRB)->(DBSKIP())
	Loop
	
EndDo

if Len(aPrdSv) > 0
	lGerou := .F.
	
	PROCESSA( { || GRVSD3(@lGerou)  }, "GERANDO CUSTOS","IMCD - INCDESPEIC")
	if lGerou
		FOR nX:= 1 To Len( aPrdSv )
			IF aPrdSv[nX][6]
				nTotSrv += aPrdSv[nX][4]
				cQuery := "UPDATE "+RetSqlName("SD1")+" SET D1_XINTSD3 = '"+DTOS(dDataBase)+"' WHERE R_E_C_N_O_ = "+Str(aPrdSv[nX][5])
				
				If TCSQLExec(cQuery) < 0
					cSqlErr := TCSqlError()
					HS_MsgInf("Ocorreu um erro :" + Chr(10) + Chr(13) + cSqlErr, "Atenção!!!", "Inconsistência")
				EndIf
			ELSE
				Alert("Erro na Nota "+ aPrdSv[nX][2]+" Serie "+ aPrdSv[nX][3])
			ENDIF
		Next
		Alert("Total serviços: "+ transform(nTotSrv,"@E 999,999.99") )
	Else
		Alert("Erro na Geração dos Custos ")
	Endif
	
Else
	ALERT("Nenhum documento Marcado.")
Endif

Return

Static Function ITENSNF(lRet)
Local nX := 0

dbSelectArea("SD1")
dbSetOrder(1)
nVBrut := 0
if MsSeek(cChvSF1)
	While SD1->(!Eof()) .and. cChvSF1 == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)
		
		aAdd(aPrdOri,{SD1->D1_COD, SD1->D1_UM, SD1->D1_LOCAL, SD1->D1_TOTAL,0,SD1->D1_CONHEC} )
		nVBrut += SD1->D1_TOTAL
		
		SD1->(DbSkip())
		Loop
	EndDo
	
Endif

FOR nX:= 1 to Len( aPrdOri )
	aPrdOri[nX][5]  := ROUND((aPrdOri[nX][4] / nVBrut),6)
Next

Return

Static Function GRVSD3(lGerou)

Local aCab		:= {}
Local aItem		:= {}
Local aItens	:={}
Local nPrOri    := 0
Local nPrSv     := 0
Local cTM		:= SUBSTR(SuperGetMv("ES_TESCUST", ,"007"),1,3 )
Private lMsHelpAuto := .T. // se .t. direciona as mensagens de help
Private lMsErroAuto := .F. //necessario a criacao

nQtItens := Len(aPrdSv)

ProcRegua(nQtItens)
if nQtItens > 0

	BEGIN TRANSACTION 
		For nPrOri := 1 To Len(aPrdOri)

			lMsErroAuto := .F.

			aCab := { {"D3_FILIAL"	, XFILIAL("SD3"),Nil},;
			{"D3_TM" 		,cTM , NIL},;
			{"D3_DOC" 	, SUBSTR(ALLTRIM( aPrdOri[nPrOri][6] ),1,9), NIL},;
			{"D3_EMISSAO" 	,dDataBase, NIL} }

			IncProc(OemToAnsi("GERANDO "+aPrdOri[nPrOri][1]))

			For nPrSv := 1 To nQtItens
			DbSelectArea("SB1")
			DbSetOrder(1)
			cTipo := POSICIONE("SB1",1,xFilial("SB1")+aPrdOri[nPrOri][1],"B1_TIPO")

				cLocPrd := iif(Alltrim(cTipo) = 'MR','01', aPrdOri[1][3] )
				aItem:={{"D3_COD" , aPrdOri[nPrOri][1] ,NIL},;
				{"D3_DOC" 	, SUBSTR(ALLTRIM( aPrdOri[nPrOri][6] ),1,9), NIL},;
				{"D3_UM" 		, aPrdOri[nPrOri][2] ,NIL},;
				{"D3_CUSTO1"	, ROUND(aPrdOri[nPrOri][5] * aPrdSv[nPrSv][4],5),Nil},;
				{"D3_LOCAL" 	, cLocPrd ,NIL},;
				{"D3_XIMPEIC"	, aPrdSv[nPrSv][1]+" EIC "+aPrdOri[nPrOri][6]  ,Nil } }

				aPrdSv[nPrSv][6] := .T.

				aadd(aItens,aItem)
				IncProc()

			Next nPrSv

			MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItens,3)
			aItens := {}
			lGerou := .T.

			If lMsErroAuto
				Mostraerro()
				DisarmTransaction()
				lGerou := .F.
			EndIf

		Next nPrSv

	END TRANSACTION 
	
Else
	ALERT("Não há itens para gerar Custos.")
Endif

Return()
