#INCLUDE "rwmake.ch"
#INCLUDE "TOTVS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EXTAPROV   º Autor ³ Leandro Nishihata  º Data ³  13/09/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ estorna aprovacao.                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EXTAPROV()

	Local aParamBox			:= {}
	Private vet := {}
	Private _astru			:={}
	PRIVATE _carq
	Private _afields		:={}
	Private arotina 		:= {}
	Private cCadastro
	private aRet 			:= {}
	Private msgmarkbrow		:="Aprovações a extornar"		
	Private cMark:=GetMark()
		
	aRotina   := { 	{ "Pesquisar","AxPesqui",0,1} ,;
					{ "Alterar","U_AEXTAPROV('tmp')",0,3} ,;
					{ "Marcar Todos" ,"U_MARCAR('tmp')" , 0, 4},;
					{ "Desmarcar Todos" ,"U_DESMARCAR('tmp')" , 0, 4},;
					{ "Inverter Todos" ,"U_MARKALL('tmp')" , 0, 4}}

	// monta tela de parametros de filtro do browser.
	aAdd(aParamBox,{1,"Período apontamento de  :",Space(16),"","","RCC_07","",0,.F.}) // Tipo caractere
	aAdd(aParamBox,{1,"Período apontamento até :",Space(16),"","","RCC_07","",0,.F.}) // Tipo caractere
	aAdd(aParamBox,{1,"Matrícula até           :",Space(999),"","mv_par03:=u_FMatricula()","","",90,.T.}) // Tipo caractere
	aAdd(aParamBox,{1,"Centro de custo de 	   :",Space(9),"","","CTT","",0,.F.}) // Tipo caractere
	aAdd(aParamBox,{1,"Centro de custo até     :",Space(9),"","","CTT","",0,.F.}) // Tipo caractere

	If ParamBox(aParamBox,"Extorno marcação",@aRet)
		vet:= aclone(aret)
		MONTATRAB(@_carq)
		cCadastro := msgmarkbrow
		MarkBrow( 'TMP', 'OK',,_afields,, cMark,"u_MarkAll('tmp')",,,,"u_Mark('tmp')")
		DbCloseArea()      				// fecha a tabela temporária
		MsErase(_carq+GetDBExtension(),,"DBFCDX")	// apaga a tabela temporária
	Endif
	
	Return

//--------------------- Seleciona dados para o browser -------------------------------------------------------

static functIon MONTATRAB(_carq)
		_astru:={}
		_afields := {}

	// Estrutura da tabela temporaria
	AADD(_astru,        { "OK"		        ,"C"	 ,2								, 0 })
	aAdd(_astru,      	{ "PB7_FILIAL"		,"C"     , TamSx3("PB7_FILIAL")[1]      , 0 })
	aAdd(_astru,      	{ "PB7_MAT"	        ,"C"     , TamSx3("PB7_MAT")[1]         , 0 })
	aAdd(_astru,      	{ "RA_NOME"		    ,"C"     , TamSx3("RA_NOME")[1]         , 0 })
	aAdd(_astru,      	{ "PB7_DATA"		,"D"     , TamSx3("PB7_DATA")[1]        , 0 })
	aAdd(_astru,      	{ "PB7_VERSAO"		,"N"     , TamSx3("PB7_VERSAO")[1]      , 0 })

	// cria a tabela temporária
	@_carq:="T_"+Criatrab(,.F.)
	MsCreate(@_carq,_astru,"DBFCDX")
	// atribui a tabela temporária ao alias TMP
	dbUseArea(.T.,"DBFCDX",@_cARq,"TMP",.T.,.F.)
	// alimenta a tabela temporária

 	selecdata(1)

	Dbselectarea("TRB")
	DBGOTOP()
	WHILE !Eof()
		IF TRB->PB7_STATUS = "6"
			DBSELECTAREA("TMP")
			RECLOCK("TMP",.T.)
			TMP->PB7_FILIAL:=TRB->PB7_FILIAL
			TMP->PB7_MAT:=TRB->PB7_MAT
			TMP->RA_NOME:=TRB->RA_NOME
			TMP->PB7_DATA:=stod(TRB->PB7_DATA)
			TMP->PB7_VERSAO:=TRB->VERSAO

			MSUNLOCK()
		ENDIF
		DBSELECTAREA("TRB")
		DBSKIP()
	ENDDO

	AADD(_afields,{"PB7_FILIAL","","FILIAL"})
	AADD(_afields,{"PB7_MAT","","MAT"})
	AADD(_afields,{"RA_NOME","","NOME"})
	AADD(_afields,{"PB7_DATA","","DATA"})
	AADD(_afields,{"PB7_VERSAO","","VERSAO"})

	DbSelectArea("TMP")
	DbGotop()
	
return

// Função para marcar todos os registros do browse
User Function Marcar(alias)
	Local oMark := GetMarkBrow()
	DbSelectArea(alias)
	DbGotop()
	While !Eof()
		IF RecLock( alias, .F. )
			OK := cMark
			MsUnLock()
		EndIf
		dbSkip()
	Enddo
	MarkBRefresh( )      		// atualiza o browse
	oMark:oBrowse:Gotop()	// força o posicionamento do browse no primeiro registro
return

// Função para desmarcar todos os registros do browse
User Function DESMARCAR(alias)
	Local oMark := GetMarkBrow()
	DbSelectArea(alias)
	DbGotop()
	While !Eof()
		IF RecLock( alias, .F. )
			OK := SPACE(2)
			MsUnLock()
		EndIf
		dbSkip()
	Enddo
	MarkBRefresh( )		// atualiza o browse
	oMark:oBrowse:Gotop()	// força o posicionamento do browse no primeiro registro
Return

// Função para grava marca no campo se não estiver marcado ou limpar a marca se estiver marcado
User Function Mark(alias)
	If IsMark( 'OK', cMark )
		RecLock( alias, .F. )
		Replace OK With Space(2)
		MsUnLock()
	Else
		RecLock( alias, .F. )
		Replace OK With cMark
		MsUnLock()
	EndIf
Return

// Função para gravar\limpar marca em todos os registros
User Function MarkAll(alias)
	Local oMark := GetMarkBrow()
	dbSelectArea(alias)
	dbGotop()
	While !Eof()
		u_Mark(alias)
		dbSkip()
	End
	MarkBRefresh( )		// atualiza o browse
	oMark:oBrowse:Gotop()	// força o posicionamento do browse no primeiro registro

Return
/*
// Função : AEXTAPROV(alias)
// alias: 	Nome da ta tabela do browser
//          INCLUSAO DE UMA NOVA LINHA NA PB7 CONTENDO O REGISTRO COM STATUS = 1
//          LIMPAR REGISTROS DE APROVACAO NA TABELA PBB
*/

user function AEXTAPROV(ALIAS)
	Local cquery := ""

	DbSelectArea(alias)
	DbGotop()
	While !Eof()
		IF !empty(OK) 
			cQuery	:= 	" SELECT   *                                     "+CRLF
			cQuery	+= 	" FROM "+RetSqlName("PB7")+" PB7                 "+CRLF
			cQuery	+= 	" WHERE                                          "+CRLF
			cQuery	+= 	"     PB7_FILIAL = '"+(ALIAS)->PB7_FILIAL+"'     "+CRLF
			cQuery	+= 	" AND PB7_MAT    = '"+(ALIAS)->PB7_MAT+   "'     "+CRLF
			cQuery	+= 	" AND PB7_DATA   = '"+DToS((ALIAS)->PB7_DATA)+"' "+CRLF
			cQuery	+= 	" AND PB7_VERSAO =  "+ALLTRIM(STR((ALIAS)->PB7_VERSAO))+"      "+CRLF

			//MEMOWRITE("C:\Protheus\TESTE.sql",cQuery)

			If Select("TRC") > 0
				TRC->(dbCloseArea())
			EndIf
			DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), "TRC", .F., .F.)

			Dbselectarea("TRC")
			DBGOTOP()
			
			// cria registro na PB7 com uma nova versao
			RecLock( "PB7", .T. )
			PB7->PB7_FILIAL	:=	TRC->PB7_FILIAL
			PB7->PB7_MAT	:=	TRC->PB7_MAT
			PB7->PB7_DATA	:=	stod(TRC->PB7_DATA)
			PB7->PB7_VERSAO	:=	(TRC->PB7_VERSAO)+1
			PB7->PB7_1E		:=	TRC->PB7_1E
			PB7->PB7_1S		:=	TRC->PB7_1S
			PB7->PB7_2E		:=	TRC->PB7_2E
			PB7->PB7_2S		:=	TRC->PB7_2S
			PB7->PB7_3E		:=	TRC->PB7_3E
			PB7->PB7_3S		:=	TRC->PB7_3S
			PB7->PB7_4E		:=	TRC->PB7_4E
			PB7->PB7_4S		:=	TRC->PB7_4S
			PB7->PB7_HRPOSV	:=	TRC->PB7_HRPOSV
			PB7->PB7_HRPOSE	:=	TRC->PB7_HRPOSE
			PB7->PB7_HRPOSJ	:=	TRC->PB7_HRPOSJ
			PB7->PB7_HRNEGV	:=	TRC->PB7_HRNEGV
			PB7->PB7_HRNEGE	:=	TRC->PB7_HRNEGE
			PB7->PB7_HRNEGJ	:=	TRC->PB7_HRNEGJ
			PB7->PB7_CODUSE	:=	TRC->PB7_CODUSE
			PB7->PB7_1ECMAN	:=	TRC->PB7_1ECMAN
			PB7->PB7_1SCMAN	:=	TRC->PB7_1SCMAN
			PB7->PB7_2ECMAN	:=	TRC->PB7_2ECMAN
			PB7->PB7_2SCMAN	:=	TRC->PB7_2SCMAN
			PB7->PB7_3ECMAN	:=	TRC->PB7_3ECMAN
			PB7->PB7_3SCMAN	:=	TRC->PB7_3SCMAN
			PB7->PB7_4ECMAN	:=	TRC->PB7_4ECMAN
			PB7->PB7_4SCMAN	:=	TRC->PB7_4SCMAN
			PB7->PB7_JUSMAR	:=	TRC->PB7_JUSMAR
			PB7->PB7_ORDEM	:=	TRC->PB7_ORDEM
			PB7->PB7_TURNO	:=	TRC->PB7_TURNO
			PB7->PB7_PAPONT	:=	TRC->PB7_PAPONT
			PB7->PB7_SEQJRN	:=	TRC->PB7_SEQJRN
			PB7->PB7_APONTA	:=	TRC->PB7_APONTA
			PB7->PB7_1ECAHR	:=	TRC->PB7_1ECAHR
			PB7->PB7_1SCAHR	:=	TRC->PB7_1SCAHR
			PB7->PB7_2ECAHR	:=	TRC->PB7_2ECAHR
			PB7->PB7_2SCAHR	:=	TRC->PB7_2SCAHR
			PB7->PB7_3ECAHR	:=	TRC->PB7_3ECAHR
			PB7->PB7_3SCAHR	:=	TRC->PB7_3SCAHR
			PB7->PB7_4ECAHR	:=	TRC->PB7_4ECAHR
			PB7->PB7_4SCAHR	:=	TRC->PB7_4SCAHR
			PB7->PB7_1ECATP	:=	TRC->PB7_1ECATP
			PB7->PB7_1SCATP	:=	TRC->PB7_1SCATP
			PB7->PB7_2ECATP	:=	TRC->PB7_2ECATP
			PB7->PB7_2SCATP	:=	TRC->PB7_2SCATP
			PB7->PB7_3ECATP	:=	TRC->PB7_3ECATP
			PB7->PB7_3SCATP	:=	TRC->PB7_3SCATP
			PB7->PB7_4ECATP	:=	TRC->PB7_4ECATP
			PB7->PB7_4SCATP	:=	TRC->PB7_4SCATP
			PB7->PB7_STATUS	:=	If(TRC->PB7_HRPOSV == 0 .AND. TRC->PB7_HRNEGV ==  0, "0", "1")
			PB7->PB7_STAATR	:=	If(TRC->PB7_HRNEGV == 0, "0", "1")
			PB7->PB7_STAHE	:=	If(TRC->PB7_HRPOSV == 0, "0", "1")
			PB7->PB7_AFASTA	:=	TRC->PB7_AFASTA
			PB7->PB7_ALTERH	:=	TRC->PB7_ALTERH
			PB7->PB7_CC	    :=	TRC->PB7_CC
			MsUnLock()


			//-> RollBack nas Aprovações.
			DBSELECTAREA("PBB")
			PBB->( dbSetOrder(2) ) //PBB_FILIAL+PBB_FILMAT+PBB_MAT+DTOS(PBB_DTAPON)+PBB_NIVEL+PBB_GRUPO+PBB_APROV
			If PBB->( dbSeek( xFilial("PBB")+(ALIAS)->PB7_FILIAL+(ALIAS)->PB7_MAT+DTOS((ALIAS)->PB7_DATA)))
				
				PBB->( RecLock("PBB",.F.) )
				PBB->( dbDelete() )
				PBB->( MsUnLock() )
				PBB->( dbSkip()   )
				
			EndIf
		EndIf
		DbSelectArea(alias)
		dbSkip()
	Enddo
	MarkBRefresh( )		// atualiza o browse
	oMark:oBrowse:Gotop()	// força o posicionamento do browse no primeiro registro
	
	If Select("TRC") > 0
		TRC->(dbCloseArea())
	EndIf
	
	// Refresh da markbrowser após acionado o botao de alterar.
	CloseBrowse() // fecha o browser
	DbCloseArea()      				// fecha a tabela temporária
	MsErase(_carq+GetDBExtension(),,"DBFCDX")	// apaga a tabela temporária
	MONTATRAB(@_carq) // reabre um novo browser com os dados atualizados.
	cCadastro := msgmarkbrow
	MarkBrow( 'TMP', 'OK',,_afields,, cMark,"u_MarkAll('tmp')",,,,"u_Mark('tmp')",{|| u_MarkAll('tmp')})

RETURN

static function selecdata(nopc) // '1 = parambox, 2 = markbrow'
	Local cQuery 	 := ""
	Local i			 := 1
	Local MV_PAR_RET := ""
	
	//Monta Query de acordo com os parametros informados
	if nopc = 1 
		cQuery	:= 	" SELECT TMP.* ,PB7_STATUS  									       "+CRLF
	else
		cQuery	:= 	" SELECT TMP.PB7_MAT MAT,TMP.RA_NOME NOME							   "+CRLF
	endif	
		cQuery	+= 	" FROM "+RetSqlName("PB7")+" B7,                                       "+CRLF
		cQuery	+= 	"      "+RetSqlName("RCC")+" RCC,                                      "+CRLF
		cQuery	+= 	" 		(SELECT                                                        "+CRLF
		cQuery	+= 	" 			'  ' ok                                                    "+CRLF
		cQuery	+= 	" 			,PB7_FILIAL                                                "+CRLF
		cQuery	+= 	" 			,PB7_MAT                                                   "+CRLF
		cQuery	+= 	" 			,RA_NOME                                                   "+CRLF
		cQuery	+= 	" 			,PB7_DATA                                                  "+CRLF
		cQuery	+= 	" 			,max(PB7_VERSAO) VERSAO                                    "+CRLF
		
		cQuery	+= 	" 		FROM  "+RetSqlName("PB7")+" PB7 left join "+RetSqlName("PBB")+" PBB on ( PBB.PBB_FILMAT = PBB_FILIAL AND PB7_DATA = PBB_DTAPON AND PB7.PB7_MAT = PBB_MAT AND PBB.D_E_L_E_T_ = ' ' )
		cQuery	+= 	" 		inner join "+RetSqlName("SRA")+"  RA  on (	RA_MAT = PB7_MAT )   
		
		cQuery	+= 	" 		WHERE                                                          "+CRLF
		cQuery	+= 	" 				RA_FILIAL = '"+ xFilial("SRA") + "'                    "+CRLF
		cQuery	+= 	" 			AND PB7_FILIAL = '"+ xFilial("PB7")+ "'                    "+CRLF
		cQuery	+= 	" 			AND RA.D_E_L_E_T_ = ' '                                    "+CRLF
		cQuery	+= 	" 			AND PB7.D_E_L_E_T_ = ' '                                   "+CRLF
	if nopc = 1
			cQuery	+= 	" 			AND RA_CC BETWEEN '"+vet[4]+"' AND '"+vet[5]+"'            "+CRLF
		if !empty(vet[3]) 	
		FOR I:= 1 TO LEN(Vet[3])
			IF SUBSTR(Vet[3],I,1)<>','
				MV_PAR_RET += SUBSTR(Vet[3],I,1)
			ELSE
				MV_PAR_RET += "','"
			ENDIF
		NEXT
	 		cQuery	+= 	" 			AND RA_MAT in('"+MV_PAR_RET+"')								   "+CRLF
	 	endif
			cQuery	+= 	" 			AND PB7_PAPONT BETWEEN '"+vet[1]+"' AND '"+vet[2]+"' 	   "+CRLF
	endif	
		cQuery	+= 	" 			AND TRIM(RA_MAT) IS NOT NULL                               "+CRLF
		cQuery	+= 	"	 	GROUP BY  PB7_FILIAL                                           "+CRLF
		cQuery	+= 	" 			,PB7_MAT                                                   "+CRLF
		cQuery	+= 	" 			,RA_NOME                                                   "+CRLF
		cQuery	+= 	" 			,PB7_DATA )TMP                                             "+CRLF
		cQuery	+= 	" WHERE       													   	   "+CRLF
		cQuery	+= 	" 		B7.PB7_FILIAL = TMP.PB7_FILIAL       						   "+CRLF
		cQuery	+= 	" 	AND B7.PB7_VERSAO = TMP.VERSAO       		   		   		   	   "+CRLF
		cQuery	+= 	" 	AND B7.PB7_DATA = TMP.PB7_DATA     		   		   		   	   	   "+CRLF
		cQuery	+= 	" 	AND B7.PB7_MAT = TMP.PB7_MAT      		   		   		   	   	   "+CRLF
		cQuery	+= 	" 	AND B7.PB7_STATUS = '6'       		   		   		   		   	   "+CRLF
		cQuery	+= 	" 	AND B7.D_E_L_E_T_ = ' '       		   		   		   		   	   "+CRLF
		cQuery	+= 	" 	AND RCC_CODIGO = 'U007'											   "+CRLF
		cQuery	+= 	" 	AND SUBSTR(RCC_CONTEU,17,1) = '1'								   "+CRLF
		cQuery	+= 	" 	AND SUBSTR(RCC_CONTEU,1,16) = B7.PB7_PAPONT						   "+CRLF
		cQuery	+= 	" 	AND RCC.D_E_L_E_T_ = ' '										   "+CRLF
		
	if nopc = 2
		cQuery	+= 	" 	GROUP BY    tmp.pb7_mat, TMP.RA_NOME					   			"+CRLF
		cQuery	+= 	"   ORDER BY    tmp.pb7_mat									   			"+CRLF
	else
		cQuery	+= 	" 	ORDER BY tmp.pb7_mat,tmp.pb7_data					 		 	 	"+CRLF
	ENDIF
		
		
	MEMOWRITE("C:\Protheus\TESTE.sql",cQuery)
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), "TRB", .F., .F.)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  FMatricula        ³ Autor ³Leandro Nishihata              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Monta tela de seleção de Funcionarios                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para o CERTISIGN                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user Function FMatricula()
Local _nome		:={}
Local _Matricula:= ""
Local _Temp 	:= ""
Local _MV_PAR 	:= space(6)
Local _cTamanho :=1
Local i			:= 1

selecdata(2)
			 	
Dbselectarea("TRB")
Dbgotop()
While !trb->(eof())
	aadd(_nome,TRB->NOME )
	_Matricula+=""+TRB->MAT
	TRB->(Dbskip())
Enddo
f_Opcoes(@_Temp,'Selecione as matriculas',_nome,_Matricula,,,.F.,06,30)
TRB->(DbCloseArea())
_MV_PAR:=""

For i:=1 to len(_Temp)
	If Substr(_Temp,i,1) # '*'
		_MV_PAR += Substr(_Temp,I,1)
			IF _cTamanho  = 6
			   _MV_PAR   += ","
			   _cTamanho :=1
			Else
				_cTamanho ++
			Endif
	Endif
Next
_MV_PAR := substr(_MV_PAR,1,len(_MV_PAR)-1)

Return _MV_PAR