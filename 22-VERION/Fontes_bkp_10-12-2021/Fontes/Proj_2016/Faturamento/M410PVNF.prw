#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?M410PVNF  ? Autor ? RICARDO CAVALINI   ? Data ?  18/11/08   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Ponto de Entrada para tratamento de data retroativa do     ???
???          ? sistema. Conforme necessidade do cliente                   ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ?                                                            ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
User Function M410PVNF()
Local _aArea1  := GetArea()  // guarda a area
Local _dServer := Date()     // data do servidor 
Local _dSiga   := DDataBase  // data do sistema
Local _lEmis   := .T.        // Retorno esperado pelo sistema  (.t. ou .f.)

// ROTINA DE GERACAO DE PEDIDO DE VENDAS NO CASO DE MEDICAO DE CONTRATOS..... 
If ALLTRIM(FUNNAME()) == "CNTA120"
     Return(_lEmis)
endif

If  _dSiga < _dServer 
	IF MSGYESNO("Data do Sistema Protheus menor que a Data Base. Deseja continuar ?")
		_lEmis   := .T.        // Retorno esperado pelo sistema  (.t. ou .f.)
	Else
		Msgbox("A nota fiscal n?o ser? gerada. Ajuste a data do sistema !")
		_lEmis   := .F.        // Retorno esperado pelo sistema  (.t. ou .f.)		
	ENDIF
Endif    

If !(ALLTRIM(SC5->C5_CONDPAG)) $ "051"
	_cTitLib := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),"A1_XLIBVA")

	If  Empty(_cTitLib)
	   	CQUERY	:=	" SELECT E1_VALOR "
		CQUERY	+=	" FROM " + retsqlname('SE1') + " SE1 "
		CQUERY	+=	" WHERE SE1.D_E_L_E_T_ = '' AND E1_CLIENTE = '"+ SC5->C5_CLIENTE +"' AND E1_LOJA = '"+ SC5->C5_LOJACLI +"' "
		CQUERY	+=	" AND E1_SALDO > 0 AND E1_TIPO = 'NF' "
		CQUERY	+=	" AND E1_VENCREA < '"+dtos(ddatabase)  +"' "

		TCQUERY CQUERY NEW ALIAS "MOX"

		Dbselectarea("MOX")
		If !EOF()
	   		ALERT (" Cliente possui titulos vencidos, favor contactar o financeiro... ")
       		Alert (" Aten??o a Nota Fiscal n?o ser? gerada !!! ")
	   		_lEmis   := .F.
		endif
	    MOX->(DBCLOSEAREA())
	Endif
Endif

RestArea(_aArea1)
Return(_lEmis)