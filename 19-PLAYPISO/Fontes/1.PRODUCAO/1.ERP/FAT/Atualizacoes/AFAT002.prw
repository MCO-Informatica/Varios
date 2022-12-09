#include "topconn.ch"
#INCLUDE "RWMAKE.CH"
#include 'Ap5Mail.ch'
#INCLUDE "PROTHEUS.CH"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFAT002   บAutor  ณMauro Nagata        บ Data ณ  29/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGerenciara os pedidos de vendas para as obras de acordo     บฑฑ
ฑฑบ          ณcom o projeto da obra                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico LISONDA.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                 
User Function AFAT002()
Local cRet
Local cQuery
Local cObPN
Private cUserAss  := AllTrim(SuperGetMv("MV_USASSRM",.F.,""))
Private cUserAdm  := AllTrim(SuperGetMv("MV_USADMRM",.F.,""))
Private cUserGPV  := AllTrim(SuperGetMv("MV_USGPVRM",.F.,""))   //usuario Gerador de Pedido de Vendas
Private cUserApr  := AllTrim(SuperGetMv("MV_USAPRRM",.F.,""))
Private cUserCst  := AllTrim(SuperGetMv("MV_USCSTRM",.F.,""))   //usuario de custo
Private aRotina   := {}
Private cCadastro := "Requisi็ใo de Material"
Private aUsers    := PswRet()

Private cIdUs     := aUsers[1][1]      //Identificacao do usuario
Private cUsuario  := aUsers[1][2]      //usuario
Private cNomeUs   := aUsers[1][4]     //nome do usuario
Private cNomUsu   := aUsers[1][4]     //nome do usuario
Private lGrpAdm   := .F.              //usuario do grupo administradores
Private cEmailUsR := aUsers[1][14]    //email do usuario requisitante
Private cEmailGer := "mauro.nagata@actualtrend.com.br"  //email geral
Private cEmailFat := AllTrim(SuperGetMv("MV_EMFATRM",.F.,"almox@playpiso.com.br"))    //email faturamento
Private lBloqUs   := aUsers[1][17]    //bloqueio do usuario

If ( cIdUs == '000000' )
	lGrpAdm:=.T.  
Else
	// Para verificar se faz parte do grupo de administradores
	If ( Ascan(aUsers[1][10],"000000") <> 0 )
		// O usuario corrente faz parte do grupo de administradores
		lGrpAdm:=.T.
	EndIf
Endif


//preparando o email dos aprovadores
nTamUsApr := Len(cUserApr)
cEmailApr := ""
cSelApr   := ""
If Empty(nTamUsApr)
	cEmailApr := cEmailGer
	cSelApr := "''"
Else
	For nI := 1 To (nTamUsApr/6)
		cCodUsApr := Substr(cUserApr,((nI-1)*6)+1,6)
		cSelApr   += "'"+cCodUsApr+"'"  //variavel para utilizar em query
		PswOrder(1)         //ordem de codigo do usuario
		PswSeek(cCodUsApr,.T.)   //procura por usuario		
		aUsApr := PswRet()
		if len(aUsApr) > 0
			cEmailApr += AllTrim(If(Empty(aUsApr[1][14]),cEmailGer,aUsApr[1][14]))
		endif
		If nI < (nTamUsApr/6)
			cEmailApr += ";"
			cSelApr   += ","
		EndIf
	Next
EndIf

//preparando o email do pessoal de custos
nTamUsCst := Len(cUserCst)
cEmailCst := ""
If !Empty(nTamUsCst)
	For nI := 1 To (nTamUsCst/6)
		cCodUsCst := Substr(cUserCst,((nI-1)*6)+1,6)
		PswOrder(1)         //ordem de codigo do usuario
		PswSeek(cCodUsCst,.T.)   //procura por usuario
		aUsCst := PswRet()
		if len(aUsCst) > 0
			cEmailCst += AllTrim(If(Empty(aUsCst[1][14]),"",aUsCst[1][14]))
		endif
		If nI < (nTamUsCst/6)
			cEmailCst += ";"   //email de custos para quando requisitado quantidade extra
		EndIf
	Next
EndIf

//preparando select do usuario assistente
nTamUsAss := Len(cUserAss)
cSelAss := If(Empty(nTamUsAss),"''","")
For nI := 1 To (nTamUsAss/6)
	//    cSelAss := ""
	cCodUsAss := Substr(cUserAss,((nI-1)*6)+1,6)
	cSelAss   += "'"+cCodUsAss+"'"  //variavel para utilizar em query
	If nI < (nTamUsAss/6)
		cSelAss   += ","
	EndIf
Next


//preparando select do usuario administrador
nTamUsAdm := Len(cUserAdm)
cSelAdm   := If(Empty(nTamUsAdm),"''","")    
cEmailAdm := ""
For nI := 1 To (nTamUsAdm/6)
	cCodUsAdm := Substr(cUserAdm,((nI-1)*6)+1,6)
	cSelAdm   += "'"+cCodUsAdm+"'"  //variavel para utilizar em query
	cEmailAdm += Busca_User(cCodUsAdm,"E")
	If nI < (nTamUsAdm/6)
		cSelAdm   += "," 
		cEmailAdm += ";"
	EndIf
Next

If lGrpAdm
	cSelAss += ",'"+__cUserID+"' "
	cSelAdm += ",'"+__cUserID+"' "
EndIf'

If !GetMv("MV_GerEmRM")   //.T.,, gerenciar os e-mail da requisicao de material, .F., nao gerenciar
   cSelAdm += ""
EndIf   


AAdd(aRotina, {"Pesquisar"	         , "AxPesqui" 	  , 0, 1})
AAdd(aRotina, {"Visualizar"         , "AxVisual"	  , 0, 2})
AAdd(aRotina, {"Requisitar Material", "U_AFAT002s"	  , 0, 3})
AAdd(aRotina, {"Gerar Pedido"       , "U_AFAT002g"	  , 0, 5})
AAdd(aRotina, {"Estornar Pedido"    , "U_AFAT002e"	  , 0, 6})
AAdd(aRotina, {"Avaliar Pend๊ncia"  , "U_AFAT002a"	  , 0, 7})
//AAdd(aRotina, {"Reprovar Requisi็ใo" , "U_AFAT002r"    , 0, 8})
AAdd(aRotina, {"Legenda"            , "U_AFAT002l"	  , 0, 8})

aCores     :={	{"Z7_NECESS <  dDataBase.And.Z7_STATUS != 'G'" , "BR_CINZA"	},; //data de necessidade do material expirado
{"Z7_STATUS =  'S'" , "BR_AMARELO"	},;     //requisicao de material
{"Z7_STATUS =  'P'" , "BR_VERMELHO" },;     //aguardando avaliacao
{"Z7_STATUS =  'A'" , "BR_LARANJA"	},;     //requisicao aprovada
{"Z7_STATUS =  'R'" , "BR_PRETO"	},;     //requisicao rejeitada
{"Z7_STATUS =  'G'" , "BR_VERDE"    },;     //gerado pedido de vendas
{"Z7_STATUS =  'E'" , "BR_BRANCO"	}    }  //pedido de vendas estornado

DbSelectArea("SZ7")
DbSetOrder(1)
mBrowse( 6, 1,22,75,"SZ7",,"Z7_STATUS",,,2,aCores)

Return cRet


User Function AFAT002s()  //rotina requisicao de material

Local cGrupo   := "Requisi็ใo de Material para a Obra "
Private oGroup1
Private oGroup2
Private oGroup3
Private oDlg
Private oFont1    := TFont():New("Times New Roman",,020,,.T.,,,,,.F.,.F.)
Private oFont2    := TFont():New("Times New Roman",,018,,.T.,,,,,.F.,.F.)
Private oObra
Private oNeces
Private oDtNeces
Private dDtNeces  := dDataBase
Private oCodProj
Private cCodProj  := Space(10)
Private oDescProj
Private cDescProj := Space(90)
Private oCodObra
Private cCodObra  := Space(10)
Private oNomObra
Private cNomObra  := Space(40)
Private oRev
Private oCodRev
Private cRevisao  := Space(04)
Private oComboBo1
Private nComboBo1 := 1
Private lBt_Canc  := .F.
Private oDiasAnt
Private nDiasAnt
Private oDiaSem
Private cDiaSem
Private oS_Dias
Private oS_Edt
Private oS_DEdt
Private oS_Tar
Private oS_DTar
Private cDescTar := Space(90)   //descricao da tarefa    
Private cDescTar1:= Space(90) 
Private cDescEdt := Space(40)   //descricao da EDT
Private cCliente := Space(06)   //codigo do cliente
Private cLoja    := Space(02)   //loja do cliente
Private cCodSol
Private aColOri
Private oFiscal
Private cFiscal := Space(02)  //codigo fiscal
Private oNomFisc
Private cNomFisc := Space(30)
Private cNomResp := Space(30)              
Private cStatReq := " "
//aFiscal := {}

aDiaSem := {"Domingo","Segunda-feira","Ter็a-feira","Quarta-feira","Quinta-feira","Sexta-feira","Sแbado"}
Vld_DiasAnt()  //valida dias de antecipacao
Vld_DiaSem()   //valida dia da semana

cQuery := "SELECT * "
cQuery += "FROM (SELECT DISTINCT Convert(VarChar(10),Cast(Z7_NECESS as DateTime),103) AS DATA, "
cQuery += "             CASE WHEN Z7_STATUS = 'S' THEN 'Material REQUISITADO' "
cQuery += "                  WHEN Z7_STATUS = 'A' THEN 'Requsi็ใo APROVADA' "
cQuery += "                  WHEN Z7_STATUS = 'G' THEN 'Pedido GERADO' "
cQuery += "                  WHEN Z7_STATUS = 'R' THEN 'Requisi็ใo REPROVADA' "
cQuery += "                  WHEN Z7_STATUS = 'E' THEN 'Pedido ESTORNADO' "
cQuery += "                  ELSE 'STATUS INDEFINIDO' "
cQuery += "             END AS STATUS, "
cQuery += "             Z7_NOMUSER AS NOMEUSER, Z7_OBRA AS OBRA, A1_NOME AS CLIENTE, "
cQuery += "             Z7_CODIGO AS CODIGO, AF8_DESCRI AS DESCRICAO, Z7_PEDIDO AS PEDIDO "
cQuery += "      FROM SZ7010 AS Z7 "
cQuery += "      INNER JOIN SA1010 AS A1 "
cQuery += "            ON Z7_CLIENTE  = A1_COD "
cQuery += "               AND Z7_LOJA = A1_LOJA "
cQuery += "               AND A1.D_E_L_E_T_ = '' "
cQuery += "      INNER JOIN AF8010 AS AF8 "
cQuery += "            ON Z7_OBRA = AF8_CODOBR "
cQuery += "               AND AF8_PROJET     = Z7_PROJETO "
cQuery += "               AND AF8.D_E_L_E_T_ = '' "
cQuery += "      WHERE "
//eliminado o bloco abaixo [Mauro Nagata, Actual Trend, 22/08/2012]
/*
cQuery += "            (Z7_IDUSER = '"    + __cUserID + "' "
cQuery += "            OR '" + __cUserID  + "' IN ("  +cSelAss+") "
cQuery += "            OR '" + __cUserID  + "' IN ("  +cSelAdm+") "
cQuery += "            OR AF8_CODF1 = '"  + __cUserID +"' "
cQuery += "            OR AF8_CODF2 = '"  + __cUserID +"' "
cQuery += "            OR Z7_CODUSFI = '" + __cUserID + "' "
cQuery += "            OR '"+If(lGrpAdm,'S','N')+"' = 'S' ) "
cQuery += "            AND Z7_STATUS NOT IN ( 'G' ) AND "        
//fim bloco [Mauro Nagata, Actual Trend, 22/08/2012]
*/ 
cQuery += "            Z7.D_E_L_E_T_ = '' ) AS A "

cQuery += "ORDER BY  CODIGO DESC, DATA DESC "

MemoWrite("AFAT002s.SQL",cQuery)

cObPN := FGEN008a(cQuery , {{ "Codigo","Necessidade", "Obra", "Descri็ใo", "Status", "Pedido", "Cliente", "USUARIO"}, {"CODIGO", "DATA", "OBRA", "DESCRICAO", "STATUS", "PEDIDO", "CLIENTE", "NOMEUSER"}}, "Requisi็ใo de Material", 1)

lManSol    := .F.
aColAux    := {}
cJustExtra := ""
//aFiscal  := {"","",""}
If Type("cObPN") == "C".And.cObPN != "InclSol"
	
	cCodSol := cObPN                 //codigo da requisicao
	
	cGrupo += "[ "+cCodSol+" ]"
	
	DbSelectArea("SZ7")
	DbSetOrder(1)
	DbSeek(xFilial("SZ7")+cCodSol)
	cCodObra   := SZ7->Z7_OBRA     //codigo da obra
	//	cRevisOri := SZ7->Z7_REVISAO  //revisao na inclusao da requisicao
	cCodProj   := SZ7->Z7_PROJETO  //codigo do projeto
	cCodigo    := SZ7->Z7_CODIGO   //codigo da requisicao
	cJustExtra := If(SZ7->Z7_STATUS="R","",SZ7->Z7_JUSTEXT)  //justificativa de quantidade extra do produto
	dDtNeces   := SZ7->Z7_NECESS
	nDiasAnt   := dDtNeces - dDataBase
	cFiscal    := SZ7->Z7_CODFISC
	cNomFisc   := GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5")+"ZZ"+cFiscal,1,"Nใo Encontrado")
	cNomResp   := cNomFisc
	cIDF_orig  := GetAdvFVal("SX5","X5_DESCSPA",xFilial("SX5")+"ZZ"+cFiscal,1,"Nใo Cadastrado")  //ID User original
	cStatReq   := SZ7->Z7_STATUS
	
	DbSelectArea("CTT")
	DbSeek(xFilial("CTT")+cCodObra)
	cNomObra := CTT->CTT_DESC01
	
	DbSelectArea("AF8")
	DbSetOrder(1)
	DbSeek(xFilial("AF8")+cCodProj)
	
	cRevisao := AF8->AF8_REVISA
	cCodObra := AF8->AF8_CODOBR
	cCliente := AF8->AF8_CLIENT
	cLoja    := AF8->AF8_LOJA
	
	//	aFiscal  := {}
	//	aAdd(aFiscal,Space(10))
	//	aAdd(aFiscal,GetAdvFVal("SX5","X5_DESCRI",xFilial('SX5')+'ZZ'+AF8->AF8_CODF1,1,''))
	//	aAdd(aFiscal,GetAdvFVal("SX5","X5_DESCRI",xFilial('SX5')+'ZZ'+AF8->AF8_CODF2,1,''))
	
	//	nCBo1     := aScan(aFiscal,SZ7->Z7_FISCAL1)
	//	nComboBo1 := If(nCBo1>1,nCBo1,1)
	
	DbSelectArea("AFC")
	DbSeek(xFilial("AFC")+cCodProj+cRevisao+"01")
	cDescProj := AFC->AFC_DESCRI
	
	DbSelectArea("AEA")   //fase do projeto
	DbSetOrder(1)
	DbSeek(xFilial("AEA")+AF8->AF8_FASE)
	cDescrFase := AllTrim(AEA->AEA_DESCRI)
	If AEA->AEA_SOLMAT != "S"    //S, pode requisitar material para a obra  N, nao pode requisitar material para a obra
		MsgBox("Esta obra esta na fase ["+AF8->AF8_FASE+"-"+cDescrFase+"], portanto, nใo permite requisitar material para a Obra.","Requisi็ใo de Material","ALERT")
		cCodObra := Space(10)
		cCodProj := Space(10)
		Return(.T.)
	EndIf
	
	DbSelectArea("AFA")          //recursos do projeto
	DbSetOrder(1)
	DbSeek(xFilial("AFA")+cCodProj+cRevisao)
	cTarefa := Space(12)
	lIpEdt  := .T.  //identificar primeira EDT
	cDescTar := Space(90)
	cDescEdt := Space(90)
	cTarAux  := AFA->AFA_TAREFA
	
	Do While !Eof().And.xFilial("AFA")+cCodProj+cRevisao=AFA->AFA_FILIAL+AFA->AFA_PROJET+AFA->AFA_REVISAO
		If !Empty(AFA->AFA_RECURS)
			DbSkip()
			Loop
		EndIf
		cTarefa  := AFA->AFA_TAREFA
		cItemTar := AFA->AFA_ITEM
		cProdut  := AllTrim(AFA->AFA_PRODUT)
		nQuant   := AFA->AFA_QUANT 
		nRegAFA  := Recno()
		If DbSeek(xFilial("AFA")+cCodProj+"0001"+cTarefa+cItemTar+cProdut)
		   nQtd_R1 := AFA->AFA_QUANT
		Else
		   nQtd_R1 := 0
		EndIf      
		nSld_Rev := nQtd_R1 - nQuant
		DbGoTo(nRegAFA)
		nQtdEnt  := AFA->AFA_QTDENT
		nQtdEmp  := AFA->AFA_QTDEMP
		nQtdSld  := nQuant - nQtdEnt - nQtdEmp
		nCustd   := AFA->AFA_CUSTD
		cEdt     := Substr(cTarefa,1,RAt(".",cTarefa)-1)
		
		DbSelectArea("AFC")
		DbSetOrder(4)
		DbSeek(xFilial("AFC")+cCodProj+cCodProj)
		cDescProj := AFC->AFC_DESCRI
		
		DbSelectArea("AFC")
		DbSetOrder(1)
		DbSeek(xFilial("AFC")+cCodProj+cRevisao+cEdt)
		cDescEDT  := AFC_DESCRI
		cDescTar1 := AF9->AF9_DESCRI
		nQtdSol   := 0
		
		DbSelectArea("SZ8")
		DbSetOrder(1)
		
		nQtdSol := If(DbSeek(xFilial("SZ8")+cCodSol+cTarefa+cItemTar+cProdut),SZ8->Z8_QTDSOL,0)
		If AFA->AFA_TAREFA != cTarAux
			aAdd(aColAux,{"","","",0,"",0,0,0,0,0,0,0,"",.F.})
			cTarAux := AFA->AFA_TAREFA
		EndIf
		aAdd(aColAux,{AFA->AFA_TAREFA,cProdut,GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+cProdut,1,"Nใo Cadastrado"),nQtdSol,GetAdvFVal("SB1","B1_UM",xFilial("SB1")+cProdut,1,"??"),nQtd_R1,nQuant,nSld_Rev,nQtdSld,nQtdEmp,nQtdEnt,nCustd,cItemTar,.F.})
		
		DbSelectArea("AFA")
		DbSkip()
	EndDo
	lManSol := .T.
ElseIf Type("cObPN") == "B"
	Return
EndIf


aColOri := aClone(aColAux)

//Private oDlg

DEFINE MSDIALOG oDlg TITLE If(lManSol,"Manuten็ใo da ","Inclusใo da ")+"Requisi็ใo" FROM 000, 000  TO 600, 1200 COLORS 0,16777215 PIXEL

@ 005, 065 GROUP oGroup1 TO 060, 565 PROMPT cGrupo   OF oDlg COLOR 16711680,16744576 PIXEL
@ 015, 070 SAY    oObra     PROMPT "Obra"          SIZE 028, 012 OF oDlg FONT oFont1 COLORS 0,16777215 PIXEL
@ 015, 119 MSGET  oCodObra  VAR cCodObra           SIZE 063, 010 OF oDlg VALID Vld_Obra("1") COLORS 255, 16777215 FONT oFont2 F3 "AF8SMO" PIXEL Picture "@!" When !lManSol
@ 016, 188 SAY    oNomObra  PROMPT cNomObra        SIZE 300, 010 OF oDlg COLORS 0, 16777215 FONT oFont2 PIXEL
@ 015, 416 SAY    oRev      PROMPT "Revisใo"       SIZE 030, 012 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 016, 447 SAY    oCodRev   PROMPT cRevisao        SIZE 054, 010 OF oDlg COLORS 0, 16777215 FONT oFont2 PIXEL
@ 030, 070 SAY    oProj     PROMPT "Projeto"       SIZE 030, 012 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 029, 119 MSGET  oCodProj  VAR    cCodProj        SIZE 063, 010 OF oDlg VALID Vld_Proj() COLORS 255, 16777215 FONT oFont2 F3 "AF8SMP" PIXEL Picture "@!" When !lManSol
@ 031, 188 SAY    oDescProj PROMPT cDescProj       SIZE 300, 010 OF oDlg COLORS 0, 16777215 FONT oFont2 PIXEL
@ 045, 070 SAY    oNeces    PROMPT "Necessidade"   SIZE 052, 012 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 045, 119 MSGET  oDtNeces  VAR    dDtNeces        SIZE 045, 010 OF oDlg VALID Vld_DtNec() COLORS 255, 16777215 FONT oFont2 PIXEL Picture "@D"
@ 046, 169 SAY    oDiaSem   PROMPT cDiaSem         SIZE 070, 010 OF oDlg COLORS 255, 16777215 FONT oFont2 PIXEL
@ 045, 239 SAY    oS_Dias   PROMPT "Para daqui a " SIZE 050, 012 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 046, 284 SAY    oDiasAnt  PROMPT nDiasAnt        SIZE 020, 010 OF oDlg COLORS 255, 16777215 FONT oFont2 PIXEL
//@ 045, 307 SAY    oS_Dias   PROMPT "dias ๚teis"    SIZE 060, 012 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 045, 302 SAY    oS_Dias   PROMPT "dias"    SIZE 060, 012 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 045, 416 SAY    oRev      PROMPT "Responsแvel"  SIZE 050, 012 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
@ 045, 475 MSGET  oFiscal   VAR    cFiscal         SIZE 015, 010 OF oDlg VALID Vld_Fisc() COLORS 255, 16777215 FONT oFont2 PIXEL Picture "@D" F3 "ZZ"
@ 045, 505 MsGet  oNomFisc  VAR    cNomFisc        SIZE 050, 010 OF oDlg COLORS 255, 16777215 FONT oFont2 PIXEL Picture "@!" When .F. NOBORDER
//@ 030, 480 MSCOMBOBOX oComboBo1 VAR nComboBo1      ITEMS aFiscal SIZE 70,010 OF oDlg COLORS 0, 16777215 PIXEL

@ 065, 015 GROUP oGroup2 TO 085, 585 PROMPT "[ EDT ]"    OF oDlg COLOR 16711680,16744576 PIXEL
@ 072, 045 SAY    oS_DEdt   PROMPT cDescEDT        SIZE 300, 010 OF oDlg COLORS 255, 16777215 FONT oFont2 PIXEL

@ 085, 015 GROUP oGroup3 TO 105, 585 PROMPT "[ Tarefa ]" OF oDlg COLOR 16711680,16744576 PIXEL
@ 092, 045 SAY    oS_DTar   PROMPT cDescTar        SIZE 300, 010 OF oDlg COLORS 255, 16777215 FONT oFont2 PIXEL

//@ 317, 327 BUTTON oButton2  PROMPT "Requisitar"    SIZE 050, 020 OF oDlg ACTION (Iif(Bt_Act1(),oDlg:End(),)) WHEN Bt_When1() PIXEL  MESSAGE "Requisitar o Material"
//@ 317, 392 BUTTON oButton1  PROMPT "Cancelar"      SIZE 050, 020 OF oDlg ACTION Bt_Act2()                                      PIXEL MESSAGE "Cancelar a Requisi็ใo de Material"
@ 270, 345 BUTTON oButton2  PROMPT "Requisitar"    SIZE 050, 020 OF oDlg ACTION (Iif(Bt_Act1(),oDlg:End(),)) WHEN Bt_When1() PIXEL  MESSAGE "Requisitar o Material"
@ 270, 410 BUTTON oButton1  PROMPT "Cancelar"      SIZE 050, 020 OF oDlg ACTION (Iif(Bt_Act2(),oDlg:End(),))                 PIXEL MESSAGE "Cancelar a Requisi็ใo de Material"


NewGe001()
If lManSol
	oMSNewGe1:aCols=aColAux
EndIf

ACTIVATE MSDIALOG oDlg CENTERED
cNomResp := cNomFisc

Return


Static Function Vld_Fisc()

cNomFisc := GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5")+"ZZ"+cFiscal,1,"Nใo Cadastrado")   //nome do fiscal
cNomResp := cNomFisc
//cIdFisc  := SX5->X5_DESCSPA  //codigo do usuario
//desativado temporariamente para avaliar a necessidade de vincular a requisicao ao projeto, apos reuniao com sr.Fabio e sra.IDA [Mauro Nagata, Actual Trend, 04/04/2011]
/*
If cFiscal != AF8->AF8_CODF1 .And. cFiscal != AF8->AF8_CODF2
	MsgBox("Este fiscal nใo ้ nenhum dos dois fiscais cadastrados neste projeto","Requisi็ใo de Material","ALERT")
EndIf

oNomFisc:Refresh()
*/
//Return.T.

User Function AFAT002a()   //avaliar a requisicao
Local   nOpca   := 0
Local   aCampos := {}
Local   cArqInd
Local   aCabPv   := {}
Local   aItens   := {}
Local   cUM
Local   cCondPag
Local   nPrcVen
Local   dDtNecess
Local   lMsErroAuto := .T.
Private cArqTmp
Private cMarca:= GetMark()
Private cPerg := "AFAT002"
Private oFont1 := TFont():New("Times New Roman",,018,,.T.,,,,,.F.,.F.)

If !(__cUserID$cUserApr+cUserAdm).And.!lGrpAdm
	MsgBox("Acesso restrito!!! Contate o Administrador de Sistema [ MV_USAPRRM ]","Requisi็ใo de Material","INFO")
	Return
EndIf


ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf

AF002aTRB()

aAdd(aCampos,{"Z7_OK"     ,"","Gerar PV",""})
aAdd(aCampos,{"STATUS" ,"","Status","@X"})
aAdd(aCampos,{"Z7_CODIGO" ,"","Cod.Requis.","@!"})
aAdd(aCampos,{"Z7_OBRA"   ,"","Obra","@!"})
aAdd(aCampos,{"Z7_NECESS" ,"","Necessidade","@D"})
aAdd(aCampos,{"DESCOBRA"  ,"","Descri็ใo","@!"})
aAdd(aCampos,{"Z7_CLIENTE","","Cliente","@!"})
aAdd(aCampos,{"Z7_LOJA"   ,"","Loja","@!"})
aAdd(aCampos,{"RAZSOC"    ,"","Razใo Social","@!"})
aAdd(aCampos,{"Z7_PROJETO","","Projeto","@!"})
aAdd(aCampos,{"Z7_FISCAL ","","Fiscal","@!"})
//aAdd(aCampos,{"Z7_STATUS" ,"","Status","@!"})
//aAdd(aCampos,{"NOMFIS1","","Nome Fiscal","@!"})


DEFINE MSDIALOG oDlga TITLE "Selecione as requisi็๕es para definir sua anแlise da requisi็ใo" FROM 5,0 To 38,128 OF oMainWnd   //"Selecione os clientes para gera็ใo dos tํtulos definitivos"
SZ7TRB->(Dbgotop())
oMark:=MsSelect():New("SZ7TRB","Z7_OK",,aCampos,,cMarca,{3,3,200,500})
oMark:oBrowse:lhasMark := .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := {|| AF002Inv(cMarca,@oMark)}

@ 220,300 Button bAprvQExt  PROMPT "Aprovar"   When .T. Size 045,022 Action(nOpca:=1,Bt_AnReq())  FONT oFont1 PIXEL OF oDlga MESSAGE "Aprovar Quantidade Extra de Material"
@ 220,370 Button bReprvQExt PROMPT "Reprovar"  When .T. Size 045,022 Action(nOpca:=2,Bt_AnReq())  FONT oFont1 PIXEL OF oDlga MESSAGE "Reprovar Quantidade Extra de Material"
@ 220,440 Button bSairQExt  PROMPT "Sair"      When .T. Size 045,022 Action(nOpca:=3,oDlga:End()) FONT oFont1 PIXEL OF oDlga MESSAGE "Sair da rotina de avalia็ใo"

ACTIVATE MSDIALOG oDlga CENTERED

If nOpca != 3
	If MsgBox("Deseja "+ If(nOpca=1,"APROVAR","REPROVAR") + " esta requisi็ใo ?","Requisi็ใo de Material","YESNO")
		DbSelectArea("SZ7TRB")
		DbGoTop()
		Do While !Eof()
			If Empty(SZ7TRB->Z7_OK)
				DbSkip()
				Loop
			EndIf
			
			DbSelectArea("SZ7")
			DbSetOrder(1)
			DbSeek(xFilial("SZ7")+SZ7TRB->Z7_CODIGO)
			RecLock("SZ7",.F.)
			SZ7->Z7_STATUS  := If(nOpca == 1,"A","R")
			SZ7->Z7_DECISAO := dDataBase
			SZ7->(MsUnLock())
			
			DbSelectArea("SZ7TRB")
			DbSkip()
			                      
			If nOpca = 2 //reprovada
			   cIDFisc    := GetAdvFVal("SX5","X5_DESCSPA",xFilial("SX5")+"ZZ"+SZ7->Z7_CODFISC,1,"Nใo Cadastrado")  
			   cEmailFisc := Busca_User(cIDFisc,"E")
			                                                                                                                                                                                                                             
			   U_FGEN010(cEmailFisc+";"+cEmailUsR+";"+cEmailAdm+";"+cEmailCst,          "ReqMat - Reprovada a Requisi็ใo [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Reprovada a Requisicao de Material","",.F.)
			   //U_FGEN010("bruno.parreira@actualtrend.com.br","ReqMat - Reprovada a Requisi็ใo [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Reprovada a Requisicao de Material","",.F.)
			Else   
			   cIDFisc    := GetAdvFVal("SX5","X5_DESCSPA",xFilial("SX5")+"ZZ"+SZ7->Z7_CODFISC,1,"Nใo Cadastrado")  
			   cEmailFisc := Busca_User(cIDFisc,"E")
			                                                                                                                                                                                                                             
			   U_FGEN010(cEmailUsR+";"+cEmailCst+";"+cEmailAdm,          "ReqMat - Aprovada a Requisi็ใo [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Aprovada a Requisicao de Material","",.F.)
			   //U_FGEN010("bruno.parreira@actualtrend.com.br","ReqMat - Reprovada a Requisi็ใo [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Reprovada a Requisicao de Material","",.F.)
			EndIf   
			
		EndDo
	EndIf
EndIf


DbSelectArea("SZ7TRB")
DbCloseArea()
fErase(cArqTmp+GetDBExtension())
Return


Static Function Bt_AnReq()
Local lRet:=.F.

DbSelectArea("SZ7TRB")
DbGoTop()
Do While !Eof()
	If Empty(SZ7TRB->Z7_OK)
		DbSkip()
		Loop
	EndIf
	lRet := .T.
	
	DbSkip()
EndDo
If !lRet
	MsgBox("ษ necessแrio selecionar uma requisi็ใo","Requisi็ใo de Material","INFO")
	DbGoTop()
Else
	oDlga:End()
EndIf
Return lRet



User Function AFAT002e()    //estorno do pedido
Local aCab   := {}
Local aItens := {}
Local cQuery
Private lMSErroAuto := .F.
Private cObPN


cQuery := "SELECT * "
cQuery += "FROM SZ7010 AS Z7 "
cQuery += "WHERE Z7_STATUS = 'G' "
cQuery += "      AND Z7.D_E_L_E_T_ = '' "
cQuery += "ORDER BY Z7_PEDIDO DESC "

cObPN := U_FGEN008(cQuery , {{ "Pedido","Obra", "Projeto","Requisi็ใo","Cliente","Loja"}, {"Z7_PEDIDO", "Z7_OBRA", "Z7_PROJETO","Z7_CODIGO","Z7_CLIENTE","Z7_LOJA"}}, "Estorno do Pedido", 4)

If Type("cObPN") == "C"
	Begin Transaction
	cCodSol := cObPN       //codigo da requisicao
	
	DbSelectArea("SZ7")
	DbSetOrder(1)
	DbSeek(xFilial("SZ7")+cCodSol)
	RecLock("SZ7",.F.)
	
	lEstorno := .T.      
	lIpFilOk := .F.
	DbSelectArea("SC6")
	DbSetOrder(1)         
	If DbSeek(xFilial("SC6")+SZ7->Z7_PEDIDO)
	   Do While !Eof().And.SZ7->Z7_PEDIDO = SC6->C6_NUM
	      If SZ7->Z7_CODIGO == AllTrim(SC6->C6_PEDCLI)
	         lIpFilOk := .T.
	         Exit
	      EndIf
	      SC6->(DbSkip())   
	   EndDo
	EndIf                   
	
	If !lIpFilOk
	   MsgBox("Pedido gerado por outra Filial","Pedido Nใo Serแ Excluํdo","INFO")	   
    	DisarmTransaction()                                                       
    	SZ7->(MsUnLock())
	   Return
	EndIf   
	
	If lEstorno
		//exclusao do pedido de vendas                   
		aAdd(aCab,	{"C5_NUM"		,SZ7->Z7_PEDIDO, NIL})
		aAdd(aItens,{{"C6_NUM"		,SZ7->Z7_PEDIDO, NIL}})
		MsExecAuto({|x,y,z|MATA410(x,y,z)},aCab,aItens,5)
		If lMSErroAuto
			Mostraerro()
			MsgAlert("Pedido nใo foi excluido!!! Houve algum erro na exclusao do pedido desta requisicao - AFAT002")
			DisarmTransaction()
			SZ7->(MsUnLock())
			Return
		EndIf
		                              
		cPedEstorno := SZ7->Z7_PEDIDO
		SZ7->Z7_ESTORNO := dDataBase
		SZ7->Z7_STATUS  := "E"
		SZ7->Z7_GERADOP := Ctod("")
		SZ7->Z7_PEDIDO  := ""
		
		DbSelectArea("SZ8")
		DbSetOrder(1)
		DbSeek(xFilial("SZ8")+SZ7->Z7_CODIGO)
		Do While !Eof().And.SZ7->Z7_CODIGO = SZ8->Z8_CODIGO
			DbSelectArea("AFA")          //recursos do projeto
			DbSetOrder(1)
			If DbSeek(xFilial("AFA")+SZ7->Z7_PROJETO+SZ7->Z7_REVISAO+SZ8->Z8_TAREFA+SZ8->Z8_ITEM+SZ8->Z8_PRODUTO)
				RecLock("AFA",.F.)
				AFA->AFA_QTDEMP += SZ8->Z8_QTDSOL
				AFA->AFA_QTDENT -= SZ8->Z8_QTDSOL
				AFA->(MsUnLock())
			EndIf
			
			DbSelectArea("SZ8")
			DbSkip()
		EndDo           
		
		cIDFisc    := GetAdvFVal("SX5","X5_DESCSPA",xFilial("SX5")+"ZZ"+SZ7->Z7_CODFISC,1,"Nใo Cadastrado")  
		cEmailFisc := Busca_User(cIDFisc,"E")         
		                                                              
		//FGEN010(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem)
		U_FGEN010(cEmailFisc+";"+cEmailFat+";"+cEmailUsR+";"+cEmailAdm, "ReqMat - Estorno de Pedido "+cPedEstorno+" [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Estorno de Pedido : "+cPedEstorno,"",.F.)
		//U_FGEN010("bruno.parreira@actualtrend.com.br",     "ReqMat - Estorno de Pedido "+cPedEstorno+" [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Estorno de Pedido : "+cPedEstorno,"",.F.)
		
	EndIf
	SZ7->(MsUnLock())
	End Transaction
EndIf

Return


Static Function Vld_DtNec()
Vld_DiasAnt()
oDiasAnt:Refresh()
Vld_DiaSem()
oDiaSem:Refresh()
aColOri := aClone(aColAux)
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณVld_DiasAntบAutor  ณMauro Nagata        บ Data ณ  26/01/11  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ validacao de dias de antecipacao - data da necessidade em  บฑฑ
ฑฑบ          ณ relacao a data base                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Lisonda                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Vld_DiasAnt()

nDiasAnt := dDtNeces - dDataBase

// criar rotina de desconsiderar sabado e domingo


Return(.T.)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณVld_DiaSem บAutor  ณMauro Nagata        บ Data ณ  26/01/11  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ validacao do dia da semana                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Lisonda                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Vld_DiaSem()

cDiaSem := aDiaSem[Dow(dDtNeces)]
Return(.T.)






Static Function Vld_Obra(pOrigem)
Local aColAux
Local cOrigem := pOrigem

cDescObra := Space(40)
cDescProj := Space(90)
cDescEdt  := Space(90)
cDescTar  := Space(90)
If cOrigem ="1".Or.lManSol
	oNomObra:Refresh()
	oDescProj:Refresh()
	oS_DEdt:Refresh()
	oS_DTar:Refresh()
	aColAux := {}
	oMSNewGe1:aCols=aColAux
	oMSNewGe1:ForceRefresh()
EndIf
DbSelectArea("AF8")
DbOrderNickName("CODBRA")
If !DbSeek(xFilial("AF8")+cCodObra)  //.And.(cOrigem = "1").Or.lManSol
	MsgBox("C๓digo da obra nใo encontrada","Requisi็ใo de Material","ALERT")
	Return(.F.)
EndIf
If AF8->AF8_ENCPRJ = "1"    //.And.(cOrigem = "1").Or.lManSol
	MsgBox("Projeto Encerrado","Requisi็ใo de Material","ALERT")
	Return(.F.)
EndIf
cCodProj := AF8->AF8_PROJET
cRevisao := AF8->AF8_REVISA
cCodObra := AF8->AF8_CODOBR
cCliente := AF8->AF8_CLIENT
cLoja    := AF8->AF8_LOJA

//aAdd(aFiscal,Space(10))
//aAdd(aFiscal,AF8->AF8_X_FISC)
//aAdd(aFiscal,AF8->AF8_XFISC2)
//aFiscal[2] := AF8->AF8_X_FISC
//aFiscal[3] := AF8->AF8_XFISC2
//oComboBo1:Refresh()
//oGroup1:Refresh()
//oDlg:Refresh()


If !Empty(cCodObra)
	DbSelectArea("AF9")
	DbSetOrder(1)
	If DbSeek(xFilial("AF9")+cCodProj+cRevisao)
		DbSelectArea("CTT")
		If DbSeek(xFilial("CTT")+cCodObra)
			cNomObra := CTT->CTT_DESC01
			If cOrigem = "1"
				oNomObra:Refresh()
			EndIf
			If CTT->CTT_MSBLQL = "1"    //.And.(cOrigem = "1").Or.lManSol
				MsgBox("Obra BLOQUEADA no cadastro de Obra. Verificar com Depto.Financeiro","Requisi็ใo de Material", "ALERT")
				Return(.F.)
			EndIf
		Else
			MsgBox("Obra nใo cadastrada na Tabela CTT. Existe inconsist๊ncia AF8 x CTT","Requisi็ใo de Material","ALERT")
			Return(.F.)
		EndIf
		DbSelectArea("AFC")
		If DbSeek(xFilial("AFC")+cCodProj+cRevisao+"01")
			
			cDescProj := AFC->AFC_DESCRI
			//  	      If cOrigem = "1".Or.lManSol
			oCodProj:Refresh()
			oDescProj:Refresh()
			oCodRev:Refresh()
			//	      EndIf
		EndIf
		//oDtNeces:SetFocus()
	EndIf
Else
	If Empty(cCodObra)
		MsgBox("C๓digo da obra indefinida.","Requisi็ใo de Material","ALERT")
		Return(.F.)
	EndIf
EndIf
Return .T.







Static Function Vld_Proj()
Local lOk := .F.
Local cTarefa
Local cProdut
Local nQuant
Local nQtdSld
Local nQtdEnt
Local nQtdEmp
//Local nQtdExt
Local nCustd
Local cDescPrd

DbSelectArea("AF8")

DbOrderNickName("CODBRA")
If !DbSeek(xFilial("AF8")+cCodObra)
	MsgBox("C๓digo da obra nใo encontrada","Requisi็ใo de Material","ALERT")
	Return(.F.)
Else
	Do While !Eof().And.cCodObra == AF8->AF8_CODOBR
		If cCodProj == AF8->AF8_PROJET
			lOk := .T.
			Exit
		EndIf
		DbSkip()
	EndDo
EndIf
If !lOk
	Return(.F.)
EndIf

cRevisao := AF8->AF8_REVISA
cCodObra := AF8->AF8_CODOBR

If !lBt_Canc
	If !Empty(AF8->AF8_FASE)
		DbSelectArea("AEA")   //fase do projeto
		DbSetOrder(1)
		If DbSeek(xFilial("AEA")+AF8->AF8_FASE)
			cDescrFase := AllTrim(AEA->AEA_DESCRI)
			If AEA->AEA_SOLMAT != "S"    //S, pode requisitar material para a obra  N, nao pode requisitar material para a obra
				MsgBox("Esta obra esta na fase ["+AF8->AF8_FASE+"-"+cDescrFase+"], portanto,  nใo permite requisitar material para a Obra.","Requisi็ใo de Material","ALERT")
				cCodObra := Space(10)
				cCodProj := Space(10)
				oCodObra:SetFocus()
				Return(.T.)
			EndIf
		EndIf
	Else
		MsgBox("Fase deste projeto nใo definido. Definir a fase atual desta obra no m๓dulo Gestใo de Projetos","Requisi็ใo de Material","ALERT")
		Return(.F.)
	EndIf
	
	DbSelectArea("AFA")          //recursos do projeto
	DbSetOrder(1)
	If DbSeek(xFilial("AFA")+cCodProj+cRevisao)
		cTarefa := Space(12)
		lIpEdt  := .T.  //identificar primeira EDT
		cDescTar := Space(90)
		cDescEdt := Space(90)
		cTarAux  := AFA->AFA_TAREFA
		
		aColAux := {}
		Do While !Eof().And.xFilial("AFA")+cCodProj+cRevisao=AFA->AFA_FILIAL+AFA->AFA_PROJET+AFA->AFA_REVISAO
			If !Empty(AFA->AFA_RECURS)
				DbSkip()
				Loop
			EndIf
			cTarefa  := AFA->AFA_TAREFA
			cItemTar := AFA->AFA_ITEM
			cProdut  := AllTrim(AFA->AFA_PRODUT)
			nQuant   := AFA->AFA_QUANT      //quantidade original
			nRegAFA  := Recno()
			If DbSeek(xFilial("AFA")+cCodProj+"0001"+cTarefa+cItemTar+cProdut)
			   nQtd_R1 := AFA_QUANT                 //quantidade do produto na revisao 0001
			Else
			   nQtd_R1 := 0                         //quando nao existir o item do produto na revisao 0001
			EndIf
			nSld_Rev := nQtd_R1 - nQuant
			DbGoTo(nRegAFA)      
			nQtdEmp  := AFA->AFA_QTDEMP     //quantidade requisitada pendente
			nQtdEnt  := AFA->AFA_QTDENT     //quantidade que gerou pedido de vendas
			nQtdSld  := nQuant - nQtdEmp - nQtdEnt
			nCustd   := AFA->AFA_CUSTD
			cEdt     := Substr(cTarefa,1,RAt(".",cTarefa)-1)
			DbSelectArea("AF9")   //tarefa do projeto
			DbSetOrder(1)
			If DbSeek(xFilial("AF9")+cCodProj+cRevisao+cTarefa)
				DbSelectArea("CTT")
				If DbSeek(xFilial("CTT")+cCodObra)
					cNomObra := CTT->CTT_DESC01
					oNomObra:Refresh()
				EndIf
				DbSelectArea("AFC")
				DbSetOrder(4)
				If DbSeek(xFilial("AFC")+cCodProj+cCodProj)
					oCodProj:Refresh()
					cDescProj := AFC->AFC_DESCRI
					oDescProj:Refresh()
					oCodRev:Refresh()
				EndIf
				
				If lIpEDT
					DbSelectArea("AFC")
					DbSetOrder(1)
					If DbSeek(xFilial("AFC")+cCodProj+cRevisao+cEdt)
						cDescEDT := AFC_DESCRI
					EndIf
					cDescTar1 := AF9->AF9_DESCRI
					lIpEdt := .F.
				EndIf
				
				oDtNeces:SetFocus()
			EndIf
			//            aAdd(aColAux,{AFA->AFA_TAREFA,cProdut,GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+cProdut,1,"Nใo Cadastrado"),nQuant,0,nQtdSld,nQtdEnt,nQtdEmp,nQtdExt,nCustd,.F.})
			nQtdSol := 0
			If lManSol
				DbSelectArea("SZ8")
				DbSetOrder(1)
				If DbSeek(xFilial("SZ8")+cCodSol+cTarefa+cItemTar+cProdut)
					nQtdSol := SZ8->Z8_QTDSOL
				EndIf
			EndIf
			If AFA->AFA_TAREFA != cTarAux
				//aAdd(aColAux,{AFA->AFA_TAREFA,"","","",0,0,0,0,0,0,"",.T.})
				//aAdd(aColAux,{"","","","",0,0,0,0,0,0,0,0,"",.F.})
				aAdd(aColAux,{"","","",0,"",0,0,0,0,0,0,0,"",.F.})
				cTarAux := AFA->AFA_TAREFA
			EndIf
			aAdd(aColAux,{cTarefa,cProdut,GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+cProdut,1,"Nใo Cadastrado"),nQtdSol,GetAdvFVal("SB1","B1_UM",xFilial("SB1")+cProdut,1,"Nใo Cadastrado"),nQtd_R1,nQuant,nSld_Rev,nQtdSld,nQtdEmp,nQtdEnt,nCustd,cItemTar,.F.})
			
			DbSelectArea("AFA")
			DbSkip()
		EndDo
		
		oMSNewGe1:aCols=aClone(aColAux)
		oMSNewGe1:ForceRefresh()
	EndIf
EndIf
cDescTar := cDescTar1
oS_DEdt:Refresh()
oS_DTar:Refresh()
Return .T.







Static Function Bt_Act1()   //botao requisitar
Local oFont1 := TFont():New("Verdana",,016,,.F.,,,,,.F.,.F.)
Local oDlg1
Local oMemo
Local cOpA
Private nPosTar
Private nPosQSol
Private cArqOrig   := "\HTML\AFAT002_JUSTEXTRA.HTM" //"C:\Users\Work Area\Work\ActualTrend\Lisonda\HTML\AFAT002_JUSTEXTRA.HTM"

Private cArqDest   := "c:\SIGA.HTML" //"C:\Users\Work Area\Work\ActualTrend\Lisonda\HTML\SIGA_JUSTEXTRA.HTML"
//Private cEmailDest := "mauro.nagata@actualtrend.com.br;mngt@terra.com.br"
Private cAnexo   := ""
Private c_Texto  := ""


If dDtNeces < dDataBase
	MsgBox("Data de Necessidade desta requisi็ใo ้ invแlida","Requisi็ใo de Material","INFO")
	Return.F.
EndIf
If Empty(cFiscal)
	MsgBox("Requisitante nใo informado","Requisi็ใo de Material","INFO")
	Return.F.
EndIf

aHeAux := aClone(oMSNewGe1:aHeader)
aCoAux := aClone(oMSNewGe1:aCols)

nPosPrd  := aScan(aHeAux,{|x|x[2]="Z8_PRODUTO"})
nPosDPrd := aScan(aHeAux,{|x|x[2]="Z8_DESCPRD"})
nPosQSol := aScan(aHeAux,{|x|x[2]="Z8_QTDSOL"})
nPosTar  := aScan(aHeAux,{|x|x[2]="Z8_TAREFA"})
nPosItem := aScan(aHeAux,{|x|x[2]="AFA_ITEM"})
nPosQSld := aScan(aHeAux,{|x|x[2]="AFA_QTDSLD"})
nPosQEmp := aScan(aHeAux,{|x|x[2]="AFA_QTDEMP"})
nPosQEnt := aScan(aHeAux,{|x|x[2]="AFA_QTDENT"})

For nI := 1 To Len(aCoAux)
	If aCoAux[nI][nPosQSol] != aColOri[nI][nPosQSol]
		aCoAux[nI][nPosQEMP] += (aCoAux[nI][nPosQSol]-aColOri[nI][nPosQSol])
		aCoAux[nI][nPosQSld] -= (aCoAux[nI][nPosQSol]-aColOri[nI][nPosQSol])
	EndIf
Next
oMSNewGe1:aCols:=aCoAux

aCoAux    := aClone(oMSNewGe1:aCols)
aCopia    := aClone(oMSNewGe1:aCols)
nTamACols := Len(aCoAux)
For nI := 1 To nTamACols
	//	nPosQSol := aScan(aHeAux,{|x|x[2]="Z8_QTDSOL"})
	//	nPosTar  := aScan(aHeAux,{|x|x[2]="Z8_TAREFA"})
	If aCoAux[nI][nPosQSol] = 0.Or.Empty(aCoAux[nI][nPosTar])
		aDel(aCoAux,nI)
		nTamACols--
		aSize(aCoAux,nTamACols)
		nI--
		If nI = nTamACols
			Exit
		EndIf 
	// Alterado por Bruno Parreira 05/04/2011 (Inserido o else)	
	else
		If nI >= nTamACols
			Exit
		EndIf	
	EndIf
Next

oMSNewGe1:aCols := aClone(aCoAux)
oMSNewGe1:ForceRefresh()
If MsgBox("Deseja gerar a requisi็ใo de material para esta obra ?","Requisi็ใo de Material","YESNO")
	oMSNewGe1:aCols := aClone(aCopia)
	oMSNewGe1:Refresh()
	aHea_Sol := oMSNewGe1:aHeader
	aCol_Sol := aClone(aCopia)
	nPosPrd  := aScan(aHea_Sol,{|x|x[2]="Z8_PRODUTO"})
	nPosDPrd := aScan(aHea_Sol,{|x|x[2]="Z8_DESCPRD"})
	nPosQSol := aScan(aHea_Sol,{|x|x[2]="Z8_QTDSOL"})
	nPosTar  := aScan(aHea_Sol,{|x|x[2]="Z8_TAREFA"})
	nPosItem := aScan(aHea_Sol,{|x|x[2]="AFA_ITEM"})
	nPosQSld := aScan(aHea_Sol,{|x|x[2]="AFA_QTDSLD"})
	nPosQEmp := aScan(aHea_Sol,{|x|x[2]="AFA_QTDEMP"})  //quantidade em requisicao
   nPosQEnt := aScan(aHea_Sol,{|x|x[2]="AFA_QTDENT"})  //quantidade em pedido
   nPosQRev := aScan(aHea_Sol,{|x|x[2]="QUANT_R1"})     //quantidade revisao 0001

	lQtdExt  := .F.  //existe quantidade extra do que foi fechado no projeto deste produto
	//	cStrQExt := "OBRA : "+cCodObra+"[ "+AllTrim(cNomObra)+" ]    REVISรO : "+cRevisao+"   Projeto : "+cCodProj+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	cDetQExt := ""
	
	lExcReq := .T.  //excluir requisicao por falta de requisicao de pelo menos uma tarefa na requisicao
	For nI := 1 To Len(aCol_Sol)
		If aCol_Sol[nI][nPosQSol] > 0   //tarefa com requisicao
			If aCol_Sol[nI][nPosQEmp]+aCol_Sol[nI][nPosQEnt] > aCol_Sol[nI][nPosQRev]   //saldo da tarefa negativa
				If aCol_Sol[nI][nPosQSol] > 0.And.!Empty(aCol_Sol[nI][nPosTar]) //se quantidade requisitada for maior que zero
					lQtdExt := .T.   //existe quantidade extra requisitada
					DbSelectArea("AF9")   //tarefa do projeto
					DbSetOrder(1)
					DbSeek(xFilial("AF9")+cCodProj+cRevisao+aCol_Sol[nI][nPosTar])
					cDetQExt += "Tarefa : "+aCol_Sol[nI][nPosTar]+"[ "+AllTrim(AF9->AF9_DESCRI)+" ]"+Chr(13)+Chr(10)+;
					"   Produto : "+AllTrim(aCol_Sol[nI][nPosPrd])+" [ "+AllTrim(aCol_Sol[nI][nPosDPrd])+" ]"+Chr(13)+Chr(10)+;
					"      Qtd.Extra[Rev.0001/Req+Ped/***Excedente***]: " +Transform(Abs(aCol_Sol[nI][nPosQRev]),"@RE 999,999.99")+;
					"/"+Transform( aCol_Sol[nI][nPosQEmp]+aCol_Sol[nI][nPosQEnt],"@RE 999,999.99")+;                         
					"/***"+Transform( aCol_Sol[nI][nPosQEmp]+aCol_Sol[nI][nPosQEnt]-aCol_Sol[nI][nPosQRev],"@RE 999,999.99")+"***"+;
					"      Qtd.Requisitada : "+Transform(aCol_Sol[nI][nPosQSol],"@RE 999,999.99")+Chr(13)+Chr(10)+Chr(13)+Chr(10)
				EndIf
			EndIf
			lExcReq := .F.   //existe requisicao de uma tarefa, portanto, nao excluir a requisicao
		EndIf
	Next
	If lQtdExt
		If MsgBox("Existe(m) produto(s) que esta(ใo) sendo requisitado(s) a mais do definido no projeto"+Chr(13)+Chr(10)+;
			"Deseja alterar a quantidade deste(s) produto(s) ?", "Quantidade Extra","YESNO")
			Return.F.
		Else
			If !lManSol
				cCodigo := GetSx8Num("SZ7", "Z7_CODIGO")
				SZ7->(RollBackSX8())
			EndIf
			
			//criar a entrada da justificativa da quantidade extra
			//			cJustExtra := cStrQExt
			//		__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cJustExtra)
			//		DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
			DEFINE MSDIALOG oDlg1 TITLE "Justificativa da Quantidade Extra" From 3,0 to 530,850 FONT oFont1 PIXEL
			@ 05,05 GET oMemo  VAR cDetQExt   MEMO SIZE 415,060 OF oDlg1 FONT oFont1 PIXEL
			@ 69,05 GET oMemo  VAR cJustExtra MEMO SIZE 415,150 OF oDlg1 FONT oFont1 PIXEL
			oMemo:bRClicked := {||AllwaysTrue()}
			oMemo:oFont:=oFont1
			
			//			DEFINE SBUTTON  FROM 240,300 TYPE 1 ACTION (EnvEmaQExt(),oDlg1:End()) ENABLE OF oDlg1 PIXEL
			@ 230,270 Button bJConfQExt PROMPT "Confirmar"  When .T. Size 045,022 ;
			Action(If(!Empty(cJustExtra),(nOJConf:=1,EnvEmaQExt(),oDlg1:End()),MsgBox("Favor justificar da necessidade deste Material Extra","Justificativa de Material Extra","ALERT"))) FONT oFont1 PIXEL OF oDlg1 MESSAGE "Confirmar Justificativa da Requisi็ใo"
			@ 230,320 Button bJCancQExt PROMPT "Cancelar"   When .T. Size 045,022 Action(nOJConf:=2,oDlg1:End()) FONT oFont1 PIXEL OF oDlg1 MESSAGE "Cancelar Requisi็ใo do Material"
			
			ACTIVATE MSDIALOG oDlg1 CENTER
			
			If nOJConf == 2
				Return.F.
			EndIf
		EndIf
	EndIf
	
	If !lManSol                                //inclusao de requisicao
		If !lExcReq    //existe, pelo menos, uma tarefa a requisitar
			cCodSol := GetSx8Num("SZ7", "Z7_CODIGO")
			SZ7->(ConfirmSX8())
			RecLock("SZ7",.T.)
			SZ7->Z7_FILIAL   := xFilial("SZ7")
			SZ7->Z7_CODIGO   := cCodSol                        //codigo da requisicao
			SZ7->Z7_NECORIG  := dDtNeces
		EndIf
	Else
		RecLock("SZ7",.F.)
		If !lExcReq    //existe, pelo menos, uma tarefa a requisitar
			SZ7->Z7_ALTERA := dDataBase
		EndIf
	EndIf
	
	If !lExcReq    //existe, pelo menos, uma tarefa a requisitar
		SZ7->Z7_PROJETO  := cCodProj                       //codigo do projeto
		SZ7->Z7_OBRA     := cCodObra                       //codigo da obra
		SZ7->Z7_REVISAO  := cRevisao                       //revisao do projeto
		SZ7->Z7_CLIENTE  := cCliente                       //codigo do cliente
		SZ7->Z7_LOJA     := cLoja                          //loja do cliente
		SZ7->Z7_DATA     := dDataBase                      //data da requisicao
		SZ7->Z7_NECESS   := dDtNeces                       //data da necessidade do material na obra
		SZ7->Z7_IDUSER   := __cUserID                      //codigo do usuario no sistema
		SZ7->Z7_STATUS   := If(lQtdExt,"P","S")           //status da requisicao  S, requisicao de material P,pendente de avaliacao de quantidade extra na requisicao
		SZ7->Z7_NOMUSER  := cUserName                      //nome do usuario
		SZ7->Z7_JUSTEXT  := If(lQtdExt,cJustExtra,"")        //justificativa
		SZ7->Z7_GERADOP  := Ctod("")                       //data que gerou pedido de vendas
		//	SZ7->Z7_ESTORNO  := Ctod("")                       //data que estorno o pedido de vendas
		//  SZ7->Z7_JUSTEST  :=                                //justificativa do estorno do pedido de vendas
		SZ7->Z7_DECISAO  := Ctod("")                      //decisao de aprovacao ou reprovacao da quantidade extra na requisicao
		SZ7->Z7_NOMAPR   := ""                            //nome do aprovador
		//	SZ7->Z7_FISCAL1  := nComboBo1
		SZ7->Z7_CODFISC  := cFiscal
		SZ7->Z7_FISCAL   := cNomFisc
		cNomResp         := cNomFisc
		
		If lManSol                                //alteracao da requisicao
	      cIDFisc    := GetAdvFVal("SX5","X5_DESCSPA",xFilial("SX5")+"ZZ"+SZ7->Z7_CODFISC,1,"Nใo Cadastrado")  
	      If cIdFisc != cIdF_Orig                  
	         cEmailFOri := Busca_User(cIDF_Orig,"E")
		      cEmailFisc := Busca_User(cIDFisc,"E")
			   cNomFOri  := Busca_User(cIDF_Orig,"N")
		      cNomFisc  := Busca_User(cIDFisc,"N")  
		      			                                                                                                                                                                                                                             
 		      U_FGEN010(cEmailFisc+";"+cEmailFOri+";"+cEmailUsR+";"+cEmailAdm,         "ReqMat - Troca de Responsแvel pela Requisi็ใo [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Troca de Responsแvel pela Requisi็ใo: "+Chr(13)+Chr(10)+"De: "+cNomFOri+Chr(13)+Chr(10)+"Para: "+cNomFisc,"",.F.)
		      //U_FGEN010("bruno.parreira@actualtrend.com.br"+";"+cEmailUsR,"ReqMat - Troca de Responsแvel pela Requisi็ใo [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Troca de Responsแvel pela Requisi็ใo: "+Chr(13)+Chr(10)+"De: "+cNomFOri+Chr(13)+Chr(10)+"Para: "+cNomFisc,"",.F.)
		   EndIf   
		EndIf
	Else                                                                                                      
	   SZ7->(DbDelete())
	   
	   cIDFisc    := GetAdvFVal("SX5","X5_DESCSPA",xFilial("SX5")+"ZZ"+SZ7->Z7_CODFISC,1,"Nใo Cadastrado")  
		cEmailFisc := Busca_User(cIDFisc,"E")
			                                                                                                                                                                                                                             
		U_FGEN010(cEmailFisc+";"+cEmailUsR+";"+cEmailAdm,          "ReqMat - Requisi็ใo Excluํda [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Requisicao Exclํda","",.F.)
		//U_FGEN010("mauro.nagata@actualtrend.com.br","ReqMat - Requisi็ใo Excluํda [Req.: "+SZ7->Z7_CODIGO+"] [Obra: "+AllTrim(SZ7->Z7_OBRA)+"] [Usuแrio: "+AllTrim(cUserName)+"]","Requisicao Exclํda","",.F.)
	EndIf
	
	If (!lManSol.And.!lExcReq).Or.lManSol  //(inclusao e existe tarefa requisitada) Ou alteracao de requisicao
		For nI := 1 To Len(aCol_Sol)
			If !Empty(aCol_Sol[nI][nPosTar])
				nDifQtd := 0
				DbSelectArea("SZ8")
				DbSetOrder(1)
				//Filial                 codsol tarefa                 item                    produto
				If DbSeek(xFilial("SZ8")+cCodSol+aCol_Sol[nI][nPosTar]+aCol_Sol[nI][nPosItem]+aCol_Sol[nI][nPosPrd])
					RecLock("SZ8",.F.)
					
					If aCol_Sol[nI][nPosQSol] > 0   //quantidade requisitada
						nDifQtd := aCol_Sol[nI][nPosQSol] - SZ8->Z8_QTDSOL
						SZ8->Z8_CODIGO   := cCodSol                        //codigo da requisicao
						SZ8->Z8_PRODUTO  := aCol_Sol[nI][nPosPrd]         //codigo do produto
						SZ8->Z8_TAREFA   := aCol_Sol[nI][nPosTar]         //codigo da tarefa
						SZ8->Z8_QTDSOL   := aCol_Sol[nI][nPosQSol]        //quantidade requisitada
						SZ8->Z8_ITEM     := aCol_Sol[nI][nPosItem]        //item da tarefa
						SZ8->Z8_DESCTAR  := GetAdvFVal("AF9","AF9_DESCRI",xFilial("AF9")+cCodProj+cRevisao+aCol_Sol[nI][nPosTar],1,"Nใo Cadastrado")
						SZ8->Z8_DESCPRD  := aCol_Sol[nI][nPosDPrd]
						If aCol_Sol[nI][nPosQSld] < 0
							SZ8->Z8_QTDEXT += nDifQtd
						EndIf
						
						//DbSelectArea("AFA")
						//DbSetOrder(1)
						//DbSeek(xFilial("AFA")+cCodProj+cRevisao+aCol_Sol[nI][nPosTar]+aCol_Sol[nI][nPosItem]+aCol_Sol[nI][nPosPrd])
						
						//RecLock("AFA",.F.)
						//AFA->AFA_QTDEXT += If(Abs(aCol_Sol[nI][nPosQSld]) < aCol_Sol[nI][nPosQSol],Abs(aCol_Sol[nI][nPosQSld]),aCol_Sol[nI][nPosQSol])     //quantidade extra
						//AFA->AFA_QTDEXT += nDifQtd
						//AFA->(MsUnLock())
						
					Else  //se quantidade igual a zero, deletar o item da requisicao
						
						DbSelectArea("AFA")
						DbSetOrder(1)
						DbSeek(xFilial("AFA")+cCodProj+cRevisao+aCol_Sol[nI][nPosTar]+aCol_Sol[nI][nPosItem]+aCol_Sol[nI][nPosPrd])
						
						RecLock("AFA",.F.)
						AFA->AFA_QTDEMP -= SZ8->Z8_QTDSOL    //estornar quantidade requisitada
						//If SZ8->Z8_EXTRAPR = "S"   //quantidade extra aprovada
						//AFA->AFA_QTDAPR -= SZ8->Z8_QTDEXT   //estornar quantidade extra da quantidade aprovada
						//AFA->AFA_QTDEXT -= SZ8->Z8_QTDEXT     //quantidade extra
						//EndIf
						//AFA->AFA_QTDEXT := Abs(aCol_Sol[nI][nPosQSld])     //quantidade extra
						
						AFA->(MsUnLock())
						
						SZ8->(DbDelete())
					EndIf
					SZ8->(MsUnLock())
				Else
					If aCol_Sol[nI][nPosQSol] > 0   //quantidade requisitada
						RecLock("SZ8",.T.)
						nDifQtd := aCol_Sol[nI][nPosQSol]
						SZ8->Z8_FILIAL   := xFilial("SZ8")
						SZ8->Z8_CODIGO   := cCodSol                        //codigo da requisicao
						SZ8->Z8_PRODUTO  := aCol_Sol[nI][nPosPrd]         //codigo do produto
						SZ8->Z8_TAREFA   := aCol_Sol[nI][nPosTar]         //codigo da tarefa
						SZ8->Z8_QTDSOL   := aCol_Sol[nI][nPosQSol]        //quantidade requisitada
						SZ8->Z8_ITEM     := aCol_Sol[nI][nPosItem]        //item da tarefa
						SZ8->Z8_DESCTAR  := GetAdvFVal("AF9","AF9_DESCRI",xFilial("AF9")+cCodProj+cRevisao+aCol_Sol[nI][nPosTar],1,"Nใo Cadastrado")
						SZ8->Z8_DESCPRD  := aCol_Sol[nI][nPosDPrd]
						If aCol_Sol[nI][nPosQSld] < 0
							SZ8->Z8_QTDEXT := If(Abs(aCol_Sol[nI][nPosQSld]) < aCol_Sol[nI][nPosQSol],Abs(aCol_Sol[nI][nPosQSld]),aCol_Sol[nI][nPosQSol])
						EndIf
						
						//DbSelectArea("AFA")
						//DbSetOrder(1)
						//DbSeek(xFilial("AFA")+cCodProj+cRevisao+aCol_Sol[nI][nPosTar]+aCol_Sol[nI][nPosItem]+aCol_Sol[nI][nPosPrd])
						
						//RecLock("AFA",.F.)
						//AFA->AFA_QTDEXT += If(Abs(aCol_Sol[nI][nPosQSld]) < aCol_Sol[nI][nPosQSol],Abs(aCol_Sol[nI][nPosQSld]),aCol_Sol[nI][nPosQSol])     //quantidade extra
						//AFA->(MsUnLock())
						
						SZ8->(MsUnLock())
					EndIf
				EndIf
				
				DbSelectArea("AFA")
				DbSetOrder(1)
				DbSeek(xFilial("AFA")+cCodProj+cRevisao+aCol_Sol[nI][nPosTar]+aCol_Sol[nI][nPosItem]+aCol_Sol[nI][nPosPrd])
				
				RecLock("AFA",.F.)
				
				AFA->AFA_QTDEMP += nDifQtd
				AFA->AFA_QTDSLD := AFA->AFA_QUANT - AFA->AFA_QTDENT - AFA->AFA_QTDEMP
				AFA->(MsUnLock())
			EndIf
			
		Next
	EndIf
	SZ7->(MsUnLock())
	//	oDlg:End()
Else
	oMSNewGe1:aCols := aClone(aCopia)
	oMSNewGe1:Refresh()
	Return.F.
EndIf
Return .T.



Static Function EnvEmaQExt()

aMaterial := {}
nContExt  := 0
cTarefa01 := cTarefa02 := cTarefa03 := cTarefa04 := cTarefa05 := cTarefa06 := cTarefa07 := cTarefa08 := cTarefa09 := cTarefa10 := ""
cMat01 := cMat02 := cMat03 := cMat04 := cMat05 := cMat06 := cMat07 := cMat08 := cMat09 := cMat10 := ""
cQReq01 := cQReq02 := cQReq03 := cQReq04 := cQReq05 := cQReq06 := cQReq07 := cQReq08 := cQReq09 := cQReq10 := ""
cQPrjExt01 := cQPrjExt02 := cQPrjExt03 := cQPrjExt04 := cQPrjExt05 := cQPrjExt06 := cQPrjExt07 := cQPrjExt08 := cQPrjExt09 := cQPrjExt10 := ""
cQSolExt01 := cQSolExt02 := cQSolExt03 := cQSolExt04 := cQSolExt05 := cQSolExt06 := cQSolExt07 := cQSolExt08 := cQSolExt09 := cQSolExt10 := ""
cQAcuExt01 := cQAcuExt02 := cQAcuExt03 := cQAcuExt04 := cQAcuExt05 := cQAcuExt06 := cQAcuExt07 := cQAcuExt08 := cQAcuExt09 := cQAcuExt10 := ""
For nI := 1 To Len(aCol_Sol)
	If aCol_Sol[nI][nPosQEmp]+aCol_Sol[nI][nPosQEnt] > aCol_Sol[nI][nPosQRev]
		If aCol_Sol[nI][nPosQSol] > 0 //se quantidade requisitada for maior que zero 
				 DbSelectArea("AF9")   //tarefa do projeto
                 DbSetOrder(1)
                 DbSeek(xFilial("AF9")+cCodProj+cRevisao+aCol_Sol[nI][nPosTar])
			nContExt++
			cTar := "cTarefa"+StrZero(nContExt,2)
			cMat := "cMat"+StrZero(nContExt,2)
			cQRS := "cQReq"+StrZero(nContExt,2)
			cQPE := "cQPrjExt"+StrZero(nContExt,2)
			cQSE := "cQSolExt"+StrZero(nContExt,2)
			cAcu := "cQAcuExt"+StrZero(nContExt,2)
			&(cTar) := aCol_Sol[nI][nPosTar]+"[ "+AF9->AF9_DESCRI+" ]"
			&(cMat) := aCol_Sol[nI][nPosPrd]+" [ "+aCol_Sol[nI][nPosDPrd]+" ]"
			//&(cQSE) := Transform(aCol_Sol[nI][nPosQRev]-(aCol_Sol[nI][nPosQEmp]+aCol_Sol[nI][nPosQEnt]),"@RE 999,999.99")
			//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 07/11/2012]
			&(cQSE) := Transform(Abs(aCol_Sol[nI][nPosQRev]-(aCol_Sol[nI][nPosQEmp]+aCol_Sol[nI][nPosQEnt])),"@RE 999,999.99")
			&(cQPE) := Transform(aCol_Sol[nI][nPosQRev],"@RE 999,999.99")
			&(cQRS) := Transform( aCol_Sol[nI][nPosQSol],"@RE 999,999.99")                                                
			&(cAcu) := Transform((aCol_Sol[nI][nPosQEmp]+aCol_Sol[nI][nPosQEnt]),"@RE 999,999.99")
			If nContExt = 10
				Exit
			EndIf
		EndIf
	EndIf
Next
c_Texto := ""
fArq(cArqOrig,cArqDest)                                                              
     
cIDFisc    := GetAdvFVal("SX5","X5_DESCSPA",xFilial("SX5")+"ZZ"+cFiscal,1,"Nใo Cadastrado")  
cEmailFisc := Busca_User(cIDFisc,"E")           

cPar1   := cEmailApr +";"+cEmailUsR +";"+cEmailFisc+";"+cEmailCst+";"+cEmailAdm
//cPar1   := "luiz.henrique@actualtrend.com.br"
cPar2   := "ReqMat - Justificativa de Requisi็ใo Extra de Material [ Req:"+cCodigo+" ] [Obra:"+AllTrim(cCodObra)+"] [ Usuแrio:"+AllTrim(cUserName)+" ]"
U_FGen010(cPar1,cPar2,c_Texto,,.F.)





Static Function Bt_Act2()    //botao sair
lBt_Canc := .T.
If MsgBox("Deseja realmente abandonar a requisi็ใo de material desta obra ?","Requisi็๕a de Material","YESNO")
	Return.T.
Else
   Return .F.  
EndIf   
   





Static Function Bt_When1()
Local lRet := .F.        
Local cIDFisc

//incluido bloco abaixo [Mauro Nagata, Actual Trend, 22/08/2012]
cIDFisc := GetAdvFVal("SX5","X5_DESCSPA",xFilial("SX5")+"ZZ"+cFiscal,1,"Nใo Cadastrado")
If (cIDFisc = __cUserID .Or.SZ7->Z7_IDUSER = __cUserID  .Or. __cUserID $ cSelAss .Or. __cUserID $ cSelAdm .Or. AF8->AF8_CODF1 = __cUserID .Or. AF8->AF8_CODF2 = __cUserID .Or. SZ7->Z7_CODUSFI = __cUserID .Or. lGrpAdm) .And. cStatReq !='G' .And.cIDFisc != "Nใo Cadastrado" .And. !Empty(cIDFisc)
   lRet := .T.
EndIf   

Return lRet



Static Function NewGe001()

Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
//Local aFields := {"Z8_TAREFA","Z8_PRODUTO","Z8_DESCPRD","B1_UM","QUANT_R1","AFA_QUANT","SALDO_REV","Z8_QTDSOL","AFA_QTDSLD","AFA_QTDEMP","AFA_QTDENT","AFA_CUSTD","AFA_ITEM"}
//substituido a linha acima pela linha abaixo [Mauro Nagata, Actual Trend, 11/04/2011]	     
Local aFields := {"Z8_TAREFA","Z8_PRODUTO","Z8_DESCPRD","Z8_QTDSOL","UNID","QUANT_R1","AFA_QUANT","SALDO_REV","AFA_QTDSLD","AFA_QTDEMP","AFA_QTDENT","AFA_CUSTD","AFA_ITEM"}
Local aAlterFields := {"Z8_QTDSOL"}
Static oMSNewGe1

// Define campos
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Do Case
		   Case aFields[nX] = "AFA_QUANT"
		        Aadd(aHeaderEx, {"Rev.Atual (b)",SX3->X3_CAMPO,"@E 999999.99",SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			          SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
			Case aFields[nX] = "Z8_PRODUTO"
		        Aadd(aHeaderEx, {"Produt",SX3->X3_CAMPO,"9999999",SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			          SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})          
			Case aFields[nX] = "Z8_DESCPRD"
		        Aadd(aHeaderEx, {"Descri็ใo do Produto",SX3->X3_CAMPO,"@S30",SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			          SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})                    
         Case aFields[nX] = "Z8_QTDSOL"
		        Aadd(aHeaderEx, {"* A REQUISITAR *",SX3->X3_CAMPO,"@E 999999.99",SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			          SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})			          
			Case aFields[nX] = "AFA_QTDEMP"
		        Aadd(aHeaderEx, {"Em Requisi็ใo",SX3->X3_CAMPO,"@E 999999.99",SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			          SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})			                    
         Case aFields[nX] = "AFA_QTDSLD"
		        Aadd(aHeaderEx, {"Saldo Atual",SX3->X3_CAMPO,"@E 999999.99",SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			          SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})	                  
         Case aFields[nX] = "AFA_QTDENT"
		        Aadd(aHeaderEx, {"Em Pedido",SX3->X3_CAMPO,"@E 999999.99",SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			          SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})			                    
		Otherwise 
		        Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			          SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})	          		          
		EndCase
	Else
		Do Case
			Case aFields[nX] = "QUANT_R1"
				SX3->(DbSeek("AFA_QUANT"))
				Aadd(aHeaderEx, {"Rev.001 (a)","QUANT_R1","@E 999999.99",SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
			Case aFields[nX] = "SALDO_REV"
				SX3->(DbSeek("AFA_QUANT"))
				Aadd(aHeaderEx, {"(a) - (b)","SALDO_REV","@E 999999.99",SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
			//incluido bloco [Mauro Nagata, Actual Trend, 11/04/2011]	     
			Case aFields[nX] = "UNID"
				SX3->(DbSeek("B1_UM"))
				Aadd(aHeaderEx, {"U.M.","UM","@!",2,0,"",SX3->X3_USADO,"C","","","",""})	   	     
		    //fim bloco [Mauro Nagata, Actual Trend, 11/04/2011]		
		EndCase
	EndIf
Next nX

// Define valor ao campo
For nX := 1 to Len(aFields)
	If DbSeek(aFields[nX])
 	   aAdd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Else
       If aFields[nX] = "QUANT_R1".Or.aFields[nX] = "SALDO_REV"
   		  aAdd(aFieldFill,0)	   
       //incluido bloco [Mauro Nagata, Actual Trend, 11/04/2011]
   	   ElseIf aFields[nX] = "UNID"
   		  aAdd(aFieldFill,"  ")		    
   	   //fim bloco [Mauro Nagata, Actual Trend, 11/04/2011]  
   	   EndIf	  
	EndIf
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsEx, aFieldFill)

//oMSNewGe1 := MsNewGetDados():New( 110, 040, 306, 600,  GD_UPDATE, "U_LOkAFAT002", "cTudoOk", , aAlterFields, , 999,"U_VldCmp",,, oDlg, aHeaderEx, aColsEx)
oMSNewGe1 := MsNewGetDados():New( 110, 015, 265, 585,  GD_UPDATE, "U_LOkAFAT002", "cTudoOk", , aAlterFields, , 999,"U_VldCmp",,, oDlg, aHeaderEx, aColsEx)
//oMSNewGe1:oBrowse:bEditCol := {|| UpGe1(oMSNewGe1:nAt),oMsNewGe1:Refresh()}
oMSNewGe1:oBrowse:lUseDefaultColors := .F.
oMSNewGe1:oBrowse:SetBlkBackColor({||GETDCLR(oMSNewGe1:aCols,oMSNewGe1:nAt,aHeaderEx,aColsEx)})

Return




Static Function EnviarEmail()

cJustExtra += Chr(13)+chr(10)
U_FGEN010(c_EMailDest,If(cFilAnt = "02" ,"Playpiso","Lisonda")+" - Requisi็ใo [ "+cCodigo+" ]  Obra [ "+cCodObra+" ]",cJustExtra,cAnexo,.T.)

Return.T.



/*
Static Function UpGe1(pPos)
Local n := pPos
Local nPosQtdSol
Local nPosQtdSld
Local nPosQtdEmp

nPosQtdSol := aScan(aHeader,{|x|x[2]="Z8_QTDSOL"})
nPosQtdSld := aScan(aHeader,{|x|x[2]="AFA_QTDSLD"})
nPosQtdEmp := aScan(aHeader,{|x|x[2]="AFA_QTDEMP"})

//aCols[n][nPosQtdSld]   -= (aCols[n][nPosQtdSol] - aColOri[n][nPosQtdSol])
//aCols[n][nPosQtdEmp]   += (aCols[n][nPosQtdSol] - aColOri[n][nPosQtdSol])
//aColOri[n][nPosQtdSol] := aCols[n][nPosQtdSol]

oMsNewGe1:oBrowse:ColPos:=(oMsNewGe1:oBrowse:ColPos)
oMsNewGe1:oBrowse:nAt=(oMsNewGe1:oBrowse:nAt)+1
oMsNewGe1:oBrowse:Refresh()

Return
*/



User Function LOkAFAT002()        //validacao por linha

Local n := oMsNewGe1:nAt
Local nPosQtdSol
//Local nPosQtdSld
Local nPosQtdEmp

nPosQtdSol := aScan(aHeader,{|x|x[2]="Z8_QTDSOL"})   //quantidade requisitada
//nPosQtdSld := aScan(aHeader,{|x|x[2]="AFA_QTDSLD"})  //saldo atual
nPosQtdEmp := aScan(aHeader,{|x|x[2]="AFA_QTDEMP"})  //quantidade total em requisicao

//aCols[n][nPosQtdSld]   -= (aCols[n][nPosQtdSol] - aColOri[n][nPosQtdSol])     //saldo atual
aCols[n][nPosQtdEmp]   += (aCols[n][nPosQtdSol] - aColOri[n][nPosQtdSol])     //quantidade total em requisicao
aColOri[n][nPosQtdSol] := aCols[n][nPosQtdSol]
Return(.T.)






User Function VldCmp()
Local nQtdPrj  //quantidade do projeto
Local nPosQtdSol
Local nPosQtdSld
Local nPosQtdEmp
Local nPosQtdPrj

nPosQtdPrj := aScan(aHeader,{|x|x[2]="AFA_QUANT"})
nPosQtdSol := aScan(aHeader,{|x|x[2]="Z8_QTDSOL"})
nPosQtdSld := aScan(aHeader,{|x|x[2]="AFA_QTDSLD"})
nPosQtdEmp := aScan(aHeader,{|x|x[2]="AFA_QTDEMP"})
nPosTar    := aScan(aHeader,{|x|x[2]="Z8_TAREFA"})

If Empty(aCols[n][nPosTar])
	aCols[n][nPosQtdSol] := 0
EndIf

nQtdSol := aCols[n][nPosQtdSol]
If nQtdSol > 0    //quantidade requisitada
	nQtdPrj := aCols[n][nPosQtdPrj]
	If nQtdPrj = 0
		MsgBox("Quantidade definida deste produto no projeto estแ Zerada","Requisi็ใo de Material","ALERT")
	EndIf
EndIf

Return(.T.)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFAT002l  บAutor  ณMauro Nagata        บ Data ณ  17/01/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLegenda                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AFAT002l()

BrwLegenda(cCadastro,"Requisi็ใo de Material",;
{	{"BR_AMARELO"	,"Material Requisitado"},;
{"BR_VERMELHO"	,"Pendente de Avalia็ใo"},;
{"BR_VERDE"	    ,"Gerado Pedido"},;
{"BR_LARANJA"   ,"Aprovada a Requisi็ใo"} ,;
{"BR_PRETO"  	,"Reprovada a Requisi็ใo"},;
{"BR_BRANCO"	,"Estornado Pedido"},;
{"BR_CINZA"	    ,"Expirada Dt.Necessidade"}    })

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFGEN008a  บAutor  ณAlexandre Sousa     บ Data ณ  04/13/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao generica para mostrar o resultado de uma query.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณc_Query: Query a ser excutada para obter informacoes.       บฑฑ
ฑฑบ          ณa_campos:Array contendo uma coluna com a descricao dos cam- บฑฑ
ฑฑบ          ณpos que sera mostrada na List, e outra contendo o nome dos  บฑฑ
ฑฑบ          ณcampos que serao retornados pela query.                     บฑฑ
ฑฑบ          ณc_tit: Titulo da janela.                                    บฑฑ
ฑฑบ          ณn_pos: Posicao do campo a ser retornado pela consulta.      บฑฑ
ฑฑบ          ณc_Ret: String com o valor do campo informado.               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FGEN008a(c_Query, a_campos, c_tit, n_pos)

Local aSalvAmb := GetArea()
Local aVetor   := {}
Local cTitulo  := Iif( c_tit = Nil, "Tํtulo", c_tit)
Local nPos		:= Iif(n_pos = Nil, 1, n_pos)
Local n_x		:= 0
Local c_Lst		:= ''
//	Local c_Query := "select distinct EA_FILIAL, EA_NUMBOR from "+RetSqlName("SEA")+" where EA_FILIAL = '"+xFilial("SEA")+"' EA_CART = 'R' and D_E_L_E_T_ <> '*'"
//	Local a_campos := {{"Filial", "Bordero" }, {"EA_FILIAL", "EA_NUMBOR"}}
//	Local c_tit := "Consulta de Borderos"

Private oDlg	:= Nil
Private oLbx	:= Nil
Private c_Ret	:= ''

If Select("QRX") > 0
	DbSelectArea("QRX")
	DbCloseArea()
EndIf
TcQuery c_Query New Alias "QRX"

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
While QRX->(!EOF())
	aAdd(aVetor, Array(len(a_campos[2])))
	
	For n_x := 1 to len(a_campos[2])
		aVetor[len(aVetor),n_x] := &("QRX->"+a_campos[2,n_x])
	Next
	QRX->(dbSkip())
End

If Len( aVetor ) == 0
	Aviso( cTitulo, "Nao existe dados para a consulta", {"Ok"} )
	Return
Endif

//+-----------------------------------------------+
//| Limitado a dez colunas                        |
//+-----------------------------------------------+
c_A := IIf(len(a_campos[1])>=1,a_campos[1,1],'' )
c_B := IIf(len(a_campos[1])>=2,a_campos[1,2],'' )
c_C := IIf(len(a_campos[1])>=3,a_campos[1,3],'' )
c_D := IIf(len(a_campos[1])>=4,a_campos[1,4],'' )
c_E := IIf(len(a_campos[1])>=5,a_campos[1,5],'' )
c_F := IIf(len(a_campos[1])>=6,a_campos[1,6],'' )
c_G := IIf(len(a_campos[1])>=7,a_campos[1,7],'' )
c_H := IIf(len(a_campos[1])>=8,a_campos[1,8],'' )
c_I := IIf(len(a_campos[1])>=9,a_campos[1,9],'' )
c_J := IIf(len(a_campos[1])>=10,a_campos[1,10],'' )

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 300,500 PIXEL
@ 010,010 LISTBOX oLbx FIELDS HEADER c_A, c_B, c_C, c_D, c_E, c_F, c_G, c_H, c_I, c_J On DBLCLICK (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) SIZE 230,095 OF oDlg PIXEL	ColSizes 20,20,20,20,20,20,20,20,20,20

oLbx:SetArray( aVetor )

c_Lst := '{|| {aVetor[oLbx:nAt,1],'
For n_x := 2 to len(a_campos[2])-1
	c_Lst += '     aVetor[oLbx:nAt,'+Str(n_x)+'],'
Next
c_Lst += '    aVetor[oLbx:nAt,'+Str(len(a_campos[2]))+']}}'

oLbx:bLine := &c_Lst
c_Ret := &c_Lst

//DEFINE SBUTTON FROM 107,180 TYPE 1 ACTION (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) ENABLE OF oDlg  ONSTOP "Confirmar Requisi็ใo"
//DEFINE SBUTTON FROM 107,210 TYPE 4 ACTION (c_Ret := "InclSol", oDlg:End()) ENABLE OF oDlg ONSTOP "Incluir uma nova Requisi็ใo"
//DEFINE SBUTTON FROM 107,014 TYPE 3 ACTION (c_Ret := "ExcSol", oDlg:End()) WHEN .F. ENABLE OF oDlg ONSTOP "Excluir esta Requisi็ใo"

@ 118,095 Button bAprvQExt  PROMPT "Editar Requisi็ใo"  When .T. Size 060,020 Action(c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) PIXEL OF oDlg MESSAGE "Editar Requisi็ใo Selecionada"
@ 118,175 Button bReprvQExt PROMPT "Nova Requisi็ใo"    When .T. Size 060,020 Action(c_Ret := "InclSol", oDlg:End())                    PIXEL OF oDlg MESSAGE "Incluir uma Nova Requisi็ใo"
@ 118,014 Button bSairQExt  PROMPT "Excluir Requisi็ใo" When .T. Size 055,015 Action(c_Ret := "ExcSol",Alert("Rotina em desenvolvimento"), oDlg:End())                     PIXEL OF oDlg MESSAGE "Excluir a Requisi็ใo Selecionada"



ACTIVATE MSDIALOG oDlg Centered

RestArea( aSalvAmb )

Return c_Ret



User Function AFAT002g()   //gerar pedido de vendas
Local   nOpca    := 0
Local   aCampos  := {}
Local   aCabPv   := {}
Local   aItens   := {}
Local   cUM
Local   cCondPag
Local   nPrcVen
Local   cTes
Local   dDtNecess
Local   lMsErroAuto := .F.
Local   cCliente
Local   cLoja
Local   cEstado         
Local   n_Ret := .F.
Private cArqTmp
Private cArqInd
Private cMarca      := GetMark()
Private cPerg       := "AFAT002"


If !(__cUserID$cUserGPV+cUserAdm).And.!lGrpAdm
	MsgBox("Acesso restrito!!! Contate o Administrador de Sistema [ MV_USGPVRM ]","Requisi็ใo de Material","INFO")
	Return
EndIf

ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf

AF002gTRB()

aAdd(aCampos,{"Z7_OK",""  ,"Gerar PV",""})
aAdd(aCampos,{"Z7_NECESS" ,"","Necessidade","@D"})
aAdd(aCampos,{"Z7_CODIGO" ,"","Cod.Requis.","@!"})
aAdd(aCampos,{"Z7_OBRA"   ,"","Obra","@!"})
aAdd(aCampos,{"DESCOBRA"  ,"","Descri็ใo","@!"})
aAdd(aCampos,{"Z7_CLIENTE","","Cliente","@!"})
aAdd(aCampos,{"Z7_LOJA"   ,"","Loja","@!"})
aAdd(aCampos,{"RAZSOC"    ,"","Razใo Social","@!"})
aAdd(aCampos,{"Z7_PROJETO","","Projeto","@!"})
aAdd(aCampos,{"Z7_FISCAL" ,"","Fiscal","@!"})

DEFINE MSDIALOG oDlg TITLE "Selecione as requisi็๕es para gera็ใo dos pedidos" FROM 3,0 To 40,145 OF oMainWnd   //"Selecione os clientes para gera็ใo dos tํtulos definitivos"
SZ7TRB->(Dbgotop())
oMark:=MsSelect():New("SZ7TRB","Z7_OK",,aCampos,,cMarca,{3,3,230,570})
oMark:bMark := { | |  MrkSelPV(cMarca)}
//oMark:bAval := { | | ValSelPV()}
oMark:oBrowse:lhasMark := .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := {|| AF002Inv(cMarca,@oMark)}

@ 250, 250 BUTTON oBGPV1  PROMPT "Visualizar" SIZE 050, 020 OF oDlg ACTION (Bt_GPV1())              WHEN .T.  PIXEL //Bt_When1() PIXEL
@ 250, 380 BUTTON oBGPV2  PROMPT "Gerar"      SIZE 050, 020 OF oDlg ACTION (nOpca := 1,oDlg:End())  WHEN .T.  PIXEL //Bt_When1() PIXEL
@ 250, 450 BUTTON oBGPV3  PROMPT "Sair"       SIZE 050, 020 OF oDlg ACTION (oDlg:End())             WHEN .T.  PIXEL //Bt_When1() PIXEL

//DEFINE SBUTTON FROM 220,420 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
//DEFINE SBUTTON FROM 220,450 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	/*
	//em reuniao com sr.Fabio, diretor, nao sera avaliado se os produtos que constarao no pedido de vendas tenham ou nao estoque [FEV/2011]
	*/
	
	If MsgBox("Deseja gerar o pedido para esta(s) requisi็ใo(๕es) ?","Gerar Pedido","YESNO")
		SA1->(DbSeek(xFilial("SA1")+SZ7TRB->Z7_CLIENTE+SZ7TRB->Z7_LOJA))
		AFA->(DbSeek(xFilial("AFA")+SZ7TRB->Z7_PROJETO))
		AF8->(DbSetOrder(1))
		AF8->(DbSeek(xFilial("AF8")+SZ7TRB->Z7_PROJETO))
		AEA->(DbSetOrder(1))
		AEA->(DbSeek(xFilial("AEA")+AF8->AF8_FASE))
		cCondPag := SA1->A1_COND
		cTabela  := SA1->A1_TABELA
		cEstado  := SA1->A1_EST
		Do Case
			//Case cEstado = "SP" .And.cFilAnt = "01"       //quando empresa Lisonda e pedido para o estado de sp
			//substituida a linha acima pela linha abaixo [Mauro Nagata, Actual Trend, 28/04/2011]
			Case cEstado = "SP" .And.cFilAnt = "01"       //quando empresa Lisonda e pedido para o estado de sp
				cCliente := "000607"
				//cLoja    := "02"
				//substituido linha acima pela abaixo [Luiz Henrique, Actual Trend, 20160923]
				cLoja    := "03"
			Case cEstado = "SP" .And.cFilAnt = "02"      //quando empresa PlayPiso e pedido para o estado de sp
				cCliente := "000611"
				cLoja    := "01"
			//Case cEstado = "RJ" .And.(cFilAnt = "01" .Or. cFilAnt = "03")  //quando empresa Lisonda ou PlayPiso e pedido para o estado do rj
			//substituida a linha acima pela linha abaixo [Mauro Nagata, Actual Trend, 28/04/2011]
			Case cEstado = "RJ" .And.(cFilAnt = "01" .Or. cFilAnt = "03")  //quando empresa Lisonda ou PlayPiso e pedido para o estado do rj
				cCliente := "200120"
				cLoja    := "01"
			Otherwise                         //demais pedido utilizar o cliente do projeto
				cCliente := SZ7TRB->Z7_CLIENTE
				cLoja    := SZ7TRB->Z7_LOJA
		EndCase
		
		DbSelectArea("SZ7TRB")
		DbGoTop()
		Do While !Eof()
			If Empty(SZ7TRB->Z7_OK)
				DbSkip()
				Loop
			EndIf
			DbSelectArea("SC5")
			cNroPed := GetSX8Num("SC5","C5_NUM",,1)
			RollBackSX8()
			
			aCabPv:={}
			aAdd(aCabPv,{"C5_NUM"       ,cNroPed          , nil})
			aAdd(aCabPv,{"C5_TIPO"      , "N"             , Nil})
			aAdd(aCabPv,{"C5_CLIENTE"   , cCliente        , Nil})
			aAdd(aCabPv,{"C5_LOJACLI"   , cLoja           , Nil})
			aAdd(aCabPv,{"C5_TRANSP"    , "000055"        , Nil})
			aAdd(aCabPv,{"C5_TIPOCLI"   , "F"             , Nil})
			aAdd(aCabPv,{"C5_TABELA"    , cTabela         , Nil})
			aAdd(aCabPv,{"C5_CONDPAG"   , "001"           , Nil})
			aAdd(aCabPv,{"C5_EMISSAO"   ,dDataBase        , nil})
			aAdd(aCabPv,{"C5_TPFRETE"   ,"C"              , nil})
			aAdd(aCabPv,{"C5_TIPLIB"    ,"1"              , nil})
			aAdd(aCabPv,{"C5_MOEDA"     ,1                , nil})
			aAdd(aCabPv,{"C5_XPEDFIN"   ,"N"              , nil})
			aAdd(aCabPv,{"C5_CCUSTO"    , SZ7TRB->Z7_OBRA , nil})
			aAdd(aCabPv,{"C5_XPEDFIN"   , "N"             , nil})
			
			dNecess := SZ7TRB->Z7_NECESS
			aItens  := {}
			DbSelectArea("SZ8")
			DbSetOrder(1)
			DbSeek(xFilial("SZ8")+SZ7TRB->Z7_CODIGO)
			nK := '00'
			Do While SZ7TRB->(!EOF()).And.SZ8->Z8_CODIGO = SZ7TRB->Z7_CODIGO
				cUM     := GetAdvFVal("SB1", "B1_UM", xFilial("SB1")+SZ8->Z8_PRODUTO, 1, "")
				nPrcVen := GetAdvFVal("SB1", "B1_CUSTD", xFilial("SB1")+SZ8->Z8_PRODUTO, 1, "")
				//cTes    := GetAdvFVal("SB1", "B1_TS", xFilial("SB1")+SZ8->Z8_PRODUTO, 1, "")
				
				//segundo o sr.Fabio, Lisonda, nao existe venda pela Lisonda RJ
				Do Case
					Case cEstado = "SP"     //remessa dentro de sp
						//cTes := "520"
						//substituida linha acima pela abaixo em razao de ter sido mudado de ST ICMS de 90 para 41, conforme orientacao da Kanaan [Mauro Nagata, Actual Tren, 20160120]
						cTes := "560"
					Case cEstado != "SP"    //remessa fora de sp
						//cTes := "521"
						//substituida linha acima pela abaixo em razao de ter sido mudado de ST ICMS de 90 para 41, conforme orientacao da Kanaan [Mauro Nagata, Actual Tren, 20160119]
						cTes := "561"
				EndCase
				
				nK := Soma1(nK,2)
				
				aAdd(aItens,{{"C6_ITEM"     , nK   , Nil},;
				{"C6_PRODUTO"  , SZ8->Z8_PRODUTO      	 , Nil},;
				{"C6_UM"       , cUM			       	 , Nil},;
				{"C6_QTDVEN"   , SZ8->Z8_QTDSOL  		 , Nil},;
				{"C6_TES"      , cTes           		 , Nil},;
				{"C6_LOCAL"    , "01"	        	   	 , Nil},;
				{"C6_ENTREG"   , dNecess         		 , Nil},;
				{"C6_PEDCLI"   , SZ7TRB->Z7_CODIGO       , nil},;
				{"C6_PRUNIT"   , nPrcVen          		 , Nil},;
				{"C6_VALDESC"  , 0                       , nil},;
				{"C6_LOJA"     , SZ7TRB->Z7_LOJA        , nil},;
				{"C6_NUM"	   , cNroPed                 , nil},;
				{"C6_CLI"	   , SZ7TRB->Z7_CLIENTE      , nil},;
				{"C6_PROJPMS"  , SZ7TRB->Z7_PROJETO  	 , Nil},;
				{"C6_EDTPMS"   , ""              	   	 , Nil},;
				{"C6_TASKPMS"  , SZ8->Z8_TAREFA    	   	 , Nil},;
				{"C6_CCUSTO"   , SZ7TRB->Z7_OBRA      	   	 , Nil}})
				
				SZ8->(DbSkip())
			EndDo
			
			Begin Transaction
			MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPV,aItens,3)  //gera pedido de vendas  
			              
			If lMsErroAuto
				Mostraerro()
				MsgAlert("Pedido nใo gerado!!! Houve algum erro na geracao do pedido desta requisicao - AFAT002")
				DisarmTransaction()  
				SZ7TRB->(DbCloseArea())
				fErase(cArqTmp+GetDBExtension())
				fErase(cArqInd+OrdBagExt())
				Return
			EndIf      
			      
			DbSelectArea("SC5")
			DbSetOrder(1)
			
			If !DbSeek(xFilial("SC5")+cNroPed)
				Mostraerro()
				MsgInfo("Pedido nใo gerado!!! Houve algum erro na geracao do pedido. Verifique o cadastro dos produtos requisitados e tente novamente.")
				DisarmTransaction()
				SZ7TRB->(DbCloseArea())
				fErase(cArqTmp+GetDBExtension())
				fErase(cArqInd+OrdBagExt())
				Return  
			Else			
				DbSelectArea("SZ7")     //requisicao de material
				DbSetOrder(1)
				DbSeek(xFilial("SZ7")+SZ7TRB->Z7_CODIGO)       //codigo da requisicao
				RecLock("SZ7",.F.)
				SZ7->Z7_STATUS  := "G"
				SZ7->Z7_GERADOP := dDataBase
				SZ7->Z7_PEDIDO  := cNroPed
				SZ7->(MsUnLock())
				
				DbSelectArea("SZ8")  //itens da requisicao de material
				DbSetOrder(1)
				DbSeek(xFilial("SZ8")+SZ7TRB->Z7_CODIGO)              //codigo da requisicao
				Do While !Eof().And.SZ7TRB->Z7_CODIGO = SZ8->Z8_CODIGO
					DbSelectArea("AFA")          //recursos do projeto
					DbSetOrder(1)
					If DbSeek(xFilial("AFA")+SZ7->Z7_PROJETO+SZ7->Z7_REVISAO+SZ8->Z8_TAREFA+SZ8->Z8_ITEM+SZ8->Z8_PRODUTO)
						RecLock("AFA",.F.)
						AFA->AFA_QTDEMP -= SZ8->Z8_QTDSOL   //subtrai a quantidade requisitada do saldo de quantidade requisitada
						AFA->AFA_QTDENT += SZ8->Z8_QTDSOL   //soma a quantidade requisitada ao saldo de quantidade de pedido
						AFA->(MsUnLock())
					EndIf
					
					DbSelectArea("SZ8")
					DbSkip()  
				EndDo      
			EndIf	
			End Transaction
			
			DbSelectArea("SZ7TRB")
			DbSkip() 
		EndDo
	EndIf
Endif

DbSelectArea("SZ7TRB")
DbCloseArea()
fErase(cArqTmp+GetDBExtension())
fErase(cArqInd+OrdBagExt())
Return





Static Functio Bt_GPV1()  //botao gera pedido de vendas

cCodReq := SZ7TRB->Z7_CODIGO
cQuery  := "SELECT Z8_PRODUTO, Z8_QTDSOL, Z8_DESCPRD "
cQuery  += "FROM SZ8010 AS Z8 "
cQuery  += "WHERE Z8_CODIGO = '"+cCodReq+"' "
cQuery  += "      AND Z8.D_E_L_E_T_ = '' "

cObPN   := U_FGEN008(cQuery , {{ "Qt.Req.", "Produto", "Descri็ใo"}, {"Z8_QTDSOL", "Z8_PRODUTO", "Z8_DESCPRD"}}, "Visualiza็ใo dos Materiais da Requisi็ใo", 1)

Return.T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ Mauro Nagata       บ Data ณ  18/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01              Codigo da Obra     	                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Do Codigo da Obra  ? ","","","MV_CH1","C",10,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Codigo da Obra ? ","","","MV_CH2","C",10,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Da Data de Necess. ? ","","","MV_CH3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate Data de Necess.? ","","","MV_CH4","D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do Cod.Requisi็ใo ?  ","","","MV_CH5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate C๓digo Requis.?  ","","","MV_CH6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(_sAlias)

Return Nil







Static Function AF002gTRB(cAlias,cIndex,cChave,cFor)  //gerar pedido

Local aCampos   := {}
Private cFiltro := ""

aAdd(aCampos,{"Z7_OK"     ,"C",2,0})
aAdd(aCampos,{"Z7_NECESS" ,"D",8,0})
aAdd(aCampos,{"Z7_CODIGO" ,"C",6,0})
aAdd(aCampos,{"Z7_OBRA"   ,"C",9,0})
aAdd(aCampos,{"DESCOBRA"  ,"C",40,0})
aAdd(aCampos,{"Z7_CLIENTE","C",6,0})
aAdd(aCampos,{"Z7_LOJA"   ,"C",2,0})
aAdd(aCampos,{"RAZSOC"    ,"C",40,0})
aAdd(aCampos,{"Z7_PROJETO","C",10,0})
aAdd(aCampos,{"Z7_FISCAL ","C",10,0})



//AADD(aCampos,{"Z8_PRODUTO","C",15,0})
//AADD(aCampos,{"Z8_QTDSOL","N",9,2})


cQuery := "SELECT ' ' AS Z7_OK, "
cQuery += "Convert(VarChar(10),Cast(Z7_NECESS as DateTime),103) AS Z7_NECESS, "
cQuery += "Z7_CODIGO, Z7_OBRA, CTT_DESC01 AS DESCOBRA, Z7_CLIENTE, Z7_LOJA, A1_NREDUZ AS RAZSOC, Z7_PROJETO, Z7_FISCAL "
cQuery += "FROM "+	RetSqlName("SZ7")+" AS Z7 "
cQuery += "INNER JOIN CTT010 AS CTT "
cQuery += "      ON   CTT_CUSTO  = Z7_OBRA "
cQuery += "           AND CTT.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN SA1010 AS A1 "
cQuery += "      ON   A1_COD  = Z7_CLIENTE "
cQuery += "           AND A1_LOJA  = Z7_LOJA "
cQuery += "           AND A1.D_E_L_E_T_ = '' "
//cQuery += "INNER JOIN SZ6010 AS Z6 "
//cQuery += "      ON   Z6_CODFIS = Z7_CODFISC"
//cQuery += "           AND Z6.D_E_L_E_T_ = '' "
cQuery += "WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' "
cQuery += "      AND Z7_NECESS BETWEEN '"+ Dtos(MV_PAR03) +"' AND '"+ Dtos(MV_PAR04) + "' "
cQuery += "      AND Z7_OBRA   BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 + "' "
cQuery += "      AND Z7_CODIGO BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 + "' "
cQuery += "      AND Z7_GERADOP = '' "
cQuery += "      AND Z7_STATUS NOT IN ( 'P', 'G', 'R' ) "    //P, pendente de avaliacao da qtd.extra; G, PV gerado; R, requisicao rejeitada
//cQuery += "      AND Z7_NECESS >= '"+ Dtos(dDatabase)+"' "
cQuery += "      AND Z7.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY Z7_NECESS, Z7_OBRA

cQuery := ChangeQuery(cQuery)

MemoWrite("AFAT002g.SQL",cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "SZ7TMP", .F., .T.)

Dbselectarea("SZ7TMP")
cAlias  := "SZ7TRB"
cArqTmp := CriaTrab(aCampos,.t.)
dbUseArea(.T.,,cArqTmp,cAlias,.F.)

cArqInd := CriaTrab(Nil,.F.)
IndRegua(cAlias,cArqInd,"Dtos(Z7_NECESS)+Z7_OBRA",,cFiltro,"Preparando Registros . . .")

DbSelectArea(cAlias)
DbSetOrder(1)
DbGoTop()


DbselectArea("SZ7TMP")
DbGoTop()
Do While !SZ7TMP->(Eof())
	/*
	//   If !Empty(SZ7->Z7_GERADOP).Or.SZ7TRB->Z7_NECESS < MV_PAR03.Or.SZ7TRB->Z7_NECESS > MV_PAR04.Or.SZ7TRB->Z7_OBRA < MV_PAR01.And.SZ7TRB->Z7_OBRA > MV_PAR02.Or.SZ7TRB->Z7_NECESS < dDataBase
	//      DbSkip()
	//      Loop
	//   EndIf
	DbSelectArea("AF9")
	DbSetOrder(1)
	If DbSeek(xFilial("AF9")+SZ7->Z7_PROJETO+SZ7->Z7_REVISAO)
	DbSelectArea("CTT")
	If DbSeek(xFilial("CTT")+SZ7->Z7_OBRA)
	cNomObra := AllTrim(CTT->CTT_DESC01)
	EndIf
	EndIf
	*/
	RecLock("SZ7TRB",.T.)
	SZ7TRB->Z7_NECESS  := Ctod(SZ7TMP->Z7_NECESS)
	SZ7TRB->Z7_CODIGO  := SZ7TMP->Z7_CODIGO
	SZ7TRB->Z7_OBRA    := SZ7TMP->Z7_OBRA
	SZ7TRB->Z7_PROJETO := SZ7TMP->Z7_PROJETO
	//	SZ7TRB->DESCOBRA   := cNomObra
	SZ7TRB->DESCOBRA   := SZ7TMP->DESCOBRA
	SZ7TRB->Z7_CLIENTE := SZ7TMP->Z7_CLIENTE
	SZ7TRB->Z7_LOJA    := SZ7TMP->Z7_LOJA
	//	SZ7TRB->RAZSOC     := GetAdvFVal("SA1","A1_NOME","xFilial('SA1')+SZ7->Z7_CLIENTE+SZ7->Z7_LOJA)",1,"Cliente nao encontrado")
	SZ7TRB->RAZSOC     := SZ7TMP->RAZSOC
	SZ7TRB->Z7_FISCAL := SZ7TMP->Z7_FISCAL
	//	SZ7TRB->NOMFIS1 := GetAdvFVal("SZ6","Z6_NOME","xFilial('SZ6')+SZ7->Z7_FISCAL",1,"Fiscal nao cadastrado")
	
	SZ7TRB->(MsUnLock())
	SZ7TMP->(DbSkip())
	
	/*
	DbSelectArea("SZ8")
	DbSeek(xFilial("SZ8")+SZ7->Z7_CODIGO)
	Do While !Eof().And.xFilial("SZ7")+SZ7->Z7_CODIGO==xFilial("SZ8")+SZ8->Z8_CODIGO
	SZ7TRB->Z8_PRODUTO := SZ8->Z8_PRODUTO
	SZ7TRB->Z8_QTDSOL  := SZ8->Z8_QTDSOL
	DbSkip()
	EndDo
	
	SZ7TRB->(MsUnLock())
	*/
Enddo

DbSelectArea("SZ7TMP")
//DbClearFilter()
DbCloseArea()

//DbSelectArea("SZ7")
//DbSetOrder(1)

Return





Static Function AF002aTRB(cAlias,cIndex,cChave,cFor)  //avaliar requisicao

Local aCampos   := {}
Private cFiltro := ""

aAdd(aCampos,{"Z7_OK"     ,"C",2,0})
aAdd(aCampos,{"STATUS"    ,"C",9,0})
aAdd(aCampos,{"Z7_OBRA"   ,"C",9,0})
aAdd(aCampos,{"Z7_CODIGO" ,"C",6,0})
aAdd(aCampos,{"Z7_NECESS" ,"D",8,0})
aAdd(aCampos,{"DESCOBRA"  ,"C",40,0})
aAdd(aCampos,{"Z7_CLIENTE","C",6,0})
aAdd(aCampos,{"Z7_LOJA"   ,"C",2,0})
aAdd(aCampos,{"RAZSOC"    ,"C",40,0})
aAdd(aCampos,{"Z7_PROJETO","C",10,0})
aAdd(aCampos,{"Z7_FISCAL" ,"C",10,0})
//aAdd(aCampos,{"Z7_STATUS","C",1,0})


cQuery := "SELECT ' ' AS Z7_OK, CASE WHEN Z7_STATUS = 'P' THEN 'Pendente' WHEN Z7_STATUS = 'A' THEN 'Aprovada' WHEN Z7_STATUS = 'R' THEN 'Reprovada' End AS STATUS, "
cQuery += "Convert(VarChar(10),Cast(Z7_NECESS as DateTime),103) AS Z7_NECESS, Z7_CODIGO, Z7_OBRA, CTT_DESC01 AS DESCOBRA, Z7_CLIENTE, Z7_LOJA, A1_NREDUZ AS RAZSOC, Z7_PROJETO, Z7_FISCAL, Z7_STATUS " //, Z6_NOME AS NOMFIS1 "
cQuery += "FROM "+	RetSqlName("SZ7")+" AS Z7 "
cQuery += "INNER JOIN CTT010 AS CTT "
cQuery += "      ON   CTT_CUSTO  = Z7_OBRA "
cQuery += "           AND CTT.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN SA1010 AS A1 "
cQuery += "      ON   A1_COD  = Z7_CLIENTE "
cQuery += "           AND A1_LOJA  = Z7_LOJA "
cQuery += "           AND A1.D_E_L_E_T_ = '' "
cQuery += "WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' "
cQuery += "      AND Z7_NECESS BETWEEN '"+ Dtos(MV_PAR03) +"' AND '"+ Dtos(MV_PAR04) + "' "
cQuery += "      AND Z7_OBRA   BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 + "' "
cQuery += "      AND Z7_CODIGO BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 + "' "
cQuery += "      AND Z7_GERADOP = '' "
cQuery += "      AND (Z7_STATUS IN ( 'P','R' ) OR (Z7_STATUS = 'A' AND Z7_PEDIDO = '')) "   //P, pendente de avaliacao da qtd.extra
//cQuery += "      AND Z7_STATUS IN ( 'P' ) "   //P, pendente de avaliacao da qtd.extra
cQuery += "      AND Z7_NECESS >= '"+ Dtos(dDatabase)+"' "
cQuery += "      AND Z7.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY Z7_CODIGO, Z7_OBRA

cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "SZ7TMP", .F., .T.)

Dbselectarea("SZ7TMP")
cAlias  := "SZ7TRB"
cArqTmp := CriaTrab(aCampos,.t.)
dbUseArea(.T.,,cArqTmp,cAlias,.F.)

DbSelectArea(cAlias)
//DbSetOrder(1)
DbGoTop()


DbselectArea("SZ7TMP")
DbGoTop()
Do While !SZ7TMP->(Eof())
	RecLock("SZ7TRB",.T.)
	SZ7TRB->Z7_NECESS  := Ctod(SZ7TMP->Z7_NECESS)
	SZ7TRB->STATUS    := SZ7TMP->STATUS
	SZ7TRB->Z7_CODIGO  := SZ7TMP->Z7_CODIGO
	SZ7TRB->Z7_OBRA    := SZ7TMP->Z7_OBRA
	SZ7TRB->Z7_PROJETO := SZ7TMP->Z7_PROJETO
	//	SZ7TRB->DESCOBRA   := cNomObra
	SZ7TRB->DESCOBRA   := SZ7TMP->DESCOBRA
	SZ7TRB->Z7_CLIENTE := SZ7TMP->Z7_CLIENTE
	SZ7TRB->Z7_LOJA    := SZ7TMP->Z7_LOJA
	//	SZ7TRB->RAZSOC     := GetAdvFVal("SA1","A1_NOME","xFilial('SA1')+SZ7->Z7_CLIENTE+SZ7->Z7_LOJA)",1,"Cliente nao encontrado")
	SZ7TRB->RAZSOC     := SZ7TMP->RAZSOC
	SZ7TRB->Z7_FISCAL := SZ7TMP->Z7_FISCAL
	//	SZ7TRB->NOMFIS1 := GetAdvFVal("SZ6","Z6_NOME","xFilial('SZ6')+SZ7->Z7_FISCAL",1,"Fiscal nao cadastrado")
	
	SZ7TRB->(MsUnLock())
	SZ7TMP->(DbSkip())
	
Enddo

DbSelectArea("SZ7TMP")
//DbClearFilter()
DbCloseArea()

//DbSelectArea("SZ7")
//DbSetOrder(1)

Return







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFAT002InvบAutor  ณMauro Nagata        บ Data ณ  10/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInverte e grava a marcacao na markBrowse                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico LISONDA.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AF002Inv(cMarca,oMark)
Local nReg := SZ7TRB->(Recno())

DbSelectArea("SZ7TRB")
DbGoTop()
Do While !Eof()
	RecLock("SZ7TRB")
	IF Z7_OK == cMarca
		SZ7TRB->Z7_OK := "  "
	Else
		SZ7TRB->Z7_OK := cMarca
		If SZ7TRB->Z7_NECESS < dDataBase
			MsgBox("Data de necessidade [ "+Dtoc(SZ7TRB->Z7_NECESS)+" ] da Requisi็ใo estแ expirada","Requisi็ใo de Material","ALERT")
			SZ7TRB->Z7_OK := "  "
		EndIf
		
		cStr2C := Substr(SZ7TRB->Z7_OBRA,1,2)
		cStr3C := Substr(SZ7TRB->Z7_OBRA,3,1)
		If cStr2C $ "SP.PP.RJ"
			//If ((cStr2C = "SP" .Or. cStr2C = "RJ" ) .And.cFilAnt != "01").Or.(cStr2C = "PP" .And.cFilAnt != "02").Or.(cStr2C = "RJ" .And.cFilAnt != "03")			
			//substituida a linha acima pela linha abaixo [Mauro Nagata, Actual Trend, 28/04/2011]                                                         
			If ((cStr2C = "SP" .Or. cStr2C = "RJ" ) .And.cFilAnt != "01").Or.(cStr2C = "PP" .And.cFilAnt != "02")
				MsgBox("Requisi็ใo de Material selecionado nใo pode ser gerado pedido nesta empresa","Requisi็ใo de Material","INFO")
				SZ7TRB->Z7_OK := "  "
			EndIf
		Else
			//If ((cStr3C = "L" .Or. cStr3C = "R").And.cFilAnt != "01").Or.(cStr3C = "P" .And.cFilAnt != "02")
			//substituida a linha acima pela linha abaixo [Mauro Nagata, Actual Trend, 28/04/2011]                                                         
			If ((cStr3C = "L" .Or. cStr3C = "R").And.cFilAnt != "01").Or.(cStr3C = "P" .And.cFilAnt != "02")
				MsgBox("Requisi็ใo de Material selecionado nใo pode ser gerado pedido nesta empresa","Requisi็ใo de Material","INFO")
				SZ7TRB->Z7_OK := "  "
			EndIf
		EndIf
	Endif
	DbSkip()
Enddo
SZ7TRB->(dbGoto(nReg))
oMark:oBrowse:Refresh(.t.)

Return Nil



Static Function GETDCLR(aLinha,nLinha,aHeader)

Local nCor2 	 := 8454016      //verde       //8454143     //amarelo
Local nCor3 	 := 16702938     //azul claro
Local nCor4      := 8454143      //amarelo    //255          //vermelho
Local nCor5      := 4210943      //vermelho   //16512        //marron
Local nCor6      := 4227327      //laranja
Local nCor7      := 15790320     //16777215 branco
Local nCor8      := 43176        //cobre
Local nPosQtdPrj := aScan(aHeader,{|x|x[2]="AFA_QUANT"})
Local nPosQtdR1  := aScan(aHeader,{|x|x[2]="QUANT_R1"})    //quantidade revisao 01
Local nPosSldRev := aScan(aHeader,{|x|x[2]="SALDO_REV"})    //saldo revisao 01
Local nPosQtdSol := aScan(aHeader,{|x|x[2]="Z8_QTDSOL"})    //quantidade requisitada
Local nPosQtdSld := aScan(aHeader,{|x|x[2]="AFA_QTDSLD"})   //saldo atual
Local nPosQtdEmp := aScan(aHeader,{|x|x[2]="AFA_QTDEMP"})   //quantidade total em requisicao
Local nPosQtdEnt := aScan(aHeader,{|x|x[2]="AFA_QTDENT"})   //quantidade total em pedido de vendas
Local nPosPrd    := aScan(aHeader,{|x|x[2]="Z8_PRODUTO"})
//Local nPosQtdExt := aScan(aHeader,{|x|x[2]="AFA_QTDEXT"})
Local nUsado 	 := Len(aHeader)+1
Local nRet	  	 := nCor3    


If !lManSol   //incluido requisicao de material
	Do Case
		Case Empty(aLinha[nLinha][nPosPrd])
		   	nRet := nCor7
			
		//Case aLinha[nLinha][nPosQtdSol] > aLinha[nLinha][nPosQtdSld] .And. !Empty(aLinha[nLinha][nPosQtdSol]) .And. aLinha[nLinha][nPosQtdSld]<0 .And. aLinha[nLinha][nPosQtdSld]+aLinha[nLinha][nPosQtdSol] < 0
		//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 24/08/2012]
		Case ((aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] > aLinha[nLinha][nPosQtdR1] .And.aLinha[nLinha][nPosQtdR1]<=aLinha[nLinha][nPosQtdPrj]) .Or. (aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] > aLinha[nLinha][nPosQtdPrj] .And.aLinha[nLinha][nPosQtdR1]>aLinha[nLinha][nPosQtdPrj])) .And. !Empty(aLinha[nLinha][nPosQtdSol]) .And. aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] >= aLinha[nLinha][nPosQtdSol]
		 	nRet := nCor5   //vermelho
			
		//Case aLinha[nLinha][nPosQtdSol] > aLinha[nLinha][nPosQtdSld] .And. !Empty(aLinha[nLinha][nPosQtdSol]) .And. aLinha[nLinha][nPosQtdSld]<0 .And. aLinha[nLinha][nPosQtdSld]+aLinha[nLinha][nPosQtdSol] >=0
		//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 24/08/2012]
		Case Empty(aLinha[nLinha][nPosQtdSol]) .And. ((aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] > aLinha[nLinha][nPosQtdR1] .And.aLinha[nLinha][nPosQtdR1]<=aLinha[nLinha][nPosQtdPrj]) .Or. (aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] > aLinha[nLinha][nPosQtdPrj] .And.aLinha[nLinha][nPosQtdR1]>aLinha[nLinha][nPosQtdPrj]))
		  	nRet := nCor6   //laranja	
			
		Case !Empty(aLinha[nLinha][nPosQtdSol])
	  	  	nRet := nCor2   //verde
			
		Case Empty(aLinha[nLinha][nPosQtdSol])
  			nRet := nCor3
	EndCase
Else            //alterando uma requisicao de material
	Do Case
		Case Empty(aLinha[nLinha][nPosPrd])
		 	nRet := nCor7
			
		//Case aLinha[nLinha][nPosQtdSol] > aLinha[nLinha][nPosQtdSld] .And. !Empty(aLinha[nLinha][nPosQtdSol]) .And. aLinha[nLinha][nPosQtdSld]<0 .And. aLinha[nLinha][nPosQtdSld]+aLinha[nLinha][nPosQtdSol] < 0
		//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 24/08/2012]
		Case ((aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] > aLinha[nLinha][nPosQtdR1] .And.aLinha[nLinha][nPosQtdR1]<=aLinha[nLinha][nPosQtdPrj]) .Or. (aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] > aLinha[nLinha][nPosQtdPrj] .And.aLinha[nLinha][nPosQtdR1]>aLinha[nLinha][nPosQtdPrj])) .And. !Empty(aLinha[nLinha][nPosQtdSol]) .And. aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] >= aLinha[nLinha][nPosQtdSol]
		 	nRet := nCor5   //vermelho
			
		//Case aLinha[nLinha][nPosQtdSol] > aLinha[nLinha][nPosQtdSld] .And. !Empty(aLinha[nLinha][nPosQtdSol]) .And. aLinha[nLinha][nPosQtdSld]<0 .And. aLinha[nLinha][nPosQtdSld]+aLinha[nLinha][nPosQtdSol] >=0
		//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 24/08/2012]
		Case (aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] > aLinha[nLinha][nPosQtdR1] .And.aLinha[nLinha][nPosQtdR1]<=aLinha[nLinha][nPosQtdPrj]) .Or. (aLinha[nLinha][nPosQtdEmp]+aLinha[nLinha][nPosQtdEnt] > aLinha[nLinha][nPosQtdPrj] .And.aLinha[nLinha][nPosQtdR1]>aLinha[nLinha][nPosQtdPrj])
			nRet := nCor6   //laranja
			
		Case !Empty(aLinha[nLinha][nPosQtdSol])
		 	nRet := nCor2   //verde
			
		Case Empty(aLinha[nLinha][nPosQtdSol])
			nRet := nCor3
	EndCase
EndIf

//rotina definindo a descricao da edt e da tarefa
cDescEDT := Space(90) //descricao EDT
cDescTar := Space(90) //descricao tarefa

nPosTarefa := aScan(aHeader,{|x|x[2]="Z8_TAREFA"})

cTarefa := aLinha[nLinha][nPosTarefa]
cEdt    := Substr(cTarefa,1,RAt(".",cTarefa)-1)
/*
If Empty(aLinha[nLinha][nPosPrd])
	cDescEDT := Space(90)
	cDescTar := Space(90)
Else
	DbSelectArea("AFC")
	DbSetOrder(1)
	If DbSeek(xFilial("AFC")+cCodProj+cRevisao+cEdt)
		cDescEDT := AFC_DESCRI
	EndIf
	
	DbSelectArea("AF9")   //tarefa do projeto
	DbSetOrder(1)
	If DbSeek(xFilial("AF9")+cCodProj+cRevisao+cTarefa)
		cDescTar := AF9->AF9_DESCRI
	EndIf
EndIf
*/
oS_DEdt:Refresh()
oS_DTar:Refresh()

Return nRet





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFGEN010a  บAutor  ณAlexandre Martins   บ Data ณ  03/28/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para envio de e-mail.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParโmetrosณ ExpC1: e-mail do destinatแrio                              บฑฑ
ฑฑบ          ณ ExpC2: assunto do e-mail                                   บฑฑ
ฑฑบ          ณ ExpC3: texto do e-mail                                     บฑฑ
ฑฑบ          ณ ExpC4: anexos do e-mail                                    บฑฑ
ฑฑบ          ณ ExpL1: exibe mensagem de envio                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno  ณ ExpL2: .T. - envio realizado                               บฑฑ
ฑฑบ          ณ        .F. - nใo enviado                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo OmniLink                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FGEN010a(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem,c_MailOrigem,c_MailCC,c_MailCCo)

Local 	l_Ret		    := .T.
Local 	c_Cadastro		:= "Envio de e-mail"
Private	c_MailServer	:= AllTrim(GetMv("MV_RELSERV"))
Private	c_MailConta
Private 	l_Auth		:= GetMv("MV_RELAUTH")
Private  c_MailAuth		:= AllTrim(GetMv("MV_RELACNT"))

Private	c_MailSenha		:= AllTrim(GetMv("MV_RELPSW"))
Private  c_SenhaAuth	:= AllTrim(GetMv("MV_RELAPSW"))
Private	a_MailDestino
Private	l_Mensagem		:= If( ValType(l_Mensagem)    != "U" , l_Mensagem,  .T. )

cMailOrigem     := c_MailOrigem
cMailDestino    := c_MailDestino
cMailCC         := c_MailCC
cMailCCo        := c_MailCCo
c_MailConta 	:= If(Type("cMailOrigem") != "C",AllTrim(GetMv("MV_RELAUSR")),cMailOrigem)
cMailCC 	    := If(Type("cMailCC")      != "C","",cMailCC)
cMailCCo	    := If(Type("cMailCCo")     != "C","",cMailCCo)
cMailDestino	:= If(Type("cMailDestino") != "C","",cMailDestino)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua validacoesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Empty(c_MailDestino)
	If l_Mensagem
		Aviso(	c_Cadastro, "Conta(s) de e-mail de destino(s) nใo informada. ";
		+"Envio nใo realizado.",{"&Ok"},,"Falta informa็ใo" )
	EndIf
	c_msgerro := "Conta(s) de e-mail de destino(s) nใo informada. Envio nใo realizado."
	l_Ret	:= .F.
EndIf

If Empty(c_Assunto)
	If l_Mensagem
		Aviso(	c_Cadastro,"Assunto do e-mail nใo informado. ";
		+"Envio nใo realizado.",{"&Ok"},,"Falta informa็ใo" )
	EndIf
	c_msgerro := "Assunto do e-mail nใo informado. Envio nใo realizado."
	l_Ret	:= .F.
EndIf

If Empty(c_Texto)
	If l_Mensagem
		Aviso(	c_Cadastro,"Texto do e-mail nใo informado. ";
		+"Envio nใo realizado.",{"&Ok"},, "Falta informa็ใo" )
	EndIf
	c_msgerro := "Texto do e-mail nใo informado. Envio nใo realizado."
	l_Ret	:= .F.
EndIf

If l_Ret
	If l_Mensagem
		Processa({|| l_Ret := SendMail_(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem), "Enviando e-mail"})
	Else
		l_Ret := SendMail_(c_MailDestino,c_Assunto,c_Texto,c_Anexos,l_Mensagem)
	EndIf
EndIf

Return(l_Ret)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSendMail  บAutor  ณAlexandre Martins   บ Data ณ  03/28/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de envio de e-mail.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo Scelisul.                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SendMail_(c_MailDestino,c_Assunt,c_Text,c_Anexo,l_Mensagem)

Local l_Conexao		    := .F.
Local l_Envio			:= .F.
Local l_Desconexao	    := .F.
Local l_Ret				:= .T.
Local c_Assunto		    := If( ValType(c_Assunt) != "U" , c_Assunt , "" )
Local c_Texto			:= If( ValType(c_Text)   != "U" , c_Text   , "" )
Local c_Anexos			:= If( ValType(c_Anexo)  != "U" , c_Anexo  , "" )
Local c_Erro_Conexao	:= ""
Local c_Erro_Envio		:= ""
Local c_Erro_Desconexao	:= ""
Local c_Cadastro			:= "Envio de e-mail"

If l_Mensagem
	IncProc("Conectando-se ao servidor de e-mail...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa conexao ao servidor mencionado no parametro. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Connect Smtp Server c_MailServer ACCOUNT c_MailConta PASSWORD c_MailSenha RESULT l_Conexao

If !l_Conexao
	GET MAIL ERROR c_Erro_Conexao
	If l_Mensagem
		Aviso(	c_Cadastro, "Nao foi possํvel estabelecer conexใo com o servidor - ";
		+c_Erro_Conexao,{"&Ok"},,"Sem Conexใo" )
	EndIf
	c_msgerro := "Nao foi possํvel estabelecer conexใo com o servidor - "+c_Erro_Conexao
	l_Ret := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se deve fazer autenticacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If l_Auth
	If !MailAuth(c_MailAuth, c_SenhaAuth)
		GET MAIL ERROR c_Erro_Conexao
		If l_Mensagem
			Aviso(	c_Cadastro, "Nao foi possํvel autenticar a conexใo com o servidor - ";
			+c_Erro_Conexao,{"&Ok"},,"Sem Conexใo" )
		EndIf
		c_msgerro := "Nao foi possํvel autenticar a conexใo com o servidor - "+c_Erro_Conexao
		l_Ret := .F.
	EndIf
EndIf

If l_Mensagem
	IncProc("Enviando e-mail...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa envio da mensagem. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(c_Anexos)
	Send Mail From c_MAILCONTA to cMailDestino CC cMailCC BCC cMailCCo SubJect c_Assunto BODY c_Texto FORMAT TEXT ATTACHMENT c_Anexos RESULT l_Envio
Else
	Send Mail From c_MAILCONTA to cMailDestino CC cMailCC BCC cMailCCo SubJect c_Assunto BODY c_Texto FORMAT TEXT RESULT l_Envio
EndIf

If !l_Envio
	Get Mail Error c_Erro_Envio
	If l_Mensagem
		Aviso(	c_Cadastro,"Nใo foi possํvel enviar a mensagem - ";
		+c_Erro_Envio,{"&Ok"},,	"Falha de envio" )
	EndIf
	c_msgerro := "Nใo foi possํvel enviar a mensagem - "+c_Erro_Envio
	l_Ret := .F.
EndIf

If l_Mensagem
	IncProc("Desconectando-se do servidor de e-mail...")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa disconexao ao servidor SMTP. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DisConnect Smtp Server Result l_Desconexao

If !l_Desconexao
	Get Mail Error c_Erro_Desconexao
	If l_Mensagem
		Aviso(	c_Cadastro,"Nใo foi possํvel desconectar-se do servidor - ";
		+c_Erro_Desconexao,{"&Ok"},,"Descone็ใo" )
	EndIf
	c_msgerro := "Nใo foi possํvel desconectar-se do servidor - "+c_Erro_Desconexao
	l_Ret := .F.
EndIf

Return(l_Ret)


Static Function MrkSelPV(pMarca)
Local lRet := .T.
If SZ7TRB->Z7_OK = pMarca
	cStr2C := Substr(SZ7TRB->Z7_OBRA,1,2)
	cStr3C := Substr(SZ7TRB->Z7_OBRA,3,1)
	If cStr2C $ "SP.PP.RJ"
		//If ((cStr2C = "SP" .Or. cStr2C = "RJ").And.cFilAnt != "01").Or.(cStr2C = "PP" .And.cFilAnt != "02").Or.(cStr2C = "RJ" .And.cFilAnt != "03")
		//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 28/04/2011]
		If ((cStr2C = "SP" .Or. cStr2C = "RJ").And.cFilAnt != "01").Or.(cStr2C = "PP" .And.cFilAnt != "02")
			MsgBox("Requisi็ใo de Material selecionado nใo pode ser gerado o pedido nesta empresa","Requisi็ใo de Material","INFO")
			SZ7TRB->Z7_OK := "  "
		EndIf
	Else
		//If ((cStr3C = "L" .Or. cStr3C = "R").And.cFilAnt != "01").Or.(cStr3C = "P" .And.cFilAnt != "02").Or.(cStr3C = "R" .And.cFilAnt != "03")
		//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 28/04/2011]
		If ((cStr3C = "L" .Or. cStr3C = "R").And.cFilAnt != "01").Or.(cStr3C = "P" .And.cFilAnt != "02")
			MsgBox("Requisi็ใo de Material selecionado nใo pode ser gerado o pedido nesta empresa","Requisi็ใo de Material","INFO")
			SZ7TRB->Z7_OK := "  "
		EndIf
	EndIf
	If dDatabase > SZ7TRB->Z7_NECESS
		MsgBox("Requisi็ใo selecionada estแ com data da necessidade expirada [ "+Dtoc(SZ7TRB->Z7_NECESS)+" ]","Requisi็ใo de Material","INFO")
		SZ7TRB->Z7_OK := "  "
	EndIf
	
EndIf
Return

Static Function fArq(c_FileOrig, c_FileDest)

	Local l_Ret 	:= .T.
	Local c_Buffer	:= ""
	Local n_Posicao	:= 0
	Local n_QtdReg	:= 0
	Local n_RegAtu	:= 0

	If !File(c_FileOrig)
		l_Ret := .F.
		MsgStop("Arquivo [ "+c_FileOrig+" ] nใo localizado.", "Nใo localizou")
	Else
		
		Ft_fuse( c_FileOrig ) 		// Abre o arquivo
		Ft_FGoTop()
		n_QtdReg := Ft_fLastRec()
		
		nHandle	:= MSFCREATE( c_FileDest )

		///////////////////////////////////
		// Carregar o array com os itens //
		///////////////////////////////////
		While !ft_fEof() .And. l_Ret
			
			c_Buffer := ft_fReadln()
			
			FWrite(nHandle, &("'" + c_Buffer + "'"))
			c_texto += &("'" + c_Buffer + "'")
			ft_fSkip()
			
		Enddo
		
		FClose(nHandle)

	Endif
	
Return l_Ret


Static Function Busca_User(pIdUser,pOpcao)
Local cRet := "" 

_aUser := {}
psworder(1)
pswseek(pIdUser)
_aUser := PswRet()

if len(_aUser) > 0
Do Case
   Case pOpcao = "N"  //nome
	     cRet := Substr(_aUser[1,4],1,50)
	Case pOpcao = "E"  //e-mail
	     cRet := _aUser[1,14]
EndCase	   
endif

Return cRet  
