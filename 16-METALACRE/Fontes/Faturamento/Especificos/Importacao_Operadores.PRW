#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"                                                                                                         
#INCLUDE "COLORS.CH"     
#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"   
//--------------------------------------------------------------
/*/{Protheus.doc} HISTCLI
Description

@param xParam Parameter Description
@return xRet Return Description
@author  -
@since 06/11/2012
/*/
//--------------------------------------------------------------
User Function ImpOPE()  

RpcClearEnv()   
RpcSetType(3)
RpcSetEnv("01","01",,,,GetEnvServer(),{ "SRA" } )//"99"
SetModulo( "SIGAFAT" , "FAT" )


PRIVATE ALOPE := GETNEXTALIAS()   
private AlTAB := "SRA"
PRIVATE ALCPO := "RA"
      
PRIVATE LGO := .T.



SELREGS()

GERATXT()
ATUSC2() 

RpcClearEnv()

Return     

STATIC FUNCTION SELREGS()

IF SELECT(ALOPE) > 0
	(ALOPE)->(DBCLOSEAREA())
ENDIF

CQRY := ""
CQRY += " SELECT * FROM "
CQRY += RETSQLNAME(ALTAB) + " " + ALCPO + " "
CQRY += " WHERE "
CQRY += "     " + ALCPO + ".D_E_L_E_T_ = '' "
cqry += " AND " + ALCPO + "_INTEGRA <> 'S' "
CQRY += " ORDER BY "  + ALCPO + "_MAT, " + ALCPO + "_NOME "
DbUseArea( .t.		, "TOPCONN"		, TcGenQry(,, cQry), (ALOPE) )
                                                               
DBSELECTAREA(ALOPE)
DBGOTOP()   
IF !EOF()

ELSE
	lGo := .F.
	MSGALERT("Não existem dados para serem exportados.")
endif


RETURN             

STATIC FUNCTION GERATXT()
               
Local _cArqNom 	:= " "
Local _nTamLin  	:= 100
Local _nBytes  	:=0
Local _cBuffer  	:= Space(_nTamLin+2)
Local _nSequen  	:= 0
local _aTXT			:={}      
lOCAL _cPath        := "\IMPTXTOPE\"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pegar e gravar o proximo numero do txt                   ³
//³ Posicionar no sx6 utilizando GetMv. N„o Utilize Seek !!! ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
local _cSequen := Getmv("MV_TXTOPE") 
      _cSequen := SOMA1(_cSequen,1)
	  PutMv("MV_TXTOPE",_cSequen) 
      
DBSELECTAREA(ALOPE)                                              
DBGOTOP()
IF EOF()
	RETURN
ENDIF

DO WHILE !EOF()   
	_c1 := STRTRAN(PADR((ALOPE)->RA_MAT,6),";"," ")                                      +";"
	_c2 := STRTRAN(PADR((ALOPE)->RA_NOME,GetSx3Cache("RA_NOME", "X3_TAMANHO")) ,";"," ") 
									
	_cSeq     :=_C1 + _C2 
	aadd(_aTxt,_cSeq)
	DBSELECTAREA(ALOPE)
	(ALOPE)->(DBSKIP())
ENDDO                 

_cArqNom  := DTOS(DDATABASE) 

IF !EXISTDIR(ALLTRIM(_cPath))
	MAKEDIR ( _cPath ) 
endif 

_cArqCont := _cPath+_cArqNom+_cSequen+".TXT"            // Path do arquivo/Nome do arquivo de LOG


_nContab  := fOpen(_cArqCont,2)	                           // Abre o arquivo


If _nContab == -1
	_nContab := MsfCreate(_cArqCont)
Else
	_nTamArq := Int(fSeek(_nContab,0,2))
	_nBytes  := fRead(_nContab,@_cBuffer,_nTamArq)	       // Le o arquivo inteiro
Endif

if !empty(_aTxt)
	For _t := 1 to len(_aTxt)
		_cSeq:=_aTxt[_t]
		Fwrite(_nContab,_cSeq+chr(13)+chr(10))
	Next 
	MSGALERT("TXT Gerado com sucesso. Arquivo " + _cArqCont)
Endif

fClose(_nContab) 

RETURN     

STATIC FUNCTION ATUSC2()

DBSELECTAREA(ALOPE)
DBGOTOP()
DO WHILE !(ALOPE)->(EOF())
//	U_UPDCAMPO(TABELA,CAMPO, FILTRO, VALORF,VALORC,FILTRO1,VALORF1,FILTRO2,VALORF2,FILTRO3,VALORF3,DELETADOS)   
	U_UPDCAMPO(ALTAB, 'RA_INTEGRA', 'RA_MAT', ((ALOPE)->RA_MAT),'S',"RA_FILIAL",XFILIAL(ALTAB))   	
	DBSELECTAREA(ALOPE)
	(ALOPE)->(DBSKIP())
ENDDO      

RETURN