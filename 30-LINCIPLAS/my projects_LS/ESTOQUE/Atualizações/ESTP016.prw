#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"

/*
+========================================================+
|Programa: ESTP016 | Autor: Antonio Carlos | 07/12/09    |
+========================================================+
|Descricao: Transferencia de mercadoria via Movimentação |
|Interna.                                                |
+========================================================+
|Uso: Laselva                                            |
+========================================================+
*/

User Function ESTP016()

Private aSays		:= {}
Private aButtons	:= {}
Private	nOpca		:= 0 
Private cCadastro	:= "Transferencia entre almoxarifado"
Private _cTm1		:= "504"
Private _cTm2		:= "004"
Private _cLoc1		:= "01"
Private _cLoc2		:= "04"
Private lMsErroAuto	:= .F.

AADD(aSays,"Este programa tem o objetivo de realizar transferencia")
AADD(aSays,"de mercadoria entre almoxarifado via Movimentação Interna")
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
FormBatch( cCadastro, aSays, aButtons )
	
If nOpcA <> 1
 	Return Nil
EndIf		

Processa( {|lEnd| AtuDados(@lEnd)}, "Aguarde...","Processando rotina...", .T. )
		
Return

Static Function AtuDados(lEnd)

Local nTotRec	:= 0
Local _nReg		:= 0
Local aCab1		:= {}
Local aCab2		:= {}
Local aItens1	:= {}
Local aTotIt1	:= {}
Local aItens2	:= {}
Local aTotIt2	:= {}

cQry := " SELECT * FROM TRANSF_CD ORDER BY COD "
TcQuery cQry NEW ALIAS "TMP"

Count To nTotRec
ProcRegua(nTotRec)

DbselectArea("TMP")
TMP->( DbGoTop() )
If TMP->( !Eof() )
	
	While TMP->( !Eof() ) 
		
		IncProc("Incluindo itens... ")                                                                      
	
		cTm	:= Alltrim(_cTm1)
		cCC	:= Space(9)
		
		/*
		If Len(aCab1) == 0
		
			aCab1	:= {{"D3_TM" 		,_cTm1				,NIL},;
						{"D3_CC" 		,Space(9)			,NIL},;
						{"D3_DOC" 		,"TRANSF01"			,NIL},;
						{"D3_EMISSAO"	,dDatabase 			,NIL}}
		EndIf				                        	
		*/
		
		If Len(aCab2) == 0
		
			aCab2	:= {{"D3_TM" 		,_cTm2				,NIL},;
						{"D3_CC" 		,Space(9)			,NIL},;
						{"D3_DOC" 		,"TRANSF04"			,NIL},;
						{"D3_EMISSAO"	,dDatabase 			,NIL}}
		EndIf				                        	
	
		/*
		DbSelectArea("SF5")
		SF5->( DbSetOrder(1) )
		If SF5->( DbSeek(xFilial("SF5")+Alltrim(_cTm1)) )
			
			DbSelectArea("SB1")
			SB1->( DbSetOrder(1) )
			If SB1->( DbSeek(xFilial("SB1")+Alltrim(TMP->COD)) )
				Aadd(aItens1, {"D3_COD"    	,Alltrim(TMP->COD)		,NIL})                                            
				Aadd(aItens1, {"D3_UM"    	,SB1->B1_UM				,NIL})                                            
				Aadd(aItens1, {"D3_QUANT"  	,TMP->QTD		  		,NIL})
				Aadd(aItens1, {"D3_LOCAL"  	,_cLoc1					,NIL})
	    		
		    	If SF5->F5_VAL = "S"
					Aadd(aItens1, {"D3_CUSTO1"	,TMP->D3_CUSTO1 ,NIL})
  				EndIf
  				
  				Aadd(aTotIt1,aItens1)
				aItens1 :={}		
				_nReg++
				
  			EndIf				
  			
		EndIf  
		*/
		
		DbSelectArea("SF5")
		SF5->( DbSetOrder(1) )
		If SF5->( DbSeek(xFilial("SF5")+Alltrim(_cTm2)) )
			
			DbSelectArea("SB1")
			SB1->( DbSetOrder(1) )
			If SB1->( DbSeek(xFilial("SB1")+Alltrim(TMP->COD)) )
				Aadd(aItens2, {"D3_COD"    	,Alltrim(TMP->COD)		,NIL})                                            
				Aadd(aItens2, {"D3_UM"    	,SB1->B1_UM				,NIL})                                            
				Aadd(aItens2, {"D3_QUANT"  	,TMP->QTD		  		,NIL})
				Aadd(aItens2, {"D3_LOCAL"  	,_cLoc2					,NIL})
	    		
		    	If SF5->F5_VAL = "S"
					Aadd(aItens2, {"D3_CUSTO1"	,TMP->D3_CUSTO1 ,NIL})
  				EndIf
  				
  				Aadd(aTotIt2,aItens2)
				aItens2 :={}		
				_nReg++
				
  			EndIf				
  			
		EndIf  
			
		/*
		DbSelectArea("SB2")
		SB2->( DbsetOrder(1) )
		If !SB2->( DbSeek(xFilial("SB2")+TMP->COD+_cLoc2) )
			RecLock("SB2",.T.) 
			SB2->B2_FILIAL	:= xFilial("SB2")		
			SB2->B2_COD		:= TMP->COD
			SB2->B2_LOCAL	:= _cLoc2
			SB2->( MsUnLock() )
		EndIf	
		*/
	
		TMP->( DbSkip() )

	EndDo                  
		
	If _nReg > 0
		
		/*
		MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab1,aTotIt1,3)
		If lMsErroAuto
			MostraErro()
		EndIf
		*/
		
		MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab2,aTotIt2,3)
		If lMsErroAuto
			MostraErro()
		EndIf
		
	EndIf
			
	Aviso("Atenção","Processamento efetuado com sucesso!",{"OK"},1,"Finalizado!")	
		
Else

	Aviso("Atenção","Nao existem registros para processamento!",{"OK"},1,"Arquivo vazio!")
	
EndIf	

DbSelectArea("TMP")
DbCloseArea()

Return