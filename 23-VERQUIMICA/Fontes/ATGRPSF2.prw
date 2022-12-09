#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE CRLF CHR(13) + CHR(10)

USER FUNCTION ATGRPSF2()
LOCAL _CQRY := ""   
PRIVATE _CMONTATXT := ""
PRIVATE _ASELSF2 := {}
PRIVATE _ASELZ04 := {}    
PRIVATE _ASELGRL := {}   	  
PRIVATE	_DUPDATE
PRIVATE _DDIFF     
PRIVATE _CGRPVEN := ""     
PRIVATE _CLOG := "DOCUMENTO|SERIE|CLIENTE|LOJA|VENDEDOR|EMISSAO|DIVISAO|OBSERVACOES"  + CRLF    
PRIVATE _COBS := ""   



_CQRY += "  SELECT * FROM (  															"   + CRLF
_CQRY += "  SELECT SF2.F2_CLIENTE, F2_LOJA  FROM SF2010 SF2  							"   + CRLF
_CQRY += "  WHERE   								  									"   + CRLF
_CQRY += "  	SF2.D_E_L_E_T_ <> '*'  													"   + CRLF
_CQRY += "  	AND SF2.F2_GRPVEN = '      '   											"   + CRLF
_CQRY += "  	AND SF2.F2_TIPO = 'N'   												"   + CRLF
_CQRY += "  	AND SF2.F2_VEND1 <> '      '  											"   + CRLF
_CQRY += "  GROUP BY SF2.F2_CLIENTE, F2_LOJA  											"   + CRLF
_CQRY += "  ORDER BY SF2.F2_CLIENTE  													"   + CRLF
_CQRY += "  ) SF2 INNER JOIN (  														"   + CRLF
_CQRY += "  SELECT Z04.Z04_CLIENT, Z04.Z04_LOJA	FROM Z04010 Z04  						"   + CRLF
_CQRY += "  WHERE Z04.Z04_GRPVEN <> '      '  											"   + CRLF 
_CQRY += "     AND Z04.Z04_STATUS = 'V'  												"   + CRLF 
_CQRY += "  GROUP BY Z04.Z04_CLIENT, Z04.Z04_LOJA 										"   + CRLF
_CQRY += "  ORDER BY Z04.Z04_CLIENT   												  	"   + CRLF
_CQRY += "  ) Z04 ON (SF2.F2_CLIENTE = Z04.Z04_CLIENT AND SF2.F2_LOJA = Z04.Z04_LOJA) 	"   + CRLF

IF SELECT("TBGRPSF2") > 0
	TBGRPSF2->(DBCLOSEAREA())
EndIf

TCQUERY _CQRY NEW ALIAS "TBGRPSF2"      

DBSELECTAREA("SF2"); DBSETORDER(2)
DBSELECTAREA("Z04"); DBSETORDER(4) //Precisa Criar para filtrar por cliente e loja     

WHILE TBGRPSF2->(!EoF())                                                                             	
	_CCODCLI := TBGRPSF2->F2_CLIENTE
	_CLOJCLI := TBGRPSF2->F2_LOJA 
	_ASELSF2 := {}
	_ASELZ04 := {}                  

	_CQRY := ""
	_CQRY := "SELECT F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_VEND1, F2_EMISSAO, F2_GRPVEN FROM " + RETSQLNAME("SF2") + " WHERE D_E_L_E_T_ <> '*' AND F2_CLIENTE = '"+_CCODCLI+"' AND F2_LOJA = '"+_CLOJCLI+"' AND F2_GRPVEN = '      '"  
	IF SELECT("TMPGRSF2") > 0
		TMPGRSF2->(DBCLOSEAREA())
	EndIf   
	TCQUERY _CQRY NEW ALIAS "TMPGRSF2"     
	
	_CQRY := ""
	_CQRY += "SELECT Z04_DOC, Z04_SERIE, Z04_CLIENT, Z04_LOJA, Z04_VENDED, Z04_EMISSA, Z04_REGIAO, Z04_GRPVEN FROM "+ RETSQLNAME("Z04")+ " WHERE D_E_L_E_T_ <> '*' AND Z04_CLIENT = '"+_CCODCLI+"'	AND Z04_LOJA = '"+_CLOJCLI+"' AND Z04_STATUS = 'V' GROUP BY Z04_DOC, Z04_SERIE, Z04_CLIENT, Z04_LOJA, Z04_VENDED, Z04_EMISSA, Z04_REGIAO, Z04_GRPVEN "   
	IF SELECT("TMPGRZ04") > 0
		TMPGRZ04->(DBCLOSEAREA())
	EndIf

	TCQUERY _CQRY NEW ALIAS "TMPGRZ04" 
	 		                                      
	WHILE TMPGRSF2->(!EOF())
		AADD(_ASELSF2, {TMPGRSF2->F2_DOC, TMPGRSF2->F2_SERIE, TMPGRSF2->F2_CLIENTE, TMPGRSF2->F2_LOJA, TMPGRSF2->F2_VEND1, TMPGRSF2->F2_EMISSAO, TMPGRSF2->F2_GRPVEN})
	  	TMPGRSF2->(DBSKIP())
	ENDDO       
		
	WHILE TMPGRZ04->(!EOF())
			AADD(_ASELZ04, {TMPGRZ04->Z04_DOC, TMPGRZ04->Z04_SERIE,  TMPGRZ04->Z04_CLIENT, TMPGRZ04->Z04_LOJA,  TMPGRZ04->Z04_VENDED, TMPGRZ04->Z04_EMISSA, TMPGRZ04->Z04_GRPVEN})
		TMPGRZ04->(DBSKIP())
	ENDDO                         

	FOR I := 1 TO LEN(_ASELSF2) STEP 1  
		_NDANT := 0 
		_COBS := ""
		_CF2VEND := _ASELSF2[I][5]
		_DF2EMIS := STOD(_ASELSF2[I][6])    
		_lPriY	 :=	.T.
		FOR Y := 1 TO LEN(_ASELZ04) STEP 1
		
			_CZ4VEND := _ASELZ04[Y][5]
			_DZ4EMIS := STOD(_ASELZ04[Y][6])     
			_DDIFF := DATEDIFFDAY(_DF2EMIS,_DZ4EMIS)
			IF _lPriY
		   		IF _ASELZ04[Y][5] = _ASELSF2[I][5]
					_DUPDATE := _DZ4EMIS 
					_NDANT := _DDIFF	          
					_ASELSF2[I][7] := _ASELZ04[Y][7] 
				    _lPriY := .F.
				ENDIF
			ELSE          
				IF _DDIFF <= _NDANT
					IF _ASELZ04[Y][5] = _ASELSF2[I][5]
						_NDANT := _DDIFF
						_DUPDATE := _DZ4EMIS   
						_ASELSF2[I][7] := _ASELZ04[Y][7] 											   
					ENDIF
				ENDIF			
			ENDIF				
		NEXT   
	NEXT     
	    

	FOR NX := 1 TO LEN(_ASELSF2) STEP 1  
		 IF (!EMPTY(_ASELSF2[NX][7]))
			AADD(_APROVIS,_ASELSF2[NX])    
			_cSQL := "UPDATE SF2010 SET F2_GRPVEN = '" +_ASELSF2[NX][7]+ "' WHERE F2_DOC = '" +_ASELSF2[NX][1]+ "' AND F2_SERIE = '"+_ASELSF2[NX][2]+"'" 
			nStatus := TCSqlExec(_cSQL)            
			_cStatus := ""
			If (nStatus < 0)     
				_cStatus := "Update nao realizado com sucesso"
			Else
				_cStatus := "Update realizado com sucesso"
			EndIf
			_CLOG += _ASELSF2[NX][1]+"|"+_ASELSF2[NX][2]+"|"+_ASELSF2[NX][3]+"|"+_ASELSF2[NX][4]+"|"+_ASELSF2[NX][5]+"|"+_ASELSF2[NX][6]+"|"+_ASELSF2[NX][7]+"|"+ "|Resultado SQL: " + _cStatus + CRLF    
		 ENDIF
	NEXT	  
TBGRPSF2->(DBSKIP())
ENDDO          

TMPGRSF2->(DBCLOSEAREA())  
TMPGRZ04->(DBCLOSEAREA())  
TBGRPSF2->(DBCLOSEAREA())    

CRIACSV(_CLOG)

 
RETURN()      



Static Function CRIACSV(cMontaTxt,cTipo)

 cNomeArq := "C:\RELATORIO\Relatorio_"+SubStr(DtoS(date()),7,2)+"_"+SubStr(DtoS(date()),5,2)+"_"+SubStr(DtoS(date()),1,4)+"_"+Transform(Time(),"@E 99999999")+"_"+cTipo+".csv"

 nHandle := FCREATE(cNomeArq)

 FWrite(nHandle,cMontaTxt)

 FClose(nHandle)

 MsgAlert("Relatorio salvo em: "+"C:\Relatorio_"+SubStr(DtoS(date()),7,2)+"_"+SubStr(DtoS(date()),5,2)+"_"+SubStr(DtoS(date()),1,4)+"_"+Transform(Time(),"@E 99999999")+"_"+cTipo+".csv")

return
                                        



USER FUNCTION ATSF2GRP ()

LOCAL _CQUERY 		:= "SELECT * FROM SF2010 WHERE F2_GRPVEN = '      ' AND F2_VEND1 <> '      ' AND D_E_L_E_T_ <> '*'"
PRIVATE _CUPDREAL 	:= "DOCUMENTO|SERIE|CLIENTE|LOJA|VENDEDOR|EMISSAO|DIVISAO|OBSERVACOES" + CRLF
PRIVATE _CUPDNREAL	:= "DOCUMENTO|SERIE|CLIENTE|LOJA|VENDEDOR|EMISSAO|DIVISAO|OBSERVACOES" + CRLF
PRIVATE _NCONTUPD	:= 0
PRIVATE _ASELSF2 	:= {}
PRIVATE _ASELZ04 	:= {}    
PRIVATE _ASELGRL 	:= {} 
PRIVATE _AUPDGRP 	:= {}
PRIVATE _AUPTGRP	:= {} 	  
PRIVATE	_DUPDATE
PRIVATE _DDIFF     
PRIVATE _CGRPVEN 	:= ""   
PRIVATE _CDTINI 	:= ""    
PRIVATE _LFIRST 	:= .T.

IF SELECT("TMPGRSF2") > 0
	TMPGRSF2->(DBCLOSEAREA())
EndIf   
TCQUERY _CQUERY NEW ALIAS "TMPGRSF2"    

WHILE TMPGRSF2->(!EOF())  
	_CGRPVEN 	:= ""  
	_ASELSF2 := {} 
	_CQUERY := "SELECT F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_VEND1, F2_EMISSAO, F2_GRPVEN, A1_GRPVEN FROM SF2010 INNER JOIN SA1010 ON (F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA) WHERE F2_VEND1 <> '      ' AND F2_GRPVEN <> '      ' AND F2_CLIENTE = '" +TMPGRSF2->F2_CLIENTE+"' ORDER BY F2_CLIENTE, F2_LOJA, F2_EMISSAO, F2_GRPVEN"
   //	_CMONTATXT += TMPGRSF2->F2_DOC + "|" + TMPGRSF2->F2_SERIE + "|" + TMPGRSF2->F2_CLIENTE + "|" + TMPGRSF2->F2_LOJA + "|" + TMPGRSF2->F2_VEND1 + "|" + TMPGRSF2->F2_EMISSAO + "|" + ALLTRIM(TMPGRSF2->F2_GRPVEN) + "|| REGISTRO PAI|" 		+ CRLF
	IF SELECT("TMPSF2") > 0
		TMPSF2->(DBCLOSEAREA())
	EndIf   
	TCQUERY _CQUERY NEW ALIAS "TMPSF2"  
	
	WHILE TMPSF2->(!EOF())
		AADD(_ASELSF2, {TMPSF2->F2_DOC, TMPSF2->F2_SERIE,  TMPSF2->F2_CLIENTE, TMPSF2->F2_LOJA,  TMPSF2->F2_VEND1, TMPSF2->F2_EMISSAO, ALLTRIM(TMPSF2->F2_GRPVEN), ALLTRIM(TMPSF2->A1_GRPVEN)})
//		_CMONTATXT += TMPSF2->F2_DOC + "|" + TMPSF2->F2_SERIE + "|" + TMPSF2->F2_CLeIENTE + "|" + TMPSF2->F2_LOJA + "|" + TMPSF2->F2_VEND1 + "|" + TMPSF2->F2_EMISSAO + "|" + ALLTRIM(TMPSF2->F2_GRPVEN) +"|"+ALLTRIM(TMPSF2->A1_GRPVEN)  + "| REGISTRO FILHO|" + CRLF		
		TMPSF2->(DBSKIP())                                                                                                                                                                                                                                                  
	ENDDO                
          
	FOR I := 1 TO LEN(_ASELSF2) STEP 1  
		IF I = 1   
			_DDIFF := DATEDIFFDAY(STOD(TMPGRSF2->F2_EMISSAO),STOD(_ASELSF2[I][6]))
			_NDANT := 0 
			_DF2EMIS := TMPGRSF2->F2_EMISSAO
		ELSE                                
			_DDIFF := DATEDIFFDAY(STOD(TMPGRSF2->F2_EMISSAO),STOD(_ASELSF2[I][6]))
			IF (_DDIFF <= _NDANT) .Or. _NDANT = 0
				_NDANT := _DDIFF
				_CGRPVEN := _ASELSF2[I][7]
			ENDIF			
		ENDIF				  
	NEXT     
      
    IF(!EMPTY(_CGRPVEN))  
    	_NCONTUPD  += 1    	
	    _cSQL := "UPDATE SF2010 SET F2_GRPVEN = (SELECT A1_GRPVEN FROM SA1010 WHERE A1_COD = '"+TMPGRSF2->F2_CLIENTE+"' AND A1_LOJA = '"+TMPGRSF2->F2_LOJA+"') WHERE F2_DOC = '" +TMPGRSF2->F2_DOC+ "' AND F2_SERIE = '"+TMPGRSF2->F2_SERIE+"'" 
		nStatus := TCSqlExec(_cSQL)            
		_cStatus := ""
		If (nStatus < 0)     
			_cStatus := "Update nao realizado com sucesso"
		Else
			_cStatus := "Update realizado com sucesso"
		EndIf   
	
		_CUPDREAL += TMPGRSF2->F2_DOC + "|" + TMPGRSF2->F2_SERIE + "|" + TMPGRSF2->F2_CLIENTE + "|" + TMPGRSF2->F2_LOJA + "|" + TMPGRSF2->F2_VEND1 + "|" + TMPGRSF2->F2_EMISSAO + "|" + _CGRPVEN + "|" + _cStatus + CRLF 
	 	AADD(_AUPDGRP, {TMPGRSF2->F2_DOC,TMPGRSF2->F2_SERIE,TMPGRSF2->F2_CLIENTE,TMPGRSF2->F2_LOJA,TMPGRSF2->F2_VEND1,TMPGRSF2->F2_EMISSAO,_CGRPVEN})
    	
	ELSE                                                                                         
	    _cSQL := "UPDATE SF2010 SET F2_GRPVEN = (SELECT A1_GRPVEN FROM SA1010 WHERE SA1010.D_E_L_E_T_ <> '*' AND A1_COD = '"+TMPGRSF2->F2_CLIENTE+"' AND A1_LOJA = '"+TMPGRSF2->F2_LOJA+"') WHERE F2_DOC = '" +TMPGRSF2->F2_DOC+ "' AND F2_SERIE = '"+TMPGRSF2->F2_SERIE+"'"
    	nStatus := TCSqlExec(_cSQL)            
		_CUPDNREAL += TMPGRSF2->F2_DOC + "|" + TMPGRSF2->F2_SERIE + "|" + TMPGRSF2->F2_CLIENTE + "|" + TMPGRSF2->F2_LOJA + "|" + TMPGRSF2->F2_VEND1 + "|" + TMPGRSF2->F2_EMISSAO + "| UPDATE REALIZADO COM BASE NA DIVISAO DO CLIENTE" + CRLF  
		AADD(_AUPTGRP, {TMPGRSF2->F2_DOC,TMPGRSF2->F2_SERIE,TMPGRSF2->F2_CLIENTE,TMPGRSF2->F2_LOJA,TMPGRSF2->F2_VEND1,TMPGRSF2->F2_EMISSAO,_CGRPVEN})	
	ENDIF

TMPGRSF2->(DBSKIP())
ENDDO                 



CRIACSV(_CUPDREAL, "Upd Realizado SF2")
CRIACSV(_CUPDNREAL, "Upd Realizado cb SA1")

Return()
