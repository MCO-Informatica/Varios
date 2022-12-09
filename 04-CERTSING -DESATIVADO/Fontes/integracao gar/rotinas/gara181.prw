#INCLUDE "PROTHEUS.CH"                              

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GARA180   �Autor  �OPVS CA             � Data �  06/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa de exportacao de arquivo TXT em layout especifico ���
���          � para importacao pelo sistema GAR                           ���
�������������������������������������������������������������������������͹��
���Uso       � JOB executado em horario especificado em parametro        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GARA181(aParSch)

Local cTime :=  time()
Local _cSql 	:= ""
Local cFileOut  := ""
Local nHandle	:= -1 
Local cValor	:= ""
//Local cJobEmp 	:= Getjobprofstring("JOBEMP","01")
//Local cJobFil 	:= Getjobprofstring("JOBFIL","02")
//Local cInterval := Getjobprofstring("INTERVAL","60")
Local cHrExec	:= ""    
Local lForce    := .f.
Local _lJob 	:= (Select('SX6')==0)

Local cJobEmp	:= aParSch[1]	
Local cJobFil	:= aParSch[2]


If _lJob

	RpcSetType(2)
	RpcSetEnv(cJobEmp, cJobFil)

EndIf


Conout("Job GARA181 - Begin Emp("+cJobEmp+"/"+cJobFil+")" )


//Conout("Interval Check : "+cInterval)

//cHrExec 	:=  GetNewPar("MV_GARTXTH", "00:01")
nDiasAnt 	:=  GetNewPar("MV_GARTXTD", 0) 
                                                                                              
//If Substr(time(),1,5) = cHrExec  .or. lForce
	While !File("\pedidosfaturados\pedidos_microsiga_"+Dtos(DATE())+".txt")
	
//		Conout("Job GARA181 - EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
		
		_cSql := "SELECT "
		_cSql += "	C5_CHVBPAG AS PEDIDO, "
		_cSql += "	SUBSTR(D2_EMISSAO,7,2) || '/' || SUBSTR(D2_EMISSAO,5,2) ||'/' || SUBSTR(D2_EMISSAO,1,4)  AS DT_FATURAMENTO, " 
		_cSql += "	C5_TOTPED  AS VL_FATURAMENTO, "

		_cSql += "	         ( "
		_cSql += "	          case "
		_cSql += "	            when SC5.C5_TIPMOV = '1' then 'Boleto' "
		_cSql += "	            when SC5.C5_TIPMOV = '2' then 'Cartao Credito' "
		_cSql += "	            when SC5.C5_TIPMOV = '3' then 'Cartao Debito' "
		_cSql += "	            when SC5.C5_TIPMOV = '4' then 'DA' "
		_cSql += "	            when SC5.C5_TIPMOV = '5' then 'DDA' "
		_cSql += "	            when SC5.C5_TIPMOV = '6' then 'Voucher' "
		_cSql += "	            else 'Outros' "
		_cSql += "	          end )           DS_FMA_PGTO, 	"



		_cSql += "	D2_TOTAL  AS VL_PEDIDO, " 
		_cSql += "  UPPER(A1_MUN) AS MUN, "
		_cSql += "  UPPER(A1_EST) AS EST, "
		_cSql += "	UPPER(B1_DESC) AS DS_PROD, "
		_cSql += "	UPPER(B1_CATEGO) AS CATEGORIA, "
		_cSql += "  D2_DOC AS NOTA, "
		_cSql += "  D2_SERIE AS SERIE "
		_cSql += "FROM " 
		_cSql += "			     "+RetSqlName("SD2")+" SD2 "
		_cSql += "                      INNER JOIN "+RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL = SD2.D2_FILIAL AND SC5.C5_NUM =  SD2.D2_PEDIDO AND SC5.D_E_L_E_T_   =   ' ' "
		_cSql += "                      INNER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.C6_FILIAL = SD2.D2_FILIAL AND SC6.C6_NUM =  SD2.D2_PEDIDO AND SC6.C6_ITEM =  SD2.D2_ITEMPV AND SC6.D_E_L_E_T_   =   ' ' "
		_cSql += "                      INNER JOIN "+RetSqlName("SB1")+" SB1 ON C6_FILIAL = B1_FILIAL AND SC6.C6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
		_cSql += "                      INNER JOIN "+RetSqlName("SA1")+" SA1 ON C5_CLIENTE = A1_COD AND SA1.D_E_L_E_T_=' ' , "
		_cSql += "			     "+RetSqlName("SF4")+" SF4 "
		_cSql += " WHERE "
		_cSql += " SD2.D2_FILIAL>='" + xFilial("SD2") +"' AND "
		_cSql += " SD2.D2_EMISSAO   >=  '"+DtoS(date()-nDiasAnt)+"'	AND   "
		_cSql += " SD2.D_E_L_E_T_=' ' AND "
		_cSql += " SD2.D2_TES =SF4.F4_CODIGO AND "
		_cSql += " SF4.F4_DUPLIC = 'S' AND "
		_cSql += " SF4.D_E_L_E_T_ = ' ' AND "
		_cSql += " C5_CHVBPAG <> '" + Space(TamSX3("C5_CHVBPAGB")[1]) + "' 
		_cSql += " ORDER  BY PEDIDO, CATEGORIA  "

	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSql),"TRBPEDTXT",.F.,.T.)
		
		TcSetField("TRBPEDTXT","VL_FATURAMENTO","N",15,2)
		TcSetField("TRBPEDTXT","VL_PEDIDO","N",15,2)
		//Path da pasta onde os arquivos gerados serao salvos \\192.168.16.30\t$\Totvs\Protheus_Data10\pedidosfaturados	
		cFileOut := "\pedidosfaturados\pedidos_microsiga_"+Dtos(date())+".txt"     // pedidos nao faturados
		nHandle := FCREATE(cFileOut)
		
		nLinPed	:= 1  
		nLinDt  := 1
		cLinFat := "" 
		cLinFat1:= ""
		nVlrPed	:= 0
		cPedido := ''
		cPedido := TRBPEDTXT->PEDIDO  
		cLin 	:= ""
		cLinVlr	:= ""
		cLinForm:= ""
		cLinNfGe:= "" 
		cLinMun := ""
		cLinEst := ""
		cLinCert:= ""
		cLinHad1:= ""
		cLinHad2:= ""
		cNumNota:= "" 
		cNumSeri:= "" 
		nCountHrd := 0
	
		If nHandle != -1			
			
		While !TRBPEDTXT->(Eof())   
		
		   		
				nVlrPed += TRBPEDTXT->VL_PEDIDO
				cLin 	:= 	PADR(TRBPEDTXT->PEDIDO,38," ")+;
							TRBPEDTXT->DT_FATURAMENTO
				cLinVlr	:= 	PADR(StrTran(alltrim(Str(nVlrPed)),".",","),16," ")
				cLinForm:= 	PADR(TRBPEDTXT->DS_FMA_PGTO,72," ")
				cLinNfGe:= 	PADR(IIF(!Empty(TRBPEDTXT->DT_FATURAMENTO),'S','N'),10," ")
				cLinMun := 	PADR(TRBPEDTXT->MUN,35," ")    
				cLinEst :=  PADR(TRBPEDTXT->EST,3," ")
			 	cDS_PROD:=  TRBPEDTXT->DS_PROD
				cNumNota:=  TRBPEDTXT->NOTA
				cNumSeri:=  TRBPEDTXT->SERIE     
				
				DbSelectArea("SF2")
				DbSetOrder(1)
				DbSeek(cJobFil+cNUmNota+cNumSeri)
				
				If cNumSeri == "RP2"
					DT_FAT_SOFT := SF2->F2_EMISSAO 
					DT_FAT		:= dTos(DT_FAT_SOFT) 
					DT_FAT_SOFT := SUBSTRING(DT_FAT,7,2)+"/"+SUBSTRING(DT_FAT,5,2)+"/"+SUBSTRING(DT_FAT,1,4)
				Else
					DT_FAT_HARD := SF2->F2_EMISSAO
					DT_FAT2 	:= dTos(DT_FAT_HARD)
					DT_FAT_HARD := SUBSTRING(DT_FAT2,7,2)+"/"+SUBSTRING(DT_FAT2,5,2)+"/"+SUBSTRING(DT_FAT2,1,4)
				Endif
								
				If TRBPEDTXT->CATEGORIA = '2'  
				
					cLinCert:= 	PADR(StrTran(alltrim(Str(TRBPEDTXT->VL_PEDIDO)),".",","),16," ")+;
								PADR(cDS_PROD,128," ")	
					cLinFat :=  PADR(DT_FAT_SOFT,10," ")
					nCountHrd += 0
					
				ElseIf TRBPEDTXT->CATEGORIA = '1'  
				
					If nLinPed == 1
						cLinHad1:= 	PADR(StrTran(alltrim(Str(TRBPEDTXT->VL_PEDIDO)),".",","),16," ")+;
									PADR(cDS_PROD,128," ")
						
						cLinHad2 := PADR(StrTran(" ",".",","),144," ")
						cLinFat1 := PADR(DT_FAT_HARD,10," ")     
						nCountHrd += 1
						
					Else			
						cLinHad2:=	PADR(StrTran(alltrim(Str(TRBPEDTXT->VL_PEDIDO)),".",","),16," ")+;
									PADR(cDS_PROD,128," ")	 
						cLinFat1 := PADR(DT_FAT_HARD,10," ")
						nCountHrd += 2 
						  	
					EndIf   
					                 
					   						  								
					nLinPed	++			
					
				EndIf		   
				 
									
				cPedido := TRBPEDTXT->PEDIDO
				    
				TRBPEDTXT->(DbSkip())
				
				If cPedido <> TRBPEDTXT->PEDIDO 
								
				    /*
					IF nCountHrd == 0
						cLinFat := PADR(StrTran(" ",".",","),144," ")+;
									PADR(StrTran(" ",".",","),144," ")+;
									PADR(DT_FAT_SOFT,10," ")  

					EndIf
	                */
				
					If cLinCert <> " "
					
							/*==================================================================
							Renato Ruy - Comentrio com as posies que devem ser enviadas para
							o arquivo que  lido pela rea de banco de dados
							==================================================================*/
					        /*
							V_CD_PEDIDO           := Da posio 001 l os prximos 038 caracteres
							V_DT_FATURAMENTO      := Da posio 039 l os prximos 010 caracteres
							V_VL_FATURAMENTO      := Da posio 049 l os prximos 016 caracteres
							V_DS_FMA_PGTO         := Da posio 065 l os prximos 072 caracteres
							V_IC_NOTA_GERADA      := Da posio 137 l os prximos 001 caracteres
							V_DS_MUNICIPIO        := Da posio 138 l os prximos 035 caracteres
							V_DS_UF             := Da posio 173 l os prximos 003 caracteres
							V_VL_CERTIFICADO      := Da posio 176 l os prximos 016 caracteres
							V_DS_CERTIFICADO      := Da posio 192 l os prximos 128 caracteres
							V_VL_HARDWARE1        := Da posio 320 l os prximos 016 caracteres
							V_DS_HARDWARE1        := Da posio 336 l os prximos 128 caracteres
							V_VL_HARDWARE2        := Da posio 464 l os prximos 016 caracteres
							V_DS_HARDWARE2        := Da posio 480 l os prximos 128 caracteres
							V_TMP_DT_FAT_CERTIFIC := Da posio 608 l os prximos 011 caracteres
							V_TMP_DT_FAT_HARDWARE := Da posio 619 l os prximos 010 caracteres
							*/
                            //Solicitante: Gustavo Dias - 15/04/2015
                            //Alterado por: Renato Ruy
							//Fora ajustes de posies
							cLin	 := PadR(cLin,48," ")
							cLinVlr	 := PadR(cLinVlr,16," ")
							cLinForm := PadR(cLinForm,72," ")
							cLinNfGe := PadR(cLinNfGe,1," ")
							cLinMun  := PadR(cLinMun,35," ")
							cLinEst	 := PadR(cLinEst,3," ")
							cLinCert := PadR(cLinCert,144," ")
							cLinHad1 := PadR(cLinHad1,144," ")
							cLinHad2 := PadR(cLinHad2,144," ")
							cLinFat  := PadR(cLinFat ,10 ," ")
							cLinFat1 := PadR(cLinFat1,10 ," ")
							
				   			FWrite(nHandle, cLin+cLinVlr+cLinForm+cLinNfGe+cLinMun+cLinEst+cLinCert+cLinHad1+cLinHad2+cLinFat+" "+cLinFat1+CRLF )
					Else 	
							//Solicitante: Gustavo Dias - 15/04/2015
                            //Alterado por: Renato Ruy
							//Fora ajustes de posies
							cLin	 := PadR(cLin,48," ")
							cLinVlr	 := PadR(cLinVlr,16," ")
							cLinForm := PadR(cLinForm,72," ")
							cLinNfGe := PadR(cLinNfGe,1," ")
							cLinMun  := PadR(cLinMun,35," ")
							cLinEst	 := PadR(cLinEst,3," ")
							cLinCert := PadR(cLinCert,144," ")
							cLinHad1 := PadR(cLinHad1,144," ")
							cLinHad2 := PadR(cLinHad2,144," ")
							cLinFat  := PadR(cLinFat ,10 ," ")
							cLinFat1 := PadR(cLinFat1,10 ," ")
							
					   		FWrite(nHandle, cLin+cLinVlr+cLinForm+cLinNfGe+cLinMun+cLinEst+cLinCert+cLinHad1+cLinHad2+cLinFat+" "+cLinFat1+CRLF )
					Endif 
					
					nLinPed	:= 1
					nVlrPed	:= 0
					cLin 	:= ""
					cLinVlr	:= ""
					cLinForm:= ""
					cLinNfGe:= ""
					cLinCert:= ""
					cLinHad1:= ""
					cLinHad2:= ""  
					cLinMun := ""
					cLinEst := ""
					cLinFat := "" //03/09/2013 - Renato Ruy - Declarao da variavel, estava gerando erro.
					cLinFat1:= "" 
					nCountHrd := 0
					 
								
				EndIf
			
			EndDo	
			
			fclose(nHandle)
//			Conout("Job GARA181 - SUCESS EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
//			Conout("Tempo de Execucao Inicio- "+cTime+" Termino "+Time())
//			Conout("Arquivo Criado - "+cFileOut)
			
		Else
//			Conout("Job GARA181 - ERRO EXECUTE Emp("+cJobEmp+"/"+cJobFil+")" )
//			CONOUT("ERROR - FAILED TO CREATE "+cFileOut+" - FERROR "+str(ferror()))
			ConOut("No foi possivel criar o arquivo no caminho: "+ cFileOut)
		Endif
		
		TRBPEDTXT->(DbCloseArea())                                   
	EndDo
//EndIf
Conout("Job GARA181 - End Begin Emp("+cJobEmp+"/"+cJobFil+")" )

Return