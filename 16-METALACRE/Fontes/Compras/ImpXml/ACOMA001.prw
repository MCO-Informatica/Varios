#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "AP5MAIL.CH"

//+-----------------------------------------------------------------------------------//
//|Funcao....: ACOMA001()
//|Autor.....: Luiz Alberto
//|Data......: 11 de novembro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function ACOMA001(lGrvMsg,cStatus,cMensag,cChvNfe)
*-----------------------------------------------------------*
Local nRecTab1  :=  0

Default lGrvMsg := .F.
Default cStatus := ""
Default cMensag := ""
Default cChvNfe := ""

//Usei rotinas abaixo uma unica vez pra corrigir XML j? cadastrados
//Processa( {|| fAjustHrUF()   },"Ajustando Hora, UF, Cid ..." )
//Processa( {|| fAjustTipo()   },"Ajustando tipo ..." )
//Processa( {|| fValidXML("0") },"Validando Status 0 ..." )
//Processa( {|| fValidXML("1") },"Validando Status 1 ..." )
//Processa( {|| fValidXML("2") },"Validando Status 2 ..." )
//Processa( {|| fValidXML("4") },"Validando Status 4 ..." )
//Processa( {|| fValidXML("5") },"Validando Status 5 ..." )
//Processa( {|| fValidXML("6") },"Validando Status 6 ..." )
//Processa( {|| fValidXML("7") },"Validando Status 7 ..." )
//Processa( {|| fValidXML("8") },"Validando Status 8 ..." )

Public _lGerXML := .t.

If lGrvMsg
	nRecTab1 := fRetRcTab1(cChvNfe,cStatus)
	If !Empty(nRecTab1) .And. !Empty(cMensag)
		fGravaMsg(nRecTab1,98,cStatus,cMensag)
	EndIf
Else
	//Chamando Rotina
	GerXmlNF()
EndIf
_lGerXML := .F.
Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fRetRcTab1()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fRetRcTab1(cChvNfe,cStatus)
*-----------------------------------------------------------*
Local nRet  := 0
Local cTab1 := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1 := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local aArea := (cTab1)->(GetArea())

(cTab1)->(DbSetOrder(3))
If (cTab1)->(DbSeek( xFilial() + cChvNfe ))
	If (cTab1)->&(cAls1+"_STATUS") != cStatus
		nRet := (cTab1)->(Recno())
	EndIf
EndIf

RestArea(aArea)

Return(nRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: GerXmlNF()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function GerXmlNF()
*-----------------------------------------------------------*

//Declara as variaveis
Private cTitCad   := "GERENCIADOR XML NFe"
Private cStrCad   := ""
Private cCadastro := ""
Private aRotina   := fMenu()
Private aFixe     := Nil
Private aCores    := {}
Private cFiltrCad := Nil
Private aIndexCad := {}

Private cFMAlias01 := "" //Regitro Principal
Private cFMAlias02 := "" //Regitro Historico
Private lZerosDoc  := GetNewPar("MV_XMLZDC",.f.)	// Determina se Numero da Nota com Zeros a Esquerda

//Verificacoes Iniciais
fVerifInic()

//Criar SX's
fCriaSXs()

//Monta Legendas
aCores := fCores()

//Faz a pergunta e monta filtro
aRetPerg := fFiltroCad()

//Se pergunta confirmada, executa filtro, caso contrario, sai da rotina
If aRetPerg[1]
	//Pergunta se baixa XML novos
	U_GXNBxa()

	cFilCad := aRetPerg[2]
	aIndexCad := {}

	cStrCad   := cFMAlias01
	cCadastro := cTitCad+" ["+cStrCad+"]"
	DbSelectArea(cStrCad)
	DbSetOrder(1)
	mBrowse(6,1,22,75,cStrCad,aFixe,,,,,aCores,,,,,,,,cFilCad)

	SetMBTopFilter(cStrCad, "")

EndIf
_lGerXML := .F.
Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: fFiltroCad()
//|Autor.....: Luiz Alberto
//|Data......: 22 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fFiltroCad()
*-----------------------------------------------------------*
Local cTab1   := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

Local lRet      := .F.
Local cRet      := ""
Local aPerg     := {}
Local aParam    := {}

Local cPerg1Tit := "Tipo XML"
Local aPerg1Arr := {}
Local cPerg1Vld := ".T."
Local cPerg1Tam := 120
Local cPerg1Obg := .T.

Local cPerg2Tit := "Tipo Documento"
Local aPerg2Arr := {}
Local cPerg2Vld := ".T."
Local cPerg2Tam := 120
Local cPerg2Obg := .T.

Local cPerg3Tit := "Tipo Status"
Local aPerg3Arr := {}
Local cPerg3Vld := ".T."
Local cPerg3Tam := 120
Local cPerg3Obg := .T.

//Opcoes da Pergunta 01
aAdd(aPerg1Arr,"T=Todos Tipos"     )
aAdd(aPerg1Arr,"1=NF"              )
aAdd(aPerg1Arr,"2=CT"              )
aAdd(aPerg1Arr,"3=XML Pedente"     )

//Opcoes da Pergunta 02
aAdd(aPerg2Arr,"T=Todos Documentos")
aAdd(aPerg2Arr,"N=Normal"          )
aAdd(aPerg2Arr,"D=Devolucao"       )
aAdd(aPerg2Arr,"B=Beneficiamento"  )
aAdd(aPerg2Arr,"C=Complementar"    )
aAdd(aPerg2Arr,"A=Ajuste"          )
aAdd(aPerg2Arr,"U=Anulacao"        )
aAdd(aPerg2Arr,"S=Substituicao"    )
aAdd(aPerg2Arr,"X=Indefinido"      )

//Opcoes da Pergunta 03
aAdd(aPerg3Arr,"T=Todos Status"                           )
aAdd(aPerg3Arr,"0=XML pendente de recebimento"            )
aAdd(aPerg3Arr,"1=XML recebido com sucesso"               )
aAdd(aPerg3Arr,"2=XML recebido com erro"                  )
aAdd(aPerg3Arr,"3=XML j? incluido no sistema"             )
aAdd(aPerg3Arr,"4=XML gerou erro na pre-nota"             )
aAdd(aPerg3Arr,"5=XML gerou pre-nota depois foi exclu?da" )
aAdd(aPerg3Arr,"6=XML de cancelamento recebido"           )
aAdd(aPerg3Arr,"7=XML bloqueado pelo validador"           )

Private mv_par01 := "T"
Private mv_par02 := "T"
Private mv_par03 := "T"
Private cParRom  := "FILTROCAD"+SM0->M0_CODIGO+SM0->M0_CODFIL

aAdd(aPerg,{2           ,;
				cPerg1Tit   ,;
				mv_par01    ,;
				aPerg1Arr   ,;
				cPerg1Tam   ,;
				cPerg1Vld   ,;
				cPerg1Obg	})
aAdd(aParam,mv_par01)

aAdd(aPerg,{2           ,;
				cPerg2Tit   ,;
				mv_par02    ,;
				aPerg2Arr   ,;
				cPerg2Tam   ,;
				cPerg2Vld   ,;
				cPerg2Obg	})
aAdd(aParam,mv_par02)

aAdd(aPerg,{2           ,;
				cPerg3Tit   ,;
				mv_par03    ,;
				aPerg3Arr   ,;
				cPerg3Tam   ,;
				cPerg3Vld   ,;
				cPerg3Obg	})
aAdd(aParam,mv_par03)

If ParamBox(aPerg,"Filtro ["+cTitCad+"]",@aParam,,,,,,,cParRom,.T.,.T.)
	//--------------------------------------------------------------------------------
	Do Case
		//"T=Todos"
		Case SubStr(mv_par01,1,1) == "T"
			cRet := ""

		//1=NF
		Case SubStr(mv_par01,1,1) == "1"
			cRet := cAls1+"_TIPXML = '1' "

		//2=CT
		Case SubStr(mv_par01,1,1) == "2"
			cRet := cAls1+"_TIPXML = '2' "

		//3=XML Pendente
		Case SubStr(mv_par01,1,1) == "3"
			cRet := cAls1+"_TIPXML = '3' "

	EndCase

	//--------------------------------------------------------------------------------
	Do Case
		//T=Todos
		Case SubStr(mv_par02,1,1) == "T"
			cRet += ''

		//N=Normal
		Case SubStr(mv_par02,1,1) == "N"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_TIPDOC = 'N' "

		//D=Devolucao
		Case SubStr(mv_par02,1,1) == "D"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_TIPDOC = 'D' "

		//B=Beneficiamento
		Case SubStr(mv_par02,1,1) == "B"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_TIPDOC = 'B' "

		//C=Complementar
		Case SubStr(mv_par02,1,1) == "C"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_TIPDOC = 'C' "

		//A=Ajuste
		Case SubStr(mv_par02,1,1) == "A"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_TIPDOC = 'A' "

		//U=Anulacao
		Case SubStr(mv_par02,1,1) == "U"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_TIPDOC = 'U' "

		//S=Substituicao
		Case SubStr(mv_par02,1,1) == "S"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_TIPDOC = 'S' "

		//X=Indefinido
		Case SubStr(mv_par02,1,1) == "X"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_TIPDOC = 'X' "

	EndCase

	//--------------------------------------------------------------------------------
	Do Case
		//T=Todos Status
		Case SubStr(mv_par03,1,1) == "T"
			cRet += ''

		//0=XML pendente de recebimento
		Case SubStr(mv_par03,1,1) == "0"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_STATUS = '0' "

		//1=XML recebido com sucesso
		Case SubStr(mv_par03,1,1) == "1"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_STATUS = '1' "

		//2=XML recebido com erro
		Case SubStr(mv_par03,1,1) == "2"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_STATUS = '2' "

		//3=XML j? incluido no sistema
		Case SubStr(mv_par03,1,1) == "3"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_STATUS = '3' "

		//4=XML gerou erro na pre-nota
		Case SubStr(mv_par03,1,1) == "4"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_STATUS = '4' "

		//5=XML gerou pre-nota depois foi exclu?da
		Case SubStr(mv_par03,1,1) == "5"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_STATUS = '5' "

		//6=XML de cancelamento recebido
		Case SubStr(mv_par03,1,1) == "6"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_STATUS = '6' "

		//7=XML bloqueado pelo validador
		Case SubStr(mv_par03,1,1) == "7"
				cRet += IIf(Empty(cRet),""," AND ")
				cRet := cAls1+"_STATUS = '7' "


	EndCase

	//--------------------------------------------------------------------------------

	lRet := .T.
EndIf

Return({lRet,cRet})

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNFil()
//|Autor.....: Luiz Alberto
//|Data......: 10 de setembro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNFil()
*-----------------------------------------------------------*

//Faz a pergunta e monta filtro
Local aRetPerg := fFiltroCad()
Local oObjMBrw := GetObjBrow()
	
//Se pergunta confirmada, executa filtro, caso contrario, sai da rotina
If aRetPerg[1]
	//Limpar filtro
	SetMBTopFilter(cStrCad, "")

	cFilCad := aRetPerg[2]
	aIndexCad := {}

	If !Empty(cFilCad)
		oObjMBrw:ResetLen()
		(cStrCad)->(DbClearFilter())

		SetMBTopFilter(cStrCad,cFilCad,,.T.)

		DbSelectArea(cStrCad)
		(cStrCad)->(dbGoTop())

		oObjMBrw:GoPgDown()
		oObjMBrw:Refresh()

		oObjMBrw:GoTop()
		oObjMBrw:Refresh()

		oObjMBrw:GoPgUp()
		oObjMBrw:Refresh()
	EndIf

EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCores()
//|Autor.....: Luiz Alberto
//|Data......: 10 de setembro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCores()
*-----------------------------------------------------------*

Local aCores := {}
Local cAls := AllTrim(cFMAlias01)
cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)

//'BR_VERDE' = XML Pendente de recebimento
aAdd(aCores,{cAls+'_STATUS == "0" ','BR_AZUL'   })

//'BR_VERDE'    = XML Recebido com sucesso
aAdd(aCores,{cAls+'_STATUS == "1" ','BR_VERDE'   })

//'BR_AMARELO'  = XML Recebido com erro
aAdd(aCores,{cAls+'_STATUS == "2" ','BR_AMARELO' })

//'BR_LARANJA'  = XML j? incluido no sistema
aAdd(aCores,{cAls+'_STATUS == "3" ','BR_LARANJA' })

//'BR_VERMELHO' = XML Gerou erro na pre-nota
aAdd(aCores,{cAls+'_STATUS == "4" ','BR_VERMELHO' })

//'BR_PINK'     = XML Gerou pre-nota depois exclu?da
aAdd(aCores,{cAls+'_STATUS == "5" ','BR_PINK'   })

//'BR_PRETO'    = Chave Cancelada no Sefaz
aAdd(aCores,{cAls+'_STATUS == "6" ','BR_PRETO'   })

//'BR_CINZA'    = Chave foi bloqueada pela validacao
aAdd(aCores,{cAls+'_STATUS == "7" ','BR_CINZA'   })

Return(aCores)

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNLeg()
//|Autor.....: Luiz Alberto
//|Data......: 10 de setembro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNLeg()
*-----------------------------------------------------------*

Local cCadLeg	:= "Status Gerenciador XML"
Local aLegenda	:= {}

aAdd(aLegenda,{'BR_AZUL'     ,'XML pendente de recebimento'           })
aAdd(aLegenda,{'BR_VERDE'    ,'XML recebido com sucesso'              })
aAdd(aLegenda,{'BR_AMARELO'  ,'XML recebido com erro'                 })
aAdd(aLegenda,{'BR_LARANJA'  ,'XML ja incluido no sistema'            })
aAdd(aLegenda,{'BR_VERMELHO' ,'XML gerou erro na pre-nota'            })
aAdd(aLegenda,{'BR_PINK'     ,'XML gerou pre-nota depois foi exclu?da'})
aAdd(aLegenda,{'BR_PRETO'    ,'XML de cancelamento recebido'          })
aAdd(aLegenda,{'BR_CINZA'    ,'XML bloqueado pelo validador'          })

BrwLegenda(cCadLeg,"Legenda",aLegenda)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fMenu()
//|Autor.....: Luiz Alberto
//|Data......: 10 de setembro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fMenu()
*-----------------------------------------------------------*

Local aRotina := {{ OemToAnsi("Pesquisar"    ),"AxPesqui"     ,  0 , 1},;
				  { OemToAnsi("Visualiza XML"),"U_GXNVis"     ,  0 , 2},; //OK
				  { OemToAnsi("Historico"    ),"U_GXNHis"     ,  0 , 4},; //OK
				  { OemToAnsi("Legendas"     ),"U_GXNLeg"     ,  0 , 3},; //OK
				  { OemToAnsi("Alterar"      ),"AxAltera"     ,  0 , 4},; //OK
				  { OemToAnsi("Parametros"   ),"U_GXNPar"     ,  0 , 3},; //OK
				  { OemToAnsi("Valida XML"   ),"U_GXNFVL"     ,  0 , 4},; //OK
				  { OemToAnsi("Vld Todos XML"),"U_GXNVld"     ,  0 , 3},; //OK
				  { OemToAnsi("Incluir XML"  ),"U_GXNInc"     ,  0 , 3},; //OK
				  { OemToAnsi("Exportar XML" ),"U_GXNExp"     ,  0 , 3},; //OK
				  { OemToAnsi("Gerar Pre-NF" ),"U_GXNImp"     ,  0 , 4},; //OK
				  { OemToAnsi("Filtra Browse"),"U_GXNFil"     ,  0 , 3},; //OK
				  { OemToAnsi("Baixar XML"   ),"U_GXNBxa"     ,  0 , 3},; //OK
				  { OemToAnsi("Ajus.Tip.Doc."),"U_GXNAju"     ,  0 , 4} } //OK


//				  { OemToAnsi("@Tratar XML"  ),"U_GXNTrt"     ,  0 , 3} } //OK - Nao vamos disponibilizar individialmente pra evitar confusao
//				  { OemToAnsi("Recebe Merc"  ),"U_GXNRec"     ,  0 , 3},; //Pendente de desenvolvimento

//Troque alguns termos pra facilitar para usu?rio
//Pesquisar   //x
//Historico   //x
//Incluir     //x Anexar XML
//Filtrar     //x Padrao mBrowse
//Importar    //x Gera Pre-NF
//Exportar    //x Exporta XML
//Recebimento //  Recebe Mercadoria
//Legendas    //x

Return(aRotina)

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNAju()
//|Autor.....: Luiz Alberto
//|Data......: 09 de janeiro de 2015, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNAju()
*-----------------------------------------------------------*
	Processa( {|| fAjustTipo()   },"Ajustando tipo ..." )
Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNVis()
//|Autor.....: Luiz Alberto
//|Data......: 09 de janeiro de 2015, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNVis()
*-----------------------------------------------------------*

Local cFileDes := ""
Local cPathTmp := AllTrim(GetTempPath())

Local cDirIni  := AllTrim(SuperGetMv("MV_FM_DXML",,"\data\impxml\"))

Local cTab1    := GetNewPar("MV_FMALS01",'')
Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

Local cCnpjE := AllTrim((cTab1)->&(cAls1+"_DECNPJ"))
Local cFile  := AllTrim((cTab1)->&(cAls1+"_ARQUIV"))
Local cData  :=    DtoS((cTab1)->&(cAls1+"_DTEMIS"))
Local cMes   := Substr(cData,5,2)
Local cAno   := Substr(cData,1,4)

cFileDes := cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\"+AllTrim(cFile)
cPathTmp := cPathTmp+AllTrim(cFile)

If File(cPathTmp)
	fErase(cPathTmp)
EndIf
If File(cPathTmp)
	Alert("Arquivo j? est? aberto!")
	Return
EndIf

COPY File &cFileDes TO &cPathTmp
ShellExecute("open",cPathTmp,"","", 5 )

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNPar()
//|Autor.....: Luiz Alberto
//|Data......: 11 de dezembro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
USer Function GXNPar()
*-----------------------------------------------------------*

Local oDialg

//Variaveis do tamanho a tela
Local aDlgTela     := {}
Local aSizeAut     := {}
Local aInfo        := {}
Local aObjects     := {}
Local aPosObj      := {}
Local cVarTemp     := ""

Private cPrtCad    := " Par?metros [ GERENCIADOR XML NFe ] "
Private lParamOK   := .F.
Private oGdParam   := Nil

//Somente o usu?rio ADMIN pode alterar os parametros
//If !__cUserID $ "000000*000059"
//	MsgAlert("Somente o usu?rio ADMIN pode alterar os parametros.")
//	Return()
//EndIf

//Define tela em relacao a area de trabalho
aSizeAut := {0       ,;
			 0       ,;
			 (0700)/2,;
			 (0350)/2,;
			 (0700)  ,;
			 (0350)  ,;
			 0        }

aInfo    := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aObjects := {}

aAdd(aObjects,{100,100,.T.,.T.}) //Itens Parametros
aAdd(aObjects,{100,020,.T.,.F.}) //Rodape
aPosObj  := MsObjSize(aInfo,aObjects)

//Variaveis do tamanho a tela
aDlgTela := {aSizeAut[7],aSizeAut[1],aSizeAut[6],aSizeAut[5]}

// Montagem da tela que serah apresentada para usuario (lay-out)
Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Of oMainWnd Pixel

/*Itens     */ fParamIts(aPosObj[1],oDialg)
/*Rodape    */ fParamRod(aPosObj[2],oDialg)

Activate MsDialog oDialg Centered

//Se confirmado
If lParamOK
	SX6->(DbSetOrder(1))
	For y:=1 To Len(oGdParam:aCols)
		cVarTemp0 := Space(Len(xFilial()))
		cVarTemp1 := AllTrim(oGdParam:aCols[y, aScan(oGdParam:aHeader,{|x|AllTrim(x[2])=="XX_PARAMET"}) ])
		cVarTemp2 := AllTrim(oGdParam:aCols[y, aScan(oGdParam:aHeader,{|x|AllTrim(x[2])=="XX_CONTEUD"}) ])
		cVarTemp3 := AllTrim(oGdParam:aCols[y, aScan(oGdParam:aHeader,{|x|AllTrim(x[2])=="XX_DESCRIC"}) ])
		cVarTemp4 := AllTrim(oGdParam:aCols[y, aScan(oGdParam:aHeader,{|x|AllTrim(x[2])=="XX_TIPO"}) ])
		If SX6->(DbSeek( cVarTemp0 + cVarTemp1 ))
			RecLock("SX6",.F.)
		Else
			RecLock("SX6",.T.)
			SX6->X6_FIL		:= cVarTemp0
			SX6->X6_VAR 	:= cVarTemp1
			SX6->X6_TIPO	:= cVarTemp4
			SX6->X6_PROPRI	:= 'U'
		EndIf
		SX6->X6_CONTEUD	:= cVarTemp2
		SX6->X6_CONTSPA	:= cVarTemp2
		SX6->X6_CONTENG	:= cVarTemp2
		SX6->X6_DESCRIC := cVarTemp3
		SX6->(MsUnLock())
	Next y
	MsgInfo("As alteracoes foram SALVAS com SUCESSO !!!"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Para que as alteracoes tenham efeito, sair da rotina e entrar novamente.")
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fParamIts()
//|Autor.....: Luiz Alberto
//|Data......: 09 de Dezembro de 2014, 23:30
//|Descricao.: Rodape da tela principal
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fParamIts(aSizeDlg,oDialg)
*-----------------------------------------------------------*

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Local cGetOpc        := GD_UPDATE                                       // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
Local aHead          := {}                                              // Array do aHeader
Local aCols          := {}                                              // Array do aCols
Local aFM_Param      := {}

aAdd(aFM_Param,{"MV_FMALS01","Alias da tabela principal da rotina"                             ,'C', fX6Ret("MV_FMALS01","PW1"                                    )  })
aAdd(aFM_Param,{"MV_FMALS02","Alias da tabela de historico dos XML"                            ,'C', fX6Ret("MV_FMALS02","PW2"                                    )  })
aAdd(aFM_Param,{"MV_FM_DXML","Diretorio onde ser? salvo os arquivos XML"                       ,'C', fX6Ret("MV_FM_DXML","\data\impxml\"                       )  })
aAdd(aFM_Param,{"MV_FMCPOP3","POP3 do servidor de e-mails pra baixar os XML."                  ,'C', fX6Ret("MV_FMCPOP3","pop.seudominio.com.br"               )  })
aAdd(aFM_Param,{"MV_FMCMAIL","E-MAIL da conta que receber? os XML que serao usados na rotina"  ,'C', fX6Ret("MV_FMCMAIL","protheus@seudominio.com.br"          )  })
aAdd(aFM_Param,{"MV_FMCPASS","SENHA da conta de e-mail que receber? os XML"                    ,'C', fX6Ret("MV_FMCPASS","senhaemail"                          )  })
aAdd(aFM_Param,{"MV_FMNFBEN","CFOP das NF de Beneficiamento"                                   ,'C', fX6Ret("MV_FMNFBEN","1901/1920/1916/1949"                 )  })
aAdd(aFM_Param,{"MV_FMNFDEV","CFOP das NF de Devolucao"                                        ,'C', fX6Ret("MV_FMNFDEV","1201/2201/1202/2202"                 )  })
aAdd(aFM_Param,{"MV_FMNFCOM","CFOP das NF de Complemento"                                      ,'C', fX6Ret("MV_FMNFCOM","1352/3101/3102/3551"                 )  })
aAdd(aFM_Param,{"MV_FM_MAIL","E-MAIL das pessoas que receberao o WF de confirmacao ou cr?tica" ,'C', fX6Ret("MV_FM_MAIL",""              )  })//lalberto@3lsystems.com.br;
aAdd(aFM_Param,{"MV_FM_HTML","Arquivo modelo HTML usado no envio dos WF"                       ,'C', fX6Ret("MV_FM_HTML","\workflow\modelo\aviso_prenota.htm"  )  })
aAdd(aFM_Param,{"MV_FMTAGPC","Usar TAG NUMPC e ITEMPC do XML pra associar a NFe (S ou N)"      ,'C', fX6Ret("MV_FMTAGPC","S"                                   )  })
aAdd(aFM_Param,{"MV_FMSA501","Campo SA5, Unidade de Medida do arquivo XML"                     ,'C', fX6Ret("MV_FMSA501","A5_XXUMXML"                          )  })//"A5_XXUMXML"
aAdd(aFM_Param,{"MV_FMSA502","Campo SA5, Numero do Fator de Conversao XML x SB1"               ,'C', fX6Ret("MV_FMSA502","A5_XXFCNUM"                          )  })//"A5_XXFCNUM"
aAdd(aFM_Param,{"MV_FMSA503","Campo SA5, Tipo do Fator de Conversao, Multiplicacao ou Divisao" ,'C', fX6Ret("MV_FMSA503","A5_XXFCTIP"                          )  })//"A5_XXFCTIP"
aAdd(aFM_Param,{"MV_FMSA504","Campo SA5, NCM Produto Fornecedor"                               ,'C', fX6Ret("MV_FMSA504","A5_NCMPRF"                          )  })//"A5_NCMPRF"
aAdd(aFM_Param,{"MV_FMSA701","Campo SA7, Unidade de Medida do arquivo XML"                     ,'C', fX6Ret("MV_FMSA701","A7_XXUMXML"                          )  })//"A7_XXUMXML"
aAdd(aFM_Param,{"MV_FMSA702","Campo SA7, Numero do Fator de Conversao XML x SB1"               ,'C', fX6Ret("MV_FMSA702","A7_XXFCNUM"                          )  })//"A7_XXFCNUM"
aAdd(aFM_Param,{"MV_FMSA703","Campo SA7, Tipo do Fator de Conversao, Multiplicacao ou Divisao" ,'C', fX6Ret("MV_FMSA703","A7_XXFCTIP"                          )  })//"A7_XXFCTIP"
aAdd(aFM_Param,{"MV_FMSA704","Campo SA7, NCM Produto Fornecedor"                               ,'C', fX6Ret("MV_FMSA704","A7_NCMCLI"                          )  })//"A7_NCMCLI"
aAdd(aFM_Param,{"MV_FVALEMP","Avalia Empresa Logada e So Permite Importacao para Ela"          ,'L', fX6Ret("MV_FVALEMP",".f."                                 )  })
aAdd(aFM_Param,{"MV_FMXPOP" ,"Habilita ou Nao a Busca de XML?s por Email"                      ,'L', fX6Ret("MV_FMXPOP" ,".f."                                 )  })
aAdd(aFM_Param,{"MV_XMLDML" ,"Efetua a Exclus?o dos Emails Lidos no Servidor ?"                ,'L', fX6Ret("MV_XMLDML" ,".T."                                 )  })
aAdd(aFM_Param,{"MV_FWSCONS","Valida XML via WebService Totvs"                                 ,'L', fX6Ret("MV_FWSCONS",".f."                                 )  })
aAdd(aFM_Param,{"MV_XMLZDC" ,"Numero da Nota Com Zeros ? Esquerda"                             ,'L', fX6Ret("MV_FWSCONS",".T."                                 )  })
aAdd(aFM_Param,{"MV_XCTTIP","Cte Gera P=Pre-Nota ou N=Nota"                                    ,'C', fX6Ret("MV_XCTTIP","N"                                )  })
aAdd(aFM_Param,{"MV_XCTPRD","Produto Padrao CTe"                                               ,'C', fX6Ret("MV_XCTPRD","726"                                    )  })
aAdd(aFM_Param,{"MV_XCTTES","Tes Padrao Cte"                                                   ,'C', fX6Ret("MV_XCTTES","125"                                 )  })
aAdd(aFM_Param,{"MV_XCTCNT","Conta Contabil CTe"                                               ,'C', fX6Ret("MV_XCTCNT","5010107022"                                 )  })
aAdd(aFM_Param,{"MV_XCTCUS","Centro Custo CTe"                                                 ,'C', fX6Ret("MV_XCTCUS","430"                                 )  })
aAdd(aFM_Param,{"MV_XCTNAT","Natureza CTe"                                                     ,'C', fX6Ret("MV_XCTNAT","200"                                 )  })
aAdd(aFM_Param,{"MV_XCTPAG","Condicao Pagamento CTe"                                           ,'C', fX6Ret("MV_XCTPAG","001"                                 )  })



//Estrutura MsNewGetDados
aAdd(aHead,{"Item"        ,"XX_ITEM"      ,"@!"                 ,           03,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Parametro"   ,"XX_PARAMET"   ,"@!"                 ,           15,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Conteudo"    ,"XX_CONTEUD"   ,"@S40"               ,          250,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ," "      , ""                            , ""        , ""        })
aAdd(aHead,{"Tipo"        ,"XX_TIPO"      ,"@!"                 ,           05,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Descricao"   ,"XX_DESCRIC"   ,""                   ,          250,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

For x:=1 To Len(aFM_Param)
	//Cria uma linha no aCols
	aAdd(aCols,Array(Len(aHead)+1))
	nLin := Len(aCols)
	
	//Alimenta a linha do aCols vazia
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_ITEM"   }) ] := StrZero(x,3)
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_PARAMET"}) ] := aFM_Param[x][1]
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_TIPO"}) ]    := aFM_Param[x][3]
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_CONTEUD"}) ] := Padr(aFM_Param[x][4],250)
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_DESCRIC"}) ] := aFM_Param[x][2]
	aCols[nLin, Len(aHead)+1]                                  := .F.
Next x

oGdParam:=MsNewGetDados():New(aSizeDlg[1]+5,aSizeDlg[2]+5,aSizeDlg[3]-5,aSizeDlg[4]-5,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fX6Ret()
//|Autor.....: Luiz Alberto
//|Data......: 09 de Dezembro de 2014, 23:30
//|Descricao.: Retorna Parametros
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fX6Ret(cPar,cCont)
*-----------------------------------------------------------*

Local cRet    := ""
Default cPar  := ""
Default cCont := ""

SX6->(DbSetOrder(1))
cVarTemp0 := Space(Len(xFilial()))
cVarTemp1 := PadR(AllTrim(cPar),10)
If SX6->(DbSeek( cVarTemp0 + cVarTemp1 ))
	cRet := SX6->X6_CONTEUD
Else
	cRet := cCont
EndIf

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fParamRod()
//|Autor.....: Luiz Alberto
//|Data......: 09 de Dezembro de 2014, 23:30
//|Descricao.: Rodape da tela principal
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fParamRod(aSizeDlg,oDialg)
*-----------------------------------------------------------*

Local nTamBtn := (aSizeDlg[4]/7)
Local aBtn01  := {aSizeDlg[1]+5,   (nTamBtn*5),   nTamBtn-5, 012}
Local aBtn02  := {aSizeDlg[1]+5,   (nTamBtn*6),   nTamBtn-5, 012}

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Botoes
@ aBtn01[1],aBtn01[2] Button "Fechar"    Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fParFechar(oDialg)
@ aBtn02[1],aBtn02[2] Button "Confirmar" Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fParConfir(oDialg)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fParFechar()
//|Autor.....: Luiz Alberto
//|Data......: 09 de Dezembro de 2014, 23:30
//|Descricao.: Botao [ Fechar ] = Sai da rotina e aborta operacao
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fParFechar(oDialg)
*-----------------------------------------------------------*

If SimNao("AVISO: Ao fechar, as informacoes nao salvas serao perdidas!"+Chr(13)+Chr(10)+"DESEJA sair assim mesmo?") == "S"
	lParamOK := .F.
	oDialg:End()
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fParConfir()
//|Autor.....: Luiz Alberto
//|Data......: 09 de Dezembro de 2014, 23:30
//|Descricao.: Botao [ Confirmar ]
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fParConfir(oDialg)
*-----------------------------------------------------------*

lParamOK := .T.
oDialg:End()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNExp()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNExp()
*-----------------------------------------------------------*

fGerTela("E") //Exportacao XML

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNExp()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNImp()
*-----------------------------------------------------------*

fGerTela("I") //Importacao XML (Gerar Pre-nota)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerTela()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerTela(cOper)
*-----------------------------------------------------------*
Local oDialg
Local cPrtCad      := " Gerenciador XML [ "+IIf(cOper=="E","Exportar Aquivo","Gerar Pre-Nota")+" ]"

Local cTab1        := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

//Variaveis do tamanho a tela
Local aDlgTela     := {}
Local aSizeAut     := {}
Local aInfo        := {}
Local aObjects     := {}
Local aPosObj      := {}

//----------------------------------------------------------
Private oSayTipXml := Nil
Private oGetTipXml := Nil
Private cGetTipXml := "T"
//----------------------------------------------------------
Private oSayStatus := Nil
Private oGetStatus := Nil
Private cGetStatus := "T"
//----------------------------------------------------------
Private oSayComCCe := Nil
Private oGetComCCe := Nil
Private cGetComCCe := "T"
//----------------------------------------------------------
Private oSayCnpjEm := Nil
Private oGetCnpjEm := Nil
Private cGetCnpjEm := Space(fX3Ret(cAls1+"_DECNPJ","X3_TAMANHO"))
//----------------------------------------------------------
Private oSayNomeEm := Nil
Private oGetNomeEm := Nil
Private cGetNomeEm := Space(fX3Ret(cAls1+"_DENOME","X3_TAMANHO"))


//----------------------------------------------------------
Private oSayTipDoc := Nil
Private oGetTipDoc := Nil
Private cGetTipDoc := "T"
//----------------------------------------------------------
Private oSayDtEmis := Nil
Private oGetDtEmis := Nil
Private dGetDtEmis := StoD("")
//----------------------------------------------------------
Private oSaySerNFe := Nil
Private oGetSerNFe := Nil
Private cGetSerNFe := Space(fX3Ret(cAls1+"_SERIE","X3_TAMANHO"))
//----------------------------------------------------------
Private oSayNumNFe := Nil
Private oGetNumNFe := Nil
Private cGetNumNFe := Space(fX3Ret(cAls1+"_DOC","X3_TAMANHO"))
//----------------------------------------------------------
Private oSayChvNFe := Nil
Private oGetChvNFe := Nil
Private cGetChvNFe := Space(fX3Ret(cAls1+"_CHVNFE","X3_TAMANHO"))


//----------------------------------------------------------
Private oGdItm01   := Nil
//----------------------------------------------------------
Private aHdStatus  := {}
Private aHeadCpos  := {}
Private aOrdHead   := {}
Private nCtrlClik  := 1

aAdd(aHdStatus,{cAls1+'_STATUS == "0" ','BR_AZUL'    , "XML pendente de recebimento"            })
aAdd(aHdStatus,{cAls1+'_STATUS == "1" ','BR_VERDE'   , "XML recebido com sucesso"               })
aAdd(aHdStatus,{cAls1+'_STATUS == "2" ','BR_AMARELO' , "XML recebido com erro"                  })
aAdd(aHdStatus,{cAls1+'_STATUS == "3" ','BR_LARANJA' , "XML ja incluido no sistema"             })
aAdd(aHdStatus,{cAls1+'_STATUS == "4" ','BR_VERMELHO', "XML gerou erro na pre-nota"             })
aAdd(aHdStatus,{cAls1+'_STATUS == "5" ','BR_PINK'    , "XML gerou pre-nota depois foi excluida" })
aAdd(aHdStatus,{cAls1+'_STATUS == "6" ','BR_PRETO'   , "XML de cancelamento recebido"           })
aAdd(aHdStatus,{cAls1+'_STATUS == "7" ','BR_CINZA'   , "XML bloqueado pelo validador"           })

//Campos que serao apresentados no MsNewGetDados
aAdd(aHeadCpos,cAls1+"_FILIAL" )
aAdd(aHeadCpos,cAls1+"_TIPDOC" )
aAdd(aHeadCpos,cAls1+"_TIPXML" )
aAdd(aHeadCpos,cAls1+"_TEMCCE" )
aAdd(aHeadCpos,cAls1+"_CHVNFE" )
aAdd(aHeadCpos,cAls1+"_SERIE"  )
aAdd(aHeadCpos,cAls1+"_DOC"    )
aAdd(aHeadCpos,cAls1+"_DTEMIS" )
aAdd(aHeadCpos,cAls1+"_HREMIS" )
aAdd(aHeadCpos,cAls1+"_DECNPJ" )
aAdd(aHeadCpos,cAls1+"_DENOME" )
aAdd(aHeadCpos,cAls1+"_VLRTOT" )
aAdd(aHeadCpos,cAls1+"_LOGDT"  )
aAdd(aHeadCpos,cAls1+"_LOGHR"  )
aAdd(aHeadCpos,cAls1+"_LOGUSR" )
//aAdd(aHeadCpos,cAls1+"_MXML"   )
//aAdd(aHeadCpos,cAls1+"_MXML2"  )

// Maximizacao da tela em relacao a area de trabalho
aSizeAut := MsAdvSize()
nSpceBar := 12 //Por nao usar o EnchoiceBar, vou consumir o espaco dele na tela
aInfo    := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4]+nSpceBar,3,3}
aObjects := {}

aAdd(aObjects,{100,055,.T.,.F.}) //Cabecalho
aAdd(aObjects,{100,100,.T.,.T.}) //Corpo
aAdd(aObjects,{100,020,.T.,.F.}) //Rodape
aPosObj  := MsObjSize(aInfo,aObjects)

//Variaveis do tamanho a tela
aDlgTela := {aSizeAut[7],aSizeAut[1],aSizeAut[6],aSizeAut[5]}

// Montagem da tela que serah apresentada para usuario (lay-out)
Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Of oMainWnd Pixel

/*Cabecalho  */ fGerCabec(aPosObj[1],oDialg,cOper)
/*Resultado  */ fGerCorpo(aPosObj[2],oDialg,cOper)
/*Rodape     */ fGerRodap(aPosObj[3],oDialg,cOper)

Activate MsDialog oDialg

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerCorpo()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerCorpo(aSizeDlg,oDialg,cOper)
*-----------------------------------------------------------*

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Local cGetOpc        := Nil                                             // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
Local aHead          := {}                                              // Array do aHeader
Local aCols          := {}                                              // Array do aCols

//          X3_TITULO    , X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO , X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
aAdd(aHead,{""           ,"XX_FLAG"      ,"@BMP"               ,          01,          0, ""      , "??????????????", "C"     , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{""           ,"XX_STATUS"    ,"@BMP"               ,          01,          0, ""      , "??????????????", "C"     , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

For x:=1 To Len(aHeadCpos)
	cX3_Descr := fX3Ret(aHeadCpos[x],"X3_TITULO" )
	cX3_Campo := fX3Ret(aHeadCpos[x],"X3_CAMPO"  )
	cX3_Tipo  := fX3Ret(aHeadCpos[x],"X3_TIPO"   )
	cX3_Pictu := fX3Ret(aHeadCpos[x],"X3_PICTURE")
	nX3_Tam01 := fX3Ret(aHeadCpos[x],"X3_TAMANHO")
	nX3_Tam02 := fX3Ret(aHeadCpos[x],"X3_DECIMAL")
	cX3_CbBox := fX3Ret(aHeadCpos[x],"X3_CBOX"   )
	aAdd(aHead,{cX3_Descr,cX3_Campo      ,cX3_Pictu            ,   nX3_Tam01,  nX3_Tam02, ""      , "??????????????", cX3_Tipo, ""      , "R"        , cX3_CbBox          , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
Next x

aAdd(aHead,{"Recno"     ,"XX_RECNO"     ,""                   ,          14,          0, ""      , "??????????????", "N"     , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
aAdd(aCols,Array(Len(aHead)+1))
nLin := Len(aCols)

//Alimenta a linha do aCols vazia
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_FLAG"  }) ] := "LBNO"
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_STATUS"}) ] := "ENABLE"

For y:=1 To Len(aHeadCpos)
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])==aHeadCpos[y]}) ] := CriaVar(aHeadCpos[y],.F.)
Next y

aCols[nLin, Len(aHead)+1] := .F.

oGdItm01:=MsNewGetDados():New(aSizeDlg[1],aSizeDlg[2],aSizeDlg[3],aSizeDlg[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
oGdItm01:oBrowse:bLDblClick := {|| fGerDpClic() }
oGdItm01:oBrowse:bHeaderClick := {|x,y| fGerTrtCol(y)  }

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerDpClic()
//|Autor.....: Luiz Alberto
//|Data......: 14 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerDpClic()
*-----------------------------------------------------------*

Local nLinhaOK := oGdItm01:oBrowse:nAt
Local nPosFlag := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"  })

//Marca apenas o registro em questao
If oGdItm01:aCols[nLinhaOK][nPosFlag] == "LBTIK"
   oGdItm01:aCols[nLinhaOK][nPosFlag] := "LBNO"
Else
   oGdItm01:aCols[nLinhaOK][nPosFlag] := "LBTIK"
EndIf

//Atualiza tela
oGdItm01:oBrowse:nAt := nLinhaOK
oGdItm01:oBrowse:Refresh()
oGdItm01:oBrowse:SetFocus()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerTrtCol()
//|Autor.....: Luiz Alberto
//|Data......: 14 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerTrtCol(nCol)
*-----------------------------------------------------------*

Local x        := 1
Local nLinhaOK := oGdItm01:oBrowse:nAt
Local nPosFlag := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})

Default nCol      := 1

//Conta de cliques
nCtrlClik ++

//Controla pra evitar passar por duas vezes na mesma rotina
If nCtrlClik%2 != 0
	Return
EndIF

If nCol == nPosFlag
	//Marca apenas o registro em questao
	If oGdItm01:aCols[nLinhaOK][nPosFlag] == "LBTIK"
		For x:=1 To Len(oGdItm01:aCols)
			oGdItm01:aCols[x][nPosFlag] := "LBNO"
		Next x
	Else
		For x:=1 To Len(oGdItm01:aCols)
			oGdItm01:aCols[x][nPosFlag] := "LBTIK"
		Next x
	EndIf

EndIf

//Tratamento de Ordenacao
If nCol != nPosFlag

	//Trata historico de ordenacao, no maximo 3
	If Len(aOrdHead) >= 3
		While Len(aOrdHead) >= 3
			aDel(aOrdHead,1)
			aSize(aOrdHead,Len(aOrdHead)-1)
		End
	EndIf

	//Adicionar coluna pra ordenacao
	aAdd(aOrdHead,nCol)

	MsAguarde({|x,y| fGerOrdena() },"Ordenando...","Aguarde, ordenando registros ... ")

EndIf

//Atualiza tela
oGdItm01:oBrowse:nAt := nLinhaOK
oGdItm01:oBrowse:Refresh()
oGdItm01:oBrowse:SetFocus()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerOrdena()
//|Autor.....: Luiz Alberto
//|Data......: 14 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerOrdena()
*-----------------------------------------------------------*

Do Case
	Case Len(aOrdHead) == 1
		aSort(oGdItm01:aCols,,,{|x,y| fAjustaVar(x[aOrdHead[1]])                                                                                        < fAjustaVar(y[aOrdHead[1]]) })
		
	Case Len(aOrdHead) == 2
		aSort(oGdItm01:aCols,,,{|x,y| fAjustaVar(x[aOrdHead[2]]) + fAjustaVar(x[aOrdHead[1]])                                                           < fAjustaVar(y[aOrdHead[2]]) + fAjustaVar(y[aOrdHead[1]]) })
		
	Case Len(aOrdHead) == 3
		aSort(oGdItm01:aCols,,,{|x,y| fAjustaVar(x[aOrdHead[3]]) + fAjustaVar(x[aOrdHead[2]]) + fAjustaVar(x[aOrdHead[1]])                              < fAjustaVar(y[aOrdHead[3]]) + fAjustaVar(y[aOrdHead[2]]) + fAjustaVar(y[aOrdHead[1]]) })
		
EndCase

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fAjustaVar()
//|Autor.....: Luiz Alberto
//|Data......: 14 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fAjustaVar(uVar)
*-----------------------------------------------------------*

Local   cRet        := ""
Private uTipoVarTmp := uVar

Do Case
	Case Type("uTipoVarTmp") == "D"
		cRet := DtoS(uTipoVarTmp)

	Case Type("uTipoVarTmp") == "N"
		cRet := StrZero(uTipoVarTmp,14,4)

	Case Type("uTipoVarTmp") == "L"
		cRet := IIf(uTipoVarTmp,"T","F")

	Case Type("uTipoVarTmp") == "U"
		cRet := ""

	Case Type("uTipoVarTmp") == "C"
		cRet := Upper(AllTrim(uTipoVarTmp))

	Otherwise
		cRet := ""

EndCase

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerRodap()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerRodap(aSizeDlg,oDialg,cOper)
*-----------------------------------------------------------*

Local nQtdCpo := 8
Local nTamBtn := (aSizeDlg[4] / nQtdCpo)
Local aBtn00  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 4)  ,  nTamBtn-05, 012}
Local aBtn01  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 5)  ,  nTamBtn-05, 012}
Local aBtn02  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 6)  ,  nTamBtn-05, 012}
Local aBtn03  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 7)  ,  nTamBtn-05, 012}

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Botoes
@ aBtn00[1],aBtn00[2] Button "Historico"            Size aBtn00[3],aBtn00[4] Pixel Of oDialg Action fGerHistor()
@ aBtn01[1],aBtn01[2] Button "Legenda"              Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fGerLegend()
If cOper == "E"
	@ aBtn02[1],aBtn02[2] Button "Exportar Arquivo" Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action ( fGerPrcExp() , oDialg:End() )
Else
	@ aBtn02[1],aBtn02[2] Button "Gerar Pre-Nota"   Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action ( fGerPrcImp() , oDialg:End() )
EndIf
@ aBtn03[1],aBtn03[2] Button "Sair"                 Size aBtn03[3],aBtn03[4] Pixel Of oDialg Action oDialg:End()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerPrcImp()
//|Autor.....: Luiz Alberto
//|Data......: 28 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerHistor()
*-----------------------------------------------------------*

Local cTab1    := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local nPosRecn := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_RECNO" })
Local nLinHist := oGdItm01:oBrowse:nAt
Local nRecHist := oGdItm01:aCols[nLinHist][nPosRecn]

//Posiciona no Registro que ser? exibido o Historico
(cTab1)->(DbGoTo(nRecHist))

//Chama rotina que exibe o historico
U_GXNHis()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerPrcImp()
//|Autor.....: Luiz Alberto
//|Data......: 28 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerPrcImp()
*-----------------------------------------------------------*

If Len(oGdItm01:aCols) > 0
	Processa( {|| fGerPrcXml()    },"Processando XML selecionados..." )
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerPrcXml()
//|Autor.....: Luiz Alberto
//|Data......: 28 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerPrcXml()
*-----------------------------------------------------------*
Local x        := 0
Local lProc    := .T.
Local nRecTab1 := 0
Local cTipoXml := ""
Local oXmlTab1 := Nil

Local cTab1        := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

Local nPosFlag := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])==    "XX_FLAG"  })
Local nPosRecn := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])==    "XX_RECNO" })
Local nPosTXml := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])==cAls1+"_TIPXML"})

ProcRegua(Len(oGdItm01:aCols))

For x:=1 To Len(oGdItm01:aCols)
	If oGdItm01:aCols[x][nPosFlag] == "LBTIK"
		IncProc()

		//Recno do registro corrente
		nRecTab1 :=  0
		nRecTab1 := oGdItm01:aCols[x][nPosRecn]

		//Tipo do XML do registro corrente
		cTipoXml := oGdItm01:aCols[x][nPosTXml]
		
		//Validando e Preparando NFe
		If cTipoXml == "1"
			//Valida XML e monta Objeto
			oXmlTab1 := Nil
			lProc    := .T.
			lProc    := fGerVldNFe(nRecTab1,@oXmlTab1)
		EndIf

		//Validando e Preparando CTe
		If cTipoXml == "2"
			//Valida XML e monta Objeto
			oXmlTab1 := Nil
			lProc    := .T.
			lProc    := fGerVldCTe(nRecTab1,@oXmlTab1)
		EndIf
	EndIf
Next x

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerVldNFe()
//|Autor.....: Luiz Alberto
//|Data......: 28 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerVldNFe(nRecTab1,oXmlTab1)
*-----------------------------------------------------------*

Local x         :=  0
Local lProc     := .T.
Local cTagPC    := AllTrim(SuperGetMv("MV_FMTAGPC",,"S"))
Local cTab1     := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1     := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cAviso    := ""
Local cErro     := ""
Local cMmXml    := ""
Local lEhFornec := .F.
Local cCodCliFor:= ""
Local cLojCliFor:= ""
Local cNomCliFor:= ""
Local cCndCliFor:= ""
Local cCodProdut:= ""
Local aCabec    := {}
Local aItens    := {}
Local aUnidMed  := {}
Local aPrdDesc  := {}

Local cMsgErro  := ""
Local cMsErro2  := ""
Local cMsgNota  := ""
Local cMsgAssu  := ""
Local cMsgFoCl  := ""

Local cCpoUmXml := ""
Local cCpoFCNum := ""
Local cCpoFCTip := ""
Local lFatorCnv := .F.

Local nCadFatCon:= 0
Local cCadTipCon:= ""
Local cOperConv := ""
Local nQtdProd  := 0

Private oNFe    := Nil
Private oNF     := Nil
Private oItens  := Nil
Private oItemTemp := Nil
Private aGXNPE001 := Nil



//Posiciona no registro correto
(cTab1)->(DbGoTo(nRecTab1))

//Valida Status, pois so pode executar se STATUS == 1
If lProc .And. (cTab1)->&(cAls1+"_STATUS") != "1"
	If (cTab1)->&(cAls1+"_STATUS") <> "1"	//? Erro na Tentativa de Importacao Anterior
		If !MsgYesNo("Deseja Efetuar Nova Tentativa de Importacao do Xml que Apresentou Erro ?")	
			fGravaMsg(nRecTab1,11," ")
			lProc := .F.
		Endif
	Else
		fGravaMsg(nRecTab1,11," ")
		lProc := .F.
	Endif
EndIf

//Valida se XML e do tipo NF
If lProc .And. (!(cTab1)->&(cAls1+"_TIPDOC") $ "N/C/D/B" )
	fGravaMsg(nRecTab1,14,"4")
	lProc := .F.
EndIf

//Valida se XML e do tipo NF
If lProc .And. (!(cTab1)->&(cAls1+"_TIPXML") $ "1" )
	fGravaMsg(nRecTab1,14,"4")
	lProc := .F.
EndIf

//Prepara String XML para tornar em Objeto
If lProc
	cMmXml   := ""
	cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML" ))
	cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML2"))
	//cMmXml   := EncodeUTF8(cMmXml)
	If Empty(cMmXml)
		//XML pendente de recebimento ( Status = 0 )
		lProc := .F.
		fGravaMsg(nRecTab1,12,"0")
	EndIf
EndIf

//Converte String XML em Objeto XML
If lProc
	cAviso   := ""
	cErro    := ""
	oXmlTab1 := Nil
	oXmlTab1 := XmlParser(cMmXml,"_",@cAviso,@cErro)
	Do Case
		Case !Empty(cErro)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.
			
		Case !Empty(cAviso)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.
			
		Case Empty(oXmlTab1)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.

		OtherWise
			//Prepara Objeto pra receber XML
			oNFe := oXmlTab1
			oNF  := IIf(Type("oNFe:_NfeProc")<>"U" , oNFe:_NFeProc:_NFe , oNFe:_NFe)
	
	EndCase
EndIf

//Identifica se e cliente ou fornecedor e o codigo correto
If lProc
	cCodCliFor := ""
	cLojCliFor := ""
	cNomCliFor := ""
	cCndCliFor := ""
	lEhFornec  := .F.
	Do Case
		Case (cTab1)->&(cAls1+"_TIPDOC") $ "N/C"
			lEhFornec  := .T.
			SA2->(DbSetOrder(3))
			If SA2->(DbSeek(xFilial("SA2")+(cTab1)->&(cAls1+"_DECNPJ")))
				cCodCliFor := SA2->A2_COD
				cLojCliFor := SA2->A2_LOJA
				cNomCliFor := SA2->A2_NOME
				cCndCliFor := SA2->A2_COND
			Else
				fGravaMsg(nRecTab1,2,"4")
				lProc := .F.
			EndIf
			
		Case (cTab1)->&(cAls1+"_TIPDOC") $ "D/B"
			lEhFornec  := .F.
			SA1->(DbSetOrder(3))
			If SA1->(DbSeek(xFilial("SA1")+(cTab1)->&(cAls1+"_DECNPJ")))
				cCodCliFor := SA1->A1_COD
				cLojCliFor := SA1->A1_LOJA
				cNomCliFor := SA1->A1_NOME
				cCndCliFor := SA1->A1_COND
			Else
				fGravaMsg(nRecTab1,1,"4")
				lProc := .F.
			EndIf
			
	EndCase
EndIf

//Verifica se produtos do XML estao cadastrados na tabela de relacionamento
If lProc

	//Campos Customizados referente a conversao da unidade de medida
	lFatorCnv := .F.
	cCpoUmXml := AllTrim(IIf(lEhFornec,GetNewPar("MV_FMSA501",''),GetNewPar("MV_FMSA701",'')))
	cCpoFCNum := AllTrim(IIf(lEhFornec,GetNewPar("MV_FMSA502",''),GetNewPar("MV_FMSA702",'')))
	cCpoFCTip := AllTrim(IIf(lEhFornec,GetNewPar("MV_FMSA503",''),GetNewPar("MV_FMSA703",'')))
	cCpoNCMFo := AllTrim(IIf(lEhFornec,GetNewPar("MV_FMSA504",''),GetNewPar("MV_FMSA704",'')))

	If  !Empty(fX3Ret(cCpoUmXml,"X3_CAMPO")) .And.;
		!Empty(fX3Ret(cCpoFCNum,"X3_CAMPO")) .And.;
		!Empty(fX3Ret(cCpoFCTip,"X3_CAMPO")) .And.;
		!Empty(fX3Ret(cCpoNCMFo,"X3_CAMPO")) 
		
		lFatorCnv := .T.
	EndIf

	oItens := IIf(Type("oNF:_InfNfe:_Det")=="O",{oNF:_InfNfe:_Det},oNF:_InfNfe:_Det)
	For x := 1 To Len(oItens)
		
		//------------------------------------------------------------
		//Variavel usada pra conseguir tratar via Type
		oItemTemp  := Nil
		oItemTemp  := oItens[x]
		//------------------------------------------------------------
		
		cXmlPrdCod := AllTrim(oItemTemp:_Prod:_cProd:TEXT)
		cXmlPrdDes := AllTrim(oItemTemp:_Prod:_xProd:TEXT)
		cXmlPrdNcm := AllTrim(oItemTemp:_Prod:_NCM:TEXT  )
		cXmlUniMed := AllTrim(oItemTemp:_Prod:_uCom:TEXT )
		cXmlPrdBar	   := ''
		If ALLTRIM(TYPE("oItemTemp:_Prod:_cEAN:TEXT"))=="C"
			cXmlPrdBar	   := oItemTemp:_Prod:_cEAN:TEXT	// Codigo de Barras XML
		Endif

		cCodProdut := ""
		lVldProdut := .T.
		cVldMensag := ""

		If lVldProdut
			If lEhFornec
				//Tratando tamanho do conteudo do campo
				cXmlPrdCod := fTrtCodPrd(cXmlPrdCod,"1")
				
				SA5->(DbSetOrder(14))
				If SA5->(DbSeek(xFilial("SA5") + cCodCliFor + cLojCliFor + cXmlPrdCod  ))
					cCodProdut := SA5->A5_PRODUTO
					If lFatorCnv .And. !Empty(cCpoFCNum)
						If Empty(&("SA5->"+cCpoNCMFo)) .Or. Empty(&("SA5->"+cCpoUmXml)) .Or. Empty(&("SA5->"+cCpoFCNum)) .Or. Empty(&("SA5->"+cCpoFCTip)) .Or. AllTrim(cXmlUniMed) != AllTrim(&("SA5->"+cCpoUmXml))
							lVldProdut := .F.
							cVldMensag := "O produto ("+cXmlPrdCod+") do Forncecedor esta com cadastro imcompleto na tabela de relacionamento de produtos [SA5]!"
							fGravaMsg(nRecTab1,98," ",cVldMensag)
							lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut,SA5->(Recno()),cXmlPrdBar,x,Len(oItens))
						EndIf
					EndIf
				Else
					lVldProdut := .F.
					cVldMensag := "O produto ("+cXmlPrdCod+") do Forncecedor nao est? cadastrado na tabela de relacionamento de produtos [SA5]!"
					fGravaMsg(nRecTab1,98," ",cVldMensag)
					lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut,Nil,cXmlPrdBar,x,Len(oItens))
				EndIf
			Else
				//Tratando tamanho do conteudo do campo
				cXmlPrdCod := fTrtCodPrd(cXmlPrdCod,"2")
	
				SA7->(DbSetOrder(3))
				If SA7->(DbSeek(xFilial("SA7") + cCodCliFor + cLojCliFor + cXmlPrdCod  ))
					cCodProdut := SA7->A7_PRODUTO
					If lFatorCnv  .And. !Empty(cCpoFCNum)
						If Empty(&("SA7->"+cCpoNCMFo)) .Or. Empty(&("SA7->"+cCpoUmXml)) .Or. Empty(&("SA7->"+cCpoFCNum)) .Or. Empty(&("SA7->"+cCpoFCTip)) .Or. AllTrim(cXmlUniMed) != AllTrim(&("SA7->"+cCpoUmXml))
							lVldProdut := .F.
							cVldMensag := "O produto ("+cXmlPrdCod+") do Cliente esta com cadastro imcompleto na tabela de relacionamento de produtos [SA7]!"
							fGravaMsg(nRecTab1,98," ",cVldMensag)
							lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut,SA7->(Recno()),cXmlPrdBar,x,Len(oItens))
						EndIf
					EndIf
				Else
					lVldProdut := .F.
					cVldMensag := "O produto ("+cXmlPrdCod+") do Cliente nao est? cadastrado na tabela de relacionamento de produtos [SA7]!"
					fGravaMsg(nRecTab1,98," ",cVldMensag)
					lVldProdut := fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,@cCodProdut,0,cXmlPrdBar,x,Len(oItens))
				EndIf
			EndIf
        Endif
        
		//Valida se produto existe na tabela SA1
		If lVldProdut
			SB1->(dbSetOrder(1))
			If SB1->(!dbSeek(xFilial("SB1")+cCodProdut))
				lVldProdut := .F.
				cVldMensag := "O produto ("+cCodProdut+") informado na rotina de produto x "+IIf(lEhFornec,"fornecedor","cliente")+" nao existe no cadastro de produtos ou est? com cadastro incompleto!"
				fGravaMsg(nRecTab1,98," ",cVldMensag)
			EndIf
		EndIf
		
		//Valida se produto na tabela SA1 est? bloqueado
		If lVldProdut
			If SB1->B1_MSBLQL == "1"
				lVldProdut := .F.
				cVldMensag := "O produto ("+cCodProdut+") est? bloqueado no cadastro de produtos!"
				fGravaMsg(nRecTab1,98," ",cVldMensag)
			EndIf
		EndIf

		//Valida Unidade de Medida do XML com a SB1
		If lVldProdut .And. !lEhFornec
			If Upper(AllTrim(SB1->B1_UM)) <> Upper(AllTrim(cXmlUniMed))
				lVldProdut := .F.
				cVldMensag := "O produto ("+cCodProdut+") est? com Unidade de Medida Diferente no cadastro de produtos!"
				fGravaMsg(nRecTab1,98," ",cVldMensag)

				If MsgYesNo("Unidade do Produto (XML) " + Upper(AllTrim(cXmlUniMed)) + " Item " + StrZero(x,4) + ", Difere do Cadastro (SB1) " + Upper(AllTrim(SB1->B1_UM))  +", Deseja Continuar a Importacao Mesmo Assim ?")
					lVldProdut := .t.
				Endif
			EndIf
		EndIf

		//Valida Unidade de Medida do XML com a SB1
		If lVldProdut .And. !lEhFornec
			If Upper(AllTrim(SB1->B1_POSIPI)) <> Upper(AllTrim(Str(Val(cXmlPrdNcm))))
				lVldProdut := .F.
				cVldMensag := "O produto ("+cCodProdut+") est? com NCM Diferente no cadastro de produtos!"
				fGravaMsg(nRecTab1,98," ",cVldMensag)                             
				
				If MsgYesNo("Codigo NCM do Produto (XML) " + Upper(AllTrim(Str(Val(cXmlPrdNcm)))) + " Item " + StrZero(x,4) + ", Difere do Cadastro (SB1) " + Upper(AllTrim(SB1->B1_POSIPI))  +", Deseja Continuar a Importacao Mesmo Assim ?")
					lVldProdut := .t.
				Endif
			EndIf
		EndIf

		//Cancela operacao pois tem que ajustar cadastro
		If !lVldProdut
			x := Len(oItens)
			lProc := .F.
		EndIf

	Next x
EndIf


//Prepara aCabec pro MsExecAuto
If lProc
	//Posiciona no registro correto
	(cTab1)->(DbGoTo(nRecTab1))

	//Reseta as variaveis
	aCabec := {}
	aadd(aCabec,{"F1_TIPO"    ,(cTab1)->&(cAls1+"_TIPDOC")                      ,Nil,Nil})
	aadd(aCabec,{"F1_FORMUL"  ,"N"                                              ,Nil,Nil})
	aadd(aCabec,{"F1_DOC"     ,(cTab1)->&(cAls1+"_DOC"   )                      ,Nil,Nil})
	aadd(aCabec,{"F1_SERIE"   ,(cTab1)->&(cAls1+"_SERIE" )                      ,Nil,Nil})
	aadd(aCabec,{"F1_COND"    ,IIf(Empty(cCndCliFor),"001",cCndCliFor)          ,Nil,Nil})
	aadd(aCabec,{"F1_EMISSAO" ,(cTab1)->&(cAls1+"_DTEMIS")                      ,Nil,Nil})
	aadd(aCabec,{"F1_FORNECE" ,cCodCliFor                                       ,Nil,Nil})
	aadd(aCabec,{"F1_LOJA"    ,cLojCliFor                                       ,Nil,Nil})
	aadd(aCabec,{"F1_ESPECIE" ,"SPED"                                           ,Nil,Nil})
	aadd(aCabec,{"F1_CHVNFE"  ,(cTab1)->&(cAls1+"_CHVNFE")                      ,Nil,Nil})
EndIf

//Prepara aItens pro MsExecAuto
If lProc
	//Reseta as variaveis
	aItens := {}

	oItens := IIf(Type("oNF:_InfNfe:_Det")=="O",{oNF:_InfNfe:_Det},oNF:_InfNfe:_Det)
	For x := 1 To Len(oItens)

		//------------------------------------------------------------
		//Variavel usada pra conseguir tratar via Type
		oItemTemp  := Nil
		oItemTemp  := oItens[x]
		//------------------------------------------------------------

		//Reseta as variaveis
		aLinha     := {}
		nCadFatCon := 1
		cCadTipCon := "M"
		cOperConv  := ""
		nQtdProd   := 0

		cXmlProduto := AllTrim(oItemTemp:_Prod:_cProd:TEXT)
		
		If lEhFornec
			//Tratando tamanho do conteudo do campo
			cXmlProduto := fTrtCodPrd(cXmlProduto,"1")
						
			SA5->(dbSetOrder(14))
			SA5->(dbSeek(xFilial("SA5")+cCodCliFor+cLojCliFor+cXmlProduto))
			//Se campos Fator Conversao Unidade Medido OK, entao calcular
			If lFatorCnv .And. !Empty(cCpoFCNum)
				nCadFatCon := &("SA5->"+cCpoFCNum)
				cCadTipCon := &("SA5->"+cCpoFCTip)
			EndIf

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
		Else
			//Tratando tamanho do conteudo do campo
			cXmlProduto := fTrtCodPrd(cXmlProduto,"2")

			SA7->(dbSetOrder(3))
			SA7->(dbSeek(xFilial("SA7")+cCodCliFor+cLojCliFor+cXmlProduto))
			//Se campos Fator Conversao Unidade Medido OK, entao calcular
			If lFatorCnv .And. !Empty(cCpoFCNum)
				nCadFatCon := &("SA7->"+cCpoFCNum)
				cCadTipCon := &("SA7->"+cCpoFCTip)
			EndIf

			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
		Endif

		If cCadTipCon == "D"
			cOperConv := "/"+AllTrim(Str(nCadFatCon,8,2))
		EndIf
		If cCadTipCon == "M"
			cOperConv := "*"+AllTrim(Str(nCadFatCon,8,2))
		EndIf

		nQtdProd := 0
		If !Empty(cOperConv)
			//If Val(oItemTemp:_Prod:_qTrib:TEXT) != 0
			//	nQtdProd := Alltrim(oItemTemp:_Prod:_qTrib:TEXT)+cOperConv
			//	nQtdProd := &(nQtdProd)
			//Else
				nQtdProd := Alltrim(oItemTemp:_Prod:_qCom:TEXT )+cOperConv
				nQtdProd := &(nQtdProd)
			//EndIf
		Else
			//If Val(oItemTemp:_Prod:_qTrib:TEXT) != 0
			//	nQtdProd := Val(oItemTemp:_Prod:_qTrib:TEXT)
			//Else
				nQtdProd := Val(oItemTemp:_Prod:_qCom:TEXT)
			//EndIf
		EndIf

		aadd(aLinha,{"D1_COD",SB1->B1_COD,Nil,Nil})
		aadd(aLinha,{"D1_QUANT",nQtdProd,Nil,Nil})
		AADD(aLinha,{"D1_UM"   ,SB1->B1_UM, Nil})
		AADD(aLinha,{"D1_CONTA",SB1->B1_CONTA, Nil})

		//If Val(oItemTemp:_Prod:_qTrib:TEXT) != 0
		//	aadd(aLinha,{"D1_VUNIT",Round(Val(oItemTemp:_Prod:_vProd:TEXT)/nQtdProd,5),Nil,Nil})
		//Else
			aadd(aLinha,{"D1_VUNIT",Round(Val(oItemTemp:_Prod:_vProd:TEXT)/nQtdProd,5),Nil,Nil})
		//Endif

		aadd(aLinha,{"D1_TOTAL",Val(oItemTemp:_Prod:_vProd:TEXT),Nil,Nil})
		
		If Type("oItemTemp:_Prod:_vDesc")<> "U"
			aadd(aLinha,{"D1_VALDESC",Val(oItemTemp:_Prod:_vDesc:TEXT),Nil,Nil})
		Endif

		Do Case
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS00")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS00
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS10")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS10
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS20")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS20
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS30")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS30
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS40")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS40
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS51")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS51
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS60")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS60
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS70")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS70
			Case Type("oItemTemp:_Imposto:_ICMS:_ICMS90")<> "U"
				oICM:=oItemTemp:_Imposto:_ICMS:_ICMS90
		EndCase

		If Type("oICM") <> "U"
			CST_Aux := Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CST:TEXT)
		Else
			CST_Aux := ""
		EndIf
		aadd(aLinha,{"D1_CLASFIS",CST_Aux,Nil,Nil})
		
		If cTagPC == "S" .And. Type("oItemTemp:_Prod:_xPed") <> "U" .And. (cTab1)->&(cAls1+"_TIPDOC") == "N"
			uVarTemp := Nil
			uVarTemp := Upper(AllTrim(oItemTemp:_Prod:_xPed:TEXT))
			If !Empty(uVarTemp) .And. !(uVarTemp $ "0000000000")
				uVarTemp := "0000000000"+uVarTemp
				uVarTemp := Right(uVarTemp,fX3Ret("D1_PEDIDO","X3_TAMANHO"))
				aadd(aLinha,{"D1_PEDIDO",uVarTemp,Nil,Nil})
			EndIf
		Endif

		If cTagPC == "S" .And. Type("oItemTemp:_Prod:_nItemPed") <> "U" .And. (cTab1)->&(cAls1+"_TIPDOC") == "N"
			uVarTemp := Nil
			uVarTemp := Upper(AllTrim(oItemTemp:_Prod:_nItemPed:TEXT))
			If !Empty(uVarTemp) .And. !(uVarTemp $ "0000000000")
				uVarTemp := "0000000000"+uVarTemp
				uVarTemp := Right(uVarTemp,fX3Ret("D1_ITEMPC","X3_TAMANHO"))
				aadd(aLinha,{"D1_ITEMPC",uVarTemp,Nil,Nil})
			EndIf
		Endif

		cAdic := IIf(Type("oItemTemp:_InfAdProd:TEXT") != "U",oItemTemp:_InfAdProd:TEXT,"")
		//Verifica se existe PE para tratamentdo das informacoes adicionais
		If ExistBlock("GXNPE001")                   
			aGXNPE001 := Nil
			aGXNPE001 := ExecBlock("GXNPE001",.F.,.F.,{cAdic})
	
			If Type("aGXNPE001") == "A"
				For y:=1 To Len(aGXNPE001)
					aAdd(aLinha,aGXNPE001[y])
				Next y
			Else
				MsgAlert("PE GXNPE001 est? com erro de retorno, favor verificar.")
			EndIf
		EndIf

		aAdd(aUnidMed,oItemTemp:_Prod:_uCom:TEXT)
		aAdd(aPrdDesc,oItemTemp:_Prod:_xProd:TEXT)

		aadd(aItens,aLinha)

	Next x
EndIf

//Perguntar se deseja relacionar ao PC
If lProc .And. Len(aItens) > 0
	If SimNao("Deseja relacionar a pre-nota "+Alltrim(aCabec[3,2])+" / "+Alltrim(aCabec[4,2])+" a um pedido de compra?") == "S"
		lProc := fLinkNFxPC(aCabec,@aItens,aUnidMed,aPrdDesc)
	EndIf
EndIf

//Executa rotina de inclusao Pre-Nota
If lProc .And. Len(aItens) > 0

	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)
	//lRetorno := MsExecAuto({|x,y,z,w| Mata103(x,y,z,w)},aCabec,aItens,3,.t.) //(_aAutoCab, _aAutoItens, 3 , _LWhenGet )
	//If !lRetorno
//		MsgAlert("Falha No Lan?amento do Documento de Entrada !")
//		Return .f.
//	Endif
	
	If lEhFornec
		cMsgFoCl := aCabec[7,2]+aCabec[8,2]
		cMsgFoCl := "Fornecedor: "+aCabec[7,2]+"/"+aCabec[8,2] +" - "+ Posicione("SA2",1,xFilial("SA2")+cMsgFoCl,"A2_NREDUZ")
	Else
		cMsgFoCl := aCabec[7,2]+aCabec[8,2]
		cMsgFoCl := "Cliente: "   +aCabec[7,2]+"/"+aCabec[8,2] +" - "+ Posicione("SA1",1,xFilial("SA1")+cMsgFoCl,"A1_NREDUZ")
	EndIf
	
	If lMsErroAuto
		lProc := .F.
		RollBackSxe()
		
		cMsErro2 := "<br>Arquivo: "+(cTab1)->&(cAls1+"_ARQUIV")
		cMsErro2 += "<br>Data/Hora:"   +DtoC(Date()) +" / "+ Time()
		cMsErro2 += "<br><br>Erro MsExecAuto: "
		cMsErro2 += "<br><br>"         +MostraErro("\")
		
		cMsgErro := "Erro na execucao do MsExecAuto para geracao da Pre-Nota."
		cMsgNota := "Numero Pre Nota: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
		cMsgAssu := "[Pre Nota] Erro na importacao do XML "
		
		fWfGerXml("INTEGRACAO XML x PRE-NOTA", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl+"<br>"+cMsErro2)
		fGravaMsg(nRecTab1,98,"4",cMsgErro+" - "+cMsgNota)

		MsgAlert(cMsgErro + Chr(13)+Chr(10) + cMsErro2 + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl)
	Else
		lProc := .T.
		ConfirmSX8()
		
		cMsgErro := "Pre Nota Gerada Com Sucesso!"
		cMsgNota := "Numero Pre Nota: "+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])
		cMsgAssu := "[Pre Nota] Gerada com sucesso : ["+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+"]"

		fWfGerXml("INTEGRACAO XML x PRE-NOTA", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl)
		fGravaMsg(nRecTab1,98,"3",cMsgErro+" - "+cMsgNota)

		MsgInfo(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl)

		IF Msgyesno("Deseja Efetuar a Classifica??o da Nota " + Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2]) + " Agora ?")
			_aArea := GetArea()
//			A103NFiscal("SF1",SF1->(Recno()),4,.f.,.f.)

			cDoc := aCabec[3,2]
			cSerie := aCabec[4,2]
			
			//dbSelectArea("SF1")            
//			dbSetOrder(1)
  //			SET FILTER TO AllTrim(F1_DOC) = Alltrim(XcDoc) .AND. AllTrim(F1_SERIE) == XcSerie .And. F1_FORNECE == cCodCliFor .And. F1_LOJA = cLojCliFor
//			dbGoTop()
			MATA103()
//			dbSelectArea("SF1")
//			SET FILTER TO */
			lProc := .t.                                                                
			RetArea(_aArea)
		Endif
	EndIf

Endif


Return(lProc)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fTrtCodPrd()
//|Autor.....: Luiz Alberto
//|Data......: 12 de janeiro de 2015, 09:00
//|Descricao.: Tratamento do Codigo do Produto
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fTrtCodPrd(cCodProd,cTipoCad)
*-----------------------------------------------------------*

Local cRet := ""
Local nTam := 0

Default cCodProd := ""
Default cTipoCad := "" //1=SA5 (Fornec), 2=SA7(Cliente)

cRet := Upper(cCodProd)
cRet := AllTrim(cRet)

Do Case
	Case cTipoCad == "1"
		nTam := fX3Ret("A5_CODPRF","X3_TAMANHO")

	Case cTipoCad == "2"
		nTam := fX3Ret("A7_CODCLI","X3_TAMANHO")
EndCase

cRet := Right(cRet,nTam)
cRet := AllTrim(cRet)
cRet := PadR(cRet,nTam)

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkNFxPC()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkNFxPC(aCabec,aItens,aUnidMed,aPrdDesc)
*-----------------------------------------------------------*
Local lRet     := .T.
Local aCoors   := {800,400}
Local aSizeAut := {}
Local aInfo    := {}
Local aObjects := {}
Local aPosObj  := {}

//Variaveis do tamanho a tela
Local aDlgTela := {}
Local aPosCb1  := {}
Local aPosCb2  := {}
Local aPosIt1  := {}
Local aPosIt2  := {}

//Divisoes dentro da tela
Local aDlgCabc := {}
Local aDlgCorp := {}
Local aDlgRodp := {}

//Variaveis da Tela
Local oDialg
Local cPrtCad  := "Relacionamento NFe/XML com PC existente"
Local nOpcao   := 0

Private oLinkGd01  := Nil
Private oLinkGd02  := Nil
Private cLinkNumPC := Space(fX3Ret("C7_NUM"    ,"X3_TAMANHO"))
Private cLinkProdu := Space(fX3Ret("C7_PRODUTO","X3_TAMANHO"))
Private cLinkForCd := aCabec[7][2]
Private cLinkForLj := aCabec[8][2]

/*
aSizeAut := {0              ,;
			 0              ,;
			 (aCoors[01])/2 ,; //Subtrai  8 por ajustar lateral
			 (aCoors[02])/2 ,; //Sibtrai 90 por causa da barra do windows e enchoice bar
			 (aCoors[01])   ,; //Subtrai  8 por ajustar lateral
			 (aCoors[02])   ,; //Subtrai 70 por causa da barra do windows
			 0               }
*/
aSizeAut := MsAdvSize()
aInfo    := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aObjects := {}

aAdd(aObjects,{100,035,.T.,.F.}) //Cabecalho
aAdd(aObjects,{100,100,.T.,.T.}) //Corpo = Nfe e Romaneio
aAdd(aObjects,{100,020,.T.,.F.}) //Rodape
aPosObj  := MsObjSize(aInfo,aObjects)

//Variaveis do tamanho a tela
aDlgTela := {aSizeAut[7],aSizeAut[1],aSizeAut[6],aSizeAut[5]}

//Divide cabecalho
aPosCb1  := aClone(aPosObj[1])
aPosCb1[4] := (aPosCb1[4]/2)-2
aPosCb2  := aClone(aPosObj[1])
aPosCb2[2] := (aPosCb2[4]/2)+2

//Divide Itens
aPosIt1  := aClone(aPosObj[2])
aPosIt1[4] := (aPosIt1[4]/2)-2
aPosIt2  := aClone(aPosObj[2])
aPosIt2[2] := (aPosIt2[4]/2)+2

// Montagem da tela que serah apresentada para usuario (lay-out)
Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Pixel //Of oMainWnd

//Contorno - Cabec 01 - NF
fLinkCabc1(aPosCb1,oDialg,aCabec)

//Contorno - Cabec 02 - PC
fLinkCabc2(aPosCb2,oDialg)

//Contorno - Itens 01 - NF
fLinkItem1(aPosIt1,oDialg,aItens,aUnidMed,aPrdDesc)

//Contorno - Itens 02 - PC
fLinkItem2(aPosIt2,oDialg)

//Contorno - Rodape
fLinkRodap(aPosObj[3],oDialg,@nOpcao)

Activate MsDialog oDialg Centered

//Se confirmado
If nOpcao == 2
	nPos1Ped := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_PEDIDO" })
	nPos1Itm := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_ITEMPC" })
	nPosPCNu := 0
	nPosPCIt := 0
	nProcessa:=	Len(oLinkGd01:aCols)	
	
	For x:=1 To nProcessa
		aLinha   := {}
		If !Empty(oLinkGd01:aCols[x][nPos1Ped]) .And. !Empty(oLinkGd01:aCols[x][nPos1Itm])
			nPosPCNu := aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_PEDIDO"})
			nPosPCIt := aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_ITEMPC"})
			nPosPCQt := aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_QUANT"})
			nPosPCVu := aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_VUNIT"})
			nPosPCTt := aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_TOTAL"})
			nPosPCDs := aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_VALDESC"})
			
			If oLinkGd01:aCols[x][nPos1Itm]<>'ZZZZ'	// Trata-se de 1 x 1
				If nPosPCNu > 0
					aItens[x][nPosPCNu][2] := oLinkGd01:aCols[x][nPos1Ped]
				Else
					aadd(aItens[x],{"D1_PEDIDO",oLinkGd01:aCols[x][nPos1Ped],Nil,Nil})
				EndIf
				
				If nPosPCIt > 0
					aItens[x][nPosPCIt][2] := oLinkGd01:aCols[x][nPos1Itm]
				Else
					aadd(aItens[x],{"D1_ITEMPC",oLinkGd01:aCols[x][nPos1Itm],Nil,Nil})
				EndIf           
	
				// Se Tiver Relacao com Pedidos de Compras ent?o Pega o Centro de Custos
				
				If SC7->(dbSetOrder(1), dbSeek(xFilial("SC7")+oLinkGd01:aCols[x][nPos1Ped]+oLinkGd01:aCols[x][nPos1Itm]))
					If aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_CC"})>0
						aItens[x][aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_CC"})][2] := SC7->C7_CC
					Else
						aadd(aItens[x],{"D1_CC",SC7->C7_CC,Nil,Nil})
					Endif
				Endif
			ElseIf oLinkGd01:aCols[x][nPos1Itm]=='ZZZZ'	// Trata-se de 1 x Varios Pedidos
				aPedidos := Separa(oLinkGd01:aCols[x][nPos1Ped],'|')
				
				For nPed := 1 To Len(aPedidos)-1
					aDtPed := Separa(aPedidos[nPed],';')
					
					cPedido := aDtPed[1]
					cItem   := aDtPed[2]
					nQuant  := Val(aDtPed[3])
					
					If nPed == 1	// Se For o Primeiro Pedido ent?o altera a quantidade do item da nota
						aItens[x][nPosPCQt][2] := nQuant
						aItens[x][nPosPCTt][2] := Round(nQuant * aItens[x][nPosPCVu][2],2)

						If nPosPCNu > 0
							aItens[x][nPosPCNu][2] := cPedido
						Else
							aadd(aItens[x],{"D1_PEDIDO",cPedido,Nil,Nil})
						EndIf
						
						If nPosPCIt > 0
							aItens[x][nPosPCIt][2] := cItem
						Else
							aadd(aItens[x],{"D1_ITEMPC",cItem,Nil,Nil})
						EndIf           
			
						// Se Tiver Relacao com Pedidos de Compras ent?o Pega o Centro de Custos
						
						If SC7->(dbSetOrder(1), dbSeek(xFilial("SC7")+cPedido+cItem))
							If aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_CC"})>0
								aItens[x][aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_CC"})][2] := SC7->C7_CC
							Else
								aadd(aItens[x],{"D1_CC",SC7->C7_CC,Nil,Nil})
							Endif
						Endif
					Else
						aadd(aLinha,{"D1_COD"	,aItens[x,aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_COD"}),2],Nil,Nil})
						aadd(aLinha,{"D1_QUANT"	,nQuant,Nil,Nil})
						AADD(aLinha,{"D1_UM"   	,aItens[x,aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_UM"}),2], Nil})
						AADD(aLinha,{"D1_CONTA"	,aItens[x,aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_CONTA"}),2], Nil})
						aadd(aLinha,{"D1_VUNIT" ,aItens[x,aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_VUNIT"}),2],Nil,Nil})
						aadd(aLinha,{"D1_TOTAL" ,Round(aItens[x,aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_VUNIT"}),2] * nQuant,2),Nil,Nil})
						If nPosPCDs > 0
							aadd(aLinha,{"D1_VALDESC",aItens[x,aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_VALDESC"}),2],Nil,Nil})
						Endif
						aadd(aLinha,{"D1_CLASFIS"	,aItens[x,aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_CLASFIS"}),2],Nil,Nil})
						AADD(aLinha,{"D1_PEDIDO"	,cPedido, Nil})
						AADD(aLinha,{"D1_ITEMPC"	,cItem, Nil})

						SC7->(dbSetOrder(1), dbSeek(xFilial("SC7")+cPedido+cItem))
						If aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_CC"})>0
							aItens[x][aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_CC"})][2] := SC7->C7_CC
							AADD(aLinha,{"D1_CC"	,aItens[x,aScan(aItens[x] , { |k| AllTrim(k[1]) == "D1_CC"}),2], Nil})
						Else
							AADD(aLinha,{"D1_CC"	,SC7->C7_CC, Nil})
						Endif

						aadd(aItens,aLinha)
					Endif
				Next
			Endif
		EndIf
	Next x

Else
	If SimNao("Deseja CANCELAR inclusao da pre-nota e gerar em outro momento?") == "S"
		lRet := .F.
	EndIf
EndIf

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkCabc1()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkCabc1(aSizeDlg,oDialg,aCabec)
*-----------------------------------------------------------*

Local cCbcNota := aCabec[3][2] + " / " + aCabec[4][2]
Local cCbcTpNF := aCabec[1][2]
Local cCbcForn := aCabec[7][2] + " / " + aCabec[8][2] + " - ?" + Posicione("SA2",1,xFilial("SA2")+cLinkForCd+cLinkForLj,"A2_NOME")

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Label " Cabecalho Pre Nota Entrada " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

@ aSizeDlg[1]+010,aSizeDlg[2]+005 Say "Nota"              Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+009,aSizeDlg[2]+030 MsGet cCbcNota          Size 070 ,008 Pixel When .F. Of oDialg

@ aSizeDlg[1]+010,aSizeDlg[2]+135 Say "Tipo NF"           Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+009,aSizeDlg[2]+160 MsGet cCbcTpNF          Size 030 ,008 Pixel When .F. Of oDialg

@ aSizeDlg[1]+022,aSizeDlg[2]+005 Say "Fornec."           Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+021,aSizeDlg[2]+030 MsGet cCbcForn          Size 160 ,008 Pixel When .F. Of oDialg

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkCabc2()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkCabc2(aSizeDlg,oDialg)
*-----------------------------------------------------------*

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Label " Pesquisar Pedido de Compra " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

@ aSizeDlg[1]+010,aSizeDlg[2]+005 Say "Num. PC"           Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+009,aSizeDlg[2]+030 MsGet cLinkNumPC        Size 090 ,008 Pixel Of oDialg F3 "SC7"

@ aSizeDlg[1]+022,aSizeDlg[2]+005 Say "Produto"           Size 050 ,008 Pixel Of oDialg
@ aSizeDlg[1]+021,aSizeDlg[2]+030 MsGet cLinkProdu        Size 090 ,008 Pixel Of oDialg F3 "SB1"

@ aSizeDlg[1]+009,aSizeDlg[2]+130 Button "Pesquisar"      Size 060 ,010 Pixel Of oDialg Action fLinkPesqu()
@ aSizeDlg[1]+021,aSizeDlg[2]+130 Button "Limpar"         Size 060 ,010 Pixel Of oDialg Action fLinkLimpa()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkPesqu()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkPesqu()
*-----------------------------------------------------------*

Local cQry   := ""
Local cQbra  := Chr(13)+Chr(10)

cQry := cQbra + " SELECT "
cQry += cQbra + "   'LBNO'            AS XX_FLAG, "
cQry += cQbra + "   C7_NUM            AS XX_PEDIDO, "
cQry += cQbra + "   C7_ITEM           AS XX_ITEMPC, "
cQry += cQbra + "   C7_PRODUTO        AS XX_PRODUTO, "
cQry += cQbra + "   C7_DESCRI         AS XX_DESCRIC, "
cQry += cQbra + "   C7_PRECO          AS XX_PRCUNIT, "
cQry += cQbra + "   C7_UM             AS XX_UM, "
cQry += cQbra + "  (C7_QUANT-C7_QUJE) AS XX_SALDO "
cQry += cQbra + "   FROM "+RetSqlName("SC7")+" SC7 "
cQry += cQbra + "  WHERE D_E_L_E_T_ = '' "
cQry += cQbra + "    AND C7_QUANT-C7_QUJE > 0 "
//cQry += cQbra + "    AND C7_CONAPRO      != 'B' " //Trata item bloqueado
cQry += cQbra + "    AND C7_RESIDUO       = ''  " //Trata item eliminado por residuo
cQry += cQbra + "    AND C7_FORNECE       = '"+cLinkForCd+"'  "
cQry += cQbra + "    AND C7_LOJA          = '"+cLinkForLj+"'  "
If !Empty(cLinkProdu)
cQry += cQbra + "    AND C7_PRODUTO    LIKE '%"+AllTrim(cLinkProdu)+"%' "
EndIf
If !Empty(cLinkNumPC)
cQry += cQbra + "    AND C7_NUM        LIKE '%"+AllTrim(cLinkNumPC)+"%' "
EndIf
cQry += cQbra + "  ORDER BY C7_NUM, C7_ITEM "

//Fecha Alias caso encontre
If Select("QRY") <> 0 ; QRY->(dbCloseArea()) ; EndIf

//Cria alias temporario
TcQuery cQry New Alias "QRY"

oLinkGd02:aCols := {}
oLinkGd02:oBrowse:Refresh()

//Carrega GetDados 02 com nova pesquisa
fLinkCarga()

//Fecha Alias
QRY->(dbCloseArea())

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkCarga()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkCarga()
*-----------------------------------------------------------*

Local cCmdTemp := ""
Local nPosTemp := 0
Local nPosFlag := aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"  })

//Carrega aCols com base no resultado da query
QRY->(DbGoTop())
While QRY->(!Eof())
	
	//Cria uma linha no aCols
	aAdd(oLinkGd02:aCols,Array(Len(oLinkGd02:aHeader)+1))
	nLin := Len(oLinkGd02:aCols)

	//Carregando campos que serao visualizados no GD
	For y:=1 To Len(oLinkGd02:aHeader)
		oLinkGd02:aCols[nLin,y] := &("QRY->"+oLinkGd02:aHeader[y][2])
	Next y

	oLinkGd02:aCols[nLin, Len(oLinkGd02:aHeader)+1] := .F.

	QRY->(DbSkip())
End

//Carrega aCols com uma linha vazia por nao teve resultado na query
QRY->(DbGoTop())
If QRY->(Eof())
	//Cria uma linha no aCols
	aAdd(oLinkGd02:aCols,Array(Len(oLinkGd02:aHeader)+1))
	nLin := Len(oLinkGd02:aCols)

	oLinkGd02:aCols[nLin, aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"   }) ] := "LBNO" //"LBTIK"
	oLinkGd02:aCols[nLin, aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_PEDIDO" }) ] := ""
	oLinkGd02:aCols[nLin, aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_ITEMPC" }) ] := ""
	oLinkGd02:aCols[nLin, aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_PRODUTO"}) ] := ""
	oLinkGd02:aCols[nLin, aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_DESCRIC"}) ] := ""
	oLinkGd02:aCols[nLin, aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_SALDO"  }) ] := 0
	oLinkGd02:aCols[nLin, Len(oLinkGd02:aHeader)+1]                                  := .F.

EndIf

//Atualiza tela
oLinkGd02:oBrowse:nAt := 1
oLinkGd02:oBrowse:Refresh()
oLinkGd02:oBrowse:SetFocus()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkLimpa()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkLimpa()
*-----------------------------------------------------------*

cLinkNumPC := Space(fX3Ret("C7_NUM"    ,"X3_TAMANHO"))
cLinkProdu := Space(fX3Ret("C7_PRODUTO","X3_TAMANHO"))

oLinkGd02:aCols := {}
oLinkGd02:oBrowse:Refresh()

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkItem1()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkItem1(aSizeDlg,oDialg,aItens,aUnidMed,aPrdDesc)
*-----------------------------------------------------------*

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Local cGetOpc        := Nil                                             // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
Local aHead          := {}                                              // Array do aHeader
Local aCols          := {}                                              // Array do aCols
Local cMsgCabec      := ""

Local nPosProd := aScan(aItens[1] , { |x| AllTrim(x[1]) == "D1_COD"   })
Local nPosQtde := aScan(aItens[1] , { |x| AllTrim(x[1]) == "D1_QUANT" })
Local nPosPrcU := aScan(aItens[1] , { |x| AllTrim(x[1]) == "D1_VUNIT" })
Local nPosPCNu := 0
Local nPosPCIt := 0

aAdd(aHead,{""              ,"XX_FLAG"      ,"@BMP"               ,          01,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Produto"       ,"XX_PRODUTO"   ,"@!"                 ,          10,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Descricao"     ,"XX_DESCRIC"   ,"@!"                 ,          20,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Unid."         ,"XX_UM"        ,"@!"                 ,          05,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Quantidade"    ,"XX_QTDE"      ,"@E 999,999,999.99"  ,          08,          4, ""      , "??????????????", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Preco Unit."   ,"XX_PRCUNIT"   ,"@E 999,999,999.99"  ,          08,          4, ""      , "??????????????", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Num.PC"        ,"XX_PEDIDO"    ,"@!"                 ,          08,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"It.PC"         ,"XX_ITEMPC"    ,"@!"                 ,          04,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

For y:=1 To Len(aItens)

	nPosPCNu := aScan(aItens[y] , { |k| AllTrim(k[1]) == "D1_PEDIDO"})
	nPosPCIt := aScan(aItens[y] , { |k| AllTrim(k[1]) == "D1_ITEMPC"})

	//Cria uma linha no aCols
	aAdd(aCols,Array(Len(aHead)+1))
	nLin := Len(aCols)
	
	//Alimenta a linha do aCols vazia
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_FLAG"   }) ] := "LBNO" //"LBTIK"
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_PRODUTO"}) ] := aItens[y][nPosProd][2]
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_DESCRIC"}) ] := aPrdDesc[y]
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_UM"     }) ] := aUnidMed[y]
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_QTDE"   }) ] := aItens[y][nPosQtde][2]
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_PRCUNIT"}) ] := aItens[y][nPosPrcU][2]
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_PEDIDO" }) ] := IIf(Empty(nPosPCNu),"",aItens[y][nPosPCNu][2])
	aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_ITEMPC" }) ] := IIf(Empty(nPosPCIt),"",aItens[y][nPosPCIt][2])
	aCols[nLin, Len(aHead)+1]                                  := .F.
Next y

oLinkGd01:=MsNewGetDados():New(aSizeDlg[1]+5,aSizeDlg[2]+5,aSizeDlg[3]-5,aSizeDlg[4]-5,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
oLinkGd01:oBrowse:bLDblClick := {|| fDblClick(@oLinkGd01,1) }

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fDblClick()
//|Autor.....: Luiz Alberto
//|Data......: 14 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fDblClick(oGDItens,nJanela)
*-----------------------------------------------------------*

Local x        := 0
Local nLinhaOK := oGDItens:oBrowse:nAt
Local nPosFlag := aScan(oGDItens:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"  })
DEFAULT nJanela := 1


If nJanela == 1 //Desmarca todos Somente se For Itens do XML
	For x:=1 To Len(oGDItens:aCols)
		oGDItens:aCols[x][nPosFlag] := "LBNO"
	Next x
Endif

//Marca Item Clicado
If oGDItens:aCols[nLinhaOK][nPosFlag] == "LBTIK"
	oGDItens:aCols[nLinhaOK][nPosFlag] := "LBNO"
Else
	oGDItens:aCols[nLinhaOK][nPosFlag] := "LBTIK"
Endif

//Atualiza tela
oGDItens:oBrowse:nAt := nLinhaOK
oGDItens:oBrowse:Refresh()
oGDItens:oBrowse:SetFocus()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkItem2()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkItem2(aSizeDlg,oDialg)
*-----------------------------------------------------------*

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Local cGetOpc        := Nil                                             // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
Local aHead          := {}                                              // Array do aHeader
Local aCols          := {}                                              // Array do aCols
Local cMsgCabec      := ""

aAdd(aHead,{""              ,"XX_FLAG"      ,"@BMP"               ,          01,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Num.PC"        ,"XX_PEDIDO"    ,"@!"                 ,          10,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"It.PC"         ,"XX_ITEMPC"    ,"@!"                 ,          05,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Produto"       ,"XX_PRODUTO"   ,"@!"                 ,          10,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Descricao"     ,"XX_DESCRIC"   ,"@!"                 ,          20,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Unid."         ,"XX_UM"        ,"@!"                 ,          05,          0, ""      , "??????????????", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Preco Unit."   ,"XX_PRCUNIT"   ,"@E 999,999,999.99"  ,          08,          4, ""      , "??????????????", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"Saldo"         ,"XX_SALDO"     ,"@E 999,999,999.99"  ,          08,          4, ""      , "??????????????", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

//Cria uma linha no aCols
aAdd(aCols,Array(Len(aHead)+1))
nLin := Len(aCols)

//Alimenta a linha do aCols vazia
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_FLAG"   }) ] := "LBNO" //"LBTIK"
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_PEDIDO" }) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_ITEMPC" }) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_PRODUTO"}) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_DESCRIC"}) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_UM"     }) ] := ""
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_PRCUNIT"}) ] := 0
aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])=="XX_SALDO"  }) ] := 0
aCols[nLin, Len(aHead)+1]                                  := .F.

oLinkGd02:=MsNewGetDados():New(aSizeDlg[1]+5,aSizeDlg[2]+5,aSizeDlg[3]-5,aSizeDlg[4]-5,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)
oLinkGd02:oBrowse:bLDblClick := {|| fDblClick(@oLinkGd02,2) }

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkRodap()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkRodap(aSizeDlg,oDialg,nOpcao)
*-----------------------------------------------------------*

Local nQtdCpo := 8
Local nTamBtn := (aSizeDlg[4] / nQtdCpo)
Local aBtn01  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 0) + (005) ,  nTamBtn-10, 012}
Local aBtn02  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 1) + (005) ,  nTamBtn-10, 012}
Local aBtn03  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 6) + (002) ,  nTamBtn-10, 012}
Local aBtn04  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 7) + (002) ,  nTamBtn-10, 012}

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Botoes
@ aBtn01[1],aBtn01[2] Button "Associar"    Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fLinkAssoc()
@ aBtn02[1],aBtn02[2] Button "Desassociar" Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fLinkDesas()
@ aBtn03[1],aBtn03[2] Button "Fechar"      Size aBtn03[3],aBtn03[4] Pixel Of oDialg Action (nOpcao:=1,oDialg:End())
@ aBtn04[1],aBtn04[2] Button "Confirmar"   Size aBtn04[3],aBtn04[4] Pixel Of oDialg Action (nOpcao:=2,oDialg:End())

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkAssoc()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkAssoc()
*-----------------------------------------------------------*

Local nPos1Prd := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_PRODUTO"})
Local nPos1Ped := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_PEDIDO" })
Local nPos1Itm := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_ITEMPC" })
Local nPos1Qtd := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_QTDE"   })
Local nPos1Flg := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"   })
Local nPos1UM  := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_UM"     })
Local nPos1Prc := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_PRCUNIT"})

Local nPos2Prd := aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_PRODUTO"})
Local nPos2Ped := aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_PEDIDO" })
Local nPos2Itm := aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_ITEMPC" })
Local nPos2Sld := aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_SALDO"  })
Local nPos2Flg := aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"   })
Local nPos2UM  := aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_UM"     })
Local nPos2Prc := aScan(oLinkGd02:aHeader,{|x|AllTrim(x[2])=="XX_PRCUNIT"})

Local nLinGD1 := 0
Local nLinGD2 := 0

Local x       := 1
Local lOk     := .F.
Local aItPed := {}

For x:=1 To Len(oLinkGd01:aCols)
	If oLinkGd01:aCols[x][nPos1Flg] == "LBTIK"
		If Empty(oLinkGd01:aCols[x][nPos1Ped]) .And. Empty(oLinkGd01:aCols[x][nPos1Itm])
			lOk     := .T.
			nLinGD1 :=  x
		Else
			lOk     := .F.
			MsgAlert("O item selecionado j? est? associado a um pedido!")
		EndIf
		x := Len(oLinkGd01:aCols)
	EndIf
Next x

If lOk
	For x:=1 To Len(oLinkGd02:aCols)
		If oLinkGd02:aCols[x][nPos2Flg] == "LBTIK"
			AAdd(aItPed,{	oLinkGd02:aCols[x][nPos2Prd],;
							oLinkGd02:aCols[x][nPos2Ped],;
							oLinkGd02:aCols[x][nPos2Itm],;
							oLinkGd02:aCols[x][nPos2Sld],;
							oLinkGd02:aCols[x][nPos2UM],;
							oLinkGd02:aCols[x][nPos2Prc],;
							'PRODUTO NF',;	// 7
							'ITEM NF',;		// 8
							0})				// 9
			nLinGD2 :=  x
		EndIf
	Next x
EndIf

If lOk .And. (Empty(nLinGD1) .Or. Empty(nLinGD2))
	lOk     := .F.
	MsgAlert("Favor selecionar os itens antes de clicar em associar!")	
EndIf

nSaldo := 0
If lOk 
	For nPed := 1 To Len(aItPed)
		nSaldo += aItPed[nPed,4]
		
		If AllTrim(oLinkGd01:aCols[nLinGD1][nPos1Prd]) != AllTrim(aItPed[nPed,1])
			lOk     := .F.
			MsgAlert("Nao e possivel associar produtos diferentes, verifique o produto selecionado!")
			Exit
		Endif
	Next
EndIf

If lOk .And. oLinkGd01:aCols[nLinGD1][nPos1Qtd] > nSaldo
	lOk     := MsgYesNo("O item do PC selecionado nao tem saldo suficiente pra realizar a associacao!, Continua assim Mesmo ?")	
EndIf

If lOk 
	For nPed := 1 To Len(aItPed)
		If AllTrim(oLinkGd01:aCols[nLinGD1][nPos1UM]) != AllTrim(aItPed[nPed,5])                                                 
			lOk     := MsgYesNo("ATEN??O: A unidade de medida do produto selecionado est? diferente ( XML x PC ) !, Continua assim Mesmo ?")	
			Exit
		Endif
	Next
EndIf

If lOk 
	For nPed := 1 To Len(aItPed)
		If AllTrim(oLinkGd01:aCols[nLinGD1][nPos1Prc]) != AllTrim(aItPed[nPed,6])
			lOk     := MsgYesNo("ATEN??O: O preco unitario do produto selecionado est? diferente ( XML x PC ) !, Continua assim Mesmo ?")	
			Exit
		Endif
	Next
EndIf

If lOk
	nQuant := oLinkGd01:aCols[nLinGD1][nPos1Qtd]
	For nPed := 1 To Len(aItPed)                
		aItPed[nPed,7]	:=	oLinkGd01:aCols[nLinGD1][nPos1Prd]
		aItPed[nPed,8]	:=	oLinkGd01:aCols[nLinGD1][nPos1Itm]
		aItPed[nPed,9]	:=	Iif(aItPed[nPed,4] > nQuant, nQuant, aItPed[nPed,4])
		
		nQuant -= aItPed[nPed,4]
	Next
	
	// Cria String Especifica para tratamento de mais de um pedido por item
	// em caso de mais de um pedido a string sera criada com a seguinte mascara
	// PPPPPP;IIII;999999.9999|	PPPPPP=Numero do Pedido de Compras IIII=Item do Pedido de Compras 9999999999.999=Qtde Utilizada do Pedido de Compras | Separa Pedidos

	cVarios:= ''
	For nPed := 1 To Len(aItPed)                
		cVarios += aItPed[nPed,2]+';'+aItPed[nPed,3]+';'+AllTrim(TransForm(aItPed[nPed,9],PesqPict("SC7","C7_QUANT")))+'|'
	Next

	oLinkGd01:aCols[nLinGD1][nPos1Ped] := Iif(Len(aItPed)>1,cVarios,oLinkGd02:aCols[nLinGD2][nPos2Ped])
	oLinkGd01:aCols[nLinGD1][nPos1Itm] := Iif(Len(aItPed)>1,'ZZZZ',oLinkGd02:aCols[nLinGD2][nPos2Itm])
	oLinkGd01:oBrowse:Refresh()	
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fLinkDesas()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fLinkDesas()
*-----------------------------------------------------------*

Local nPosPed := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_PEDIDO"})
Local nPosItm := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_ITEMPC"})
Local nPosFlg := aScan(oLinkGd01:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"  })
Local x       := 1

For x:=1 To Len(oLinkGd01:aCols)
	If oLinkGd01:aCols[x][nPosFlg] == "LBTIK"
		oLinkGd01:aCols[x][nPosPed] := ""
		oLinkGd01:aCols[x][nPosItm] := ""
	EndIf
Next x

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerRlcPrd()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerRlcPrd(lEhFornec,nRecTab1,cXmlPrdCod,cXmlPrdDes,cXmlPrdNcm,cXmlUniMed,cCodCliFor,cLojCliFor,cNomCliFor,cCodProdut,nRecA5A7,cXmlPrdBar,nItem,nTotItem)
*-----------------------------------------------------------*

//Variaveis do tamanho a tela
Local aDlgTela     := {000,000,410,505} //{000,000,343,505}

//Divisoes dentro da tela
Local aDlgCabc     := {005,005,040,250}
Local aDlgCorp1    := {045,005,092,250}
Local aDlgCorp2    := {097,005,144,250}
Local aDlgCorp3    := {149,005,174,250}
Local aDlgRodp     := {179,005,199,250}

Local nQtdCpo      := 5
Local nTamBtn      := (aDlgRodp[4] / nQtdCpo)
Local aBtn01       := {aDlgRodp[1]+04,   aDlgRodp[2] + (nTamBtn * 3) + (005) ,  nTamBtn-10, 012}
Local aBtn02       := {aDlgRodp[1]+04,   aDlgRodp[2] + (nTamBtn * 4) + (000) ,  nTamBtn-10, 012}

Local cTab2        := AllTrim(GetNewPar("MV_FMALS02",''))
Local cAls2        := IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)

Local oDialg
Local cStrCad      := AllTrim(GetNewPar("MV_FMALS02",''))
Local cTitCad      := "Amarracao Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
Local cPrtCad      := cTitCad+" ["+cStrCad+"]"
Local cCpoXml      := cCodCliFor +"-"+ cLojCliFor

Local nOpcao       := 0
Local lExiste      := .F.
Local lReturn      := .T.
Local lLoop        := .T.

Local cCpoUmXml    := AllTrim(IIf(lEhFornec,GetNewPar("MV_FMSA501",''),GetNewPar("MV_FMSA701",'')))
Local cCpoFCNum    := AllTrim(IIf(lEhFornec,GetNewPar("MV_FMSA502",''),GetNewPar("MV_FMSA702",'')))
Local cCpoFCTip    := AllTrim(IIf(lEhFornec,GetNewPar("MV_FMSA503",''),GetNewPar("MV_FMSA703",'')))
Local cCpoNCMFo    := AllTrim(IIf(lEhFornec,GetNewPar("MV_FMSA504",''),GetNewPar("MV_FMSA704",'')))

Local lWhenNcmXm   := .F.
Local lWhenUmXml   := .F.
Local lWhenFCNum   := .F.
Local lWhenFCTip   := .F.
Local lWhenTtCps   := .F.

Default nRecA5A7   := 0
Default nItem      := 0
Default nTotItem   := 0

Private cCadPrdCod := Space(fX3Ret("B1_COD","X3_TAMANHO"))
Private cCadPrdBar := Space(fX3Ret("B1_CODBAR","X3_TAMANHO"))
Private cCadPrdNcm := ""
Private cCadUniMed := ""
Private cCadPrdDes := ""

Private nCadFatCon := 1
Private oCadTipCon := Nil
Private cCadTipCon := "M"
Private aCadTipCon := {"M=Multiplicador","D=Divisor"}

//Trata campos de Conversao
If Empty(fX3Ret(cCpoNCMFo,"X3_CAMPO"))
	//Campo nao foi criado
	lWhenNcmXm := .F.
Else
	//Campo OK
	lWhenUmXml := .T.
EndIf

//Trata campos de Conversao
If Empty(fX3Ret(cCpoUmXml,"X3_CAMPO"))
	//Campo nao foi criado
	lWhenUmXml := .F.
Else
	//Campo OK
	lWhenUmXml := .T.
EndIf

//Trata campos de Conversao
If Empty(fX3Ret(cCpoFCNum,"X3_CAMPO"))
	//Campo nao foi criado
	lWhenFCNum := .F.
Else
	//Campo OK
	lWhenFCNum := .T.
EndIf

//Trata campos de Conversao
If Empty(fX3Ret(cCpoFCTip,"X3_CAMPO"))
	//Campo nao foi criado
	lWhenFCTip := .F.
Else
	//Campo OK
	lWhenFCTip := .T.
EndIf

//Se todos campos foram criado, entao faz tratamento
If lWhenUmXml .And. lWhenFCNum .And. lWhenFCTip .And. lWhenNcmXm
	lWhenTtCps := .T.
EndIf

If nTotItem > 0
	cPrtCad      += " [Item: " + AllTrim(Str(nItem,5))+'/'+AllTrim(Str(nTotItem,5))+"]"
Endif
While lLoop

	If Empty(nRecA5A7)
		cCadPrdCod := Space(fX3Ret("B1_COD","X3_TAMANHO"))
		cCadPrdBar := Space(fX3Ret("B1_CODBAR","X3_TAMANHO"))
		cCadPrdNcm := ""
		cCadPrdDes := ""
		cCadUniMed := ""
		nCadFatCon := 1
		cCadTipCon := "M"
	Else
		If lEhFornec
			SA5->(DbGoTo(nRecA5A7))
			cCadPrdCod := SA5->A5_PRODUTO
			fVldRlcPrd(.F.)                  
			If !Empty(cCpoFCNum)
				nCadFatCon := &("SA5->"+cCpoFCNum)
				cCadTipCon := &("SA5->"+cCpoFCTip)
			Endif
		Else
			SA7->(DbGoTo(nRecA5A7))
			cCadPrdCod := SA7->A7_PRODUTO
			fVldRlcPrd(.F.)
			If !Empty(cCpoFCNum)
				nCadFatCon := &("SA7->"+cCpoFCNum)
				cCadTipCon := &("SA7->"+cCpoFCTip)
			Endif
		EndIf
	EndIf                 
	
	If Empty(cCadPrdCod) .And. !Empty(cXmlPrdBar)	// Se n?o encontrou nenhum relacionamento ent?o tenta localiza??o por codigo de barras e Sugere
		If SB1->(dbSetOrder(3), dbSeek(xFilial("SB1")+cXmlPrdBar))
			cCadPrdCod := SB1->B1_COD
			fVldRlcPrd(.F.)          
		Endif
	Endif
	
	// Montagem da tela que serah apresentada para usuario (lay-out)
	Define MsDialog oDialg Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Pixel //Of oMainWnd
	
	//Cabec
	@ aDlgCabc[1], aDlgCabc[2] To aDlgCabc[3], aDlgCabc[4] LABEL " XML: Dados do "+IIf(lEhFornec,"Fornecedor ","Cliente ") COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	
	@ aDlgCabc[1]+010,aDlgCabc[2]+005 Say "Codigo"            Size 030 ,008 Pixel Of oDialg
	@ aDlgCabc[1]+009,aDlgCabc[2]+035 MsGet cCpoXml           Size 085 ,008 Pixel When .F. Of oDialg
	
	@ aDlgCabc[1]+022,aDlgCabc[2]+005 Say "Nome"              Size 030 ,008 Pixel Of oDialg
	@ aDlgCabc[1]+021,aDlgCabc[2]+035 MsGet cNomCliFor        Size 205 ,008 Pixel When .F. Of oDialg
	

	@ aDlgCabc[1]+010,aDlgCabc[2]+128 Button "Ped.Compras Fornec." Size 80,10 Pixel Of oDialg Action (U_PdcForn(cCpoXml))

	//Corpo 01
	@ aDlgCorp1[1], aDlgCorp1[2] To aDlgCorp1[3], aDlgCorp1[4] LABEL " XML: Dados do Produto " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	
	@ aDlgCorp1[1]+010,aDlgCorp1[2]+005 Say "Produto"           Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp1[1]+009,aDlgCorp1[2]+035 MsGet cXmlPrdCod        Size 085 ,008 Pixel When .F. Of oDialg
	
	@ aDlgCorp1[1]+010,aDlgCorp1[2]+128 Say "Barra"	            Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp1[1]+009,aDlgCorp1[2]+155 MsGet cXmlPrdBar        Size 085 ,008 Pixel When .F. Of oDialg

	@ aDlgCorp1[1]+022,aDlgCorp1[2]+005 Say "NCM"               Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp1[1]+021,aDlgCorp1[2]+035 MsGet cXmlPrdNcm        Size 085 ,008 Pixel When .F. Of oDialg

	@ aDlgCorp1[1]+022,aDlgCorp1[2]+128 Say "Unid.Med."         Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp1[1]+021,aDlgCorp1[2]+155 MsGet cXmlUniMed        Size 085 ,008 Pixel When .F. Of oDialg
	
	@ aDlgCorp1[1]+034,aDlgCorp1[2]+005 Say "Descricao"         Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp1[1]+033,aDlgCorp1[2]+035 MsGet cXmlPrdDes        Size 205 ,008 Pixel When .F. Of oDialg
	
	//Corpo 02
	@ aDlgCorp2[1], aDlgCorp2[2] To aDlgCorp2[3], aDlgCorp2[4] LABEL " Relacione o produto acima com um item do seu cadastro " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	
	@ aDlgCorp2[1]+010,aDlgCorp2[2]+005 Say "Produto"           Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp2[1]+009,aDlgCorp2[2]+035 MsGet cCadPrdCod        Size 085 ,008 Pixel When .T. Of oDialg F3 "SB1" Valid(fVldRlcPrd(.F.))
	
	@ aDlgCorp2[1]+010,aDlgCorp2[2]+128 Say "Barra"             Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp2[1]+009,aDlgCorp2[2]+155 MsGet cCadPrdBar        Size 085 ,008 Pixel When .F. Of oDialg

	@ aDlgCorp2[1]+022,aDlgCorp2[2]+005 Say "NCM"               Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp2[1]+021,aDlgCorp2[2]+035 MsGet cCadPrdNcm        Size 085 ,008 Pixel When .F. Of oDialg
	
	@ aDlgCorp2[1]+022,aDlgCorp2[2]+128 Say "Unid.Med."         Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp2[1]+021,aDlgCorp2[2]+155 MsGet cCadUniMed        Size 085 ,008 Pixel When .F. Of oDialg

	@ aDlgCorp2[1]+034,aDlgCorp2[2]+005 Say "Descricao"         Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp2[1]+033,aDlgCorp2[2]+035 MsGet cCadPrdDes        Size 205 ,008 Pixel When .F. Of oDialg

	//Corpo 03
	@ aDlgCorp3[1], aDlgCorp3[2] To aDlgCorp3[3], aDlgCorp3[4] LABEL " Conversao Unidade Medida " COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel

	@ aDlgCorp3[1]+010,aDlgCorp3[2]+005 Say "Fator Conv."       Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp3[1]+009,aDlgCorp3[2]+035 MsGet nCadFatCon        Size 085 ,008 Pixel When lWhenTtCps Of oDialg Picture "@E 9,999.99"
	
	@ aDlgCorp3[1]+010,aDlgCorp3[2]+128 Say "Tipo Conv."        Size 030 ,008 Pixel Of oDialg
	@ aDlgCorp3[1]+009,aDlgCorp3[2]+155 ComboBox oCadTipCon Var cCadTipCon Items aCadTipCon Size 085 ,008 Pixel When lWhenTtCps Of oDialg

	//Rodape / Botoes
	@ aDlgRodp[1], aDlgRodp[2] To aDlgRodp[3], aDlgRodp[4] LABEL "" COLOR CLR_BLUE,CLR_WHITE Of oDialg Pixel
	@ aBtn01[1],aBtn01[2] Button "Processar" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action (nOpcao:=1,oDialg:End())
	@ aBtn02[1],aBtn02[2] Button "Cancelar"  Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action (nOpcao:=2,oDialg:End())
	
	Activate MsDialog oDialg Centered
	
	//Verifica se operacao foi cancelada
	If nOpcao != 1
		lLoop   := .F.
		lReturn := .F.
	EndIf
	
	//Valida Produto escolhido
	If nOpcao == 1
		lReturn := fVldRlcPrd(.T.)
	EndIf

	//Caso lReturn OK, entao sair do Loop
	If lLoop .And. lReturn
		lLoop   := .F.
	EndIf
	
End

If nOpcao == 1 .And. lReturn

	//Declara variavel
	lExiste := .F.
	lReturn := .T.

	If lEhFornec
		//Tratando tamanho do conteudo do campo
		cXmlPrdCod := fTrtCodPrd(cXmlPrdCod,"1")

		SA5->(dbSetOrder(1))
		If SA5->(dbSeek(xFilial("SA5")+ cCodCliFor + cLojCliFor + cCadPrdCod))
			RecLock("SA5",.F.)
		Else
			Reclock("SA5",.T.)
		Endif
		SA5->A5_FILIAL  := xFilial("SA5")
		SA5->A5_FORNECE := cCodCliFor
		SA5->A5_LOJA    := cLojCliFor
		SA5->A5_NOMEFOR := cNomCliFor
		SA5->A5_PRODUTO := cCadPrdCod
		SA5->A5_NOMPROD := Upper(AllTrim(cCadPrdDes))
		SA5->A5_CODPRF  := Upper(AllTrim(cXmlPrdCod))
		If SA5->(FieldPos("A5_DESCPRF")) > 0
			SA5->A5_DESCPRF := Upper(AllTrim(cXmlPrdDes))
		Endif
		If lWhenTtCps
			&("SA5->"+cCpoUmXml) := cXmlUniMed
			&("SA5->"+cCpoFCNum) := nCadFatCon
			&("SA5->"+cCpoFCTip) := cCadTipCon			
			&("SA5->"+cCpoNCMFo) := cXmlPrdNcm
		EndIf
		SA5->(MsUnlock())

		//Esta variavel ser? retornata pra quem a chamou
		cCodProdut := SA5->A5_PRODUTO
		
		cVldMensag := "O produto ("+cCadPrdCod+") Vs ("+cXmlPrdCod+") foi cadastrado na tabela Amarracao Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
		fGravaMsg(nRecTab1,98," ",cVldMensag)
		
	Else
		//Tratando tamanho do conteudo do campo
		cXmlPrdCod := fTrtCodPrd(cXmlPrdCod,"2")
		
		SA7->(dbSetOrder(1))
		If SA7->(dbSeek(xFilial("SA7") + cCodCliFor + cLojCliFor + cCadPrdCod))
			RecLock("SA7",.F.)
		Else
			Reclock("SA7",.T.)
		Endif
		
		SA7->A7_FILIAL  := xFilial("SA7")
		SA7->A7_CLIENTE := cCodCliFor
		SA7->A7_LOJA    := cLojCliFor
		SA7->A7_PRODUTO := cCadPrdCod
		SA7->A7_DESCCLI := Upper(AllTrim(cXmlPrdDes))
		SA7->A7_CODCLI  := Upper(AllTrim(cXmlPrdCod))
		If lWhenTtCps
			&("SA7->"+cCpoUmXml) := cXmlUniMed
			&("SA7->"+cCpoFCNum) := nCadFatCon
			&("SA7->"+cCpoFCTip) := cCadTipCon			
			&("SA7->"+cCpoNCMFo) := cXmlPrdNcm
		EndIf
		SA7->(MsUnlock())

		//Esta variavel ser? retornata pra quem a chamou
		cCodProdut := SA7->A7_PRODUTO

		cVldMensag := "O produto ("+cCadPrdCod+") Vs ("+cXmlPrdCod+") foi cadastrado na tabela Amarracao Produto x "+IIf(lEhFornec,"Fornecedor [SA5]","Cliente [SA7]")
		fGravaMsg(nRecTab1,98," ",cVldMensag)
		
	EndIf
EndIf

Return(lReturn)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldRlcPrd()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fVldRlcPrd(lVldVazio)
*-----------------------------------------------------------*

Local lOk  := .T.
Local lRet := .F.
Default lVldVazio := .F.

//Valida fazio caso solicitado
If lOk .And. lVldVazio .And. Empty(cCadPrdCod)
	MsgAlert("O Produto nao foi informado. Informe um produto valido!")
	lOk := .F.
EndIf

//Se for vazio e nao e pra validar, entao sair e retornar .T., pois operacao foi cancelada
If lOk .And. !lVldVazio .And. Empty(cCadPrdCod)
	cCadPrdCod := Space(fX3Ret("B1_COD","X3_TAMANHO"))
	cCadPrdBar := Space(fX3Ret("B1_CODBAR","X3_TAMANHO"))
	cCadPrdNcm := ""
	cCadUniMed := ""
	cCadPrdDes := ""
	Return(.T.)
EndIf

SB1->(dbSetOrder(1))
If lOk .And. SB1->(!dbSeek(xFilial("SB1")+AllTrim(cCadPrdCod)))
	MsgAlert("Produto Cod.: "+cCadPrdCod+" nao encontrado. Informe um produto valido!")
	lOk := .F.
EndIf

If lOk .And. SB1->B1_MSBLQL == "1"
	MsgAlert("Produto Cod.: "+cCadPrdCod+" bloqueado. Informe um produto valido!")
	lOk := .F.
EndIf

If lOk
	lRet       := .T.
	cCadPrdCod := SB1->B1_COD
	cCadPrdBar := SB1->B1_CODBAR
	cCadPrdNcm := SB1->B1_POSIPI
	cCadUniMed := SB1->B1_UM
	cCadPrdDes := SB1->B1_DESC
Else
	lRet       := .F.
	cCadPrdCod := Space(fX3Ret("B1_COD","X3_TAMANHO"))
	cCadPrdBar := Space(fX3Ret("B1_CODBAR","X3_TAMANHO"))
	cCadPrdNcm := ""
	cCadUniMed := ""
	cCadPrdDes := ""
EndIf

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerPrcExp()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerPrcExp()
*-----------------------------------------------------------*

Local cDirDest := cGetFile(,"Selecione o diretorio",,"",.T.,GETF_LOCALHARD+ GETF_RETDIRECTORY+GETF_NETWORKDRIVE)

If !Empty(cDirDest)
	Processa( {|| fGerSlvXml(cDirDest)    },"Exportando XML pro diretorio selecionado..." )
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerSlvXml()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerSlvXml(cDirDest)
*-----------------------------------------------------------*

Local x        := 0
Local cPath    := ""
Local cTemp    := ""
Local nRecn    := 0
Local cTab1    := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local nQtdExp  := 0

Local nPosFlag := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])==    "XX_FLAG"  })
Local nPosRecn := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])==    "XX_RECNO" })
Local nPosCnpj := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])==cAls1+"_DECNPJ"})
Local nPosEmis := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])==cAls1+"_DTEMIS"})

ProcRegua(Len(oGdItm01:aCols))

For x:=1 To Len(oGdItm01:aCols)
	If oGdItm01:aCols[x][nPosFlag] == "LBTIK"
		IncProc()
		nQtdExp ++
		
		cPath := cDirDest

		//CNPJ
		cTemp := Alltrim(oGdItm01:aCols[x][nPosCnpj])
		cPath += cTemp+"\"

		//ANO
		cTemp := SubStr(DtoS(oGdItm01:aCols[x][nPosEmis]),1,4)
		cPath += cTemp+"\"

		//MES
		cTemp := SubStr(DtoS(oGdItm01:aCols[x][nPosEmis]),5,2)
		cPath += cTemp+"\"

		//Trata variavel
		cPath := AllTrim(Upper(cPath))

		//Cria Diretorio
		MontaDir(cPath)

		//Recno do Registro corrente
		nRecn := oGdItm01:aCols[x][nPosRecn]

		//Gerar Arquivo XML
		fGerGrvXml(cPath,nRecn)

	EndIf
Next x

MsgInfo("Foram exportados "+Alltrim(Str(nQtdExp))+" arquivos XML.")

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerGrvXml()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerGrvXml(cPathDest,nRecTab1)
*-----------------------------------------------------------*
Local nHdl	:= 0
Local cCRLF	:= Chr(13)+Chr(10)

Local cTab1 := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1 := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cArqv := ""
Local cDeth := ""
Local cMemo := ""

//Posiciona no registro a ser validade
(cTab1)->(DbGoTo(nRecTab1))
cArqv := cPathDest + AllTrim((cTab1)->&(cAls1+"_CHVNFE")) + ".XML"

//Apaga arquivo caso exista
If File(cArqv) ; fErase(cArqv) ; Endif

//Cria arquivo txt
nHdl := fCreate(cArqv)

cDeth := AllTrim((cTab1)->&(cAls1+"_MXML" ))
cDeth += AllTrim((cTab1)->&(cAls1+"_MXML2"))
cDeth := EncodeUTF8(cDeth)

fWrite( nHdl,cDeth+cCRLF,Len(cDeth+cCRLF ) )

//Finaliza processo e fecha arquivo txt
fClose(nHdl)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerLegend()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerLegend()
*-----------------------------------------------------------*
Local aCores     := {}

For x:=1 To Len(aHdStatus)
	aAdd(aCores,{aHdStatus[x][2],aHdStatus[x][3]})
Next x

BrwLegenda(" Gerenciador XML ","Legenda",aCores)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerCabec()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerCabec(aSizeDlg,oDialg,cOper)
*-----------------------------------------------------------*

Local cTab1        := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

Local nQtdCpo := 8
Local nTamCpo := (aSizeDlg[4] / nQtdCpo)

//----------------------------------------------------------------------------------------------

//Declaracao das Vari?veis
Local bSayTipDoc := {|| "Tipo Documento"}
Local aSayTipDoc := {aSizeDlg[1]+05,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}
Local aGetTipDoc := {aSizeDlg[1]+15,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}

//Declaracao das Vari?veis
Local bSayStatus := {|| "Status"}
Local aSayStatus := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 1)  ,  (nTamCpo*1.5)-05, 008}
Local aGetStatus := {aSizeDlg[1]+15,   aSizeDlg[2] + (nTamCpo * 1)  ,  (nTamCpo*1.5)-05, 008}

//Declaracao das Vari?veis
Local bSayComCCe := {|| "Com CCe"}
Local aSayComCCe := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 2.5),  (nTamCpo*0.5)-05, 008}
Local aGetComCCe := {aSizeDlg[1]+15,   aSizeDlg[2] + (nTamCpo * 2.5),  (nTamCpo*0.5)-05, 008}

//Declaracao das Vari?veis
Local bSayCnpjEm := {|| "CNPJ Emitente"}
Local aSayCnpjEm := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}
Local aGetCnpjEm := {aSizeDlg[1]+15,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}

//Declaracao das Vari?veis
Local bSayNomeEm := {|| "Nome Emitente"}
Local aSayNomeEm := {aSizeDlg[1]+05,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}
Local aGetNomeEm := {aSizeDlg[1]+15,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}

//Botao
Local aBtn01     := {aSizeDlg[1]+13,   aSizeDlg[2] + (nTamCpo * 7)  ,  nTamCpo-05, 012}

//----------------------------------------------------------------------------------------------

//Declaracao das Vari?veis
Local bSayTipXml := {|| "Tipo XML"}
Local aSayTipXml := {aSizeDlg[1]+27,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}
Local aGetTipXml := {aSizeDlg[1]+37,   aSizeDlg[2] + (005)          ,  nTamCpo-10, 008}

//Declaracao das Vari?veis
Local bSayDtEmis := {|| "A partir Data Emissao"}
Local aSayDtEmis := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 1)  ,  nTamCpo-05, 008}
Local aGetDtEmis := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 1)  ,  nTamCpo-05, 008}

//Declaracao das Vari?veis
Local bSaySerNFe := {|| "Serie NF"}
Local aSaySerNFe := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 2)  ,  nTamCpo-05, 008}
Local aGetSerNFe := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 2)  ,  nTamCpo-05, 008}

//Declaracao das Vari?veis
Local bSayNumNFe := {|| "Numero NF"}
Local aSayNumNFe := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}
Local aGetNumNFe := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 3)  ,  nTamCpo-05, 008}

//Declaracao das Vari?veis
Local bSayChvNFe := {|| "Chave Nota Fiscal"}
Local aSayChvNFe := {aSizeDlg[1]+27,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}
Local aGetChvNFe := {aSizeDlg[1]+37,   aSizeDlg[2] + (nTamCpo * 4)  ,  (nTamCpo*3)-05, 008}


//Botao
Local aBtn02     := {aSizeDlg[1]+35,   aSizeDlg[2] + (nTamCpo * 7)  ,  nTamCpo-05, 012}

//----------------------------------------------------------------------------------------------

Local aCBoxTipDoc := {}//Tipo Documento
Local aCBoxTipXml := {}//Tipo XML
Local aCBoxComCCe := {}//Com Carta de Correcao
Local aCBoxStatus := {}//Status

//----------------------------------------------------------------------------------------------

//Opcoes da Pergunta
aAdd(aCBoxTipDoc,"T=Todos Documentos")
aAdd(aCBoxTipDoc,"N=Normal"          )
aAdd(aCBoxTipDoc,"D=Devolucao"       )
aAdd(aCBoxTipDoc,"B=Beneficiamento"  )
aAdd(aCBoxTipDoc,"C=Complementar"    )
aAdd(aCBoxTipDoc,"A=Ajuste"          )
aAdd(aCBoxTipDoc,"U=Anulacao"        )
aAdd(aCBoxTipDoc,"S=Substituicao"    )
aAdd(aCBoxTipDoc,"X=Indefinido"      )

//Opcoes da Pergunta
aAdd(aCBoxTipXml,"T=Todos Tipos"     )
aAdd(aCBoxTipXml,"1=NF"              )
aAdd(aCBoxTipXml,"2=CT"              )
aAdd(aCBoxTipXml,"3=XML Pedente"     )

//Opcoes da Pergunta
aAdd(aCBoxComCCe,"T=Todos"           )
aAdd(aCBoxComCCe,"S=Sim"              )
aAdd(aCBoxComCCe,"N=Nao"              )

//Opcoes da Pergunta
aAdd(aCBoxStatus,"T=Todos Status"                           )
aAdd(aCBoxStatus,"0=XML pendente de recebimento"            )
aAdd(aCBoxStatus,"1=XML recebido com sucesso"               )
aAdd(aCBoxStatus,"2=XML recebido com erro"                  )
aAdd(aCBoxStatus,"3=XML j? incluido no sistema"             )
aAdd(aCBoxStatus,"4=XML gerou erro na pre-nota"             )
aAdd(aCBoxStatus,"5=XML gerou pre-nota depois foi exclu?da" )
aAdd(aCBoxStatus,"6=XML de cancelamento recebido"           )
aAdd(aCBoxStatus,"7=XML bloqueado pelo validador"           )

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//----------------------------------------------------------------------------------------------

oSayTipDoc  := TSay():New( aSayTipDoc[1] ,aSayTipDoc[2] ,bSayTipDoc ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayTipDoc[3] ,aSayTipDoc[4])
oGetTipDoc  := TComboBox():New( aGetTipDoc[1],aGetTipDoc[2],{|u| IIf(Pcount()>0,cGetTipDoc:=u,cGetTipDoc)},aCBoxTipDoc,aGetTipDoc[3],aGetTipDoc[3],oDialg,,,,,,.T.)

oSayStatus  := TSay():New( aSayStatus[1] ,aSayStatus[2] ,bSayStatus ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayStatus[3] ,aSayStatus[4])
oGetStatus  := TComboBox():New( aGetStatus[1],aGetStatus[2],{|u| IIf(Pcount()>0,cGetStatus:=u,cGetStatus)},aCBoxStatus,aGetStatus[3],aGetStatus[3],oDialg,,,,,,.T.)

oSayComCCe  := TSay():New( aSayComCCe[1] ,aSayComCCe[2] ,bSayComCCe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayComCCe[3] ,aSayComCCe[4])
oGetComCCe  := TComboBox():New( aGetComCCe[1],aGetComCCe[2],{|u| IIf(Pcount()>0,cGetComCCe:=u,cGetComCCe)},aCBoxComCCe,aGetComCCe[3],aGetComCCe[3],oDialg,,,,,,.T.)

oSayCnpjEm  := TSay():New( aSayCnpjEm[1] ,aSayCnpjEm[2] ,bSayCnpjEm ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayCnpjEm[3] ,aSayCnpjEm[4])
oGetCnpjEm  := TGet():New( aGetCnpjEm[1] ,aGetCnpjEm[2] ,{|u| IIf(Pcount()>0,cGetCnpjEm:=u ,cGetCnpjEm )},oDialg,aGetCnpjEm[3] ,aGetCnpjEm[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

oSayNomeEm  := TSay():New( aSayNomeEm[1] ,aSayNomeEm[2] ,bSayNomeEm ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayNomeEm[3] ,aSayNomeEm[4])
oGetNomeEm  := TGet():New( aGetNomeEm[1] ,aGetNomeEm[2] ,{|u| IIf(Pcount()>0,cGetNomeEm:=u ,cGetNomeEm )},oDialg,aGetNomeEm[3] ,aGetNomeEm[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//----------------------------------------------------------------------------------------------

oSayTipXml  := TSay():New( aSayTipXml[1] ,aSayTipXml[2] ,bSayTipXml ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayTipXml[3] ,aSayTipXml[4])
oGetTipXml  := TComboBox():New( aGetTipXml[1],aGetTipXml[2],{|u| IIf(Pcount()>0,cGetTipXml:=u,cGetTipXml)},aCBoxTipXml,aGetTipXml[3],aGetTipXml[3],oDialg,,,,,,.T.)

oSayDtEmis  := TSay():New( aSayDtEmis[1] ,aSayDtEmis[2] ,bSayDtEmis ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayDtEmis[3] ,aSayDtEmis[4])
oGetDtEmis  := TGet():New( aGetDtEmis[1] ,aGetDtEmis[2] ,{|u| IIf(Pcount()>0,dGetDtEmis:=u ,dGetDtEmis )},oDialg,aGetDtEmis[3] ,aGetDtEmis[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

oSaySerNFe  := TSay():New( aSaySerNFe[1] ,aSaySerNFe[2] ,bSaySerNFe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSaySerNFe[3] ,aSaySerNFe[4])
oGetSerNFe  := TGet():New( aGetSerNFe[1] ,aGetSerNFe[2] ,{|u| IIf(Pcount()>0,cGetSerNFe:=u ,cGetSerNFe )},oDialg,aGetSerNFe[3] ,aGetSerNFe[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

oSayNumNFe  := TSay():New( aSayNumNFe[1] ,aSayNumNFe[2] ,bSayNumNFe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayNumNFe[3] ,aSayNumNFe[4])
oGetNumNFe  := TGet():New( aGetNumNFe[1] ,aGetNumNFe[2] ,{|u| IIf(Pcount()>0,cGetNumNFe:=u ,cGetNumNFe )},oDialg,aGetNumNFe[3] ,aGetNumNFe[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

oSayChvNFe  := TSay():New( aSayChvNFe[1] ,aSayChvNFe[2] ,bSayChvNFe ,oDialg,,,.F.,.F.,.F.,.T.,,,aSayChvNFe[3] ,aSayChvNFe[4])
oGetChvNFe  := TGet():New( aGetChvNFe[1] ,aGetChvNFe[2] ,{|u| IIf(Pcount()>0,cGetChvNFe:=u ,cGetChvNFe )},oDialg,aGetChvNFe[3] ,aGetChvNFe[4] ,'@!'  ,/*cValid*/{|| .T. } ,,,,.F.,,.T.,  ,.F.,/*cWhen*/{|| .T. },.F.,.F.,,.F.,.F.,/*cF3*/"","",,,,.T.)

//----------------------------------------------------------------------------------------------

//Botoes
@ aBtn01[1],aBtn01[2] Button "Pesquisar" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action fGerPesqsa(cOper)
@ aBtn02[1],aBtn02[2] Button "Limpar"    Size aBtn02[3],aBtn02[4] Pixel Of oDialg Action fGerLimpar()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerPesqsa()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerPesqsa(cOper)
*-----------------------------------------------------------*

MsAguarde({|| fGerPrcPsq(cOper) },"Processando...","Aguarde, pesquisando ... ")

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerPrcPsq()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerPrcPsq(cOper)
*-----------------------------------------------------------*

//aIndexCad
Local cTab1        := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

Local cCpo   := " "+cAls1+"_STATUS , R_E_C_N_O_ AS XX_RECNO "
Local cQry   := ""
Local cQbra  := Chr(13)+Chr(10)

For x:=1 To Len(aHeadCpos)
	If !(aHeadCpos[x] $ cCpo)
		cCpo += IIf(Empty(cCpo),"",",") + aHeadCpos[x] + " "
	EndIf
Next

cQry += cQbra+" SELECT " + cCpo
cQry += cQbra+" FROM "+RetSqlName(cTab1)+" "+cTab1+"(NOLOCK)
cQry += cQbra+" WHERE "+cTab1+".D_E_L_E_T_ = ''
//----------------------------------------------------------
If cGetTipXml != "T"
cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_TIPXML = '"+AllTrim(cGetTipXml)+"' "
EndIf
//----------------------------------------------------------
If cGetStatus != "T"
	cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_STATUS = '"+AllTrim(cGetStatus)+"' "
Else
	cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_STATUS <> '3' "
EndIf
//----------------------------------------------------------
If cGetComCCe != "T"
cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_TEMCCE = '"+AllTrim(cGetComCCe)+"' "
EndIf
//----------------------------------------------------------
If !Empty(cGetCnpjEm)
cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_DECNPJ) LIKE '%"+AllTrim(cGetCnpjEm)+"%' "
EndIf
//----------------------------------------------------------
If !Empty(cGetNomeEm)
cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_DENOME) LIKE '%"+AllTrim(cGetNomeEm)+"%' "
EndIf
//----------------------------------------------------------
If cGetTipDoc != "T"
cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_TIPDOC = '"+AllTrim(cGetTipDoc)+"' "
EndIf
//----------------------------------------------------------
If !Empty(dGetDtEmis)
cQry += cQbra+"   AND "+cTab1+"."+cAls1+"_DTEMIS >= '"+DtoS(dGetDtEmis)+"' "
EndIf
//----------------------------------------------------------
If !Empty(cGetSerNFe)
cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_SERIE) LIKE '%"+AllTrim(cGetSerNFe)+"%' "
EndIf
//----------------------------------------------------------
If !Empty(cGetNumNFe)
cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_DOC) LIKE '%"+AllTrim(cGetNumNFe)+"%' "
EndIf
//----------------------------------------------------------
If !Empty(cGetChvNFe)
cQry += cQbra+"   AND UPPER("+cTab1+"."+cAls1+"_CHVNFE) LIKE '%"+AllTrim(cGetChvNFe)+"%' "
EndIf
//----------------------------------------------------------

//----------------------------------------------------------
cQry += cQbra+" ORDER BY "+cAls1+"_DTEMIS, "+cAls1+"_DECNPJ, "+cAls1+"_DOC"
//----------------------------------------------------------

//Fecha Alias caso encontre
If Select("QRY") <> 0 ; QRY->(dbCloseArea()) ; EndIf

//Cria alias temporario
TcQuery cQry New Alias "QRY"

//Trata campos Data
For x:=1 To Len(aHeadCpos)
	If fX3Ret(aHeadCpos[x],"X3_TIPO") == "D"
		TcSetField("QRY",aHeadCpos[x],"D",8,0)
	EndIf
Next x

//Limpa GetDados 01
oGdItm01:aCols := {}
oGdItm01:oBrowse:Refresh()

//Carrega GetDados 01 com nova pesquisa
fGerCargGD()

//Fecha Alias
QRY->(dbCloseArea())

//Zera variavel que controla ordenacao
aOrdHead := {}

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerCargGD()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerCargGD()
*-----------------------------------------------------------*

Local cCmdTemp := ""
Local nPosTemp := 0
Local nPosFlag := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"  })
Local nPosStts := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_STATUS"})

//Carrega aCols com base no resultado da query
QRY->(DbGoTop())
While QRY->(!Eof())
	
	//Cria uma linha no aCols
	aAdd(oGdItm01:aCols,Array(Len(oGdItm01:aHeader)+1))
	nLin := Len(oGdItm01:aCols)

	//Alimenta a linha do aCols vazia
	oGdItm01:aCols[nLin, nPosFlag] := "LBTIK"

	//Tratando legenda do status
	For y:=1 To Len(aHdStatus)
		cCmdTemp := AllTrim(aHdStatus[y][1])
		cCmdTemp := "QRY->("+cCmdTemp+")"
		If &(cCmdTemp)
			oGdItm01:aCols[nLin, nPosStts] := aHdStatus[y][2]
			y := Len(aHdStatus)
		EndIf
	Next y

	//Carregando campos que serao visualizados no GD
	For y:=1 To Len(aHeadCpos)
		nPosTemp := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])==aHeadCpos[y]})
		oGdItm01:aCols[nLin, nPosTemp ] := &("QRY->"+aHeadCpos[y])
	Next y

	//Adiciona Coluna Recno
	nPosTemp := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])=="XX_RECNO"})
	oGdItm01:aCols[nLin, nPosTemp ] := QRY->XX_RECNO

	oGdItm01:aCols[nLin, Len(oGdItm01:aHeader)+1] := .F.

	QRY->(DbSkip())
End

//Carrega aCols com uma linha vazia por nao teve resultado na query
QRY->(DbGoTop())
If QRY->(Eof())
	//Cria uma linha no aCols
	aAdd(oGdItm01:aCols,Array(Len(oGdItm01:aHeader)+1))
	nLin := Len(oGdItm01:aCols)

	//Alimenta a linha do aCols vazia
	oGdItm01:aCols[nLin, nPosFlag] := "LBNO"

	oGdItm01:aCols[nLin, nPosStts] := "ENABLE"

	For y:=1 To Len(aHeadCpos)
		nPosTemp := aScan(oGdItm01:aHeader,{|x|AllTrim(x[2])==aHeadCpos[y]})
		oGdItm01:aCols[nLin, nPosTemp ] := CriaVar(aHeadCpos[y],.F.)
	Next y

	oGdItm01:aCols[nLin, Len(oGdItm01:aHeader)+1] := .F.
EndIf

//Atualiza tela
oGdItm01:oBrowse:nAt := 1
oGdItm01:oBrowse:Refresh()
oGdItm01:oBrowse:SetFocus()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerLimpar()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerLimpar()
*-----------------------------------------------------------*

Local cTab1        := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1        := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)

//----------------------------------------------------------
cGetTipDoc := "T"
oGetTipDoc:Refresh()
//----------------------------------------------------------
cGetTipXml := "T"
oGetTipXml:Refresh()
//----------------------------------------------------------
dGetDtEmis := StoD("")
oGetDtEmis:Refresh()
//----------------------------------------------------------
cGetChvNFe := Space(fX3Ret(cAls1+"_CHVNFE","X3_TAMANHO"))
oGetChvNFe:Refresh()
//----------------------------------------------------------
cGetSerNFe := Space(fX3Ret(cAls1+"_SERIE","X3_TAMANHO"))
oGetSerNFe:Refresh()
//----------------------------------------------------------
cGetNumNFe := Space(fX3Ret(cAls1+"_DOC","X3_TAMANHO"))
oGetNumNFe:Refresh()
//----------------------------------------------------------
cGetCnpjEm := Space(fX3Ret(cAls1+"_DECNPJ","X3_TAMANHO"))
oGetCnpjEm:Refresh()
//----------------------------------------------------------
cGetNomeEm := Space(fX3Ret(cAls1+"_DENOME","X3_TAMANHO"))
oGetNomeEm:Refresh()
//----------------------------------------------------------
cGetComCCe := "T"
oGetComCCe:Refresh()
//----------------------------------------------------------
cGetStatus := "T"
oGetStatus:Refresh()
//----------------------------------------------------------
oGdItm01:aCols := {}
oGdItm01:oBrowse:Refresh()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNInc()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNInc()

Local cDirXml  := AllTrim(SuperGetMv("MV_FM_DXML",,"\data\impxml\"))
Local cTipo 	:=	"Arquivos XML (*.XML)       | *.XML  |"
Local cTitulo	:= "Dialogo de Selecao de Arquivos"
Local cDirIni	:= ""
Local cDrive	:= ""
Local cDir		:= ""
Local cFile		:= ""
Local cExten	:= ""
Local cGetFile	:= cGetFile(cTipo,cTitulo,,cDirIni,.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE)//GETF_ONLYSERVER+GETF_RETDIRECTORY+GETF_LOCALFLOPPY
Local cNovoDir := ""

// Separa os componentes
SplitPath( cGetFile, @cDrive, @cDir, @cFile, @cExten )

If !Empty(cFile)
	If !File(cGetFile)
		Alert("Erro ao localizar arquivo origem!")
		Return
	EndIf

	//Cria pasta caso nao exita ainda
	MontaDir(cDirXml+"pendente\")
	
   //Local Destino Arquivo
	cNovoDir := cDirXml+"pendente\"+cFile+cExten

	If File(cNovoDir)
		Alert("Erro ao tentar anexar arquivo, XML j? est? na fila pra processamento!")
		Return
	EndIf

	Processa( {|| fCopiaXML(cGetFile,cNovoDir)    },"Copiando XML pro server..." )
	Processa( {|| fTrataXML()                     },"Tratando XML copiado..." )

	MsgInfo("Arquivo anexado com sucesso!")

EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCopiaXML()
//|Autor.....: Luiz Alberto
//|Data......: 27 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCopiaXML(cFileOri,cFileDest)
*-----------------------------------------------------------*

//Copia arquivo pra servidor
COPY File &cFileOri TO &cFileDest

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNHis()
//|Autor.....: Luiz Alberto
//|Data......: 22 de outubro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNHis()
*-----------------------------------------------------------*

//Variaveis do tamanho a tela
Local aDlgTela     := {000,000,307,705}

//Divisoes dentro da tela
Local aDlgCabc     := {005,005,125,350}
Local aDlgRodp     := {130,005,150,350}

Local cTab2   := AllTrim(GetNewPar("MV_FMALS02",''))
Local cAls2   := IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)

Local oDialgH
Local cStrCad    := AllTrim(GetNewPar("MV_FMALS02",''))
Local cTitCad    := "Historico"
Local cPrtCad    := cTitCad+" ["+cStrCad+"]"

// Montagem da tela que serah apresentada para usuario (lay-out)
Define MsDialog oDialgH Title cPrtCad From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Of oMainWnd Pixel

fHisCabec(oDialgH,aDlgCabc)
fHisRodap(oDialgH,aDlgRodp)

Activate MsDialog oDialgH Centered

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fHisCabec()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fHisCabec(oDialg,aSizeDlg)
*-----------------------------------------------------------*
Local cTab1   := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cTab2   := AllTrim(GetNewPar("MV_FMALS02",''))
Local cAls2   := IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Local cGetOpc        := Nil                                             // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
Local aHead          := {}                                              // Array do aHeader
Local aCols          := {}                                              // Array do aCols
Local aHeadCpos      := {}
Local oGdItem02      := Nil

//Campos que serao apresentados no MsNewGetDados
aAdd(aHeadCpos,cAls2+"_CHVNFE" )
aAdd(aHeadCpos,cAls2+"_PROTOC" )
aAdd(aHeadCpos,cAls2+"_MSG"    )
aAdd(aHeadCpos,cAls2+"_LOGDT"  )
aAdd(aHeadCpos,cAls2+"_LOGHR"  )
aAdd(aHeadCpos,cAls2+"_LOGUSR" )

For x:=1 To Len(aHeadCpos)
	cX3_Descr := fX3Ret(aHeadCpos[x],"X3_TITULO" )
	cX3_Campo := fX3Ret(aHeadCpos[x],"X3_CAMPO"  )
	cX3_Tipo  := fX3Ret(aHeadCpos[x],"X3_TIPO"   )
	cX3_Pictu := fX3Ret(aHeadCpos[x],"X3_PICTURE")
	nX3_Tam01 := fX3Ret(aHeadCpos[x],"X3_TAMANHO")
	nX3_Tam02 := fX3Ret(aHeadCpos[x],"X3_DECIMAL")

   //          X3_TITULO, X3_CAMPO      , X3_PICTURE          ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO , X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
	aAdd(aHead,{cX3_Descr,cX3_Campo      ,cX3_Pictu            ,   nX3_Tam01,  nX3_Tam02, ""      , "??????????????", cX3_Tipo, ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
Next x

(cTab2)->(DbSetOrder(3))
If (cTab2)->(DbSeek(xFilial(cTab2)+(cTab1)->&(cAls1+"_CHVNFE")))
	While (cTab2)->(!Eof()) .And. (cTab2)->&(cAls2+"_CHVNFE") == (cTab1)->&(cAls1+"_CHVNFE")

		//Cria uma linha no aCols
		aAdd(aCols,Array(Len(aHead)+1))
		nLin := Len(aCols)
		//Alimenta a linha do aCols vazia
		For y:=1 To Len(aHeadCpos)
			aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])==aHeadCpos[y]}) ] := (cTab2)->&(aHeadCpos[y])
		Next y
		aCols[nLin, Len(aHead)+1] := .F.
	
		(cTab2)->(DbSkip())
	End
Else
	//Cria uma linha no aCols
	aAdd(aCols,Array(Len(aHead)+1))
	nLin := Len(aCols)
	//Alimenta a linha do aCols vazia
	For y:=1 To Len(aHeadCpos)
		aCols[nLin, aScan(aHead,{|x|AllTrim(x[2])==aHeadCpos[y]}) ] := CriaVar(aHeadCpos[y],.F.)
	Next y
	aCols[nLin, Len(aHead)+1] := .F.
EndIf

oGdItem02:=MsNewGetDados():New(aSizeDlg[1]+05,aSizeDlg[2]+05,aSizeDlg[3]-05,aSizeDlg[4]-05,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHead,aCols)

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fX3Ret()
//|Autor.....: Luiz Alberto
//|Data......: 14 de outubro de 2014, 08:00
//|Descricao.: 
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fX3Ret(cCampo,cRet)
*-----------------------------------------------------------*

Default cCampo := ""
Default cRet   := ""

SX3->(DbSetOrder(2))
If SX3->(MsSeek(cCampo))
	cRet := &("SX3->"+cRet)
EndIf

If ValType(cRet) == "C"
	cRet := AllTrim(cRet)
EndIf

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fHisRodap()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fHisRodap(oDialg,aSizeDlg)
*-----------------------------------------------------------*

Local nQtdCpo := 5
Local nTamBtn := (aSizeDlg[4] / nQtdCpo)
Local aBtn01  := {aSizeDlg[1]+04,   aSizeDlg[2] + (nTamBtn * 4)  ,  nTamBtn-10, 012}

//Contorno
@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDialg Pixel

//Botoes
@ aBtn01[1],aBtn01[2] Button "Sair" Size aBtn01[3],aBtn01[4] Pixel Of oDialg Action oDialg:End()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVerifInic()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fVerifInic()
*-----------------------------------------------------------*

Private cFMTabNovo := "/"
//Verifica se parametros j? foram criados
//Verifica o conteudo dos parametros
//Cria parametro caso necess?rio
cFMAlias01 := fPesqTab("MV_FMALS01")
cFMTabNovo += cFMAlias01+"/"

cFMAlias02 := fPesqTab("MV_FMALS02")
cFMTabNovo += cFMAlias02+"/"

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fPesqTab()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fPesqTab(cVar)
*-----------------------------------------------------------*

Local cRet     := ""
Local aAreaSX6 := SX6->(GetArea())

//Verifica se parametro existe e busca conteudo do mesmo
SX6->(DbSetOrder(1))
If SX6->(DbSeek(xFilial("SX6")+cVar))
	cRet := GetMv(cVar)
EndIf

//Valida Conteudo do Parametro
If Empty(cRet)
	//Procura tabela disponivel
	cRet := fNewSX2()

	//Cria parametro 
	If SX6->(DbSeek(xFilial("SX6")+cVar))
		RecLock("SX6",.F.)
	Else
		RecLock("SX6",.T.)
	EndIf
	SX6->X6_FIL     := ""
	SX6->X6_VAR     := cVar
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "TABELA UTILIZADA PELA ROTINA GERXMLNF()"
	SX6->X6_CONTEUD := cRet
	SX6->X6_PROPRI  := "U"
	SX6->(MsUnLock())
EndIf

RestArea(aAreaSX6)

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fNewSX2()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fNewSX2()
*-----------------------------------------------------------*

Local cRet     := ""
Local lLoop    := .T.
Local cNewTab  := "SZ0"
Local aAreaSX2 := SX2->(GetArea())

SX2->(DbSetOrder(1))
While lLoop
	If SX2->(DbSeek(cNewTab)) .Or. cNewTab $ cFMTabNovo
		cNewTab := Soma1(cNewTab)
		Do Case
			Case SubStr(cNewTab,1,2) != "SZ" .And. SubStr(cNewTab,1,1) == "S"
				cNewTab := "ZZ0"
			Case SubStr(cNewTab,1,2) != "ZZ" .And. SubStr(cNewTab,1,1) == "Z"
				cNewTab := "P00"
		EndCase
	Else
		cRet  := cNewTab
		lLoop := .F.
	EndIf
End

RestArea(aAreaSX2)

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCriaSXs()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCriaSXs()
*-----------------------------------------------------------*
Local aAreaSX2 := SX2->(GetArea())
Local aAreaSX3 := SX3->(GetArea())
Local aAreaSIX := SIX->(GetArea())

fCriaSX2()
fCriaSX3()
fCriaSIX()

RestArea(aAreaSX2)
RestArea(aAreaSX3)
RestArea(aAreaSIX)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCriaSX2()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCriaSX2()
*-----------------------------------------------------------*

Local cPath  := ""
Local cNome  := ""
Local aEstrut:= {}
Local aSX2   := {}
Local i      := 0
Local j      := 0

aEstrut := {"X2_CHAVE","X2_PATH"   ,"X2_ARQUIVO","X2_NOME"                       ,"X2_NOMESPA"                    ,"X2_NOMEENG"                    ,"X2_DELET","X2_MODO","X2_MODOUN","X2_MODOEMP","X2_TTS","X2_ROTINA","X2_PYME","X2_UNICO"}
Aadd(aSX2, {cFMAlias01,""          ,""          ,"Ger. XML NFe - Principal"      ,"Ger. XML NFe - Principal"      ,"Ger. XML NFe - Principal"      ,0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"N"      ,""        })
Aadd(aSX2, {cFMAlias02,""          ,""          ,"Ger. XML NFe - Historico"      ,"Ger. XML NFe - Historico"      ,"Ger. XML NFe - Historico"      ,0         ,"C"      ,"C"        ,"C"         ,""      ,""         ,"N"      ,""        })

dbSelectArea("SX2")
dbSetOrder(1)
dbSeek("SF1")

cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !dbSeek(aSX2[i,1])
			RecLock("SX2",.T.)
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			SX2->X2_PATH    := cPath
			SX2->X2_ARQUIVO := aSX2[i,1]+cNome
			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCriaSX3()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCriaSX3()
*-----------------------------------------------------------*

Local aSX3       := {}
Local cAls       := ""
Local aEstrut    := {}
Local aCampos    := {}
Local i          := 0
Local j          := 0
Local x          := 0
Local lCriaPerg  := .F.
Local cTipDoc    := "N=Normal;D=Devolucao;B=Beneficiamento;C=Complementar;A=Ajuste;U=Anulacao;S=Substituicao;X=Indefinido"
Local cTipXml    := "1=NF;2=CT;3=XML Pedente"

//CFOP de Entrada (inicia por 1, 2, 3) para NF-e de Sa?da (tpNF=1) 
//CFOP de Sa?da (inicia por 5, 6, 7) para NF-e de Entrada (tpNF=0) 
//CFOP de Operacao com Exterior (inicia por 3 ou 7) e UF destinat?rio = EX

//TABELA	PRINCIPAL
aCampos := {}
cAls := AllTrim(cFMAlias01)
cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP                                       ,                                         ,                                          ,VALID                    ,WHEN                 ,RELACAO
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP
aAdd(aCampos,{cAls+"_FILIAL" ,"C"      ,fX3Ret("A1_FILIAL","X3_TAMANHO")            ,0            ,"Filial      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,""                               })
aAdd(aCampos,{cAls+"_STATUS" ,"C"      ,1            ,0            ,"Status      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_TIPDOC" ,"C"      ,1            ,0            ,"Tipo Doc.   ","@!"                  ,   cTipDoc                        ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_TIPXML" ,"C"      ,1            ,0            ,"Tipo XML    ","@!"                  ,   cTipXml                        ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_TEMCCE" ,"C"      ,1            ,0            ,"Tem CCe     ","@!"                  ,   "S=Sim;N=Nao"                  ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_CHVNFE" ,"C"      ,44           ,0            ,"Chave       ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_SERIE"  ,"C"      ,3            ,0            ,"Serie       ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_DOC"    ,"C"      ,9            ,0            ,"Nota Fiscal ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_DTEMIS" ,"D"      ,8            ,0            ,"Dt Emissao  ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_HREMIS" ,"C"      ,8            ,0            ,"Hr Emissao  ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_DEUF"   ,"C"      ,02           ,0            ,"UF          ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_DECIDAD","C"      ,30           ,0            ,"Cidade Emit.","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_DECNPJ" ,"C"      ,14           ,0            ,"CNPJ Emit.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_DENOME" ,"C"      ,50           ,0            ,"Nome Emit.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_TOCNPJ" ,"C"      ,14           ,0            ,"CNPJ Dest.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_TONOME" ,"C"      ,50           ,0            ,"Nome Dest.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_VLRTOT" ,"N"      ,16           ,4            ,"Valor Total ","@E 999,999,999.9999" ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_ARQUIV" ,"C"      ,100          ,0            ,"Arquivo     ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_MXML"   ,"M"      ,10           ,0            ,"XML     "    ,"@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_MXML2"  ,"M"      ,10           ,0            ,"XML Contin." ,"@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_LOGDT"  ,"D"      ,8            ,0            ,"LOG Data    ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_LOGHR"  ,"C"      ,8            ,0            ,"LOG Hora    ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })
aAdd(aCampos,{cAls+"_LOGUSR" ,"C"      ,30           ,0            ,"LOG Usuario ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,".F."                ,'"P"'                            })


//Conforme array acima, monta array abaixo
aEstrut :=        { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO"  ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN"     ,"X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}
For x:=1 To Len(aCampos)
	If aCampos[x][1] $ cAls+"_FILIAL"+"/"+cAls+"_STATUS"
		Aadd(aSX3,{	cFMAlias01     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"???????????????   ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","N          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
	Else
		Aadd(aSX3,{	cFMAlias01     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"??????????????    ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
	EndIF
Next

	
//TABELA	HISTORICO
aCampos := {}
cAls := AllTrim(cFMAlias02)
cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)
//                 X3_CAMPO  ,X3_TIPO  ,X3_TAMANHO   ,X3_DECIMAL   ,X3_TITULO     ,X3_PICTURE            ,   X3_CBOX                        ,X3_F3         ,HELP
aAdd(aCampos,{cAls+"_FILIAL" ,"C"      ,fX3Ret("A1_FILIAL","X3_TAMANHO")            ,0            ,"Filial      ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,""                               })
aAdd(aCampos,{cAls+"_DTEMIS" ,"D"      ,8            ,0            ,"Dt Emissao  ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_DECNPJ" ,"C"      ,14           ,0            ,"CNPJ Emit.  ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_CHVNFE" ,"C"      ,44           ,0            ,"Chave       ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_PROTOC" ,"C"      ,30           ,0            ,"Protocolo   ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_MSG"    ,"C"      ,200          ,0            ,"Mensagem    ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_ARQUIV" ,"C"      ,100          ,0            ,"Arquivo     ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_MXML"   ,"M"      ,10           ,0            ,"XML         ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_LOGDT"  ,"D"      ,8            ,0            ,"LOG Data    ",""                    ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_LOGHR"  ,"C"      ,8            ,0            ,"LOG Hora    ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })
aAdd(aCampos,{cAls+"_LOGUSR" ,"C"      ,30           ,0            ,"LOG Usuario ","@!"                  ,   ""                             ,""            ,{""                                        ,""                                       ,""                                       },""                       ,""                   ,'"P"'                            })

//Conforme array acima, monta array abaixo
aEstrut :=        { "X3_ARQUIVO" ,"X3_ORDEM"   ,"X3_CAMPO"    ,"X3_TIPO"     ,"X3_TAMANHO"  ,"X3_DECIMAL"  ,"X3_TITULO"    ,"X3_TITSPA"    ,"X3_TITENG"    ,"X3_DESCRIC"   ,"X3_DESCSPA"   ,"X3_DESCENG"   ,"X3_PICTURE"         ,"X3_VALID"                              ,"X3_USADO"          ,"X3_RELACAO"  ,"X3_F3"      ,"X3_NIVEL","X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE"  ,"X3_VISUAL","X3_CONTEXT" ,"X3_OBRIGAT","X3_VLDUSER" ,"X3_CBOX"     ,"X3_CBOXSPA"  ,"X3_CBOXENG"  ,"X3_PICTVAR","X3_WHEN"     ,"X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL"}
For x:=1 To Len(aCampos)
	If aCampos[x][1] $ cAls+"_FILIAL"
		Aadd(aSX3,{	cFMAlias02     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"???????????????   ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","N          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
	Else
		Aadd(aSX3,{	cFMAlias02     ,StrZero(x,2) ,aCampos[x][1] ,aCampos[x][2] ,aCampos[x][3] ,aCampos[x][4] ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][5]  ,aCampos[x][6]        ,aCampos[x][10]                          ,"??????????????    ",aCampos[x][12],aCampos[x][8],1         ,"          ","          ","          ","P         ","S          ","A        ","R          ","          ","           ",aCampos[x][7] ,aCampos[x][7] ,aCampos[x][7] ,"          ",aCampos[x][11],"         ","         ","         ","       ","          "})
	EndIF
Next

dbSelectArea("SX3")
dbSetOrder(2)

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(aSX3[i,3])
			RecLock("SX3",.T.)
			For j:=1 To Len(aSX3[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
			lCriaPerg := .T.
		EndIf
	EndIf
Next i

//Cria Help dos campos
If lCriaPerg
	fHelpCpo(aCampos,1,9)
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fCriaSIX()
//|Autor.....: Luiz Alberto
//|Data......: 10 de setembro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fCriaSIX()
*-----------------------------------------------------------*

Local aSIX   := {}
Local aEstrut:= {}
Local cAls   := ""
Local i      := 0
Local j      := 0

aEstrut := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME"}

//------------------- PRINCIPAL -------------------
cAls := AllTrim(cFMAlias01)
cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)

aAdd(aSIX,{	cFMAlias01,"1",cAls+"_FILIAL+"+cAls+"_DECNPJ+"+cAls+"_DOC",;
"CNPJ Emit. + Nota Fiscal",;
"CNPJ Emit. + Nota Fiscal",;
"CNPJ Emit. + Nota Fiscal",;
"S","",""})

aAdd(aSIX,{	cFMAlias01,"2",cAls+"_FILIAL+"+cAls+"_DOC+"+cAls+"_SERIE",;
"Nota Fiscal + Serie",;
"Nota Fiscal + Serie",;
"Nota Fiscal + Serie",;
"S","",""})

aAdd(aSIX,{	cFMAlias01,"3",cAls+"_FILIAL+"+cAls+"_CHVNFE",;
"Chave",;
"Chave",;
"Chave",;
"S","",""})

aAdd(aSIX,{	cFMAlias01,"4",cAls+"_FILIAL+DTOS("+cAls+"_DTEMIS)+"+cAls+"_DECNPJ",;
"Dt Emissao + CNPJ Emit.",;
"Dt Emissao + CNPJ Emit.",;
"Dt Emissao + CNPJ Emit.",;
"S","",""})

//------------------- HISTORICO -------------------
cAls := AllTrim(cFMAlias02)
cAls := IIf(SubStr(cAls,1,1)=="S",SubStr(cAls,2,2),cAls)

aAdd(aSIX,{	cFMAlias02,"1",cAls+"_FILIAL+"+cAls+"_DECNPJ",;
"CNPJ Emit. ",;
"CNPJ Emit. ",;
"CNPJ Emit. ",;
"S","",""})

aAdd(aSIX,{	cFMAlias02,"2",cAls+"_FILIAL+"+cAls+"_PROTOC",;
"Protocolo",;
"Protocolo",;
"Protocolo",;
"S","",""})

aAdd(aSIX,{	cFMAlias02,"3",cAls+"_FILIAL+"+cAls+"_CHVNFE",;
"Chave",;
"Chave",;
"Chave",;
"S","",""})

aAdd(aSIX,{	cFMAlias02,"4",cAls+"_FILIAL+DTOS("+cAls+"_DTEMIS)+"+cAls+"_DECNPJ",;
"Dt Emissao + CNPJ Emit.",;
"Dt Emissao + CNPJ Emit.",;
"Dt Emissao + CNPJ Emit.",;
"S","",""})

dbSelectArea("SIX")
dbSetOrder(1)

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,1])
		If !dbSeek(aSIX[i,1]+aSIX[i,2])
			RecLock("SIX",.T.)
			For j:=1 To Len(aSIX[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fHelpCpo()
//|Autor.....: Luiz Alberto
//|Data......: 17 de janeiro de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fHelpCpo(aCampos,nPosCpo,nPosHelp)
*-----------------------------------------------------------*

Local x        := 00
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpEsp := {}

For x:=1 To Len(aCampos)
	aHelpPor := aCampos[x][nPosHelp]
	aHelpEng := aCampos[x][nPosHelp]
	aHelpEsp := aCampos[x][nPosHelp]
	PutHelp( "P"+aCampos[x][nPosCpo],aHelpPor, aHelpEng, aHelpEsp, .T. )
Next x

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNBxa()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNBxa(lEhJob)
*-----------------------------------------------------------*
Local lRet     := .T.    
Local lEmail   := GetNewPar("MV_FMXPOP",.f.)	// Parametro que Define se Baixa XML por Emails ou Nao
Private lZerosDoc  := GetNewPar("MV_XMLZDC",.f.)	// Determina se Numero da Nota com Zeros a Esquerda

Default lEhJob := .F.

If lEmail
	Processa( {|| fBaixaXML(@lRet,lEhJob)},"Baixando XML do webmail..." )
Endif

If lRet
	Processa( {|| fTrataXML(lEhJob) },"Tratando XML baixado..." )
EndIf

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fBaixaXML()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fBaixaXML(lRet,lEhJob)
*-----------------------------------------------------------*

Static __MailServer
Static __MailError
Static __MailFormatText    := .f. // Mensagem em formato Texto
Static __isConfirmMailRead := .f. // Se mensagem deve pedir confimacao de leitura

Local nMessages    :=  0

Local __cPop3      := AllTrim(SuperGetMV( "MV_FMCPOP3", , "pop.seudominio.com.br"      ))
Local __cAccount   := AllTrim(SuperGetMV( "MV_FMCMAIL", , "protheus@seudominio.com.br" ))
Local __cPswEmail  := AllTrim(SuperGetMV( "MV_FMCPASS", , "senhaemail"                 ))

Local cFrom        := ""
Local cTo          := ""
Local cCc          := ""
Local cBcc         := ""
Local cSubject     := ""
Local cBody        := ""

Local nX           :=  0
Local nY           :=  0
Local cDirIni      := AllTrim(SuperGetMv("MV_FM_DXML",,"\data\impxml\"))
Local nResp        :=  0
Default lRet       := .T.

aFileAtch := {}

//Conta quantas mensagens existem para a conta Mobiminds
If lRet
	lRet := MailPopOn(__cPop3, __cAccount, __cPswEmail, 30 )
EndIf

If lRet
	lRet := PopMsgCount(@nMessages)
EndIf	

If Type("lEhJob") <> "L"
	lEhJob := .f.
Endif

//Pergunta
If lRet .And. nMessages > 100 .And. lEhJob
	nResp     := 3
	nMessages := 50

ElseIf lRet .And. nMessages > 100
	nResp := Aviso('EMAILS','Existem '+Alltrim(Str(nMessages))+' e-mails pra baixar!'+;
						Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
						"Voc? deseja baixar:",{"Todos","Nenhum","50 e-mails"})
	Do Case
		//Nao fazer nada
		Case nResp == 1

		//Cancelar operacao
		Case nResp == 2
			lRet := .F. 

		//Baixar apenas 50 e-mails
		Case nResp == 3
			nMessages := 50

		//Cancelar operacao
		Otherwise
			lRet := .F. 
		
	EndCase
EndIf

//Carrega contador
ProcRegua(nMessages)
		
If lRet
	If nMessages > 0
		conout(" ")
		conout(Replicate("=",80))
		conout(OemtoAnsi("A conta contem "+StrZero(nMessages,3)+" mensagem(s)") ) //###
		conout(Replicate("=",80))
		
		//Recebe as mensagens e grava os arquivos XML
		For nX := 1 to nMessages

			//Processa contador
			IncProc()

			aFileAtch := {}
			cFrom     := ""
			cTo       := ""
			cCc       := ""
			cBcc      := ""
			cSubject  := ""
			cBody     := ""
			
			MailReceive(nX,,,,,,,aFileAtch,cDirIni+"pendente",GetNewPar("MV_XMLDML",.T.))
			
			For nY := 1 to Len(aFileAtch)

				If ".XML" $ Upper(aFileAtch[nY][1])
					ConOut(" ")
					ConOut(Replicate("=",80))
					ConOut("Recebido o arquivo " + aFileAtch[nY][1]) //
					ConOut(Replicate("=",80))	
				Else
					fErase(aFileAtch[nY][1])
				Endif
				
			Next nY
			
		Next nX
		
	Else
		Conout(Replicate("=",80))
		ConOut( Time()+" - Nao existem arquivos a serem recebidos" )
		Conout(Replicate("=",80))
	Endif
EndIf
	
//DISCONNECT POP SERVER
MailPopOff()

__RpcCalled := Nil

Return(lRet) 

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNFVL()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNFVL()
*-----------------------------------------------------------*
Local cTab1   := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cStatus := (cTab1)->&(cAls1+"_STATUS")
Local cChvNfe := (cTab1)->&(cAls1+"_CHVNFE")
Local cRecno  := AllTrim(Str((cTab1)->(Recno())))

If SimNao("Chave NFe: "+cChvNfe + Chr(13)+Chr(10) + "Confirma a validacao da chave novamente ?") == "S"
	Processa( {|| fValidXML(cStatus,,cRecno) },"Validando XML novamente..." )
EndIf

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNVld()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNVld()
*-----------------------------------------------------------*

Processa( {|| fValidXML("1") },"Validando todos XML (status verde)..." )
//Processa( {|| fValidXML("5") },"Validando XML tratado..." )
//Processa( {|| fValidXML("7") },"Validando XML tratado..." )

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fValidXML()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fValidXML(cOpcVer,cFileXML,cRecno)
*-----------------------------------------------------------*

Local lRet   := .T.
Local aRet   := {}
Local nReg   := 0
Local cTab1  := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1  := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local aArea  := (cTab1)->(GetArea())
Local cQuery := " SELECT *, R_E_C_N_O_ AS "+cAls1+"_RECNO FROM "+RetSqlName(cTab1)+" WHERE D_E_L_E_T_ = '' AND "+cAls1+"_STATUS IN ('"+cOpcVer+"') "
Local cVldMensag := ""
Default cFileXML := ""
Default cRecno   := ""

If !Empty(cFileXML)
	cQuery += " AND UPPER("+cAls1+"_ARQUIV) LIKE '%"+AllTrim(Upper(cFileXML))+"%' "
EndIf

If !Empty(cRecno)
	cQuery += " AND R_E_C_N_O_ = "+cRecno+" "
EndIf

//Fecha area se estiver em uso
If Select("SQL") > 0 ; SQL->(dbCloseArea()) ; Endif

//Monta area de trabalho executando a Query
TcQuery cQuery ALIAS "SQL" NEW

DbSelectArea("SQL")
SQL->(DbGoTop())
Count To nReg
ProcRegua(nReg)

SQL->(DbGoTop())
While SQL->(!Eof())
	//Inicia variavel para validar proximo registro
	lRet := .T.

	//Processa contador
	IncProc()

	//Posiciona registro
	nRecTab1 := SQL->&(cAls1+"_RECNO")

	//Verificar se CNPJ fornecedor existe no cadastro do Fornecedores ou Clientes
	//Emitende
	If lRet
		aRet := fVldCnpjEm(nRecTab1)
		lRet := aRet[1]
		If !lRet .And. aRet[2] == "SA1"
			fGravaMsg(nRecTab1,1,"4")
		EndIf
		If !lRet .And. aRet[2] == "SA2"
			fGravaMsg(nRecTab1,2,"4")
		EndIf
		If !lRet .And. Empty(aRet[2])
			fGravaMsg(nRecTab1,3,"4")
		EndIf

	EndIf

	//Verificar se CNPJ Destinatario est? cadastrado no sigamat, pois caso nao encontrado, foi uma emissao errado do fornecedor
	//Destinatario
	If lRet
		lRet := fVldCnpjDs(nRecTab1)
		If !lRet ; fGravaMsg(nRecTab1,4,"7") ; EndIf
	EndIf

	//Verificar se chave nfe nao foi importada anteriormente, nao podendo constar em outra nota de entrada
	If lRet
		lRet := fVldChvNFe(nRecTab1)
		If !lRet ; fGravaMsg(nRecTab1,5,"7") ; EndIf
	EndIf

	//Verificar se chave nfe est? ativa no sefaz, se existe e se nao foi cancelada
	If lRet
		aRet := fVldChvAtv(nRecTab1)
		lRet := aRet[1]   
		Do Case
			Case !lRet .And. aRet[2] == "101"
				fGravaMsg(nRecTab1,6,"7")

			Case !lRet .And. aRet[2] == "102"
				fGravaMsg(nRecTab1,7,"7")

			Case !lRet .And. aRet[2] $  "/103/104/105/106/107/108/109/110/111/112/"
				fGravaMsg(nRecTab1,8,"7")

			Case !lRet //Qualquer outro msg nao tratada, nao bloquear chave
				fGravaMsg(nRecTab1,98," ","ATENCAO : "+aRet[3])
				lRet := .T. //Seguir com as validacoes
			
			Case lRet .And. aRet[2] == "999"
				fGravaMsg(nRecTab1,9," ")

			Case lRet .And. aRet[2] == "100"
				cVldMensag := "Consulta Sefaz: 100 - "+AllTrim(aRet[3])
				fGravaMsg(nRecTab1,98," ",cVldMensag)

		EndCase

	EndIf

	//Se passou pelas validacoes e estava como erro ao gerar pre-nf, entao desbloqueia
	If lRet .And. SQL->&(cAls1+"_STATUS") == "4"
		fGravaMsg(nRecTab1,99,"1")
	EndIf

	//Se passou pelas validacoes e estava como pre-nf excluida, entao desbloqueia
	If lRet .And. SQL->&(cAls1+"_STATUS") == "5"
		fGravaMsg(nRecTab1,99,"1")
	EndIf

	//Se passou pelas validacoes e estava bloqueado, entao desbloqueia
	If lRet .And. SQL->&(cAls1+"_STATUS") == "7"
		fGravaMsg(nRecTab1,99,"1")
	EndIf

	SQL->(DbSkip())
End

//Fecha area se estiver em uso
If Select("SQL") > 0 ; SQL->(dbCloseArea()) ; Endif

RestArea(aArea)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldChvAtv()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fVldChvAtv(nRecTab1,nMsg)
*-----------------------------------------------------------*
Local lRet    := .F.
Local cURL    := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cMsg    := ""
Local oWS     := Nil
Local lWs     := GetNewPar("MV_FWSCONS",.f.)
Local cTab1   := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cVarPsq := ""
Local cCodEst := ""

//Posiciona no registro a ser validade
(cTab1)->(DbGoTo(nRecTab1))
cVarPsq := (cTab1)->&(cAls1+"_CHVNFE")

If lWS	// Consulta Nota pelo WebService Totvs
	//Codigo do Estado
	cCodEst := SubStr(cVarPsq,01,02)
	cCodEst := SPEDRetEst(cCodEst)
	
	//Se sem chave, entao nao precisa validar
	If Empty(cVarPsq)
		Return(.F.)
	EndIf
	
	oWs := WsNFeSBra():New()
	oWs:cUserToken := "TOTVS"
	oWs:cID_ENT    := RetIdEnti()
	oWs:cCHVNFE    := cVarPsq
	oWs:cUF        := cCodEst
	oWs:_URL       := AllTrim(cURL)+"/NFeSBRA.apw"
	
	If oWs:ConsultaChaveNFE()
		lRet := .T.
	
		//100 Autorizado o uso NF-e
		//101 Cancelamento de NF-e homologado
		//102 Inutilizacao de numero homologado
		//103 Lote recebido com sucesso
		//104 Lote processado
		//105 Lote em processamento
		//106 Lote nao localizado
		//107 Servico em Operacao
		//108 Servico Paralisado (curto prazo)
		//109 Servico Paralisado (sem previsao)
		//110 Uso Denegado
		//111 Consulta cadastro com uma ocorr?ncia
		//112 Consulta cadastro com mais de uma ocorr?ncia
		cMsgCod := AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE)
		cMsgDsc := AllTrim(oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE)
	
		If cMsgCod == "100"
			lRet := .T.
		Else
			lRet := .F.
		EndIf
	
	Else
		//Servico de consulta inoperando, nao foi possivel consultar chave
		lRet := .T.
		cMsgCod := "999"
		cMsgDsc := GetWscError(3)+" - "+GetWscError(1)
	EndIf
Else
	lRet := .T.
	cMsgCod := "999"
	cMsgDsc := 'Consulta Chave SPED Desativada, Par?metro MV_FWSCONS'
Endif
Return({lRet,cMsgCod,cMsgDsc})

//+-----------------------------------------------------------------------------------//
//|Funcao....: fGravaMsg()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGravaMsg(nRecTab1,nMsg,cSts,cTmpMsg)
*-----------------------------------------------------------*
Local cTab1    := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cTab2    := AllTrim(GetNewPar("MV_FMALS02",''))
Local cAls2    := IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)
Local cMens    := ""
Default cSts   := ""
Default cTmpMsg:= ""

//Posiciona no registro a ser validade
(cTab1)->(DbGoTo(nRecTab1))

Do Case
	Case nMsg == 1
		cMens := "CNPJ do Emitende nao est? cadastrado no sistema (SA1)"

	Case nMsg == 2
		cMens := "CNPJ do Emitende nao est? cadastrado no sistema (SA2)"

	Case nMsg == 3
		cMens := "CNPJ do Emitende nao localizado no XML"

	Case nMsg == 4
		cMens := "CNPJ do Destinat?rio nao est? cadastrada no sistema (SIGAMAT)"

	Case nMsg == 5
		cMens := "A Chave da NFe j? est? registrada no sistema (Duplicidade)"

	Case nMsg == 6
		cMens := "A Chave da NFe est? cancelada no Sefaz!"

	Case nMsg == 7
		cMens := "O numero da NFe est? inutilizada no Sefaz!"

	Case nMsg == 8
		cMens := "Servicos de consulta da NFe nao confirmou autorizacao da Chave. Verificar novamente!"

	Case nMsg == 9
		cMens := "Servicos de consulta da NFe esta inoperando. Chave nao consultada!"

	Case nMsg == 10
		cMens := "Status ajustado automaticamente, pois foi identificado que a nota j? foi incluida no sistema!"

	Case nMsg == 11
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o Status diferente de 1 impediu a operacao!"

	Case nMsg == 12
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o XML pendente de recebimento!"

	Case nMsg == 13
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o XML est? com erro de estrutura!"

	Case nMsg == 14
		cMens := "Houve uma tentativa de gerar Pre-NF dessa chave, mas o XML nao e do tipo NF!"

	Case nMsg == 15
		cMens := "Xml J? Lan?ado no Sistema - Verifique!"

	Case nMsg == 98
		cMens := cTmpMsg

	Case nMsg == 99
		cMens := "Registro foi desbloqueado, validacao OK!"

	Otherwise
		//Se mensagem nao tratada acima, sair sem fazer nada
		Return()
EndCase

//Caso seja so mensagem, nao tratar status
If !Empty(cSts)
	//Registro Corrigido
	Reclock(cTab1,.F.)
	&(cAls1+"_STATUS") := cSts
	(cTab1)->( MsUnlock() )
EndIf

//Gravar novo registro
Reclock(cTab2,.T.)
&(cAls2+"_FILIAL") := (cTab1)->(&(cAls1+"_FILIAL"))
&(cAls2+"_DTEMIS") := (cTab1)->(&(cAls1+"_DTEMIS"))
&(cAls2+"_DECNPJ") := (cTab1)->(&(cAls1+"_DECNPJ"))
&(cAls2+"_CHVNFE") := (cTab1)->(&(cAls1+"_CHVNFE"))
&(cAls2+"_PROTOC") := "VALIDACAO INTERNA"
&(cAls2+"_MSG"   ) := cMens
&(cAls2+"_ARQUIV") := ""
&(cAls2+"_MXML"  ) := ""
&(cAls2+"_LOGDT" ) := Date()
&(cAls2+"_LOGHR" ) := Time()
&(cAls2+"_LOGUSR") := __cUserID+"-"+AllTrim(UsrRetName(__cUserID))
(cTab2)->( MsUnlock() )
MsAguarde({||Inkey(2)}, "", cMens, .T.)
Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldCnpjEm()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fVldCnpjEm(nRecTab1)
*-----------------------------------------------------------*
Local lRet    := .F.
Local cTab1   := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cTipDoc := "" //"N=Normal;D=Devolucao;B=Beneficiamento;C=Complementar;A=Ajuste;U=Anulacao;S=Substituicao;X=Indefinido"
Local cTipXml := "" //"1=NF;2=CT;3=XML Pedente"
Local nCadInx := 0
Local nCadAls := ""
Local cVarPsq := ""

//Posiciona no registro a ser validade
(cTab1)->(DbGoTo(nRecTab1))
cTipDoc := (cTab1)->&(cAls1+"_TIPDOC")
cTipXml := (cTab1)->&(cAls1+"_TIPXML")
cVarPsq := (cTab1)->&(cAls1+"_DECNPJ")

Do Case
	//NFe - SA2
	Case cTipXml == "1" .And. cTipDoc $ "/N/C/A/"
		nCadInx := 3
		nCadAls := "SA2"

	//NFe - SA1
	Case cTipXml == "1" .And. cTipDoc $ "/D/B/"
		nCadInx := 3
		nCadAls := "SA1"

	//CTe - SA2
	Case cTipXml == "2" .And. cTipDoc $ "/N/C/U/S/"
		nCadInx := 3
		nCadAls := "SA2"

	//XML Pendente
	Case cTipXml == "3"
		nCadInx := 0
		nCadAls := ""

EndCase

//Verifica se CNPJ est? cadastrado
If !Empty(nCadInx) .And. !Empty(nCadAls) .And. !Empty(cVarPsq)
	(nCadAls)->(DbSetOrder(nCadInx))
	If (nCadAls)->(DbSeek(xFilial(nCadAls)+cVarPsq))
		lRet := .T.
	EndIf
EndIf

Return({lRet,nCadAls})

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldCnpjDs()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fVldCnpjDs(nRecTab1)
*-----------------------------------------------------------*

Local lRet    := .F.
Local cTab1   := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cVarPsq := ""
Local aAreaSM0:= SM0->(GetArea())

//Posiciona no registro a ser validade
(cTab1)->(DbGoTo(nRecTab1))
cVarPsq := AllTrim((cTab1)->&(cAls1+"_TOCNPJ"))

SM0->(DbGoTop())
While SM0->(!Eof()) .And. !lRet
	If cVarPsq == SM0->M0_CGC
		lRet := .T.
	EndIf
	SM0->(DbSkip())
End

RestArea(aAreaSM0)	

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVldChvNFe()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fVldChvNFe()
*-----------------------------------------------------------*
Local lRet    := .T.
Local cTab1   := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1   := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cVarPsq := ""
Local cQuerys := ""

//Posiciona no registro a ser validade
(cTab1)->(DbGoTo(nRecTab1))
cVarPsq := AllTrim((cTab1)->&(cAls1+"_CHVNFE"))

//Verifica se chave j? foi registrada!!!
cQuerys := " SELECT F1_TIPO, SF1.F1_CHVNFE, COUNT(*) QTD "
cQuerys += "   FROM "+RetSqlName("SF1")+" SF1 "
cQuerys += "  WHERE SF1.D_E_L_E_T_ = '' "
cQuerys += "    AND SF1.F1_CHVNFE = '"+cVarPsq+"' "
cQuerys += "  GROUP BY F1_TIPO, SF1.F1_CHVNFE "

If Select("TMP") <> 0 ; SQL->(dbCloseArea()) ;EndIf
TcQuery cQuerys New Alias "TMP"
TMP->(DbGoTop())

//Caso retorno maior que 0(zero) e porque nfe j? foi registrada
If TMP->(!Eof())
	Do Case
		Case TMP->QTD == 0
			lRet := .T.

		Case TMP->QTD == 1
			lRet := .T.
			//Ajusta o status
			RecLock(cTab1,.F.)
			&(cAls1+"_STATUS") := "3"
			&(cAls1+"_TIPDOC") := TMP->F1_TIPO
			(cTab1)->(MsUnLock())
			//Grava mensagem informando a alteracao do status
			fGravaMsg(nRecTab1,10," ")

		Case TMP->QTD >= 2
			lRet := .F.
	EndCase
Else
	RecLock(cTab1,.F.)
	&(cAls1+"_STATUS") := "1"
	(cTab1)->(MsUnLock())
EndIf
TMP->(dbCloseArea())

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: GXNTrt()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
User Function GXNTrt()
*-----------------------------------------------------------*

Processa( {|| fTrataXML() },"Tratando XML baixado..." )

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fTrataXML()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fTrataXML(lEhJob)
*-----------------------------------------------------------*

Local cErro      := ""
Local cAviso     := ""
Local cFile      := ""
Local cExt       := ""
Local cVar       := ""
Local cDirIni    := AllTrim(SuperGetMv("MV_FM_DXML",,"\data\impxml\"))
Local aDir     	 := Directory( cDirIni+"pendente\" + "*.*", "H" ) 
Local i
Local lValEmp    := GetNewPar("MV_FVALEMP",.f.)
Local cTab1      := GetNewPar("MV_FMALS01",'')
Local cTab2      := GetNewPar("MV_FMALS02",'')
Local cAls       := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cAls2      := IIf(SubStr(cTab2,1,1)=="S",SubStr(cTab2,2,2),cTab2)

Local cTipo      := "" 
Local cVersao    := ""
Local cCnpjE     := ""
Local cNomeE     := ""
Local cCnpjD     := ""
Local cNomeD     := ""
Local cChNFE     := ""
Local cNF        := ""
Local cSerie     := ""
Local cTotal     := ""
Local cTipoDoc   := "" 
Local cData      := ""
Local cHora      := ""
Local cProtoc    := ""
Local cTexto     := ""

Local nHdlArq    := 0  
Local xBuffer    := ""
Local lLoop      := .T.

Local cHora    := ""
Local cUF      := ""
Local cCid     := ""            

DEFAULT lEhJob := .f.

Private oXml     := NIL
Private oEvento  := Nil  
Private oRetEven := Nil

//Carrega contador
ProcRegua(Len(aDir))

For i:=1 to Len(aDir)

	//Processa contador
	IncProc('Processando Arquivo ' + AllTrim(Str(i)) + ' de ' + AllTrim(Str(Len(aDir))))
	
	cFile := AllTrim(aDir[i][1])  //nome arquivo
	oXML  := XmlParserFile( cDirIni+"pendente\"+cFile ,"_" , @cAviso,@cErro )

	//Carrega XML numa string
	nHdlArq :=FOPEN(cDirIni+"pendente\"+cFile,2+64)
	nTamArq :=FSEEK(nHdlArq,0,2)
	xBuffer :=Space(nTamArq)
	FSEEK(nHdlArq,0,0)
	FREAD(nHdlArq,@xBuffer,nTamArq)
	FCLOSE(nHdlArq)
	
	If Empty(cAviso) .AND. Empty(cErro)
		
		Do Case
			Case Type('oXML:_NFEPROC') <> "U"
				cTipo    := "NFE"
				cChNFE   := &('oXML:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT'         )
				cVersao  := &('oXML:_NFEPROC:_NFE:_INFNFE:_VERSAO:TEXT'             )
				cCnpjE   := &('oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT'         )
				cNomeE   := &('oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT'        )

				// Pessoa Fisica Pula
				
				If Type('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT') <> 'U'
					cCnpjD   := &('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT'         )
				Else
					cCnpjD:='RECUSADO'
				Endif
				cNomeD   := &('oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_XNOME:TEXT'        )
				cNF      := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT'           )
				cSerie   := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT'         )
				cTotal   := &('oXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT')
				cTipoDoc := fVTipoDoc(oXML,cTipo)
				If Type('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT') <> "U"
					cData    := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT'       )
				Else
					cData    := &('oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT'      )
				EndIf
				cProtoc  := ""
				cTexto   := ""

				cUF      := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				If Type('oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT') <> "U"
					cHora    := oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT
					cHora    := SubStr(cHora,12)
				Else
					cHora    := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT
					cHora    := SubStr(cHora,12)
				EndIf

				
			Case Type('oXML:_CTEPROC') <> "U"
				cTipo    := "CTE"
				cChNFE   := &('oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT'         )
				cVersao  := &('oXML:_CTEPROC:_CTE:_INFCTE:_VERSAO:TEXT'             )
				cCnpjE   := &('oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT'         )
				cNomeE   := &('oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT'        )
				If Type("oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT")<>"U"
					cCnpjD   := &('oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT'         )
				Else      
					cCnpjD   := 'RECUSADO'
				Endif
				cNomeD   := &('oXML:_CTEPROC:_CTE:_INFCTE:_REM:_XNOME:TEXT'        )
				cNF      := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT'           )
				cSerie   := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT'         )
				cTotal   := &('oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT'    )
				cTipoDoc := fVTipoDoc(oXML,cTipo)
				cData    := &('oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT'         )
				cProtoc  := ""
				cTexto   := ""

				cUF      := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				cHora    := oXML:_CTEPROC:_PROTCTE:_INFPROT:_DHRECBTO:TEXT
				cHora    := SubStr(cHora,12)            ?

				
			Case Type('oXML:_PROCCANCNFE') <> "U" .And. 1 > 1
				cTipo := "CAN"
				cChNFE   := &('oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_CHNFE:TEXT'     )
				cVersao  := &('oXML:_PROCCANCNFE:_CANCNFE:_VERSAO:TEXT'             )
				cCnpjE   := SubStr(cChNFE,07,14)
				cNomeE   := ""
				cCnpjD   := ""
				cNomeD   := ""
				cNF      := ""
				cSerie   := ""
				cTotal   := ""
				cTipoDoc := ""
				cData    := &('oXML:_PROCCANCNFE:_RETCANCNFE:_INFCANC:_DHRECBTO:TEXT')
				cProtoc  := &('oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_NPROT:TEXT'      )
				cTexto   := &('oXML:_PROCCANCNFE:_RETCANCNFE:_INFCANC:_XMOTIVO:TEXT' )
				cTexto   += "-"
				cTexto   += &('oXML:_PROCCANCNFE:_CANCNFE:_INFCANC:_XJUST:TEXT'      )
				cUF      := ""
				cCid     := ""
				cHora    := ""

			Case Type('oXML:_PROCEVENTONFE') <> "U"
				cTipo    := "CCE"

				oEvento  := Nil  
				oRetEven := Nil

				If Type('oXML:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO') != "U"
					oEvento  := oXML:_PROCEVENTONFE:_EVENTO:_ENVEVENTO:_EVENTO
					oRetEven := oXML:_PROCEVENTONFE:_RETEVENTO:_RETENVEVENTO:_RETEVENTO
				Else
					oEvento  := oXML:_PROCEVENTONFE:_EVENTO
					oRetEven := oXML:_PROCEVENTONFE:_RETEVENTO
				EndIf

				cChNFE   := oEvento:_INFEVENTO:_CHNFE:TEXT
				cVersao  := oXML:_PROCEVENTONFE:_VERSAO:TEXT
				cCnpjE   := SubStr(cChNFE,07,14)
				cNomeE   := ""
				cCnpjD   := ""
				cNomeD   := ""
				cNF      := ""
				cSerie   := ""
				cTotal   := ""
				cTipoDoc := ""
				cData    := oEvento:_INFEVENTO:_DHEVENTO:TEXT
				cProtoc  := oRetEven:_INFEVENTO:_NPROT:TEXT
				
				If Type('oEvento:_INFEVENTO:_DETEVENTO:_XJUST') <> "U"
					cTexto   := &('oEvento:_INFEVENTO:_DETEVENTO:_DESCEVENTO:TEXT')
					If "CANCELAMENTO" $ Upper(cTexto)
						cTipo := "CAN"
					EndIf
					cTexto   += "-"
					cTexto   += &('oEvento:_INFEVENTO:_DETEVENTO:_XJUST:TEXT')
				Else
					cTexto   := &('oEvento:_INFEVENTO:_DETEVENTO:_XCORRECAO:TEXT')
				EndIf
				cUF      := ""
				cCid     := ""
				cHora    := ""

			Otherwise
				cTipo := "XXX"

		EndCase
	
		lOk := .f.
		If !Empty(cCnpjD)	// CNPJ Destinatario 
			nReg := SM0->(Recno())
			SM0->(dbGoTop())
			While SM0->(!Eof())
				If lValEmp .And. AllTrim(SM0->M0_CGC)$AllTrim(cCnpjD)
					lOk := .t.
					Exit         
				Else                
					If lValEmp
						lOk := .F.
					Else
						lOk := .t.
					Endif
					Exit
				Endif
				
				SM0->(dbSkip(1))
			Enddo
			SM0->(dbGoTo(nReg))
		Endif                
		
		If !lOk .And. Type('oXML:_PROCEVENTONFE') == "U" .Or. cCnpjD=='RECUSADO'
			If !lEhJob                                        
				MsAguarde({||Inkey(2)}, "", "Atencao o XML " + cFile + " Nao Pertence ? Empresa como Destinatario ! Arquivo Movido Para Pasta Recusados !", .T.)
			Endif

			//move o arquivo de pasta 
			MontaDir(cDirIni+"recusado\")
			fRename(cDirIni+"pendente\"+cFile,cDirIni+"recusado\"+cFile)
			Loop
		Endif				


		cData  := StrTran(Substr(cData,1,10),"-","")
		cMes   := Substr(cData,5,2)
		cAno   := Substr(cData,1,4)

		//cria os diretorios
		MontaDir(cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\")

		//Tratamento pra mover arquivos com o nome duplicado
		If File(cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\"+cFile)
			lLoop := .T.
			cSeq  := "001"
			While lLoop
				cNewFile := SubStr(cFile,1,Rat(".XML",cFile)-1)+"-"+cSeq+".XML"
				If File(cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\"+cNewFile)
					cSeq  := Soma1(cSeq)
				Else
					lLoop := .F.
				EndIf
			End
		Else
			cNewFile := cFile
		EndIf

		//move o arquivo de pasta
		fRename(cDirIni+"pendente\"+cFile,cDirIni+"processado\"+cCnpjE+"\"+cAno+"\"+cMes+"\"+cNewFile)

		ConOut(" ")
		ConOut(Replicate("=",80))
		ConOut("Recebido o arquivo " + cDirIni+"pendente\"+cNewFile)
		ConOut(Replicate("=",80))

		//Grava registro na tabela principal apenas se for NF ou CT
		//Demais XML deve ser localizado a chave principal e gravar em mensagens do XML principal (Cancelamento, Carta de Correcao e duplicidades de XML)
		Do Case

			//Grava em Mensagens - Extrutura do XML nao identificado
			Case cTipo == "XXX"

			//Grava em Mensagens - Carta de Correcao ou Cancelamento
			Case cTipo $ "/CCE/CAN/" .And. !Empty(cChNFE)

				//Verifica se existe chave na tabela principal e caso nao exista, gravar um breve cadastro com _STATUS == 0 e TIPXML == 3 
				//Caso exista, gravar flag dizendo que tem carta de correcao ou NFe foi cancelada
				(cTab1)->(DbSetOrder(3))
				If (cTab1)->( DbSeek(xFilial(cTab1)+cChNFE) )
					Reclock(cTab1,.F.)

					//Ajusta valores conforme tipo do XML
					If cTipo == "CCE" ; &(cAls+"_TEMCCE") := "S" ; EndIf
					If cTipo == "CAN" ; &(cAls+"_STATUS") := "6" ; EndIf

					(cTab1)->( MsUnlock() )
				Else
					Reclock(cTab1,.T.)

					&(cAls+"_FILIAL") := xFilial(cTab1)
					&(cAls+"_STATUS") := "0"                       //(0=XML Pendente de recebimento)
					&(cAls+"_TEMCCE") := "N"                       //(N=Nao)
					&(cAls+"_TIPDOC") := "X"                       //(N=Normal;D=Devolucao;B=Benefic.;X=Desconhecido)
					&(cAls+"_TIPXML") := "3"                       //(1=NF / 2=CT / 3=XML Pedente)
					&(cAls+"_DECNPJ") := cCnpjE
					&(cAls+"_CHVNFE") := cChNFE
					&(cAls+"_ARQUIV") := cNewFile
					&(cAls+"_LOGDT")  := Date()
					&(cAls+"_LOGHR")  := Time()
					&(cAls+"_LOGUSR") := __cUserID+"-"+AllTrim(UsrRetName(__cUserID))

					//Ajusta valores conforme tipo do XML
					If cTipo == "CCE" ; &(cAls+"_TEMCCE") := "S" ; EndIf
					If cTipo == "CAN" ; &(cAls+"_STATUS") := "6" ; EndIf

					(cTab1)->( MsUnlock() )
				EndIf

				//Independente se XML ja foi recebido ou nao, gravar novo registro
				Reclock(cTab2,.T.)
				&(cAls2+"_FILIAL") := xFilial(cTab2) 
				&(cAls2+"_DTEMIS") := StoD(cData)
				&(cAls2+"_HREMIS") := cHora
				&(cAls2+"_DECNPJ") := cCnpjE
				&(cAls2+"_CHVNFE") := cChNFE
				&(cAls2+"_PROTOC") := cProtoc
				&(cAls2+"_MSG"   ) := cTexto
				&(cAls2+"_ARQUIV") := cNewFile
				&(cAls2+"_MXML"  ) := xBuffer
				&(cAls2+"_LOGDT" ) := Date()
				&(cAls2+"_LOGHR" ) := Time()
				&(cAls2+"_LOGUSR") := __cUserID+"-"+AllTrim(UsrRetName(__cUserID)) 
				(cTab2)->( MsUnlock() )
				
			//Grava Chave Principal
			Case cTipo $ "/NFE/CTE/" .And. !Empty(cChNFE) .And. !Empty(cNF)

				lGravaReg := .F.

				//Verifica se chave j? existe
				(cTab1)->(DbSetOrder(3))
				If (cTab1)->(DbSeek(xFilial(cTab1)+cChNFE))
					//Verifica se deve atualizar informacoes da tabela principal
					//Somente se for tipo 3
					If (cTab1)->(&(cAls+"_TIPXML")) == "3"
						lGravaReg := .T.
						Reclock(cTab1,.F.)
						&(cAls+"_STATUS") := IIf(&(cAls+"_STATUS")=="0","1",&(cAls+"_STATUS"))
					Else
						//Gravar mensagem que XML chegou em duplicidade
					EndIf
				Else
					lGravaReg := .T.
					Reclock(cTab1,.T.)
					&(cAls+"_TEMCCE") := "N" //Definir como N somente na inclusao
					&(cAls+"_STATUS") := "1" //1=XML Recebido com sucesso
				EndIf

				//Grava informacoes na tabela
				If lGravaReg
					&(cAls+"_FILIAL") := xFilial(cTab1)
					&(cAls+"_TIPDOC") := cTipoDoc
					&(cAls+"_TIPXML") := IIf(cTipo=="NFE","1","2") //(1=NF / 2=CT)
					&(cAls+"_SERIE" ) := StrZero(Val(cSerie),3)
					&(cAls+"_DOC"   ) := Iif(lZerosDoc,PadL(cNF,9,'0'),PadR(cNF,9))
					&(cAls+"_DTEMIS") := StoD(cData)
					&(cAls+"_HREMIS") := cHora
					&(cAls+"_DEUF"  ) := cUF
					&(cAls+"_DECIDAD"):= cCid
					&(cAls+"_DECNPJ") := cCnpjE
					&(cAls+"_DENOME") := cNomeE
					&(cAls+"_TOCNPJ") := cCnpjD
					&(cAls+"_TONOME") := cNomeD
					&(cAls+"_VLRTOT") := Val(cTotal)
					&(cAls+"_CHVNFE") := cChNFE
					&(cAls+"_ARQUIV") := cNewFile
					&(cAls+"_MXML"  ) := IIf(Len(xBuffer)>65530,SubStr(xBuffer,1    ,65530       ),xBuffer)
					&(cAls+"_MXML2" ) := IIf(Len(xBuffer)>65530,SubStr(xBuffer,65531,Len(xBuffer)),""     )
					&(cAls+"_LOGDT" ) := Date()
					&(cAls+"_LOGHR" ) := Time()
					&(cAls+"_LOGUSR") := __cUserID+"-"+AllTrim(UsrRetName(__cUserID))
					(cTab1)->( MsUnlock() )
				EndIf
				cVldSts := (cTab1)->(&(cAls+"_STATUS"))
				cVldRec := AllTrim(Str((cTab1)->(Recno())))
				fValidXML(cVldSts,,cVldRec)
		EndCase
		cAviso := ""
		cErro  := ""
	Else
		//AQUI - Mover XML pra uma pasta onde ficarao os XML com erro de estrutura
		Conout(Replicate("=",80))
		ConOut( cAviso+" - "+cErro )
		Conout(Replicate("=",80))
		cAviso := ""
		cErro  := ""
	EndIf
Next i

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fVTipoDoc()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fVTipoDoc(oXML,cTipoXML)
*-----------------------------------------------------------*
Local cRet    := ""
Local oDet    := Nil
Local oIde    := Nil
Local lDetOk  := .F.
Local lIdeOk  := .F.
Local cCFOP_B := AllTrim(SuperGetMV( "MV_FMNFBEN", , "1901/1920/1916/1949" )) //Beneficiamento
Local cCFOP_D := AllTrim(SuperGetMV( "MV_FMNFDEV", , "1201/2201/1202/2202" )) //Devolucao
Local cCFOP_C := AllTrim(SuperGetMV( "MV_FMNFCOM", , "1352/3101/3102/3551" )) //Complemento
Local cXXCF_B := "901/920"                                                    //Beneficiamento
Local cXXCF_D := "201/202"                                                    //Devolucao

//finNFe Finalidade de emissao da NF-e
//1=Normal(N); 
//2=Complementar(C); 
//3=Ajuste(A); 
//4=Devolucao(D)/Beneficiamento(B)

//tpCTe Finalidade de emissao da CT-e
//0=Normal(N)
//1=Complemento(C)
//2=Anulacao(U)
//3=Substituicao(S)

Private oNF  := oXML

Do Case
	Case cTipoXML == "CTE"
		lIdeOk := .F.

		If !lIdeOk .And. Type("oNF:_CTeProc:_CTe:_InfCTe:_IDE:_TpCTe") != "U"
			oIde := oNF:_CTeProc:_CTe:_InfCTe:_IDE:_TpCTe
			lIdeOk := .T.
		EndIf

		//Normal
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "0"
			cRet := "N"
		EndIf		

		//Complementar
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "1"
			cRet := "C"
		EndIf		

		//Anulacao
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "2"
			cRet := "U"
		EndIf		

		//Substituicao
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "3"
			cRet := "S"
		EndIf		

		If Empty(cRet)
			cRet := "X"
		EndIf
		
	Case cTipoXML == "NFE"
		lIdeOk := .F.
		lDetOk := .F.

		If !lIdeOk .And. Type("oNF:_NfeProc:_Nfe:_InfNfe:_IDE:_finNFe") != "U"
			oIde := oNF:_NfeProc:_Nfe:_InfNfe:_Ide:_finNFe
			lIdeOk := .T.
		EndIf

		If !lDetOk .And. Type("oNF:_NfeProc:_Nfe:_InfNfe:_Det") == "A"
			oDet := oNF:_NfeProc:_Nfe:_InfNfe:_Det
			lDetOk := .T.
		EndIf

		If !lDetOk .And. Type("oNF:_NfeProc:_Nfe:_InfNfe:_Det") == "O"
			oDet := {oNF:_NfeProc:_Nfe:_InfNfe:_Det}
			lDetOk := .T.
		EndIf

		//Verifica CFOP caso parametro preenchido
		If Empty(cRet) .And. lDetOk
			//Verifica o tipo da nota fiscal
			For x:=1 To Len(oDet)

				//Beneficiamento
				If Empty(cRet) .And. AllTrim(oDet[x]:_Prod:_CFOP:TEXT) $ cCFOP_B .And. !Empty(cCFOP_B)
					cRet := "B"
					x := Len(oDet)
				EndIf
				
				//Devolucao
				If Empty(cRet) .And. AllTrim(oDet[x]:_Prod:_CFOP:TEXT) $ cCFOP_D .And. !Empty(cCFOP_D)
					cRet := "D"
					x := Len(oDet)
				EndIf

				//Complemento
				If Empty(cRet) .And. AllTrim(oDet[x]:_Prod:_CFOP:TEXT) $ cCFOP_C .And. !Empty(cCFOP_C)
					cRet := "C"
					x := Len(oDet)
				EndIf

			Next x
		EndIf

		//Normal
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "1"
			cRet := "N"
		EndIf		

		//Complementar
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "2"
			cRet := "C"
		EndIf		

		//Ajuste
		If Empty(cRet) .And. lIdeOk .And. AllTrim(oIde:Text) == "3"
			cRet := "A"
		EndIf		

		//Devolucao / Beneficiamento
		If Empty(cRet) .And. lDetOk //.And. lIdeOk .And. AllTrim(oIde:Text) $ " 4" 

			//Verifica o tipo da nota fiscal
			For x:=1 To Len(oDet)
				//Beneficiamento
				If Empty(cRet) .And. SubStr(AllTrim(oDet[x]:_Prod:_CFOP:TEXT),2,3) $ cXXCF_B
					cRet := "B"
					x := Len(oDet)
				EndIf
				
				//Devolucao
				If Empty(cRet) .And. SubStr(AllTrim(oDet[x]:_Prod:_CFOP:TEXT),2,3) $ cXXCF_D
					cRet := "D"
					x := Len(oDet)
				EndIf
			Next x

		EndIf		

		//Normal
		If Empty(cRet) .And. lIdeOk .And. !Empty(oIde:Text)
			cRet := "N"
		EndIf		

		If Empty(cRet)
			cRet := "X"
		EndIf
		
	Otherwise
		
EndCase

Return(cRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: MailReceive()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function MailReceive(anMsgNumber, acFrom, acTo, acCc, acBcc, acSubject, acBody, aaFiles, acPath, alDelete, alUseTLSMail, alUseSSLMail)
*-----------------------------------------------------------*

local oMessage
local nInd
local nCount
local cFilename
local aAttInfo

default acFrom := ""
default acTo := ""
default acCc := ""
default acBcc := ""
default acSubject := ""
default acBody := ""
default acPath  := ""
default alDelete := .f.
default aaFiles := { }
default alUseTLSMail := .f.
default alUseSSLMail := .f.

oMessage := TMailMessage():New()
oMessage:Clear()
__MailError := oMessage:Receive(__MailServer, anMsgNumber)
if __MailError == 0
	acFrom := oMessage:cFrom
	acTo := oMessage:cTo
	acCc := oMessage:cCc
	acBcc := oMessage:cBcc
	acSubject := oMessage:cSubject
	acBody := oMessage:cBody
	
	nCount := 0
	for nInd := 1 to oMessage:getAttachCount()
		aAttInfo := oMessage:getAttachInfo(nInd)
		//Somente arquivo .XML
		If ".XML" $ Upper(aAttInfo[1])
			if empty(aAttInfo[1])
				aAttInfo[1] := "ATT.DAT"
			endif
			cFilename := acPath + "\" + aAttInfo[1]
			while file(cFilename)
				nCount++
				cFilename := acPath + "\" + substr(aAttInfo[1], 1, at(".", aAttInfo[1]) - 1) + strZero(nCount, 3) +;
				substr(aAttInfo[1], at(".", aAttInfo[1]))
			enddo
			nHandle := FCreate(cFilename)
			if nHandle == 0
				__MailError := 2000
				return .f.
			endif
			FWrite(nHandle, oMessage:getAttach(nInd))
			FClose(nHandle)
			aAdd(aaFiles, { cFilename, aAttInfo[2]})
		EndIf
	Next nInd
	
	if alDelete
		__MailServer:DeleteMsg(anMsgNumber)
	endif
endif

return( __MailError == 0 )

//+-----------------------------------------------------------------------------------//
//|Funcao....: MailPopOn()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function MailPopOn(cServer,cUser,cPassword,nTimeOut)
*-----------------------------------------------------------*

Default nTimeOut := 30

__MailError	 := 0
if valType(__MailServer) == "U"
	__MailServer := TMailManager():New()
endif

__MailServer:Init(cServer, '', cUSer, cPassword )
__MailError	:= __MailServer:SetPopTimeOut( nTimeOut )
__MailError := __MailServer:PopConnect( )

Return( __MailError == 0 )

//+-----------------------------------------------------------------------------------//
//|Funcao....: MailPopOff()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function MailPopOff()
*-----------------------------------------------------------*

__MailError := __MailServer:PopDisconnect()

Return( __MailError == 0 )


//+-----------------------------------------------------------------------------------//
//|Funcao....: PopMsgCount()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static function PopMsgCount(nMsgCount)
*-----------------------------------------------------------*

nMsgCount := 0
__MailError := __MailServer:GetNumMsgs(@nMsgCount)

Return( __MailError == 0 )

//+-----------------------------------------------------------------------------------//
//|Funcao....: fWfGerXml()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fWfGerXml(cTitulo, cAssunto, cMsg)
*-----------------------------------------------------------*
Local cToMail := AllTrim(SuperGetMV( "MV_FM_MAIL", , "lalberto@3lsystems.com.br;"              )) //E-mail dos usu?rios que serao notificados quando uma NF for gerada
Local cToFull := ""
Local cAttach   := ""
Local aMsg      := {}
Local aUsrMail := {}
Local lConectou := .f.
LOCAL cACCOUNT := alltrim(getmv("MV_RELACNT"))
LOCAL cPASSWORD := alltrim(getmv("MV_RELPSW"))
LOCAL cSERVER   := alltrim(getmv("MV_RELSERV"))
Local lAutentic := getmv("MV_RELAUTH")
	
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConectou
	
//?????????????????????????????????????????????????????????????????????Ŀ
//? Requer autenticacao													?
//???????????????????????????????????????????????????????????????????????
If lAutentic
	MAILAUTh(cAccount,cPassword)
Endif

SEND MAIL FROM cACCOUNT TO cToMail SUBJECT cAssunto BODY cMsg RESULT lEnviado

If !lEnviado
	cMensagem := ""
	GET MAIL ERROR cMensagem
	Alert(cMensagem)
Endif
DISCONNECT SMTP SERVER Result lDesConectou
Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fWfGerXml()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fAjustTipo()
*-----------------------------------------------------------*

Local cTab1    := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local aArea    := (cTab1)->(GetArea())
Local nRecno   := 0
Local cTipoDoc := ""
Local cQuery   := " SELECT R_E_C_N_O_ AS "+cAls1+"_RECNO FROM "+RetSqlName(cTab1)+" WHERE D_E_L_E_T_ = '' AND "+cAls1+"_STATUS != '3' "
Private oXML   := Nil

//Fecha area se estiver em uso
If Select("SQL") > 0 ; SQL->(dbCloseArea()) ; Endif

//Monta area de trabalho executando a Query
TcQuery cQuery ALIAS "SQL" NEW

DbSelectArea("SQL")
SQL->(DbGoTop())
Count To nReg
ProcRegua(nReg)

SQL->(DbGoTop())
While SQL->(!Eof())

	//Processa contador
	IncProc()

	//Posiciona no registro
	nRecno := SQL->&(cAls1+"_RECNO")
	(cTab1)->(DbGoTo(nRecno))

	//Prepara String XML para tornar em Objeto
	cMmXml   := ""
	cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML" ))
	cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML2"))
	
	cAviso   := ""
	cErro    := ""
	oXML     := Nil
	oXML     := XmlParser(cMmXml,"_",@cAviso,@cErro)
	
	If Type('oXML:_NFEPROC') <> "U"
		cTipoDoc := ""
		cTipoDoc := fVTipoDoc(oXML,"NFE")

		If !Empty(cTipoDoc)
			Reclock(cTab1,.F.)
			&(cAls1+"_TIPDOC") := cTipoDoc
			(cTab1)->( MsUnlock() )
		EndIf
	EndIf

	SQL->(DbSkip())
End

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: fAjustHrUF()
//|Autor.....: Luiz Alberto
//|Data......: janeiro/fevereiro/marco de 2014, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fAjustHrUF()
*-----------------------------------------------------------*

Local cTab1    := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1    := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local aArea    := (cTab1)->(GetArea())
Local nRecno   := 0
Local cTipo    := ""
Local cHora    := ""
Local cUF      := ""
Local cCid     := ""
Local cQuery   := " SELECT R_E_C_N_O_ AS "+cAls1+"_RECNO FROM "+RetSqlName(cTab1)+" WHERE D_E_L_E_T_ = '' AND "+cAls1+"_DEUF = '' "
Private oXML   := Nil

//Fecha area se estiver em uso
If Select("SQL") > 0 ; SQL->(dbCloseArea()) ; Endif

//Monta area de trabalho executando a Query
TcQuery cQuery ALIAS "SQL" NEW

DbSelectArea("SQL")
SQL->(DbGoTop())
Count To nReg
ProcRegua(nReg)

SQL->(DbGoTop())
While SQL->(!Eof())

	//Processa contador
	IncProc()

	//Limpa variaveis
	cTipo    := ""
	cHora    := ""
	cUF      := ""
	cCid     := ""

	//Posiciona no registro
	nRecno := SQL->&(cAls1+"_RECNO")
	(cTab1)->(DbGoTo(nRecno))

	//Prepara String XML para tornar em Objeto
	cMmXml   := ""
	cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML" ))
	cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML2"))
	
	cAviso   := ""
	cErro    := ""
	oXML     := Nil
	oXML     := XmlParser(cMmXml,"_",@cAviso,@cErro)
	
	If Empty(cAviso) .AND. Empty(cErro)
		Do Case
			Case Type('oXML:_NFEPROC') <> "U"
				cTipo    := "NFE"
				cUF      := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				If Type('oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT') <> "U"
					cData    := oXML:_NFEPROC:_PROTNFE:_INFPROT:_DHRECBTO:TEXT
					cHora    := SubStr(cData,12)
				Else
					cData    := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT
					cHora    := SubStr(cData,12)
				EndIf
				
			Case Type('oXML:_CTEPROC') <> "U"
				cTipo    := "CTE"
				cUF      := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
				cCid     := oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_XMUN:TEXT
				cData    := oXML:_CTEPROC:_PROTCTE:_INFPROT:_DHRECBTO:TEXT
				cHora    := SubStr(cData,12)
				
			Case Type('oXML:_PROCCANCNFE') <> "U"
				cTipo := "CAN"
				cUF      := ""
				cCid     := ""
				cData    := oXML:_PROCCANCNFE:_RETCANCNFE:_INFCANC:_DHRECBTO:TEXT
				cHora    := ""

			Case Type('oXML:_PROCEVENTONFE') <> "U"
				cTipo    := "CCE"
				cUF      := ""
				cCid     := ""
				cData    := oEvento:_INFEVENTO:_DHEVENTO:TEXT
				cHora    := ""
				
			Otherwise
				cTipo := "XXX"

		EndCase

		If (cTipo $ "NFE/CTE")
			Reclock(cTab1,.F.)
			&(cAls1+"_HREMIS ") := cHora
			&(cAls1+"_DEUF   ") := cUF
			&(cAls1+"_DECIDAD") := cCid
			(cTab1)->( MsUnlock() )
		EndIf

    EndIf

	SQL->(DbSkip())
End

Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: fGerVldCTe()
//|Autor.....: Luiz Alberto
//|Data......: 15 de Junho de 2016, 09:00
//|Descricao.: Gerenciador dos XML's das NFe da Entrada
//|Observacao: 
//+-----------------------------------------------------------------------------------//
*-----------------------------------------------------------*
Static Function fGerVldCte(nRecTab1,oXmlTab1)
*-----------------------------------------------------------*

Local x         :=  0
Local lProc     := .T.
Local cTagPC    := AllTrim(SuperGetMv("MV_FMTAGPC",,"S"))
Local cTab1     := AllTrim(GetNewPar("MV_FMALS01",''))
Local cAls1     := IIf(SubStr(cTab1,1,1)=="S",SubStr(cTab1,2,2),cTab1)
Local cAviso    := ""
Local cErro     := ""
Local cMmXml    := ""
Local lEhFornec := .F.
Local cCodCliFor:= ""
Local cLojCliFor:= ""
Local cNomCliFor:= ""
Local cCndCliFor:= ""
Local cCodProdut:= ""
Local aCabec    := {}
Local aItens    := {}
Local aUnidMed  := {}
Local aPrdDesc  := {}

Local cMsgErro  := ""
Local cMsErro2  := ""
Local cMsgNota  := ""
Local cMsgAssu  := ""
Local cMsgFoCl  := ""

Local cCpoUmXml := ""
Local cCpoFCNum := ""
Local cCpoFCTip := ""
Local lFatorCnv := .F.

Local nCadFatCon:= 0
Local cCadTipCon:= ""
Local cOperConv := ""
Local nQtdProd  := 0
Local lValEmp    := GetNewPar("MV_FVALEMP",.f.)

Private oNFe    := Nil
Private oNF     := Nil
Private oItens  := Nil
Private oItemTemp := Nil
Private aGXNPE001 := Nil

//Posiciona no registro correto
(cTab1)->(DbGoTo(nRecTab1))

//Valida Status, pois so pode executar se STATUS == 1
If lProc .And. (cTab1)->&(cAls1+"_STATUS") != "1"
	If (cTab1)->&(cAls1+"_STATUS") <> "1"	//? Erro na Tentativa de Importacao Anterior
		If !MsgYesNo("Deseja Efetuar Nova Tentativa de Importacao do Xml que Apresentou Erro ?")	
			fGravaMsg(nRecTab1,11," ")
			lProc := .F.
		Endif
	Else
		fGravaMsg(nRecTab1,11," ")
		lProc := .F.
	Endif
EndIf

//Valida se XML e do tipo NF
If lProc .And. (!(cTab1)->&(cAls1+"_TIPDOC") $ "N/C/D/B" )
	fGravaMsg(nRecTab1,14,"4")
	lProc := .F.
EndIf

//Valida se XML e do tipo NF
If lProc .And. (!(cTab1)->&(cAls1+"_TIPXML") $ "2" )
	fGravaMsg(nRecTab1,14,"4")
	lProc := .F.
EndIf

//Prepara String XML para tornar em Objeto
If lProc
	cMmXml   := ""
	cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML" ))
	cMmXml   += AllTrim((cTab1)->&(cAls1+"_MXML2"))
	//cMmXml   := EncodeUTF8(cMmXml)
	If Empty(cMmXml)
		//XML pendente de recebimento ( Status = 0 )
		lProc := .F.
		fGravaMsg(nRecTab1,12,"0")
	EndIf
EndIf

//Converte String XML em Objeto XML
If lProc
	cAviso   := ""
	cErro    := ""
	oXmlTab1 := Nil
	oXmlTab1 := XmlParser(cMmXml,"_",@cAviso,@cErro)
	Do Case
		Case !Empty(cErro)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.
			
		Case !Empty(cAviso)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.
			
		Case Empty(oXmlTab1)
			//XML com erro de estrutura ( Status = 2 )
			fGravaMsg(nRecTab1,13,"2")
			lProc := .F.

		OtherWise

			//Prepara Objeto pra receber XML
			oCTe := oXmlTab1
			If Type("oCTE:_CTE") <> "U"
				oCT := oCTE:_CTE:_INFCTE
			Else
				oCT  := oCTE:_CTEPROC:_CTE
				oCTE := oCTE:_CTEPROC
			Endif

			cCNPJ  := ""
			cDoc   := ""
			cSerie := ""
			cCod   := ""
			cLoja  := ""
			cNom   := ""
			_Tipo  := ""
			_Mod   := "CTE"
			_cData := ""
			_dData := ""
			
			If Type("oCTE:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT") <> "U"
				IF oCTE:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT = "0"
					oDados := oCTE:_CTE:_INFCTE:_REM
				ElseIf oCTE:_CTE:_INFCTE:_IDE:_TOMA3:_TOMA:TEXT = "3"
					oDados := oCTE:_CTE:_INFCTE:_REM
				Endif
			ElseIf Type("oCTE:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT") <> "U"
				IF oCTE:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT = "0"
					oDados := oCTE:_CTE:_INFCTE:_REM
				ElseIf oCTE:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT = "3"
					oDados := oCTE:_CTE:_INFCTE:_REM
				Endif
			ElseIF Type("oCTE:_CTE:_INFCTE:_IDE:_TOMA4:_TOMA:TEXT") <> "U"
				oDados := oCTE:_CTE:_INFCTE:_IDE:_TOMA4
			Else
				Alert("Erro Na Leitura do Arquivo Erro: Sem Tomador 3 e 4 ")
				Return .f.
			Endif
			//// Caso o CNPJ nao for da filial ativa nao carrega a nota.
			If SM0->M0_CGC = Iif(Type("oDados:_CNPJ:TEXT")<>"U",oDados:_CNPJ:TEXT,oDados:_CPF:TEXT) .Or. !lValEmp
				cCNPJ  := oCTE:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT
				cDoc   := Iif(lZerosDoc,PADL(ALLTRIM(oCTE:_CTE:_INFCTE:_IDE:_NCT:TEXT),9,'0'),PADR(ALLTRIM(oCTE:_CTE:_INFCTE:_IDE:_NCT:TEXT),9)) //Nro da Nota
				cSerie := PADR(oCTE:_CTE:_INFCTE:_IDE:_SERIE:TEXT,3)
				_cData := SUBSTR(oCTE:_CTE:_INFCTE:_IDE:_DHEMI:TEXT,9,2)+SUBSTR(oCTE:_CTE:_INFCTE:_IDE:_DHEMI:TEXT,6,2)+SUBSTR(oCTE:_CTE:_INFCTE:_IDE:_DHEMI:TEXT,1,4)
				_dData := ALLTRIM(SUBSTR(_cData,1,2)+'/'+Substr(_cData,3,2)+'/'+SUBSTR(_cData,5,4))
				
				//// VerIFica se o CNPJ e de Fornecedor ou de Cliente
				lEhFornec  := .F.
				If SA2->(dbSetOrder(3), dbSeek(xFilial("SA2")+cCNPJ))
					lEhFornec  := .T.
					//// VerIFica se a Nota j? existe
					If SF1->(dbSetOrder(1), dbSeek(xFilial("SF1")+cDoc+cSerie+SA2->A2_COD+SA2->A2_LOJA))
						fGravaMsg(nRecTab1,15,"3")
						lProc := .F.
					Else 
						lProc := .t.
						cCod  := SA2->A2_COD
						cLoja := SA2->A2_LOJA
						cNom  := SA2->A2_NREDUZ
						_Tipo := "F"
					Endif
				ElseIf SA1->(dbSetOrder(3), dbSeek(xFilial("SA1")+cCNPJ))
					If SF1->(dbSetOrder(1), dbSeek(xFilial("SF1")+cDoc+cSerie+SA1->A1_COD+SA1->A1_LOJA))
						fGravaMsg(nRecTab1,15,"3")
						lProc := .F.
					Else
						lProc := .t.
						cCod  := SA1->A1_COD
						cLoja := SA1->A1_LOJA
						cNom  := SA1->A1_NREDUZ
						_Tipo := "C"
					Endif
				Endif
			Endif
	EndCase
EndIf

//Verifica se produtos do XML estao cadastrados na tabela de relacionamento
If lProc
	aUnidMed  := {}
	aPrdDesc  := {}
	cCodProdut :=  GetNewPar("MV_XCTPRD",'FRETE')
	cTesProdut :=  GetNewPar("MV_XCTTES",'053')
	cCntProdut :=  GetNewPar("MV_XCTCNT",'42214001')
	cCusProdut :=  GetNewPar("MV_XCTCUS",'2.011.02')
	cNaturez   :=  GetNewPar("MV_XCTNAT",'202005')
	cCondPag   :=  GetNewPar("MV_XCTPAG",'251')
	
	lProc 	:=	 .t.
	If Empty(cCodProdut)
		lVldProdut := .F.
		cVldMensag := "O produto ("+cCodProdut+") Nao Foi Configurado !"
		fGravaMsg(nRecTab1,98," ",cVldMensag)
		lProc	:=	.f.
	Endif

	If lProc .And. !SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+cCodProdut))
		lVldProdut := .F.
		cVldMensag := "O produto ("+cCodProdut+") Nao Localizado No Cadastro !"
		fGravaMsg(nRecTab1,98," ",cVldMensag)
		lProc	:=	.f.
	Endif

	aAux := {}
	aItens := {}
	If lProc
		If Type("oCTE:_CTEPROC") = "O"
			oCT := oCTE:_CTEPROC:_CTE:_INFCTE
			//// Pega a Chave
			oChaveNFE := oCTE:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT
		ElseIf Type("oCTE:_CTE:_INFCTE") = "O"
			oCT := oCTE:_CTE:_INFCTE
			oChaveNFE := SUBSTR(oCTE:_CTE:_SIGNATURE:_SIGNEDINFO:_REFERENCE:_URI:TEXT,5,48)
		ENDIF

		//// Pega o CFOP do Produto
		_CFOP := oCT:_IDE:_CFOP:TEXT
		If Left(ALLTRIM(_CFOP),1) = "5"
			_CFOP := "1"+SUBSTR(ALLTRIM(_CFOP),2,3)
		ElseIf Left(ALLTRIM(_CFOP),1) = "6"
			_CFOP := "2"+SUBSTR(ALLTRIM(_CFOP),2,3)
		ElseIf Left(ALLTRIM(_CFOP),1) = "7"
			_CFOP := "3"+SUBSTR(ALLTRIM(_CFOP),2,3)
		Endif
		
		cData := SUBSTR(oCT:_IDE:_DHEMI:TEXT,9,2)+SUBSTR(oCT:_IDE:_DHEMI:TEXT,6,2)+SUBSTR(oCT:_IDE:_DHEMI:TEXT,1,4)
		dData := CTOD(SUBSTR(cData,1,2)+'/'+Substr(cData,3,2)+'/'+SUBSTR(cData,5,4))
		
		cNfOri := ''
		If Type("oCT:_infCTeNorm:_infDoc:_infNF") = "O"
			cNfOri := oCT:_infCTeNorm:_infDoc:_infNF:_NDOC:TEXT
		Else
			If Type("oCT:_infCTeNorm:_infDoc:_infNFe") <> "A"
				cNfOri := substr(oCT:_infCTeNorm:_infDoc:_infNFe:_chave:text,26,9) +"-"+substr(oCT:_infCTeNorm:_infDoc:_infNFe:_chave:text,35,1)
			Else
				For nI := 1 To Len(oCT:_infCTeNorm:_infDoc:_infNFe)
					cNfOri := cNfOri += " "+SUBSTR(oCT:_infCTeNorm:_infDoc:_infNFe[nI]:_CHAVE:TEXT,26,9)+"-"+SUBSTR(oCT:_infCTeNorm:_infDoc:_infNFe[nI]:_CHAVE:TEXT,35,1)
				Next
			Endif
		Endif

		//// Cabeca da Nota Fiscal
		aCabec := {{"F1_FILIAL", XFILIAL("SF1"), Nil},;
		{"F1_TIPO   ", "N", Nil},;
		{"F1_FORMUL ", "N", Nil},;
		{"F1_DOC    ", Iif(lZerosDoc,PADL(ALLTRIM(oCT:_IDE:_NCT:TEXT),9,'0'),PADR(ALLTRIM(oCT:_IDE:_NCT:TEXT),9)), Nil},;
		{"F1_SERIE  ", oCT:_IDE:_SERIE:TEXT, Nil},;
		{"F1_EMISSAO", dData, Nil},;
		{"F1_FORNECE", SA2->A2_COD, Nil},;
		{"F1_LOJA   ", SA2->A2_LOJA, Nil},;
		{"F1_ESPECIE", "CTE", Nil},;
		{"F1_EST    ", SA2->A2_EST, Nil},;
		{"F1_COND   ", cCondPag, Nil},;
		{"E2_NATUREZ", cNaturez, Nil},;
		{"F1_DTDIGIT", DATE(), Nil},;
		{"F1_FORMUL ", "N", Nil},;
		{"F1_RECBMTO", DATE(), Nil},;
		{"F1_CHVNFE ", oChaveNFE, Nil},;
		{"F1_MENNOTA", "Referente a Nota Fiscal: "+cNfOri, Nil}}
		
		cEstCte	:=	oCTE:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
		cMunCte	:=	Right(AllTrim(oCTE:_CTE:_INFCTE:_DEST:_ENDERDEST:_CMUN:TEXT),5)


		//// Item da Nota Fiscal
		AADD(aAux,{"D1_FILIAL ",XFILIAL("SD1"), Nil})
		AADD(aAux,{"D1_ITEM   ","0001", Nil})
		AADD(aAux,{"D1_COD    ",SB1->B1_COD, Nil})
		AADD(aAux,{"D1_UM     ",SB1->B1_UM, Nil})
		AADD(aAux,{"D1_QUANT  ",1, Nil})
		AADD(aAux,{"D1_VUNIT  ",VAL(oCT:_VPREST:_VTPREST:TEXT), Nil})
		AADD(aAux,{"D1_TOTAL  ",VAL(oCT:_VPREST:_VTPREST:TEXT), Nil})
		AADD(aAux,{"D1_TES    ",cTesProdut, Nil})
		AADD(aAux,{"D1_LOCAL  ",SB1->B1_LOCPAD, Nil})
		AADD(aAux,{"D1_CONTA"  ,cCntProdut, Nil})
		AADD(aAux,{"D1_CC"     ,cCusProdut, Nil})
		AADD(aAux,{"D1_DOC    ",Iif(lZerosDoc,PADL(ALLTRIM(oCT:_IDE:_NCT:TEXT),9,'0'),PADR(ALLTRIM(oCT:_IDE:_NCT:TEXT),9)), Nil})
		AADD(aAux,{"D1_SERIE  ",PadR(oCT:_IDE:_SERIE:TEXT,3), Nil})
		AADD(aAux,{"D1_EMISSAO",dData, Nil})
		AADD(aAux,{"D1_DTDIGIT",DATE(), Nil})
		AADD(aAux,{"D1_TIPO   ","N", Nil})
		AADD(aAux,{"D1_TP     ",SB1->B1_TIPO, Nil})
		AADD(aAux,{"D1_FORNECE",SA2->A2_COD, Nil})
		AADD(aAux,{"D1_LOJA   ",SA2->A2_LOJA, Nil})
		AADD(aAux,{"D1_VALICMS",Iif(TYPE("oCT:_IMP:_ICMS:_ICMS00:_VICMS:TEXT")<>"U",VAL(oCT:_IMP:_ICMS:_ICMS00:_VICMS:TEXT),0), Nil})
		AADD(aAux,{"D1_PICM   ",Iif(TYPE("oCT:_IMP:_ICMS:_ICMS00:_PICMS:TEXT")<>"U",VAL(oCT:_IMP:_ICMS:_ICMS00:_PICMS:TEXT),0), Nil})
		AADD(aAux,{"D1_BASEICM",Iif(TYPE("oCT:_IMP:_ICMS:_ICMS00:_VBC:TEXT")<>"U",VAL(oCT:_IMP:_ICMS:_ICMS00:_VBC:TEXT),0), Nil})

		aAdd(aUnidMed,SB1->B1_UM)
		aAdd(aPrdDesc,SB1->B1_DESC)

		lRelaciona := .f.
		/*If SimNao("Deseja relacionar a CTe "+Alltrim(aCabec[3,2])+" / "+Alltrim(aCabec[4,2])+" a um pedido de compra?") == "S"
			lRelaciona := .t.
			AADD(aAux,{"D1_PEDIDO ","", Nil})
			AADD(aAux,{"D1_ITEMPC ","", Nil})
		Endif
          */
		AADD(aItens,aClone(aAux))
		
		//Perguntar se deseja relacionar ao PC
		If lProc .And. Len(aItens) > 0 .And. lRelaciona
			lProc := fLinkNFxPC(aCabec,@aItens,aUnidMed,aPrdDesc)
		EndIf

		If lProc
			lMSErroAuto := .F.         
			lRetorno := .t.
			If GetNewPar("MV_XCTTIP",'N') == 'P'
				MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)
	    	Else
				lRetorno := MsExecAuto({|x,y,z,w| Mata103(x,y,z,w)},aCabec,aItens,3,.t.) //(_aAutoCab, _aAutoItens, 3 , _LWhenGet )
			Endif
			
			If !lRetorno
				MsgAlert("Lan?amento Nota Cte Cancelado !")
				Return .f.
			Else
				IF lMSErroAuto 
					lProc := .F.
					RollBackSxe()
					MostraErro()
					
					cMsErro2 := "<br>Arquivo: "+(cTab1)->&(cAls1+"_ARQUIV")
					cMsErro2 += "<br>Data/Hora:"   +DtoC(Date()) +" / "+ Time()
					cMsErro2 += "<br><br>Erro MsExecAuto: "
					cMsErro2 += "<br><br>"         //+MostraErro("\")
					
					cMsgErro := "Erro na execucao do MsExecAuto para geracao da Nota CTe."
					cMsgNota := "Numero Nota CTe: "+Alltrim(aCabec[4,2])+' / '+Alltrim(aCabec[5,2])
					cMsgAssu := "[Pre Nota] Erro na importacao do XML "
					
					fWfGerXml("INTEGRACAO XML x NOTA CTe", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl+"<br>"+cMsErro2)
					fGravaMsg(nRecTab1,98,"4",cMsgErro+" - "+cMsgNota)
			
					MsgAlert(cMsgErro + Chr(13)+Chr(10) + cMsErro2 + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl)
				Else           
					If !(AllTrim(SF1->F1_DOC) == AllTrim(aCabec[4,2]) .And. AllTrim(SF1->F1_SERIE) == AllTrim(aCabec[5,2]))
						MsgAlert("Lan?amento Nota Cte Cancelado !")
						Return .f.
					Endif
				
					lProc := .T.
					ConfirmSX8()
					
					cMsgErro := "Nota Gerada Com Sucesso!"
					cMsgNota := "Numero Nota CTe: "+Alltrim(aCabec[4,2])+' / '+Alltrim(aCabec[5,2])
					cMsgAssu := "Nota Gerada com sucesso : ["+Alltrim(aCabec[4,2])+' / '+Alltrim(aCabec[5,2])+"]"
			
					fWfGerXml("INTEGRACAO XML x NOTA CTe", cMsgAssu , cMsgErro+"<br>"+cMsgNota+"<br>"+cMsgFoCl)
					fGravaMsg(nRecTab1,98,"3",cMsgErro+" - "+cMsgNota)
			
					MsgInfo(cMsgErro + Chr(13)+Chr(10) + cMsgNota + Chr(13)+Chr(10) + cMsgFoCl)
					
					If RecLock("SF1",.f.)
						SF1->F1_ESTCTE	:=	cEstCte
						SF1->F1_CMUCTE	:=	cMunCte
						SF1->(MsUnlock())
					Endif
				Endif
			Endif
		Endif
	Endif
EndIf
Return(lProc)




#include "rwmake.ch"
#include "topconn.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?NOVO2     ?Autor  ?Microsiga           ? Data ?  10/27/11   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function PdcForn(cFornece)
Private _aAliasDet :=GetArea()
private cPro       :=SB1->B1_COD
private _aArqSel   := {"SC7"}
private cArq       :=""
private cCampos    :="C7_NUM,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_QUANT,C7_QUJE,C7_AQUANT,C7_UM,C7_DATPRF,"
private aFields    :={}

cria_TC7()
processa({|| monta_TC7(cFornece)},"Selecionando registros...") 

aTela :={}
aAdd(aTela,{"C7_NUM"    ,"Pedido"                     })
aAdd(aTela,{"C7_ITEM"   ,"Item"       ,"@!"        })
aAdd(aTela,{"C7_PRODUTO","Produto"                    })
aAdd(aTela,{"C7_DESCRI" ,"Descricao"  ,"@!"           })
aAdd(aTela,{"C7_QUANT"  ,"Quantidade" ,"@E 999,999.99"})
aAdd(aTela,{"C7_UM"     ,"Unidade"    ,"@!"           })
aAdd(aTela,{"C7_QUJE"   ,"Qt.Recebida","@E 999,999.99"})
aAdd(aTela,{"C7_AQUANT" ,"a Receber"  ,"@E 999,999.99"})
aAdd(aTela,{"C7_DATPRF" ,"Dt.Previsao"                })

@ 000,000 to 220,700 dialog oDlg2 title "Pedidos de Compra em Aberto"
@ 000,000 to 110,350 browse "TC7" fields aTela

activate dialog oDlg2 center

dbSelectArea("TC7")
dbCloseArea()
if file(cArq+OrdBagExt())
	fErase(cArq+OrdBagExt())
endif

RestArea(_aAliasDet)

return
*****************************************************************************************************
static function cria_TC7()
Local _nX

dbSelectArea('SX3')
dbSetOrder(1)
For _nX := 1 To Len(_aArqSel)
	DbSeek(_aArqSel[_nX])
	While !Eof() .And. X3_ARQUIVO = _aArqSel[_nX]
		if (alltrim(X3_CAMPO)+"," $cCampos)
			aadd(aFields,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
		endif
		dbSkip()
	endDo
Next
aadd(aFields,{"C7_AQUANT","N",12,2})

cArq:=criatrab(aFields,.T.)
dbUseArea(.t.,,cArq,"TC7")
return


*****************************************************************************************************
static function monta_TC7(cFornece)

Local _nX

cQueryCad :="select C7_NUM,C7_ITEM,C7_DESCRI,C7_DATPRF,C7_QUANT,C7_QUJE,C7_PRODUTO,"
cQueryCad +="       (C7_QUANT-C7_QUJE) As C7_AQUANT,C7_UM"
cQueryCad +="  from "+RetSqlName('SC7')+" "
cQueryCad +=" where D_E_L_E_T_ <>'*' and C7_FORNECE ='"+Left(cFornece,6) + "' AND C7_LOJA = '" + Right(cFornece,2) + "' and "
cQueryCad +=" C7_QUANT >C7_QUJE and C7_RESIDUO <> 'S' and "
cQueryCad +=" C7_FILIAL = '"+xFilial("SC7")+"' "
cQueryCad +=" order by C7_DATPRF"

tcQuery cQueryCad new alias "CAD"

tcSetField("CAD","C7_DATPRF","D")

dbSelectArea("CAD")
dbGoTop()

procRegua(recCount())
while CAD->(!eof())
	incProc()
	recLock("TC7",.T.)
	for _nX := 1 to Len(aFields)
		if aFields[_nX,2] ='C'
			cX :='TC7->'+aFields[_nX,1]+' :=alltrim(CAD->'+aFields[_nX,1]+')'
		else
			cX :='TC7->'+aFields[_nX,1]+' :=CAD->'+aFields[_nX,1]
		endif
		cX :=&cX
	next
	msUnLock()
	CAD->(dbSkip())
endDo
dbSelectarea("CAD")
dbCloseArea()

dbSelectarea("TC7")
dbGoTop()
sysRefresh()
return
