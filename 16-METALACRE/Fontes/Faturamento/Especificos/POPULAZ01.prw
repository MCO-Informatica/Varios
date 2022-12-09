#include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTVALPED  �Autor  �Bruno Daniel Abrigo � Data �  10/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Permite validar alteracao nos campos Lacre e Qtd           ���
���          � Se for alterar, bloqueia                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Metalacre                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function POPULAZ01()

      
Local nCont := '000000'     
local calias := getNextAlias()

if SELECT(CALIAS) > 0
	(CALIAS)->(DBCLOSEAREA())
ENDIF

CQRY := ""
CQRY += " SELECT MAX(Z01_NUMERO) AS NUMERO FROM " 
CQRY += RETSQLNAME("Z01") + " Z01 "
CQRY += " WHERE D_E_L_E_T_ = '' "
CQRY += " AND Z01_NUMERO <> '' "
DbUseArea( .T.,"TOPCONN",TcGenQry(,,cQry),CALIAS,.T.,.T.)
DBSELECTAREA(CALIAS)
DBGOTOP()
IF !EOF()
	IF !EMPTY((CALIAS)->NUMERO)
		NCONT := ((CALIAS)->NUMERO)
	ENDIF
ENDIF
                             
(CALIAS)->(DBCLOSEAREA())

IF EMPTY(NCONT)
	NCONT := '000000'
ENDIF

DBSELECTAREA("Z01")
//DBSETORDER(1)
DBGOTOP()
dO WHILE !EOF()
	IF EMPTY(Z01->Z01_NUMERO)
		NCONT := soma1(NCONT)
		RECLOCK("Z01",.F.)      
		Z01->Z01_NUMERO :=  NCONT
		Z01->(MSUNLOCK())
	ENDIF
	DBSELECTAREA("Z01")
	DBSKIP()
ENDDO
	 
MSGALERT("FIM")				

RETURN               

/*                        
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CANCELAR  � Autor �FLAVIA AGUIAR          � Data �         ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � BOTAO PARA O CANCELAMENTO DA NOTA FISCAL,                  ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
        
USER Function GETMAX(TABELA, CAMPO, FILTRO, VALFILTRO, FILTRO1 )
           
LOCAL LRET 		   
LOCAL ALIASREM  := "GETMAX" + ALLTRIM(__CUSERID)

CQRY := " SELECT MAX(" + CAMPO + ") AS CONTA FROM " + RETSQLNAME(TABELA) + " WHERE D_E_L_E_T_ = '' AND "
CQRY += SUBSTR(CAMPO,1,2) + "_FILIAL  = '" + XFILIAL(TABELA) + "' "  
IF !EMPTY(FILTRO) 
	CQRY += " AND " + ALLTRIM(FILTRO) + " = "
	IF VALTYPE(VALFILTRO) == 'C'
	  CQRY += "'" + VALFILTRO + "' "
	ELSEIF VALTYPE(VALFILTRO) == 'N'
	  CQRY += " " + str(VALFILTRO) + " "
	ENDIF 
ENDIF 	
DbUseArea( .t.		, "TOPCON"		, TcGenQry(,, cQry), ALIASREM )
DBSELECTAREA(ALIASREM)
DBGOTOP()
IF !EOF()  
	LRET := (ALIASREM)->CONTA
ENDIF

(ALIASREM)->(DBCLOSEAREA())      

RETURN LRET    

