#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ MTA416PV ³ Ponto de entrada para alimentacao de campos de usuario no pedº±±
±±º             ³          ³ caso nao exista.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 20.09.07 ³ Robson                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 20.09.07 ³ Robson                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ 1.                                                                      º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ ??.??.?? - Nome - Descrição                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA416PV()

Local aAreaAtu	:= GetArea()
Local nUsado := Len(aHeadC6)
LOCAL nAcols := Len(_aCols)
// ENVIANDO CAMPOS DOS ITENS DO ORCAMENTO PARA O PEDIDO
For nCntFor := 1 To nUsado
						Do Case
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMREF" )
							_aCols[nAcols,nCntFor] := SCK->CK_NUMREF
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PV" )
							_aCols[nAcols,nCntFor] := SCK->CK_PV
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_NUMPCOM" )
							_aCols[nAcols,nCntFor] := SCK->CK_PV	
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEMCLI" )
							_aCols[nAcols,nCntFor] := SCK->CK_ITEMCLI
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ITEMPC" )
							_aCols[nAcols,nCntFor] := SCK->CK_ITEMCLI
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_XOBS" )
							_aCols[nAcols,nCntFor] := SCK->CK_OBS
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DSCTEC" )
							_aCols[nAcols,nCntFor] := SCK->CK_DSCTEC
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_XDIAS" )
							_aCols[nAcols,nCntFor] := SCK->CK_XDIAS 
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_FRETE" )
							_aCols[nAcols,nCntFor] := SCK->CK_FRETE	
				   		Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_MRG" )
							_aCols[nAcols,nCntFor] := SCK->CK_MRG
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_TXFIN" )
							_aCols[nAcols,nCntFor] := SCK->CK_TXFIN				
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_PIS" )
							_aCols[nAcols,nCntFor] := SCK->CK_PIS				
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_CUSUNIT" )
							_aCols[nAcols,nCntFor] := SCK->CK_CUSUNIT				
		     			Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_FONTE" )
							_aCols[nAcols,nCntFor] := SCK->CK_FONTE
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_DTVALID" )
							_aCols[nAcols,nCntFor] := SCK->CK_DTVALID	
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_TABPRC" )
							_aCols[nAcols,nCntFor] := SCK->CK_TABPRC
   						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_COFINS" )
							_aCols[nAcols,nCntFor] := SCK->CK_COFINS
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_VLICM" )
							_aCols[nAcols,nCntFor] := SCK->CK_VLICM	 
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_ENTREG" )
							_aCols[nAcols,nCntFor] := DATE()+SCK->CK_XDIAS 
						CASE ( ALLTRIM(_AHEADER[NCNTFOR,2]) == "C6_IPI" )
							_ACOLS[NACOLS,NCNTFOR] := SCK->CK_IPI 
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_FILIAL" )
							_aCols[nAcols,nCntFor] := SCK->CK_FILIAL
						Case ( AllTrim(aHeadC6[nCntFor,2]) == "C6_LOCAL" )
							_aCols[nAcols,nCntFor] := SCK->CK_LOCAL	 							
						EndCase
Next nCntFor                                                                        
// ENVIANDO CAMPOS DO CABECALHO DO ORCAMENTO PARA O PEDIDO
M->C5_NUM		:= SCJ->CJ_NUM
M->C5_FILIAL	:= SCJ->CJ_FILIAL
M->C5_VEND1		:= SCJ->CJ_VEND
M->C5_OBSANL	:= SCJ->CJ_OBSANL                                                                         
M->C5_AGINT		:= SCJ->CJ_AGINT
M->C5_VEND5		:= SCJ->CJ_VEND5
M->C5_CONTATO	:= SCJ->CJ_CONTATO
M->C5_XCOMPRA	:= SCJ->CJ_NMCONTA
M->C5_VEND5		:= SCJ->CJ_VEND5
M->C5_IMPEXP="N"     
//A410ReCalc(.t.)

M->C5_NOMCLI	:=U_HC410VC(1 ,M->C5_TIPO,M->CJ_CLIENTE,M->CJ_LOJA) 
M->C5_TIPOCLI	:=U_HC410VC(10,M->C5_TIPO,M->CJ_CLIENTE,M->CJ_LOJA)                                                 					
M->C5_ENDENT	:=U_HC410VC(5 ,M->C5_TIPO,M->CJ_CLIENTE,M->CJ_LOJA)
M->C5_BAIRROE	:=U_HC410VC(6 ,M->C5_TIPO,M->CJ_CLIENTE,M->CJ_LOJA)
M->C5_MUNENT	:=U_HC410VC(7 ,M->C5_TIPO,M->CJ_CLIENTE,M->CJ_LOJA)
M->C5_ESTENT	:=U_HC410VC(8 ,M->C5_TIPO,M->CJ_CLIENTE,M->CJ_LOJA)
M->C5_CEPE		:=U_HC410VC(9 ,M->C5_TIPO,M->CJ_CLIENTE,M->CJ_LOJA)
M->C5_XNREDUZ:=Posicione("SA1",1,xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA,"A1_NREDUZ")					
M->C5_CLIENTE	:= SCJ->CJ_CLIENTE
M->C5_LOJACLI	:= SCJ->CJ_LOJA
A410Cli("C5_CLIENTE",M->C5_CLIENTE,.F.) 
A410Loja("C5_LOJACLI",M->C5_LOJACLI,.F.)
RestArea(aAreaAtu)
//cFilAnt:=substring(cNumEmp,3,2)
Return()
					