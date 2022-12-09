#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  11/22/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RCRME010()

Local _cCodOp  := M->AD1_PROSPE
Local _cOport  := M->AD1_NROPOR
Local _cRevis  := M->AD1_REVISA
Local _cEstag  := M->AD1_STAGE
Local _cTipo   := M->AD1_TIPO
Local _cProce  := "000001"
Local _cEstag1 := "000001"
Local _cEstag2 := "000002"
Local _cDtini  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_DTCAD") 
Local _cHrini  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_HRCAD") 
Local _cDtenc  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_DTENCE") 
Local _cHrenc  := Posicione("SUS",1,xFilial("SUS")+_cCodOP+"01","US_HRENCE") 
Local _Deciso  := M->AD1_DECI
Local _cInflu  := M->AD1_INFLU
Local _cUsuar  := M->AD1_USUA
Local _cDescr  := M->AD1_DESC
Local _cAmost  := M->AD1_AMOST
Local _cConc1  := M->AD1_CONCL1
Local _cAprov  := M->AD1_APROV
Local _cQuant  := M->AD1_QTDAV
Local _cConc3  := M->AD1_CONCL3
Local _cTestI  := M->AD1_TINDUS
Local _cFtec   := M->AD1_FTEC
Local _cFseg   := M->AD1_FSEG
Local _cNecdc  := M->AD1_DOCS
Local _cSegme  := M->AD1_SEGMEN
Local _cAplic  := M->AD1_APLIC
Local _cQtmp   := M->AD1_QTMP
Local _cDescn  := M->AD1_DESCNC
Local _cCusto  := M->AD1_CUSTOF
Local _cMelhor := M->AD1_MLPROC
Local _cRendim := M->AD1_AUMREB
Local _cQuali  := M->AD1_MLQUAL
Local _cInova  := M->AD1_INOV
Local _cNeces  := M->AD1_NECTEC
Local _cQtusa  := M->AD1_QTUSA
Local _cQtpag  := M->AD1_QTPG
Local _cTotano := M->AD1_TOTANO
Local _cConcor := M->AD1_CONC
Local _cNomcon := M->AD1_NCONC
Local _cProdco := M->AD1_PRODC
Local _cOqusa  := M->AD1_OQUSA
Local _cMpproc := M->AD1_MPPROC
Local _cDescpr := M->AD1_DESCP
Local _cCodpro := M->AD1_CODPRO
Local _cTeste  := M->AD1_TESTE
Local _cResult := M->AD1_RESULT

If _cEstag == "000004" .AND. (_cTipo == "2" .OR. _cTipo == "3")
	aCabec      := {}     //-Array com os campos
	MsErroAuto  := .F.
	lRet     	:= .T.
 
	aCabec:= 	   {{ "AD1_FILIAL"  		     , xFilial("AD1")                  	, NIL },;
 			  		{ "AD1_NROPOR"  		     , AD1->AD1_NROPOR                 	, NIL },;
   		  			{ "AD1_REVISA"  		     , AD1->AD1_REVISA                 	, NIL },;
		  			{ "AD1_STAGE "   			 , "000010"	                    	, NIL }} 
  
	MSExecAuto({|x,y|FATA300(x,y)},4,aCabec)
  
   		If MsErroAuto		
	 		DisarmTransaction()		
	 		MostraErro()		
			lRet := .F.	
 		Else		
	 		lRet := .T.	
  		EndIf
EndIf

If _cEstag == "000004" .AND. _cTipo == "1" .AND. !Empty(_Deciso) .AND. !Empty(_cInflu) .AND. !Empty(_cUsuar) .AND. !Empty(_cDescr)
	aCabec      := {}     //-Array com os campos
	MsErroAuto  := .F.
	lRet     	:= .T.
 
	aCabec:= 	   {{ "AD1_FILIAL"  		     , xFilial("AD1")                  	, NIL },;
 			  		{ "AD1_NROPOR"  		     , AD1->AD1_NROPOR                 	, NIL },;
   		  			{ "AD1_REVISA"  		     , AD1->AD1_REVISA                 	, NIL },;
		  			{ "AD1_STAGE "   			 , "000005"	                    	, NIL }} 
  
	MSExecAuto({|x,y|FATA300(x,y)},4,aCabec)
  
   		If MsErroAuto		
	 		DisarmTransaction()		
	 		MostraErro()		
			lRet := .F.	
 		Else		
	 		lRet := .T.	
  		EndIf
EndIf

If _cEstag == "000005" .AND. !Empty(_cSegme) .AND. !Empty(_cAplic) .AND. !Empty(_cQtmp) .AND. !Empty(_cDescn) .AND. !Empty(_cMpproc) .AND. !Empty(_cDescpr);
                       .AND. (_cCusto = .T. .OR. _cMelhor = .T. .OR. _cRendim = .T. .OR. _cQuali = .T. .OR. _cInova = .T.) .AND.;
                       (_cNeces = .T. .OR. (!Empty(_cQtusa) .AND. !Empty(_cQtpag) .AND. !Empty(_cTotano) .AND. !Empty(_cConcor);
                                                            .AND. !Empty(_cNomcon) .AND. !Empty(_cProdco) .AND. !Empty(_cOqusa)))
	aCabec      := {}     //-Array com os campos
	MsErroAuto  := .F.
	lRet     	:= .T.
 
	aCabec:= 	   {{ "AD1_FILIAL"  		     , xFilial("AD1")                  	, NIL },;
 			  		{ "AD1_NROPOR"  		     , AD1->AD1_NROPOR                 	, NIL },;
   		  			{ "AD1_REVISA"  		     , AD1->AD1_REVISA                 	, NIL },;
		  			{ "AD1_STAGE "   			 , "000006"	                    	, NIL }} 
  
	MSExecAuto({|x,y|FATA300(x,y)},4,aCabec)
  
   		If MsErroAuto		
	 		DisarmTransaction()		
	 		MostraErro()		
			lRet := .F.	
 		Else		
	 		lRet := .T.	
  		EndIf
EndIf

If _cEstag == "000006" .AND. !Empty(_cCodpro) .AND. !Empty(_cTeste) .AND. !Empty(_cResult)
	aCabec      := {}     //-Array com os campos
	MsErroAuto  := .F.
	lRet     	:= .T.
 
	aCabec:= 	   {{ "AD1_FILIAL"  		     , xFilial("AD1")                  	, NIL },;
 			  		{ "AD1_NROPOR"  		     , AD1->AD1_NROPOR                 	, NIL },;
   		  			{ "AD1_REVISA"  		     , AD1->AD1_REVISA                 	, NIL },;
		  			{ "AD1_STAGE "   			 , "000007"	                    	, NIL }} 
  
	MSExecAuto({|x,y|FATA300(x,y)},4,aCabec)
  
   		If MsErroAuto		
	 		DisarmTransaction()		
	 		MostraErro()		
			lRet := .F.	
 		Else		
	 		lRet := .T.	
  		EndIf
EndIf

If _cEstag == "000007" .AND. ((!Empty(_cAmost) .AND. !Empty(_cAprov)) .OR. _cConc1 = "3")
	aCabec      := {}     //-Array com os campos
	MsErroAuto  := .F.
	lRet     	:= .T.
 
	aCabec:= 	   {{ "AD1_FILIAL"  		     , xFilial("AD1")                  	, NIL },;
 			  		{ "AD1_NROPOR"  		     , AD1->AD1_NROPOR                 	, NIL },;
   		  			{ "AD1_REVISA"  		     , AD1->AD1_REVISA                 	, NIL },;
		  			{ "AD1_STAGE "   			 , "000008"	                    	, NIL }} 
  
	MSExecAuto({|x,y|FATA300(x,y)},4,aCabec)
  
   		If MsErroAuto		
	 		DisarmTransaction()		
	 		MostraErro()		
			lRet := .F.	
 		Else		
	 		lRet := .T.	
  		EndIf
EndIf
 
If _cEstag == "000008" .AND. ((!Empty(_cQuant) .AND. !Empty(_cTestI)) .OR. _cConc3 = "3")
	aCabec      := {}     //-Array com os campos
	MsErroAuto  := .F.
	lRet     	:= .T.
 
	aCabec:= 	   {{ "AD1_FILIAL"  		     , xFilial("AD1")                  	, NIL },;
 			  		{ "AD1_NROPOR"  		     , AD1->AD1_NROPOR                 	, NIL },;
   		  			{ "AD1_REVISA"  		     , AD1->AD1_REVISA                 	, NIL },;
		  			{ "AD1_STAGE "   			 , "000009"	                    	, NIL }} 
  
	MSExecAuto({|x,y|FATA300(x,y)},4,aCabec)
  
   		If MsErroAuto		
	 		DisarmTransaction()		
	 		MostraErro()		
			lRet := .F.	
 		Else		
	 		lRet := .T.	
  		EndIf
EndIf

If _cEstag == "000009" .AND. ((_cFtec = .T. .AND. _cFseg = .T.) .OR. _cNecdc = .T.)
	aCabec      := {}     //-Array com os campos
	MsErroAuto  := .F.
	lRet     	:= .T.
 
	aCabec:= 	   {{ "AD1_FILIAL"  		     , xFilial("AD1")                  	, NIL },;
 			  		{ "AD1_NROPOR"  		     , AD1->AD1_NROPOR                 	, NIL },;
   		  			{ "AD1_REVISA"  		     , AD1->AD1_REVISA                 	, NIL },;
		  			{ "AD1_STAGE "   			 , "000010"	                    	, NIL }} 
  
	MSExecAuto({|x,y|FATA300(x,y)},4,aCabec)
                                                                                                              
  
  
   		If MsErroAuto		
	 		DisarmTransaction()		
	 		MostraErro()		
			lRet := .F.	
 		Else		
	 		lRet := .T.	
  		EndIf
EndIf

If _cEstag == "000011" .AND. !Empty(_cAceite) //Aceite Proposta

		aCabec := {}     //-Array com os campos
   		MsErroAuto  := .F.
		lRet	:= .T.
	 
		aCabec:= 	   {{ "AD1_FILIAL"  		     , xFilial("AD1")                  	, NIL },;
	 			  		{ "AD1_NROPOR"  		     , AD1->AD1_NROPOR                 	, NIL },;
	   		  			{ "AD1_REVISA"  		     , AD1->AD1_REVISA                 	, NIL },;
			  			{ "AD1_STAGE "   			 , "000012"	                    	, NIL }} 
	  
		MSExecAuto({|x,y|FATA300(x,y)},4,aCabec)
	  
	   		If MsErroAuto		
		 		DisarmTransaction()		
		 		MostraErro()		
				lRet := .F.	   
	 		Else		
		 		lRet := .T.	
	   		EndIf

EndIf
                                                               
Return