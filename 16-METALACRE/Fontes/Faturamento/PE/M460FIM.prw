#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch" 
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao   ³ Tratamento de Prioridade            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Metalacre                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M460FIM()
Local _aArea := _aAreaSF2 := _aAreaSD2 := _aAreaSA1 := _aAreaSA2 := _aAreaSC5 := _aAreaSB1 := {}

_aArea    := GetArea()
_aAreaSB1 := SB1->(GetArea())
_aAreaSF2 := SF2->(GetArea())
_aAreaSD2 := SD2->(GetArea())
_aAreaSA1 := SA1->(GetArea())
_aAreaSA2 := SA2->(GetArea())
_aAreaSC5 := SC5->(GetArea())
_aAreaSC6 := SC6->(GetArea())
_aAreaSF4 := SF4->(GetArea())

If !SF2->F2_TIPO $ 'D*B' .And. SF2->(FieldPos("F2_NOMCLI")) > 0 
	dbSelectArea("SA1")
	dbSetOrder(1)
	If SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		RecLock("SF2",.F.)
		SF2->F2_NOMCLI := SA1->A1_NOME
		MsUnlock()
	EndIF	
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	If SA2->(dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		RecLock("SF2",.F.)
		SF2->F2_NOMCLI := SA2->A2_NOME
		MsUnlock()
	EndIF	
Endif

If cEmpAnt <> '01'
	Return 
Endif
      
// Atualiza Id de Transacao de Pagamento Sealbag no FInanceiro

If SC5->(FieldPos("C5_PEDWEB")) > 0
	If !Empty(SC5->C5_IDPAY)
		If SE1->(dbSetOrder(2), dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC))
			While SE1->(!Eof()) .And. SE1->E1_FILIAL == xFilial("SE1") .And. SE1->E1_CLIENTE == SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA .And. SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DOC
				If RecLock("SE1",.f.)
					SE1->E1_IDPAY	:=	SC5->C5_IDPAY
					SE1->(MsUnlock())
				Endif
				
				SE1->(dbSkip(1))
			Enddo
		Endif
	Endif
Endif

// Particularidade Cliente 725 Vncimentos 
If SF2->F2_CLIENTE+SF2->F2_LOJA == '00072501'
	If SE1->(dbSetOrder(2), dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)) 
		If Day(SE1->E1_EMISSAO) >= 1 .And. Day(SE1->E1_EMISSAO) <= 15
			dVencTo := MonthSum(SE1->E1_EMISSAO,1)
			dVencto := DataValida(CtoD('13/'+StrZero(Month(dVencto),2)+'/'+Str(Year(dVencto),4)),.F.)
		ElseIf Day(SE1->E1_EMISSAO) >= 16 .And. Day(SE1->E1_EMISSAO) <= 31
			dVencTo := MonthSum(SE1->E1_EMISSAO,1)
			dVencto := DataValida(CtoD('28/'+StrZero(Month(dVencto),2)+'/'+Str(Year(dVencto),4)),.F.)
		Endif  		
					
		If RecLock("SE1",.F.)      
			SE1->E1_VENCTO  := dVencto
			SE1->E1_VENCREA := dVencto
			SE1->(MsUnLock())
		Endif
	Endif
ElseIf SF2->F2_CLIENTE $ '000007*000794'
	If SE1->(dbSetOrder(2), dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)) 
		If Day(SE1->E1_EMISSAO) >= 1 .And. Day(SE1->E1_EMISSAO) <= 05
			dVencTo := MonthSum(SE1->E1_EMISSAO,1)
			dVencto := DataValida(CtoD('10/'+StrZero(Month(dVencto),2)+'/'+Str(Year(dVencto),4)),.F.)
		ElseIf Day(SE1->E1_EMISSAO) >= 06 .And. Day(SE1->E1_EMISSAO) <= 10
			dVencTo := MonthSum(SE1->E1_EMISSAO,1)
			dVencto := DataValida(CtoD('18/'+StrZero(Month(dVencto),2)+'/'+Str(Year(dVencto),4)),.F.)
		ElseIf Day(SE1->E1_EMISSAO) >= 11 .And. Day(SE1->E1_EMISSAO) <= 20
			dVencTo := MonthSum(SE1->E1_EMISSAO,1)
			dVencto := DataValida(CtoD('25/'+StrZero(Month(dVencto),2)+'/'+Str(Year(dVencto),4)),.F.)
		Endif  		
					
		If RecLock("SE1",.F.)      
			SE1->E1_VENCTO  := dVencto
			SE1->E1_VENCREA := dVencto
			SE1->(MsUnLock())
		Endif
	Endif
ElseIf SF2->F2_CLIENTE == '015592'
	If SE1->(dbSetOrder(2), dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)) 
		If Day(SE1->E1_EMISSAO) >= 1 .And. Day(SE1->E1_EMISSAO) <= 15
			dVencTo := SE1->E1_EMISSAO
			dVencto := DataValida(CtoD('25/'+StrZero(Month(dVencto),2)+'/'+Str(Year(dVencto),4)),.F.)
		ElseIf Day(SE1->E1_EMISSAO) >= 16 .And. Day(SE1->E1_EMISSAO) <= 31
			dVencTo := MonthSum(SE1->E1_EMISSAO,1)
			dVencto := DataValida(CtoD('10/'+StrZero(Month(dVencto),2)+'/'+Str(Year(dVencto),4)),.F.)
		Endif  		
					
		If RecLock("SE1",.F.)      
			SE1->E1_VENCTO  := dVencto
			SE1->E1_VENCREA := dVencto
			SE1->(MsUnLock())
		Endif
	Endif
ElseIf SF2->F2_CLIENTE == '015996'
	If SE1->(dbSetOrder(2), dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)) 
		If Day(SE1->E1_EMISSAO) >= 1 .And. Day(SE1->E1_EMISSAO) <= 10
			dVencTo := MonthSum(SE1->E1_EMISSAO,1)
			dVencto := DataValida(CtoD('10/'+StrZero(Month(dVencto),2)+'/'+Str(Year(dVencto),4)),.F.)
		ElseIf Day(SE1->E1_EMISSAO) >= 11 .And. Day(SE1->E1_EMISSAO) <= 31
			dVencTo := MonthSum(SE1->E1_EMISSAO,1)
			dVencto := DataValida(CtoD('20/'+StrZero(Month(dVencto),2)+'/'+Str(Year(dVencto),4)),.F.)
		Endif  		
					
		If RecLock("SE1",.F.)      
			SE1->E1_VENCTO  := dVencto
			SE1->E1_VENCREA := dVencto
			SE1->(MsUnLock())
		Endif
	Endif
ElseIf SF2->F2_CLIENTE == '016149'
	If SE1->(dbSetOrder(2), dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC))
		dVencto := (SE1->E1_EMISSAO + 21)
		
		If Dow(dVencto) == 2	// se cair na segunda feira, muda pra terça feira
			dVencto := dVencto + 1
		ElseIf Dow(dVencto) == 4 // Quarta Feira Muda Pra Sexta Feira
			dVencto := dVencto + 2
		ElseIf Dow(dVencto) == 5 // Quinta Feira Muda Pra Sexta Feira
			dVencto := dVencto + 1
		Endif
		dVencRea := DataValida(dVencto,.F.) 
	Endif

	If RecLock("SE1",.F.)      
		SE1->E1_VENCORI := dVencto
		SE1->E1_VENCTO  := dVencto
		SE1->E1_VENCREA := dVencRea
		SE1->(MsUnLock())
	Endif
Endif

// Envia Email de Primeira Compra

U_PrcPriCom(SC5->C5_NUM) 

RestArea(_aAreaSF2)
RestArea(_aAreaSD2)
RestArea(_aAreaSA1)
RestArea(_aAreaSA2)
RestArea(_aAreaSC6)
RestArea(_aAreaSC5)
RestArea(_aAreaSB1)
RestArea(_aAreaSF4)
RestArea(_aArea)
Return

//User Function M460FIM()

//Comentada, pois o ponto de entrada nao estava no projeto. William Palma 27/03

/*
Local cPed  := SD2->D2_PEDIDO // PEGA O NUMERO DO PEDIDO DA NF QUE ACABOU DE SER GERADA
Local cNota := "" 

ALERT("PASSOU NO PONTO DE ENTRADA")

DBSELECTAREA("SC5")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SC5") + cPed)  // PROCURA O PEDIDO REFERENTE A ESTA NF
	cNota := SC5->C5_NOTA
ENDIF

DBSELECTAREA("SUA")
DBSETORDER(8)
IF DBSEEK(XFILIAL("SUA") + cPed)      // VAI NA TABELA SUA E GRAVA O NUMERO DA NF NO CAMPO PARA ATUALIZAR A LEGENDA
	RecLock("SUA",.F.)
	SUA->UA_NOTAFIS := cNota 
	MsUnlock()
ENDIF
/*/
Return

