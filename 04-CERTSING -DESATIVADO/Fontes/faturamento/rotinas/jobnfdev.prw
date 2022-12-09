#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
---------------------------------------------------------------------------
| Rotina    | JOBNFDEV    | Autor | Gustavo Prudente | Data | 13.09.2013  |
|-------------------------------------------------------------------------|
| Descricao | Gera notas fiscais de devolucao para produtos com saldo na  |
|           | tabela SB6 e movimentos na SZ5.                             |
|-------------------------------------------------------------------------|
| Parametros| EXPA1 - aParSch[ 1 ] - Codigo da empresa.                   |
|           |         aParSch[ 2 ] - Codigo da filial.                    |
|-------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                         |
---------------------------------------------------------------------------
*/
User Function JOBNFDEV( aParSch )

Local lJob 		:= ( Select( "SX6" ) == 0 )
Local nX		:= 0
Local nQtdItem	:= 0
Local nTamDoc 	:= 0
Local nTamProd	:= 0
Local nPos		:= 0

Local cFornece  := ""
Local cLoja		:= ""
Local cSerie	:= ""
Local cTpNrNfs	:= ""
Local cTesDev	:= ""
Local cTipoNF	:= ""
Local cEspecie	:= ""
Local cNumDev	:= ""
Local cGetID	:= ""
Local cWhereTES := ""
Local cPosto	:= ""
Local cPedProt	:= ""
Local cEmpOld	:= ""
Local cFilOld	:= ""
Local cFilRet	:= ""
Local lFatFil	:= .F.
Local cEstFilFat:= ""
Local cJobEmp	:= aParSch[ 1 ]
Local cJobFil	:= aParSch[ 2 ]
Local cquery    :=' '
Local aItensDev	:= {}
Local aCabec	:= {}
Local aItens	:= {}
Local aArea		:= GetArea()
Local cPedSite	:= ""
Local cPedGAR	:= ""
Local Ny
Local Nx
Local __aRetNF  := {}

Local	cDir := GetSrvProfString("Startpath","")

Local cMV_MAILNFD := 'MV_MAILNFD'
Local cAnexo := ''

Private lMsErroAuto := .F.	// Controla erro retorno rotina

If lJob
	RpcSetType( 3 )
	RpcSetEnv( cJobEmp, cJobFil )
EndIf

nTamDoc	 := TamSX3( "F1_DOC" )[ 1 ]
nTamProd := TamSX3( "B1_COD" )[ 1 ]

cFilSF4	 := xFilial( "SF4" )

cForLoja := getmv("MV_XFORDEV",, "") //SuperGetMV( "MV_XFORDEV",, ""     )		// Informar o fornecedor + loja que deve realizar o processamento
nDias	 := getmv("MV_XDIADEV",, 1) //SuperGetMV( "MV_XDIADEV",, 1      )		// Numero de dias que deve retroceder a database
cTesNFS  := getmv( "MV_XTESNFS",, "611"  )		// Tes utilizada para geracao da selecao de itens da NF de Saida

cTesNFS  := FormatIn( cTesNFS, "/" )

// Se nao informar o fornecedor no parametro, processa todos os fornecedores
If Empty( cForLoja )
	cCondSZ8 := " "
Else                     

	cCondSZ8 := "SZ8.Z8_FORNEC || SZ8.Z8_LOJA = '" + AllTrim( cForLoja ) + "' AND"
	//cCondSZ8 := "SZ8.Z8_FORNEC || SZ8.Z8_LOJA IN" + AllTrim( cForLoja ) + " AND"
EndIf

cDataIni := '20170101' //DtoS(Date() - nDias )
cDataFim := DtoS(Date())

cCondSZ8 := "%" + cCondSZ8 + "%"

// Formata TES de saida para selecao da SB6
If At( ",", cTesNFS ) > 0
		cWhereTES := "SB6.B6_TES IN " + cTesNFS
Else
		cTesNFS   := StrTran( cTesNFS, "(", "" )
		cTesNFS   := StrTran( cTesNFS, ")", "" )
		cWhereTES := "SB6.B6_TES = " + cTesNFS
EndIf
		
cWhereTES := "%" + cWhereTES + "%"


If Select("TRBSZ5")>0
		TRBSZ5->( dbCloseArea() )
Endif

BeginSql Alias "TRBSZ5"

SELECT DISTINCT 
       SZ5.R_E_C_N_O_ AS RECSZ5, 
       SZ8.Z8_FORNEC  AS FORNEC , SZ8.Z8_LOJA   AS LOJA  , SZ8.Z8_DESC DESCPONDIS, SZ8.Z8_COD     AS PONDIS,
       SZ5.Z5_PRODGAR AS PRODGAR, SZ5.Z5_PEDGAR AS PEDGAR, SZ5.Z5_PEDIDO AS PEDIDO, SZ5.Z5_PEDSITE AS PEDSIT, 
       SZ5.Z5_CODPOS AS CODPOS, SZ5.Z5_DESPOS AS DESPOS, SZ5.Z5_REDE AS REDE,
       SZ5.Z5_PROCRET AS PROCRET,  SZ5.Z5_TIPVOU AS TIPVOUVHER, SZ5.Z5_CODVOU AS CODVOUCHER, 
       SZ5.Z5_PRODUTO AS HARDAVULSO,
       SB1.B1_COD AS CODMIDIA, SB1.B1_DESC AS DESCMIDIA, SG1.G1_QUANT AS QTDMIDIA, SZ5.Z5_TIPO SITUACAO_PED, 
       SZ5.Z5_EMISSAO DATREG, SZ5.Z5_DATVAL DATVAL, SZ5.Z5_DATVER DATVER, SZ5.Z5_DATEMIS DATEMIS, 
       SZ3.Z3_CODENT CODENT, SZ5.Z5_NFDEV NF_RETORNO_TERCEIRO
FROM 
	%Table:SZ5% SZ5
	LEFT JOIN 	%Table:SZ3% SZ3 ON
	    SZ3.Z3_FILIAL = %xFilial:SZ3%  AND
	    SZ3.Z3_CODGAR = SZ5.Z5_CODPOS AND
	    SZ3.Z3_CODGAR > ' ' AND                                                                                          
	    SZ3.Z3_TIPENT = '4' AND
	    SZ3.D_E_L_E_T_<>'*'
	LEFT JOIN 	%Table:SZ8% SZ8 ON
	    SZ8.Z8_FILIAL = %xFilial:SZ8% AND
   		SZ8.Z8_COD = SZ3.Z3_PONDIS AND
	    SZ8.D_E_L_E_T_<>'*'
	INNER JOIN 	%Table:PA8%  PA8 ON 
        PA8.PA8_FILIAL=%xFilial:PA8% AND
        PA8.PA8_CODBPG=SZ5.Z5_PRODGAR AND
        PA8.D_E_L_E_T_<>'*'
    INNER JOIN 	%Table:SG1% SG1 ON
        SG1.G1_FILIAL='02' AND
        SG1.G1_COD=PA8.PA8_CODMP8 AND
        SG1.D_E_L_E_T_<>'*'
    INNER JOIN 	%Table:SB1% SB1 ON 
     	SB1.B1_FILIAL='02' AND
     	SB1.B1_COD=G1_COMP AND
     	SB1.B1_CATEGO='1' AND
     	SB1.D_E_L_E_T_<>'*'
WHERE
 
	SZ5.Z5_FILIAL  =  %xFilial:SZ5%  AND
	SZ5.Z5_DATVER  >= %Exp:cDataIni% AND
	SZ5.Z5_DATVER  <= %Exp:cDataFim% AND
	SZ5.Z5_PRODGAR >  ' ' AND
	SZ5.Z5_CODPOS  >  ' ' AND
    SZ5.Z5_PEDGAR  >  ' ' AND
    SZ5.Z5_PEDGANT =  ' ' AND
    SZ5.Z5_NFDEV   =  ' ' AND
    %Exp:cCondSZ8%  
    SZ5.D_E_L_E_T_<> '*' 

UNION
  
SELECT DISTINCT 
       SZ5.R_E_C_N_O_ AS RECSZ5, 
       SZ8.Z8_FORNEC  AS FORNEC , SZ8.Z8_LOJA   AS LOJA  , SZ8.Z8_DESC DESCPONDIS, SZ8.Z8_COD     AS PONDIS,
       SZ5.Z5_PRODGAR AS PRODGAR, SZ5.Z5_PEDGAR AS PEDGAR, SZ5.Z5_PEDIDO AS PEDIDO, SZ5.Z5_PEDSITE AS PEDSIT,
       SZ5.Z5_CODPOS AS CODPOS, SZ5.Z5_DESPOS AS DESPOS, SZ5.Z5_REDE AS REDE,
       SZ5.Z5_PROCRET AS PROCRET, SZ5.Z5_TIPVOU AS TIPVOUVHER, SZ5.Z5_CODVOU AS CODVOUCHER, 
       SZ5.Z5_PRODUTO AS HARDAVULSO,
       SB1.B1_COD AS CODMIDIA, SB1.B1_DESC AS DESCMIDIA, SC6.C6_QTDVEN AS QTDMIDIA , SZ5.Z5_TIPO SITUACAO_PED,
       SZ5.Z5_EMISSAO DATREG, SZ5.Z5_DATVAL DATVAL, SZ5.Z5_DATVER DATVER, SZ5.Z5_DATEMIS DATEMIS, 
       SZ3.Z3_CODENT CODENT, SZ5.Z5_NFDEV NF_RETORNO_TERCEIRO
FROM
 	 %Table:SZ5% SZ5
	 LEFT JOIN 	%Table:SZ3% SZ3 ON
	     SZ3.Z3_FILIAL = %xFilial:SZ3%  AND
	     SZ3.Z3_CODGAR = SZ5.Z5_CODPOS AND
	     SZ3.Z3_CODGAR > ' ' AND                                                                                          
	     SZ3.Z3_TIPENT = '4' AND
	     SZ3.D_E_L_E_T_<>'*'
	 LEFT JOIN 	%Table:SZ8% SZ8 ON
	     SZ8.Z8_FILIAL = %xFilial:SZ8% AND
	   	 SZ8.Z8_COD = SZ3.Z3_PONDIS AND
	     SZ8.D_E_L_E_T_<>'*'
	 LEFT JOIN 	%Table:SB1% SB1 ON 
	     SB1.B1_FILIAL='02' AND
	     SB1.B1_COD=SZ5.Z5_PRODUTO AND
	     SB1.B1_CATEGO='1' AND
	     SB1.D_E_L_E_T_<>'*'
	 LEFT JOIN 	%Table:SC6% SC6 ON 
	     SC6.C6_FILIAL=%xFilial:SC6% AND
	     SC6.C6_NUM=SZ5.Z5_PEDIDO AND
	     SC6.C6_ITEM=SZ5.Z5_ITEMPV AND
	     SC6.D_E_L_E_T_<>'*'
WHERE
     SZ5.Z5_FILIAL  =  %xFilial:SZ5%  AND
     SZ5.Z5_EMISSAO >= %Exp:cDataIni%  AND
     SZ5.Z5_EMISSAO <= %Exp:cDataFim%  AND
     SZ5.Z5_PEDGAR  =  ' ' AND
     SZ5.Z5_PRODUTO >  ' ' AND
     SZ5.Z5_CODPOS  >  ' ' AND
     SZ5.Z5_TIPO    =  'ENTHAR' AND
	 SZ5.Z5_NFDEV   =  ' ' AND
	 %Exp:cCondSZ8%
     SZ5.D_E_L_E_T_ <>'*' 

ORDER BY  FORNEC, LOJA, CODMIDIA
 

	
EndSql
//Equanto não for final de arquivo

//Identificar o código do Fornecedor
//Identiticar o Saldo por mídia em poder deste fornecedor e armazenar em um vetor

		//	Produto, Serie+nota+item de origem, saldo, Quantidade a retornar,{}Rencos SZ5
		// 			  MR01001, SP200000000101, 100, 0, {}
		//  		  MR02001, SP200000000201, 100, 0, {}
		   
// Equanto  for este código de fornecedor popular a posição 4 somando 1 acada recno da sz5 adcinada na ultima posição do Vetor:

//    MR01001, SP200000000101, 100, 5, 123451
//                                     123452 
//                                     123453           
//                                     123455
//                                     123456
//    MR02001, SP200000000201, 100, 3, 123451
//                                     123452
//                                     123453
//
// Quando mudar o fornecedor então fazer a leitura do Array para composição dos vetores de cabeçalho e itens utilizados no execauto de documento de entrada
    
cquery      := getlastquery()[2]       
aRTerceiros := {} //Array de                
aItensDev	:= {} //Array de análise de itens a devolver.
aItens      := {} //Array de itens a devolver para nota fiscal de entrada. Utilizado no Execauto
aCabec		:= {} //Array com dados do fornecedor para cabeçalho da noto fiscal de entrada. Utilizado no Execauto

cFornece 	:= " " //Código do Fornecedor
cLoja	 	:= " " //Loja do Fornecedor
cPonDis		:= " " //Código do ponto de distribuição

cGetID  	:=GetIDNFD()

cArqlogFalha:= "NFRETORNOFALHA"+cGetID+".CSV" //Array de log de falhas no processo de apuração do retorno
nHdlFalha   :=0    //Numero do controlo do aquivo de log de falhas


Do While TRBSZ5->( ! EoF() )
	//Se mudar o fornecedor atualiza o Array Base de Geração da Nota de retorno e atualização dos Recnos na Sz5
	IF cFornece+cLoja<>TRBSZ5->FORNEC+TRBSZ5->LOJA .AND. !EMPTY(TRBSZ5->PONDIS)
	
	 	If !Empty(cFornece)
		   //Guarda Array para Geração da nota
		   aItensDev := aSort(aItensDev,,,{|x,y| x[12]+x[1]+X[11] < y[12]+y[1]+y[11]})
		   AAdd(aRTerceiros,{cFornece, cLoja, cPonDis, aItensDev})
		   aItensDev:={}
	    Endif
	    //Inicializa as variáveis para novo Ciclo
		
		cFornece 	:= TRBSZ5->FORNEC
		cLoja	 	:= TRBSZ5->LOJA
		cPonDis     := TRBSZ5->PONDIS
		cProduto    := ""
		
		
		//Trata o Laço do Fornecedor
		While TRBSZ5->( ! EoF() ) .and. cFornece+cLoja==TRBSZ5->FORNEC+TRBSZ5->LOJA 
		   
			If cProduto<>TRBSZ5->CODMIDIA
				cProduto    := TRBSZ5->CODMIDIA
				// Seleciona saldos em poder de terceiros do fornecedor e Adcinoa registros no vetor para este produto
				If Select("TRBSB6")>0
						TRBSB6->( dbCloseArea() )
				Endif

				BeginSql Alias "TRBSB6"
					
					SELECT	SB6.B6_EMISSAO EMISSAO, SB6.B6_FILIAL AS FILIAL, SB6.B6_PRODUTO AS PRODUTO, SB6.B6_DOC    AS DOC   , SB6.B6_SERIE AS SERIE, SB6.B6_SALDO AS SALDO,
					SD2.D2_NUMSEQ  AS NUMSEQ , SD2.D2_PRCVEN AS PRCVEN, SD2.D2_ITEM  AS ITEM , SF4.F4_TESDV AS TESDV
					FROM 	%Table:SB6% SB6
					INNER JOIN %Table:SF4% SF4 ON
					SF4.F4_FILIAL = %xFilial:SF4% AND
					SF4.F4_CODIGO = SB6.B6_TES AND
					SF4.F4_TESDV > ' ' AND
					SF4.%notDel%
					INNER JOIN %Table:SD2% SD2 ON
					SD2.D2_FILIAL = SB6.B6_FILIAL AND
					SD2.D2_NUMSEQ = SB6.B6_IDENT AND
					SD2.%notDel%
					WHERE
					SB6.B6_FILIAL BETWEEN '  ' AND 'ZZ' AND
//					SB6.B6_FILIAL BETWEEN '02' AND '02' AND
					SB6.B6_CLIFOR = %Exp:cFornece% AND
					SB6.B6_LOJA   = %Exp:cLoja% AND
					SB6.B6_TPCF   = 'F' AND
					SB6.B6_SALDO  > 0 AND
					%Exp:cWhereTES% AND  
					SB6.B6_PRODUTO=%Exp:cProduto% AND
					SB6.%notDel%
					ORDER BY SB6.B6_EMISSAO, SB6.B6_PRODUTO, SB6.B6_FILIAL 
					
				EndSql
				cquery2      := getlastquery()[2]  
				//Distribui as validações do produto de acordo com o saldo em aberto das notas de remessa.
				If TRBSB6->( !EoF() )
					While TRBSB6->( ! EoF() )
				       //Adciona mais um elemento no ventor
					   TRBSB6->(AADD(aItensDev, {PRODUTO,DOC,SERIE,ITEM,TESDV,NUMSEQ,PRCVEN,SALDO,0,{},FILIAL, EMISSAO,{} } )) 
			           //Trata o Laço do produto
				       While TRBSZ5->( ! EoF() );
				       		 .and. cFornece+cLoja+cProduto==TRBSZ5->FORNEC+TRBSZ5->LOJA+TRBSZ5->CODMIDIA; //Mesmo fornecedor
				       		 .and. aItensDev[len(aItensDev),9]<aItensDev[len(aItensDev),8] //e quantidade validade menor que o saldo a da nota
                        	
 							//Adiciona ao vetor de retorno(dev) somente se a SOMA entre "quantidade atual do vetor" e a "quantidade entregue de mídias" for
 							//Menor que o saldo da nota para este produto. Isso acontece somente com entregas de mídias avulsas.
		                    If aItensDev[len(aItensDev),9] + TRBSZ5->QTDMIDIA <=aItensDev[len(aItensDev),8] 
		                    	AADD(aItensDev[len(aItensDev),10], TRBSZ5->RECSZ5)  //Incrementa o Renco da tabela Sz5 na utima coluna da ultima lina do vetor que será utilizado futuramente para gravar o numero do anota na SZ5
		                    	AADD(aItensDev[len(aItensDev),13], TRBSZ5->QTDMIDIA)
		                        aItensDev[len(aItensDev),9] += TRBSZ5->QTDMIDIA  //Atualiza a quantidade a ser devolvida do produto
		                    Else
		                    	//Não será tratada esta exceção. As quantidades exedentes serão tratadas em outro processamento.     
				            Endif
			            	TRBSZ5->(DbSkip())
			           End
			           TRBSB6->(DbSkip())                         
					End
				Else
				       
					AADD(aItensDev, {cProduto,"NF NAO ENCONTRADA","NÃO EXISTE SALDO EM PODER DE TERCEIROS","","","",0,0,0,{},"","",{}})
									
				    While TRBSZ5->( ! EoF() );
				    	 .and. cFornece+cLoja+cProduto==TRBSZ5->FORNEC+TRBSZ5->LOJA+TRBSZ5->CODMIDIA; //Mesmo fornecedor
			   	
				   	              aItensDev[len(aItensDev),9] += TRBSZ5->QTDMIDIA //Atualiza a apenas a quantidade que deveria ser devolvida.
			           
			          	TRBSZ5->(DbSkip())
			        End

				Endif
				
				TRBSB6->( dbCloseArea() )

				Loop 
			
			EndIf

			TRBSZ5->(DbSkip())

	     Enddo       
	     
	   Loop

    Else
    	If nHdlFalha==0
			nHdlFalha:=fCreate(cArqLogFalha)

	  		cLinha:= "RECSZ5;" 
	    	cLinha+= "FORNEC;" 
	    	cLinha+= "LOJA;"
	    	cLinha+= "DESCPONDIS;"
	    	cLinha+= "PONDIS;"
	    	cLinha+= "PRODGAR;"
	    	cLinha+= "PEDGAR;"
	    	cLinha+= "PEDIDO;"
	    	cLinha+= "CODPOS;"
	    	cLinha+= "DESPOS;"
	    	cLinha+= "REDE;"
	    	cLinha+= "PROCRET;"
	    	cLinha+= "TIPVOUVHER;"
	    	cLinha+= "CODVOUCHER;"
	    	cLinha+= "HARDAVULSO;"
	    	cLinha+= "CODMIDIA;"
	    	cLinha+= "DESCMIDIA;"
     		cLinha+= "QTDMIDIA;"
     		cLinha+= "SITUACAO_PED;"
     		cLinha+= "DATREG;"
     		cLinha+= "DATVAL;"
     		cLinha+= "DATVER;"
     		cLinha+= "DATEMIS;" 
      		cLinha+= "CODENT;"
      		cLinha+= "NF_RETORNO_TERCEIRO"
      		cLinha+= CRLF
			fWrite(nHdlFalha,cLinha )
       EndIf 
       
	  		cLinha:= STR(TRBSZ5->RECSZ5)+";" 
	    	cLinha+= TRBSZ5->FORNEC+";" 
	    	cLinha+= TRBSZ5->LOJA+";"
	    	cLinha+= TRBSZ5->DESCPONDIS+";"
	    	cLinha+= TRBSZ5->PONDIS+";"
	    	cLinha+= TRBSZ5->PRODGAR+";"
	    	cLinha+= TRBSZ5->PEDGAR+";"
	    	cLinha+= TRBSZ5->PEDIDO+";"
	    	cLinha+= TRBSZ5->CODPOS+";"
	    	cLinha+= TRBSZ5->DESPOS+";"
	    	cLinha+= TRBSZ5->REDE+";"
	    	cLinha+= TRBSZ5->PROCRET+";"
	    	cLinha+= TRBSZ5->TIPVOUVHER+";"
	    	cLinha+= TRBSZ5->CODVOUCHER+";"
	    	cLinha+= TRBSZ5->HARDAVULSO+";"
	    	cLinha+= TRBSZ5->CODMIDIA+";"
	    	cLinha+= TRBSZ5->DESCMIDIA+";"
     		cLinha+= Transform(TRBSZ5->QTDMIDIA,"@E 999,999.99")+";"
     		cLinha+= TRBSZ5->SITUACAO_PED+";"
     		cLinha+= TRBSZ5->DATREG+";"
     		cLinha+= TRBSZ5->DATVAL+";"
     		cLinha+= TRBSZ5->DATVER+";"
     		cLinha+= TRBSZ5->DATEMIS+";" 
      		cLinha+= TRBSZ5->CODENT+";"
      		cLinha+= TRBSZ5->NF_RETORNO_TERCEIRO
      		cLinha+= CRLF

        If nHdlFalha>0
			fWrite(nHdlFalha,cLinha )
        Endif

		TRBSZ5->(DbSkip())
	
	Endif
	
EndDo	
IF cFornece+cLoja<>TRBSZ5->FORNEC+TRBSZ5->LOJA 
	
	 	If !Empty(cFornece)
		   //Guarda Array para Geração da nota
		   aItensDev := aSort(aItensDev,,,{|x,y| x[1]+x[12]+x[11] < y[1]+y[12]+y[11] })
		   AAdd(aRTerceiros,{cFornece, cLoja, cPonDis, aItensDev})
		   aItensDev:={}
	    Endif
Endif	    //Inicializa as variáveis para novo Ciclo

If nHdlFalha>0
	fClose(cArqLogFalha)
Endif


TRBSZ5->( dbCloseArea() )
    
cFornece:="" 
cLoja   :=""
cPonDis :=""
cProduto:=""
cDocOrig:=""
cSerOrig:=""
cIteOrig:=""
cIdentB6:=""
nPrecRem:=0 
nSaldRem:=0
nQtdItem:=0
cArqLog :=""                                    
cMsg	:=""
cLinha	:=""
cArqLog :="NFRETORNO"+cGetID+".CSV"                                    
cMsg	:=""           
nHdl    :=0
nHdl:=fCreate(cArqLog)

    
cLinha:= "FORNECEDOR;"
cLinha+= "LOJA;"
cLinha+= "PD;"
cLinha+= "GETID;"
cLinha+= "PRODUTO;"
cLinha+= "DOCORIG;"
cLinha+= "SERIORI;"
cLinha+= "ITEMORIG;"
cLinha+= "IDENTB6;"
cLinha+= "QTDITEM;"
cLinha+= "SALDREM;"
cLinha+= "PRCREM;"
cLinha+= "NFRETORNO" 
cLinha+= CRLF

If nHdl>0
	fWrite(nHdl,cLinha )
Endif

cFilOld		:= cFilAnt
//Le p Array com os movimentos que devem ser realizados	                      
For ni:=1 to len(aRTerceiros) 	
    
    cFornece:= aRTerceiros[ni,1]
    cLoja   := AllTrim( aRTerceiros[ni,2])
    cPonDis := AllTrim( aRTerceiros[ni,3])
   // cPosto	:= AllTrim( aRTerceiros[ni,5])
 	cProduto:="--"
	cDocOrig:="--"
	cSerOrig:="--"
	cIteOrig:="--"
	cIdentB6:="--"
	nPrecRem:=0 
	nQtdItem:=0
    nSaldRem:=0


	U_GTPutIN( cGetID, "T", "", .T., { "JOBNFDEV",cPonDis, "Inicio da geração de NF de Devolução", "Fornecedor: " +cFornece + "/" + cLoja, "Ponto Distribuição: " + cPonDis } )
	
	    
	cLinha:= cFornece 	+";"
	cLinha+= cLoja		+";"
	cLinha+= cPondis	+";"
	cLinha+= cGetId		+";"
	cLinha+= cProduto	+";"
	cLinha+= cDocOrig	+";"
	cLinha+= cSerOrig	+";"
	cLinha+= cIteOrig	+";"
	cLinha+= cIdentB6	+";"
	cLinha+= Transform(nQtdItem,"@E 999,999.99")	+";"
	cLinha+= Transform(nSaldRem,"@E 999,999.99")	+";"
	cLinha+= Transform(nPrecRem,"@E 999,999.99")	+";"
	cLinha+= " " 
	cLinha+= CRLF

	If nHdl>0
		fWrite(nHdl,cLinha )
    Endif
	
	
	aCabec  := {}
	aItens  := {}
	aLinha  := {}
	 
	IF  len(aRTerceiros[ni,4])>0 
	
		cFilRET		:= iif(empty(aRTerceiros[ni,4,1,11]),cFilOld,aRTerceiros[ni,4,1,11] )
		If cFilRet <> cFilAnt
			STATICCALL( VNDA190, FATFIL, nil, cFilRet )
		EndIf                                  
		
		DdataBase	:= date()
     	//carrega parâmetros para filial posicionada
		cSerie	 := GetMV( "MV_XSERDEV",, "2"    )		// Serie da NF de Entrada - retorno terceiros
		cTpNrNfs := GetMV( "MV_TPNRNFS",, "2"    )    	// Serie da NF de Saida (param. para numeracao autom.)
		cTesDev	 := SuperGetMV( "MV_XTESDEV",, "008"  )		// Tes utilizado para devolucao de poder de terceiro
		cTipoNF  := SuperGetMV( "MV_XTPDEVO",, "N"    )		// Tipo de documento de entrada referente a devolucao
		cEspecie := SuperGetMV( "MV_XESPECI",, "SPED" )		// Especie na nota fiscal de entrada, referente a devolucao

				
		AAdd( aCabec, { "F1_DOC"    , ""		, Nil } )	// Numero da NF
		AAdd( aCabec, { "F1_SERIE"  , cSerie	, Nil } )	// Serie da NF
		AAdd( aCabec, { "F1_FORMUL" , "S"		, Nil } )  	// Formulario proprio
		AAdd( aCabec, { "F1_EMISSAO", Date()	, Nil } )  	// Data emissao
		AAdd( aCabec, { "F1_FORNECE", cFornece	, Nil } )	// Codigo do Fornecedor
		AAdd( aCabec, { "F1_LOJA"   , cLoja 	, Nil } )	// Loja do Fornecedor
		AAdd( aCabec, { "F1_TIPO"   , cTipoNF	, Nil } )	// Tipo da NF
		AAdd( aCabec, { "F1_ESPECIE", cEspecie	, Nil } )	// Especie da NF
		
		aRecSz5 :={}  //Guarda os Recnos que serão atualizados
			
		For ny:=1 to len(aRTerceiros[ni,4])
		    
		    If cFilRet <> aRTerceiros[ni,4,ny,11]
				
		    	If nY > 1
		    		CriaNf(@aCabec,@aItens,@cNumDev,@cSerie,@cTpNrNfs,@nTamDoc,@cGetID,@cFornece,@cLoja,@cPonDis,@aRecSz5,cTipoNF,cEspecie)
		    		aItens  := {}
		    		aLinha  := {}
		    		aRecSZ5 := {}                  
					    		
					cLinha:= cFornece 	+";"
					cLinha+= cLoja		+";"
					cLinha+= cPondis	+";"
					cLinha+= cGetId		+";"
					cLinha+= "--;"
					cLinha+= "--;"
					cLinha+= "--;"
					cLinha+= "--;"
					cLinha+= "--;"
					cLinha+= ";"
					cLinha+= ";"
					cLinha+= ";"
					cLinha+= cSerie + cNumDev 
					cLinha+= CRLF
					cNumDev	:= ""
					
					If nHdl>0
						fWrite(nHdl,cLinha )
					Endif	
			
		   		EndIf
		    	
		    	cFilRet		:= iif(empty(aRTerceiros[ni,4,ny,11]),cFilOld,aRTerceiros[ni,4,ny,11] )
		    	STATICCALL( VNDA190, FATFIL, nil, cFilRet )
		    	
				cSerie	 := GetMV( "MV_XSERDEV",, "2"    )		// Serie da NF de Entrada - retorno terceiros
				cTpNrNfs := GetMV( "MV_TPNRNFS",, "2"    )    	// Serie da NF de Saida (param. para numeracao autom.)
				cTesDev	 := SuperGetMV( "MV_XTESDEV",, "008"  )		// Tes utilizado para devolucao de poder de terceiro
				cTipoNF  := SuperGetMV( "MV_XTPDEVO",, "N"    )		// Tipo de documento de entrada referente a devolucao
				cEspecie := SuperGetMV( "MV_XESPECI",, "SPED" )		// Especie na nota fiscal de entrada, referente a devolucao
		
				aCabec := {}		
				AAdd( aCabec, { "F1_DOC"    , ""		, Nil } )	// Numero da NF
				AAdd( aCabec, { "F1_SERIE"  , cSerie	, Nil } )	// Serie da NF
				AAdd( aCabec, { "F1_FORMUL" , "S"		, Nil } )  	// Formulario proprio
				AAdd( aCabec, { "F1_EMISSAO", Date()	, Nil } )  	// Data emissao
				AAdd( aCabec, { "F1_FORNECE", cFornece	, Nil } )	// Codigo do Fornecedor
				AAdd( aCabec, { "F1_LOJA"   , cLoja 	, Nil } )	// Loja do Fornecedor
				AAdd( aCabec, { "F1_TIPO"   , cTipoNF	, Nil } )	// Tipo da NF
				AAdd( aCabec, { "F1_ESPECIE", cEspecie	, Nil } )	// Especie da NF
		    
		    Endif  
		    
		    cProduto:=aRTerceiros[ni,4,ny,1]
		    cDocOrig:=aRTerceiros[ni,4,ny,2] 
		    cSerOrig:=aRTerceiros[ni,4,ny,3] 
		    cIteOrig:=aRTerceiros[ni,4,ny,4]
		    cTesDev :=aRTerceiros[ni,4,ny,5]                            
			cIdentB6:=aRTerceiros[ni,4,ny,6]
		    nPrecRem:=aRTerceiros[ni,4,ny,7]
			nSaldRem:=aRTerceiros[ni,4,ny,8]
		    nQtdItem:=aRTerceiros[ni,4,ny,9]
		    //Será realizado o retorno automático somente os que tem Itens Validados e Saldo de Remessa na nota fiscal.
			//Este tratamento é necessário porque existem produtos que foram validados e não existe saldo de nota para retorno.
		    If nQtdItem>0 .and. nSaldRem>0
			    
				AAdd( aLinha, { "D1_DOC"     , ""						, Nil } )
				AAdd( aLinha, { "D1_SERIE"   , cSerie					, Nil } )
				AAdd( aLinha, { "D1_FORNECE" , cFornece					, Nil } )
				AAdd( aLinha, { "D1_LOJA"    , cLoja   					, Nil } )
				AAdd( aLinha, { "D1_COD"     , cProduto					, Nil } )
				AAdd( aLinha, { "D1_TES"	 , cTesDev				 	, Nil } )
				AAdd( aLinha, { "D1_IDENTB6" , cIdentB6			  		, Nil } )
				AAdd( aLinha, { "D1_SERIORI" , cSerOrig					, Nil } )
				AAdd( aLinha, { "D1_NFORI"	 , cDocOrig					, Nil } )
				AAdd( aLinha, { "D1_ITEMORI" , cIteOrig		         	, Nil } )
				AAdd( aLinha, { "D1_QUANT"	 , nQtdItem					, Nil } )
				AAdd( aLinha, { "D1_VUNIT"	 , nPrecRem					, Nil } )
				AAdd( aLinha, { "D1_TOTAL"	 , nQtdItem * nPrecRem		, Nil } )
								
				AAdd( aItens, aLinha )
				AAdd( aRecSZ5,{aRTerceiros[ni,4,ny,10],cSerie,cFornece,cLoja,cProduto,cTesDev,cIdentB6,cSerOrig,cDocOrig,aRTerceiros[ni,4,ny,11],cIteOrig,aRTerceiros[ni,4,ny,13],nPrecRem})
				aLinha := {}
			Endif
			
			cLinha:= cFornece 	+";"
			cLinha+= cLoja		+";"
			cLinha+= cPondis	+";"
			cLinha+= cGetId		+";"
			cLinha+= cProduto	+";"
			cLinha+= cDocOrig	+";"
			cLinha+= cSerOrig	+";"
			cLinha+= cIteOrig	+";"
			cLinha+= cIdentB6	+";"
			cLinha+= Transform(nQtdItem,"@E 999,999.99")	+";"
			cLinha+= Transform(nSaldRem,"@E 999,999.99")	+";"
			cLinha+= Transform(nPrecRem,"@E 999,999.99")	+";"
			cLinha+= " " 
			cLinha+= CRLF
			If nHdl>0
				fWrite(nHdl,cLinha )
			Endif
			
		Next
		
		CriaNf(@aCabec,@aItens,@cNumDev,@cSerie,@cTpNrNfs,@nTamDoc,@cGetID,@cFornece,@cLoja,@cPonDis,@aRecSz5,cTipoNF,cEspecie)
		aItens  := {}
		aLinha  := {}
		aRecSZ5 := {}                  
			
		If cFilRet <> aRTerceiros[ni,4,len(aRTerceiros[ni,4]),11]
			cFilRet		:= iif(empty(aRTerceiros[ni,4,len(aRTerceiros[ni,4]),11]),cFilOld,aRTerceiros[ni,4,len(aRTerceiros[ni,4]),11] )
		    STATICCALL( VNDA190, FATFIL, nil, cFilRet )
	    Endif 
	
	Else
	
		cMsg:= "Não existe saldo para realizar retorno das mídias. Favor realizar análise do Ponto de distribuição"
	    
	   	U_GTPutOUT(cGetID, "T","",{"JOBNFDEV",{.F.,"E00001","",cMsg,"Fornecedor: " +cFornece + "/" + cLoja , "Ponto Distribuição: " + cPonDis}})
	    
	Endif                               
	
	cLinha:= cFornece 	+";"
	cLinha+= cLoja		+";"
	cLinha+= cPondis	+";"
	cLinha+= cGetId		+";"
	cLinha+= "--;"
	cLinha+= "--;"
	cLinha+= "--;"
	cLinha+= "--;"
	cLinha+= "--;"
	cLinha+= ";"
	cLinha+= ";"
	cLinha+= ";"
	cLinha+= cSerie + cNumDev 
	cLinha+= CRLF
	cNumDev	:= ""
	STATICCALL( VNDA190, FATFIL, nil, cFilOld )
	
	If nHdl>0
		fWrite(nHdl,cLinha )
	Endif	
Next

If nHdl>0
	fClose(nHdl)
Endif

//-----------------------------------------------------------------------------------------------------
// Enviar por e-mail os aquivos de log no formato CSV para os emails cadastrados no referido parâmetro.
//-----------------------------------------------------------------------------------------------------
If .NOT. GetMv( cMV_MAILNFD, .T. )
	CriarSX6( cMV_MAILNFD, 'C', 'EMAIL DAS PESSOAS QUE RECEBERAO OS ARQUIVOS DE LOG DA ROTINA JOBNFDEV.prw', 'estoque@certisign.com.br;fiscaltributario@certisign.com.br' )
Endif
  
//cMV_MAILNFD := "giovanni.rodrigues@certisign.com.br;vcoliveira@certisign.com.br;"
cMV_MAILNFD := GetMv( cMV_MAILNFD, .F. )

If .NOT. Empty( cMV_MAILNFD )
	If File( cArqLogFalha ) .AND. File( cArqLog )
		cAnexo := cDir + cArqLogFalha + "," + cDir + cArqLog
	Else
		If File( cArqLogFalha )
			cAnexo := cDir + cArqLogFalha
		Elseif File( cArqLog )
			cAnexo := cDir + cArqLog
		Else
			Conout('JOBNFDEV - DATA '+Dtoc(MsDate())+' HORA '+Time()+'. Não há anexo para enviar email.')
		Endif
   Endif
   
   If .NOT. Empty( cAnexo )
		FSSendMail( cMV_MAILNFD,;
      'ARQ. LOG DO PROCESSAMENTO.',;
      'ARQUIVOS CSV DE LOG DO PROCESSAMENTO DE INCONSISTÊNCIAS DE RETORNO - ROTINA JOBNFDEV - DATA '+Dtoc(MsDate())+' HORA '+Time()+'.',;
       cAnexo )
	Endif
Endif

Return
	


/*
----------------------------------------------------------------------------
| Rotina    | AtuMovSZ5   | Autor | Gustavo Prudente | Data | 19.09.2013   |
|--------------------------------------------------------------------------|
| Descricao | Atualiza os movimentos dos fornecedores dos postos de        |
|           | atendimento que tiveram NF de Devolucao gerada.              |
|--------------------------------------------------------------------------|
| Parametros| EXPA1 - Array com os dados de movimento da SZ5 e com os      |
|           |         produtos que foram usados na geracao da NF de Dev.   |
|           | EXPC2 - Fornecedor do processamento atual                    |
|           | EXPC3 - Loja do fornecedor                                   |
|           | EXPC4 - Numero da NF de Devolucao gerada                     |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/

Static Function AtuMovSZ5( cFornece,cLoja,cPonDis,aRecSz5, cNumDev, cSerie,cTipoNF,cEspecie )

Local nX 		:= 0
Local ny        := 0
For nx := 1 To Len( aRecSZ5 ) // Trata conjunto de recnos de cada produto
	
    FOR ny:=1 to len(aRecSZ5[nx,1])
		
		
		SZ5->( DbGoTo( aRecSZ5[nx,1,ny] ) )
		
		RecLock( "SZ5", .F. )
		SZ5->Z5_PROCRET := "S"
		SZ5->Z5_FORNECE := aRecSZ5[nx,3]
		SZ5->Z5_LOJA    := aRecSZ5[nx,4]
		SZ5->Z5_CODPD   := cPonDis
		SZ5->Z5_NFDEV   := cNumDev
	  
		SZ5->( MsUnLock() )
    
    	SZB->(RecLock( "SZB", .T. ))
		
		SZB->ZB_FILIAL	:= xFilial("SZB") 	
		SZB->ZB_TIPOMOV	:= "E"
		SZB->ZB_FILNF	:= aRecSZ5[nx,11]
		SZB->ZB_DOC		:= cNumDev
		SZB->ZB_SERIE	:= cSerie
		SZB->ZB_FORMUL	:= "S"
		SZB->ZB_EMISSAO	:= DDATABASE
		SZB->ZB_CLIFOR	:= aRecSZ5[nx,3]
		SZB->ZB_LOJA	:= aRecSZ5[nx,4]
		SZB->ZB_TIPO	:= cTipoNF
		SZB->ZB_ESPECIE	:= cEspecie
		SZB->ZB_PRODUTO	:= aRecSZ5[nx,5]
		SZB->ZB_TES		:= aRecSZ5[nx,6]
		SZB->ZB_IDENTB6	:= aRecSZ5[nx,7]
		SZB->ZB_SERIORI	:= aRecSZ5[nx,8]
		SZB->ZB_NFORI	:= aRecSZ5[nx,9]
		SZB->ZB_ITEMORI	:= aRecSZ5[nx,11]
		SZB->ZB_QUANT	:= aRecSZ5[nx,12,ny]
		SZB->ZB_VUNIT	:= aRecSZ5[nx,13]
		SZB->ZB_TOTAL	:= aRecSZ5[nx,12,ny]* aRecSZ5[nx,13]
		SZB->ZB_PD		:= cPonDis
		SZB->ZB_PEDGAR	:= SZ5->Z5_PEDGAR
		SZB->ZB_PEDSITE := SZ5->Z5_PEDSITE
		SZB->ZB_PENTREG	:= SZ5->Z5_CODPOS
		SZB->ZB_UFENTRE	:= SA2->(GetAdvFval("SA2", "A2_EST", xFilial("SA2")+aRecSZ5[nx,3]+aRecSZ5[nx,4],1," "))
		SZB->ZB_RECSZ5	:=aRecSZ5[nx,1,ny]
		
		SZB->( MsUnLock() ) 
			
    Next ny

Next nx

Return( .T. )


/*
----------------------------------------------------------------------------
| Rotina    | GetIDNFD    | Autor | Gustavo Prudente | Data | 02.10.2013   |
|--------------------------------------------------------------------------|
| Descricao | Gera ID para gravacao de Logs nas tabelas GTIN/GTOUT         |
|--------------------------------------------------------------------------|
| Uso       | Certisign Certificadora Digital S/A                          |
----------------------------------------------------------------------------
*/
Static Function GetIDNFD

Local cTime := ""
Local cDate := ""

cTime := SubStr( StrTran( Time(), ":", "" ), 1, 4 ) + AllTrim( Str( Int( Seconds() ) ) )
cDate := StrTran( DtoC( Date() ), "/", "" )

Return( cDate + cTime )

//
// Funcao para chamada do Remote
//
User Function EXEJOBNFD()
	U_JOBNFDEV( { "01", "02" } )
Return( .T. )                                                   
//Chamadas iniciando em pontos diversos da tabela
//para verificação de fornecedores com saldo não gerado.
//A chamada principal do JOB JOBNFDEV deve faturar todo os SZ5 ref. a Hw entregues
//--------------------------------------------------------------             
User Function CTRJOBNFD() // Controla a execução de JBNdf percorrendo a tabela SZ8
sz8->(dbsetorder(2))
sz8->(dbseek(xfilial("SZ8"), .t.))
while !sz8->(eof())
	putmv("MV_XFORDEV",alltrim(sz8->z8_fornec)+alltrim(sz8->z8_loja) )
	sleep(200)
	U_JOBNFDEV( { "01", "02" } )
	sz8->(dbskip())
end-while 
putmv("MV_XFORDEV","" )
Return( .T. ) 

//--------------------------------------------------------------             
User Function FRWJOBNFD() // Controla a execução de JBNdf percorrendo a tabela SZ8
sz8->(dbsetorder(2))
sz8->(dbgobottom())
while !sz8->(bof())
	putmv("MV_XFORDEV",alltrim(sz8->z8_fornec)+alltrim(sz8->z8_loja) )
	sleep(200)
	U_JOBNFDEV( { "01", "02" } )
	sz8->(dbskip(-1))
end-while 
putmv("MV_XFORDEV","" )
Return( .T. )

//--------------------------------------------------------

//--------------------------------------------------------------             
User Function RNGJOBNFD() // Emite um range de fornecedores
sz8->(dbsetorder(2))
sz8->(dbseek(xfilial("SZ8")+"111914", .t.))
while !sz8->(eof()) .and. sz8->z8_fornec <= "121180"
	putmv("MV_XFORDEV",alltrim(sz8->z8_fornec)+alltrim(sz8->z8_loja) )
	sleep(200)
	U_JOBNFDEV( { "01", "02" } )
	sz8->(dbskip())
end-while 
putmv("MV_XFORDEV","" )
Return( .T. )

Static Function CriaNf(aCabec,aItens,cNumDev,cSerie,cTpNrNfs,nTamDoc,cGetID,cFornece,cLoja,cPonDis,aRecSz5,cTipoNF,cEspecie)
	//Se foi possível montar os arrays de itens então efetua o retorno simbólico
	Local nX		:= 0
	Local __aRetNF  := {}
	Local SomenteLog:= GetMV( "MV_XLOGP3",, .F. ) 
	
	If Len( aItens )>0 .and. !SomenteLog
		
		// Atualiza numero de NF de Devolucao antes de chamar a rotina automatica
		Do While Empty( AllTrim( cNumDev ) )
			cNumDev	:= PadR( NxtSX5Nota( cSerie, .T., cTpNrNfs ), nTamDoc )
		EndDo
		// Atualiza arrays de cabecalho e item de devolucao com o numero da NF de Devolucao
		aCabec[ 1, 2 ] := cNumDev
				
		For nX := 1 To Len( aItens )
					aItens[ nX, 1, 2 ] := cNumDev
		Next nX
		lMsErroAuto:=.f.		
		MSExecAuto( { |x, y, z| MATA103( x, y, z ) }, aCabec, aItens, 3 ) // ExecAuto para emissao da NFe de Entrada retorno de terceiros
		
		If lMsErroAuto
		    mostraerro()
			cMsg := "Inconsistência ao gerar a NF de Devolução. "
		  	U_GTPutOUT(cGetID, "T","",{"JOBNFDEV",{.F.,"E00022","",cMsg,"Fornecedor: " +cFornece + "/" + cLoja , "Ponto Distribuição: " + cPonDis}})
			DisarmTransaction()
	    Else
	        // Atualiza dados dos registros de movimento do fornecedor na SZ5
			AtuMovSZ5( cFornece,cLoja,cPonDis,aRecSz5, cNumDev, cSerie,cTipoNF,cEspecie )
			
		
			sf1->(dbsetorder(1))
			sf1->(dbseek(xfilial("SF1") + cNumDev + Padr(alltrim(cSerie),3)+ cFornece + cLoja + cTipoNF ))    //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
			
			
			__aRetNF := {.t.,"","",""}
     		__aRetNF := u_TRANSMITENFE(cNumDev,Padr(alltrim(cSerie),3),"NF DEV",sf1->(recno()))

						
			cMsg :=  "NF de Devolucao gerada com sucesso: "+cNumDev + " - Transmissao: "+__aRetNF[4]

		   	U_GTPutOUT(cGetID, "T","",{"JOBNFDEV",{.F.,"M00001","",cMsg,"Fornecedor: " +cFornece + "/" + cLoja, "Ponto Distribuição: " + cPonDis}})
            
            
		Endif
		
	ElseIf SomenteLog
	
		cMsg:= "Processamento somente para gerar LOG de análise de movimentação. o Paramentro MV_XLOGP3 está definido como .T. "
	   	U_GTPutOUT(cGetID, "T","",{"JOBNFDEV",{.F.,"E00001","",cMsg,"Fornecedor: " +cFornece + "/" + cLoja , "Ponto Distribuição: " + cPonDis}})

	Else
	
		cMsg:= "Não existe saldo para realizar retorno das mídias. Favor realizar análise do Ponto de distribuição"
	   	U_GTPutOUT(cGetID, "T","",{"JOBNFDEV",{.F.,"E00001","",cMsg,"Fornecedor: " +cFornece + "/" + cLoja , "Ponto Distribuição: " + cPonDis}})

	Endif


Return
