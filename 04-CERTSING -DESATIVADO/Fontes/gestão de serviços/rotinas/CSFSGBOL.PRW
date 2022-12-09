#INCLUDE "PRTOPDEF.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch" 

User Function CSFSGBOL(cClifat,cPA1OS,cCliloj,nSoma,dDataV)
                                                       		
LOCAL	aPergs := {}
LOCAL   aMarked    := {}
LOCAL	lRet := .T.
LOCAL	aRet := {} 
local cMVBolReg		:= GetNewPar("MV_BOLETRG","2")
PRIVATE lExec    := .F.
PRIVATE cIndexName := ''                               		
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''
Private _cNossoNum := "00000000"
Private cCart      := "" 
PRIVATE cNumos := cPA1OS
PRIVATE cCliente := cClifat
PRIVATE cLoja := cCliloj
PRIVATE nTotaliq := 0                                                    							
PRIVATE dDatVen := dDataV
PRIVATE cRN
PRIVATE nValDoc := 0
PRIVATE nValDesc := 0       
private cLink	:= "" 
private cOsZZV	:= ""

nValDoc := nSoma
nTotaliq := nSoma

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg     :="BLTBAR"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0

if Processa({|lEnd| lRet := MontaRel()})

	lRet := .F.
	
Else

	//lRet := .T.
	lRet := iif( valtype(lRet) == "L", lRet, ".T.")
	
	//----------------------------------------------------------------
	// Cobranca Boleto sem Registro (Legado)  
	// Conforme solicitacao do Consultor Claudio Correa, solicitou
	// quando for cobranca registrada, o ultimo parametro enviar 
	// em branco (variavel cRN).
	//
	// @autor: Douglas Parreja
	// @Since: 19/12/2016
	//----------------------------------------------------------------
	if !empty( cMVBolReg )
		if cMVBolReg == "1"
			aAdd(aRet,{lRet,dDatVen,cRN})
		elseif cMVBolReg == "2"			
			aAdd(aRet,{lRet,dDatVen,"",cLink, cOsZZV})
		endif       
	endif
	
Endif


Return (aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MontaRel()
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " " 
Local cCNPJ :=  ""   
LOCAL aDadosEmp    := {}
LOCAL cAgconta := GETNEWPAR("MV_CSGBOL2","9999;99999-0")
LOCAL cAgencia := SubStr(cAgconta,1,4)
LOCAL cConta := SubStr(cAgconta,7,5)
LOCAL cDigito := SubStr(cAgconta,13,1)
LOCAL cNumbanco := GETNEWPAR("MV_CSGBOL1","341")
LOCAL cCarteira := GETNEWPAR("MV_CSGBOL3","175")
LOCAL cPrefixo := GETNEWPAR("MV_CSBOL5","RCP")
LOCAL cTitulo := GETNEWPAR("MV_CSGBOL6","NCC")
LOCAL cProduto := GETNEWPAR("MV_CSCOPRO","SV010001")
LOCAL cTes := GETNEWPAR("MV_CSAGTES","903")
Local cNatureza := "" //GETNEWPAR("MV_CSAGNAT","FT010001")  
//local cNatSimplesNac := GETNEWPAR("MV_CSAGNAT","FT010007")  
Local lAdjustToLegacy := .F.
Local lDisableSetup  := .T.
Local cLocal          := MsDocPath()  
Local cFilePrint := ""
LOCAL aDadosTit
LOCAL aDatSacado
LOCAL aBolText     := {}
LOCAL nI           := 1
LOCAL nVlrAbat	   := 0
Local _nDgit       := ""
Local aCB_RN_NN    := {}
Local nIRR		   := 0
Local nPIS		   := 0
Local nCOF		   := 0
Local nCSL		   := 0   
local cMVBolReg		:= GetNewPar("MV_BOLETRG","2")        
local aDeducao		:= {}   
local aNat			:= {}  
local lSimplNac		:= .F.  
local cTipoTrib		:= ""
local cOrdemSeq		:= ""
local aRetControl	:= {}
local lRetControl	:= .F.

Private cMensImp1	   := ""
Private cMensImp2	   := ""
Private cMensImp3	   := ""
Private cMensImp4	   := ""

PRIVATE aDadosBanco
PRIVATE lRet := .F.
Private cMensImp := ""

cAtendBol := cNumos

cNumAtend := cNumos
	
//Calcula Impostos de Retenção

//----------------------------------------------------------------
// Realizado alteracao na estrutura, para que ja alimento a 
// variavel Tipo de Tributacao (cTipoTrib), com o seu conteudo 
// eu verifico na funcao csNatureza a qual natureza refere-se.
// Caso for Simples Nacional, sera calculado somente o I.R. 
//
// @autor: Douglas Parreja
// @Since: 19/01/2017
//----------------------------------------------------------------
if FUNNAME() <> "CSAG0001"
	if M->ADE_KTIPO == "J"   	
		cTipoTrib := alltrim(M->ADE_KTRIB) 
	endif
else	
	dbSelectArea("SA1")
	dbSetOrder(1)
	if dbSeek(xFilial("SA1")+cCliente+cLoja)			
		if alltrim(SA1->A1_PESSOA) == "J" //.and. SA1->A1_SIMPLES != "1"
			cTipoTrib := iif( alltrim(SA1->A1_SIMPLES) == "1", "Simples Nacional", "" )
		endif
	endif
endif

if valType( cTipoTrib ) <> "U"	 
		
	aImposto := {}     
	
	//----------------------------------------------------------------
	// Envio qual tipo de Tributacao esta sendo processado, e retorna
	// a natureza correta e se eh optante pelo Simples Nacional.
	//----------------------------------------------------------------
	aNat 		:= csNatureza( cTipoTrib )
	cNatureza 	:= iif( len(aNat) > 0, aNat[1], "" )
	lSimplNac	:= iif( len(aNat) > 0, iif( len(aNat) > 1, aNat[2], .F. ), .F. )	
		
	aImposto := U_CALCIMP( "S", "N", cCliente, cLoja,"C",cProduto, 1, nTotaliq, nTotaliq, cTES, cNatureza )
	
	If Len(aImposto) > 0
	
		For n := 1 To Len(aImposto[1])
		
			If aImposto[1][n][1] == "IRR" 
			
				nIRR := aImposto[1][n][5] 
			
			ElseIf 	aImposto[1][n][1] == "PIS" .and. !(lSimplNac)
			
				nPIS := aImposto[1][n][5]
				
			ElseIf 	aImposto[1][n][1] == "COF" .and. !(lSimplNac)
			
				nCOF := aImposto[1][n][5]
				
			ElseIf aImposto[1][n][1] == "CSL" .and. !(lSimplNac)
			
				nCSL := aImposto[1][n][5]
				
			End If
		
		Next n
		
		nValDesc := ( IIF(nIRR > GETMV("MV_VLRETIR", .F., 10),nIRR, 0) + nPIS + nCOF + nCSL)
				
		cMensImp1 := IIF(nIRR > GETMV("MV_VLRETIR", .F., 10),"IR: " + alltrim(Transform(nIRR,"@E 99,999,999.99")), "IR: ")
		cMensImp2 := "PIS: " + alltrim(Transform(nPIS,"@E 99,999,999.99"))
		cMensImp3 := "COFINS: " + alltrim(Transform(nCOF,"@E 99,999,999.99"))
		cMensImp4 := "CSLL: " + alltrim(Transform(nCSL,"@E 99,999,999.99"))			
		
		nTotaliq := (nTotaliq) - (nValDesc)
		
	End If				
End If

//----------------------------------------------------------------
// Somente gerara Boleto caso for cobranca sem Registro (Legado)
// @autor: Douglas Parreja
// @Since: 12/12/2016
//----------------------------------------------------------------
if !empty( cMVBolReg )
	if cMVBolReg == "1"
		oPrint := FWMSPrinter():New(cNumos, IMP_PDF, .T. ,cLocal,.T., ,oPrint ,"" , , , .F.,)
		oPrint:lServer := .T.                          
		oPrint:lInJob := .T.
		cFilePrint := cLocal+"000000.PD_"
		File2Printer( cFilePrint, "PDF" )    
	elseif cMVBolReg == "2"
		aDeducao := {}
		aAdd( aDeducao, nValDoc		)	//1-(N) Valor Documento
		aAdd( aDeducao, nValDesc  	)	//2-(N) Valor Desconto 
   		aAdd( aDeducao, nTotaliq  	)	//3-(N) Valor Liquido				
		aAdd( aDeducao, cMensImp1 	)	//4-(C) Mensagem IR
		aAdd( aDeducao, cMensImp2 	)	//5-(C) Mensagem PIS
		aAdd( aDeducao, cMensImp3 	)	//6-(C) Mensagem COFINS
		aAdd( aDeducao, cMensImp4 	)	//7-(C) Mensagem CSLL

	endif
endif
	
dData := dDatVen

cCNPJ := "CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."
cCNPJ +=Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"
cCNPJ +=Subs(SM0->M0_CGC,13,2)	                                 

aDadosEmp    := {	SM0->M0_NOMECOM ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                     ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
cCNPJ                                                                     ,; //[6]
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

 
	cDVCta	:= cDigito//alltrim(SEE->EE_SUBCTA)	//Digito da conta
	_cNossoNum := "99"+cNumos // StrZero(Val(Alltrim(SEE->EE_FAXATU))+1,8)
		
	aDadosBanco  := {cNumbanco                        ,;   //[1]Numero do Banco
	"Itaú Unibanco S.A."      	       ,;   //[2]Nome do Banco
	cAgencia ,;   //[3]Agência
	cConta   ,;   //[4]Conta Corrente
	cDigito   ,;   //[5]Dígito da conta corrente
	cCarteira}    //[6]Codigo da Carteira 
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+cCliente+cLoja,.T.)
	/*
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := { 	u_removeCaracEspecial(AllTrim(SA1->A1_NOME))           										,;      	// [1]Razão Social
							u_removeCaracEspecial(AllTrim(SA1->A1_COD )+"-"+u_removeCaracEspecial(SA1->A1_LOJA))    		,;      	// [2]Código
							u_removeCaracEspecial(AllTrim(SA1->A1_END ))+"-"+u_removeCaracEspecial(AllTrim(SA1->A1_BAIRRO))	,;      	// [3]Endereço
							u_removeCaracEspecial(AllTrim(SA1->A1_MUN )) 					                            ,;			// [4]Cidade
							u_removeCaracEspecial(SA1->A1_EST)                                      					,;			// [5]Estado
							u_removeCaracEspecial(SA1->A1_CEP)				                                      	,;      	// [6]CEP
							u_removeCaracEspecial(SA1->A1_CGC)														 	,;  		// [7]CGC
							u_removeCaracEspecial(SA1->A1_PESSOA)													     	,;			// [8]PESSOA 
							u_removeCaracEspecial(alltrim(SA1->A1_BAIRRO))		                                   }			// [9] BAIRRO 
	Else
		aDatSacado   := {	u_removeCaracEspecial(AllTrim(SA1->A1_NOME))									            	,;   		// [1]Razão Social
							u_removeCaracEspecial(AllTrim(SA1->A1_COD ))+"-"+u_removeCaracEspecial(SA1->A1_LOJA)         	,;   		// [2]Código
							u_removeCaracEspecial(AllTrim(SA1->A1_ENDCOB))+"-"+u_removeCaracEspecial(AllTrim(SA1->A1_BAIRROC)) ,;   	// [3]Endereço
							u_removeCaracEspecial(AllTrim(SA1->A1_MUNC))				                            	,;		   	// [4]Cidade
							u_removeCaracEspecial(SA1->A1_ESTC)				                                  		,;   		// [5]Estado
							u_removeCaracEspecial(SA1->A1_CEPC)		 		                                     	,;		   	// [6]CEP
							u_removeCaracEspecial(SA1->A1_CGC)											 				,;			// [7]CGC
							u_removeCaracEspecial(SA1->A1_PESSOA)															,;			// [8]PESSOA  
							u_removeCaracEspecial(SA1->A1_BAIRRO)                                   	 				} 			// [9] BAIRRO 
	Endif	
	*/
	//Renato Ruy - 12/09/2018
	//Utiliza dados da PA0 para gerar o boleto
	If Empty(PA0->PA0_ENDFAT)
		aDatSacado   := { 	u_removeCaracEspecial(AllTrim(PA0->PA0_CLLCNO))           										,;    	// [1]Razão Social
								u_removeCaracEspecial(AllTrim(PA0->PA0_CLILOC )+"-"+u_removeCaracEspecial(PA0->PA0_LOJLOC)),;    	// [2]Código
								u_removeCaracEspecial(AllTrim(PA0->PA0_END )),;      													// [3]Endereço
								u_removeCaracEspecial(AllTrim(PA0->PA0_CIDADE )) 					                      ,;			// [4]Cidade
								u_removeCaracEspecial(PA0->PA0_ESTADO)                                      				,;			// [5]Estado
								u_removeCaracEspecial(PA0->PA0_CEP)				                                      	,;      	// [6]CEP
								u_removeCaracEspecial(PA0->PA0_CGCFAT)														 	,;  		// [7]CGC
								u_removeCaracEspecial(SA1->A1_PESSOA)													     	,;			// [8]PESSOA 
								u_removeCaracEspecial(alltrim(PA0->PA0_BAIRRO))		                                   ,;			// [9] BAIRRO
								IIF( EMPTY(PA0->PA0_NUMFAT),"SN",u_removeCaracEspecial(alltrim(PA0->PA0_NUMERO)))		,;			// [10] NUMERO DO LOGRADOURO
								u_removeCaracEspecial(alltrim(PA0->PA0_COMPLE))												} 				// [11] COMPLEMENTO ENDERECO 
	Else
		aDatSacado   := { 	u_removeCaracEspecial(AllTrim(PA0->PA0_CLFTNM))           										,;     // [1]Razão Social
								u_removeCaracEspecial(AllTrim(PA0->PA0_CLIFAT )+"-"+u_removeCaracEspecial(PA0->PA0_LOJAFA)),;     // [2]Código
								u_removeCaracEspecial(AllTrim(PA0->PA0_ENDFAT )),;      												// [3]Endereço
								u_removeCaracEspecial(AllTrim(PA0->PA0_CIDFAT )) 					                            ,;	// [4]Cidade
								u_removeCaracEspecial(PA0->PA0_ESTFAT)                                      					,;		// [5]Estado
								u_removeCaracEspecial(PA0->PA0_CEPFAT)				                                      	,;      	// [6]CEP
								u_removeCaracEspecial(PA0->PA0_CGCFAT)														 	,;  		// [7]CGC
								u_removeCaracEspecial(SA1->A1_PESSOA)													     	,;			// [8]PESSOA 
								u_removeCaracEspecial(alltrim(PA0->PA0_BAIFAT))		                                   ,;			// [9] BAIRRO
								IIF( EMPTY(PA0->PA0_NUMFAT),"SN",u_removeCaracEspecial(alltrim(PA0->PA0_NUMFAT)))		,;			// [10] NUMERO DO LOGRADOURO                                 	 				} 			// [9] BAIRRO
								u_removeCaracEspecial(alltrim(PA0->PA0_FATCOM))												} 				// [11] COMPLEMENTO ENDERECO
	Endif
	
	//----------------------------------------------------------------
	// Alterado devido que o Legado nao tinha controle de numeracao,
	// e com isso por default sera gerado.
	// @autor: Douglas Parreja
	// @Since: 24/01/2017
	//----------------------------------------------------------------
	if !empty( cMVBolReg )
		if cMVBolReg == "1"
			cOrdemSeq 	:= "99"
			lRetControl	:= .T.
		else	
			aRetControl := csControlBol( cNumos, dData )
			
			lRetControl := iif( len(aRetControl)>0, aRetControl[1], .F. ) 
			cOrdemSeq	:= iif( len(aRetControl)>0, iif(len(aRetControl)>1,alltrim(aRetControl[2]),""), "" )
		endif
	endif 
	
	//----------------------------------------------------------------
	// Alterado devido que o processo novo ShopLine, eh preciso gerar
	// outra sequencial do numero do Documento.
	// Conforme alinhado com Giovanni x Claudio, a ordem definida 
	// para o CNAB Agendamento Externo eh "99", com isso, somente
	// o primeiro "9" que definara o Agendamento, o outro caracter
	// tera a sequencia de 9 a 0, com isso, o cliente podera gerar
	// no maximo 10 boletos.
	//
	// @autor: Douglas Parreja
	// @Since: 24/01/2017
	//----------------------------------------------------------------
	if lRetControl
		aDadosTit	:= {"9"+cOrdemSeq+alltrim(cNumOS)	,;  // [1] Número do título
		dDataBase										,;  // [2] Data da emissão do título PA0_DTEBOL
		dDataBase										,;  // [3] Data da emissão do boleto 
		dData											,;  // [4] Data do vencimento PA0_DTVBOL
		nValDoc											,;  // [5] Valor do título
		"9"+cOrdemSeq+alltrim(cNumOS)					,;  // [6] Nosso número (Ver fórmula para calculo)
		cPrefixo										,;  // [7] Prefixo da NF
		cTitulo											,;  // [8] Tipo do Titulo
		0												}	// [9] Valor Acrescimo  
	else
		aDadosTit := {"",dDataBase,dDataBase,dDataBase,0,"","","",0}
	endif
	
	nVal1 := aDadosTit[9] 
	nVal2 := aDadosTit[5]

	aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],aDadosTit[6],aDadosTit[5],dData)								//Numero do Banco       //Agencia      //Conta       //Digito da Conta
	
	//----------------------------------------------------------------
	// Criado o Parametro para que tenha mobilidade na geracao da 
	// cobranca, com isso, caso o(s) Banco(s)Itau esteja fora por 
	// algum motivo, eh possivel realizar a geracao da cobranca  
	// como sempre foi realizado.
	// E ja pensando no futuro, caso tenha mais de uma opcao para 
	// geracao do Boleto registrado, podera incluir outros Bancos,
	// com isso precisara incluir o numero sequencial.
	// Exemplo:
	// 1-Boleto Certisign(Legado) / 2-Itau / 3-Bradesco 
	//
	// @autor: Douglas Parreja
	// @Since: 12/12/2016
	//----------------------------------------------------------------
	if !empty( cMVBolReg )
		if cMVBolReg == "1"
			Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		else
			if lRetControl		
				cLink	:= u_boletoReg( aDadosTit, aDatSacado, aDeducao ) 
				cOsZZV	:= iif( !empty(cOrdemSeq) .and. !empty(cNumOS), "9"+cOrdemSeq+alltrim(cNumOS), "" )  
				lRet 	:= .T.
			else
				lRet := .F.
			endif
		endif
	endif
	
	nX := nX + 1

	IncProc()
	nI := nI + 1 

//----------------------------------------------------------------
// Somente gerara Boleto caso for cobranca sem Registro (Legado)
// @autor: Douglas Parreja
// @Since: 12/12/2016
//----------------------------------------------------------------
if !empty( cMVBolReg )
	if cMVBolReg == "1"
		oPrint:EndPage()     // Finaliza a página
		oPrint:Preview()     // Visualiza antes de imprimir
	endif
endif
		
//Grava no banco de conhecimento o arquivo do boleto em pdf.

cAnexo := cAtendBol

cFileName :=  cLocal+"\"+ cAnexo+".PDF"

If File(cFileName)

	lRet := FAT30Anexar(cAnexo, cFileName, cNumAtend)
	
End If  

Return (lRet)


Static Function FAT30Anexar(cAnexo, cFileName, cCodOp) 
	Local aArea       := GetArea()
	Local cDirDoc     := MsDocPath()
	Local cFile       := ''
	Local cACB_CODOBJ := ''
	Local lRet        := .F.
	
	cFile := cAnexo
			
	DbSelectArea("ACB")
	DbSetOrder(1)
	DbSeek(xFilial("ACB")+cFile+".PDF")
	
	If Found()
	
		cFile += "_2.PDF"
		
	Else
	
		cFile += ".PDF"
	
	End If
	
	If lRet := File(cFileName)
	
		__CopyFile(cFileName,cDirDoc + "\" + cFile )
	
	Else
	
		lRet := __CopyFile(cFileName,cDirDoc + "\" + cFile )
		
	End If	
	
	If lRet	
		cACB_CODOBJ := GetSXENum('ACB','ACB_CODOBJ')	
	
		ACB->( RecLock( 'ACB', .T. ) )
		ACB->ACB_FILIAL	:= xFilial( 'ACB' )
		ACB->ACB_CODOBJ	:= cACB_CODOBJ
		ACB->ACB_OBJETO	:= cFile
		ACB->ACB_DESCRI	:= cAnexo
		
		ACB->( MsUnLock() )	
		ACB->( ConfirmSX8() )
		
		AC9->( RecLock( 'AC9', .T. ) )
		AC9->AC9_FILIAL	:= xFilial( 'AC9' )
		AC9->AC9_FILENT	:= xFilial( 'PA0' )
		AC9->AC9_ENTIDA	:= 'PA0'
		AC9->AC9_CODENT	:= cCodOp
		AC9->AC9_CODOBJ	:= cACB_CODOBJ
		AC9->AC9_DTGER    := dDataBase
		AC9->( MsUnLock() )
		
		ACC->( RecLock( 'ACC', .T. ) )
		ACC->ACC_FILIAL := xFilial( 'ACC' ) 
		ACC->ACC_CODOBJ := cACB_CODOBJ
		ACC->ACC_KEYWRD := cCodOp + ' ' + cAnexo
		ACC->( MsUnLock() )
		
	EndIf
	RestArea(aArea)
	
Return( lRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
LOCAL _Dig := Alltrim(str(Modulo10(aDadosBAnco[3]+aDadosBanco[4]+aDadosBanco[6]+aDadosTit[6]))) //Digito Verificador
Local nDV  :=Alltrim(str(Modulo10(aDadosBAnco[3]+aDadosBanco[4]+aDadosBanco[6]+aDadosTit[6]))) //Digito Verificador
Local nLin := 0
Local nX   := 0   
Local cNF  := "" 
local cProd:= ""    
Local cMsg := ""
aBitmap_new :=  "\system\logitau2.bmp"
//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12  := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 50
nRowgrid := -10

oPrint:Line (nRowgrid+0150,500,nRowgrid+0070, 500)
oPrint:Line (nRowgrid+0150,710,nRowgrid+0070, 710)
oPrint:Say  (nRow1+0084,100,"Banco Itau SA",oFont14 )
oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont21 )
oPrint:Say  (nRow1+0075,755,aCB_RN_NN[2],oFont15n)		// [1]Numero do Banco

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)
oPrint:Line (nRowgrid+0150,100,nRowgrid+0150,2300)

oPrint:Say  (nRow1+0110,100 ,"Cedente",oFont8)
oPrint:Say  (nRow1+0160,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0110,1060,"Agência/Código Cedente",oFont8)
oPrint:Say  (nRow1+0160,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (nRow1+0110,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0160,1510,aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0210,100 ,"Sacado",oFont8)
oPrint:Say  (nRow1+0260,100 ,SUBSTR(aDatSacado[1],1,43),oFont10)				//Nome

oPrint:Say  (nRow1+0210,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+260,1060,StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0210,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0260,1550,AllTrim(Transform(aDadosTit[5],"@E 99,999,999.99")),oFont10)

oPrint:Say  (nRow1+0360,0100,"Recebi(emos) o bloqueto/título",oFont10)
oPrint:Say  (nRow1+0410,0100,"com as características acima.",oFont10)
oPrint:Say  (nRow1+0310,1060,"Data",oFont8)
oPrint:Say  (nRow1+0310,1410,"Assinatura",oFont8)
oPrint:Say  (nRow1+0410,1060,"Data",oFont8)
oPrint:Say  (nRow1+0410,1410,"Entregador",oFont8)

oPrint:Line (nRowgrid+0250, 100,nRowgrid+0250,1900 )
oPrint:Line (nRowgrid+0350, 100,nRowgrid+0350,1900 )
oPrint:Line (nRowgrid+0450,1050,nRowgrid+0450,1900 ) //---
oPrint:Line (nRowgrid+0550, 100,nRowgrid+0550,2300 )
oPrint:Line (nRowgrid+0550,1050,nRowgrid+0150,1050 )
oPrint:Line (nRowgrid+0550,1400,nRowgrid+0350,1400 )
oPrint:Line (nRowgrid+0350,1500,nRowgrid+0150,1500 ) //--
oPrint:Line (nRowgrid+0550,1900,nRowgrid+0150,1900 )

oPrint:Say  (nRow1+0115,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0165,1910,"(  )Ausente"                                  ,oFont8)
oPrint:Say  (nRow1+0205,1910,"(  )Não existe nº indicado"                  	,oFont8)
oPrint:Say  (nRow1+0245,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0285,1910,"(  )Não procurado"                            ,oFont8)
oPrint:Say  (nRow1+0325,1910,"(  )Endereço insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0365,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0405,1910,"(  )Falecido"                                 ,oFont8)
oPrint:Say  (nRow1+0445,1910,"(  )Outros(anotar no verso)"                 	,oFont8)


/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 50
nRowgrid2 := 10

//Pontilhado separador
For nI := 100 to 2300 step 50
	oPrint:Line(nRowgrid2+0580, nI,nRowgrid2+0580, nI+30)
Next nI

oPrint:Line (nRowgrid2+0710,100,nRowgrid2+0710,2300)
oPrint:Line (nRowgrid2+0710,500,nRowgrid2+0630, 500)
oPrint:Line (nRowgrid2+0710,710,nRowgrid2+0630, 710)
oPrint:Say  (nRow2+0644,100,"Itaú Unibanco S.A.",oFont12 )		// [2]Nome do Banco
oPrint:Say  (nRow2+0644,513,aDadosBanco[1]+"-7",oFont21 )	// [1]Numero do Banco
oPrint:Say  (nRow2+0644,1850,"Recibo do Sacado",oFont10)
oPrint:Say	(nRow1+0644,755,aCB_RN_NN[2],oFont15n)
oPrint:Line (nRowgrid2+0810,100,nRowgrid2+0810,2300 )
oPrint:Line (nRowgrid2+0910,100,nRowgrid2+0910,2300 )
oPrint:Line (nRowgrid2+0980,100,nRowgrid2+0980,2300 )
oPrint:Line (nRowgrid2+1050,100,nRowgrid2+1050,2300 )
oPrint:Line (nRowgrid2+0910,500,nRowgrid2+1050,500)
oPrint:Line (nRowgrid2+0980,750,nRowgrid2+1050,750)
oPrint:Line (nRowgrid2+0910,1000,nRowgrid2+1050,1000)
oPrint:Line (nRowgrid2+0910,1300,nRowgrid2+0980,1300)
oPrint:Line (nRowgrid2+0910,1480,nRowgrid2+1050,1480)

oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0725,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ.",oFont10)
oPrint:Say  (nRow2+0765,400 ,"NÃO RECEBER APÓS O VENCIMENTO.",oFont10)

oPrint:Say  (nRow2+0710,1810,"Vencimento"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (nRow2+0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0910,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow2+0940,605 ,aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela
oPrint:Say  (nRow2+0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (nRow2+0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
oPrint:Say  (nRow2+0910,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow2+0940,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow2+0910,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0910,1810,"Nosso Número"                                   ,oFont8)
cString := aDadosBanco[6]+"/"+aDadosTit[6]+"-"+_Dig
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0980,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow2+0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow2+1010,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (nRow2+0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow2+0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow2+0980,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow2+0980,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow2+1100,100 ,"Sr(a). Caixa, não receber após o vencimento. " ,oFont10)
oPrint:Say  (nRow2+1125,100 ,"O agendamento somente será confirmado 1 (dia) util após o pagamento deste boleto.",oFont10)
oPrint:Say  (nRow2+1150,100 ,"Outras deduções:",oFont10)
oPrint:Say  (nRow2+1180,100 ,cMensImp1,oFont10)
oPrint:Say  (nRow2+1200,100 ,cMensImp2,oFont10) 
oPrint:Say  (nRow2+1225,100 ,cMensImp3,oFont10) 
oPrint:Say  (nRow2+1245,100 ,cMensImp4,oFont10)           

oPrint:Say  (nRow2+1050,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow2+1120,1810,"(-)Outras Deduções"                             ,oFont8)
cString := Alltrim(Transform(nValDesc,"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1140,nCol,cString ,oFont11c)
oPrint:Say  (nRow2+1190,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow2+1260,1810,"(+)Outros Acréscimos"                           ,oFont8) 
oPrint:Say  (nRow2+1330,1810,"(=)Valor Cobrado"                               ,oFont8)
cString := Alltrim(Transform(nTotaliq,"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+1350,nCol,cString ,oFont11c)   

cString_ := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))

oPrint:Say  (nRow2+1400,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow2+1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)
oPrint:Say  (nRow2+1470,400 ,aDatSacado[3]                                    ,oFont8)
oPrint:Say  (nRow2+1520,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1570,400 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
Else
	oPrint:Say  (nRow2+1570,400 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
EndIf 


oPrint:Say  (nRow2+1570,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

nLin += 215 
oPrint:Say  (nRow2+1665,100 ,"Sacador/Avalista: "                               ,oFont8)   
oPrint:Say  (nRow2+1665,1800,"Autenticação Mecânica",oFont8)

oPrint:Line (nRowgrid2+0710,1800,nRowgrid2+1400,1800 )
oPrint:Line (nRowgrid2+1120,1800,nRowgrid2+1120,2300 )
oPrint:Line (nRowgrid2+1190,1800,nRowgrid2+1190,2300 )
oPrint:Line (nRowgrid2+1260,1800,nRowgrid2+1260,2300 )
oPrint:Line (nRowgrid2+1330,1800,nRowgrid2+1330,2300 )

oPrint:Line (nRowgrid2+1400,100 ,nRowgrid2+1400,2300 )
oPrint:Line (nRowgrid2+1650,100 ,nRowgrid2+1650,2300 )

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := 25
nRowgrid3 := -5

For nI := 100 to 2300 step 50
	oPrint:Line(nRowgrid3+1880, nI, nRowgrid3+1880, nI+30)
Next nI

oPrint:Line (nRowgrid3+2000,100,nRowgrid3+2000,2300)
oPrint:Line (nRowgrid3+2000,500,nRowgrid3+1920, 500)
oPrint:Line (nRowgrid3+2000,710,nRowgrid3+1920, 710)

oPrint:Say  (nRow3+1934,100,"Itaú Unibanco S.A.",oFont12 )		// 	[2]Nome do Banco
oPrint:Say  (nRow3+1925,513,aDadosBanco[1]+"-7",oFont21 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRowgrid3+2100,100,nRowgrid3+2100,2300 )
oPrint:Line (nRowgrid3+2200,100,nRowgrid3+2200,2300 )
oPrint:Line (nRowgrid3+2270,100,nRowgrid3+2270,2300 )
oPrint:Line (nRowgrid3+2340,100,nRowgrid3+2340,2300 )

oPrint:Line (nRowgrid3+2200,500 ,nRowgrid3+2340,500 )
oPrint:Line (nRowgrid3+2270,750 ,nRowgrid3+2340,750 )
oPrint:Line (nRowgrid3+2200,1000,nRowgrid3+2340,1000)
oPrint:Line (nRowgrid3+2200,1300,nRowgrid3+2270,1300)
oPrint:Line (nRowgrid3+2200,1480,nRowgrid3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow3+2015,400 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ.",oFont10)
oPrint:Say  (nRow3+2055,400 ,"NÃO RECEBER APÓS O VENCIMENTO.",oFont10)

oPrint:Say  (nRow3+2000,1810,"Vencimento",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ    

oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

oPrint:Say  (nRow3+2200,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+2200,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+2200,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (nRow3+2230,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+2200,1305,"Aceite"                                         ,oFont8)
oPrint:Say  (nRow3+2230,1400,"N"                                             ,oFont10)

oPrint:Say  (nRow3+2200,1485,"Data do Processamento"                          ,oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

//Calcula o Digito Verificador

oPrint:Say  (nRow3+2200,1810,"Nosso Número"                                   ,oFont8)
cString  :=  aDadosBanco[6]+"/"+aDadosTit[6]+"-"+_Dig
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2270,100 ,"Uso do Banco"                                   ,oFont8)

oPrint:Say  (nRow3+2270,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6]                                  	,oFont10)

oPrint:Say  (nRow3+2270,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor"                                          ,oFont8)

oPrint:Say  (nRow3+2270,1810,"Valor do Documento"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2350,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow3+2400,100 ,"Sr(a). Caixa, não receber após o vencimento. " ,oFont10)
oPrint:Say  (nRow3+2425,100 ,"O agendamento somente será confirmado 1 (dia) util após o pagamento deste boleto.",oFont10)
oPrint:Say  (nRow2+2435,100 ,"Outras deduções:",oFont10)
oPrint:Say  (nRow3+2480,100 ,cMensImp1,oFont10)
oPrint:Say  (nRow3+2500,100 ,cMensImp2,oFont10) 
oPrint:Say  (nRow3+2520,100 ,cMensImp3,oFont10) 
oPrint:Say  (nRow3+2540,100 ,cMensImp4,oFont10) 

nLin := nRow3+2600
oPrint:Say  (nLin ,100 ,cProd,oFont8)   

oPrint:Say  (nRow3+2340,1810,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (nRow3+2410,1810,"(-)Outras Deduções"                             ,oFont8)
cString := Alltrim(Transform(nValDesc,"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+2430,nCol,cString ,oFont11c)
oPrint:Say  (nRow3+2480,1810,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+)Outros Acréscimos"                           ,oFont8) 
oPrint:Say  (nRow3+2620,1810,"(=)Valor Cobrado"                               ,oFont8)
cString := Alltrim(Transform(nTotaliq,"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow2+2630,nCol,cString ,oFont11c)

cString_ := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1810+(374-(len(cString)*22))

oPrint:Say  (nRow3+2690,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (nRow3+2700,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont8)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2700,1750,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8) // CGC
Else
	oPrint:Say  (nRow3+2700,1750,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8) 	// CPF
EndIf

oPrint:Say  (nRow3+2740,400 ,aDatSacado[3]                                    ,oFont8)
oPrint:Say  (nRow3+2780,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8) // CEP+Cidade+Estado
oPrint:Say  (nRow3+2780,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont8)

nLin += 135
oPrint:Say  (nLin,100 ,"Sacador/Avalista: "                                ,oFont8)
oPrint:Say  (nRow3+2840,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont8)

oPrint:Line (nRowgrid3+2000,1800,nRowgrid3+2690,1800 )
oPrint:Line (nRowgrid3+2410,1800,nRowgrid3+2410,2300 )
oPrint:Line (nRowgrid3+2480,1800,nRowgrid3+2480,2300 )
oPrint:Line (nRowgrid3+2550,1800,nRowgrid3+2550,2300 )
oPrint:Line (nRowgrid3+2620,1800,nRowgrid3+2620,2300 )

oPrint:Line (nRowgrid3+2690,100 ,nRowgrid3+2690,2300 )
oPrint:Line (nRowgrid3+2860,100,nRowgrid3+2860,2300  )

oPrint:FWMSBAR( "INT25",67.8  ,2 ,aCB_RN_NN[1],oPrint,.F.   ,     ,     ,     ,  1 ,      ,      ,     ,.F.)
oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

LOCAL cValorFinal := strzero(nValor*100,10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cCB			:= ''
LOCAL cS			:= ''
LOCAL cFator        := strzero(dVencto - ctod("07/10/97"),4)
Local cCart         := aDadosBanco[6]

//-----------------------------
// Definicao do NOSSO NUMERO
// ----------------------------
cS    :=  cAgencia + cConta + cCart + cNroDoc
nDvnn := modulo10(cS) // digito verifacador Agencia + Conta + Carteira + Nosso Num
cNN   := cCart + cNroDoc + AllTrim(Str(nDvnn))

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
cS:= cBanco + cFator +  cValorFinal + cNN + cAgencia + cConta + cDacCC + '000'
nDvcb := modulo11(cS)
//nDvcb := modulo11("09"+"341",2,7)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,25) + AllTrim(Str(nDvnn))+ SubStr(cS,31)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS    := cBanco + cCart + SubStr(cNroDoc,1,2)
nDv   := modulo10(cS)
cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '

// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS :=Subs(cNN,6,6) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3)
nDv:= modulo10(cS)
cRN := Subs(cBanco,1,3) + "9" + Subs(cCart,1,1)+'.'+ Subs(cCart,2,3) + Subs(cNN,4,2) + SubStr(cRN,11,1)+ ' '+  Subs(cNN,6,5) +'.'+ Subs(cNN,11,1) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3) +Alltrim(Str(nDv)) + ' '

// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS    := Subs(cAgencia,4,1) + Subs(cConta,1,4) +  Subs(cConta,5,1)+Alltrim(cDacCC)+'000'
nDv   := modulo10(cS)
cRN   := cRN + Subs(cAgencia,4,1) + Subs(cConta,1,4) +'.'+ Subs(cConta,5,1)+Alltrim(cDacCC)+'000'+ Alltrim(Str(nDv))

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
cRN   := cRN + cFator + StrZero(nValor * 100,14-Len(cFator))

Return({cCB,cRN,cNN})


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

//-----------------------------------------------------------------------
/*/{Protheus.doc} csNatureza()
Funcao responsavel por retornar o codigo da Natureza da Operacao que 
sera realizada atraves do Tipo de Tributacao selecionada para o cliente
Pessoa Juridica.

@param		cTipoTrib	Tipo de Tributacao (Simples Nacional, Tributado, etc).
@return		cRet		Retorna o valor do conteudo do parametro.

@author	Douglas Parreja
@since	18/01/2017
@version 11.8
/*/
//-----------------------------------------------------------------------
static function csNatureza( cTipoTrib )

	local cMVNatPCC 	:= "MV_CSAGNAT"
	local cMVNatSim 	:= "MV_CSNATSI"
	local cExec			:= "Processo Agendamento Externo (Validacao Parametro)"
	local cRet			:= ""
	local lSimplesNac	:= .F.
	
	default cTipoTrib	:= ""
	
	if valType( cTipoTrib ) <> "U"
		if cTipoTrib <> "Simples Nacional"	
			//-------------------------------------------------------------------------------------------
			// MV_SERVGRU - Define o codigo da Natureza que sera realizado quando o Cliente NAO for
			// Simples Nacional, ou seja, calculo de Imposto PCC. 
			//-------------------------------------------------------------------------------------------	
			if !GetMV( cMVNatPCC, .T. )
				CriarSX6( cMVNatPCC, 'C', 'Natureza agendamento externo', 'FT010001' )
				u_autoMsg(cExec, , "criado parametro MV_CSAGNAT - Natureza PCC agendamento externo")
			endif
			cRet := alltrim( getMv(cMVNatPCC) )
		
		elseif cTipoTrib == "Simples Nacional"	
			//-------------------------------------------------------------------------------------------
			// MV_CSNATSI - Define o codigo da Natureza que sera realizado quando o Cliente FOR 
			// do Simples Nacional, ou seja, calculo apenas IR. 
			//-------------------------------------------------------------------------------------------	
			if !GetMV( cMVNatSim, .T. )
				CriarSX6( cMVNatSim, 'C', 'Natureza agendamento externo SIMPLES NACIONAL', 'FT010007' )
				u_autoMsg(cExec, , "criado parametro MV_CSAGNAT - Natureza PCC agendamento externo")
			endif
			
			lSimplesNac := .T.
			cRet := alltrim( getMv(cMVNatSim) )
		
		endif
	endif
	
return { cRet, lSimplesNac }

//-------------------------------------------------------------------
/*/{Protheus.doc} csControlBol
Funcao responsavel por controlar a numeracao do proximo Boleto, 
mantendo a numeracao da Ordem de Servico fixa.
Exemplo: 99123456

9 -> Agendamento Externo
9 -> Sequencial de boletos gerados (9 a 0) Decrescente.
123456 -> Numero da Ordem de Servico.

@param		cOrdemServ		Numero ordem de servico.
		  	dDataVenc		Data Vencimento que deseja.	  	
@return		lRet			Retorna se operacao pode ser continuada.
			cRetOS			Retorna o numero da Ordem que sera o proximo
							numero do boleto.					  	

@author  Douglas Parreja
@since   24/01/2017
@version 11.8
/*/
//-------------------------------------------------------------------
static function csControlBol( cOrdemServ, dDataVenc )

	local cTabela 			:= "ZZV"
	local cUltimaOS			:= ""
	local cRetOS			:= ""
	local lRet				:= .F. 
	local PA0_cOrdemServ	:= ""
	local PA0_cNumControle	:= ""
	local PA0_dDataVen		:= ""
	local PA0_cLinkNovo		:= ""
	local lReenvBol			:= .F.
	
	default cOrdemServ		:= ""
	default dDataVenc		:= ""
	
	if ( !(empty(cOrdemServ)) .and. !(empty(dDataVenc)) )  
		if u_csChkTabela( cTabela )				
			if csValidTabela ( cTabela )
				ZZV->(dbSetOrder(1)) //ZZV_FILIAL+ZZV_OS     
				if ZZV->( dbSeek(xFilial("ZZV") + alltrim(cOrdemServ) ))
					while !ZZV->(eof()) .and. (ZZV->ZZV_OS == alltrim( cOrdemServ )) 
						cUltimaOS := alltrim( ZZV->ZZV_CONTRO )		
						lRet := .T.	  
						ZZV->(dbSkip())
					end								
					if valtype( cUltimaOS ) == "C"
						nCalc := (val(substr(cUltimaOS,2,1)) - 1)
						if nCalc >= 0
							cRetOS := alltrim(str(nCalc))
						else
							alert("Não foi possível gerar o Boleto, devido que já foram gerados 10 boletos para a mesma Ordem de Serviço " + cOrdemServ )   
							lRet := .F.
						endif
					endif
			
				else
				//-----------------------------------------------------------------
				// Se entrou aqui eh porque nao tem boleto gerado na ZZV (legado).
				// Com isto precisamos retornar o numero sequencial para ser 
				// gerado o novo boleto, com isso, o proximo numero sera 8, porque
				// o 9 eh o primeiro boleto.
				//-----------------------------------------------------------------					
					if valtype( cOrdemServ ) == "C"
						if FUNNAME() == "CSAG0001" .Or. FUNNAME() == "TMKA510A"
	
							dbSelectArea("PA0")
							PA0->(dbsetOrder(1))
							if PA0->( dbSeek(xFilial("PA0") + alltrim(cOrdemServ)) )					
								PA0_cOrdemServ		:= alltrim( PA0->PA0_OS )
								PA0_cNumControle	:= "99" + alltrim( PA0->PA0_OS )
								PA0_dDataVen		:= PA0->PA0_DTVBOL
								PA0_cLinkNovo		:= alltrim(PA0->PA0_LINK)
								lReenvBol			:= .T.
								lRet 				:= .T.	                        
							endif                                                                   
							
							if lRet .and. ( !empty(PA0_cOrdemServ) .and. !empty(PA0_cNumControle) .and. !empty(PA0_dDataVen) .and. !empty(PA0_cLinkNovo) )
								if u_csGravaZZV( PA0_cOrdemServ, PA0_cNumControle, PA0_dDataVen, PA0_cLinkNovo, lReenvBol )
									cRetOS := "8" 
								endif
							else
								//-----------------------------------------------------------------
								// Quando eh retornado .F. significa que eh a primeiro Boleto, 
								// neste caso, eh necessario retornar '9' como default.
								//-----------------------------------------------------------------
								cRetOS := "9"
							endif
						endif							
					endif					
				endif									
			endif
		endif
	endif
	
return { lRet, cRetOS }

//-------------------------------------------------------------------
/*/{Protheus.doc} csChkTabela
Funcao responsavel por verificar se existe a tabela no Dicionario
de Dados.

@param		cTable		Tabela a ser verificada.
@return  	lRet		Retorna se existe a tabela.

@author  Douglas Parreja
@since   24/01/2017
@version 11.8
/*/
//-------------------------------------------------------------------
user function csChkTabela( cTable )
	
	default cTable := ""	

return iif( ChkFile(alltrim(cTable)),.T., .F. )

//-------------------------------------------------------------------
/*/{Protheus.doc} csValidTabela
Funcao responsavel por verificar se as tabelas estao em uso, caso
nao esteja, realizo a abertura das mesmas.

@param		cTable	Tabela a ser verificada.
@return 	lRet	Retorna se as tabelas estao prontas para uso.

@author  Douglas Parreja
@since   24/01/2017
@version 11.8
/*/
//-------------------------------------------------------------------
static function csValidTabela( cTable )

	local lRet := .F.
	default cTable := ""
	
	cTable := alltrim(cTable) 
	
	if !(empty(cTable))	
		if select(cTable) > 0 
			lRet := .T.
		else
			dbSelectArea(cTable)
			if select(cTable) > 0 
				lRet := .T.
			endif 		
		endif
	endif

return lRet
