#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA681MNU º Autor ³ Luiz Alberto       º Data ³  Abr/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Visualiza Operadores e Lançamentos Relacionados ao Apontamento±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTA681MNU()

//aadd(aRotina,{'Operadores','U_VerOper()' , 0 , 3,0,NIL})


Return Nil


User Function VerOper()
Local oDlg3
Local oLbx
Local oBtn6
Local aArea := GetArea()
Local aOper := {}
Local lChkLinha := .f.
Local nTotal := 0.00

DbSelectArea("PWI")
DbSetOrder(1)
DbSeek(xFilial('PWI')+StrZero(SH6->(Recno()),10))
While PWI->(!Eof()) .And. PWI->PWI_FILIAL == xFilial("PWI") .And. PWI->PWI_RECSH6 == StrZero(SH6->(Recno()),10)
	AAdd(aOper,{PWI->PWI_CODOPE,;
				PWI->PWI_NOMOPE,;
				DtoC(PWI->PWI_DTINI),;
				PWI->PWI_HRINI,;
				DtoC(PWI->PWI_DTFIM),;
				PWI->PWI_HRFIM,;
				TransForm(PWI->PWI_QTDPRD,"@E 9,999,999")})

	lChkLinha := Iif(PWI->PWI_LINPRD=='S',.t.,.f.)
	
	If lChkLinha // Se For Linha de Producao Então Não Soma as Quantidades por Operador
		nTotal := PWI->PWI_QTDPRD
	Else
		nTotal += PWI->PWI_QTDPRD
	Endif
	
	PWI->(dbSkip(1))
End      

cTotal := 'Qtde Produzida : ' + TransForm(nTotal,"@E 9,999,999")  
	
Define Dialog oDlg3 Title "Producao x Operadores - Ordem: " + SH6->H6_OP Of oMainWnd Pixel From 0,0 To 350,800 Color CLR_BLACK,CLR_WHITE
@ 21,5 ListBox oLbx Fields Header "Código", "Nome",'Dt Inicio', "Hora Inicio", 'Dt Final', 'Hora Final', 'Qtd Produzida' Size 385,150 Of oDlg3 Pixel
oLbx:SetArray(aOper)
oLbx:bLine := {||{ aOper[oLbx:nAt,1],aOper[oLbx:nAt,2],aOper[oLbx:nAt,3],aOper[oLbx:nAt,4],aOper[oLbx:nAt,5],aOper[oLbx:nAt,6],aOper[oLbx:nAt,7]}}
	
@  4,200 CHECKBOX oChkLinha VAR lChkLinha PROMPT "Linha de Produção" SIZE 100, 014 WHEN .F. OF oDlg3 COLORS 0, 16777215 PIXEL
@  4,350 Button oBtn6 Prompt "&Ok"   Size 40,12 Of oDlg3 Pixel Action (oDlg3:End())
@  4,005 SAY   oSayTotal PROMPT cTotal  PIXEL SIZE 200, 16 COLORS CLR_BLUE,CLR_WHITE PIXEL OF oDlg3
oSayTotal:oFont := TFont():New('Arial',,24,,.T.,,,,.T.,.F.)

Activate Dialog oDlg3 Center

RestArea(aArea)
Return .t.
