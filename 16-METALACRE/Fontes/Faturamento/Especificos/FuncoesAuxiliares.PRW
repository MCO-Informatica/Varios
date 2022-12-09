#INCLUDE "rwmake.ch"
             
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          º Autor ³FLAVIA AGUIAR       º Data ³ 28/08/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ FONTE COM FUNÇÕES USADAS VARIOS LOCAIS DO PROJETO.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PROCURA  º Autor ³ Flavia Aguiar      º Data ³  09/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao que PROCURA UM DADO NA TABELA DE ACORDO COM OS PARAMº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

USER FUNCTION PROCURA(FILV1,PROCURA,TABELA,FILC1,FILC2,FILV2,FILC3,FILV3, SINAL,FILC4,FILV4,FILC5,FILV5)

Local INT  	  := "INT" + ALLTRIM(SUBSTR(CUSUARIO,7,5))  
Local cINT    := ""

if !EMPTY(FILC1) 
	If Select(INT )>0
		INT->(DbCloseArea())
	EndIf
	
	CQRY := "  SELECT  " + ALLTRIM(PROCURA)    + " AS PROCURA "   + Chr(13) + Chr(10)  
	IF LEN(TABELA) > 3
		CQRY += "  FROM "    + TABELA+ " with(NOLOCK) "   + Chr(13) + Chr(10)  
		IF VALTYPE(FILV1) == 'N'                      
			CQRY += "  WHERE " + FILC1 + " = "                          + (FILV1) + "  "         		
		 ELSE
	 		CQRY += "  WHERE " + FILC1 + " = '"                          + ALLTRIM(FILV1) + "'  "         		
	 	ENDIF
	ELSE
		CQRY += "  FROM "    + RETSQLNAME(TABELA)+ " with(NOLOCK) "   + Chr(13) + Chr(10) 	
		CQRY += "  WHERE D_E_L_E_T_ = '' "		 					  + Chr(13) + Chr(10)
		IF VALTYPE(FILV1) == 'N'                      
			CQRY += "   AND " + FILC1 + " = "                          + ALLTRIM(FILV1) + "  "                 		
		 ELSE   
		 	IF !EMPTY(SINAL)                                                                                            
				CQRY += "   AND " + FILC1                		
			  	CQRY += "  " + SINAL + " " 
			  	IF SINAL = 'LIKE'  
			  		cQRY += " '%" 	+ alltrim(FILV1)   + "%' " 	+ Chr(13) + Chr(10)   
			  	elseIF "(" $ alltrim(FILV1)
					cQRY += " " 	+ alltrim(FILV1)   + " " 	+ Chr(13) + Chr(10)			  	
			  	ELSE
			  		cQRY += " '" 	+ alltrim(FILV1)   + "' " 	+ Chr(13) + Chr(10)
			  	ENDIF
			ELSE
		    	CQRY += "   AND " + FILC1 + " = '"                          + ALLTRIM(FILV1) + "'  "  
		    ENDIF             		
	 	ENDIF
	ENDIF
	IF !EMPTY(FILC2)
		IF VALTYPE(FILV2) = 'N'
			CQRY += "   AND " + FILC2 + " = "                          + (FILV2) + " " 
		ELSE
			CQRY += "   AND " + FILC2 + " = '"                          + ALLTRIM(FILV2) + "'  " 		
		ENDIF
	ENDIF       
	IF !EMPTY(FILC3) 
		IF VALTYPE(FILV3) = 'N'
			CQRY += "   AND " + FILC3 + " = "                          + (FILV3) + "  " 
		ELSE
			CQRY += "   AND " + FILC3 + " = '"                          + ALLTRIM(FILV3) + "'  " 
		ENDIF
	ENDIF       
	IF !EMPTY(FILC4)
		IF VALTYPE(FILV4) = 'N'
			CQRY += "   AND " + FILC4 + " = "                          + (FILV4) + " " 
		ELSE
			CQRY += "   AND " + FILC4 + " = '"                          + ALLTRIM(FILV4) + "'  " 		
		ENDIF
	ENDIF       
	IF !EMPTY(FILC5)
		IF VALTYPE(FILV5) = 'N'
			CQRY += "   AND " + FILC5 + " = "                          + (FILV5) + " " 
		ELSE
			CQRY += "   AND " + FILC5 + " = '"                          + ALLTRIM(FILV5) + "'  " 		
		ENDIF
	ENDIF       		
	DbUseArea( .t.		, "TOPCON"		, TcGenQry(,, cQry), INT )
	DBSELECTAREA(INT)
	DBGOTOP()
	IF !EOF()
		cINT := (INT)->PROCURA
	ENDIF
	(INT)->(DBCLOSEAREA())      
endif

RETURN(CINT)    

 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UPDCAMPO º Autor ³ Flavia Aguiar      º Data ³  11/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ funcao generica que faz o update nos campos conforme os    º±±
±±º          ³ paramentros passados.                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
    
USER FUNCTION UPDCAMPO(TABELA,CAMPO, FILTRO, VALORF,VALORC,FILTRO1,VALORF1,FILTRO2,VALORF2,FILTRO3,VALORF3,DELETADOS)   

CUPD := " UPDATE " 
IF LEN(TABELA) > 3
	CUPD+= (TABELA)	+ Chr(13) + Chr(10)     
ELSE
	CUPD+=  RETSQLNAME(TABELA)	+ Chr(13) + Chr(10)     
ENDIF
IF VALTYPE(VALORC) == 'C'
  cUPD += " SET "    + alltrim(CAMPO) 	+ " = '"    + alltrim(VALORC)   + "' "	+ Chr(13) + Chr(10)
ELSEIF VALTYPE(VALORC) == 'N'
  cUPD += " SET "    + alltrim(CAMPO) 	+ " = "     + alltrim(str(VALORC))   + " "	+ Chr(13) + Chr(10)
ENDIF

CUPD += " WHERE  " + alltrim(FILTRO)   

	CUPD += " = " 
	IF VALTYPE(VALORF) == 'C'
	  cUPD += " '" 	+ alltrim(VALORF)   + "' " 	+ Chr(13) + Chr(10)
	ELSEIF VALTYPE(VALORF) == 'N'
	  cUPD += " " 	+ alltrim(str(VALORF))   + " " 	+ Chr(13) + Chr(10)
	ENDIF     

IF LEN(TABELA) > 3

ELSE
	IF DELETADOS  
	
	ELSE
		CUPD += " AND D_E_L_E_T_ = ''  "        + Chr(13) 	+ Chr(10)                                                       
	ENDIF
ENDIF

IF !EMPTY(FILTRO1)
	CUPD += " AND "+ alltrim(FILTRO1)   + " = "
	IF VALTYPE(VALORF1) == 'C'
	  cUPD += " '" 	+ alltrim(VALORF1)   + "' " 	+ Chr(13) + Chr(10)
	ELSEIF VALTYPE(VALORF1) == 'N'
	  cUPD += " " 	+ alltrim(str(VALORF1))   + " " 	+ Chr(13) + Chr(10)
	ENDIF
ENDIF   
IF !EMPTY(FILTRO2)
	CUPD += " AND "+ alltrim(FILTRO2)   + " = "     
	IF VALTYPE(VALORF2) == 'C'
	  cUPD += " '" 	+ alltrim(VALORF2)   + "' " 	+ Chr(13) + Chr(10)
	ELSEIF VALTYPE(VALORF2) == 'N'
	  cUPD += " " 	+ alltrim(str(VALORF2))   + " " 	+ Chr(13) + Chr(10)
	ENDIF
ENDIF 
IF !EMPTY(FILTRO3)
	CUPD += " AND "+ alltrim(FILTRO3)   + " = "     
	IF VALTYPE(VALORF3) == 'C'
	  cUPD += " '" 	+ alltrim(VALORF3)   + "' " 	+ Chr(13) + Chr(10)
	ELSEIF VALTYPE(VALORF3) == 'N'
	  cUPD += " " 	+ alltrim(str(VALORF3))   + " " 	+ Chr(13) + Chr(10)
	ENDIF
ENDIF
      
nRet = TCSQLEXEC(CUPD)
If nRet == 0                  
	TCRefresh(RETSQLNAME(TABELA))
EndIf

RETURN  

/*                        
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ CANCELAR  ³ Autor ³FLAVIA AGUIAR          ³ Data ³         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ BOTAO PARA O CANCELAMENTO DA NOTA FISCAL,                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±Parametros: TABELA A SER PESQUISADA, CAMPO QUE SERA SOMADO, CAMPO QUE  ±±±
±±           Å SERA AGRUPADO, CAMPO DO 1 FILTRO, VALOR DO 1 FILTRO, CAMPO ´±±
±±           ³ DO 2 FILTRO, VALOR DO 2 FILTRO, TIPO C= COUNT, S = SUM.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
        
USER Function GETSOMA(TABELA,CAMPO,GRUPO,FILTRO,VALFILTRO,FILTRO2,VALFILTRO2,FILTRO3,VALFILTRO3, TIPO)
           
LOCAL LRET 		    
LOCAL ALIASREM  := "SOMA" + ALLTRIM(__CUSERID)

IF SELECT(ALIASREM) > 0
	(ALIASREM)->(DBCLOSEAREA())      	
ENDIF  

IF TIPO = 'C'
	CQRY := " SELECT COUNT(*) AS CONTA FROM " + RETSQLNAME(TABELA) + ""
ELSEIF TIPO = 'M'
	CQRY := " SELECT MAX(" + CAMPO + ") AS CONTA FROM " + RETSQLNAME(TABELA) + " with(nolock) "
ELSE
	CQRY := " SELECT SUM(" + CAMPO + ") AS CONTA FROM " + RETSQLNAME(TABELA) + ""
ENDIF
CQRY += " WHERE " + FILTRO + " = "
IF VALTYPE(VALFILTRO) == 'C'
  CQRY += "'" + VALFILTRO + "' "
ELSEIF VALTYPE(VALFILTRO) == 'N'
  CQRY += " " + str(VALFILTRO) + " "
ENDIF  
IF !EMPTY(FILTRO2) 
	CQRY += " AND " + ALLTRIM(FILTRO2) + " = "
	IF VALTYPE(VALFILTRO2) == 'C'
	  CQRY += "'" + VALFILTRO2 + "' "
	ELSEIF VALTYPE(VALFILTRO2) == 'N'
	  CQRY += " " + str(VALFILTRO2) + " "
	ENDIF 
ENDIF 	
IF !EMPTY(FILTRO3) 
	CQRY += " AND " + ALLTRIM(FILTRO3) + " = "
	IF VALTYPE(VALFILTRO3) == 'C'
	  CQRY += "'" + VALFILTRO3 + "' "
	ELSEIF VALTYPE(VALFILTRO3) == 'N'
	  CQRY += " " + str(VALFILTRO3) + " "
	ENDIF 
ENDIF 	
CQRY += " AND D_E_L_E_T_ = ''"   
IF TIPO <> 'M'
	CQRY += " GROUP BY "  + GRUPO 
ENDIF

DbUseArea( .t.		, "TOPCON"		, TcGenQry(,, cQry), ALIASREM )
DBSELECTAREA(ALIASREM)
DBGOTOP()
IF !EOF()  
	LRET := (ALIASREM)->CONTA
ENDIF

(ALIASREM)->(DBCLOSEAREA())      

RETURN LRET         
                
         

      