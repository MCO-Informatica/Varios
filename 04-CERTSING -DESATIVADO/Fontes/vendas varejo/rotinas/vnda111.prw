#include "Fileio.ch"
#Include "totvs.ch"
#INCLUDE "Protheus.ch"

#DEFINE ENTER chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³vnda111 ºAutor  ³Leandro Nishihata º Data ³  17/01/18       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³inclusão / alteracao de dados no cadastro de clientes 	  º±±
±±º    		  utilizando a rotina de vendas da certisign				  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function vnda111()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local oDlg
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cDirIn	:= Space(256)
Local aDirIn	:= {}
private cDirOut	:= Space(256)
private cArqOut	:= Space(256)

DEFINE MSDIALOG oDlg FROM  36,1 TO 210,550 TITLE "Leitura do .CSV" PIXEL

@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 25,10 SAY "Dir. Relatório" OF oDlg PIXEL
@ 25,70 MSGET cDirOut SIZE 200,5 OF oDlg PIXEL

@ 40,10 SAY "nome do arquivo .CSV" OF oDlg PIXEL
@ 40,70 MSGET cArqOut SIZE 200,5 OF oDlg PIXEL


@ 65,010 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CSVCLIA(@aDirIn,@cDirIn)
@ 65,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 65,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1
	Return(.F.)
EndIf

If len(aDirIn) == 0
	MsgAlert( "Não Foram encontrados Arquivos para processamento!" )
	Return(.F.)
EndIf

Proc2BarGauge({|| OkLeTxt(aDirIn) },"Processamento de Arquivo CSV")

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSVCLIA ºAutor  ³Leandro Nishihata º Data ³  17/01/18       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao selecao dos diretorios 			  				  º±±
±±º             origem - caminho do arquivo csv que contenha os clientes  º±±
±±º             destino- onde irá ser salvo o relatorio 				  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CSVCLIA(aDirIn,cDirIn)

	aDirIn  := ALLTRIM(cGetFile("*.csv", "importar arquivo", 1,"C:\" ,.F. , GETF_LOCALHARD ))
	cDirIn  := aDirIn
	cDirout := cGetFile('Arquivo *|*.*|Arquivo csv|*.csv','diretório impressão',0,'C:\',.T.,GETF_LOCALHARD+GETF_RETDIRECTORY+GETF_NETWORKDRIVE,.F.)
	cDirout := cDirout+space(255)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OkLeTxt ºAutor  ³Leandro Nishihata º Data ³  17/01/18       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   //³ Abertura do arquivo texto   								  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkLeTxt(aDirIn)

//Local nIGeral 	:= 0
Private cArqTxt := ""
Private nHdl    := ""

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cArqTxt := ALLTRIM(aDirIn)//[nIGeral][1]
	nHdl    := fOpen(cArqTxt,68)
	MONTAVET()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MONTAVET ºAutor  ³Leandro Nishihata º Data ³  17/01/18      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   //³ letura das linhas do arquivo csv, ( inicio do processo)	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function MONTAVET()
Local aLin

Private AALTERA	  := {}
Private AINCLUI   := {}

FT_FUSE(cArqTxt)

FT_FGOTOP()

DbSelectArea("SA1")
SA1->(DbSetOrder(3)) //A1_FILIAL + A1_CGC
BarGauge1Set( FT_FLASTREC())
While !FT_FEOF()
	xBuff	:= alltrim(FT_FREADLN())

	While ";;" $ xBuff
		xBuff	:= StrTran(xBuff,";;",";-;")
	EndDo
	While ";;" $ xBuff
		xBuff	:= StrTran(xBuff,";;",";-;")
	EndDo

	aLin 	:= StrTokArr(xBuff,";")

	while len(aLin) < 14 // cria os campos de inscricacao estadual e municipal nos casos de serem isentas.
		aadd(aLin," ")
	enddo
	
	IF ALLTRIM(aLin[10]) <> ''
		IMPCSV(aLin)
	ENDIF
		FT_FSkip()	
	enddo
	IncProcG1("processamento finalizado.")
	ProcessMessage()
	dbclosearea()
	fExpExel()
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPCSV   ºAutor  ³Leandro Nishihata º Data ³  17/01/18      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   //³ importacao dos registros do csv. feito de forma indidual   º±±
±±º			   (linha  a linha)											  º±±
±±º		o arquivo csv tem que obrigatoriamente seguir a sequencia abaixo  º±±
±±º		aLin[1] = ds_nome_fantasia										  º±±
±±º		aLin[2] = END													  º±±	
±±º		aLin[3] = NUMERO												  º±±
±±º		aLin[4] = COMPLEMENTO											  º±±	
±±º		aLin[5] = BAIRRO												  º±±	
±±º		aLin[6] = CEP													  º±±	
±±º		aLin[7] = CIDADE												  º±±	
±±º		aLin[8] = UF													  º±±	
±±º		aLin[9] = NOME													  º±±	
±±º		aLin[10] = CPF													  º±±	
±±º		aLin[11] = EMAIL												  º±±	
±±º		aLin[12] = TELEFONE												  º±±
±±º		aLin[13]= Inscrição Estadual (quando CNPJ)						  º±± 
±±º		aLin[14]= Inscrição Municipal (Quando CNPJ).					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function IMPCSV(aLin)

Local cCgc		 := ALLTRIM(aLin[10]) 
Local cNome		 := ALLTRIM(aLin[9])
Local cNReduz	 := ALLTRIM(aLin[1])
Local cEnd		 := ALLTRIM(aLin[2]+", "+ALLTRIM(aLin[3]))
lOCAL CLOGRAD    := ALLTRIM(aLin[2])
Local cCompl	 := ALLTRIM(aLin[4])
Local cCep		 := StrTran(ALLTRIM(aLin[6]),"-","")
Local cBairro	 := ALLTRIM(aLin[5])
Local cFone		 := StrTran(ALLTRIM(aLin[12]),"-","")
Local cDDD		 := ""
Local cMunicipio	 := ALLTRIM(aLin[7])
Local cUf		 := ALLTRIM(aLin[8])
local cCodMum    := GetAdvFVal('PA7','PA7_CODMUN', XFILIAL('PA7')+cCEP,1, '')
Local cCodUF     := GetAdvFVal('PA7','PA7_CODUF', XFILIAL('PA7')+cCEP,1, '')
Local cIbge		 := cCodUF+cCodMum //COMPATIBILIZADO PARA NÃO ATUALIZAR ERRONEAMENTE A PA7 NO VNDA110
Local cEmail	 := ALLTRIM(iif(Empty(aLin[11]),"N/A",ALLTRIM(aLin[11]))) 
Local cPessoa	 := ""
Local cInEst	 := ALLTRIM(iif(Empty(aLin[13]),"ISENTO",ALLTRIM(aLin[14])))
Local CInMun	 := ALLTRIM(iif(Empty(aLin[13]),"ISENTO",ALLTRIM(aLin[14])))
Local cLjCli	 := "01"
Local cTpCli	 := "F"	//Consumidor final
Local nOpc 		 := 3
Local nTentativa := 0
Local lCliente   := .F.
Local aRetCl
Local aDadEnt	:= {cEnd,cBairro, ALLTRIM(aLin[3]), cCompl, cCep, cMunicipio,cUf}
Local cCliente  := ''

If empty(alltrim(cCgc)) .OR. VAL(cCgc)<=0

	aRetCl := {.F.,"Linha Vazia. Não é possível gerar o cadastro do cliente!"}
	AADD(AINCLUI,{"ERRO",cCliente,cNome,aRetCl[2],cCgc	 , cNome	 , cNReduz , cEnd	 , CLOGRAD , cCompl	 , cCep	 , cBairro , cFone	 , cDDD	 , cMunicipio , cUf	 , cCodMum , cCodUF  , cIbge	 , cEmail	 , cPessoa , cInEst	 , CInMun	 })
	return

Endif
	IncProcG1("processndo cliente: "+cNome)
	ProcessMessage()
	
//tratamento cgc
cCgc := StrTran(ALLTRIM(cCgc),"-","")
cCgc := StrTran(ALLTRIM(cCgc),".","")
cCgc := StrTran(ALLTRIM(cCgc),"/","")

if LEN(cCgc) <= 11
	cCgc := right(replicate("0",11)+cCgc,11)
else
	cCgc := right(replicate("0",14)+cCgc,14)
endif
cPessoa	 := if(len(alltrim(cCgc)) = 11,"F","J")

DbSetOrder(3)
dbgotop()
If !DbSeek(xFilial("SA1") + U_CSFMTSA1(cCgc))

	nTentativa := 0
	lCliente   := .F.
	While !lCliente .And. nTentativa < 10
		sleep(Randomize( 1000, 5000 ))
		cCliente := GetSXENum('SA1','A1_COD')
		lCliente := LockByName("CLIENTE-"+cCliente)
		nTentativa++
	Enddo

	cLjCli		:= "01"
	cTpCli		:= "F"	//Consumidor final
	nOpc 		:= 3
    
	If lCliente

		//Destrava antes de executar a execAuto e grava a sequencia
		SA1->(ConfirmSX8())
		UnLockByName("CLIENTE-"+cCliente)

		aRetCl := U_VNDA110(nOpc,cCliente,cLjCli,cPessoa,cNome,cNReduz,cTpCli,cEnd,cBairro,cCEP,cMunicipio,cUf,""/*cPais*/,""/*cDescPais*/,cDDD,cFone,cCgc,""/*cRG*/,cEmail,cInEst,cInMun,/*cSufra*/"",""/*cNpSite*/,""/*cID*/,aDadEnt,""/*cPedLog*/,cIbge,cLograd)
	Else
		aRetCl := {.F.,"Não foi possível reservar o numero para gerar o cadastro do cliente!"}
	Endif
			
	If aRetCl[1]
	AADD(AINCLUI,{"OK",cCliente,cNome,aRetCl[2],cCgc	 , cNome	 , cNReduz , cEnd	 , CLOGRAD , cCompl	 , cCep	 , cBairro , cFone	 , cDDD	 , cMunicipio , cUf	 , cCodMum , cCodUF  , cIbge	 , cEmail	 , cPessoa , cInEst	 , CInMun	 })

	Else
	AADD(AINCLUI,{"ERRO",cCliente,cNome,aRetCl[2],cCgc	 , cNome	 , cNReduz , cEnd	 , CLOGRAD , cCompl	 , cCep	 , cBairro , cFone	 , cDDD	 , cMunicipio , cUf	 , cCodMum , cCodUF  , cIbge	 , cEmail	 , cPessoa , cInEst	 , CInMun	 })

	Endif
else

	cCliente    := SA1->A1_COD
	cLjCli      := SA1->A1_LOJA
	cTpCli      := SA1->A1_TIPO
	nOpc        := 4
	aRetCl := U_VNDA110(nOpc,cCliente,cLjCli,cPessoa,cNome,cNReduz,cTpCli,cEnd,cBairro,cCEP,cMunicipio,cUf,""/*cPais*/,""/*cDescPais*/,cDDD,cFone,cCgc,""/*cRG*/,cEmail,cInEst,cInMun,/*cSufra*/"",""/*cNpSite*/,""/*cID*/,aDadEnt,""/*cPedLog*/,cIbge,cLograd)
	If aRetCl[1]
		AADD(AALTERA,{"OK",cCliente,cNome,aRetCl[2],cCgc	 , cNome	 , cNReduz , cEnd	 , CLOGRAD , cCompl	 , cCep	 , cBairro , cFone	 , cDDD	 , cMunicipio , cUf	 , cCodMum , cCodUF  , cIbge	 , cEmail	 , cPessoa , cInEst	 , CInMun	 })
	Else
		AADD(AALTERA,{"ERRO",cCliente,cNome,aRetCl[2],cCgc	 , cNome	 , cNReduz , cEnd	 , CLOGRAD , cCompl	 , cCep	 , cBairro , cFone	 , cDDD	 , cMunicipio , cUf	 , cCodMum , cCodUF  , cIbge	 , cEmail	 , cPessoa , cInEst	 , CInMun	 })
	Endif
	
Endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³expexel ºAutor  ³Leandro Nishihata º Data ³  17/01/18       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de geracao do arquivo no formato csv                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fExpExel()

Local nHdlTXT	:= 0
Local cFileCSV	:= CriaTrab(Nil,.F.)+".CSV"
Local cLinhaCSV	:= ""
Local i 		:= 0
Local oExcel	:= Nil
//Local _aCCusto 	:={}

nHdlTXT := FCreate(cFileCSV)

If nHdlTXT < 0
	MsgAlert( "Houve um erro na tentiva de geração do arquivo csv, tente novamente." )
	Return(Nil)
EndIf

cLinhaCSV := " clientes importados com sucesso"
FWrite(nHdlTXT,cLinhaCSV+Chr(13)+Chr(10))
FWrite(nHdlTXT,"status;Cliente;Nome;LOG;cCg;cNome;cNReduz;cEnd;CLOGRAD;cCompl;cCep;cBairro;cFone;cDDD;cMunicipio;cUf;cCodMum;cCodUF;cIbge;cEmail;cPessoa;cInEst;CInMun"+Chr(13)+Chr(10) )

BarGauge2Set( len(AINCLUI)+ len(AALTERA))

for i:=1 to len(AINCLUI)
	IncprocG2( "imprimindo registros incluídos --- cliente: "+ AINCLUI[i][3] )
	ProcessMessage()
		
	cLinhaCSV :=   AINCLUI[i][1]+";"
	cLinhaCSV +=   AINCLUI[i][2]+";"
	cLinhaCSV +=   AINCLUI[i][3]+";"
	cLinhaCSV +=   AINCLUI[i][4]+";"
	cLinhaCSV +=   AINCLUI[i][5]+";"
	cLinhaCSV +=   AINCLUI[i][6]+";"
	cLinhaCSV +=   AINCLUI[i][7]+";"
	cLinhaCSV +=   AINCLUI[i][8]+";"
	cLinhaCSV +=   AINCLUI[i][9]+";"
	cLinhaCSV +=   AINCLUI[i][10]+";"
	cLinhaCSV +=   AINCLUI[i][11]+";"
	cLinhaCSV +=   AINCLUI[i][12]+";"
	cLinhaCSV +=   AINCLUI[i][13]+";"
	cLinhaCSV +=   AINCLUI[i][14]+";"
	cLinhaCSV +=   AINCLUI[i][15]+";"
	cLinhaCSV +=   AINCLUI[i][16]+";"
	cLinhaCSV +=   AINCLUI[i][17]+";"
	cLinhaCSV +=   AINCLUI[i][18]+";"
	cLinhaCSV +=   AINCLUI[i][19]+";"
	cLinhaCSV +=   AINCLUI[i][20]+";"
	cLinhaCSV +=   AINCLUI[i][21]+";"
	cLinhaCSV +=   AINCLUI[i][22]+";"
	cLinhaCSV +=   AINCLUI[i][23]+";"
	
	FWrite(nHdlTXT,cLinhaCSV+Chr(13)+Chr(10))
next i

cLinhaCSV := " Clientes alterados importados"
FWrite(nHdlTXT,cLinhaCSV+Chr(13)+Chr(10))
FWrite(nHdlTXT,"status;Cliente;Nome;LOG;cCg;cNome;cNReduz;cEnd;CLOGRAD;cCompl;cCep;cBairro;cFone;cDDD;cMunicipio;cUf;cCodMum;cCodUF;cIbge;cEmail;cPessoa;cInEst;CInMun"+Chr(13)+Chr(10) )

for i:=1 to len(AALTERA)
	IncprocG2( "imprimindo registros alterados --- cliente: "+ AALTERA[i][3] )
	ProcessMessage()
		
	cLinhaCSV :=   AALTERA[i][1]+";"
	cLinhaCSV +=   AALTERA[i][2]+";"
	cLinhaCSV +=   AALTERA[i][3]+";"
	cLinhaCSV +=   AALTERA[i][4]+";"
	cLinhaCSV +=   AALTERA[i][5]+";"
	cLinhaCSV +=   AALTERA[i][6]+";"
	cLinhaCSV +=   AALTERA[i][7]+";"
	cLinhaCSV +=   AALTERA[i][8]+";"
	cLinhaCSV +=   AALTERA[i][9]+";"
	cLinhaCSV +=   AALTERA[i][10]+";"
	cLinhaCSV +=   AALTERA[i][11]+";"
	cLinhaCSV +=   AALTERA[i][12]+";"
	cLinhaCSV +=   AALTERA[i][13]+";"
	cLinhaCSV +=   AALTERA[i][14]+";"
	cLinhaCSV +=   AALTERA[i][15]+";"
	cLinhaCSV +=   AALTERA[i][16]+";"
	cLinhaCSV +=   AALTERA[i][17]+";"
	cLinhaCSV +=   AALTERA[i][18]+";"
	cLinhaCSV +=   AALTERA[i][19]+";"
	cLinhaCSV +=   AALTERA[i][20]+";"
	cLinhaCSV +=   AALTERA[i][21]+";"
	cLinhaCSV +=   AALTERA[i][22]+";"
	cLinhaCSV +=   AALTERA[i][23]+";"

	FWrite(nHdlTXT,cLinhaCSV+Chr(13)+Chr(10))
next i

FClose(nHdlTXT)

cDirOut := TRIM(cDirOut)
cArqOut := TRIM(cArqOut)
//tratamento de pasta a ser salvo o relatório
if substr(cDirOut,len(TRIM(cDirOut)),1) <> "\"

	cDirOut := TRIM(cDirOut) + "\"
endif

if upper(substr(cArqOut,len(TRIM(cArqOut))-3,4))  <> ".CSV"
	cArqOut := TRIM(cArqOut) + ".CSV"
endif

u_CriarDir(cDirout)  // funcao encontrada no fonte csfuncoes.prw ( cria  diretorio conforme necessario )

__CopyFile(cFileCSV,cDirout+cArqOut)

oExcel := MsExcel():New()
oExcel:WorkBooks:Open( cDirout+cArqOut )
oExcel:SetVisible(.T.)

Return(.T.)
