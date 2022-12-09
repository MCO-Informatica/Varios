//#INCLUDE "LIBPV.CH"
#INCLUDE "PROTHEUS.CH"            

/*==========================================================================
|Funcao    |TESINT      | Autor | Rodolfo Vacari        | Data | 07/06/08  |
|==========================================================================|
|Descricao | TES Inteligente:                                              |
|          | Ao Digitar uma quantidade no Pedido de Venda,                 |
|          | 	engatilha o TEs correta (Parametros -> Tp Operacao, Produto|
|          | 	Estado, NCM, Cliente                                       |
===========================================================================|
|Modulo    | Faturamento                                                   |
|Paramentro| Tp Operacao, Cliente, Tp Cliente, Tp Pessoa, Prod Similar     |
==========================================================================*/
User Function TESINTCALL()

Local aArea     := GetArea()
Local nOpcA     := 0
Local lRet      := .F.
Local cTES    := ""
Local aRegistros:= {}
Local aDadosCfo := {}                                                                  
Local cTipoCli := ""

		nPos_cTES      := aScan(aHeader, {|x| Rtrim(x[2]) == "UB_TES"})
		nPos_cCF       := aScan(aHeader, {|x| Rtrim(x[2]) == "UB_CF"})
		                                                     

       DbSelectArea("SZ2")
       DbSetOrder(1)
       If DBSeek(xFilial()+SB1->B1_POSIPI)
       		If SB1->B1_IPI = 0
       				cTES := "523"
       		Else
       				cTES := "524"
       		EndIf				

			cTipoCli  := POSICIONE("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_TIPO")
       		
			If !empty(cTES)
				dbSelectArea("SF4")
				dbSetOrder(1)  
				dbSeek(xFilial("SF4")+cTES)

 				Aadd(aDadosCfo,{"OPERNF","S"})
 				Aadd(aDadosCfo,{"TPCLIFOR",cTipoCli})
 				Aadd(aDadosCfo,{"UFDEST",SA1->A1_EST})
 				Aadd(aDadosCfo,{"INSCR", SA1->A1_INSCR})
 				MaFisCfo(,SF4->F4_CF,aDadosCfo)
 				cCfop := MaFisCfo(,SF4->F4_CF,aDadosCfo)
 			
				aCols[n][nPos_cTES]  := cTES
				aCols[n][nPos_cCF]   := cCfop
//				aCols[n][nPos_cCl]   := aCols[n][nPos_cCl]+SF4->F4_SITTRIB       	
       		EndIf
       Else                                                           
              If SB1->B1_IPI = 0 
					aCols[n][nPos_cTES]  := "521"       				
			  Else
					aCols[n][nPos_cTES]  := "504"   
			  EndIf		    							  			
       EndIf                         
//	dbSelectArea("SC6")
Return .T.
