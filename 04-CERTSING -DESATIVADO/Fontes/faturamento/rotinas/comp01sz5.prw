#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ-ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³COMP01SZ5      ³ Autor ³ MICROSIGA        ³ Data ³ 12/12/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Principal                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gestao Hospitalar                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function COMP01SZ5()

cArqEmp 					:= "SigaMat.Emp"
__cInterNet 	:= Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
Private nModulo 	:= 51 // modulo SIGAHSP

Set Dele On

lEmpenho				:= .F.
lAtuMnu					:= .F.

Processa({|| ProcATU()},"Processando [COMP01SZ5]","Aguarde , processando preparação dos arquivos")

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcATU   ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Baseado na funcao criada por Eduardo Riera em 01/02/2002   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcATU()
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0
Local aRecnoSM0 	:= {}
Local lOpen     	:= .F.

ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")
If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))

	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0
			Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
		dbSkip()
	EndDo	

	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
 		nModulo := 51 // modulo SIGAHSP
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua(8)

			Begin Transaction

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GeraSX3()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os gatilhos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Gatilhos...")
			cTexto += GeraSX7()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando arquivos de índices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
			cTexto += GeraSIX()

			End Transaction
	
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				dbSelectArea(aArqUpd[nx])
			Next nX		

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
		 EndIf
		Next nI
		
		If lOpen
			
			cTexto 				:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [COMP01SZ5] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
	
		EndIf
		
	EndIf
		
EndIf 	

Return(Nil)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0Ex()

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit	
	EndIf
	Sleep( 500 )
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
EndIf

Return( lOpen )




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX3  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX3()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SZ5","01","Z5_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZ5","02","Z5_PEDGAR","C",07,00,"PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","03","Z5_DATPED","D",08,00,"DataPedGAR","DataPedGAR","DataPedGAR","DatapedidoGAR","DatapedidoGAR","DatapedidoGAR","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","04","Z5_EMISSAO","D",08,00,"Emissao","Emissao","Emissao","Emissao","Emissao","Emissao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","05","Z5_RENOVA","D",08,00,"DtRenovacao","DtRenovacao","DtRenovacao","DatadaRenovacao","DatadaRenovacao","DatadaRenovacao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","06","Z5_REVOGA","D",08,00,"DtRevogacao","DtRevogacao","DtRevogacao","DatadeRevogacao","DatadeRevogacao","DatadeRevogacao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","07","Z5_DATVAL","D",08,00,"DtValidacao","DtValidacao","DtValidacao","DatadeValidacao","DatadeValidacao","DatadeValidacao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","08","Z5_HORVAL","C",05,00,"HoraValidac","HoraValidac","HoraValidac","HoraValidacao","HoraValidacao","HoraValidacao","99:99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","09","Z5_CNPJ","C",14,00,"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF","CNPJdoCertificado","CNPJdoCertificado","CNPJdoCertificado","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","V","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","10","Z5_CNPJCER","C",14,00,"CNPJ/CPFCer","CNPJ/CPFCer","CNPJ/CPFCer","CNPJ/CPFCertificado","CNPJ/CPFCertificado","CNPJ/CPFCertificado","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","10","Z5_CNPJV","N",14,00,"CnpjValid","CnpjValid","CnpjValid","CnpjdaValidacao","CnpjdaValidacao","CnpjdaValidacao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","11","Z5_NOMREC","C",100,00,"NomeCertifi","NomeCertifi","NomeCertifi","NomeCertificado","NomeCertificado","NomeCertificado","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","11","Z5_RSVALID","C",100,00,"RazaoSocial","RazaoSocial","RazaoSocial","RazaoSocialdoCertifica","RazaoSocialdoCertifica","RazaoSocialdoCertifica","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","12","Z5_DATPAG","D",08,00,"DataPagto","DataPagto","DataPagto","DataPagto","DataPagto","DataPagto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","13","Z5_VALOR","N",12,02,"Valor","Valor","Valor","Valor","Valor","Valor","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","16","Z5_TIPMOV","C",01,00,"FormaPagto","FormaPagto","FormaPagto","FormaPagto","FormaPagto","FormaPagto","9","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","17","Z5_NTITULA","C",100,00,"NomeTitular","NomeTitular","NomeTitular","NomedoTitulardoCertif","NomedoTitulardoCertif","NomedoTitulardoCertif","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","19","Z5_STATUS","C",01,00,"Status","Status","Status","Status","Status","Status","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","1=Validacao;2-Renovacao","1=Validacao;2-Renovacao","1=Validacao;2-Renovacao","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","20","Z5_GARANT","C",10,00,"PedGARante","PedGARante","PedGARante","PedGARanterior","PedGARanterior","PedGARanterior","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","21","Z5_CODAR","C",20,00,"CodigoARV","CodigoARV","CodigoARV","CodigoARValidacao","CodigoARValidacao","CodigoARValidacao","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","22","Z5_DESCAR","C",100,00,"DescricARV","DescricARV","DescricARV","DescricARValidacao","DescricARValidacao","DescricARValidacao","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","23","Z5_CODPOS","C",20,00,"CodigoPosto","CodigoPosto","CodigoPosto","CodigoPostoValidacao","CodigoPostoValidacao","CodigoPostoValidacao","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","24","Z5_DESPOS","C",100,00,"DescriPosto","DescriPosto","DescriPosto","DescricaodoPosto","DescricaodoPosto","DescricaodoPosto","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","25","Z5_CODAGE","C",20,00,"CodAgente","CodAgente","CodAgente","CodigodoAgente","CodigodoAgente","CodigodoAgente","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","26","Z5_NOMAGE","C",100,00,"NomeAgente","NomeAgente","NomeAgente","NomeAgente","NomeAgente","NomeAgente","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","27","Z5_CPFAGE","C",14,00,"CPFAgente","CPFAgente","CPFAgente","CPFAgente","CPFAgente","CPFAgente","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","28","Z5_CERTIF","C",20,00,"Certificado","Certificado","Certificado","Certificado","Certificado","Certificado","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","29","Z5_CODAC","C",20,00,"CodAC","CodAC","CodAC","CoddaACdePedido","CoddaACdePedido","CoddaACdePedido","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","30","Z5_PRODUTO","C",20,00,"Produto","Produto","Produto","Produto","Produto","Produto","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","31","Z5_DESCAC","C",100,00,"DescrAC","DescrAC","DescrAC","DescdaACdePedido","DescdaACdePedido","DescdaACdePedido","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","32","Z5_DESPRO","C",100,00,"Descricao","Descricao","Descricao","Descricao","Descricao","Descricao","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","33","Z5_CODARP","C",20,00,"CodARPed","CodARPed","CodARPed","CoddaARdoPedido","CoddaARdoPedido","CoddaARdoPedido","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","34","Z5_GRUPO","C",20,00,"Grupo","Grupo","Grupo","Grupo","Grupo","Grupo","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","35","Z5_DESCARP","C",100,00,"DescARPed","DescARPed","DescARPed","DescdaARdoPedido","DescdaARdoPedido","DescdaARdoPedido","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","36","Z5_DESGRU","C",100,00,"DescrGrupo","DescrGrupo","DescrGrupo","DescrGrupo","DescrGrupo","DescrGrupo","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","37","Z5_TIPVOU","C",09,00,"TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","38","Z5_CODVOU","C",20,00,"CodVoucher","CodVoucher","CodVoucher","CodVoucher","CodVoucher","CodVoucher","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","39","Z5_COMISS","C",01,00,"Comissao","Comissao","Comissao","Controledecomissao","Controledecomissao","Controledecomissao","","PERTENCE('1')","€€€€€€€€€€€€€€ ","'1'","",00,"şÀ","","","U","N","A","R","","","1=AGerar;2=Gerado;3=Pago","1=AGerar;2=Gerado;3=Pago","1=AGerar;2=Gerado;3=Pago","","M->Z5_COMISS<>'3'","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","40","Z5_OBSCOM","C",100,00,"ObsComissao","ObsComissao","ObsComissao","Obsdefalhaaogerarcom","Obsdefalhaaogerarcom","Obsdefalhaaogerarcom","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","41","Z5_REDE","C",100,00,"Rede","Rede","Rede","NomedaRededeValidacao","NomedaRededeValidacao","NomedaRededeValidacao","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","42","Z5_PRODGAR","C",20,00,"ProdutoGar","ProdutoGar","ProdutoGar","CodigoProdutoGAR","CodigoProdutoGAR","CodigoProdutoGAR","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","43","Z5_NOMECLI","C",100,00,"NomeCliente","NomeCliente","NomeCliente","NomeClientedaFatura","NomeClientedaFatura","NomeClientedaFatura","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","44","Z5_CNPJFAT","C",14,00,"CNPJ/CPFFAT","CNPJ/CPFFAT","CNPJ/CPFFAT","CNPJ/CPFdaFatura","CNPJ/CPFdaFatura","CNPJ/CPFdaFatura","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","45","Z5_EMAIL","C",50,00,"Email","Email","Email","Emailtitular","Emailtitular","Emailtitular","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","46","Z5_CODVEND","C",20,00,"CodRevendor","CodRevendor","CodRevendor","CoddoRevendedor","CoddoRevendedor","CoddoRevendedor","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","47","Z5_NOMVEND","C",100,00,"NomeRevend","NomeRevend","NomeRevend","NomedoRevendedor","NomedoRevendedor","NomedoRevendedor","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","48","Z5_COMSW","N",07,04,"%ComSW","%ComSW","%ComSW","%ComissaoSoftware","%ComissaoSoftware","%ComissaoSoftware","@999.9999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","49","Z5_COMHW","N",06,04,"%ComHW","%ComHW","%ComHW","%ComissaoHardware","%ComissaoHardware","%ComissaoHardware","@999.9999","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","50","Z5_VALORSW","N",12,02,"ValordoSW","ValordoSW","ValordoSW","ValordoSW","ValordoSoftware","ValordoSoftware","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","51","Z5_VALORHW","N",12,02,"ValorHW","ValorHW","ValorHW","ValordoHardware","ValordoHardware","ValordoHardware","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","52","Z5_TIPO","C",06,00,"TipodeRem","TipodeRem","TipodeRem","TipodeMovdeRemuneca","TipodeMovdeRemuneca","TipodeMovdeRemuneca","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","VALIDA=Validacao;RENOVA=Renovacao;CLUBRE=ClubedoRevendedor;CAMPCO=CampanhadoContador;HWAVUL=HardwareAvulso","VALIDA=Validacao;RENOVA=Renovacao;CLUBRE=ClubedoRevendedor;CAMPCO=CampanhadoContador;HWAVUL=HardwareAvulso","VALIDA=Validacao;RENOVA=Renovacao;CLUBRE=ClubedoRevendedor;CAMPCO=CampanhadoContador;HWAVUL=HardwareAvulso","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","53","Z5_FLAGA","C",01,00,"FlagAtu","FlagAtu","FlagAtu","FlagdeAtualizacao","FlagdeAtualizacao","FlagdeAtualizacao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","54","Z5_CPFT","C",11,00,"CPFTitular","CPFTitular","CPFTitular","CPFTitularCertificado","CPFTitularCertificado","CPFTitularCertificado","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","55","Z5_DESCST","C",20,00,"DescStatus","DescStatus","DescStatus","DescStatus","DescStatus","DescStatus","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","55","Z5_PEDIDO","C",06,00,"PedidoVenda","PedidoVenda","PedidoVenda","PedidoVendaProtheus","PedidoVendaProtheus","PedidoVendaProtheus","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","56","Z5_CODPAR","C",20,00,"CodParceiro","CodParceiro","CodParceiro","CodigodoParceiro","CodigodoParceiro","CodigodoParceiro","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","57","Z5_NOMPAR","C",60,00,"NomeParceir","NomeParceir","NomeParceir","NomeParceir","NomedoParceiro","NomedoParceiro","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","58","Z5_ITEMPV","C",02,00,"ITEMPV","ITEMPV","ITEMPV","ItemdoPedidodeVenda","ItemdoPedidodeVenda","ItemdoPedidodeVenda","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","59","Z5_TIPODES","C",30,00,"DescTipo","DescTipo","DescTipo","DescTipodeMovRP","DescTipodeMovRP","DescTipodeMovRP","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZ5","60","Z5_PEDGANT","C",07,00,"PedGARAnter","PedGARAnter","PedGARAnter","PedidoGARAnterior","PedidoGARAnterior","PedidoGARAnterior","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZG","01","ZG_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZG","02","ZG_CODFLU","C",08,00,"CodigoFluxo","CodigoFluxo","CodigoFluxo","CodigoFluxo","CodigoFluxo","CodigoFluxo","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","03","ZG_NUMVOUC","C",12,00,"NumVoucher","NumVoucher","NumVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","€€€€€€€€€€€€€€ ","","SZF",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","04","ZG_NUMPED","C",06,00,"NumPedido","NumPedido","NumPedido","NumerodoPedidoProtheus","NumerodoPedidoProtheus","NumerodoPedidoProtheus","@X","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","05","ZG_ITEMPED","C",02,00,"ItemPedido","ItemPedido","ItemPedido","ItemdoPedido","ItemdoPedido","ItemdoPedido","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","06","ZG_QTDSAI","N",09,02,"Quantidade","Quantidade","Quantidade","Quantidadesaida","Quantidadesaida","Quantidadesaida","@E999999.99","","€€€€€€€€€€€€€€ ","0","",00,"şÀ","","","U","S","A","R","€","Positivo()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","07","ZG_PEDIDO","C",06,00,"PedidoGAR","PedidoGAR","PedidoGAR","NumerodoPedidoGAR","NumerodoPedidoGAR","NumerodoPedidoGAR","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","08","ZG_NFSER","C",12,00,"NFServico","NFServico","NFServico","Serie+numeroNFServico","Serie+numeroNFServico","Serie+numeroNFServico","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","09","ZG_NFPROD","C",12,00,"NFProduto","NFProduto","NFProduto","Serie+NumeroNFProduto","Serie+NumeroNFProduto","Serie+NumeroNFProduto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","10","ZG_NFENT","C",12,00,"NFEntrega","NFEntrega","NFEntrega","Serie+NumeroNFEntrega","Serie+NumeroNFEntrega","Serie+NumeroNFEntrega","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","11","ZG_NUMEST","C",09,00,"Mov.Interna","Mov.Interna","Mov.Interna","MovimentacaoInternaEst.","MovimentacaoInternaEst.","MovimentacaoInternaEst.","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","12","ZG_DATAMOV","D",08,00,"DataMov","DataMov","DataMov","DatadoMovimento","DatadoMovimento","DatadoMovimento","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","13","ZG_ROTINA","C",15,00,"RotinaMov","RotinaMov","RotinaMov","RotinaqueMovimentou","RotinaqueMovimentou","RotinaqueMovimentou","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","14","ZG_GRPROJ","C",10,00,"GrupoProjet","GrupoProjet","GrupoProjet","GrupodoProjeto","GrupodoProjeto","GrupodoProjeto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","15","ZG_TITULAR","C",30,00,"Titular","Titular","Titular","TitulardoCertificado","TitulardoCertificado","TitulardoCertificado","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","16","ZG_SEQVOUC","C",11,00,"SEQVOUC","SEQVOUC","SEQVOUC","SEQVOUC","SEQVOUC","SEQVOUC","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZF","01","ZF_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZF","02","ZF_CODFLU","C",07,00,"CodFluxo","CodFluxo","CodFluxo","CodigodoFluxo","CodigodoFluxo","CodigodoFluxo","","","€€€€€€€€€€€€€€ ","GETSXENUM('SZF','ZF_CODFLU')","",00,"şÀ","","","U","S","V","R","","NaoVazio().And.ExistChav('SZF')","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","03","ZF_QTDFLUX","N",05,00,"QtdVouchers","QtdVouchers","QtdVouchers","QuantidadedeVouchers","QuantidadedeVouchers","QuantidadedeVouchers","@E999999","","€€€€€€€€€€€€€€ ","000001","",00,"şÀ","","","U","N","A","V","","positivo()","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","04","ZF_COD","C",12,00,"Cod.Voucher","Cod.Voucher","Cod.Voucher","CodigodoVoucher","CodigodoVoucher","CodigodoVoucher","","","€€€€€€€€€€€€€€ ","U_NUMVOU()","",00,"şÀ","","","U","S","V","R","€","NaoVazio().And.ExistChav('SZF')","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","05","ZF_USRSOL","C",25,00,"UsrSolicita","UsrSolicita","UsrSolicita","UsuarioSolicitante","UsuarioSolicitante","UsuarioSolicitante","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","06","ZF_DATCRI","D",08,00,"DataCriacao","DataCriacao","DataCriacao","DatadeCriacao","DatadeCriacao","DatadeCriacao","@D","","€€€€€€€€€€€€€€ ","DDATABASE","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","07","ZF_HORCRI","C",08,00,"HoraCriacao","HoraCriacao","HoraCriacao","HoradeCriacao","HoradeCriacao","HoradeCriacao","99:99:99","","€€€€€€€€€€€€€€ ","TIME()","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","08","ZF_DTVALID","D",08,00,"Val.Voucher","Val.Voucher","Val.Voucher","ValidadedoVoucher","ValidadedoVoucher","ValidadedoVoucher","@D","M->ZF_DTVALID>=DDATABASE","€€€€€€€€€€€€€€ ","DDATABASE+365","",00,"şÀ","","","U","S","V","R","€","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","09","ZF_TIPOVOU","C",01,00,"TipoVoucher","TipoVoucher","TipoVoucher","TipodeVoucher","TipodeVoucher","TipodeVoucher","@!","","€€€€€€€€€€€€€€ ","","SZH",00,"şÀ","","S","U","S","A","R","€","U_ValTipUser(M->ZF_USERCOD,M->ZF_TIPOvOU)","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","10","ZF_DESTIPO","C",30,00,"DescTipo","DescTipo","DescTipo","DescricaodotipodeVouc","DescricaodotipodeVouc","DescricaodotipodeVouc","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","11","ZF_PRODEST","C",15,00,"Produto","Produto","Produto","Produtodestino","Produtodestino","Produtodestino","@!","","€€€€€€€€€€€€€€ ","","ALT",00,"şÀ","","S","U","N","A","R","€","existcpo('SB1')","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","12","ZF_PRODESC","C",30,00,"DescProduto","DescProduto","DescProduto","DescricaodoProduto","DescricaodoProduto","DescricaodoProduto","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","13","ZF_PDESGAR","C",20,00,"ProdutoGar","ProdutoGar","ProdutoGar","ProdutoGar","ProdutoGar","ProdutoGar","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","14","ZF_MOTOCO","C",06,00,"MotOcorrenc","MotOcorrenc","MotOcorrenc","MotivoOcorrencia","MotivoOcorrencia","MotivoOcorrencia","@!","","€€€€€€€€€€€€€€ ","","ZF",00,"şÀ","","S","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","15","ZF_DESMOT","C",30,00,"DescMotivo","DescMotivo","DescMotivo","DescricaoMotivo","DescricaoMotivo","DescricaoMotivo","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","16","ZF_VALID","C",01,00,"Validacao","Validacao","Validacao","Comoseraavalidacao","Comoseraavalidacao","Comoseraavalidacao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","A=Presencial;B=Posto","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","17","ZF_PEDIDO","C",10,00,"PedGAROrig","PedGAROrig","PedGAROrig","PedGAROrigem","PedGAROrigem","PedGAROrigem","@X","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","S","U","S","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","18","ZF_CDPRGAR","C",20,00,"CdProdGAR","CdProdGAR","CdProdGAR","CodigoProdutoGAR","CodigoProdutoGAR","CodigoProdutoGAR","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","S","U","N","A","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","19","ZF_PRODUTO","C",15,00,"ProdutoOrig","Produto","Produto","CodigodoProdutoOrigem","CodigodoProdutoOrigem","CodigodoProdutoOrigem","@!","vazio().or.existCpo('SB1')","€€€€€€€€€€€€€€ ","","ALT",00,"şÀ","","S","U","S","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","20","ZF_DESPRO","C",30,00,"DescProdOr","DescProdOr","DescProdOr","DescricaodoProduto","DescricaodoProduto","DescricaodoProduto","@!","","€€€€€€€€€€€€€€ ","IF(!INCLUI,POSICIONE('SB1',1,XFILIAL('SB1')+SZF->ZF_PRODUTO,'B1_DESC'),'')","",00,"şÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","21","ZF_QTDVOUC","N",09,02,"Quantidade","Quantidade","Quantidade","QuantidadedoVoucher","QuantidadedoVoucher","QuantidadedoVoucher","@E999999.99","","€€€€€€€€€€€€€€ ","1","",00,"şÀ","","","U","N","V","R","","Positivo()","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","22","ZF_CDORATE","C",06,00,"CodOriAten","CodOriAten","CodOriAten","CodigoOrigemAtendimento","CodigoOrigemAtendimento","CodigoOrigemAtendimento","","","€€€€€€€€€€€€€€ ","U_CarreAtend('ZF_CDORATE')","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","23","ZF_ORIATE","C",20,00,"OrigemAtend","OrigemAtend","OrigemAtend","OrigemdeAtendimento","OrigemdeAtendimento","OrigemdeAtendimento","@!","","€€€€€€€€€€€€€€ ","U_CarreAtend('ZF_ORIATE')","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","24","ZF_AC","C",40,00,"AC","AC","AC","AC","AC","AC","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","25","ZF_AR","C",40,00,"AR","AR","AR","AR","AR","AR","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","26","ZF_CODSTAT","C",02,00,"CodStatus","CodStatus","CodStatus","CodigodoStatus","CodigodoStatus","CodigodoStatus","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","27","ZF_STCERPD","C",30,00,"StCerPEDGA","StCerPEDGA","StCerPEDGA","StatusCertificadoPedGAR","StatusCertificadoPedGAR","StatusCertificadoPedGAR","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","28","ZF_REVREJ","C",01,00,"Revog/Rejeit","Revog/Rejeit","Revog/Rejeit","Revogado/Rejeitado","Revogado/Rejeitado","Revogado/Rejeitado","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","Vazio().OR.Pertence('12')","1=Revogado;2=Rejeitado","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","29","ZF_CGCCLI","C",14,00,"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF","CNPJ/CPFdocliente","CNPJ/CPFdocliente","CNPJ/CPFdocliente","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","30","ZF_NOMCLI","C",40,00,"NomeCliente","NomeCliente","NomeCliente","NomedoCliente","NomedoCliente","NomedoCliente","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","31","ZF_OBS","C",50,00,"Observacao","Observacao","Observacao","Observacao","Observacao","Observacao","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","32","ZF_DTVLPGO","D",08,00,"DtVlPDOri","DtVlPDOri","DtVlPDOri","DtVlPedGAROrigem","DtVlPedGAROrigem","DtVlPedGAROrigem","@D","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","33","ZF_GRPPROJ","C",10,00,"GrpProjeto","GrpProjeto","GrpProjeto","GrupodeProjeto","GrupodeProjeto","GrupodeProjeto","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","34","ZF_SALDO","N",09,02,"SldVoucher","SldVoucher","SldVoucher","SaldodoVoucher","SaldodoVoucher","SaldodoVoucher","@E999999.99","","€€€€€€€€€€€€€€ ","1","",00,"şÀ","","","U","S","V","R","","Positivo()","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","35","ZF_ATIVO","C",01,00,"Ativo","Ativo","Ativo","Ativo","Ativo","Ativo","@!","","€€€€€€€€€€€€€€ ","'S'","",00,"şÀ","","","U","S","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","36","ZF_NOTEMP","C",13,00,"NotaEmpenho","NotaEmpenho","NotaEmpenho","NotadeEmpenho","NotadeEmpenho","NotadeEmpenho","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","37","ZF_PEDIDOV","C",06,00,"PedidoVenda","PedidoVenda","PedidoVenda","PedidodeVendaProtheus","PedidodeVendaProtheus","PedidodeVendaProtheus","@X","","€€€€€€€€€€€€€€ ","","SC5",00,"şÀ","","","U","N","A","R","","vazio().or.existCpo('SC5')","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","38","ZF_TPOPP","C",06,00,"Tp.Op.Prod","Tp.Op.Prod","Tp.Op.Prod","TipoOperacaoProduto","TipoOperacaoProduto","TipoOperacaoProduto","@!","ExistCpo('SX5','DJ'+M->ZF_TPOPP)","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","38","ZF_OPORTUN","C",06,00,"Oportunidade","Oportunidade","Oportunidade","Oportunidade","Oportunidade","Oportunidade","@!","","€€€€€€€€€€€€€€ ","","AD1",00,"şÀ","","","U","N","A","R","","vazio().or.existCpo('AD1')","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","39","ZF_CONTRAT","C",15,00,"Contrato","Contrato","Contrato","NumerodoContrato","NumerodoContrato","NumerodoContrato","@X","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","","","","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","40","ZF_TPFATUR","C",01,00,"TpFaturamen","TpFaturamen","TpFaturamen","TipodeFaturamento","TipodeFaturamento","TipodeFaturamento","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","Vazio().Or.Pertence('AP')","A=Antecipado;P=Postecipado","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","41","ZF_EMNTVEN","C",01,00,"EmNotaVend","EmNotaVend","EmNotaVend","EmiteNotaVenda","EmiteNotaVenda","EmiteNotaVenda","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","44","ZF_ALBIVE","C",01,00,"ApeItVenda","ApeItVenda","ApeItVenda","ApenasLibItemVenda","ApenasLibItemVenda","ApenasLibItemVenda","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","45","ZF_EMNTENT","C",01,00,"EmNtEntreg","EmNtEntreg","EmNtEntreg","EmiteNotaEntrega","EmiteNotaEntrega","EmiteNotaEntrega","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","46","ZF_TPOPENT","C",06,00,"Tp.Op.Entr","Tp.Op.Entr","Tp.Op.Entr","TipoOperacaoEntrega","TipoOperacaoEntrega","TipoOperacaoEntrega","@!","ExistCpo('SX5','DJ'+M->ZF_TPOPENT)","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","47","ZF_ARQEST","C",01,00,"ApReqEstoq","ApReqEstoq","ApReqEstoq","ApenasRequisicaoEstoque","ApenasRequisicaoEstoque","ApenasRequisicaoEstoque","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","48","ZF_TPMOVIM","C",03,00,"TipoMovimen","TipoMovimen","TipoMovimen","TipoMovimentacao","TipoMovimentacao","TipoMovimentacao","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","49","ZF_FLAGSIT","C",01,00,"Jaenviado","Jaenviado","Jaenviado","Jaenviadoparaosite","Jaenviadoparaosite","Jaenviadoparaosite","@!","","€€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","50","ZF_PEDVEND","C",06,00,"PedVenOrig","PedVenOrig","PedVenOrig","PedidodeVendaOrigem","PedidodeVendaOrigem","PedidodeVendaOrigem","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","51","ZF_NFVENOR","C",13,00,"NFVendOrig","NFVendOrig","NFVendOrig","NFdeVendadeOrigem","NFdeVendadeOrigem","NFdeVendadeOrigem","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","52","ZF_NFSEROR","C",13,00,"NFServOrig","NFServOrig","NFServOrig","NFdeServicodeOrigem","NFdeServicodeOrigem","NFdeServicodeOrigem","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","53","ZF_NFENTOR","C",13,00,"NFEntOrig","NFEntOrig","NFEntOrig","NFdeEntregadeOrigem","NFdeEntregadeOrigem","NFdeEntregadeOrigem","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","4","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","54","ZF_USERCOD","C",06,00,"CodUsuario","CodUsuario","CodUsuario","CodigodoUsuario","CodigodoUsuario","CodigodoUsuario","","","€€€€€€€€€€€€€€ ","__CUSERID","",00,"şÀ","","","U","N","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","55","ZF_USERNAM","C",25,00,"NomeUsuario","NomeUsuario","NomeUsuario","NomedoUsuario","NomedoUsuario","NomedoUsuario","","","€€€€€€€€€€€€€€ ","CUSERNAME","",00,"şÀ","","","U","S","V","R","","","","","","","","","","1","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","56","ZF_MIDIA","C",01,00,"MidiaPerson","MidiaPerson","MidiaPerson","MidiaPersonalizada","MidiaPersonalizada","MidiaPersonalizada","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","S=Sim;N=Nao","","","","","","","2","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZF","57","ZF_TPOPSER","C",06,00,"Tp.Op.Serv","Tp.Op.Serv","Tp.Op.Serv","TipoOpercaoServico","TipoOpercaoServico","TipoOpercaoServico","@!","ExistCpo('SX5','DJ'+M->ZF_TPOPSER)","€€€€€€€€€€€€€€","","",00,"şÀ","","","U","N","V","R","","","","","","","","","","3","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","01","ZG_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZG","02","ZG_CODFLU","C",08,00,"CodigoFluxo","CodigoFluxo","CodigoFluxo","CodigoFluxo","CodigoFluxo","CodigoFluxo","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","03","ZG_NUMVOUC","C",12,00,"NumVoucher","NumVoucher","NumVoucher","NumerodoVoucher","NumerodoVoucher","NumerodoVoucher","@!","","€€€€€€€€€€€€€€ ","","SZF",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","04","ZG_NUMPED","C",06,00,"NumPedido","NumPedido","NumPedido","NumerodoPedidoProtheus","NumerodoPedidoProtheus","NumerodoPedidoProtheus","@X","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","05","ZG_ITEMPED","C",02,00,"ItemPedido","ItemPedido","ItemPedido","ItemdoPedido","ItemdoPedido","ItemdoPedido","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","06","ZG_QTDSAI","N",09,02,"Quantidade","Quantidade","Quantidade","Quantidadesaida","Quantidadesaida","Quantidadesaida","@E999999.99","","€€€€€€€€€€€€€€ ","0","",00,"şÀ","","","U","S","A","R","€","Positivo()","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","07","ZG_PEDIDO","C",06,00,"PedidoGAR","PedidoGAR","PedidoGAR","NumerodoPedidoGAR","NumerodoPedidoGAR","NumerodoPedidoGAR","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","08","ZG_NFSER","C",12,00,"NFServico","NFServico","NFServico","Serie+numeroNFServico","Serie+numeroNFServico","Serie+numeroNFServico","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","09","ZG_NFPROD","C",12,00,"NFProduto","NFProduto","NFProduto","Serie+NumeroNFProduto","Serie+NumeroNFProduto","Serie+NumeroNFProduto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","10","ZG_NFENT","C",12,00,"NFEntrega","NFEntrega","NFEntrega","Serie+NumeroNFEntrega","Serie+NumeroNFEntrega","Serie+NumeroNFEntrega","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","11","ZG_NUMEST","C",09,00,"Mov.Interna","Mov.Interna","Mov.Interna","MovimentacaoInternaEst.","MovimentacaoInternaEst.","MovimentacaoInternaEst.","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","12","ZG_DATAMOV","D",08,00,"DataMov","DataMov","DataMov","DatadoMovimento","DatadoMovimento","DatadoMovimento","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","13","ZG_ROTINA","C",15,00,"RotinaMov","RotinaMov","RotinaMov","RotinaqueMovimentou","RotinaqueMovimentou","RotinaqueMovimentou","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","14","ZG_GRPROJ","C",10,00,"GrupoProjet","GrupoProjet","GrupoProjet","GrupodoProjeto","GrupodoProjeto","GrupodoProjeto","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","15","ZG_TITULAR","C",30,00,"Titular","Titular","Titular","TitulardoCertificado","TitulardoCertificado","TitulardoCertificado","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZG","16","ZG_SEQVOUC","C",11,00,"SEQVOUC","SEQVOUC","SEQVOUC","SEQVOUC","SEQVOUC","SEQVOUC","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","V","V","","","","","","","","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","01","ZH_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"şÀ","","","U","N","","","","","","","","","","","033","","","","","","","","","N","N","N"})
AADD(aRegs,{"SZH","02","ZH_TIPO","C",01,00,"TipoVoucher","TipoVoucher","TipoVoucher","TipodeVoucher","TipodeVoucher","TipodeVoucher","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","ExistChav('SZH',M->ZH_TIPO)","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","03","ZH_DESCRI","C",30,00,"DesTipoVou","DesTipoVou","DesTipoVou","DescricaoTipoVoucher","DescricaoTipoVoucher","DescricaoTipoVoucher","@!","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","04","ZH_EMNTVEN","C",01,00,"Em.NFVenda","Em.NFVenda","Em.NFVenda","EmiteNFVenda","EmiteNFVenda","EmiteNFVenda","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","Pertence('SPAN')","S=Servico;P=Produto;A=Ambos;N=NaoEmite","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","05","ZH_TPOPSER","C",06,00,"Tp.Op.Serv","Tp.Op.Serv","Tp.Op.Serv","TipoOperacaoServ.","TipoOperacaoServ.","TipoOperacaoServ.","@!","ExistCpo('SX5','DJ'+M->ZH_TPOPSER)","€€€€€€€€€€€€€€ ","","DJ",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","06","ZH_TPOPP","C",06,00,"Tp.Op.Prod","Tp.Op.Prod","Tp.Op.Prod","TipoOperacaoProduto","TipoOperacaoProduto","TipoOperacaoProduto","@!","ExistCpo('SX5','DJ'+M->ZH_TPOPP)","€€€€€€€€€€€€€€ ","","DJ",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","07","ZH_ALBIVE","C",01,00,"Lib.Item","Lib.Item","Lib.Item","Apenasliberaitemvenda","Apenasliberaitemvenda","Apenasliberaitemvenda","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","08","ZH_EMNTENT","C",01,00,"Em.NFEnt.","Em.NFEnt.","Em.NFEnt.","EmiteNFdeEntrega","EmiteNFdeEntrega","EmiteNFdeEntrega","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","09","ZH_TPOPENT","C",06,00,"Tp.Op.Entr","Tp.Op.Entr","Tp.Op.Entr","TipoOperacaoEntrega","TipoOperacaoEntrega","TipoOperacaoEntrega","@!","ExistCpo('SX5','DJ'+M->ZH_TPOPENT)","€€€€€€€€€€€€€€ ","","DJ",00,"şÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","10","ZH_ARQEST","C",01,00,"Req.Est.","Req.Est.","Req.Est.","ApenasRequisicaoestoque","ApenasRequisicaoestoque","ApenasRequisicaoestoque","","","€€€€€€€€€€€€€€ ","","",00,"şÀ","","","U","N","A","R","€","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","N","N","N"})
AADD(aRegs,{"SZH","11","ZH_TPMOVIM","C",03,00,"TipodeMov.","TipodeMov.","TipodeMov.","TipodeMovimentacao","TipodeMovimentacao","TipodeMovimentacao","","","€€€€€€€€€€€€€€ ","","SF5",00,"şÀ","","","U","N","A","R","","vazio().or.existCpo('SF5')","","","","","M->ZH_ARQEST=='S'","","","","","","","","N","N","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX7  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX7()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"ZF_QTDVOUC","001","M->ZF_QTDVOUC                                                                                       ","ZF_SALDO  ","P","N","   ",00,"                                                                                                    ","                                        ","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_PEDIDO","001","U_VeriPedGAR('ZF_AC',M->ZF_PEDIDO)","ZF_AC","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","002","U_VeriPedGAR('ZF_AR',M->ZF_PEDIDO)","ZF_AR","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","003","U_VeriPedGAR('ZF_CDPRGAR',M->ZF_PEDIDO)","ZF_CDPRGAR","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","004","U_VeriPedGAR('ZF_CGCCLI',M->ZF_PEDIDO)","ZF_CGCCLI","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","005","U_VeriPedGAR('ZF_NOMCLI',M->ZF_PEDIDO)","ZF_NOMCLI","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","006","U_VeriPedGAR('ZF_DTVLPGO',M->ZF_PEDIDO)","ZF_DTVLPGO","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","007","U_GetPedido(M->ZF_PEDIDO)","ZF_PEDVEND","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","008","U_GetNFVou(M->ZF_PEDIDO,'52')","ZF_NFVENOR","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","009","U_GetNFVou(M->ZF_PEDIDO,'51')","ZF_NFSEROR","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","010","U_GetNFVou(M->ZF_PEDIDO,'53')","ZF_NFENTOR","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","011","U_VeriPedGAR('ZF_CODSTAT',M->ZF_PEDIDO)","ZF_CODSTAT","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_PEDIDO","012","U_VeriPedGAR('ZF_STCERPD',M->ZF_PEDIDO)","ZF_STCERPD","P","N","",00,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_CDPRGAR","001","PA8->PA8_CODMP8","ZF_PRODUTO","P","S","PA8",01,"xFilial('PA8')+M->ZF_CDPRGAR","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_PRODUTO","001","SB1->B1_DESC","ZF_DESPRO","P","S","SB1",01,"xFilial('SB1')+M->ZF_PRODUTO","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_MOTOCO","001","X5DESCRI()","ZF_DESMOT","P","S","SX5",01,"xFilial('SX5')+'ZF'+M->ZF_MOTOCO","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_PRODEST","001","SB1->B1_DESC","ZF_PRODESC","P","S","SB1",01,"xFilial('SB1')+M->ZF_PRODEST","","U"})
AADD(aRegs,{"ZF_PRODEST","002","PA8->PA8_CODBPG","ZF_PDESGAR","P","S","PA8",02,"xFilial('PA8')+M->ZF_PRODEST","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"ZF_TIPOVOU","001","SZH->ZH_DESCRI","ZF_DESTIPO","P","S","SZH",01,"xFilial('SZH')+M->ZF_TIPOVOU","","U"})
AADD(aRegs,{"ZF_TIPOVOU","002","U_GatSZF('ZF_EMNTVEN')","ZF_EMNTVEN","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","003","U_GatSZF('ZF_TPOPSER')","ZF_TPOPSER","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","004","U_GatSZF('ZF_TPOPP')","ZF_TPOPP","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","005","U_GatSZF('ZF_ALBIVE')","ZF_ALBIVE","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","006","U_GatSZF('ZF_EMNTENT')","ZF_EMNTENT","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","007","U_GatSZF('ZF_TPOPENT')","ZF_TPOPENT","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","008","U_GatSZF('ZF_ARQEST')","ZF_ARQEST","P","N","",00,"","","U"})
AADD(aRegs,{"ZF_TIPOVOU","009","U_GatSZF('ZF_TPMOVIM')","ZF_TPMOVIM","P","N","",00,"","","U"})

dbSelectArea("SX7")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX7", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX7 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSIX  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSIX()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SZF","1","ZF_FILIAL+ZF_CODFLU+ZF_COD                                                                                                                                      ","Cod Fluxo+Cod. Voucher                                                ","Cod Fluxo+Cod. Voucher                                                ","Cod Fluxo+Cod. Voucher                                                ","U","                                                                                                                                                                ","          ","N"})
AADD(aRegs,{"SZF","2","ZF_FILIAL+ZF_COD                                                                                                                                                ","Cod. Filial+Cod. Voucher                                              ","Cod. Filial+Cod. Voucher                                              ","Cod. Filial+Cod. Voucher                                              ","U","                                                                                                                                                                ","          ","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZG","1","ZG_FILIAL+ZG_NUMPED+ZG_ITEMPED+ZG_NUMVOUC","NumPedido+ItemPedido+NumVoucher","NumPedido+ItemPedido+NumVoucher","NumPedido+ItemPedido+NumVoucher","U","","","N"})
AADD(aRegs,{"SZG","2","ZG_FILIAL+ZG_PEDIDO","Filial+PedidoGAR","Filial+PedidoGAR","Filial+PedidoGAR","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZH","1","ZH_FILIAL+ZH_TIPO","CodTipoVou","CodTipoVou","CodTipoVou","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

aRegs  := {}
AADD(aRegs,{"SZ5","1","Z5_FILIAL+Z5_PEDGAR","PedidoGAR","PedidoGAR","PedidoGAR","U","","","S"})
AADD(aRegs,{"SZ5","2","Z5_FILIAL+Z5_FLAGA","FlagAtualiza","FlagAtualiza","FlagAtualiza","U","","","N"})
AADD(aRegs,{"SZ5","3","Z5_FILIAL+Z5_PEDIDO+Z5_ITEMPV","Pedido+item","Pedido+item","Pedido+item","U","","","N"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SIX : ' + cTexto  + CHR(13) + CHR(10))
