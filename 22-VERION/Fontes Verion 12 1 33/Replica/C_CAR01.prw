#INCLUDE "protheus.ch"

User Function C_CAR01(Empr,Fili,Mdtab,TpOpx,cdTab)        
Local _stru:={}
Local aCpoBro := {}
Local oDlgLocal 
aCores := {}
Private lInverte := .F.
Private cMark   := GetMark()   
Private oMark
nOpca    := 1                   
_cEmpr   := Empr
_cFili   := Fili                 
_cmodtb  := Mdtab
_lCdCnt  := .T.
_cOpRtn  := TpOpx       
_cOpenTb := cdTab
_cSx2Ori := ""   // sx2 de origem para usar na comparacao de compartilhamento
_aAllEmp := {}   // todas as empresas para o browse
_lVtLock := .T.  // SE DEVE OU NAO MONTAR O MARKBROWSE
_cTbMdo1 := ""   // se a tabela e exclusiva ou compartilhada...
_cTbMdo2 := ""   // se a tabela e exclusiva ou compartilhada...
_aTbMdo3 := {}   // Array com as filiais que tem a tabela exclusiva e compartilhada...
_nScan   := 0 
AEMPACH  := {}   // ARRAY COM AS EMPRESAS MARCADAS

//Cria um arquivo de Apoio
AADD(_stru,{"OK"        ,"C"	,02		,0		})
AADD(_stru,{"CODIGO"    ,"C"	,02		,0		})
AADD(_stru,{"FILIAL"    ,"C"	,02		,0		})
AADD(_stru,{"NOME"      ,"C"	,40		,0		})
AADD(_stru,{"NOMF"      ,"C"	,60		,0		})
AADD(_stru,{"STATX"     ,"C"	,01		,0		})

cArq := Criatrab(_stru,.T.)
DBUSEAREA(.t.,,carq,"TTRB")

// caso a empresa nao seja a primeira
IF _cEmpr <> "01"
	DbSelectArea("SM0")
	DbGotop()
	While  SM0->(!Eof())   

    		IF  _cEmpr == SM0->M0_CODIGO .AND. _cFili == SM0->M0_CODFIL
		        _cSx2Ori := ""
				_CSX2Ach := "SX2"+ALLTRIM(_cEmpr)+"0"
				
				/*
				DbUseArea(.T.,,_CSX2Ach,"TTRX",.T.,.F.)
				dbsetorder(1)
				DbGotop()
				MsSeek(_cOpenTb)
				While !Eof() .and. alltrim(TTRX->X2_CHAVE) == _cOpenTb
                		_cSx2Ori := TTRX->X2_ARQUIVO						
		                _cTbMdo1 := TTRX->X2_MODO   // se a tabela e exclusiva ou compartilhada...                
						dbSelectArea("TTRX")
						dbSkip()
				End
        
        		TTRX->(DbCloseArea())
				*/

           		_cSx2Ori := FWSX2Util():GetFile( _cOpenTb ) //TTRX->X2_ARQUIVO						
                _cTbMdo1 := "C" //TTRX->X2_MODO   // se a tabela e exclusiva ou compartilhada...                


		        // verifica se ja existe no array unico de empresa
				_nScan := aScan(_aTbMdo3,{|x| x[1] == SM0->M0_CODIGO})  
	
				If ( _nScan==0 )
					aadd(_aTbMdo3,{SM0->M0_CODIGO})
				Endif
            endif
            
    		DbSelectArea("SM0")
			SM0->(DbSkip()) 
			LOOP
	End
ENDIF


//Alimenta o arquivo de apoio com os registros do cadastro de clientes (SA1)
DbSelectArea("SM0")
DbGotop()
While  SM0->(!Eof())   

    // nao coloca no browse a empresa/filial de origem 
    IF  _cEmpr == SM0->M0_CODIGO .AND. _cFili == SM0->M0_CODFIL
        _cSx2Ori := ""
		_CSX2Ach := "SX2"+ALLTRIM(_cEmpr)+"0"
				
		DbUseArea(.T.,,_CSX2Ach,"TTRX",.T.,.F.)
		dbsetorder(1)
		DbGotop()
		MsSeek(_cOpenTb)
		While !Eof() .and. alltrim(TTRX->X2_CHAVE) == _cOpenTb
                _cSx2Ori := TTRX->X2_ARQUIVO						
                _cTbMdo1 := TTRX->X2_MODO   // se a tabela e exclusiva ou compartilhada...                
				dbSelectArea("TTRX")
				dbSkip()
		End
        
        TTRX->(DbCloseArea())

        // verifica se ja existe no array unico de empresa
		_nScan := aScan(_aTbMdo3,{|x| x[1] == SM0->M0_CODIGO})  
	
		If ( _nScan==0 )
			aadd(_aTbMdo3,{SM0->M0_CODIGO})
		Endif

	    DbSelectArea("SM0")
		SM0->(DbSkip()) 
		LOOP

    ELSE

      IF _cOpenTb == "SRV"
	        _cSx2Ori := ""
			_CSX2Ach := "SX2"+ALLTRIM(SM0->M0_CODIGO)+"0"
					
			DbUseArea(.T.,,_CSX2Ach,"TTRX",.T.,.F.)
			dbsetorder(1)
			DbGotop()
			MsSeek(_cOpenTb)
			While !Eof() .and. alltrim(TTRX->X2_CHAVE) == _cOpenTb
        	        _cSx2Ori := TTRX->X2_ARQUIVO						
                    _cTbMdo1 := TTRX->X2_MODO   // se a tabela e exclusiva ou compartilhada...                
					dbSelectArea("TTRX")
					dbSkip()
			End
        
        	TTRX->(DbCloseArea())

	        // verifica se ja existe no array unico de empresa
			_nScan := aScan(_aTbMdo3,{|x| x[1] == SM0->M0_CODIGO})  
	
			If ( _nScan==0 )
				aadd(_aTbMdo3,{SM0->M0_CODIGO})
			Endif

      ENDIF
    ENDIF

    // nao coloca no browse as filiais da mesma empresa quando no sx2 estiver como compartilhado
   	IF  _cmodtb == "C" .AND. _cEmpr == SM0->M0_CODIGO 
		SM0->(DbSkip()) 
		LOOP
   	ENDIF

    // tratamento para tabelas comuns
    IF _cEmpr <> SM0->M0_CODIGO 
        _cNewAc := SM0->M0_CODIGO 
        _cS2Ori := ""
		_CS2Ach := "SX2"+ALLTRIM(_cNewAc)+"0"

		/*		
		DbUseArea(.T.,,_CS2Ach,"TRTX",.T.,.F.)
		dbsetorder(1)
		DbGotop()
		MsSeek(_cOpenTb)
		While !Eof() .and. alltrim(TRTX->X2_CHAVE) == _cOpenTb
                _cS2Ori  := TRTX->X2_ARQUIVO						
                _cTbMdo2 := TRTX->X2_MODO   // se a tabela e exclusiva ou compartilhada...                
				dbSelectArea("TRTX")
				dbSkip()
		End
        TRTX->(DbCloseArea())      
		*/ 

   		_cS2Ori := FWSX2Util():GetFile( _cOpenTb ) //TTRX->X2_ARQUIVO						
        _cTbMdo2 := "C" //TTRX->X2_MODO   // se a tabela e exclusiva ou compartilhada...                


        // tratamento para compartilhado no SX2 da mesma tabela do banco de dados
        IF _cSx2Ori == _cS2Ori                                                   
            DbSelectArea("SM0")
			SM0->(DbSkip()) 
			LOOP
		ENDIF	
    ENDIF


    Aadd(_aAllEmp,{SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_NOME,SM0->M0_NOMECOM,"0"})

	SM0->(DbSkip())
End

// VERIFICA SE E A MESMA TABELA E SE ESTA TABELA ESTA COMO EXCLUSIVA NO SX2
IF _cSx2Ori == _cS2Ori .AND. _cTbMdo2 = "E" .AND. _cTbMdo1 = "E"
   _clstEmp := ""
   for EP := 1 to len(_aTbMdo3)
          _clstEmp := _clstEmp+alltrim(_aTbMdo3[EP,1])+"/"
   next EP

   ApMsgAlert("Tabela "+_cS2Ori+", comum entre as empresas "+alltrim(_clstEmp)+", usando modo Exclusivo...")
ENDIF


// grava arquivo temporario
c_GrvTmp(_aAllEmp)

//Define as cores dos itens de legenda.
aCores := {}
aAdd(aCores,{"TTRB->STATX == '0'","BR_VERDE"	})
aAdd(aCores,{"TTRB->STATX == '1'","BR_AMARELO"	})
aAdd(aCores,{"TTRB->STATX == '2'","BR_VERMELHO"})

//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
aCpoBro	:= {{ "OK"			,, "Mark"           ,"@!"},;			
			{ "CODIGO"		,, "Codigo"         ,"99"},;		   
			{ "FILIAL"		,, "FILIAL"         ,"99"},;		   
			{ "NOME"		,, "Nome"           ,"@!"},;		   
			{ "NOMF"		,, "Filial"         ,"@!"}}

DbSelectArea("TTRB")
DbGotop()

if !_lVtLock //VERIFICA SE TEM REGISTRO NA TABELA
   TTRB->(DbCloseArea())
   RETURN(AEMPACH)
ENDIF

//Cria uma Dialog
DEFINE MSDIALOG oDlg TITLE "Filial de Destino" From 9,0 To 315,800 PIXEL
//Cria a MsSelect
oMark := MsSelect():New("TTRB","OK","",aCpoBro,@lInverte,@cMark,{17,1,150,400},,,,,aCores)
oMark:bMark := {| | Disp()} //Exibe a Dialog
ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End()},{|| nOpca := 2,oDlg:End()})  

if nopca = 1                                  
	AEMPACH := {}
	_lCdCnt := .T.

	DbSelectArea("TTRB")
	DbGotop()
	While  TTRB->(!Eof())   
    	   IF !EMPTY(TTRB->OK)
        	  AADD(AEMPACH, {TTRB->CODIGO,TTRB->FILIAL})
	       ENDIF
    	   TTRB->(DbSkip())
	End
endif

if nopca = 2
	AEMPACH := {}
	_lCdCnt := .F.
endif

//Fecha a Area e elimina os arquivos de apoio criados em disco.
TTRB->(DbCloseArea())
Iif(File(cArq + GetDBExtension()),FErase(cArq  + GetDBExtension()) ,Nil)
Return(AEMPACH)

//Funcao executada ao Marcar/Desmarcar um registro.   
Static Function Disp()
RecLock("TTRB",.F.)
If Marked("OK")	
	TTRB->OK := cMark
Else	
	TTRB->OK := ""
Endif             
MSUNLOCK()
oMark:oBrowse:Refresh()
Return()



// grava arquivo temporario
Static Function c_GrvTmp(AllEmp)
_aVtLock := AllEmp
_lVtLock := .T.

If Len(_aVtLock) > 0

	For Rc := 1 to Len(_aVtLock)
		DbSelectArea("TTRB")	
		RecLock("TTRB",.T.)	   
		TTRB->CODIGO    := _aVtLock[Rc,1] //SM0->M0_CODIGO
		TTRB->FILIAL    := _aVtLock[Rc,2] //SM0->M0_CODFIL
		TTRB->NOME      := _aVtLock[Rc,3] //SM0->M0_NOME
		TTRB->NOMF      := _aVtLock[Rc,4] //SM0->M0_NOMECOM
		TTRB->STATX     := "0"
		MsunLock("TTRB")	
	Next Rc
Else
   ApMsgAlert("Arquivo Compartilhado entre empresas. Operacao de Inclusao Invalida...")
   _lVtLock := .F.
Endif
Return
