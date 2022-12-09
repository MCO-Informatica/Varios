#INCLUDE "PROTHEUS.CH"

/*      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFFSGERP    ºAutor  ³Claudio H. Corrêa º Data ³  19/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geração de Pedido de Solicitação de Atendimento             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSFSGERP(cOs)

Local lRet := .T.
Local cClifat := ""
Local cCliloj := ""

dbSelectArea("PA0")
dbSetOrder(1)
dbSeek(xFilial("PA0")+cOs)

if Found()

	//_numped	:= GETSXENUM("SC5","C5_NUM")
	//ConfirmSX8()	
	ProcRegua( LastRec() )
	
	_aItens		:= {}
	_aItenh		:= {}
	_aCab 		:= {}
	_ncounts	:= 1
	_ncounth	:= 1
	
	cClifat := IIF(Empty(PA0->PA0_CLIFAT),PA0->PA0_CLILOC,PA0->PA0_CLIFAT)
	cCliloj := POSICIONE("SA1",1,xFILIAL("SA1")+cClifat, "A1_LOJA")
		
	If Select("DET") > 0
		DbSelectArea("DET")
		DbCloseArea("DET")
	End If
								
	cQRYPA1 := "SELECT * "
	cQRYPA1 += " FROM "+RETSQLNAME("PA1")
	cQRYPA1 += " WHERE D_E_L_E_T_ = '' "
	cQRYPA1 += " AND PA1_OS = '"+cOs+"'"
								
	cQRYPA1 := changequery(cQRYPA1)
					   				 	
	dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQRYPA1),"DET", .F., .T.)
		
	DbSelectArea("DET")
	DbGoTop()
	
	nValorPed := 0
	
	Do While !Eof("DET")   
	
		If DET->PA1_FATURA $ ('S|P') 
	
			If  !Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_TIPO")	$ GetMv("MV_MATHARD")
				
				_aRets := {}
				aAdd( _aRets, {"C6_FILIAL"	, xFilial("SC6")											 		, NIL})
				aAdd( _aRets, {"C6_ITEM"	, StrZero(_ncounts,2)										 	 	, NIL})
				aAdd( _aRets, {"C6_PRODUTO"	, DET->PA1_PRODUT											 		, NIL})
				aAdd( _aRets, {"C6_DESCRI"	, Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_DESC")	, NIL})
				aAdd( _aRets, {"C6_UM" 		, Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_UM") 	, NIL})
				aAdd( _aRets, {"C6_QTDVEN" 	, DET->PA1_QUANT 													, NIL})
				aAdd( _aRets, {"C6_PRCVEN"	, DET->PA1_PRCUNI													, NIL})
				aAdd( _aRets, {"C6_TES"		, "903"            										 	, "ALLWAYSTRUE()"})
				aAdd( _aRets, {"C6_PRUNIT"	, DET->PA1_PRCUNI													, NIL})
				aAdd( _aRets, {"C6_VALOR"	, DET->PA1_VALOR   											 		, NIL})
				aAdd( _aRets, {"C6_COMIS1"	, 0											 						, NIL})
				aAdd( _aRets, {"C6_ENTREG"	, dDataBase													 		, NIL})
				aAdd( _aRets, {"C6_LOCAL"	, "00" 																, "ALLWAYSTRUE()"})
				aAdd( _aRets, {"C6_QTDLIB"	, DET->PA1_QUANT													, NIL})
				aAdd( _aItens, _aRets)
				_ncounth:= _ncounth + 1
				
				nValorPed += DET->PA1_VALOR
			 
			 End If
		
		End If
	
		DbSelectArea("DET")
	
		DbSkip()
	
	End Do
	
	_aCab := {}
	aAdd( _aCab,{"C5_FILIAL"	, xFilial("SC5")		              													, NIL})
	aAdd( _aCab,{"C5_TIPO"		, "N"			    																	, NIL})
	aAdd( _aCab,{"C5_TIPOCLI"	, Posicione("SA1",1 ,xFilial("SA1") + cClifat + cCliLoj	, "A1_TIPO")					, NIL})
	aAdd( _aCab,{"C5_CLIENTE"	, cClifat		           																, NIL})
	aAdd( _aCab,{"C5_LOJACLI"	, cCliloj				           														, NIL})
	aAdd( _aCab,{"C5_VEND1"  	, " "				  		                   											, "ALLWAYSTRUE()"})
	aAdd( _aCab,{"C5_CONDPAG"	, PA0->PA0_CONDPA			                    										, NIL})
	aAdd( _aCab,{"C5_TPFRETE"	, "F"									 												, NIL})
	aAdd( _aCab,{"C5_EMISSAO"	, dDATABASE      																   		, NIL})
	aAdd( _aCab,{"C5_MOEDA"  	, 1		     																	   		, NIL})
	aAdd( _aCab,{"C5_XNATURE" 	, "FT010001"		     																, NIL})
	aAdd( _aCab,{"C5_VEND1" 	, "CC0001"		     																	, NIL})
	aAdd( _aCab,{"C5_AR" 		, PA0->PA0_AR     																	  	, NIL})
	aAdd( _aCab,{"C5_TOTPED"	, nValorPed																	  			, NIL})	
	aAdd( _aCab,{"C5_XORIGPV"	, "5"     																	  			, NIL})	
	aAdd( _aCab,{"C5_NUMATEX"	, PA0->PA0_OS											  							, NIL})	
	aAdd( _aCab,{"C5_MENNOTA"	, "Numero do Atendimento: " + PA0->PA0_OS	  											, NIL})	
		
	If Len(_aItens) > 0
	
		lMsHelpAuto := .T.
		lMsErroAuto := .F.
									
		MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCab,_aItens,3) 
									
		If !lMsErroAuto						
			_numped := SC5->C5_NUM					
			//Grava o numero do Pedido Microsiga no Atendimento
			DbSelectArea("PA1")
			DbSetOrder(1)
			DbSeek(xFilial("PA1")+PA0->PA0_OS)
		
			While !Eof("PA1") .and. PA1->PA1_OS == PA0->PA0_OS
		
				If PA1->PA1_FATURA $ "S|P"
			
					BEGIN TRANSACTION
					RecLock("PA1",.F.)
					PA1->PA1_MSPED := _numped
					MsUnlock()
					END TRANSACTION			
					
				EndIf
			
				DbSkip()
		
			EndDo
								
			/* /Grava o numero do Atendimento no Pedido de Venda     //??? Não é necessário porque o execauto já faz isso
			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xFilial()+_numped)
								
			If SC5->C5_NUM == _numped
			
				BEGIN TRANSACTION
				RecLock("SC5",.F.)
				SC5->C5_NUMATEX := 	PA0->PA0_OS
				SC5->C5_MENNOTA	:=	"Numero do Atendimento: " + PA0->PA0_OS
				MsUnlock()
				END TRANSACTION
			
			EndIf
								
			_numped	:= GETSXENUM("SC5","C5_NUM")
			ConfirmSX8()
			*/	
		Else
		
			lRet := .F.
			mostraerro()
		
		EndIf
										
	EndIf

Endif		
		
Return lRet