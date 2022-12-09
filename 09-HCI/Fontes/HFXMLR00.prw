#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |HFXMLR01  � Autor � Roberto Souza      � Data �  18/05/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Relat�rio de compara��o de documentos fiscais de entrada   ���
���          � que n�o foi recepcionado o XML do Fornecedores.            ���
�������������������������������������������������������������������������͹��
���Uso       � IMPORTA XML                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function HFXMLR00


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Doctos Entrada x Xml"
Local cPict          := ""
Local titulo       := "Doctos Entrada x Xml"
Local nLin         := 6

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "HFXMLR00" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "HFXMLR00"
Private cString := "SF1"

dbSelectArea("SF1")
dbSetOrder(1)


AjustaSX1(cPerg)

Pergunte(cPerg,.T.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
if MV_PAR14 == 1
	titulo := "Doctos Entrada S/ Xml"
else
	titulo := "Xml S/ Doctos Entrada"
endif

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  18/05/12   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local Nx      := 0
Local nOrdem
Local cWhere  := ""
Local cOrder  := ""
Local cLinCab := ""     
Local cFilDe  := MV_PAR01
Local cFilAte := MV_PAR02
Local cDtIni  := DTos(MV_PAR03)
Local cDtFim  := DTos(MV_PAR04)
Local cSerIni := MV_PAR05
Local cSerFim := MV_PAR06
Local cNFIni  := MV_PAR07
Local cNFFim  := MV_PAR08   
Local cEspecP := MV_PAR09//"('SPED','CTE')"
Local cForIni := MV_PAR10
Local cForFim := MV_PAR11
Local cLojaIni:= MV_PAR12
Local cLojaFim:= MV_PAR13
Local aEspecP := Separa(cEspecP,",",.F.)
Local nCol    := 7
Local nIniLin := 6
Local aStatus := {}
Private cSF1      := GetNextAlias() 
Private cAliasXMl := GetNextAlias()
Private lSharedA1 := U_IsShared("SA1")
Private lSharedA2 := U_IsShared("SA2") 
Private nFormNfe  := Val(GetNewPar("XM_FORMNFE","6"))
Private nFormCTe  := Val(GetNewPar("XM_FORMCTE","6"))


//���������������������������������������������������������������������Ŀ
//� Monta massa de dados temporaria com informa��es de NF x XML.        �
//�����������������������������������������������������������������������
MsgRun(titulo,"Processando filtro...", {||U_XmlInfoX(cAliasXMl,.T.,"1") })

aadd( aStatus, {" ", " " } )
aadd( aStatus, {"A", "R.Carg" } )
aadd( aStatus, {"B", "Import" } )
aadd( aStatus, {"F", "Falha " } )
aadd( aStatus, {"N", "Doc-En" } )
aadd( aStatus, {"S", "Pre-Nt" } )
aadd( aStatus, {"X", "Cancel" } )
aadd( aStatus, {"Z", "Falha " } )

cLinCab:= "St.XML Especie     Serie   N. Fiscal       Emiss�o     Entrada       Valor Bruto"
//        "01234567890123456789012345678901234567890123456789012345679012345678901234567890"
//        "          1         2         3         4         5        6         7         8"
//DbSelectArea("ZBZ")
//DbSetOrder(6) 

DbSelectArea(cAliasXMl)
DbGoTop()
SetRegua(RecCount())

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
nLin := nIniLin

While (cAliasXMl)->(!EOF())
	cFilProc := (cAliasXMl)->F1_FILIAL
	@nLin,00 PSAY "Filial - "+(cAliasXMl)->F1_FILIAL
	nLin ++    
	
	While (cAliasXMl)->F1_FILIAL == cFilProc .And. (cAliasXMl)->(!EOF())
		
		lFirst := .F.
		nLin++

		cCodFor := (cAliasXMl)->F1_FORNECE+(cAliasXMl)->F1_LOJA       
	    @nLin,00 PSAY (cAliasXMl)->F1_FORNECE+"-"+(cAliasXMl)->F1_LOJA+" "+(cAliasXMl)->F1_NOME+" "+(cAliasXMl)->F1_CGC
		nLin++
	    @nLin,00 PSAY "Fone: " +(cAliasXMl)->F1_FONE
		@nLin,20 PSAY "E-mail: "+(cAliasXMl)->F1_EMAIL 
		nLin++

		@nLin,00 PSAY Replicate("-",80)
		nLin++  
		@nLin,00 PSAY cLinCab   
		nLin++    
		
		
	    While (cAliasXMl)->F1_FORNECE+(cAliasXMl)->F1_LOJA == cCodFor .And. (cAliasXMl)->(!EOF())
		   	//���������������������������������������������������������������������Ŀ
			//� Verifica o cancelamento pelo usuario...                             �
			//�����������������������������������������������������������������������
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			    Exit
			Endif
		   	//���������������������������������������������������������������������Ŀ
		   	//� Impressao do cabecalho do relatorio. . .                            �
		   	//�����������������������������������������������������������������������
		   	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      	nLin := nIniLin
		   	Endif
			
			cStatXml:= "" 
			if aScan( aStatus, {|x| x[1] = (cAliasXMl)->F1_STXML } ) > 0
				cStatXml:= aStatus[aScan( aStatus, {|x| x[1] = (cAliasXMl)->F1_STXML } )][2]
			endif
				   
		    @nLin,00        PSAY cStatXml
		    @nLin,nCol + 00 PSAY (cAliasXMl)->F1_ESPECIE
			@nLin,nCol + 12 PSAY (cAliasXMl)->F1_SERIE
		    @nLin,nCol + 20 PSAY (cAliasXMl)->F1_DOC
		    @nLin,nCol + 36 PSAY (cAliasXMl)->F1_EMISSAO
		    @nLin,nCol + 48 PSAY (cAliasXMl)->F1_DTDIGIT
		    @nLin,nCol + 60 PSAY Transform((cAliasXMl)->F1_VALBRUT,"@E 99,999,999.99")
	
	   		nLin++
			(cAliasXMl)->(DbSkip())
			IncRegua()	
		EndDo       

		@nLin,00 PSAY __PrtThinLine() //Replicate("-",80)
		nLin++
	EndDo
   	If (cAliasXMl)->(!EOF())
      	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      	nLin := nIniLin
   	Endif
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


 
Static Function ConvDate(nTipo , uDado)
Local xRet      
If nTipo == 1 // AAAAMMDD -> DD/MM/AA
	xRet := Substr(uDado,7,2)+"/"+Substr(uDado,5,2)+"/"+Substr(uDado,3,2)
Else
	xRet := uDado
EndIf                                      
	
Return(xRet) 



Static Function AjustaSX1(cPerg)
Local aHelpPor := {}

Aadd( aHelpPor, "Informe a Filial inicial a ser processada." )
PutSx1(cPerg,"01","Filial de   "        ,"Prev.Fechamento de  ","Prev.Fechamento de  "	,"mv_ch1","C",02,0,0,"G","","SM0","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)
                 
aHelpPor := {}
Aadd( aHelpPor, "Informe a Filial final a ser processada." )
PutSx1(cPerg,"02","Filial Ate  "        ,"Prev.Fechamento Ate ","Prev.Fechamento Ate "	,"mv_ch2","C",02,0,0,"G","","SM0","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe a Data de entrada inicial a ser processada." )
PutSx1(cPerg,"03","Entrada de  "        ,"Prev.Fechamento de  ","Prev.Fechamento de  "	,"mv_ch3","D",08,0,0,"G","",   "","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe a Data de entrada final a ser processada." )
PutSx1(cPerg,"04","Entrada Ate "        ,"Prev.Fechamento Ate ","Prev.Fechamento Ate "	,"mv_ch4","D",08,0,0,"G","",   "","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe a Serie inicial a ser processada." )
PutSx1(cPerg,"05","Serie de    "	 	,"Moeda"				,"Moeda"				,"mv_ch5","C",03,0,0,"G","",   "","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe a Serie final a ser processada." )
PutSx1(cPerg,"06","Serie Ate   "	 	,"Moeda"				,"Moeda"				,"mv_ch6","C",03,0,0,"G","",   "","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe a Nota Fiscal inicial a ser processada." )
PutSx1(cPerg,"07","Nota Fiscal de    " 	,"Moeda"				,"Moeda"				,"mv_ch7","C",09,0,0,"G","",   "","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe a Nota Fiscal final a ser processada." )
PutSx1(cPerg,"08","Nota Fiscal Ate   "	,"Moeda"				,"Moeda"				,"mv_ch8","C",09,0,0,"G","",   "","","","mv_par08","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe as esp�cies que devem ser consideradas" )
Aadd( aHelpPor, "separadas por virgulas Ex: SPED,CTE" )
PutSx1(cPerg,"09","Considera especie   "	,"Moeda"				,"Moeda"				,"mv_ch9","C",20,0,0,"G","",   "","","","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe o codigo inicial do emissor do XML." )
PutSx1(cPerg,"10","Emissor do XML de   "	,"Moeda"				,"Moeda"				,"mv_cha","C",6,0,0,"G","",   "","","","mv_par10","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe o codigo final do emissor do XML." )
PutSx1(cPerg,"11","Emissor do XML ate   "	,"Moeda"				,"Moeda"				,"mv_chb","C",6,0,0,"G","",   "","","","mv_par11","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)


aHelpPor := {}
Aadd( aHelpPor, "Informe a loja inicial do emissor do XML." )
PutSx1(cPerg,"12","Loja do Emissor do XML de   "	,"Moeda"				,"Moeda"				,"mv_chc","C",2,0,0,"G","",   "","","","mv_par12","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe a loja final do emissor do XML." )
PutSx1(cPerg,"13","Loja do Emissor do XML ate   "	,"Moeda"				,"Moeda"				,"mv_chd","C",2,0,0,"G","",   "","","","mv_par13","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "NF Analisar NFs que n�o tem XML." )
Aadd( aHelpPor, "XML Analisar XMLs que n�o tem NF." )
PutSx1(cPerg,"14","Analise Base NF ou Base XML? "	,""						,""						,"mv_che","N",1,0,0,"C","",   "","","","mv_par14","NF","","","","XML","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe as esp�cies que s�o consideradas como" )
Aadd( aHelpPor, "modelo de XML 55-NF-e Ex: SPED,NFE" )
Aadd( aHelpPor, "Isto para quando for Base NF." )
PutSx1(cPerg,"15","Especie que s�o Modelo 55  "	,"Especie que s�o Modelo 55","Especie que s�o Modelo 55","mv_chf","C",20,0,0,"G","",   "","","","mv_par15","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe a Data de EMISS�O inicial a ser processada." )
PutSx1(cPerg,"16","Emiss�o de  "        ,"Emiss�o de  ","Emiss�o de  "	,"mv_chg","D",08,0,0,"G","",   "","","","mv_par16","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {}
Aadd( aHelpPor, "Informe a Data de EMISS�O final a ser processada." )
PutSx1(cPerg,"17","Emiss�o Ate "        ,"Emiss�o Ate ","Emiss�o Ate "	,"mv_chh","D",08,0,0,"G","",   "","","","mv_par17","","","","","","","","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

Return


Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_HFXMLR00()
	EndIF
Return(lRecursa)