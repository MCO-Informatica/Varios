#include "protheus.ch"
#include "topconn.ch"
/*
RCTRA002    : Autor : Eugenio Arcanjo : Data : 31/03/15
*/

User Function FA050INC()
Local _aAreaAtu	:= GetArea()
Local _lRet		:= .T.
Local dDate 	:= M->E2_EMISSAO
Local _cNatuRe  := M->E2_NATUREZ 
Local _cTipo	:= M->E2_TIPO

IF  CMODULO <> "GCT" .And. CMODULO <> "COM" .And. CMODULO <> "EST" .and. _cTipo <> "DIC"
	
	
	IF dDate > ctod("01/04/2015") .AND.  !(ALLTRIM(_cNatuRe)) == '2353' 
		
		If Empty(M->E2_CCD) .or.  Empty(M->E2_ITEMD) .or. Empty(M->E2_EC05DB)  .or. Empty(M->E2_CONTAD) .or. Empty(M->E2_CLVLDB)
			_lRet := .F.
			MsgAlert("Entidades contábeis não preenchidas (Projeto + C.custo + Classe Orcamentária), favor verificar!","Atenção")
		Endif
		
	Endif
	
	RestArea( _aAreaAtu )
Endif

// Grava título Liberado para RJ por ser titulo de Imposto (Gileno - 08/06/2020)
If SE2->E2_EMISSAO > CtoD("16/10/2019")
   If SE2->E2_TIPO = "INS" .OR. SE2->E2_TIPO="IRF".OR. SE2->E2_TIPO="ISS" .OR. SE2->E2_PREFIXO="TAQ"
   		SE2->E2_APROVA  := "000001"
   		SE2->E2_DATALIB := Date()
   		SE2->E2_STATLIB := "03" 
   		SE2->E2_USUALIB := "INC POSTERIOR REC JUDIC  " 
   		SE2->E2_CODAPRO := "000000"
   		SE2->E2_XRJ     := "N"
		   
   EndIf 
EndIf    
      

Return( _lRet )
