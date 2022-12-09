#INCLUDE "RWMAKE.CH"

/* 
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �LJFISCHI	� Autor � Leandro Nogueira      � Data � 30/03/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina para impressao de FACTURA e BOLETA - Chile - R 11.5  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 �SIGALOJA/SIGAFRT						                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LJFISCHI()

Local nTotImps  := 0		//Total de impostos
Local nX		:= 0		//Contador de for
Local aTesImpInf:= {}		//TES
Local cDataExt	:= ""
Local cEspecie	:= "1"
Local cGiro		:= "" 
Local nLinha	:= 20                           
Local nMoedaCor := 1


If !cPaisLoc == "CHI" .AND. !GetRpoRelease("R5")  .AND. SuperGetMv("MV_CTRLFOL",.F.)	
	Return Nil
EndIf

M->L1_NUM := SL1->L1_NUM

//��������������������������������������������������������������������������������������������������������������������������Ŀ
//�                                              CABECALHO                                                                   �
//����������������������������������������������������������������������������������������������������������������������������
@01,040 PSAY SM0->M0_CGC										//RUT ESTABELECIMENTO
@02,040 PSAY SM0->M0_ENDCOB										//ENDERECO ESTABELECIMENTO
@03,040 PSAY SM0->M0_BAIRCOB									//COMUNA/BARIO ESTABELECIMENTO
@04,040 PSAY Trim(SM0->M0_CIDCOB) + "," + Trim(SM0->M0_ESTCOB)	//CIDADE e REGIAO ESTABELECIMENTO

dbSelectArea("SL1")
@05,110 PSAY SL1->L1_DOC										//FACTURA/BOLETA

//���������������������������Ŀ
//� Controle de Formul�rios	  �
//�����������������������������  
	dbSelectArea( "SFP" )                 
	If dbSeek( xFilial("SFP")+SL1->L1_FILIAL+SL1->L1_SERIE)
		cEspecie:= SFP->FP_ESPECIE
		@06,110 PSAY Rtrim(SFP->FP_CAI)							//NUMERO DA RESOLUCION
		@07,110 PSAY SFP->FP_DTAVAL		   						//DATA DA RESOLUCION			
	EndIf	



cDataExt := Trim(SM0->M0_CIDCOB) + "," + Transform(Day(dDataBase),'99') + " de " + MesExtenso(dDataBase) + " de " + Transform(Year(dDataBase),'9999') 
@08,005 PSAY cDataExt											//DATA POR EXTENSO


//���������Ŀ
//�Cliente  �
//�����������
dbSelectArea( "SA1" )
dbSeek( xFilial("SA1")+SL1->L1_CLIENTE )

@10,010 PSAY A1_NOME            								//SENOR(ES)
@11,110 PSAY Trim(A1_CGC) PICTURE PesqPict("SA1","A1_CGC")     	//RUT
@12,010 PSAY Trim(A1_END) 										//DIRECION
@13,010 PSAY Trim(A1_BAIRRO) 									//COMUNA
@13,050 PSAY Trim(A1_MUN) 		   								//CIUDAD
@13,110 PSAY A1_TEL  	PICTURE PesqPict("SA1","A1_TEL")		//TELEFONO 


//����������������������Ŀ
//� Segmentos do Mercado �
//������������������������
cGiro:= Posicione("SX5",1,xFilial("SX5")+"T3"+SA1->A1_SATIV1,"X5_DESCRI")

@14,010 PSAY cGiro	 											//GIRO


//������������������������Ŀ
//� Condicao de pagamento  �
//��������������������������
dbSelectArea( "SE4" )
dbSeek( xFilial("SE4")+SL1->L1_CONDPG )

@15,010 PSAY Rtrim(SE4->E4_DESCRI) 								//CONDICION VENTA

//��������������������������������������������������������������������������������������������������������������������������Ŀ
//�                                              ITENS                                                                       �
//����������������������������������������������������������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Posiciona no arquivo de Itens							     �
//����������������������������������������������������������������
dbSelectArea( "SL2" )
dbSeek( xFilial("SL2")+M->L1_NUM )

While SL2->(!Eof()) .AND. L2_FILIAL+L2_NUM == xFilial("SL2")+M->L1_NUM
    
	@ nLinha,004 PSAY L2_QUANT	  Picture "999" 				//CANTIDAD
	
	//��������Ŀ
	//�PRODUCTO�
	//����������
	@ nLinha,014 PSAY L2_PRODUTO   								//CODIGO
	dbSelectArea( "SB1" )                                       
	dbSeek( xFilial("SB1")+SL2->L2_PRODUTO)						
	dbSelectArea( "SL2")
	@nLinha,022 PSAY Rtrim(SB1->B1_DESC)                		//DESCRICAO
	@nLinha,090 PSAY Trim(SB1->B1_UM)                          //UNIDADE
	@nLinha,092 PSAY SL2->L2_VRUNIT	 ;
			PICTURE PesqPict("SL2","L2_VRUNIT",,nMoedaCor)		//VALOR UNITARIO
	@nLinha,110 PSAY SL2->L2_VLRITEM ;
			PICTURE PesqPict("SL2","L2_VLRITEM",,nMoedaCor)		//VALOR TOTAL
	nLinha++

	//��������������������Ŀ
	//�Controle de impostos�
	//����������������������
	aTesImpInf  := TesImpInf(SL2->L2_TES)
   	For nX  := 1 to Len(aTesImpInf)	   
    	If aTesImpInf[nX][3] == "1"  //Incide na NF			   
     		nTotImps  += SL2->(FieldGet(FieldPos("L2_"+Substr(aTesImpInf[nX][2],4,7))))	         
      	EndIf   
   	Next nX      	
	dbSkip()
End

//����������Ŀ
//� Vendedor �
//������������
dbSelectArea( "SA3" )
dbSeek( xFilial("SA3")+SL1->L1_VEND)
@72,022 PSAY "Atencion de :" + SA3->A3_NOME

@73,022 PSAY "Caja :" + SL1->L1_OPERADO

//��������������������������������������������������������������������������������������������������������������������������Ŀ
//�                                              RODAPE                                                                      �
//����������������������������������������������������������������������������������������������������������������������������
@76,105 PSAY SL1->L1_VALMERC;
		Picture PesqPict("SL1","L1_VALMERC",,nMoedaCor)			//SUB-TOTAL
@77,105 PSAY nTotImps;
		Picture PesqPict("SL2","L2_VALIMP1",,nMoedaCor)			//TOTAL IVA
@78,105 PSAY SL1->L1_VLRTOT;	 	
		Picture PesqPict("SL1","L1_VLRTOT",,nMoedaCor)			//TOTAL

//�����������������������������������������������Ŀ
//�Impressao exclusiva para Boleta e Boleta Exenta�
//�������������������������������������������������
If cEspecie $ "3|4" 
	@083,040 PSAY "BOLETA DE VENTA AUTORIZADA POR EL SII"   
EndIf


Ms_Flush()

Return()

