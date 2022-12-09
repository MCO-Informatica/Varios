#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RTMK001  �Autor  � Gustavo Prudente   � Data �  04/01/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio Voucher perfil SAC                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CertiSign - SAC                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RTMK001()

Local cDesc1	:= "Este programa tem como objetivo imprimir relatorio de voucher "
Local cDesc2	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3	:= "Rela��o de Voucher"    
Local cPict		:= ""
Local titulo	:= "@Rela��o de Voucher"   
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
Private nomeprog     := "RTMK001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "ZF_TIPOVOU == '2' .Or. ZF_TIPOVOU == 'A'", 1}
Private nLastKey     := 0
Private cbtxt      	 := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RTMK001"
Private cPerg 	     := "RTMK001"
Private cString      := "SZF"

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

cAliasTrb := "TRBSZF"

BeginSql Alias cAliasTrb

	SELECT 
    	ZF_FILIAL, ZF_CODFLU, ZF_COD, ZF_PRODUTO, ZF_USRSOL, ZF_DESTIPO, ZF_PEDIDO, 
    	ZF_PDESGAR, ZF_DESMOT, ZF_OBS, ZF_DATCRI, ZF_CDPRGAR, ZF_DESPRO, ZF_USERNAM, 
    	ZF_AC, ZF_AR, ZF_STCERPD, ZF_CGCCLI, ZF_NOMCLI, ZF_DTVLPGO
	FROM 
    	%Table:SZF% 
    WHERE
    	ZF_FILIAL = ' ' AND
    	ZF_DATCRI BETWEEN %Exp:mv_par01% AND %Exp:mv_par02% AND
    	D_E_L_E_T_ = ' '
 	
EndSql

TcSetField( cAliasTrb, "ZF_DATCRI" , "D",  8, 0 ) 
TcSetField( cAliasTrb, "ZF_DTVLPGO", "D",  8, 0 ) 
  
TRBSZF->(dbGoTop())

While !TRBSZF->( EoF() )

	aAdd(_aDados, 	{   TRBSZF->ZF_CODFLU,;		// 7
        				TRBSZF->ZF_COD,;		// 12
        				TRBSZF->ZF_PRODUTO,;    // 15
        				TRBSZF->ZF_USRSOL,;     // 25
        			 	TRBSZF->ZF_DESTIPO,;    // 30
        			 	TRBSZF->ZF_PEDIDO,;     // 10
        			 	TRBSZF->ZF_PDESGAR,;    // 32
        			 	TRBSZF->ZF_DESMOT,;     // 30
        			 	TRBSZF->ZF_OBS,;        // 50
        			 	TRBSZF->ZF_DATCRI,;     // 10
        			 	TRBSZF->ZF_CDPRGAR,;    // 32
        			 	TRBSZF->ZF_DESPRO,;     // 30
        			 	TRBSZF->ZF_USERNAM,;    // 25
        			 	TRBSZF->ZF_AC,;         // 40
        			 	TRBSZF->ZF_AR,;         // 40
        			 	TRBSZF->ZF_STCERPD,;    // 30
        			 	TRBSZF->ZF_CGCCLI,;     // 14
        			 	TRBSZF->ZF_NOMCLI,;     // 40
        			 	TRBSZF->ZF_DTVLPGO } )	// 10

   TRBSZF->(dbSkip())    

EndDo

TRBSZF->( dbCloseArea() )

_aDados := aSort(_aDados,,,{|x,y| x[1]+x[2] < y[1]+y[2]}) 

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
	@nLin,91 PSAY SubStr( _aDados[nCount][nCols], 1, 25 )
	nCols++
	@nLin,117 PSAY _aDados[nCount][nCols]		
	nCols++	// ZF_OBS
	nCols++
	@nLin,149 PSAY _aDados[nCount][nCols]		
	nCols++ // ZF_CDPRGAR
	nCols++ // ZF_DESPRO
	nCols++
	@nLin,160 PSAY _aDados[nCount][nCols]		
	nCols++ // ZF_AC
	nCols++ // ZF_AR
	nCols++
	@nLin,190 PSAY SubStr( _aDados[nCount][nCols], 1, 20 )
	nCols++ // ZF_CGCLI
	nCols++ // ZF_NOMCLI
	nCols++
	@nLin,211 PSAY _aDados[nCount][nCols]
						
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

	AAdd(_aCabec,"FLUXO")
	AAdd(_aCabec,"VOUCHER")
	AAdd(_aCabec,"PRODUTO_ORIGEM")
	AAdd(_aCabec,"SOLICITANTE")
	AAdd(_aCabec,"TIPO")
	AAdd(_aCabec,"PED_GAR_ORIGEM")
	AAdd(_aCabec,"PRODUTO_GAR")
	AAdd(_aCabec,"MOTIVO")
	AAdd(_aCabec,"OBS")
	AAdd(_aCabec,"DATA_CRIACAO")
	AAdd(_aCabec,"PRODUTO_GAR_ORIGEM")
	AAdd(_aCabec,"DESCRICAO_PROD_ORIGEM")
	AAdd(_aCabec,"USUARIO")
	AAdd(_aCabec,"AC")
	AAdd(_aCabec,"AR")
	AAdd(_aCabec,"SITUACAO_PED_GAR")
	AAdd(_aCabec,"CNPJ/CPF")
	AAdd(_aCabec,"NOME CLIENTE")
	AAdd(_aCabec,"VALID_PED_ORIGEM")
  
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
���Programa  � AjusteSX1 �Autor  � Gustavo Prudente   � Data �  04/01/12  ���
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

PutSx1( cPerg, 	"01", "Data Criacao De?         ", "Data Criacao De?         ", "Data Criacao De?         ", "mv_ch1", "D", 08, 00, 01, "G", "", "   ", "", "", "mv_par01",;
				" "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data de cria��o inicial do voucher"})
				
PutSx1( cPerg, 	"02", "Data Criacao Ate?        ", "Data Criacao Ate?        ", "Data Criacao Ate?        ", "mv_ch2", "D", 08, 00, 01, "G", "", "   ", "", "", "mv_par02",;
				" "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data de cria��o final do voucher"})
				
PutSx1( cPerg, 	"03", "Excel			 ","Excel              ","Excel             ","mv_ch3","N",01,00,01,"C","",""   ,"","","mv_par03",;
				"Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo em Excel"})

RestArea(aArea)

Return