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
@author  -       EXCLUSIVO PARA O SCHEDULE.
@since 06/11/2012
/*/
//--------------------------------------------------------------
User Function ImpTXT1() 
                
RpcClearEnv()   
RpcSetType(3)
RpcSetEnv("01","01",,,,GetEnvServer(),{ "SC2" } )//"99"
SetModulo( "SIGAFAT" , "FAT" )


PRIVATE OPINI
PRIVATE OPFIM
      
PRIVATE ALSC2 := GETNEXTALIAS()   
      
PRIVATE LGO := .T.

//PERGUNTAS()   

SELREGS()
GERATXT()
ATUSC2() 

RpcClearEnv()

Return     

STATIC FUNCTION PERGUNTAS()

Private aRet 		:= {}
Private aParambox   := {}  
Private lRet        := .T.        
Private cCadastro   := "" 

// PARA TIPO 1 = MSGET:TIPO, DESCRICAO, INICIALIZADOR CAMPO, PICTURE CAMPO,VALIDACAO, F3,WHEN,TAMANHO,OBRIGATORIO(T/F)  
//Aadd(aParambox,{1,"Data Inicial"         ,  ,"99/99/99" ,"","","",0,.T.})         
Aadd(aParambox,{1,"OP de:"    , space(11) ,           ,"","SC2","",0,.F.})         // 09      
Aadd(aParambox,{1,"OP até"    , space(11) ,           ,"","SC2","",0,.T.})         // 09           

// para tipo 2 = combo: TIPO, DESCRICAO, OPCAO INICIAL, TAMANHO, VALIDACAO, OBRIG
//Aadd(aParambox,{1,"Inter ",Space(8),'99/99/99',"","","",0,.f.})          


IF Parambox(aParambox,"SELEÇÃO DAS OPS",@aRet,   ,         , .T.      ,     ,      ,         ,      ,.T.,.T.)
	OPINI     := ARET[1]
	OPFim     := ARET[2]
else
	lGo := .F.
ENDIF	          
	

return      
             
             
STATIC FUNCTION SELREGS()

IF SELECT(ALSC2) > 0
	(ALSC2)->(DBCLOSEAREA())
ENDIF

CQRY := ""
CQRY += " SELECT  "
CQRY += "  C2_FILIAL, C2_NUM, C2_ITEM, C2_SEQUEN, C2_PEDIDO, C2_ITEMPV, C2_PRODUTO, C2_XLACRE "
CQRY += "  , C6_NUM, C6_PRODUTO, C6_XLACRE, C6_XINIC, C6_XFIM, A1_NOME                        "
CQRY += "  , B1_DESC, B1_TIPOBAR, B1_CODBAR                                                   "
CQRY += " FROM "
CQRY += RETSQLNAME("SC2") + " C2 "
CQRY += ", " + RETSQLNAME("SC6") + " C6 "
CQRY += ", " + RETSQLNAME("SB1") + " B1 "
CQRY += ", " + RETSQLNAME("SA1") + " A1 "
CQRY += " WHERE "
CQRY += "     B1.D_E_L_E_T_ = '' "
CQRY += " AND C2.D_E_L_E_T_ = '' "
CQRY += " AND C6.D_E_L_E_T_ = '' "
CQRY += " AND A1.D_E_L_E_T_ = '' "
CQRY += " AND C6_FILIAL = '" + XFILIAL("SC6") + "' "
CQRY += " AND C2_FILIAL = '" + XFILIAL("SC2") + "' "
CQRY += " AND B1_FILIAL = '" + XFILIAL("SB1") + "' "   
CQRY += " AND A1_FILIAL = '" + XFILIAL("SA1") + "' "
CQRY += " AND C2_PEDIDO = C6_NUM "
CQRY += " AND C2_ITEMPV = C6_ITEM "
CQRY += " AND C2_PRODUTO = B1_COD "
CQRY += " AND C6_PRODUTO = B1_COD "  
CQRY += " AND C6_CLI = A1_COD  AND C6_LOJA = A1_LOJA  "  
cqry += " AND C2_TXT <> 'S' "
CQRY += " ORDER BY C2_NUM, C2_ITEM , C2_SEQUEN "
DbUseArea( .t.		, "TOPCONN"		, TcGenQry(,, cQry), (alSC2) )
                                                               
DBSELECTAREA(ALSC2)
DBGOTOP()  


RETURN             

STATIC FUNCTION GERATXT()
               
Local _cArqNom 	:= " "
Local _nTamLin  	:= 100
Local _nBytes  	:=0
Local _cBuffer  	:= Space(_nTamLin+2)
Local _nSequen  	:= 0
local _aTXT			:={}      
lOCAL _cPath        := "\IMPTXTSC2\"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pegar e gravar o proximo numero do txt                   ³
//³ Posicionar no sx6 utilizando GetMv. N„o Utilize Seek !!! ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
local _cSequen := Getmv("MV_TXTSC2") 
      _cSequen := SOMA1(_cSequen,1)
	  PutMv("MV_TXTSC2",_cSequen) 
      
DBSELECTAREA(ALSC2)                                          
DBGOTOP()
IF EOF()
	RETURN
ENDIF

DO WHILE !EOF()   
/*00000000001;000001;000001;EAN13;1010102

onde

0000000001=> Numero da OP
000001=> Lacre Inicial
000100=>Lacre Final
EAN13=>Tipo Cod. Barras
1010102020123=>Código de Barras
*/
	_c1 := STRTRAN(PADR((alsc2)->C2_NUM + (alsc2)->C2_ITEM + (alsc2)->C2_SEQUEN,11)     ,";"," ") + ";"  
	_c6 := STRTRAN(PADR((alsc2)->C6_XLACRE	  ,GetSx3Cache("C6_XLACRE"  , "X3_TAMANHO")),";"," ") + ";"	
	_c2 := STRTRAN(PADR((alsc2)->C6_XINIC	  ,GetSx3Cache("C6_XINIC"   , "X3_TAMANHO")),";"," ") + ";"
	_c3 := STRTRAN(PADR((alsc2)->C6_XFIM	  ,GetSx3Cache("C6_XFIM"    , "X3_TAMANHO")),";"," ") + ";"
	_c4 := STRTRAN(PADR((alsc2)->B1_TIPOBAR   ,GetSx3Cache("B1_TIPOBAR" , "X3_TAMANHO")),";"," ") + ";"
	_c5 := STRTRAN(PADR((alsc2)->B1_CODBAR	  ,GetSx3Cache("B1_CODBAR"  , "X3_TAMANHO")),";"," ") + ";"
	_c7 := STRTRAN(PADR((alsc2)->A1_NOME	  ,GetSx3Cache("A1_NOME"    , "X3_TAMANHO")),";"," ") + ";"
	_c8 := STRTRAN(PADR(SM0->M0_CGC	          ,GetSx3Cache("A1_CGC"     , "X3_TAMANHO")),";"," ")
									
	_cSeq     :=_C1 + _c6 + _C2 + _C3 + _C4 + _C5 + _c7	+ _c8		
		
	aadd(_aTxt,_cSeq)
	DBSELECTAREA(ALSC2)
	(ALSC2)->(DBSKIP())
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
Endif

fClose(_nContab) 

RETURN     

STATIC FUNCTION ATUSC2()

DBSELECTAREA(ALSC2)
DBGOTOP()
DO WHILE !(ALSC2)->(EOF())
//	U_UPDCAMPO(TABELA,CAMPO, FILTRO, VALORF,VALORC,FILTRO1,VALORF1,FILTRO2,VALORF2,FILTRO3,VALORF3,DELETADOS)   
	U_UPDCAMPO('SC2','C2_TXT', '(C2_NUM+C2_ITEM+C2_SEQUEN)', ((ALSC2)->(C2_NUM+C2_ITEM+C2_SEQUEN)),'S',"C2_FILIAL",XFILIAL("SC2"))   	
	DBSELECTAREA(ALSC2)
	(ALSC2)->(DBSKIP())
ENDDO      

RETURN