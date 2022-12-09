#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH"
/*
==================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-----------------------------------+------------------+||
||| Programa: FA200POS  | Autor: Danilo Alves Del Busso      | Data: 30/05/2016 |||
||+------------+--------+-----------------------------------+------------------+||
||| Descricao: |O ponto de entrada FA200POS � inserido ap�s o posicionamento do|||
|||			   |SEB (Ocorr�ncias banc�rias), chamado no processamento de todas |||
|||			   |as linhas do arquivo de retorno, antes da execu��o das a��es   |||
|||			   |correspondentes � ocorr�ncia e da localiza��o / posicionamento |||
|||			   |do t�tulo correspondente no SE1. Para a localiza��o do T�tulo  |||
|||			   |correspondente no SE1, foram disponibilizadas as seguintes 	   |||
|||			   |vari�veis: 													   |||
|||			   |	cNumTit:  N�mero 										   |||
|||			   | 	cEspecie: Cont�m o Tipo do T�tulo       	     		   |||
|||			   |Aqui estou pegando o processamento das linhas e gravando       |||
|||            |as despesas de cartorio na SE1->E1_DESPCAR (criado para verq.) |||
||+------------+---------------------------------------------------------------+||
||| Alteracao: |                                                               |||
||+------------+---------------------------------------------------------------+||
||| Uso:       | Verquimica                                                    |||
||+------------+---------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==================================================================================
*/    

User Function FA200POS()    

DbSelectArea("SE1"); DbSetOrder(16)  

_cNumTitV := PADL(AllTrim(SubStr(PARAMIXB[1][16],117,8)),9,"0") //Pega com o numero do titulo verquimica no arquivo, limpa com alltrim e acrescenta 0 a esquerda se faltar.
_cIdCnabV := AllTrim(SubStr(PARAMIXB[1][16],38,10))				//Pega o IDCNAB 
_cNumParV := AllTrim(SubStr(PARAMIXB[1][16],126,1)) 			//pega o numero da parcela
_nValTitV := Val(SubStr(PARAMIXB[1][16],153,13)) 				//pega o valor nominal do titulo 
_cValRet  := AllTrim(SubStr(PARAMIXB[1][16],109,2)) 			//pega a linha do codigo de retorno ex: 43 - despesa cartorio

If (_cValRet == "43")   //se for despesa de cartorio, vai preencher na SE1->E1_DESPCAR
//	 nValTCob := Val(SubStr(PARAMIXB[1][16],176,11)) + Val("0." + SubStr(PARAMIXB[1][16],187,2)) //pega o valor da tarifa de cobran�a no arquivo cnab    
	 nValTCob := Val(SubStr(PARAMIXB[1][16],176,13))/100 //pega o valor da tarifa de cobran�a no arquivo cnab    
	 If (nValTCob <> 0)
	 	 If SE1->(DbSeek(xFilial("SE1")+_cIdCnabV))
	 	 	  RecLock("SE1", .F.)
	 	      	SE1->E1_DESPCAR += nValTCob
	 	 	  MsUnlock()                                       	
		 EndIf
	 EndIf
EndIf
Return