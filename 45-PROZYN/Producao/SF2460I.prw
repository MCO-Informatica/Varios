#Include "Rwmake.ch"
#INCLUDE "PROTHEUS.CH"
/*                      
ÜÜÜÜÜÜÜÜÜÜ ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I()    ºAutor  ³Ricardo Nisiyama º Data ³  27/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para gravação de PO na tabela SD1 e SE1   º±±
±±º          ³                                                       	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma  ³ACRESCENTADO ºAutor  ³Ricardo Nisiyama º Data ³  30/06/16   º±±
±±º          ³ Regra de gravação de VOLUME/ESPECIE/PESO BRUTO na NFE      º±±
±±º          ³                                                       	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12                          	                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF2460I()                                                
           
_cAlias := Alias()
_nRecno := Recno()
_nIndex := IndexOrd()

_cCliente := SF2->F2_CLIENTE      
_cLoja    := SF2->F2_LOJA   
_cDoc     := SF2->F2_DOC  
_cSerie   := SF2->F2_SERIE
_cPo      := SC5->C5_NUMPO 
_nVol     := 0 
_nCtVol   := 0
_nBruto   := 0 
_nBruto2  := 0  
_nBruto3  := 0
_cEsp1    := ""
_cEsp2    := ""




//Gravando a origem nos titulos de todos os tipos (nf, tx, ncc, ndc, etc)
DbSelectArea("SE1")
DbSetORder(1)       //prefixo, num, parcela, tipo, fornece, loja.
If DbSeek(xFilial("SE1") + _cSerie + _cDoc)

 //	If SF2->F2_VALFAT<>SF2->F2_VALBRUT .And. ((SF2->F2_VALFAT-SF2->F2_VALBRUT)>0.03 .Or. (SF2->F2_VALFAT-SF2->F2_VALBRUT)<(-0.03))
	 //	MsgStop("ATENÇÃO,VALOR DA NOTA FISCAL DIFERENTE DO FINANCEIRO, INFORME O ADMINISTRADOR DO SISTEMA!")
   //	EndIf
	
	While SE1->(!EOF()) .and. (xFilial("SE1") + _cSerie + _cDoc) == SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM
		Reclock("SE1",.F.)
			E1_NUMPO   := _cPo
			E1_RSOCIAL := Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE + SE1->E1_LOJA,"A1_NOME")
			If SC5->C5_MOEDA<>1
				If SC5->C5_TXREF>0
					
					_aParcAux := Condicao(SF2->F2_VALFAT,SC5->C5_CONDPAG,SF2->F2_VALIPI,dDataBase,0)
					
					SE1->E1_VALOR	:= _aParcAux[IIF(Val(SE1->E1_PARCELA)>0,Val(SE1->E1_PARCELA),1)][2]
					SE1->E1_SALDO	:= _aParcAux[IIF(Val(SE1->E1_PARCELA)>0,Val(SE1->E1_PARCELA),1)][2]
					SE1->E1_TXMOEDA := SC5->C5_TXREF 
					SE1->E1_VLM2 	:= SE1->E1_VLCRUZ
				   //	SE1->E1_VLCRUZ	:= Round(_aParcAux[IIF(Val(SE1->E1_PARCELA)>0,Val(SE1->E1_PARCELA),1)][2] * SC5->C5_TXREF,2)
				Else 
			   		SE1->E1_VLM2 	:= SE1->E1_VLCRUZ
					SE1->E1_TXMOEDA := Posicione("SM2",1,DTOS(DDATABASE),"M2_MOEDA"+AllTrim(Str(SC5->C5_MOEDA)))
				EndIf
				
				//SE1->E1_VLCRUZ	:= (NoRound((SE1->E1_VALOR*SE1->E1_TXMOEDA)*100,0)/100)
			EndIf
		
		SE1->(MsUnLock())
		
		DbSelectArea("SE1")
		DbSetORder(1)       //prefixo, num, parcela, tipo, fornece, loja.		
		DbSkip()
	Enddo
EndIf

_cEsp := {}

/*
LFSS - 07-08-2017 - Inativando rotina visto que a nova diretriz é gravar os campos da c5  
DbSelectArea("SD2")
DbSetORder(3)      
If DbSeek(xFilial("SD2") + _cDoc + _cSerie + _cCliente + _cLoja)// + D2->D2_COD + D2->D2_ITEM)
	While !EOF() 
	   
	
		//VARIAVEL = PESO * QUANTIDADE / EMBALAGEM
		_cVol := (Posicione("SB1",1,xFilial("SB1") + D2_COD,"B1_PESO")*D2_QUANT)/Posicione("SB1",1,xFilial("SB1") + D2_COD,"B1_QE")
		//CONTADOR DE VOLUMES
		_nBruto   := _cVol/Posicione("SB1",1,xFilial("SB1") + D2_COD,"B1_PESOEMB") 
		_nBruto2  := _nBruto2 + _nBruto 
		
		_nCtVol := _nCtVol + _cVol 
		
		
		//RECEBE TIPO DA VARIAVEL ATUAL
		_cEsp1  := Posicione("SB1",1,xFilial("SB1") + D2_COD,"B1_ESPVEND")
		
		If ascan(_cEsp,_cEsp1)==0
			AADD(_cEsp,_cEsp1)
		Endif
				
		Reclock("SD2",.F.)
		D2_NUMPO   := _cPo
		MsUnLock()
		DbSkip()
	Enddo
	 
	_nBruto3 :=  _nCtVol + _nBruto2
	
	IF Len(_cEsp)>1
		_cEsp1 := "VOLUME" 
	Endif

	
	If SC5->C5_VOLUME1 == 0 //.AND. SC5->C5_ESPECI1 == ""
		DbSelectArea("SF2")
		Reclock("SF2",.F.) 
			SF2->F2_VOLUME1  := _nCtVol
			SF2->F2_ESPECI1  := _cEsp1   
			SF2->F2_PBRUTO   := _nBruto3
		MsUnLock()
	Endif
	
Endif	*/

// LFSS 07-08-2017 - Gravando dados do SC5 no SF2 
DbSelectArea("SF2")
Reclock("SF2",.F.) 
SF2->F2_VOLUME1  := SC5->C5_VOLUME1
SF2->F2_ESPECI1  := SC5->C5_ESPECI1 
SF2->F2_PBRUTO   := SC5->C5_PBRUTO 
SF2->F2_PLIQUI   := SC5->C5_PESOL
MsUnLock()
// FDA      

DbSelectArea("SF2")
If SF2->F2_TIPO $ "D|B"
	Reclock("SF2",.F.)
	SF2->F2_NOMCLI := Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE + SF2->F2_LOJA,"A2_NREDUZ")
	MsUnLock()
Else  
	Reclock("SF2",.F.)
	SF2->F2_NOMCLI := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE + SF2->F2_LOJA,"A1_NREDUZ")	
	MsUnLock()
EndIf
If !empty(SF2->F2_TRANSP)
	Reclock("SF2",.F.)
	SF2->F2_NOMTRA:= POSICIONE("SA4",1,xfilial("SA4")+SF2->F2_TRANSP,"A4_NREDUZ")                    
	MsUnLock()
EndIF

		
return
