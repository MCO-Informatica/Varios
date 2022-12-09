#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include 'protheus.ch'

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+--------------------------------+------------------+||
||| Programa: CfmAtuMo | Autor: Celso Ferrone Martins   | Data: 14/10/2014 |||
||+-----------+--------+--------------------------------+------------------+||
||| Descricao | Atualiza moedas/cambio                                     |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+------------------------------------------------------------------------+||
||| Colocar as linhas abaixo no appserver.ini para utilizar apenas o JOB   |||
||| sem scheduler.                                                         |||
|||                                                                        |||
||| [ONSTART]                                                              |||
||| jobs=Moedas                                                            |||
||| ;Tempo em Segundos 86400=24 horas  /18000=5 Horas                       |||
||| RefreshRate=18000                                                      |||
|||                                                                        |||
||| [Moedas]                                                               |||
||| main=U_CfmAtuMo                                                        |||
||| Environment=Environment                                                |||
|||                                                                        |||
||+------------------------------------------------------------------------+||
||| Caso queira adicionar em Scheduler                                     |||
|||                                                                        |||
||| [ONSTART]                                                              |||
||| jobs=Moedas                                                            |||
||| ;Tempo em Segundos 86400=24 horas                                      |||
||| ;RefreshRate=15                                                        |||
|||                                                                        |||
||| [Moedas]                                                               |||
||| main=WFONSTART                                                         |||
||| Environment=Environment                                                |||
||| nParms=0                                                               |||
|||                                                                        |||
||+------------------------------------------------------------------------+||
|||Criar arquivo scheduler.wf na pasta system com o conteudo               |||
|||02,01,IMAP10A,.T.                                                       |||
||+------------------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmAtuMo()

Private xData     := cTod("  /  /  ")
Private lAuto     := .F.
Private xSabDom   := .F.
Private nValDolar := 0
Private nValReal  := 1.000000
Private nValUfir  := 1.064100

If FindFunction('WFPREPENV')
	WfPrepEnv( "01", "01")
Else
	Prepare Environment Empresa "01" Filial "01" Tables "SM2"
	lAuto := .T.
EndIf

ConOut('Iniciando Atualizacao de Moedas. '+Dtoc(Date())+' - '+Time())

If !lAuto
	LjMsgRun(OemToAnsi('Atualizacao On-line BCB'),,{|| fAtuMoedas()} )
Else
	fAtuMoedas()
EndIf

If lAuto
	//	RpcClearEnv()		   				//Libera o Environment
	ConOut('Atualizacao de Moedas Concluida. '+Dtoc(Date())+' - '+Time())
EndIf

Return

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: fAtuMoedas | Autor: Celso Ferrone Martins | Data: 14/10/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function fAtuMoedas()

Local cFile
Local cTexto
Local dDataRef := date() - 1
Local dData    := cTod("  /  /  ")

ConOut('ponto 1')


//Feriados Bancario Fixo
If ( Dtos(dDataRef) == STR(Year(Date()),4)+'0101' )		//Dia Mundial da Paz
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0421'	//Dia de Tradentes
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0501'	//Dia do Trabalho
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0907'	//Dia da Independencia
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1012'	//Dia da N. Sra. Aparecida
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1102'	//Dia de Finados
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1115'	//Dia da Proclamacao da Republica
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1225'	//Natal
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1231'	//Dia sem Expediente Bancario //Feriado Bancario Variavel 2007. Rever Anualmente
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0219'	//Segunda de Carnaval
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0220'	//Terca de Carnaval
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0406'	//Sexta-Feira da Paixao
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0607'	//Corpus Christi
	cFile := Dtos(dDataRef - 1)+'.csv'
ElseIf	Dow(dDataRef) == 1								//Se for domingo
	cFile := Dtos(dDataRef - 2)+'.csv'
ElseIf	Dow(dDataRef) == 7  			   				//Se for sabado
	cFile := Dtos(dDataRef - 1)+'.csv'
Else						   							//Se for dia normal
	cFile := Dtos(dDataRef)+'.csv'
EndIf
ConOut('ponto 2')

cTexto  := HttpGet('http://www4.bcb.gov.br/Download/fechamento/'+cFile)
ConOut('ponto 3')

If lAuto
	ConOut('DownLoading from http://www4.bcb.gov.br/Download/fechamento/'+cFile+' In '+Dtoc(DATE()))
EndIf

//INICIO - Busca o valor da Taxa de Aplicacao DI
FTPConnect("ftp.cetip.com.br")   //Acessa a pagina FTP
FTPDirChange('MediaCDI')         //Acessa a pasta do FTP
cStartPath	:= GetSrvProfString('Startpath','') // Conteudo contido no appserver Startpath
//FTPDownload(caminho e nome do arquivo a ser gravado na maquina (se apenas informar o nome, sera gravado no Startpath),nome do arquivo no FTP)

If Dow(dDataRef) == 2		//Se for segunda
	xFile := Dtos(dDataRef - 3)+'.txt'
Else
	xFile := cFile
	xFile := StrTran(xFile,".csv",".txt")
Endif

FTPDownload(cStartPath+xFile,xFile)
FTPDisconnect()
xPath := cStartPath+xFile

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

If File(xPath)  							// Se o Arquivo Existir, Processa-lo
	aStruct := {}
	Aadd(aStruct, {"EDI", "C", 009, 0})
	cArqTRB := CriaTrab(aStruct, .T.)
	DbUseArea(.T.,, cArqTRB, "TRB", .T., .F.)
	Append From &xPath. SDF                // Converter TXT p/ DBF (Appendar Registros)
	
	DbSelectArea("TRB")
	DbGoTop()
	FErase(cFile) //Apaga arquivo do StartPath
	
	TRB->(DbCloseArea())
Endif
//FIM

If !Empty(cTexto)  //Se existe o arquivo
	nLinhas := MLCount(cTexto, 81)
	For nX	:= 1 to nLinhas
		cLinha	:= Memoline(cTexto,81,nX)
		cData  	:= Substr(cLinha,1,10)
		cCompra := StrTran(Substr(cLinha,22,10),',','.')//Caso a empresa use o Valor de Compra nas linhas abaixo substitua por esta variavel
		cVenda  := StrTran(Substr(cLinha,33,10),',','.')//Para conversao interna nas empresas normalmente usa-se Valor de Venda
		
		If Substr(cLinha,12,3)=='220'	//Seleciona o Valor do Dolar EUA
			dData		:= Ctod(cData)
			nValDolar	:= Val(cVenda)
		EndIf
		
	Next nX
Else
	Return //Caso nao foi liberado o arquivo o sistema finaliza a rotina.
Endif

GravaDados()			//Grava Dados do PerÌodo selecionado

If Dow(dDataRef) == 2	//Se for segunda
	xSabDom := .T.
	xData := Date()
	For Nx := 1 to 2
		xData--
		GravaDados()	//Grava os Valores de Sabado e Domingo
	Next nX
EndIf

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: GravaDados | Autor: Celso Ferrone Martins | Data: 14/10/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Grava Moedas                                               |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

Static Function GravaDados()

DbSelectArea("SM2") ; DbSetorder(1)

If xSabDom							//Se for segunda grava sabado e domingo
	If SM2->(DbSeek(DTOS(xData)))
		RecLock("SM2", .F.) 		//Para alterar
	Else
		Reclock("SM2",.T.)  		//Para incluir
		SM2->M2_DATA := xData
	EndIf
Else
	If SM2->(DbSeek(DTOS(Date())))
		RecLock("SM2", .F.) 		//Para alterar
	Else
		Reclock("SM2",.T.)  		//Para incluir
		SM2->M2_DATA := Date()
	EndIf
Endif
SM2->M2_MOEDA1	:= nValReal			//Real
SM2->M2_MOEDA2	:= nValDolar		//Dolar
SM2->M2_MOEDA3	:= nValUfir			//Ufir
SM2->M2_INFORM	:= "S"
SM2->(MsUnLock())

Return()
