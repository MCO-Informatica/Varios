#include "PROTHEUS.CH"
#include "TBICONN.CH"
#include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSFD0007  ºAutor  ³Rodrigo Seiti Mitaniº Data ³  20/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Job de geração de pedidos por atendimento fechado           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CertiSign                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSFS0007(_xfil)
/*
If _xfil[1] == 1
PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01'
Else
PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
End If 
*/


If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")                                                                                            	
End If

BeginSql Alias "TRB"
Select  PA0_FILIAL, PA0_OS
From %Table:PA0% PA0
Where PA0.%NotDel%
and PA0_OS Between '      ' and 'ZZZZZZ'
and PA0_CLILOC Between '      ' and 'ZZZZZZ'
and PA0_DTAGEN Between '20060101' and %Exp:DToS(DDataBase)%
and PA0_STATUS = 'F' and  PA0_SITUAC = 'L'
EndSql

//and PA0_FILORI = %Exp:Iif(_xfil[1] == 1, '01','02')%

DbSelectArea("TRB")
_numped	:= GETSXENUM("SC5","C5_NUM")

//ProcRegua( LastRec() )
DbGoTop()
Do While !Eof("TRB")
	
	_aItens	:= {}
	_aItenh	:= {}
	_aCab 	:= {}
	_ncounts	:= 1
	_ncounth	:= 1
	If Select("DET") > 0
		DbSelectArea("DET")
		DbCloseArea("DET")
	End If

BeginSql Alias "DET"
%NoParser%
Select * From %Table:PA1% PA1 Where PA1_OS = %Exp:TRB->PA0_OS%
and PA1.%NotDel% 
EndSql

	
	DbSelectArea("DET")
	DbGoTop()
	Do While !Eof("DET")
		If DET->PA1_FATURA == 'S'
			If !Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_TIPO")	$ GetMv("MV_MATHARD")
				
				_aRets := {}
				aAdd( _aRets, {"C6_FILIAL"	, xFilial("SC6")											 		, NIL})
				aAdd( _aRets, {"C6_NUM"		, 	_numped													 		, NIL})
				aAdd( _aRets, {"C6_ITEM"		, StrZero(_ncounts,2)									 	 	, NIL})
				aAdd( _aRets, {"C6_PRODUTO"	, DET->PA1_PRODUT											 		, NIL})
				aAdd( _aRets, {"C6_DESCRI"	, Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_DESC")	, NIL})
				aAdd( _aRets, {"C6_UM" 		, Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_UM") 	, NIL})
				aAdd( _aRets, {"C6_QTDVEN" 	, DET->PA1_QUANT 													, NIL})
				aAdd( _aRets, {"C6_PRCVEN"	, DET->PA1_PRCUNI													, NIL})
				aAdd( _aRets, {"C6_TES"		, DET->PA1_TES            										 	, "ALLWAYSTRUE()"})
				aAdd( _aRets, {"C6_PRUNIT"	, DET->PA1_PRCUNI													, NIL})
				aAdd( _aRets, {"C6_VALOR"	, DET->PA1_VALOR   											 		, NIL})
				aAdd( _aRets, {"C6_COMIS1"	, 0											 						, NIL})
				aAdd( _aRets, {"C6_ENTREG"	, dDataBase													 		, NIL})
				aAdd( _aRets, {"C6_LOCAL"	, "00" 																, "ALLWAYSTRUE()"})
				aAdd( _aRets, {"C6_QTDLIB"	, DET->PA1_QUANT													, NIL})
				aAdd( _aItens, _aRets)
				
				_ncounts:= _ncounts + 1
			End If
		End If
		DbSelectArea("DET")
		DbSkip()
	End Do
	
	If Select("CAB") > 0
		DbSelectArea("CAB")
		DbCloseArea("CAB")
	End If
	

BeginSql Alias "CAB"
%NoParser%
Select * From %Table:PA0% PA0 Where PA0_OS = %Exp:TRB->PA0_OS%
and PA0.%NotDel% 
EndSql

	_aCab := {}
	aAdd( _aCab,{"C5_FILIAL"	, xFilial("SC5")		              												, NIL})
	aAdd( _aCab,{"C5_NUM"		, _numped				     														, NIL})
	aAdd( _aCab,{"C5_TIPO"		, "N"			    																, NIL})
	aAdd( _aCab,{"C5_TIPOCLI"	, Posicione("SA1",1 ,xFilial("SA1") + Iif(!Empty(CAB->PA0_CLIFAT),CAB->PA0_CLIFAT+CAB->PA0_LOJAFA,CAB->PA0_CLILOC+CAB->PA0_LOJLOC), "A1_TIPO"), NIL})
	aAdd( _aCab,{"C5_CLIENTE"	, Iif(!Empty(CAB->PA0_CLIFAT),CAB->PA0_CLIFAT,CAB->PA0_CLILOC), NIL})
	aAdd( _aCab,{"C5_LOJACLI"	, Iif(!Empty(CAB->PA0_LOJAFA),CAB->PA0_LOJAFA,CAB->PA0_LOJLOC), NIL})
	aAdd( _aCab,{"C5_VEND1"  	, " "				  		                   										, "ALLWAYSTRUE()"})
	aAdd( _aCab,{"C5_CONDPAG"	, CAB->PA0_CONDPA			                    									, NIL})
	aAdd( _aCab,{"C5_TPFRETE"	, "F"									 											, NIL})
	aAdd( _aCab,{"C5_EMISSAO"	, dDATABASE      																   	, NIL})
	aAdd( _aCab,{"C5_MOEDA"  	, 1		     																	   	, NIL})
	aAdd( _aCab,{"C5_XNATURE" 	, "FT010001"		     															, NIL})
	aAdd( _aCab,{"C5_VEND1" 	, "CC0001"		     																, NIL})
	aAdd( _aCab,{"C5_AR" 		, CAB->PA0_OS     																	, NIL})
	
	If Len(_aItens) > 0
		lMsHelpAuto := .t.
		lMsErroAuto := .f.
				
		
		MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCab,_aItens,3)
		
	End If
	
	If lMsErroAuto
		MemoWrite('errajob.txt',MostraErro())
		RollBackSXE()
		
	Else
		ConfirmSX8()
		_numped	:= GETSXENUM("SC5","C5_NUM")
	End If
	
	If Select("DET") > 0
		DbSelectArea("DET")
		DbCloseArea("DET")
	End If

BeginSql Alias "DET"
%NoParser%
Select * From %Table:PA1% PA1 Where PA1_OS = %Exp:TRB->PA0_OS%
and PA1.%NotDel% 
EndSql

	
	DbSelectArea("DET")
	DbGoTop()
	Do While !Eof("DET")
		If DET->PA1_FATURA == 'S'
			If Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_TIPO")	$ GetMv("MV_MATHARD")
				
				_hard := .T.
				_aReth := {}
				aAdd( _aReth, {"C6_FILIAL"	, xFilial("SC6")											 			, NIL})
				aAdd( _aReth, {"C6_NUM"		, 	_numped													 			, NIL})
				aAdd( _aReth, {"C6_ITEM"		, StrZero(_ncounth,2)									 	 		, NIL})
				aAdd( _aReth, {"C6_PRODUTO"	, DET->PA1_PRODUT											 			, NIL})
				aAdd( _aReth, {"C6_DESCRI"	, Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_DESC")		, NIL})
				aAdd( _aReth, {"C6_UM" 		, Posicione("SB1",1 ,xFilial("SB1") + DET->PA1_PRODUT,  "B1_UM") 		, NIL})
				aAdd( _aReth, {"C6_QTDVEN" 	, DET->PA1_QUANT 														, NIL})
				aAdd( _aReth, {"C6_PRCVEN"	, DET->PA1_PRCUNI														, NIL})
				aAdd( _aReth, {"C6_TES"		, DET->PA1_TES            										 		, "ALLWAYSTRUE()"})
				aAdd( _aReth, {"C6_PRUNIT"	, DET->PA1_PRCUNI														, NIL})
				aAdd( _aReth, {"C6_VALOR"	, DET->PA1_VALOR   											 			, NIL})
				aAdd( _aReth, {"C6_COMIS1"	, 0											 							, NIL})
				aAdd( _aReth, {"C6_ENTREG"	, dDataBase													 			, NIL})
				aAdd( _aReth, {"C6_LOCAL"	, "00" 																	, "ALLWAYSTRUE()"})
				aAdd( _aReth, {"C6_QTDLIB"	, DET->PA1_QUANT														, NIL})
				aAdd( _aItenh, _aReth)
				
				_ncounth:= _ncounth + 1
			End If
		End If
		DbSelectArea("DET")
		DbSkip()
	End Do
	
	If Select("CAB") > 0
		DbSelectArea("CAB")
		DbCloseArea("CAB")
	End If

BeginSql Alias "CAB"
%NoParser%
Select * From %Table:PA0% PA0 Where PA0_OS = %Exp:TRB->PA0_OS%
and PA0.%NotDel% 
EndSql

	_aCab := {}
	aAdd( _aCab,{"C5_FILIAL"	, xFilial("SC5")		              													, NIL})
	aAdd( _aCab,{"C5_NUM"		, _numped				     															, NIL})
	aAdd( _aCab,{"C5_TIPO"		, "N"			    																	, NIL})
	aAdd( _aCab,{"C5_TIPOCLI"	, Posicione("SA1",1 ,xFilial("SA1") + Iif(!Empty(CAB->PA0_CLIFAT),CAB->PA0_CLIFAT+CAB->PA0_LOJAFA,CAB->PA0_CLILOC+CAB->PA0_LOJLOC), "A1_TIPO"), NIL})
	aAdd( _aCab,{"C5_CLIENTE"	, Iif(!Empty(CAB->PA0_CLIFAT),CAB->PA0_CLIFAT,CAB->PA0_CLILOC), NIL})
	aAdd( _aCab,{"C5_LOJACLI"	, Iif(!Empty(CAB->PA0_LOJAFA),CAB->PA0_LOJAFA,CAB->PA0_LOJLOC), NIL})

//	aAdd( _aCab,{"C5_TIPOCLI"	, Posicione("SA1",1 ,xFilial("SA1") + CAB->PA0_CLILOC + CAB->PA0_LOJLOC	, "A1_TIPO")	, NIL})
//	aAdd( _aCab,{"C5_CLIENTE"	, CAB->PA0_CLILOC		           														, NIL})
//	aAdd( _aCab,{"C5_LOJACLI"	, CAB->PA0_LOJLOC		           														, NIL})
	aAdd( _aCab,{"C5_VEND1"  	, " "				  		                   											, "ALLWAYSTRUE()"})
	aAdd( _aCab,{"C5_CONDPAG"	, CAB->PA0_CONDPA			                    										, NIL})
	aAdd( _aCab,{"C5_TPFRETE"	, "F"									 												, NIL})
	aAdd( _aCab,{"C5_EMISSAO"	, dDATABASE      																   		, NIL})
	aAdd( _aCab,{"C5_MOEDA"  	, 1		     																	   		, NIL})
	aAdd( _aCab,{"C5_XNATURE" 	, "FT010001"		     																, NIL})
	aAdd( _aCab,{"C5_VEND1" 	, "CC0001"		     																	, NIL})
	aAdd( _aCab,{"C5_AR" 		, CAB->PA0_OS     																	  	, NIL})
	
	
	
	If Len(_aItenh) > 0
		lMsHelpAuto := .t.                    
		lMsErroAuto := .f.
		
		MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCab,_aItenh,3)
		
	End If
	
	If lMsErroAuto
		
	  //	MostraErro()
		MemoWrite('errajob1.txt',MostraErro())
		
		RollBackSXE()
		
	Else
		
		DbSelectArea("PA0")
		DbSetOrder(1)
		DbSeek(TRB->PA0_FILIAL+TRB->PA0_OS)
		If Found()
				

			RecLock("PA0",.F.)
			PA0->PA0_SITUAC := 'P'
			PA0->PA0_STATUS := 'P'
			MsUnlock()
		End If
		//    Alert("Pedido nº"+ _numped +"gerado com sucesso.")
		ConfirmSX8()
		_numped	:= GETSXENUM("SC5","C5_NUM")
	End If
	//RollBackSXE()
	DbSelectArea("TRB")
	DbSkip()
EndDo()
Return(.T.)
