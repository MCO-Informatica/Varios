#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"

User Function CalcData()

Local dEmissa     := M->UA_EMISSAO
Local n_Num       := 4 
Local n_DiaUtil	  := 0            // VARIAVEL DE CONTROLE PARA SABER SE EH DIA UTIL E PARA CHEGAR NO DIA CORRETO
Local l_Continua  := .T.          // CONTROLE PARA EXIBIR A DATA FINAL
Local d_DataFinal := dEmissa      //RECEBE O PARAMETRO E CONVERTE EM DATA

While ( l_Continua )

	If ( d_DataFinal == DataValida(d_DataFinal) ) //COMPARA O PARAMETRO PRA VER SE EH DIA UTIL
		n_DiaUtil++                               //ACRESCENTA MAIS 1 NA VARIAVEL QUE CONTROLA O DIA UTIL
	Endif
	
	If ( n_DiaUtil < n_Num ) // TESTA SE O NUMERO PASSADO POR PARAMETRO EH MENOR QUE A VARIAVEL DE CONTROLE
		d_DataFinal++        // VAI ACRESCENTANDO MAIS 1 NA VARIAVEL DATA QUE SERA EXIBIDA
	Else
		l_Continua := .F.
	Endif

Enddo

Return d_DataFinal

  