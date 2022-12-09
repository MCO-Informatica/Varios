#Include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MapaUsu  º Autor ³Carlos G. Berganton º Data ³  16/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Mapeia Acessos dos Usuarios do Sistema                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function la_usuarios()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}
Private titulo       := "Relatorio de Acessos dos Usuarios"
Private nLin         := 80
Private Cabec1       := ""
Private Cabec2       := ""
Private tamanho      := "G"
Private nomeprog     := "FM_USUARIOS"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private cPerg        := "MAPAUS    "
Private m_pag        := 01
Private wnrel        := 'FM_USUARIOS'
Private cString      := ""

AjustSX1()

Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario... ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif
fErase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  16/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local aIdiomas := {"Portugues","Ingles","Espanhol"}
Local aTipoImp := {"Em Disco","Via Spool","Direto na Porta","E-Mail"}
Local aFormImp := {"Retrado","Paisagem"}
Local aAmbImp  := {"Servidor","Cliente"}
Local aColAcess:= {000,040,080}
Local aColMenus:= {000,044,088}
Local i        := 0
Local k        := 0
Local j        := 0
Local aMenu

_cRotinas := upper(alltrim(mv_par14)+';'+alltrim(mv_par15)+';'+alltrim(mv_par21)+';'+alltrim(mv_par20)+';'+alltrim(mv_par22))
_aRotinas := {}
_cRotina  := ''
For _nI := 1 to len(_cRotinas)
	If substr(_cRotinas,_nI,1) == ';'
		If !empty(_cRotina)
			aAdd(_aRotinas,'>' + alltrim(_cRotina) + '<')
		EndIf
		_cRotina := ''
	Else
		_cRotina += substr(_cRotinas,_nI,1)
	EndIf
Next

aUser    := {}

aModulos := fModulos()
aAcessos := fAcessos()

aAllUsers:= {}
aAllGrupos := {}
Processa({|| CarregaUser()},'Carregando Usuários...')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Len(aUser) * len(amodulos))
_cEmpOri := cEmpAnt
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa Usuarios ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par13 <> 1
	_cArq  := 'c:\spool\la_mapausu.txt'
	_nHdl  := fCreate(_cArq)
	_lErro := .f.
	_cLinha:= "Login;Nome Completo;Emp;Fil;Matric;Sit;Afast;Admissao;Demissao;Validade;Nome RH;Nro Aces;e-mail;Cargo;Grupo;Menu;Funcao;Vis;Inc;Alt;Exc;Rotina;Nivel" + _cEnter
	If fWrite(_nHdl, _cLinha, Len(_cLinha)) != Len(_cLinha)
		_lErro := .t.
		MsgBox("Ocorreu um erro na gravação do arquivo " + _cArq + "." , "Atenção!!!",'STOP')
		fClose(_nHdl)
		Return()
	Endif
EndIf

For i:=1 to Len(aUser)
	
	If !empty(mv_par11)
		_lPula := .t.
		For k:=1 to Len(aUser[i,02,06])
			If (substr(aUser[i,02,06,k],3,2) $ mv_par11)
				_lPula := .f.
				exit
			EndIf
		Next
		
		If _lPula
			For _nI := 1 to len(aModulos)
				IncRegua()
			Next
			loop
		EndIf
	EndIf
	
	If (mv_par16 == 1 .and. aUser[i,01,17]) .or. (mv_par16 == 2 .and. !aUser[i,01,17])  // bloqueados / liberados
		loop
	EndIf
	_cModulos := ''
	If !empty(mv_par12)
		_lPula := .t.
		For k:=1 to Len(aModulos)
			If substr(aUser[i,03,k],3,1) <> 'X'
				_cModulos += left(aUser[i,03,k],2) + '/'
				If left(aUser[i,03,k],2) $ mv_par12
					_lPula := .f.
				EndIf
			EndIf
		Next
		
		If _lPula
			For _nI := 1 to len(aModulos)
				IncRegua()
			Next
			loop
		EndIf
	EndIf
	
	If mv_par13 == 1
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 5
		
		@ nLin,000 pSay "I N F O R M A C O E S   D O   U S U A R I O"
		If left(aUser[i,01,22],2) <> _cEmpOri
			DbSelectArea('SRA')
			DbCloseArea()
			cEmptAnt := left(aUser[i,01,22],2)
			RetIndex('SRA')
			DbSelectArea('SRA')
		EndIf
		_cSitFol := Posicione('SRA',1,substr(aUser[i,01,22],3),'RA_SITFOLH') + ' / ' + SRA->RA_AFASFGT + '  ' + dtoc(SRA->RA_ADMISSA) + '   ' + dtoc(SRA->RA_DEMISSA)
		If left(aUser[i,01,22],2) <> _cEmpOri
			DbCloseArea()
			cEmptAnt := _cEmpOri
			RetIndex('SRA')
			DbSelectArea('SRA')
		EndIf
		@ ++nLin,000 pSay "User ID.........................: "+aUser[i,01,01] + '   Empr: ' + left(aUser[i,01,22],2) + '   Filial: ' + substr(aUser[i,01,22],3,2) + '   Matric: ' + right(aUser[i,01,22],6) + '  Sit Fol: ' + _cSitFol
		@ ++nLin,000 pSay "Usuario.........................: "+aUser[i,01,02] //Usuario
		@ ++nLin,000 pSay "Nome Completo...................: "+aUser[i,01,04] //Nome Completo
		@ ++nLin,000 pSay "Validade........................: "+DTOC(aUser[i,01,06]) //Validade
		@ ++nLin,000 pSay "Acessos para Expirar............: "+AllTrim(Str(aUser[i,01,07])) //Expira em n acessos
		@ ++nLin,000 pSay "Autorizado a Alterar Senha......: "+If(aUser[i,01,08],"Sim","Nao") //Autorizado a Alterar Senha
		@ ++nLin,000 pSay "Alterar Senha no Proximo LogOn..: "+If(aUser[i,01,09],"Sim","Nao") //Alterar Senha no Proximo LogOn
		
		PswOrder(1)
		PswSeek(aUser[i,1,11],.t.)
		aSuperior := PswRet(NIL)
		@ ++nLin,000 pSay "Superior........................: "+If(!Empty(aSuperior),aSuperior[01,02],"") //Superior
		@ ++nLin,000 pSay "Departamento....................: "+aUser[i,01,12] //Departamento
		@ ++nLin,000 pSay "Cargo...........................: "+aUser[i,01,13] //Cargo
		@ ++nLin,000 pSay "E-Mail..........................: "+aUser[i,01,14] //E-Mail
		@ ++nLin,000 pSay "Acessos Simultaneos.............: "+AllTrim(Str(aUser[i,01,15])) //Acessos Simultaneos
		@ ++nLin,000 pSay "Ultima Alteracao................: "+DTOC(aUser[i,01,16]) //Data da Ultima Alteracao
		@ ++nLin,000 pSay "Usuario Bloqueado...............: "+If(aUser[i,01,17],"Sim","Nao") //Usuario Bloqueado
		@ ++nLin,000 pSay "Digitos p/o Ano.................: "+AllTrim(STR(aUser[i,01,18])) //Numero de Digitos Para o Ano
		@ ++nLin,000 pSay "Idioma..........................: "+aIdiomas[aUser[i,02,02]] //Idioma
		@ ++nLin,000 pSay "Diretorio do Relatorio..........: "+aUser[i,02,03] //Diretorio de Relatorio
		@ ++nLin,000 pSay "Tipo de Impressao...............: "+aTipoImp[aUser[i,02,08]] // Tipo de Impressao
		@ ++nLin,000 pSay "Formato de Impressao............: "+aFormImp[aUser[i,02,09]] // Formato
		@ ++nLin,000 pSay "Ambiente de Impressao...........: "+aAmbImp[aUser[i,02,10]] // Ambiente
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Grupos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ nLin+=2,000 pSay Replic("-",132)
		@ ++nLin,000 pSay "G R U P O S"
		++nLin
		For k:=1 to Len(aUser[i,01,10])
			fCabec(@nLin,55)
			
			PswOrder(1)
			PswSeek(aUser[i,01,10,k],.f.)
			aGroup := PswRet(NIL)
			
			@ ++nLin,005 pSay aGroup[01,2] //Grupos
		Next k
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Horarios ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par06==1
			fCabec(@nLin,50)
			
			@ nLin+=2,000 pSay Replic("-",132)
			@ ++nLin,000 pSay "H O R A R I O S"
			++nLin
			For k:=1 to Len(aUser[i,02,01])
				fCabec(@nLin,55)
				@ ++nLin,005 pSay aUser[i,2,01,k] //Horarios
			Next k
			++nLin
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Empresas / Filiais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par07==1
			fCabec(@nLin,50)
			
			@ ++nLin,000 pSay Replic("-",132)
			@ ++nLin,000 pSay "E M P R E S A S / F I L I A I S"
			nLin+=2
			For k:=1 to Len(aUser[i,02,06])
				fCabec(@nLin,55)
				
				dbSelectArea("SM0")
				dbSetOrder(1)
				dbSeek(aUser[i,02,06,k])
				@ nLin++,005 pSay Substr(aUser[i,02,06,k],1,2)+"/"+Substr(aUser[i,02,06,k],3,2)+If(Found()," "+M0_NOME+" - "+M0_NOMECOM,If(Substr(aUser[i,02,06,k],1,2)=="@@"," - Todos","")) //Empresa / Filial
				
			Next k
			++nLin
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Modulos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par08==1
			fCabec(@nLin,50)
			
			@ nLin,000 pSay Replic("-",132)
			nLin+=1
			@ nLin,000 pSay "M O D U L O S"
			nLin+=2
			//                        1         2         3         4         5         6         7         8
			//               123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			@ nLin,000 pSay "MODULO                                        NIVEL ARQ.MENU"
			nLin+=1
			@ nLin,000 pSay "--------------------------------------------- ----- --------------------------------------------"
			nLin+=1
			
			For k:=1 to Len(aModulos)
				If Substr(aUser[i,03,k],3,1) <> "X"
					If nLin > 55
						fCabec(@nLin,55)
						@ nLin,000 pSay "MODULO                                        NIVEL ARQ.MENU"
						nLin+=1
						@ nLin,000 pSay "--------------------------------------------- ----- --------------------------------------------"
						nLin+=1
					Endif
					
					@ nLin,000 pSay aModulos[k,02]+" - "+aModulos[k,3]
					@ nLin,048 pSay Substr(aUser[i,03,k],3,1)
					@ nLin,052 pSay Substr(aUser[i,03,k],4)
					
					nLin+=1
				Endif
			Next k
			nLin+=1
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Acessos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par09==1
			fCabec(@nLin,50)
			
			@ nLin,000 pSay Replic("-",132)
			nLin+=1
			@ nLin,000 pSay "A C E S S O S"
			nLin+=2
			
			nCol := 1
			For k:=1 to 103
				If Substr(aUser[i,02,5],k,1) == "S"
					fCabec(@nLin,55)
					@ nLin,aColAcess[nCol] pSay aAcessos[k]
					If nCol==3
						nCol:=1
						nLin+=1
					Else
						nCol+=1
					Endif
				Endif
			Next k
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Menus ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par10==1
			fCabec(@nLin,50)
			
			@ nLin,000 pSay Replic("-",132)
			nLin+=1
			@ nLin,000 pSay "M E N U S"
			nLin+=2
			//                        1         2         3         4         5         6         7         8
			//               123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			@ nLin,000 pSay "TITULO             PROGRAMA   ACESSOS       TITULO             PROGRAMA   ACESSOS       TITULO             PROGRAMA   ACESSOS"
			nLin+=1
			@ nLin,000 pSay "------------------ ---------- ----------    ------------------ ---------- ----------    ------------------ ---------- ----------"
			nLin+=1
			
			For k:=1 to Len(aModulos)
				If Substr(aUser[i,03,k],3,1) <> "X"
					aMenu := fGetMnu(Substr(aUser[i,03,k],4),aUser[i,01,02])
					
					If !empty(aMenu)
						nLin +=1
						@ nLin,000 pSay aModulos[k,02]+" - "+AllTrim(aModulos[k,3])+"  -->  "+Substr(aUser[i,03,k],4)
						nLin+=2
					EndIf
					
					nCol := 1
					For j:=1 to Len(aMenu)
						If nLin > 55
							fCabec(@nLin,55)
							@ nLin,000 pSay "TITULO             PROGRAMA   ACESSOS       TITULO             PROGRAMA   ACESSOS       TITULO             PROGRAMA   ACESSOS"
							nLin+=1
							@ nLin,000 pSay "------------------ ---------- ----------    ------------------ ---------- ----------    ------------------ ---------- ----------"
							nLin+=1
						Endif
						
						@ nLin,aColMenus[nCol]+000 pSay aMenu[j,01]
						@ nLin,aColMenus[nCol]+019 pSay aMenu[j,02]
						@ nLin,aColMenus[nCol]+030 pSay aMenu[j,03]
						If nCol==3
							nCol:=1
							++nLin
						Else
							++nCol
						Endif
					Next
					++nLin
				Endif
			Next k
			++nLin
		Endif
		
	Else  // RESUMIDO
		
		cabec1 := "Login             Nome Completo                    Emp  Fil  Matric   Sit     Admissao     Demissao  Validade  Nome RH                                   e-mail"
		//         213456789012345 -                                                                                              1234567890123456789012345678901234567890
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 7
		EndIf
		
		If left(aUser[i,01,22],2) <> _cEmpOri
			DbSelectArea('SRA')
			DbCloseArea()
			cEmptAnt := left(aUser[i,01,22],2)
			RetIndex('SRA')
			DbSelectArea('SRA')
		EndIf
		_cSitFol := Posicione('SRA',1,substr(aUser[i,01,22],3),'RA_SITFOLH') + ' / ' + SRA->RA_AFASFGT + '  ' + dtoc(SRA->RA_ADMISSA) + '   ' + dtoc(SRA->RA_DEMISSA)
		_lFunc  := !empty(SRA->RA_ADMISSA)
		_lDemis := !empty(SRA->RA_DEMISSA)
		_cNome  := SRA->RA_NOME
		If left(aUser[i,01,22],2) <> _cEmpOri
			DbCloseArea()
			cEmptAnt := _cEmpOri
			RetIndex('SRA')
			DbSelectArea('SRA')
		EndIf
		
		_cLinha := ''
		If ((mv_par17 == 1 .and. _lDemis) .or. (mv_par17 == 2 .and. !_lDemis) .or. mv_par17 == 3) .and. ;
			((mv_par18 == 1 .and. _lFunc) .or. (mv_par18 == 2 .and. !_lFunc) .or. mv_par18 == 3)
			If (upper(alltrim(aUser[i,1,4])) <> upper(alltrim(_cNome)) .and. mv_par19 == 1) .or.;
				(upper(alltrim(aUser[i,1,4])) == upper(alltrim(_cNome)) .and. mv_par19 == 2) .or. mv_par19 == 3
				_aMenus := {}
				If mv_par13 == 3
					For k:=1 to Len(aUser[i,3])
						IncRegua()
						If Substr(aUser[i,03,k],3,1) <> "X"
							aMenu := fGetMnu(Substr(aUser[i,03,k],4),aUser[i,01,02])
							If len(aMenu) > 0 //.and. !empty(aMenu[1,1,1])
								aAdd(_aMenus,aClone(aMenu))
								For _nL := 1 to len(_aMenus[len(_aMenus)])
									aAdd(_aMenus[len(_aMenus),_nL],Substr(aUser[i,03,k],3,1))
								Next
							EndIf
						EndIf
					Next
				EndIf
				If len(_aMenus) > 0 .or. mv_par13 <> 3
					_cRotinas := ''
					@ ++nLin,000 pSay aUser[i,1,2] + " - " + aUser[i,1,4] + '   ' + left(aUser[i,1,22],2) + '   ' + substr(aUser[i,1,22],3,2) + '   ' + right(aUser[i,1,22],6) + '  ' + _cSitFol + '  ' + dtoc(aUser[i,1,6]) + '  ' + _cNome + " - " + AllTrim(Str(aUser[i,01,15])) + ' - ' + alltrim(UsrRetMail(aUser[i,1,1]))
					
					_cSitFol := alltrim(SRA->RA_SITFOLH)          + ";" + alltrim(SRA->RA_AFASFGT)           + ";"
					_cSitFol += alltrim(dtoc(SRA->RA_ADMISSA))    + ";" + alltrim(dtoc(SRA->RA_DEMISSA))
					
					_cLinha += alltrim(aUser[i,1,2])              + ";" + alltrim(aUser[i,1,4])              + ";"
					_cLinha += alltrim(left(aUser[i,1,22],2))     + ";" + alltrim(substr(aUser[i,1,22],3,2)) + ";"
					_cLinha += alltrim(right(aUser[i,1,22],6))    + ";" + alltrim(_cSitFol)                  + ";"
					_cLinha += alltrim(dtoc(aUser[i,1,6]))        + ";" + alltrim(_cNome)                    + ";"
					_cLinha += alltrim(Str(aUser[i,01,15]))       + ';' + alltrim(UsrRetMail(aUser[i,1,1]))  + ';'
					If empty(substr(aUser[i,01,22],3))
						_cLinha += alltrim(aUser[i,01,12]) + ' - ' + alltrim(aUser[i,01,13])			     + ';'
					Else
						_cLinha += Posicione('SRJ',1,SRA->RA_FILIAL + SRA->RA_CODFUNC,'RJ_DESC') 			     + ';'
					EndIf
					_cLinha += aUser[i,1,10,1]			  		  + ';'
					_cUsuario := _cLinha
					For _nRot := 1 to len(_aMenus)
						For _nL := 1 to len(_aMenus[_nRot])
							If nLin > 55
								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
								nLin := 7
							EndIf
							If !empty(_aMenus[_nRot,_nL]) .and. len(_aMenus[_nRot,_nL]) >= 4
								@ ++nLin,10 pSay 'Menu: ' + _aMenus[_nRot,_nL,1] + '  Funcao: ' + _aMenus[_nRot,_nL,3] + '  Acessos: ' + _aMenus[_nRot,_nL,4] + '  Rotina: ' + _aMenus[_nRot,_nL,2]
								_cLinha += alltrim(_aMenus[_nRot,_nL,1]) + ';' + alltrim(_aMenus[_nRot,_nL,3]) + ';'
								_cLinha += alltrim(_aMenus[_nRot,_nL,4]) + ';' + alltrim(_aMenus[_nRot,_nL,2]) + ';
								_cLinha += _aMenus[_nRot,_nL,5] + _cEnter
								
								If fWrite(_nHdl, _cLinha, Len(_cLinha)) != Len(_cLinha)
									_lErro := .t.
									MsgBox("Ocorreu um erro na gravação do arquivo " + _cArq + "." , "Atenção!!!",'STOP')
									Exit
								Endif
								
								_cLinha := _cUsuario
							EndIf
						Next
					Next
					
					If !empty(_cModulos)
						@ ++nLin,000 pSay '  Modulos: ' + left(_cModulos,100)
						If len(_cModulos) > 100
							@ ++nLin,059 pSay substr(_cModulos,101)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	
Next i

If mv_par13 <> 1
	fClose(_nHdl)
EndIf

If aReturn[5]==1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fModulos ºAutor  ³Carlos G. Berganton º Data ³  16/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna Array com Codigos e Nomes dos Modulos              º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fModulos()

Local aReturn

aReturn := {{"01","SIGAATF ","Ativo Fixo                       "},;
{"02","SIGACOM ","Compras                           "},;
{"03","SIGACON ","Contabilidade                     "},;
{"04","SIGAEST ","Estoque/Custos                    "},;
{"05","SIGAFAT ","Faturamento                       "},;
{"06","SIGAFIN ","Financeiro                        "},;
{"07","SIGAGPE ","Gestao de Pessoal                 "},;
{"08","SIGAFAS ","Faturamento Servico               "},;
{"09","SIGAFIS ","Livros Fiscais                    "},;
{"10","SIGAPCP ","Planej.Contr.Producao             "},;
{"11","SIGAVEI ","Veiculos                          "},;
{"12","SIGALOJA","Controle de Lojas                 "},;
{"13","SIGATMK ","Call Center                       "},;
{"14","SIGAOFI ","Oficina                           "},;
{"15","SIGARPM ","Gerador de Relatorios Beta1       "},;
{"16","SIGAPON ","Ponto Eletronico                  "},;
{"17","SIGAEIC ","Easy Import Control               "},;
{"18","SIGAGRH ","Gestao de R.Humanos               "},;
{"19","SIGAMNT ","Manutencao de Ativos              "},;
{"20","SIGARSP ","Recrutamento e Selecao Pessoal    "},;
{"21","SIGAQIE ","Inspecao de Entrada               "},;
{"22","SIGAQMT ","Metrologia                        "},;
{"23","SIGAFRT ","Front Loja                        "},;
{"24","SIGAQDO ","Controle de Documentos            "},;
{"25","SIGAQIP ","Inspecao de Projetos              "},;
{"26","SIGATRM ","Treinamento                       "},;
{"27","SIGAEIF ","Importacao - Financeiro           "},;
{"28","SIGATEC ","Field Service                     "},;
{"29","SIGAEEC ","Easy Export Control               "},;
{"30","SIGAEFF ","Easy Financing                    "},;
{"31","SIGAECO ","Easy Accounting                   "},;
{"32","SIGAAFV ","Administracao de Forca de Vendas  "},;
{"33","SIGAPLS ","Plano de Saude                    "},;
{"34","SIGACTB ","Contabilidade Gerencial           "},;
{"35","SIGAMDT ","Medicina e Seguranca no Trabalho  "},;
{"36","SIGAQNC ","Controle de Nao-Conformidades     "},;
{"37","SIGAQAD ","Controle de Auditoria             "},;
{"38","SIGAQCP ","Controle Estatistico de Processos "},;
{"39","SIGAOMS ","Gestao de Distribuicao            "},;
{"40","SIGACSA ","Cargos e Salarios                 "},;
{"41","SIGAPEC ","Auto Pecas                        "},;
{"42","SIGAWMS ","Gestao de Armazenagem             "},;
{"43","SIGATMS ","Gestao de Transporte              "},;
{"44","SIGAPMS ","Gestao de Projetos                "},;
{"45","SIGACDA ","Controle de Direitos Autorais     "},;
{"46","SIGAACD ","Automacao Coleta de Dados         "},;
{"47","SIGAPPAP","PPAP                              "},;
{"48","SIGAREP ","Replica                           "},;
{"49","SIGAGAC ","Gerenciamento Academico           "},;
{"50","SIGAEDC ","Easy DrawBack Control             "},;
{"97","SIGAESP ","Especificos                       "},;
{"98","SIGAESP1","Especificos I                     "}}


Return(aReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fAcessos ºAutor  ³Carlos G. Berganton º Data ³  16/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna os Acessos dos Sistema                             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAcessos()

Local aReturn

aReturn := {"Excluir Produtos             ",;
"Alterar Produtos             ",;
"Excluir Cadastros            ",;
"Alterar Solicit. Compras     ",;
"Excluir Solicit. Compras     ",;
"Alterar Pedidos Compras      ",;
"Excluir Pedidos Compras      ",;
"Analisar Cotacoes            ",;
"Relat Ficha Cadastral        ",;
"Relat Bancos                 ",;
"Relacao Solicit. Compras     ",;
"Relacao de Pedidos de Compras",;
"Alterar Estruturas           ",;
"Excluir Estruturas           ",;
"Alterar TES                  ",;
"Excluir TES                  ",;
"Inventario                   ",;
"Fechamento Mensal            ",;
"Proc Diferenca de Inventario ",;
"Alterar Pedidos de Venda     ",;
"Excluir Pedidos de Venda     ",;
"Alterar Helps                ",;
"Substituicao de Titulos      ",;
"Inclusao de Dados Via F3     ",;
"Rotina de Atendimento        ",;
"Proc. Troco                  ",;
"Proc. Sangria                ",;
"Bordero Cheques Pre-Datado   ",;
"Rotina de Pagamento          ",;
"Rotina de Recebimento        ",;
"Troca de Mercadorias         ",;
"Acesso Tabela de Precos      ",;
"Abortar c/ Alt-C/Ctrl-Brk    ",;
"Retorno Temporario p/ o DOS  ",;
"Acesso Condicao Negociada    ",;
"Alterar DataBase do Sistema  ",;
"Alterar Empenhos de OP's     ",;
"Pode Utilizar Debug          ",;
"Form. Precos Todos os Niveis ",;
"Configura Venda Rapida       ",;
"Abrir/Fechar Caixa           ",;
"Excluir Nota/Orc LOJA        ",;
"Alterar Bem Ativo Fixo       ",;
"Excluir Bem Ativo Fixo       ",;
"Incluir Bem Via Copia        ",;
"Tx Juros Condicao Negociada  ",;
"Liberacao Venda Forcad TEF   ",;
"Cancelamento Venda TEF       ",;
"Cadastra Moeda na Abertura   ",;
"Altera Num. da NF            ",;
"Emitir NF Retroativa         ",;
"Excluir Baixa - Receber      ",;
"Excluir Baixa - Pagar        ",;
"Incluir Tabelas              ",;
"Alterar Tabelas              ",;
"Excluir Tabelas              ",;
"Incluir Contratos            ",;
"Alterar Contratos            ",;
"Excluir Contratos            ",;
"Uso Integracao SIGAEIC       ",;
"Inclui Emprestimo            ",;
"Alterar Emprestimo           ",;
"Excluir Emprestimo           ",;
"Incluir Leasing              ",;
"Alterar Leasing              ",;
"Excluir Leasing              ",;
"Incluir Imp. Nao Financ.     ",;
"Alterar Imp. Nao Financ.     ",;
"Excluir Imp. Nao Financ.     ",;
"Incluir Imp. Financ.         ",;
"Alterar Imp. Financ.         ",;
"Excluir Imp. Financ.         ",;
"Incluir Imp. Fin.Export      ",;
"Alterar Imp. Fin.Export      ",;
"Excluir Imp. Fin.Export      ",;
"Incluir Contrato             ",;
"Alterar Contrato             ",;
"Excluir Contrato             ",;
"Lancar Taxa Libor            ",;
"Consolidar Empresas          ",;
"Incluir Cadastros            ",;
"Alterar Cadastros            ",;
"Incluir Cotacao Moedas       ",;
"Alterar Cotacao Moedas       ",;
"Excluir Cotacao Moedas       ",;
"Incluir Corretoras           ",;
"Alterar Corretoras           ",;
"Excluir Corretoras           ",;
"Incluir Imp./Exp./Cons       ",;
"Alterar Imp./Exp./Cons       ",;
"Excluir Imp./Exp./Cons       ",;
"Baixar Solicitacoes          ",;
"Visualiza Arquivo Limite     ",;
"Imprime Doctos. Cancelados   ",;
"Reativa Doctos. Cancelados   ",;
"Consulta Doctos. Obsoletos   ",;
"Imprime Doctos. Obsoletos    ",;
"Consulta Doctos. Vencidos    ",;
"Imprime Doctos. Vencidos     ",;
"Def. Laudo Final Entrega     ",;
"Imprime Param Relatorio      ",;
"Transfere Pendencias         ",;
"Usa Relatorio por E-Mail     "}

Return(aReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCabec   ºAutor  ³Carlos G. Berganton º Data ³  18/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Quebra de Pagina e Imprime Cabecalho                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCabec(nLin,nLimite)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . . ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > nLimite
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 6
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGetMnu   ºAutor  ³Carlos G. Berganton º Data ³  15/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtem dados de um arquivo .mnu                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGetMnu(cArq,cUsuario)

Local aRet := {}
Local aTmp := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o Arquivo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File(cArq)
	ft_fuse(cArq)
ElseIf mv_par13 == 3
	Return({})
	//Return({{'','','',''}})
Else
	Return({{"Arquivo "+AllTrim(cArq)+" nao foi encontrado. Usuario "+AllTrim(cUsuario)+".",'','','','','','','',''}})
Endif
_lMenuItem := .f.
_lGrava    := .f.
_nMenu     := 0
Do while !ft_feof()
	
	cBuff := alltrim(ft_freadln())	//³ Le linha do Arquivo ³
	
	If 'MENU STATUS' $ upper(cBuff)
		
		_lMenuItem := .f.
		_lGrava    := ('ENABLE' $ upper(cBuff))
		
	ElseIf '<MENUITEM' $ upper(cBuff)
		
		_lMenuItem := .t.
		_lGrava    := ('ENABLE' $ upper(cBuff))
		aTmp       := {}
		aAdd(aTmp,cArq)
		
	ElseIf _lMenuItem .and. '<TITLE LANG="PT">' $ upper(cBuff) .and. _lGrava
		
		_nPosic := at('>',cBuff)
		cBuff   := substr(cBuff,_nPosic+1)
		_nPosic := at('</TITLE>',upper(cBuff))
		cBuff   := left(left(cBuff,_nPosic-1),18)
		aAdd(aTmp,cBuff)
		
	ElseIf _lMenuItem .and. '<FUNCTION>' $ upper(cBuff) .and. _lGrava
		
		_nPosic := at('>',cBuff)
		cBuff   := substr(cBuff,_nPosic+1)
		_nPosic := at('#',cBuff)
		If _nPosic > 0
			cBuff := substr(cBuff,_nPosic+1)
		EndIf
		_nPosic := at('</FUNCTION>',upper(cBuff))
		cBuff   := left(left(cBuff,_nPosic-1),18)
		aAdd(aTmp,upper(cBuff))
		//_lGrava := (empty(mv_par14+mv_par15+mv_par21+mv_par20+mv_par22) .or. upper(cBuff) $ upper(mv_par14 + mv_par15+mv_par20+mv_par21+mv_par22))
		_lGrava := (empty(_aRotinas) .or. aScan(_aRotinas, '>' + upper(cBuff) + '<' ) > 0)
		
	ElseIf _lMenuItem .and. '<ACCESS>' $ upper(cBuff) .and. _lGrava
		
		_nPosic := at('>',cBuff)
		cBuff   := substr(cBuff,_nPosic+1)
		_nPosic := at('</ACCESS>',upper(cBuff))
		cBuff   := left(left(cBuff,_nPosic-1),18)
		_cBuff  := ''
		For _nAcc := 2 to 4
			_cBuff += substr(cBuff,_nAcc,1) + ';'
		Next
		_cBuff += substr(cBuff,_nAcc,1)
		
		aAdd(aTmp,_cBuff)
		
	ElseIf '</MENUITEM>' $ upper(cBuff)
		
		If _lGrava
			aAdd(aRet,aClone(aTmp))
		EndIf
		_lMenuItem := .f.
		//_lGrava    := .f.
		aTmp       := {}
		
	EndIf
	
	ft_fskip()
	
EndDo

ft_fuse()

Return(aRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³ Carlos G. Berganton   ³ Data ³ 15/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustSX1()

Local aArea	    := GetArea()
Local cPerg		:= "MAPAUS    "
Local aRegs		:= {}
Local i

AAdd(aRegs,{"01","Do ID..............?","mv_ch1","C",06,0,0,"G","mv_par01",""   ,"","","",""    })
AAdd(aRegs,{"02","Ate ID.............?","mv_ch2","C",06,0,0,"G","mv_par02",""   ,"","","",""    })
AAdd(aRegs,{"03","Do Usuario.........?","mv_ch3","C",15,0,0,"G","mv_par03",""   ,"","","",""    })
AAdd(aRegs,{"04","Ate Usuario........?","mv_ch4","C",15,0,0,"G","mv_par04",""   ,"","","",""    })
AAdd(aRegs,{"05","Ordem..............?","mv_ch5","N",01,0,0,"C","mv_par05","ID" ,"Usuario","Empr+Filial+Mat","Empr+Filial+Usuário","Empr+Filial+Nome Completo"    })
AAdd(aRegs,{"06","Imprime Horarios...?","mv_ch6","N",01,0,0,"C","mv_par06","Sim","Nao","","",""    })
AAdd(aRegs,{"07","Imprime Emp/Filiais?","mv_ch7","N",01,0,0,"C","mv_par07","Sim","Nao","","",""    })
AAdd(aRegs,{"08","Imprime Modulos....?","mv_ch8","N",01,0,0,"C","mv_par08","Sim","Nao","","",""    })
AAdd(aRegs,{"09","Imprime Acessos....?","mv_ch9","N",01,0,0,"C","mv_par09","Sim","Nao","","",""    })
AAdd(aRegs,{"10","Imprime Menus......?","mv_cha","N",01,0,0,"C","mv_par10","Sim","Nao","","",""    })
AAdd(aRegs,{"11","Filiais............?","mv_chb","C",60,0,0,"G","mv_par11",""   ,"","","",""    })
AAdd(aRegs,{"12","Módulos............?","mv_chc","C",60,0,0,"G","mv_par12",""   ,"","","",""    })
AAdd(aRegs,{"13","Relatorio..........?","mv_chd","N",01,0,0,"C","mv_par13","Completo","Resumido","Resumido c/rotinas","",""    })
AAdd(aRegs,{"14","Rotinas ...........?","mv_che","C",60,0,0,"G","mv_par14","","","","",""    })
AAdd(aRegs,{"15","Rotinas ...........?","mv_chf","C",60,0,0,"G","mv_par15","","","","",""    })
AAdd(aRegs,{"16","Situacao Usuario...?","mv_cha","N",01,0,0,"C","mv_par16","Liberados","Bloqueados","Ambos","",""    })
AAdd(aRegs,{"17","Demitidos..........?","mv_chb","N",01,0,0,"C","mv_par17","Sim","Nao","","",""    })
AAdd(aRegs,{"18","Funcionario........?","mv_chc","N",01,0,0,"C","mv_par18","Sim","Nao","Ambos","",""    })
AAdd(aRegs,{"19","Quanto ao nome.....?","mv_chd","N",01,0,0,"C","mv_par19","Diferentes","Iguais","Ambos","",""    })
AAdd(aRegs,{"20","Rotinas ...........?","mv_che","C",60,0,0,"G","mv_par20","","","","",""    })
AAdd(aRegs,{"21","Rotinas ...........?","mv_chf","C",60,0,0,"G","mv_par21","","","","",""    })
AAdd(aRegs,{"22","Rotinas ...........?","mv_chg","C",60,0,0,"G","mv_par22","","","","",""    })

dbSelectArea("SX1")
dbSetOrder(1)
For i:=1 to Len(aRegs)
	dbSeek(cPerg+aRegs[i,1])
	If !Found() .or. aRegs[i,2]<>X1_PERGUNT
		RecLock("SX1",!Found())
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := aRegs[i,01]
		SX1->X1_PERGUNT := aRegs[i,02]
		SX1->X1_VARIAVL := aRegs[i,03]
		SX1->X1_TIPO    := aRegs[i,04]
		SX1->X1_TAMANHO := aRegs[i,05]
		SX1->X1_DECIMAL := aRegs[i,06]
		SX1->X1_PRESEL  := aRegs[i,07]
		SX1->X1_GSC     := aRegs[i,08]
		SX1->X1_VAR01   := aRegs[i,09]
		SX1->X1_DEF01   := aRegs[i,10]
		SX1->X1_DEF02   := aRegs[i,11]
		SX1->X1_DEF03   := aRegs[i,12]
		SX1->X1_DEF04   := aRegs[i,13]
		SX1->X1_DEF05   := aRegs[i,14]
		MsUnlock()
	Endif
Next

RestArea(aArea)

Return
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function CarregaUser()
/////////////////////////////
aAllGrupos := AllGroups()
aAllUsers:= AllUsers()

ProcRegua(Len(aAllUsers))
For i := 1 to Len(aAllUsers)
	
	IncProc()
	
	If aAllUsers[i,01,01] >= mv_par01 .and. aAllUsers[i,01,01] <= mv_par02 .and.;
		upper(aAllUsers[i,01,02]) >= upper(mv_par03) .and. upper(aAllUsers[i,01,02]) <= upper(mv_par04) .and. !(aAllUsers[i,01,01] $ '000000/000740/')
		
		aAdd(aUser,aClone(aAllUsers[i]))
		
		If !empty(aUser[len(aUser),1,10]) .and. aUser[len(aUser),1,10,1] <> '000000' .and. aUser[len(aUser),2,11]	// prioriza grupo
			
			aUser[len(aUser),3] := {}
			_nI := 1
			//For _nI := 1 to len(aUser[len(aUser),1,10])
			
			_cgrupo := aUser[len(aUser),1,10,_nI]
			_nPosic := aScan(aAllGrupos, {|X| X[1,1] == _cGrupo})
			If _nPosic > 0
				For _nJ := 1 to len(aAllGrupos[_nPosic,2])
					If upper(substr(aAllGrupos[_nPosic,2,_nJ],3,1)) <> 'X' .and. aScan(aUser[len(aUser),3], aAllGrupos[_nPosic,2,_nJ]) == 0
						aAdd(aUser[len(aUser),3], aAllGrupos[_nPosic,2,_nJ])
					EndIf
				Next
			EndIf
			aSort(aUser[len(aUser),3])
			
			//Next
			
		Else
			
			If empty(aUser[len(aUser),1,10])
				aAdd(aUser[len(aUser),1,10], '')
			Else
				aUser[len(aUser),1,10] := {''}
			EndIf
			
		EndIf
		
	Endif
	
Next

If mv_par05==1 //ID
	aSort(aUser,,,{ |aVar1,aVar2| aVar1[1,1] < aVar2[1,1]})
Else           //Usuario
	aSort(aUser,,,{ |aVar1,aVar2| lower(aVar1[1,2]) < lower(aVar2[1,2])})
Endif

Return()