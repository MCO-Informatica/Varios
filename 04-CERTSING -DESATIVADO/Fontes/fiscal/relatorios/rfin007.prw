#INCLUDE "rwmake.ch"
#DEFINE PICT_VL  "@E 999,999,999.99"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFIN006   บAutor  ณRen๊ Lopes          บ Data ณ  19/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Hardware Avulso                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function RFIN007()

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variaveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio de mapa de hardware avulso "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Hardware Avulso"
Local cPict          := ""
Local titulo       := "Hardware Avulso"
Local nLin         := 80

Local Cabec1       := "FORNECEDOR  NOME                                                           CNPJ                 NUMERO   EMISSAO     ALIQ    BS.INSS    VLINSS      DT.VENC     VENC REAL   DT.DIGIT    FILIAL"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RFIN007" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RFIN007" // Coloque aqui o nome do arquivo usado para impressao em disco 
Private cPerg 	:= "RFIN007" 
Private cString := "" 

private aCabecAC2	:= {}
private aCabecFIXO	:= {}
Private aCabec		:= {}
private nTamCabec 	:= 0 //tamanho cabe๏ฟฝalho      

AjustaSX1()
If !Pergunte(cPerg,.T.)
	Return
EndIf     


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤL,็L,็ฟ
//ณMonta a interface padrao com o usuario...  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤL,็L,็ู
*/

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessamento. RPTSTATUS monta janela com a regua de processamento.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRUNREPORT     บAutor  ณAP6 IDE         บ Data ณ  04/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cStatus := ""  

cAliasTrb := "TRC"

 	BeginSql Alias cAliasTrb
  		
  		SELECT 
		C5.C5_NUM AS PEDIDO,
		C5.C5_CLIENTE AS COD_CLIENTE,
		(SELECT A1_NOME FROM %Table:SA1% A1 WHERE C5.C5_CLIENTE = A1.A1_COD AND D_E_L_E_T_ = ' ') AS NOME, 
		SUBSTR(C5.C5_EMISSAO,7,2) ||'/'|| SUBSTR(C5.C5_EMISSAO,5,2) ||'/'|| SUBSTR(C5.C5_EMISSAO,1,4) AS DT_PEDIDO,
		CONVERT(C5.C5_XPOSTO,'US7ASCII') AS COD_POSTO,
		C6.C6_PRODUTO AS PRODUTO,
		C6.C6_DESCRI AS DESCR_PROD,
		C6.C6_QTDVEN AS QUANTIDADE,
		C6.C6_PRCVEN AS PRECO_UNIT,
		C6.C6_VALOR AS PRECO_TOTAL,
		C5.C5_XNPSITE AS SITES,
		C6.C6_TES AS TES,
		SUBSTR(C6.C6_DATFAT,7,2) ||'/'|| SUBSTR(C6.C6_DATFAT,5,2) ||'/'|| SUBSTR(C6.C6_DATFAT,1,4) AS DT_FATURAMENTO,
		SUBSTR(C6.C6_DATFAT,1,6) PERIODO
		FROM
		%Table:SC5% C5 INNER JOIN %Table:SC6% C6 ON C6.C6_FILIAL = C5.C5_FILIAL AND C5.C5_NUM = C6.C6_NUM AND C5.C5_CLIENT = C6.C6_CLI 
		WHERE
		C5.C5_FILIAL  =  %xfilial:SC5% AND
		C6.C6_DATFAT  >= %exp:mv_par01% AND
		C6.C6_DATFAT  <= %exp:mv_par02% AND  
		C5.C5_XORIGPV = '3'  AND
		C6.C6_XOPER   IN ('53','62')  AND
		C5.C5_XNPSITE <> ' ' AND   
		C6.C6_NOTA    <> ' ' AND
		C6.D_E_L_E_T_ = ' ' AND
		C5.D_E_L_E_T_ = ' ' 
		UNION ALL
		SELECT 
		C5.C5_NUM AS PEDIDO,
		C5.C5_CLIENTE AS COD_CLIENTE,
		(SELECT A1_NOME FROM %Table:SA1% A1 WHERE C5.C5_CLIENTE = A1.A1_COD AND D_E_L_E_T_ = ' ') AS NOME, 
		SUBSTR(C5.C5_EMISSAO,7,2) ||'/'|| SUBSTR(C5.C5_EMISSAO,5,2) ||'/'|| SUBSTR(C5.C5_EMISSAO,1,4) AS DT_PEDIDO,
		CONVERT(C5.C5_XPOSTO,'US7ASCII') AS COD_POSTO,
		C6.C6_PRODUTO AS PRODUTO,
		C6.C6_DESCRI AS DESCR_PROD,
		C6.C6_QTDVEN AS QUANTIDADE,
		C6.C6_PRCVEN AS PRECO_UNIT,
		C6.C6_VALOR AS PRECO_TOTAL,
		C5.C5_XNPSITE AS SITES,
		C6.C6_TES AS TES,
		SUBSTR(C6.C6_DATFAT,7,2) ||'/'|| SUBSTR(C6.C6_DATFAT,5,2) ||'/'|| SUBSTR(C6.C6_DATFAT,1,4) AS DT_FATURAMENTO,
		SUBSTR(C6.C6_DATFAT,1,6) PERIODO
		FROM
		%Table:SC5% C5 INNER JOIN %Table:SC6% C6 ON C6.C6_FILIAL = C5.C5_FILIAL AND C5.C5_NUM = C6.C6_NUM AND C5.C5_CLIENT = C6.C6_CLI 
		WHERE
		C5.C5_FILIAL  =  %xfilial:SC5% AND
		C5.C5_XPOSTO != ' ' AND
		C6.C6_DATFAT  >= %exp:mv_par01% AND
		C6.C6_DATFAT  <= %exp:mv_par02% AND  
		C5.C5_XORIGPV = '2'  AND
		C6.C6_XOPER  IN ('53','62')  AND
		C5.C5_XNPSITE <> ' ' AND   
		C6.C6_NOTA    <> ' ' AND
		(C6.C6_PEDGAR = ' ' AND C5.C5_CHVBPAG = ' ') AND
		(C6.C6_XIDPED = C6.C6_XIDPEDO) and
		C6.C6_XSKU = ' ' AND		
		C6.D_E_L_E_T_ = ' ' AND
		C5.D_E_L_E_T_ = ' ' 
		ORDER BY PEDIDO
   ENDSQL
   

_aCabec 	:= {}
_aDados		:= {}
  
DbSelectArea("TRC") 
TRC->(dbGoTop())

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSETREGUA -> Indica quantos registros serao processados para a reguaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

SetRegua(RecCount())   


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosicionamento do primeiro registro e loop principal. Pode-se criar  ณ
//ณa logica da seguinte maneira: Posiciona-se na filial corrente e pro  ณ
//ณcessa enquanto a filial do registro for a filial corrente. Por exem  ณ
//ณplo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:     ณ
//ณ                                                                     ณ
//ณdbSeek(xFilial())                                                    ณ
//ณWhile !EOF() .And. xFilial() == A1_FILIAL                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
_aDados		:= {} 

TRC->(DbGoTop())

While !TRC->(EOF())

DbSelectArea("SZ3")
DbSetOrder(4)
DbSeek(xFilial("SZ3")+TRC->COD_POSTO)

cNomePosto := Alltrim(SZ3->Z3_DESENT)
cDesAr 	   := Alltrim(SZ3->Z3_DESAR) 
	
	//Renato Ruy - 07/12/2017
	cStatus := ""
	SZ6->(DbSetOrder(4))
	If SZ6->(DbSeek(xFilial("SZ6")+TRC->Sites))
		If SZ6->Z6_PERIODO != TRC->Periodo
			cStatus := "Pago Anteriormente no perํodo : " + SZ6->Z6_PERIODO
		Else
			cStatus := "Lan็amento gerado no perํodo : " + SZ6->Z6_PERIODO
		Endif
	Else
		cStatus := "O pedido nใo foi calculado"
	Endif
	
	aAdd(_aDados, 	{   TRC->Pedido,;
        				TRC->Cod_Cliente,;
        			  	TRC->Nome,;
        				TRC->DT_Pedido,;
        				TRC->Cod_Posto,;
        				cNomePosto,;
        				cDesAr,;
        				TRC->Produto,;
        			 	TRC->Descr_Prod,;
        				TRC->Quantidade,;
        				TRC->Preco_Unit,;
        				TRC->Preco_Total,;
        				TRC->Sites,;
        				TRC->Tes,;
        				TRC->Dt_Faturamento,;
        				cStatus,;
 					}) 
TRC->(Dbskip())        				  
Enddo 

nDados := Len(_aDados)
nCount := 1
Private aCols

While nCount <= nDados 


		/*                       Emissใo
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario... ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		*/
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif            
   
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณImpressao do cabecalho do relatorio. .ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
     If nLin > 55 // Salto de P๏ฟฝgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
  	 Endif
	
	 // Coloque aqui a logica da impressao do seu programa...
   	// Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
 		
 		
       //nLin := nLin + 1 // Avanca a linha de impressa
	    
        aCols := 1 
   //   	@nLin,02  PSAY _aDados[nCount][aCols]	
   		aCols++
   	 //	@nLin,12  PSAY _aDados[nCount][aCols]	
		aCols++
	   //	@nLin,75 PSAY _aDados[nCount][aCols] 		//PICTURE "@R 99.999.999/9999-99"
		aCols++
		//@nLin,96 PSAY _aDados[nCount][aCols]  	  //	PICTURE "999999"
		aCols++ 
		//@nLin,105 PSAY _aDados[nCount][aCols] 	
		//aCols++
	//	@nLin,105 PSAY _aDados[nCount][aCols]		
		aCols++ 
	  //	@nLin,117 PSAY _aDados[nCount][aCols]  		  		
		aCols++  
	//	@nLin,120 PSAY _aDados[nCount][aCols]       //PICTURE PICT_VL
		aCols++
	  //	@nLin,132 PSAY _aDados[nCount][aCols]		//PICTURE PICT_VL
		aCols+=2 
	//	@nLin,149 PSAY _aDados[nCount][aCols]   
		aCols++
	  //	@nLin,161 PSAY _aDados[nCount][aCols]
		aCols++
	//	@nLin,173 PSAY _aDados[nCount][aCols]
	  	aCols++ 
	  //	@nLin,185 PSAY _aDados[nCount][aCols]
		aCols++
	//	@nLin,210 PSAY _aDados[nCount][aCols]				
		
		nLin++
		nCount++ 
		                  
EndDo
TRC->(dbCloseArea()) 

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤใLำฆLำฆฟ
//ณ Abertura do Arquivo em EXCEL. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤใLำฆLำฆู
*/
	
If mv_par03 == 1  
	DefCabecalho()
	//DlgToExcel({ {"ARRAY","Hardware Avulso", _aCabec, _aDados} }) 
	processa({||DlgToExcel({ {"ARRAY","Hardware Avulso", aCabec,_aDados} }) }, "Exp. Hardware Avulso","Aguarde, exportando para Excel...",.T.)

EndIf



/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFinaliza a execucao do relatorio...   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

SET DEVICE TO SCREEN


/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe impressao em disco, chama o gerenciador de impressao...   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/

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
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusteSX1 บAutor  ณRene Lopes          บ Data ณ  19/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function AjustaSX1()

Local aArea := GetArea()

PutSx1(cPerg,"01","Dt. Faturamento De         ","Dt. Faturamento De        ","Dt. Faturamento De         ","mv_ch1","D",08,00,01,"G","","   ","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Inicial a ser considerada"})
PutSx1(cPerg,"02","Dt. Faturamento Ate        ","Dt. Faturamento Ate       ","Dt. Faturamento Ate         ","mv_ch2","D",08,00,01,"G","","   ","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Data Final a ser considerada"})
PutSx1(cPerg,"03","Excel			 ","Excel              ","Excel             ","mv_chA","N",01,00,01,"C","",""   ,"","","mv_par03","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","","","","","",{"Criar arquivo Exce"})

RestArea(aArea)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusteSX1 บAutor  ณRene Lopes          บ Data ณ  19/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function DefCabecalho()


Aadd(aCabecFixo,"Pedido") 	
Aadd(aCabecFixo,"Cod_Cliente")
Aadd(aCabecFixo,"Nome") 
Aadd(aCabecFixo,"Dt_Pedido") 
Aadd(aCabecFixo,"Cod_Posto") 
Aadd(aCabecFixo,"Nome")	
Aadd(aCabecFixo,"Desc_Ar")	
Aadd(aCabecFixo,"Produto")
Aadd(aCabecFixo,"Descr_Prod")
Aadd(aCabecFixo,"Quantidade") 
Aadd(aCabecFixo,"Preco_Unit")
Aadd(aCabecFixo,"Preco_Total")
Aadd(aCabecFixo,"Ped_Site") 
Aadd(aCabecFixo,"TES") 		
Aadd(aCabecFixo,"Dt_Faturamento")
Aadd(aCabecFixo,"Status")                           

aCabec:= aCabecFixo
aeval(aCabecAC2,{|x|aadd(aCabec,x)})

nTamCabec := len(aCabec)

Return()