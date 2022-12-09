#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "RWMAKE.CH"
#INCLUDE "COLORS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTREPUSER  บAutor  ณThiago S. Oliveira  บ Data ณ  01/25/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de usuแrios e seus respectivos acessos.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


USER FUNCTION TREPUSER()
	Local oReport
	Private cPerg := "TREPUSER"
	private oTmpTable := nil 
	private cAliasTmp := getNextAlias()


	oReport := ReportDef()
	oReport:PrintDialog()


RETURN



STATIC FUNCTION ReportDef()
	Local oReport
	Local oSection1
	Local oSection2

	Pergunte( cPerg , .F. )

	oReport := TReport():New("TREPUSER","RELATORIO DE USUมRIOS",cPerg, {|oReport| IMPDADOS(oReport)},"Este relatorio ira imprimir a relacao de usuแrios e seus respectivos acessos.")
	oReport:SetLandscape()        // define o relat๓rio como paisagem
	oReport:cFontBody := 'Courier New'
	oReport:nFontBody := 8



	&& Impressใo
	oSection1 := TRSection():New(oReport,"USUมRIOS")
	//oSection1:SetHeaderSection(.F.) // Inibe Header

	TRCell():New(oSection1,"cUsuario","","Usuแrio","",10)//,"","","","","","","",""/*lAutoSize*/,)
	TRCell():New(oSection1,"cNome","","Nome","",10)

	TRCell():New(oSection1,"cNomeComp","","Nome Completo","",15)//,"","","","","","","",""/*lAutoSize*/,)
	TRCell():New(oSection1,"cDepto","","Departamento","",15)
	TRCell():New(oSection1,"cCargo","","Cargo","",15)
	TRCell():New(oSection1,"nAceSimu","","Acessos Simultaneos","",3)

	TRCell():New(oSection1,"dValidade","","Validade","",10)
	TRCell():New(oSection1,"bAltsen","","Altera senha","",3)
	TRCell():New(oSection1,"cSuperior","","Superior","",15)
	TRCell():New(oSection1,"cEmail","","E-mail","",15)
	TRCell():New(oSection1,"cBloque","","Bloqueado","",3)


	oSection2 := TRSection():New(oSection1,"Acessos")
	//oSection2:SetHeaderPage(.T.)
	oSection2:SetHeaderSection(.T.)

	TRCell():New(oSection2,"cModulo"	,"","M๓dulo","",15)
	TRCell():New(oSection2,"cTipoAces"	,"","Op็ใo do Menu","",10)
	TRCell():New(oSection2,"cPrograma"	,"","Rotina","",20)
	TRCell():New(oSection2,"cAcess"	,"","Acesso","",3)
	TRCell():New(oSection2,"cPesqR"	,"","Pesquisar","",3)
	TRCell():New(oSection2,"cVisuR"	,"","Visualizar","",3)
	TRCell():New(oSection2,"cAlterarR"	,"","Alterar","",3)
	TRCell():New(oSection2,"cExcluirR"	,"","Excluir","",3)



RETURN oReport




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPDADOS   บAutor  ณMicrosiga           บ Data ณ  01/23/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Impressใo do Relat๓rio de usuแrios                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


STATIC FUNCTION IMPDADOS( oReport )

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)

	local _cAlias	:= Alias()
	local _cMenu :=''
	local _cModulo :=''
	local _cVerMenu :=''
	local _cNomUser :=''
	Local nI := 0
	Local i := 0
	Local j := 0


	Public _cNome, _cDepto, _cMail, _cRamal, _cUsuario, _cMenu, _cVerMenu, _cImp01, _cImp02, _nResSup, _cOpenMen, _cVerifLin, _nUsu
	Private _nCtnUsu := 0
	 
	memowrite("\LOGRDM\"+ALLTRIM(PROCNAME())+".LOG",Dtoc(date()) + " - " + time() + " - " +alltrim(cusername))


	Pergunte(cPerg,.F.)

	_cUsuario := ALLTRIM(UPPER(alltrim(cusername)))

	_nUsu := 1



	aAllUser	:= AllUsers()
	aAllGroup	:= AllGroups(.T.)
	_nUltUser := val(aAllUser[len(aAllUser),1,1])
	nI := 1
	_cUser :=''
	aUser := {}


	For nI:=1 to Len(aAllUser)

		IF !Empty(mv_par03)
			IF aAllUser[nI][01][01]>=Alltrim(mv_par01) .and. aAllUser[nI][01][01]<=Alltrim(mv_par02) .AND. Alltrim(mv_par03) ==  aAllUser[nI][01][12]   //Filtra por usuแrio e departamento.
				aAdd(aUser,aAllUser[nI])
			Endif
		else				
			if aAllUser[nI][01][01] >= Alltrim(mv_par01) .and. aAllUser[nI][01][01]<=Alltrim(mv_par02)   //filtra por usuแrio
				aAdd(aUser,aAllUser[nI])
			endif
		endif
	Next


	For i:=1 to Len(aUser)

		IF (aUser[i][01][01] == '000000' .OR. aUser[i][01][02] == 'Administrador')		
			LOOP		
		ENDIF

		_cUsuario  :=aUser[i][01][01] //ID
		_cNome     :=aUser[i][01][02] //Usuario
		_cNomComp  :=aUser[i][01][04] //Nome Completo
		_dValidade :=DTOC(aUser[i][01][06]) //Validade
		_bAltSen:=If(aUser[i][01][08],"Sim","Nao") //Autorizado a Alterar Senha


		PswOrder(1)
		PswSeek(aUser[i][1][11],.t.)
		aSuperior := PswRet(NIL)

		_cSuperior:= If(!Empty(aSuperior),aSuperior[01][02],"") //Superior
		_cDepto   := aUser[i][01][12] //Departamento
		_cCargo   :=aUser[i][01][13] //Cargo
		_cEmail   :=aUser[i][01][14] //E-Mail
		_nAceSimu :=AllTrim(Str(aUser[i][01][15])) //Acessos Simultaneos
		_cBloque:=If(aUser[i][01][17],"Sim","Nao") //Usuario Bloqueado



		//Carrega as c้lula da sessใo 1  (oSection1) com as informa็๕es do(s) usuแrio(s)
		oSection1:Init()	
		oSection1:Cell("cUsuario"):SetValue( _cUsuario )
		oSection1:Cell("cUsuario"):SetClrFore(CLR_HRED) //cor da fonte
		oSection1:Cell("cUsuario"):SetAlign("LEFT")

		oSection1:Cell("cNome"):SetValue( _cNome )
		oSection1:Cell("cNome"):SetClrFore(CLR_HRED) //cor da fonte
		oSection1:Cell("cNome"):SetAlign("LEFT")

		oSection1:Cell("cNomeComp"):SetValue( _cNomComp )
		oSection1:Cell("cNomeComp"):SetClrFore(CLR_HRED) //cor da fonte
		oSection1:Cell("cNomeComp"):SetAlign("LEFT")

		oSection1:Cell("dValidade"):SetValue( _dValidade )
		oSection1:Cell("dValidade"):SetClrFore(CLR_HRED) //cor da fonte
		oSection1:Cell("dValidade"):SetAlign("LEFT")

		oSection1:Cell("bAltSen"):SetValue( _bAltSen )
		oSection1:Cell("bAltSen"):SetClrFore(CLR_HRED) //cor da fonte
		oSection1:Cell("bAltSen"):SetAlign("LEFT")

		oSection1:Cell("cSuperior"):SetValue( _cSuperior )
		oSection1:Cell("cSuperior"):SetClrFore(CLR_HRED) //cor da fonte
		oSection1:Cell("cSuperior"):SetAlign("LEFT")


		oSection1:Cell("cDepto"):SetValue( _cDepto )
		oSection1:Cell("cDepto"):SetClrFore(CLR_HRED) //cor da fonte
		oSection1:Cell("cDepto"):SetAlign("LEFT")

		oSection1:Cell("cCargo"):SetValue( _cCargo )
		oSection1:Cell("cCargo"):SetClrFore(CLR_HRED) //cor da fonte
		//	oSection1:Cell("cCargo"):SetAutoSize()
		oSection1:Cell("cCargo"):SetAlign("LEFT")

		oSection1:Cell("cEmail"):SetValue( _cEmail )
		oSection1:Cell("cEmail"):SetClrFore(CLR_HRED) //cor da fonte
		//	oSection1:Cell("cCargo"):SetAutoSize()
		oSection1:Cell("cEmail"):SetAlign("LEFT")

		oSection1:Cell("nAceSimu"):SetValue( _nAceSimu )
		oSection1:Cell("nAceSimu"):SetClrFore(CLR_HRED) //cor da fonte
		oSection1:Cell("nAceSimu"):SetAlign("LEFT")

		oSection1:Cell("cBloque"):SetValue(_cBloque )
		oSection1:Cell("cBloque"):SetClrFore(CLR_HRED) //cor da fonte
		oSection1:Cell("cBloque"):SetAutoSize()



		oSection1:PrintLine()
		oReport:SkipLine() //-- Salta linha

		//	PswOrder(1)

		inf := PswRet()

		//Busca todos os menus

		For j = 1 to len(aUser[i,3])


			_cMenu :=aUser[i,3,j]


			_cVerMenu := Substr(_cMenu,3,1)


			//Verifica se o usuแrio possui acesso ao m๓dulo
			If VAL(_cVerMenu) > 0			
				If Substring(_cMenu,1,2) = '01'
					_cModulo := 'ATIVO FIXO'
				ElseIf Substring(_cMenu,1,2) = '02'
					_cModulo := 'COMPRAS'
				ElseIf Substring(_cMenu,1,2) = '03'
					_cModulo := 'CONTABILIDADE'
				ElseIf Substring(_cMenu,1,2) = '04'
					_cModulo := 'ESTOQUE'
				ElseIf Substring(_cMenu,1,2) = '05'
					_cModulo := 'FATURAMENTO'
				ElseIf Substring(_cMenu,1,2) = '06'
					_cModulo := 'FINANCEIRO'
				ElseIf Substring(_cMenu,1,2) = '07'
					_cModulo := 'GESTAO DE PESSOA'
				ElseIf Substring(_cMenu,1,2) = '09'
					_cModulo := 'FISCAL'
				ElseIf Substring(_cMenu,1,2) = '10'
					_cModulo := 'PCP'
				ElseIf Substring(_cMenu,1,2) = '16'
					_cModulo := 'PONTO ELETRONICO'
				ElseIf Substring(_cMenu,1,2) = '20'
					_cModulo := 'RECRUTAMENTO E SELECAO'
				ElseIf Substring(_cMenu,1,2) = '21'
					_cModulo := 'INSPECAO DE ENTRADA'
				ElseIf Substring(_cMenu,1,2) = '26'
					_cModulo := 'TREINAMENTO'
				ElseIf Substring(_cMenu,1,2) = '34'
					_cModulo := 'CONTABILIDADE GERENCIAL'
				ElseIf Substring(_cMenu,1,2) = '35'
					_cModulo := 'MEDICINA E SEGURANCA DO TRABALHO'
				ElseIf Substring(_cMenu,1,2) = '42'
					_cModulo := 'WMS'
				Else
					_cModulo := _cMenu
				EndIf

				_cOpenMen := alltrim(substr(_cMenu,4,25))

			else

				loop

			endif


			oSection2:Init()

			U_LeXML(_cOpenMen,cAliasTmp)		
	
			(cAliasTmp)->(dbgotop())		
			While (cAliasTmp)->(!EOF())
				//Carrega as informa็๕es de Rotina, Programa, acessos

				_cRotPai:= Alltrim((cAliasTmp)->ROTPAI)

				_cTitulo:= Substring((cAliasTmp)->TITULO,1,30)

				_cAcess := (cAliasTmp)->STATUS



				If left(_cAcess,1) == "E" //"T"
					_cAcessR:= "Sim"
				Else
					_cAcessR:= "Nใo"
				Endif

				//_cPesq := Substring(cBuffer,122,1)
				_cPesq := Substring((cAliasTmp)->ACESSOS,1,1)

				If _cPesq == "x"
					_cPesqR:= "Sim"
				Else
					_cPesqR:= "Nใo"
				Endif

				//_cVisu := Substring(cBuffer,123,1)
				_cVisu := Substring((cAliasTmp)->ACESSOS,2,1)

				If _cVisu == "x"
					_cVisuR:= "Sim"
				Else
					_cVisuR:= "Nใo"
				Endif

				//_cIncluir 	:= Substring(cBuffer,124,1)
				_cIncluir 	:= Substring((cAliasTmp)->ACESSOS,3,1)

				If _cIncluir == "x"
					_cIncluirR:= "Sim"
				Else
					_cIncluirR:= "Nใo"
				Endif

				//_cAlterar := Substring(cBuffer,125,1)
				_cAlterar := Substring((cAliasTmp)->ACESSOS,4,1)

				If _cAlterar == "x"
					_cAlterarR:= "Sim"
				Else
					_cAlterarR:= "Nใo"
				Endif

				//_cExcluir := Substring(cBuffer,126,1)
				_cExcluir := Substring((cAliasTmp)->ACESSOS,5,1)

				If _cExcluir == "x"
					_cExcluirR:= "Sim"
				Else
					_cExcluirR:= "Nใo"
				Endif


				//Carrega a sessใo dois(oSection2) com as informa็๕es referentes aos acessos do(s) usuแrio(s)


				&&			oSection2:Init()
				oSection2:Cell("cModulo"):SetValue( _cModulo )
				oSection2:Cell("cModulo"):SetAutoSize(.T.)

				oSection2:Cell("cTipoAces"):SetValue( _cRotPai )
				oSection2:Cell("cTipoAces"):SetAutoSize(.T.)

				oSection2:Cell("cPrograma"):SetValue( _cTitulo )
				oSection2:Cell("cPrograma"):SetAutoSize(.T.)

				oSection2:Cell("cAcess"):SetValue( _cAcessR )
				oSection2:Cell("cAcess"):SetAutoSize(.T.)

				oSection2:Cell("cPesqR"):SetValue( _cPesqR )
				oSection2:Cell("cPesqR"):SetAutoSize(.T.)

				oSection2:Cell("cVisuR"):SetValue( _cVisuR )
				oSection2:Cell("cVisuR"):SetAutoSize(.T.)

				oSection2:Cell("cAlterarR"):SetValue( _cAlterarR )
				oSection2:Cell("cAlterarR"):SetAutoSize(.T.)

				oSection2:Cell("cExcluirR"):SetValue( _cExcluirR )
				oSection2:Cell("cExcluirR"):SetAutoSize(.T.)			
				oSection2:PrintLine()   //linha simples

				&&			oReport:SkipLine() //-- Salta linha			
				&&			oSection2:Finish()

				(cAliasTmp)->(dbskip())

			Enddo
			oSection2:Finish()

			(cAliasTmp)->(dbclosearea())

			If oTmpTable <> Nil
				oTmpTable:Delete()
				freeObj(oTmpTable)
			Endif
		next

		_NomeArq := nTamFile := cEol := nTamLin := cBuffer := nBtLidos := ""


		dbselectarea(_cAlias)


		oSection1:Finish()

		oReport:IncMeter()



		oSection1:Finish()

		//	EXIT

		//	ENDIF

	NEXT i



	return


	#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLEXML     บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua leitura dos arquivos de menu em formato XML         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function LeXML(_cArqMenu,_cArqret,_cPrograma,_cRotPai)
	/*
	Estrutura do retorno da Xnuload:
	[i,1] Array de 3 posi็๕es com o nome da fun็ใo:
	[i,1,1] Tํtulo em Portugues
	[i,1,2] Tํtulo em Espanhol
	[i,1,3] Tํtulo em Ingles
	[i,2] Status - E ativada (<menuitem status=enable>), D desativada (<menuitem status=disable>)
	[i,3] Array com outro aMenu(recursivo) ou o nome da fun็ใo (as posi็๕es de 4 a 7 s๓ existem no caso do tipo [i,3] for igual a caracter)
	[i,4] Array com as tabelas que a fun็ใo usa
	[i,5] Acesso
	[i,6] N๚mero do m๓dulo
	[i,7] Tipo da fun็ใo
	*/

	private _lInterface := _cArqMenu == NIL

	memowrite("\LOGRDM\"+ALLTRIM(PROCNAME())+".LOG",Dtoc(date()) + " - " + time() + " - " +alltrim(cusername))

	_cPrograma := iif(_cPrograma == NIL,"",alltrim(_cPrograma))

	if _lInterface
		Processa({||ProcXML(_cArqMenu,_cArqret,_cPrograma,_cRotPai)} , "Processando Menus")
	else
		ProcXML(_cArqMenu,_cArqret,_cPrograma,_cRotPai)
	endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROCXML   บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua leitura dos arquivos de menu em formato XML         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcXML(_cArqMenu,_cArqret,_cPrograma,_cRotPai)
	local aStru := {}
	Local _ni := 0
	Local _nj := 0

	Private _aMenus := iif(_cArqMenu==NIL,Directory("\SYSTEM\*.XNU"),{{_cArqMenu}})
	Private _cArquivo

	aAdd(aStru,{"ARQUIVO"	,"C",30,00})
	aAdd(aStru,{"PROGRAMA"	,"C",20,00})
	aAdd(aStru,{"TITULO"	,"C",50,00})
	aAdd(aStru,{"TIPO"		,"N",05,00})
	aAdd(aStru,{"STATUS"	,"C",05,00})
	aAdd(aStru,{"ACESSOS"	,"C",20,00})
	aAdd(aStru,{"ROTPAI"	,"C",30,00})

	oTmpTable := FWTemporaryTable():New( cAliasTmp )  
	oTmpTable:SetFields(aStru) 


	//------------------
	//Criacao da tabela temporaria
	//------------------
	oTmpTable:Create()  


	if _lInterface
		ProcRegua(len(_aMenus))
	endif

	for _ni := 1 to len(_aMenus)
		_cArquivo := iif(_cArqMenu==NIL,"\SYSTEM\","") + _aMenus[_ni,1]
		if _lInterface
			IncProc("Arquivo: " + _cArquivo)
		endif
		_aDados := XNULoad(_cArquivo) // Carrega os dados do menu
		for _nj := 1 to len(_aDados)
			GravaDBF(_aDados[_nj],_aMenus[_ni,1],_cPrograma,_cRotPai)
		next _nj
	next _ni



return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRAVADBF  บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava arquivo DBF com os dados do menu                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function GravaDBF(_aDadMenu,_cArq,_cPrograma,_cRotPai)
	local _nk
	local _cPrgMenu
	local _cRotPai := iif(empty(_cRotPai) .or. _cRotPai==NIL,"",_cRotPai)

	if valtype(_aDadMenu[3]) == "C"  // Programa

		_cPrgMenu := upper(_aDadMenu[3])

		_cPrgMenu := iif(left(_cPrgMenu,2) == "U_" , substr(_cPrgMenu,3,15) , _cPrgMenu)

		_cPrgMenu := iif(left(_cPrgMenu,1) == "#" , substr(_cPrgMenu,2,15) , _cPrgMenu)

		_cPrgMenu := alltrim(_cPrgMenu)

		if empty(_cPrograma) .or. _cPrgMenu == _cPrograma
			RecLock(cAliasTmp,.T.)
			(cAliasTmp)->ARQUIVO   	:= upper(_cArq)
			(cAliasTmp)->PROGRAMA 	:= _aDadMenu[3]
			(cAliasTmp)->TITULO		:= _aDadMenu[1,1]
			(cAliasTmp)->TIPO		:= _aDadMenu[7]
			(cAliasTmp)->STATUS		:= _aDadMenu[2]
			(cAliasTmp)->ACESSOS	:= _aDadMenu[5]
			(cAliasTmp)->ROTPAI     := _cRotPai
			(cAliasTmp)->(MsUnlock())
		endif

	elseif  valtype(_aDadMenu[3]) == "A" // Divisao de menu

		_cRotPai := iif(!empty(_cRotPai),_cRotPai,iif(valtype(_aDadMenu[1][1])=="C" .and. !empty(_aDadMenu[1][1]),alltrim(_aDadMenu[1][1]),""))

		for _nk := 1 to len(_aDadMenu[3])
			GravaDBF(_aDadMenu[3,_nk],_cArq,_cPrograma,_cRotPai)
		next _nk

	endif

return
