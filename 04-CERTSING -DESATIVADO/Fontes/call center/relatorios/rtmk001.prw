#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RTMK001  บAutor  ณ Gustavo Prudente   บ Data ณ  04/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Voucher perfil SAC                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CertiSign - SAC                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RTMK001()

Local cDesc1	:= "Este programa tem como objetivo imprimir relatorio de voucher "
Local cDesc2	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3	:= "Rela็ใo de Voucher"    
Local cPict		:= ""
Local titulo	:= "@Rela็ใo de Voucher"   
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta a interface padrao com o usuario...  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento. RPTSTATUS monta janela com a regua de processamento.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ RUNREPORT บAutor  ณAP6 IDE             บ Data ณ  04/10/12  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario... ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif            
   
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณImpressao do cabecalho do relatorio. .ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤใLำฆLำฆฟ
//ณ Abertura do Arquivo em EXCEL. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤใLำฆLำฆู
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
  
	Processa( {|| DlgToExcel({ {"ARRAY","@Rela็ใo de Voucher", _aCabec,_aDados} }) }, "Exp. Rela็ใo de Voucher","Aguarde, exportando para Excel...",.T.)
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFinaliza a execucao do relatorio...   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe impressao em disco, chama o gerenciador de impressao...   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ AjusteSX1 บAutor  ณ Gustavo Prudente   บ Data ณ  04/01/12  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDescricao ณ Cria grupo de perguntas RTMK001.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1()

Local aArea := GetArea()

PutSx1( cPerg, 	"01", "Data Criacao De?         ", "Data Criacao De?         ", "Data Criacao De?         ", "mv_ch1", "D", 08, 00, 01, "G", "", "   ", "", "", "mv_par01",;
				" "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data de cria็ใo inicial do voucher"})
				
PutSx1( cPerg, 	"02", "Data Criacao Ate?        ", "Data Criacao Ate?        ", "Data Criacao Ate?        ", "mv_ch2", "D", 08, 00, 01, "G", "", "   ", "", "", "mv_par02",;
				" "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data de cria็ใo final do voucher"})
				
PutSx1( cPerg, 	"03", "Excel			 ","Excel              ","Excel             ","mv_ch3","N",01,00,01,"C","",""   ,"","","mv_par03",;
				"Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo em Excel"})

RestArea(aArea)

Return