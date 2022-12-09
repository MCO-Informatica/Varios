#INCLUDE "Protheus.ch"
               
//+---------------------------------------------------------------+
//| Rotina | RTMK007 | Autor | Rafael Beghini | Data | 06/03/2015 |
//+---------------------------------------------------------------+
//| Descr. | Relat�rio de Movimenta��o de Voucher	              |
//| Orienta��o | Jos� Felipe - Sistemas Corporativos              |
//+---------------------------------------------------------------+
//| Uso    | SAC [CertiSign]                                      |
//+---------------------------------------------------------------+
User Function RTMK007()                                      

	Local cDesc1	:= "Este programa tem como objetivo imprimir movimenta��o de voucher "
	Local cDesc2	:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3	:= "Movimenta��o de Voucher"    
	Local cPict		:= ""
	Local titulo	:= "@Movimenta��o de Voucher"   
	Local nLin		:= 80
	Local Cabec1	:= "FLUXO    VOUCHER      PRODUTO         SOLICITANTE               TIPO           PEDIDO GAR  PRODUTO GAR               MOTIVO                          DATA       USUARIO                       SITUACAO             DT VL"
	Local Cabec2	:= "                      ORIGEM                                                   ORIGEM                                                                CRIACAO    PED GAR                       PD ORI"
	Local imprime	:= .T.
	Local aOrd		:= {"Por Codigo Fluxo/Voucher"}
	
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "RTMK007" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, ""/*"ZF_TIPOVOU == '2' .Or. ZF_TIPOVOU == 'A'"*/, 1}
	Private nLastKey     := 0
	Private cbtxt      	 := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RTMK007"
	Private cPerg 	     := "RTMK007"
	Private cString      := "SZG"
	
	AjustaSX1()
	
	If !Pergunte(cPerg,.T.)
		Return
	EndIf              
	
	//���������������������������������������������
	//�Monta a interface padrao com o usuario...  �
	//���������������������������������������������
	wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//�������������������������������������������������������������������Ŀ
	//�Processamento. RPTSTATUS monta janela com a regua de processamento.�
	//���������������������������������������������������������������������
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RUNREPORT �Autor  �AP6 IDE             � Data �  04/10/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem  
	Local _aDados := {}
	Local _aCabec := {}
	Local dVencReal 
	Local nCols   := {}
	
	cAliasTrb := "TRBSZG"
	
	BeginSql Alias cAliasTrb
	
		SELECT 
	    ZG_NUMPED, ZG_CODFLU, ZG_ITEMPED, ZG_NUMVOUC,
	    ZG_QTDSAI, ZG_PEDIDO, ZG_NFSER, ZG_NFPROD, ZG_NFENT, 
	    ZG_NUMEST, ZG_DATAMOV
		FROM 
	    	%Table:SZG% 
	    WHERE
	    	ZG_FILIAL = ' ' AND
	    	ZG_DATAMOV BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
	    	D_E_L_E_T_ = ' '
	 	
	EndSql
	
	TcSetField( cAliasTrb, "ZG_DATAMOV" , "D",  8, 0 ) 
	TcSetField( cAliasTrb, "ZG_DATAMOV", "D",  8, 0 ) 
	  
	TRBSZG->(dbGoTop())
	
	While !TRBSZG->( EoF() )    
	
		aAdd(_aDados, 	{ZG_NUMPED,; 
						ZG_CODFLU,; 
						ZG_ITEMPED,; 
					   ALLTRIM(	CHR(160)+ZG_NUMVOUC),;
						Transform(ZG_QTDSAI,'@R 999,999,999.99'),; 
						ZG_DATAMOV} )
	
	   TRBSZG->(dbSkip())    
	
	EndDo
	
	TRBSZG->( dbCloseArea() )
	
	nDados := Len(_aDados)
	nCount := 1
	
	Do While nCount <= nDados
	
		//�����������������������������������������Ŀ
		//� Verifica o cancelamento pelo usuario... �
		//�������������������������������������������
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif            
	   
		//��������������������������������������Ŀ
		//�Impressao do cabecalho do relatorio. .�
		//����������������������������������������
		If nLin > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		    
	    nCols := 1 
	  	@nLin,01 PSAY _aDados[nCount][nCols]	
		nCols++
		@nLin,09 PSAY _aDados[nCount][nCols]	
		nCols++
		@nLin,22 PSAY _aDados[nCount][nCols] 		
		nCols++
		@nLin,38 PSAY _aDados[nCount][nCols]  		
		nCols++ 
		@nLin,64 PSAY SubStr( _aDados[nCount][nCols], 1, 15 )
		nCols++ 
		@nLin,79 PSAY _aDados[nCount][nCols]  		  		
		nCols++  
							
		nLin++
		nCount++ 
			                  
	EndDo
	
	@nLin,00 PSAY Replicate ("__",220)
	nLin += 2
	
	//���������������������������������LӦLӦ�
	//� Abertura do Arquivo em EXCEL. �
	//���������������������������������LӦLӦ�
	If mv_par03 == 1
	
		For nX := 1 To Len( _aDados )
			_aDados[nX,1] := Chr(160) + _aDados[nX,1]
			_aDados[nX,2] := Chr(160) + _aDados[nX,2]
		Next nX  
		
		AAdd(_aCabec,"NUM_PEDIDO")
		AAdd(_aCabec,"CODIGO_DO_FLUXO")
		AAdd(_aCabec,"ITEM_DO_PEDIDO")
		AAdd(_aCabec,"NUM_VOUCHER")
		AAdd(_aCabec,"QTD_SAIDA")  
		AAdd(_aCabec,"DATA_MOVIMENTACAO")  
		
		Processa( {|| DlgToExcel({ {"ARRAY","@Rela��o de Voucher", _aCabec,_aDados} }) }, "Exp. Rela��o de Voucher","Aguarde, exportando para Excel...",.T.)
		
	EndIf
	
	//��������������������������������������Ŀ
	//�Finaliza a execucao do relatorio...   �
	//����������������������������������������
	
	SET DEVICE TO SCREEN
	
	//�������������������������������������������������������������Ŀ
	//�Se impressao em disco, chama o gerenciador de impressao...   �
	//���������������������������������������������������������������
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AjusteSX1 �Autor  � Rafael Beghini � Data �  06/03/15      ���
�������������������������������������������������������������������������͹��
���Descricao � Cria grupo de perguntas RTMK001.                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()

	Local aArea := GetArea()
	
	PutSx1( cPerg, 	"01", "Movimentacao De?         ", "Movimentacao De?         ", "Movimentacao De?         ", "mv_ch1", "D", 08, 00, 01, "G", "", "   ", "", "", "mv_par01",;
					" "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data de Movimentacao inicial do voucher"})
					
	PutSx1( cPerg, 	"02", "Movimentacao Ate?        ", "Movimentacao Ate?        ", "Movimentacao De?        ", "mv_ch2", "D", 08, 00, 01, "G", "", "   ", "", "", "mv_par02",;
					" "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data de Movimentacao final do voucher"})
					
	PutSx1( cPerg, 	"03", "Excel			 ","Excel              ","Excel             ","mv_ch3","N",01,00,01,"C","",""   ,"","","mv_par03",;
					"Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo em Excel"})
	
	RestArea(aArea)

Return