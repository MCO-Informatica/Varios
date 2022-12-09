#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
                                 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CopyC6toZ5� Autor �                    � Data �  11/11/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa que que cria os movimentos de remuneracao SZ5     ���
���          � a partir da base SC6 existente                             ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CopyC6toZ5()          
Local cSqlRet

	RpcSetType(2)
	RpcSetEnv('01','02') 
	
//Busca de Vendas de Hardware Avulso
cSqlRet := "SELECT SC6.C6_PEDGAR, SC6.C6_VALOR, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_XNUMVOU, SC6.C6_PROGAR, SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_DATFAT, SC6.C6_XOPER"
cSqlRet += " FROM " + RetSqlName("SC6") +" SC6 INNER JOIN "+RetSqlName("SC5")+" SC5 ON SC5.C5_NUM = SC6.C6_NUM"
cSqlRet += " WHERE SC6.C6_FILIAL = '" + xFilial("SC6")+ "' AND SC5.C5_FILIAL = '" + xFilial("SC5")+ "' AND SC6.C6_NOTA <> ' ' AND SC6.C6_PEDGAR = ' ' AND SC6.D_E_L_E_T_ = ' ' "  
cSqlRet += " AND SC5.C5_XNPSITE <> ' ' AND SC5.D_E_L_E_T_ = ' '"

cSqlRet := ChangeQuery(cSqlRet)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSqlRet),"TMPSC6",.F.,.T.)


DbSelectArea("TMPSC6")                   

If TMPSC6->(!Eof())
	TMPSC6->(DbGoTop())
	While TMPSC6->(!Eof()) 
	
			DbSelectArea("SZ5")
			DbsetOrder(3)		
			If !DbSeek(xFilial("SZ5") + TMPSC6->C6_NUM + TMPSC6->C6_ITEM)
					
				//SZ5->(DbAppend(.F.))
				RecLock("SZ5",.T.)
				SZ5->Z5_PEDGAR := TMPSC6->C6_PEDGAR        
				SZ5->Z5_EMISSAO := STOD(TMPSC6->C6_DATFAT)
				//Z5_DATPAG
				SZ5->Z5_VALOR := TMPSC6->C6_VALOR
				//Z5_TIPMOV 
				SZ5->Z5_CODPOS := Posicione("SC5",1,xFilial("SC5")+TMPSC6->C6_NUM,"C5_XPOSTO")
				SZ5->Z5_PRODUTO := TMPSC6->C6_PRODUTO
				SZ5->Z5_DESPRO := TMPSC6->C6_DESCRI
				SZ5->Z5_CODVOU := TMPSC6->C6_XNUMVOU
				SZ5->Z5_PRODGAR := TMPSC6->C6_PROGAR     
				
				//verifica se eh movimento de hardware avulso
				IF 	TMPSC6->C6_XOPER <> "53"
					SZ5->Z5_TIPO := "HWAVUL"
			 		SZ5->Z5_TIPODES := "HARDWARE AVULSO"
				ELSE 
					SZ5->Z5_TIPO    := "ENTHAR"
					SZ5->Z5_TIPODES := "ENTREGA MIDIA"
				Endif
					
				//NOME E CPF/CNPJ DO CLIENTE DE FATURAMENTO
				IF TMPSC6->C6_XOPER == "51"
					SZ5->Z5_VALORSW := TMPSC6->C6_VALOR
					
				ELSE 
					SZ5->Z5_VALORHW := TMPSC6->C6_VALOR
				ENDIF   
					
				SZ5->Z5_PEDIDO := TMPSC6->C6_NUM
				SZ5->Z5_ITEMPV := TMPSC6->C6_ITEM
					
			
				SZ5->(Msunlock())
//				SZ5->(DBCommit())
				Conout("Gerado SZ5 para o item "+Alltrim(TMPSC6->C6_ITEM)+" do pedido "+Alltrim(TMPSC6->C6_NUM))
			
			Endif
		  //	DbSelectArea("TMPSC6")                   
			TMPSC6->(Dbskip())
		//Endif
	Enddo
Endif    

DbSelectArea("TMPSC6")                   
TMPSC6->(DbCloseArea())

//busca das demais vendas de varejo
cSqlRet := "SELECT SC6.C6_PEDGAR, SC6.C6_VALOR, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_XNUMVOU, SC6.C6_PROGAR, SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_DATFAT, SC6.C6_XOPER FROM " + RetSqlName("SC6") + " SC6"
cSqlRet += " WHERE SC6.C6_FILIAL = '" + xFilial("SC6")+ "' AND SC6.C6_NOTA <> ' ' AND SC6.C6_PEDGAR <> ' ' AND SC6.D_E_L_E_T_ = ' ' AND SC6.C6_XOPER <> '53' AND C6_DATFAT>'20120101'"  

cSqlRet := ChangeQuery(cSqlRet)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSqlRet),"TMPSC6",.F.,.T.)


DbSelectArea("TMPSC6")                   

If TMPSC6->(!Eof())
	TMPSC6->(DbGoTop())
	While TMPSC6->(!Eof()) 
	
			DbSelectArea("SZ5")
			DbsetOrder(3)		
			If !DbSeek(xFilial("SZ5") + TMPSC6->C6_NUM + TMPSC6->C6_ITEM)
					
				//SZ5->(DbAppend(.F.))
				RecLock("SZ5",.T.)
				SZ5->Z5_PEDGAR := TMPSC6->C6_PEDGAR        
				SZ5->Z5_EMISSAO := STOD(TMPSC6->C6_DATFAT)
				//Z5_DATPAG
				SZ5->Z5_VALOR := TMPSC6->C6_VALOR
				//Z5_TIPMOV 
				SZ5->Z5_CODPOS := Posicione("SC5",1,xFilial("SC5")+TMPSC6->C6_NUM,"C5_XPOSTO")
				SZ5->Z5_PRODUTO := TMPSC6->C6_PRODUTO
				SZ5->Z5_DESPRO := TMPSC6->C6_DESCRI
				SZ5->Z5_CODVOU := TMPSC6->C6_XNUMVOU
				SZ5->Z5_PRODGAR := TMPSC6->C6_PROGAR     
				
					
				//NOME E CPF/CNPJ DO CLIENTE DE FATURAMENTO
				IF TMPSC6->C6_XOPER == "51"
					SZ5->Z5_VALORSW := TMPSC6->C6_VALOR
					
				ELSE 
					SZ5->Z5_VALORHW := TMPSC6->C6_VALOR
					
				ENDIF   
					
				SZ5->Z5_PEDIDO := TMPSC6->C6_NUM
				SZ5->Z5_ITEMPV := TMPSC6->C6_ITEM
					
			
				SZ5->(Msunlock())
//				SZ5->(DBCommit())
				Conout("Gerado SZ5 para o item "+Alltrim(TMPSC6->C6_ITEM)+" do pedido "+Alltrim(TMPSC6->C6_NUM))
			
			Endif
		  //	DbSelectArea("TMPSC6")                   
			TMPSC6->(Dbskip())
		//Endif
	Enddo
Endif    

DbSelectArea("TMPSC6")                   
TMPSC6->(DbCloseArea())

Return