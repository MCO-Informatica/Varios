#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"            
#include "msgraphi.ch"
#INCLUDE "Totvs.ch"
#INCLUDE "AP5MAIL.CH"

#DEFINE PRSPED 	001
#DEFINE PRSIPD 	002
#DEFINE PRSPRD 	003
#DEFINE PRSDSC 	004
#DEFINE PRSORP 	005
#DEFINE PRSLIN 	006
#DEFINE PRSLFI 	007
#DEFINE PRSSTA 	008
#DEFINE PRSCOP 	009
#DEFINE PRSSEQ 	010
#DEFINE PRSNAT 	011
#DEFINE PRSLOG 	012

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFATA010 บ Autor ณBruno Daniel Borges บ Data ณ  25/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de personalizacoes de lacres                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RFATA010()
Local aArea := GetArea()
Private cCadastro := "Cadastro de Personalizacoes de Lacres"
Private aRotina := { 	{"Pesquisar"	,"AxPesqui",0,1} ,;
						{"Visualizar"	,"U_RFATA10A",0,2} ,;
						{"Incluir"		,"U_RFATA10A",0,3} ,;
						{"Alterar"		,"U_RFATA10A",0,4} ,;
						{"Excluir"		,"U_RFATA10A",0,5} ,;
						{"Senha"		,"U_TelaPSW(.T.,.T.)",0,6}}
						
						
dbSelectArea("Z00")
Z00->(dbSetOrder(1))

mBrowse( 6,1,22,75,"Z00")


RestArea(aArea)
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RFATA10A บAutor  ณBruno Daniel Borgessบ Data ณ  25/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de manutencao no cadastro de personalizacoes de lacres บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RFATA10A(x,y,nOpcBrw)
Local oEnchoice    := Nil
Local oGetDados    := Nil
Local aCoordenadas := MsAdvSize(.T.)
Local aCols        := {}
Local aHeader      := {}
Local nOpcClick    := 0
Local i,j     
Local lRet 
Local _lDeleta      := (!Altera .and. !Inclui .and. nOpcBrw == 5 ) // Deletar

Private oDlgPersona     := Nil
Private oFolder		:= Nil
Private cCodigo		:=""
Private aButtons	:={}
Private cParametro  := GetMV("MV_DIRPDF")//Parametro criado para que usuแrio defina onde armazenar os Arquivos PDF

Private aTela[0][0]
Private aGets[0]

&& Bruno Abrigo em 26-03-2012 controle de inclusao por senha

Private _lOk:=.T.

dbSelectArea("Z00")

&& Bruno Abrigo em 30-07-12 valida antes de deletar
If  _lDeleta
	lRet:=( findSc6(Z00->Z00_COD) )
	
	If !lRet
		Return lRet
	Endif
	
Endif

if nOpcBrw != 2 // tudo que for diferente de inclusao
	If !SU7->(dbSetOrder(4), dbSeek(xFilial("SU7")+__cUserID))
		Alert("Aten็ใo Usuแrios Nใo Operadores do Telemarketing s๓ Poderใo Visualizar os Dados !")
		//Return .f.
	Endif
Endif

dbSelectArea("Z00")

aLstZ01N := {}
aLstZ01S := {}

cCodigo:=Iif(nOpcBrw == 3,CriaVar("Z00_COD"),Z00->Z00_COD)

//Monta o aCols
dbSelectArea("Z01")
Z01->(dbSetOrder(4))
Z01->(dbSeek(xFilial("Z01")+cCodigo ))
While Z01->(!Eof()) .And. Z01->Z01_FILIAL + Z01->Z01_COD == xFilial("Z01")+cCodigo
	cStat := ''
	If Z01->Z01_STAT == '1'
		cStat := 'Em Pedido'
	ElseIf Z01->Z01_STAT == '2'
		cStat := 'Op Gerada'
	ElseIf Z01->Z01_STAT == '3'
		cStat := 'Op Apontada'
	ElseIf Z01->Z01_STAT == '5'
		cStat := 'Faturado'
	ElseIf Z01->Z01_STAT == '5'
		cStat := 'Devolvido'
	Endif
	
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1")+Z01->Z01_PROD))
		
	If !Left(Z01->Z01_PV,1)$'0123456789' .And. AllTrim(Z01->Z01_PV)<>'INTERV'	// Stand By ou SealBag
		AAdd(aLstZ01S,{Z01->Z01_PV,;
						Z01->Z01_ITEMPV,;
						Z01->Z01_PROD,;                       
						SB1->B1_DESC,;
						Z01->Z01_OP,;
						Z01->Z01_INIC,;
						Z01->Z01_FIM,;
						cStat,;
						Z01->Z01_COPIA,;
						Z01->Z01_NUMERO,;
						Z01->Z01_NUMAT,;
						Z01->Z01_LOGINT})

	Else
		AAdd(aLstZ01N,{Z01->Z01_PV,;
						Z01->Z01_ITEMPV,;
						Z01->Z01_PROD,;
						SB1->B1_DESC,;
						Z01->Z01_OP,;
						Z01->Z01_INIC,;
						Z01->Z01_FIM,;
						cStat,;
						Z01->Z01_COPIA,;
						Z01->Z01_NUMERO,;
						Z01->Z01_NUMAT,;
						Z01->Z01_LOGINT})
	Endif
	
	Z01->(dbSkip(1))
Enddo

nComum := 0
nStand := 0

If Empty(Len(aLstZ01N))
	aLstZ01N	:=	{{'','','','','','','','','','','',''}}
Else
	nComum := Len(aLstZ01N)
Endif	
If Empty(Len(aLstZ01S))
	aLstZ01S	:=	{{'','','','','','','','','','','',''}}
Else
	nStand := Len(aLstZ01S)
Endif	

Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )

Z00->(RegToMemory("Z00",nOpcBrw == 3))

//Tela de apontamento Mensal                                 -50
//DEFINE MSDIALOG oDlgPersona FROM aCoordenadas[7],000 TO aCoordenadas[6]-10,aCoordenadas[5]-10 TITLE Alltrim(OemToAnsi("Personaliza็ใo de Lacres")) Pixel 
DEFINE MSDIALOG oDlgPersona TITLE Alltrim(OemToAnsi("Personaliza็ใo de Lacres")) From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

oEnchoice := MsMGet():New("Z00",Z00->(RecNo()),nOpcBrw,,,,,{030,003,oDlgPersona:nClientHeight/4,oDlgPersona:nClientWidth/2},,3,,,,,,.T.)	//-5

@ oDlgPersona:nClientHeight/4+5, 003 FOLDER oFolder OF oDlgPersona PROMPT "Personaliza็ใo Comum (" + AllTrim(Str(nComum)) + ")" ,"Personaliza็ใo Stand By (" + AllTrim(Str(nStand)) + ")"  PIXEL SIZE 675,130

@ 000, 000 LISTBOX oNPerso Fields HEADER 'Pedido', 'Item PV', 'Produto', 'Descri็ใo', 'Ordem Prod.',;
																 'Lacre Inicial', 'Lacre Final', 'Status', 'Copia', 'Seq.',;
																 'Num.Atend.','Log Intervalo' SIZE 670,110 OF oFolder:aDialogs[1] PIXEL 

oNPerso:SetArray(aLstZ01N)
oNPerso:bLine := {|| {	aLstZ01N[oNPerso:nAt,PRSPED],;
						aLstZ01N[oNPerso:nAt,PRSIPD],;
						aLstZ01N[oNPerso:nAt,PRSPRD],;
						aLstZ01N[oNPerso:nAt,PRSDSC],;
						aLstZ01N[oNPerso:nAt,PRSORP],;
						aLstZ01N[oNPerso:nAt,PRSLIN],;
						aLstZ01N[oNPerso:nAt,PRSLFI],;
						aLstZ01N[oNPerso:nAt,PRSSTA],;
						aLstZ01N[oNPerso:nAt,PRSCOP],;
						aLstZ01N[oNPerso:nAt,PRSSEQ],;
						aLstZ01N[oNPerso:nAt,PRSNAT],;
						aLstZ01N[oNPerso:nAt,PRSLOG]}}


@ 000,000 LISTBOX oSPerso Fields HEADER 'Pedido', 'Item PV', 'Produto', 'Descri็ใo', 'Ordem Prod.',;
																 'Lacre Inicial', 'Lacre Final', 'Status', 'Copia', 'Seq.',;
																 'Num.Atend.','Log Intervalo' SIZE 670, 110 OF oFolder:aDialogs[2] PIXEL 

oSPerso:SetArray(aLstZ01S)
oSPerso:bLine := {|| {	aLstZ01S[oSPerso:nAt,PRSPED],;
						aLstZ01S[oSPerso:nAt,PRSIPD],;
						aLstZ01S[oSPerso:nAt,PRSPRD],;
						aLstZ01S[oSPerso:nAt,PRSDSC],;
						aLstZ01S[oSPerso:nAt,PRSORP],;
						aLstZ01S[oSPerso:nAt,PRSLIN],;
						aLstZ01S[oSPerso:nAt,PRSLFI],;
						aLstZ01S[oSPerso:nAt,PRSSTA],;
						aLstZ01S[oSPerso:nAt,PRSCOP],;
						aLstZ01S[oSPerso:nAt,PRSSEQ],;
						aLstZ01S[oSPerso:nAt,PRSNAT],;
						aLstZ01S[oSPerso:nAt,PRSLOG]}}


//oGetDados := MsNewGetDados():New(oDlgPersona:nClientHeight/4+5,003          ,oDlgPersona:nClientHeight/2-5 ,oDlgPersona:nClientWidth/2-5,2    ,,,"",,,9999,,,,oDlgPersona,aHeader,aCols)


@ -15,-15 BUTTON oBtn PROMPT "..." SIZE 1,1 PIXEL OF oDlgPersona
Aadd( aButtons,{"Visualizar", {|| VISPDF(cCodigo,cParametro)}, "Visualizar...", "Visualizar PDF" })
//Aadd( aButtons,{"Alterar", {|| ALTPDF(cCodigo,cParametro)}, "Alterar...", "Alterar PDF" })

oDlgPersona:Activate(,,,,,,{||EnchoiceBar(oDlgPersona,{|| Iif(Obrigatorio(aGets,aTela), Iif (RFATTOK(nOpcBrw), Iif(1==1, (nOpcClick := 1, oDlgPersona:End()),Nil),Nil ),(MsgAlert("Campos obrigatorios nใo preenchidos!","Aten็ใo: "+cUserName),.F. )/*(oDlgPersona:End(),Nil)*/)  },{|| nOpcClick := 0,oDlgPersona:End()},,@aButtons)})
//oDlgPersona:Activate(,,,,,,{||EnchoiceBar(oDlgPersona,{|| Iif(Obrigatorio(aGets,aTela), Iif (RFATTOK(), Iif(UPPDF(cCodigo,cParametro), (nOpcClick := 1, oDlgPersona:End()),Nil),Nil ),(MsgAlert("Campos obrigatorios nใo preenchidos!","Aten็ใo: "+cUserName),.F. )/*(oDlgPersona:End(),Nil)*/)  },{|| nOpcClick := 0,oDlgPersona:End()},,@aButtons)})

If nOpcClick == 1 .And. nOpcBrw <> 2
	dbSelectArea("Z00")
	dbSetOrder(1)
	iif(nOpcBrw<>3,Z00->(dbSeek(xFilial("Z00")+M->Z00_COD)),.T.)    // Bruno Abrigo em 16.05.12 erro de rollback
	Z00->(RecLock("Z00",nOpcBrw == 3))
	
	If nOpcBrw == 3
		ConfirmSX8("Z00","Z00_COD")  // Bruno ABrigo em 25/04/12
	EndIf
	
	// Se For Uma Altera็ใo
	// e xIntervalo igual a Sim entใo Salva o Salto na Z01 como Pulo de Sequencia
	// e Volta xIntervalo para N
	// xIntervalo ้ sempre Nใo, Apenas na Altera็ใo poderแ haver este processo.
	// Luiz Alberto - 3L Systems - 10-11-15
	
	lSalto := .f.
	If M->Z00_INTERV=='1' .And. nOpcBrw==4	// Altera็ใo
		lSalto := .t.                                   
		IF !msgyesno("Confirma o Salto por Intervalo ?","Desenho T้cnico")
			lSalto := .F.                                   
		Endif
				
		
		nLacreIni := Z00->Z00_LACINI
		If Z01->(dbSetOrder(1), dbSeek(xFilial("Z01")+cCodigo))
			While Z01->(!Eof()) .And. Z01->Z01_FILIAL == xFilial("Z01") .And. Z01->Z01_COD == cCodigo
				nLacreIni := Z01->Z01_FIM
				
				Z01->(dbSkip(1))
			Enddo
		Endif
		nLacreFim := Z00->Z00_LACRE
	Endif
		
	M->Z00_INTERV := ''

	If nOpcBrw <> 5
		Z00->Z00_FILIAL := xFilial("Z00")
		For j := 1 To Len(oEnchoice:aGets)
			If Posicione("SX3",2,AllTrim(SubStr(oEnchoice:aGets[j],9,10)),"SX3->X3_CONTEXT") <> "V"
				Z00->&(SubStr(oEnchoice:aGets[j],9,10)) := M->&(SubStr(oEnchoice:aGets[j],9,10))
			EndIf
		Next j
		Z00->(MsUnlock())
		
		If lSalto
			If RecLock("Z01",.t.)
				Z01->Z01_FILIAL	:= xFilial("Z01")
				Z01->Z01_COD	:= Z00->Z00_COD
				Z01->Z01_PV		:= 'INTERV'
				Z01->Z01_ITEMPV	:= '01'
				Z01->Z01_STAT	:= "5"
				Z01->Z01_PROD	:= 'INTERVALO'
				Z01->Z01_COPIA	:= ''
				Z01->Z01_INIC	:= nLacreFim
				Z01->Z01_FIM	:= Z00->Z00_LACRE-1
				Z01->Z01_NUMERO := SOMA1(U_GETSOMA('Z01','Z01_NUMERO',,'Z01_FILIAL',XFILIAL("Z01"),,,,, 'M'))
				If Z01->(FieldPos("Z01_LOGINT")) > 0
					Z01->Z01_LOGINT := UsrFullName(__cUserId)+' em '+DtoC(dDataBase)+' as '+Left(Time(),5)
				Endif
				Z01->(MsUnlock())
			Endif
			lSalto := .f.      
		Endif		
//		U_ChkLacre(Z00->Z00_COD)

		// Enviar email com aviso
		
		If nOpcBrw == 3
		 	cCabecalho := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
		 	cCabecalho += '    <html>                                                       '
		 	cCabecalho += '    <head> '
		 	cCabecalho += '      <meta '
		 	cCabecalho += '     content="text/html; charset=ISO-8859-1" '
		 	cCabecalho += '     http-equiv="content-type"> '
		 	cCabecalho += '      <title>WorkFlow Metalacre</title> '
		 	cCabecalho += '    </head> '
		 	cCabecalho += '    <body> '
		 	cCabecalho += '    <table '
		 	cCabecalho += '     style="font-family: Helvetica,Arial,sans-serif; width: 100%; text-align: left; margin-left: auto; margin-right: 0px;" '
		 	cCabecalho += '     border="1" cellpadding="2" cellspacing="2"> '
		 	cCabecalho += '      <tbody> '
		 	cCabecalho += '        <tr style="font-weight: bold;" '
		 	cCabecalho += '     align="center"> '
		 	cCabecalho += '          <td '
		 	cCabecalho += '     style="background-color: rgb(255, 255, 255);" colspan="8" '
		 	cCabecalho += '     rowspan="1"><big><big><img '
		 	cCabecalho += '     style="width: 300px; height: 88px;" alt="" '
		 	cCabecalho += '     src="http://www.metalacre.com.br/wp-content/uploads/2015/03/logotipometalacrepeq1.jpg"><br> '
		 	cCabecalho += '          </big></big></td> '
		 	cCabecalho += '        </tr> '
		 	cCabecalho += '        <tr style="font-weight: bold;" '
		 	cCabecalho += '     align="center"> '
		 	cCabecalho += '          <td '
		 	cCabecalho += '     style="background-color: rgb(255, 255, 204);" colspan="8" '
		 	cCabecalho += '     rowspan="1"><big><big>Inclus&atilde;o '
		 	cCabecalho += '    de Nova Personaliza&ccedil;&atilde;o</big></big></td> '
		 	cCabecalho += '        </tr> '
		 	cCabecalho += '        <tr> '
		 	cCabecalho += '          <td><small>Codigo:</small></td> '
		 	cCabecalho += '          <td colspan="4" rowspan="1"><small>Descricao:</small></td> '
		 	cCabecalho += '          <td colspan="3" rowspan="1"><small>Desenho Tecnico:</small></td> '
		 	cCabecalho += '        </tr> '
		 	cCabecalho += '        <tr> '
		 	cCabecalho += '          <td><small>Cliente:</small></td> '
		 	cCabecalho += '          <td><small>Lacre Inicial:</small></td> '
		 	cCabecalho += '          <td colspan="2" rowspan="1"><small>Lacre Atual:</small></td> '
		 	cCabecalho += '          <td><small>Regrava:</small></td> '
		 	cCabecalho += '          <td colspan="1" rowspan="1"><small>Rel.CEMIG:</small></td> '
		 	cCabecalho += '          <td rowspan="1" colspan="2"><small>Cod.CEMIG:</small></td> '
		 	cCabecalho += '        </tr> '
		 	cCabecalho += '        <tr> '
		 	cCabecalho += '          <td><small>Tipo:</small></td> '
		 	cCabecalho += '          <td><small>Cod.Especial:</small></td> '
		 	cCabecalho += '          <td><small>Tipo Personal:</small></td> '
		 	cCabecalho += '          <td><small>Pd.Inmetro:</small></td> '
		 	cCabecalho += '          <td><small>Qtde Caracteres:</small></td> '
		 	cCabecalho += '          <td colspan="3" rowspan="1"><small>xIntervalo:</small></td> '
		 	cCabecalho += '        </tr> '
		 	cCabecalho += '        <tr> '
		 	cCabecalho += '          <td colspan="8" rowspan="1"><small>Prospect:</small></td> '
		 	cCabecalho += '        </tr> '
		 	cCabecalho += '        <tr> '
		 	cCabecalho += '          <td '
		 	cCabecalho += '     style="background-color: rgb(255, 255, 204);" colspan="8" '
		 	cCabecalho += '     rowspan="1"><small><small><span '
		 	cCabecalho += '     style="font-weight: bold;">Data Envio:</span> '
		 	cCabecalho += '    Hora Envio: Operador:</small></small></td> '
		 	cCabecalho += '        </tr> '
		 	cCabecalho += '      </tbody> '
		 	cCabecalho += '    </table> '
		 	cCabecalho += '    <br '
		 	cCabecalho += '     style="font-family: Helvetica,Arial,sans-serif;"> '
		 	cCabecalho += '    </body> '
		 	cCabecalho += '    </html> '
	
			xCabecalho	:= cCabecalho
			cNomRespo := UsrFullName(__cUserId)
			cEmaRespo := UsrRetMail(__cUserId)
			
			cNome := ''
			If !Empty(M->Z00_PROCOD)
	  			xCabecalho := StrTran(xCabecalho,'Prospect:','Prospect: <span style="font-weight: bold;">('+M->Z00_PROCOD+'/'+M->Z00_PROLOJ+') '+Capital(Posicione("SUS",1,xFilial("SUS")+M->Z00_PROCOD+M->Z00_PROLOJ,"US_NOME")))+'</span>'
	  			cNome := SUS->US_NOME
		 	Else
	  			xCabecalho := StrTran(xCabecalho,'Cliente:','Cliente: <span style="font-weight: bold;">('+M->Z00_CLI+'/'+M->Z00_LOJA+') '+Capital(Posicione("SA1",1,xFilial("SA1")+M->Z00_CLI+M->Z00_LOJA,"A1_NOME")))+'</span>'
	  			cNome := SA1->A1_NOME
	  		Endif
			
			xCabecalho := StrTran(xCabecalho,'Codigo:','Codigo: <span style="font-weight: bold;">'+M->Z00_COD)+'</span>'
			xCabecalho := StrTran(xCabecalho,'Descricao:','Descricao: <span style="font-weight: bold;">'+M->Z00_DESC)+'</span>'
			xCabecalho := StrTran(xCabecalho,'Desenho Tecnico:','Desenho Tecnico: <span style="font-weight: bold;">'+M->Z00_DESC1)+'</span>'
			xCabecalho := StrTran(xCabecalho,'Lacre Inicial:','Lacre Inicial: <span style="font-weight: bold;">'+Str(M->Z00_LACINI))+'</span>'
			xCabecalho := StrTran(xCabecalho,'Lacre Atual:','Lacre Atual: <span style="font-weight: bold;">'+Str(M->Z00_LACRE))+'</span>'
			xCabecalho := StrTran(xCabecalho,'Regrava:','Regrava: <span style="font-weight: bold;">'+Iif(M->Z00_REGRAV=='S','SIM','NAO'))+'</span>'
			xCabecalho := StrTran(xCabecalho,'Rel.CEMIG:','Rel.CEMIG: <span style="font-weight: bold;">'+M->Z00_CEMIG)+'</span>'
			xCabecalho := StrTran(xCabecalho,'Cod.CEMIG:','Cod.CEMIG: <span style="font-weight: bold;">'+M->Z00_CODCEM)+'</span>'
	
			cTipo := ''
			If M->Z00_TIPO=='1'
				cTipo := 'Semi-Barreira'
			ElseIf M->Z00_TIPO=='2'
				cTipo := 'Sinalizacao'
			Endif                    
			
			cTipoP := ''
			If M->Z00_TPPERS == '1'
				cTipoP := 'Logotipo'
			ElseIf M->Z00_TPPERS == '2'
				cTipoP := 'Logotipo+Cod.Letras'
			ElseIf M->Z00_TPPERS == '3'
				cTipoP := 'Nome'
			ElseIf M->Z00_TPPERS == '4'
				cTipoP := 'Cod.Letras'
			Endif
	
			xCabecalho := StrTran(xCabecalho,'Tipo:','Tipo: <span style="font-weight: bold;">'+cTipo)+'</span>'
			xCabecalho := StrTran(xCabecalho,'Cod.Especial:','Cod.Especial: <span style="font-weight: bold;">'+Iif(M->Z00_BARRAS=='1','1D',Iif(M->Z00_BARRAS=='2','2D','NAO')))+'</span>'
			xCabecalho := StrTran(xCabecalho,'Tipo Personal:','Tipo Personal: <span style="font-weight: bold;">'+cTipoP)+'</span>'
			xCabecalho := StrTran(xCabecalho,'Pd.Inmetro:','Pd.Inmetro: <span style="font-weight: bold;">'+Iif(M->Z00_PDINME=='S','SIM','NAO'))+'</span>'
			xCabecalho := StrTran(xCabecalho,'Qtde Caracteres:','Qtde Caracteres: <span style="font-weight: bold;">'+Str(M->Z00_TMLACR))+'</span>'
			xCabecalho := StrTran(xCabecalho,'xIntervalo:','xIntervalo: <span style="font-weight: bold;">'+M->Z00_INTERV)+'</span>'
		
			xCabecalho := StrTran(xCabecalho,'Data Envio:','Data Envio: <span style="font-weight: bold;">'+DtoC(dDataBase))+'</span>'
			xCabecalho := StrTran(xCabecalho,'Hora Envio:','Hora Envio: <span style="font-weight: bold;">'+Time())+'</span>'
			xCabecalho := StrTran(xCabecalho,'Operador:','Operador: <span style="font-weight: bold;">'+Capital(cNomRespo))+'</span>'
		  			
			cEmaFina	:=	SuperGetMV('MV_USRQUA', .F., 'fernanda.santos@metalacre.com.br') 
			cEmaRespo	:=  AllTrim(cEmaRespo)+';'+cEmaFina
		
			EnvWrkPer(cNomRespo,cEmaRespo,'Inclusใo de Nova Personaliza็ใo No. ' + M->Z00_COD,xCabecalho)
		Endif
	Else
		dbSelectArea("Z01")
		Z01->(dbSetOrder(1))
		Z01->(dbSeek(xFilial("Z01")+Z00->Z00_COD ))
		While Z01->(!Eof()) .And. Z01->Z01_FILIAL + Z01->Z01_COD == xFilial("Z01")+Z00->Z00_COD
			Z01->(RecLock("Z01",.F.))
			Z01->(dbDelete())
			Z01->(MsUnlock())
			Z01->(dbSkip())
		EndDo
		
		Z00->(RecLock("Z00",.F.))
		Z00->(dbDelete())
		Z00->(MsUnlock())
	EndIf
EndIf

If nOpcClick == 0 .And. nOpcBrw == 3
   	Z00->(RollBackSX8())
EndIf

Return(Nil)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATA010  บAutor  Jonas Gouveia          Data ณ  17/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validar permitir validar os dados antes de      บฑฑ
ฑฑบ          ณincluir ou alterar dados                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RFATTOK(nOpcBrw)

Local lRet:= .T.
//Validacao da qtd de caracteres do numero inicial do lacre
If LEN(cValtoChar(M->Z00_LACINI)) >  M->Z00_TMLACR
	MsgStop("A quantidade mแxima de caracteres para o lacre incial estแ invแlida, por favor verifique." )
	lRet:= .F.
EndIf

If M->Z00_TPPERS$'1*2' .And. Empty(M->Z00_DESC1)
	MsgStop("Aten็ใo Para o Tipo de Personaliza็ใo 1 ou 2 ้ Necessแrio a Sele็ใo de Um Arquivo PDF de Desenho T้cnico !")
	lRet := .f.                                                        
Endif
                       
If nOpcBrw == 3 .And. !U_ChkDup(AllTrim(M->Z00_DESC)+AllTrim(M->Z00_ABREV),M->Z00_CLI,M->Z00_LOJA,1,nOpcBrw,M->Z00_COD)
	MsgStop("Aten็ใo Jแ Existe Lacre com esta Descri็ใo e Abrevia็ใo - " + AllTrim(M->Z00_DESC) + ' - ' + AllTrim(M->Z00_ABREV) + " Verifique !")
	lRet := .F.
Endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUPPDF     บAutor  OscaR Alderete         Data ณ  18/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada, para validar as informa็๕es de tela referentesบฑฑ
ฑฑบ          ณao upload de arquivo e chamar as fun็๕es auxiliares         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function UPPDF(cCodigo,cParametro)

Local lRet:=.T.
&&if INCLUI .or. ALTERA   && Bruno Abrigo em 19\03\2012

if M->Z00_TPPERS == "3" && Bruno Abrigo em 19\02\2012
	lRet:= .T.
	Return lRet
Endif
If M->Z00_TPPERS$('1').or.M->Z00_TPPERS$('2')
	lRet:=File(cParametro+"\"+cCodigo+".pdf")
	If lRet==.T.
		IF msgyesno("Desenho T้cnico jแ Existe, Deseja Visualizar?","Desenho T้cnico")
			VISPDF(cCodigo,cParametro)
		Else&& Bruno Abrigo em 19\02\2012
			lRet:= .T.
			Return lRet
		EndIf
	Else
		while lRet==.F.
			msgstop("Favor incluir o Desenho T้cnico","Desenho T้cnico")
			U_UPPPDF(cCodigo,cParametro)
			lRet:=File(cParametro+"\"+cCodigo+".pdf")
		End
	EndIF
Else
	File(cParametro+"\"+cCodigo+".pdf", 1 ,.T.)
	If lRet==.T.
		If msgyesno("Desenho T้cnico jแ Existe, Deseja Visualizar?","Desenho T้cnico")
			VISPDF(cCodigo,cParametro)
		Else&& Bruno Abrigo em 19\02\2012
			lRet:= .T.
			Return lRet
		EndIf
	Else
		if msgyesno("Deseja Incluir o Desenho T้cnico","Desenho T้cnico")
			U_UPPPDF(cCodigo,cParametro)
		Else&& Bruno Abrigo em 19\02\2012
			lRet:= .T.
			Return lRet
		Endif
	EndIf
Endif
&&Endif
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณUPPPDF   บAutor  OscaR Alderete         Data ณ  18/01/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada, para realizar o upload de arquivos para o    บฑฑ
ฑฑบ          ณservidor, nele ้ chamada a fun็ใo auxiliar de visuliza็ใo   บฑฑ
ฑฑบ			 ณdo arquivo	   											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function UPPPDF(cCodigo,cParametro)

Local cArq:= ""
Local cArq1:= ""
Local cArq2:= ""
Local cGetFile
Local lRet:=.T.


cArq:= cGetFile ( 'PDF|*.pdf|' , 'Desenho t้cnico', 1, 'C:\', .F., GETF_LOCALHARD + GETF_LOCALFLOPPY, .T.)

//Altera o nome do arquivo original pelo codigo de personaliza็ใo
cArq1:=Left(cArq,Len(cArq)-4)+cCodigo+".pdf"
cArq2:="c:\"+cCodigo
__COPYFILE(cArq,cArq1)//faz copia do arquivo, para que o original permane็a no local de origem
Frename(cArq1,cArq2+".pdf")
//Grava o arquivo no Servidor
CpyT2S( cArq2+".pdf", cParametro, .T. )
//Deleta o arquivo gerado temporariamente para mudan็a de nome
Ferase(cArq2+".pdf")
Ferase(cArq1+".pdf")

M->Z00_DESC1 := cArq
DlgRefresh(oDlgPersona)
SysRefresh()

If Msgyesno("Deseja visualizar Arquivo anexado?")
	VisPDF(CCodigo,cParametro)//Fun็ใo de Visualiza็๕
Else && Bruno Abrigo em 19\03\2012
	lRet:=.T.
	Return lRet
Endif

lRet:=File(cParametro+"\"+cCodigo+".pdf")

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVISPDF   บAutor  OscaR Alderete         Data ณ  19/01/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada, para visualiza็ใo do arquivo anexado e salvo บฑฑ
ฑฑบ          ณno servidor   									          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VisPDF(CCodigo,cParametro)

Local cArq :=""
Local cArq1:=""
Local lRet:=.T.

cArq := AllTrim(M->Z00_DESC1)
lRet:=FILE(cArq) // Verifica no diret๓rio Desenhos T้cnicos do servidor se existe o arquivo buscado.pdf
If lRet
//	If	MAKEDIR('C:\TEMP')!= 0
//		Alert("Impossivel a Cria็ใo da Pasta C:\TEMP em Sua Maquina Local, Verifique !!!")
//		Return .f.
//	EndIf

	//pega o caminho do arquivo
//	cArq :=cParametro+"\"+cCodigo+".pdf"
	//copia o arquivo para a pasta temp no remote
	//Limpa a pasta temporaria no remote
//	Ferase('C:\TEMP\'+cCodigo+".pdf")
//	__COPYFILE(cParametro+"\"+cCodigo+".pdf",'C:\TEMP\'+cCodigo+".pdf")
//	CpyS2T(cParametro+"\"+cCodigo+".pdf", 'C:\TEMP\', .T.)
	shellExecute( "Open", cArq, " /k dir", "C:\", 1 ) //executa o programa para leitura do arquivo copiado
Else   
	Alert("Atencao Arquivo " + cArq + " Nใo Localizado !!!")
//	If Msgyesno("Nใo hแ nenhum documento!,Deseja Anexar?") //se nใo encontrar o arquivo no diret๓rio, informa o usuแrio
//		U_UPPPDF(cCodigo,cParametro)
//	Else  && Bruno Abrigo em 19\03\2012
//		Return
//	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVISPDF   บAutor  OscaR Alderete         Data ณ  19/01/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao criada, para altera็ใo do arquivo anexado e salvo    บฑฑ
ฑฑบ          ณno servidor   									          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AltPDF(CCodigo,cParametro)

Local cArq:= ""
Local cArq1:= ""
Local cArq2:= ""
Local cGetFile
Local lRet:= .T.

//FErase(cParametro+"\"+cCodigo+".pdf")

cArq:= cGetFile ( 'PDF|*.pdf|' , 'Desenho t้cnico', 1, 'C:\', .F., GETF_LOCALHARD + GETF_LOCALFLOPPY, .T.)

//Altera o nome do arquivo original pelo codigo de personaliza็ใo
cArq1:=cArq+cCodigo+".pdf"
cArq2:="c:\"+cCodigo
__COPYFILE(cArq,cArq1)//faz copia do arquivo, para que o original permane็a no local de origem
Frename(cArq1,cArq2+".pdf")
//Grava o arquivo no Servidor
CpyT2S( cArq2+".pdf", cParametro, .T. )
//Deleta o arquivo gerado temporariamente para mudan็a de nome
Ferase(cArq2+".pdf")
Ferase(cArq1+".pdf")

M->Z00_DESC1 := cArq
DlgRefresh(oDlgPersona)
SysRefresh()

If Msgyesno("Deseja visualizar Arquivo anexado?")
	VisPDF(CCodigo,cParametro)
Else  && Bruno Abrigo em 19\03\2012
	Return
Endif

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_CriaSX6  บAutor  ณBruno Abrigo        บ Data ณ  03/26/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Cria parametro de senha                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _CriaSX6()

DbSelectArea("SX6")
SX6->(dbsetOrder(1))
If !SX6->(DbSeek("  MV_METPSSW"))
	RecLock("SX6",.T.)
	SX6->X6_VAR     := "MV_METPSSW"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Senha p\ grupo de usuarios autorizdos."
	SX6->X6_DESC1   := "Serao considerados para efeito de incluir\alterar 	 "
	SX6->X6_DESC2   := "somente c\ a senha abaixo serใo incluidos\alterados Lacre"
	SX6->X6_CONTEUD := "admin"
	SX6->X6_CONTSPA := "admin"
	SX6->X6_CONTENG := "admin"
	SX6->(MsUnLock())
Endif


If !SX6->(DbSeek("  MV_METUSER"))
	RecLock("SX6",.T.)
	SX6->X6_VAR     := "MV_METUSER"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "User p\ autorizados."
	SX6->X6_DESC1   := "Serao considerados para efeito de incluir\alterar"
	SX6->X6_DESC2   := "somente c\ o user abaixo serใo incluidos\alterados Lacre"
	SX6->X6_CONTEUD := "Administrador;mariana;totalsiga"
	SX6->X6_CONTSPA := "admin"
	SX6->X6_CONTENG := "admin"
	SX6->(MsUnLock())
Endif

Return


// Dialog Principal


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaSenha บAutor  ณBruno Abrigo        บ Data ณ  26/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria tela para digitar senha                                บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TelaPSW(_lOk,lEdit)

Local _cUsuario	 := cUserName
Local _cSenha 	 := Space(6)
Local cGet3 	 := Space(6)
Local oGet1
Local oGet2
Local oGet3
//local lsair:=.F.// Bruno Abrigo em 10/04/12
// Variaveis Private da Funcao
Local oDlg

&& Cria\Valida Parametros
_CriaSX6()

_lOk:=.F.

if lEdit
	DEFINE MSDIALOG oDlg TITLE "Logon" FROM 178,181 TO 350,410 PIXEL
Else
	DEFINE MSDIALOG oDlg TITLE "Logon" FROM 178,181 TO 285,410 PIXEL
Endif
oDlg:lEscClose := .F. //Nใo permite sair ao usuario se precionar o ESC

//	@80,10 MsGet oSen Var cSen Picture "@S40" Valid .T.  PASSWORD Pixel of oDlg
// Cria Componentes Padroes do Sistema
@  001, 002 Say "Nome:" Size  018, 008 COLOR CLR_BLACK PIXEL OF oDlg
@  010, 002 MsGet oGet1 Var _cUsuario when .f. Size  084, 009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg

if lEdit
	@  025, 002 Say "Senha Atual:" Size 060	, 030 COLOR CLR_BLACK PIXEL OF oDlg
	@  032, 002 MsGet oGet2 Var _cSenha Size  084,009 Picture "@*" PASSWORD PIXEL OF oDlg //Valid .T.
	
	@  055, 002 Say "Nova Senha:" Size  060, 030 COLOR CLR_BLACK PIXEL OF oDlg
	@  062, 002 MsGet oGet3 Var cGet3 Size  084,009 Picture "@*" PASSWORD PIXEL OF oDlg //Valid .T.
	
	@  010, 091 Button "OK" Size  023, 012 PIXEL OF oDlg;
	Action(ValidaSenha(_cUsuario,_cSenha,@_lOk,lEdit,cGet3),oDlg:End())
	
	@  032, 091 Button "Cancelar" Size  023, 012 PIXEL OF oDlg;
	Action( Alert("Cancelado pelo administrador!","Aten็ใo"),oDlg:End())
	
Else
	
	@  025, 002 Say "Senha:" Size  018, 007 COLOR CLR_BLACK PIXEL OF oDlg
	@  032, 002 MsGet oGet2 Var _cSenha Size  084,009 Picture "@*" PASSWORD PIXEL OF oDlg //Valid .T.
	
	@  010, 091 Button "OK" Size  023, 012 PIXEL OF oDlg;
	Action(ValidaSenha(_cUsuario,_cSenha,@_lOk,lEdit),oDlg:End())
	
	@  032, 091 Button "Cancelar" Size  023, 012 PIXEL OF oDlg;
	Action( Alert("Cancelado pelo administrador!","Aten็ใo"),_lOk:=.F.,oDlg:End())
	
	
Endif


ACTIVATE MSDIALOG oDlg CENTERED

// Bruno abrigo em 10/04/12
Return(_lOk)

//	lSair:=.F.
//	Return(u_TelaPSW(_lOk,lEdit))
//Endif

/*
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
ษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บDesc      ณ Valida senha e Usuario   Bruno Abrigo em 26-03-2012        บ
ศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidaSenha( xcUsuario, xcSenha,_lOk,lEdit ,cGet3)

Local cSenhax_ := GetMv("MV_METPSSW")
Local cUserx_  :=GetMv("MV_METUSER")
Local _axUser:={}

if lEdit
	_axUser:=Separa( cUserx_,";",.T.)
	
	For i:=1 to Len(_axUser)
		If _axUser[i] == xcUsuario .and.  Alltrim(xcSenha)  == Alltrim(cSenhax_)
			
			DbSelectArea("SX6")
			SX6->(dbsetOrder(1))
			If SX6->(DbSeek("  MV_METPSSW"))
				RecLock("SX6",.F.)
				SX6->X6_VAR     := "MV_METPSSW"
				SX6->X6_TIPO    := "C"
				SX6->X6_DESCRIC := "Senha p\ grupo de usuarios autorizdos."
				SX6->X6_DESC1   := "Serao considerados para efeito de incluir\alterar 	 "
				SX6->X6_DESC2   := "somente c\ a senha abaixo serใo incluidos\alterados Lacre"
				SX6->X6_CONTEUD := cGet3
				SX6->X6_CONTSPA := cGet3
				SX6->X6_CONTENG := cGet3
				SX6->(MsUnLock())
			Endif
			
			MsgInfo("Senha alterada com sucesso!")
			_lOk:=.T.
			Return _lOk
		Endif
	Next i
	
	Alert("Senha atual invแlida! ou Usuario sem permissใo para altera็ใo!","Aten็ใo")
	_lOk:=.F.
	Return _lOk
	
Else
	
	IF Alltrim(xcSenha)  == Alltrim(cSenhax_)
		_lOk:=.T.
		Return _lOk
	Else
		&&	Final( cMensag1, cMensag2 )
		Alert("Senha invแlida!","Aten็ใo")
		_lOk:=.F.
		Return _lOk
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfindSc6  บAutor  ณBruno Abrigo         บ Data ณ  07/30/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se existe algum registro no item do Pedido        บฑฑ
ฑฑบ          ณ antes de deletar                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function findSc6(cCodDel)
Local cQry := ""
Local lRet

cQry := " SELECT C6_NUM 'DOC',C6_ENTREG 'DTA',C6_PRODUTO,C6_ITEM 'ITEM' FROM " + RetSqlName("SC6") + " WITH(NOLOCK) "+CRLF
cQry += "  WHERE D_E_L_E_T_ <> '*' AND C6_XLACRE = '"+cCodDel+"'" +CRLF
cQry += "  GROUP BY C6_NUM ,C6_ENTREG ,C6_PRODUTO,C6_ITEM "+CRLF

TcQuery cQry New Alias "DEL"

dbSelectArea("DEL")
DEL->(DbGotop())

If !DEL->(Eof())
	
	If MsgYesno("Existe(em) Pedido(s) ativo(s) relacionado(s) a esta Personaliza็ใo, serแ necessแrio excluir o(s) Pedido(s) antes de prosseguir! Deseja visualizar o log ?")
		
		DEFINE DIALOG oDlg TITLE "Log Itens Pedidos" FROM 180,180 TO 550,700 PIXEL
		
		oBrowse := MsSelBr():New( 1,1,260,184,,,,oDlg,,,,,,,,,,,'Log de Erros',.F.,"DEL",.T.,,.T.,,, )
		                                
		oBrowse:AddColumn(TCColumn():New('Nบ Pedido',{|| DEL->DOC },,,,'LEFT',,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New('Data Pedido'  ,{|| cValtochar(Date(DEL->DTA)) },,,,'LEFT',,.F.,.F.,,,,.F.,))
		oBrowse:AddColumn(TCColumn():New('Item Pedido'  ,{|| DEL->ITEM},,,,'LEFT',,.F.,.F.,,,,.F.,))
		
		oBrowse:lHasMark := .T.    
		oBrowse:bAllMark := {|| alert('Para sair aperte Esc'), oBrowse:Refresh() }
		
		ACTIVATE DIALOG oDlg CENTERED
	Endif
	lRet:=.F.
Else
	lRet:=.T.
Endif

DEL->(DbCloseArea())
Return lRet




// Envio de Email do WorkFlow Financeiro

Static Function EnvWrkPer(cNomRespo,cEmaRespo,cAssunto,mCorpo)
Local cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
Local cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
Local cPara		:= cEmaRespo
Local cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
Local cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
Local lResult  := .F.							// Se a conexao com o SMPT esta ok
Local cError   := ""							// String de erro
Local lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
Local cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
Local cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEnvia o mail para a lista selecionada. Envia como BCC para que a pessoa penseณ
	//ณque somente ela recebeu aquele email, tornando o email mais personalizado.   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult
	
	// Se a conexao com o SMPT esta ok
	If lResult
	
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaTK)	
		Else
			lRet := .T.	
	    Endif    
		
		If lRet
			SEND MAIL FROM cFrom ;
			TO      	cPara;
			SUBJECT 	cAssunto;
			BODY    	mCorpo;
			RESULT lResult
	
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
					Help(" ",1,'Erro no Envio do Email',,cError+ " " + cPara,4,5)	//Aten็ใo
			Endif
	
		Else
			GET MAIL ERROR cError
			Help(" ",1,'Autentica็ใo',,cError,4,5)  //"Autenticacao"
			MsgStop('Erro de Autentica็ใo','Verifique a conta e a senha para envio') 		 //"Erro de autentica็ใo","Verifique a conta e a senha para envio"
		Endif
			
		DISCONNECT SMTP SERVER
		
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
	Endif
Return .t.





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ChkLacre(cCod)  บAutor  ณ Luiz Albertoบ Data ณ  10/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Checa o Cabe็alho do Lacre se Bate Com a Numera็ใo
ฑฑบ          ณ Dos registros de movimentos do lacre
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ChkLacre(cCodigo)
Local aArea := GetArea()

/*If Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+cCodigo))
	nLacreIni := Z00->Z00_LACINI
	nLacreFim := Z00->Z00_LACRE
	
	nLacreCalc:= Z00->Z00_LACRE-1
	
	If Z01->(dbSetOrder(4), dbSeek(xFilial("Z01")+cCodigo))
		While Z01->(!Eof()) .And. Z01->Z01_FILIAL == xFilial("Z01") .And. Z01->Z01_COD == cCodigo
			nLacreCalc := Z01->Z01_FIM
			
			Z01->(dbSkip(1))
		Enddo   

		If nLacreCalc+1 <> nLacreFim
			If RecLock("Z00",.f.)
				Z00->Z00_LACRE	:=	nLacreCalc+1
				Z00->(MsUnlock())
			Endif
		Endif
	Else
		If RecLock("Z00",.f.)
			Z00->Z00_LACRE	:=	nLacreIni
			Z00->(MsUnlock())
		Endif
	Endif
	
Endif
  */
RestArea(aArea)
Return .t.
