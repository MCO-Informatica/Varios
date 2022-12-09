#include "rwmake.ch"
#include "topconn.ch"
#Include "Totvs.ch"
#include "Ap5Mail.ch"
#Include 'Protheus.ch'
#Include 'rwmake.ch'
#include 'COLORS.CH'    
 /**
 * @Classe - Funcionalidades integracao PCO Certisign
 * @author Gesse Santos
 * @Aug 11 2014
 * translate(CT1_E06DSC,'âàãáÁÂÀÃéêÉÊíÍóôõÓÔÕüúÜÚÇç','aaaaAAAAeeEEiIoooOOOuuUUCc')
 */
*************************************************************************************************************
&& Main Function e static function associada para Run
*************************************************************************************************************
User Function CSPCO001()
	private oPcoCS
	oPcoCS := PcoCertisign():New()	
	oPcoCS:getParam()
	if oPcoCS:VldPeriod()
		if aviso("Processo demorado","Sincroniza produtos?",{"Sim","Nao"}) == 1
			MsgRun("Sincronizando produtos..." ,,{|| stSynE07() })		
        endif
		if aviso("Processo demorado","Sincroniza clientes?",{"Sim","Nao"}) == 1
		   MsgRun("Sincronizando clientes..." ,,{|| stSyn1E05() })
		endif
		if aviso("Processo demorado","Sincroniza fornecedores?",{"Sim","Nao"}) == 1
			MsgRun("Sincronizando fornecedores..." ,,{|| stSyn2E05() })
		endif
		if aviso("Processo demorado","Sincroniza entidades contabeis?",{"Sim","Nao"}) == 1
			MsgRun("Sincronizando Contas x Classes x Operacoes..." ,,{|| stSynCT1() })
		endif                                
		MsgRun("Sincronizando movimentos..." ,,{|| stSynMov() })
	else
	   alert("Lancamentos - Ja existem lancamentos do razao no periodo!")
	endif		
	oPcoCS:endProcess()	
Return()

*************************************************************************************************************
&& Funcoes static - Separar os processamentos e viabilizar o MsgRun
*************************************************************************************************************
static function stSynE07()
   	oPcoCS:syncE07()
return()
static function stSyn2E05()
   	oPcoCS:sync2E05()
return() 
static function stSyn1E05()
   	oPcoCS:sync1E05()
return()
static function stSynCT1()
   	oPcoCS:syncCT1()
return()
static function stSynMov()

	oPcoCS:GetMov()
return()
*************************************************************************************************************
&& Class Builder
*************************************************************************************************************
class PcoCertisign
	Data cTotal         as string       &&  Metodo de totalizacao 
	Data cSId 			as string		&&  ID da sessao == UUUUUU + AAAAMMDD + HHMMSS
	Data nSeqId         as Integer      && Sequencia para compor a chave virtual para nao deletar AKD
	Data cType 			as string		&&  R|D 
	Data cDtIni			as string		&&  YYYYMMDD format
	Data cDtFin			as string		&&  YYYYMMDD format
	Data cModel			as string		&&  O|R 
    Data cFolder        as String       && Pasta para gravacao da planilha 
	Data cOrcCtb        as String       && Orcamrnto no contabil - Origem
	Data cGestor        as String       && Gestor para gerar junto com Danielle - Por enquando o codigo da Danielle esta chumbado mudar p MV
    Data cProc          as String       && Processo para validacao - de acordo com as escolhas do ParamBox
    
	Method New()        Constructor
	Method GetParam() 		
	Method VldPeriod() 		
	Method Sync1E05() 		
	Method Sync2E05() 
	Method SyncE07()
	Method SyncCT1()
	Method putCV0()	 		
	Method GetMov()
	Method MakePlanilha() 		
	Method BuildQuery()
	Method ClassifyMov() 	
	Method PutAkd() 		
	Method CallPtoLct() 	
	Method endProcess()
	Method GetMaxCv0()
endClass

*************************************************************************************************************
&& Constructor Method 
*************************************************************************************************************
Method New() Class PcoCertisign
	::cSId     := __cUserID+alltrim(dtos(dDataBase))+strtran(time(),":","") 
	::cType    := ""
	::cDtIni   := ""
	::cDtFin   := ""
	::cModel   := ""
	::cFolder  := ""
	::cProc    := ""
	::cTotal   := ""
	::cOrcCtb  := ""
	::cGestor  := ""
	::nSeqId   := 0
	
Return Self

*************************************************************************************************************
&& Metodos 
*************************************************************************************************************

*************************************************************************************************************
&& 
*************************************************************************************************************
Method GetMov() 		Class PcoCertisign
local aArea    	:= GetArea()
local csAlias   := ""
local cQuery    := ""

do case
case ::cModel == "1" && Realizado
	csAlias := ""	 
	do case
		case ::cType == "1"
			
			csAlias := oPcoCS:BuildQuery(::cTotal," SUBSTR(CT1_CONTA,1,1) = '1' AND "," SUBSTR(CT1_CONTA,1,4) NOT IN ('1302','1303','1304') AND ", "1","N")
			if !empty(csAlias)
			    oPcoCS:ClassifyMov(csAlias)
				oPcoCS:PutAkd()
			endif
					 
			csAlias := ""	 
			csAlias := oPcoCS:BuildQuery(::cTotal,""," SUBSTR(CT1_CONTA,1,4) IN ('1302','1303','1304') AND ", "1","N")
			if !empty(csAlias)
			    oPcoCS:ClassifyMov(csAlias)
				oPcoCS:PutAkd()
			endif    

		case ::cType == "2"                                              
		 	csAlias := oPcoCS:BuildQuery(::cTotal," SUBSTR(CT1_CONTA,1,1) = '2' AND ","", "1","N")
			if !empty(csAlias)
			    oPcoCS:ClassifyMov(csAlias)
				oPcoCS:PutAkd()
			endif		
		case ::cType == "3" 
		 	csAlias := oPcoCS:BuildQuery(::cTotal," SUBSTR(CT1_CONTA,1,1) = '3' AND ","", "1","N")
			if !empty(csAlias)
			    oPcoCS:ClassifyMov(csAlias)
				oPcoCS:PutAkd()
			endif
		case ::cType == "4"
	     	csAlias := oPcoCS:BuildQuery(::cTotal," SUBSTR(CT1_CONTA,1,1) = '4' AND ","", "1","S")
			if !empty(csAlias)
			    oPcoCS:ClassifyMov(csAlias)
				oPcoCS:PutAkd()
			endif
	endcase 
	
case ::cModel == "2" && Orcado
		
		csAlias := ""	 
		csAlias := oPcoCS:BuildQuery("","","", "0","")
		if !empty(csAlias)                  
			oPcoCS:ClassifyMov(csAlias)
			oPcoCS:PutAkd()
		endif
		
case ::cModel == "3" && Gera a planilha do PCO
	// Cria AK1
	// Copia de AK5 para AK3
	// Copia de CV1 para AK2
	// Gera AKG com o usuario que esta processando
	// Gera AKE com revisao "0001"

		if empty(::cOrcCtb)
			Alert("Orcamento contabil nao informado!")		
		else
			if empty(::cGestor)
				Alert("Gestor da planilia orcamentaria nao informado!")
		    else
		    	if !UsrExist(::cGestor) 
					Alert("Gestor da planilia orcamentaria nao informado!")
		        else 
					csAlias := ""	 
					csAlias := oPcoCS:BuildQuery("","","", "0","")
					if !empty(csAlias)                  
						oPcoCS:MakePlanilha(csAlias)
					endif		        
		        endif                                                                                      
			endif
        endif

endcase          

RestArea(aArea)
Return()

*************************************************************************************************************
&&  Constroi a planilha do PCO a partir do orcamento da contabilidade
&&  AK1, AK3, AK2, AKG, AKE 
*************************************************************************************************************
Method  MakePlanilha(cTab) 		Class PcoCertisign 
local __cCodPla := "000000000000000"
local __nLevel  := 1
local __cID     := "0001"
begin Transaction

&& Criacao do cabecalho da planilha
ak1->(dbsetorder(1))
if ak1->(dbseek(xfilial("AK1"), .t.))
	while !ak1->(eof()) .and. ak1->ak1_filial == xfilial("AK1")    
   		__cCodPla := alltrim(ak1->ak1_codigo)
		ak1->(dbskip())
	end-while
endif
__cCodPla := soma1(__cCodPla)
ak1->(Reclock("AK1",.t.)) 
ak1->ak1_filial    := xfilial("AK1")
ak1->ak1_codigo    := __cCodPla
ak1->ak1_versao    := "0001"
ak1->ak1_descri    := "ORCAMENTO CERTISIGN "
ak1->ak1_nmax      := 1
ak1->ak1_tpperi    := "3"
ak1->ak1_iniper    := stod(::cDtIni)
ak1->ak1_fimper    := stod(::cDtFin)
ak1->ak1_tprev     := "1"
ak1->ak1_status    := "1"
ak1->ak1_ctrusr    := "1"
ak1->ak1_fase      := "001"
ak1->(MsUnlock())
&& Cabecalho
ak5->(dbsetorder(1))
ak5->(dbseek(xfilial("AK5"), .t. )) 

ak3->(RecLock("AK3",.t.))
ak3->ak3_filial   := xfilial("AK3")
ak3->ak3_orcame   := __cCodPla 
ak3->ak3_versao   := "0001"
ak3->ak3_co       := substr(__cCodPla,1,12)
ak3->ak3_nivel    := "001"
ak3->ak3_descri   := "ORCAMENTO - CERTISIGN - "+substr(::cDtIni,1,4)
ak3->(MsUnlock())

akg->(RecLock("AKG",.t.))
akg->akg_filial   := xfilial("AKG")
akg->akg_orcame   := __cCodPla 
akg->akg_co       := substr(__cCodPla,1,12)
akg->akg_user     := __cUserID
akg->akg_nome     := substr(cUserName,1,25) 
akg->akg_estrut   := "3"
akg->akg_itens    := "4"
akg->akg_cntusu   := "4"
akg->akg_revisa   := "4"
akg->akg_itmctb   := "2"
akg->akg_ccusto   := "2"
akg->akg_clavlr   := "2"
akg->akg_entida   := "2"
akg->(MsUnlock())

                 
akg->(RecLock("AKG",.t.))
akg->akg_filial   := xfilial("AKG")
akg->akg_orcame   := __cCodPla 
akg->akg_co       := substr(__cCodPla,1,12)
akg->akg_user     := ::cGestor
akg->akg_nome     := UsrRetName(::cGestor)  
akg->akg_estrut   := "3"
akg->akg_itens    := "4"
akg->akg_cntusu   := "4"
akg->akg_revisa   := "4"
akg->akg_itmctb   := "2"
akg->akg_ccusto   := "2"
akg->akg_clavlr   := "2"
akg->akg_entida   := "2"
akg->(MsUnlock())                


ake->(RecLock("AKE",.t.))
ake->ake_filial   := xfilial("AKE")
ake->ake_orcame   := __cCodPla
ake->ake_revisa   := "0001"
ake->ake_datai    := dDataBase
ake->ake_horai    := time()
ake->ake_dataf    := dDataBase
ake->ake_horaf    := time()
ake->ake_useri    := __cUserID
ake->ake_userf    := __cUserID
ake->(MsUnlock())

while !ak5->(eof()) .and. ak5->ak5_filial == xfilial("AK5")
	if substr(ak5->ak5_codigo,1,1) $ "34"
		&& Esta é uma solucao local para colocar o nivel da conta
		__nLevel := iif(len(alltrim(ak5->ak5_codigo))==1,2,iif(len(alltrim(ak5->ak5_codigo))==2,3,iif(len(alltrim(ak5->ak5_codigo))==4,4,iif(len(alltrim(ak5->ak5_codigo))==6,5,6))))
		ak3->(RecLock("AK3",.t.))
		ak3->ak3_filial   := xfilial("AK3")
		ak3->ak3_orcame   := __cCodPla 
		ak3->ak3_versao   := "0001"
		ak3->ak3_co       := ak5->ak5_codigo  
		ak3->ak3_pai      := iif(__nLevel==2,substr(__cCodPla,1,12),ak5->ak5_cosup)
		ak3->ak3_nivel    := strzero(__nLevel,3)
		ak3->ak3_descri   := ak5->ak5_descri  
		ak3->ak3_tipo     := ak5->ak5_tipo
		ak3->(MsUnlock())
	endif
	ak5->(dbskip())
end-while

(cTab)->(dbgotop())
while !(cTab)->(eof())
    if substr((cTab)->z__conta,1,1) $ "34"
	    ak2->(RecLock("AK2",.t.))
	    ak2->ak2_filial    := xfilial("AK2")
	    ak2->ak2_id        := (cTab)->z__ord 
	    ak2->ak2_orcame    := __cCodPla
	    ak2->ak2_versao    := "0001"
	    ak2->ak2_co        := (cTab)->z__conta
	    ak2->ak2_period    := stod( substr((cTab)->z__data,1,6)+"01" )
	    ak2->ak2_cc        := (cTab)->z__cc
	    ak2->ak2_itctb     := (cTab)->z__item    
		ak2->ak2_descri    := (cTab)->z__hist 
	    ak2->ak2_clvlr     := (cTab)->z__clvl
		ak2->ak2_classe    := substr((cTab)->z__conta,1,2)
		ak2->ak2_valor     := (cTab)->z__valor
		ak2->ak2_oper      := substr((cTab)->z__conta,1,4)
		ak2->ak2_moeda     := 1
		ak2->ak2_dataf     := LastDay( stod( substr((cTab)->z__data,1,6)+"01" ) )
		ak2->ak2_datai     := stod( substr((cTab)->z__data,1,6)+"01" )
		ak2->ak2_ent06     := (cTab)->z__e06 
		       
	    ak2->(MsUnlock())          
	    __cID := soma1(__cID)
	endif
    (cTab)->(dbskip())
end-while
end Transaction  

dbselectarea(cTab)
dbclosearea()
dbselectarea("AK1")
Return()


*************************************************************************************************************
&&  Investimentos
&&  Input.: TipoMov         -> S=Saldo na Data | M=Movimento Mes | L=Lancamentos 
&&          ContasWhere   -> Clausula Where
&&          ContasIN      -> Clausila IN
&&          Tipo Saldo      -> 1=Real / 0=Orcado
&&  Output:
&& Exemplo: BuildQuery(cMov, cExpBtw, cExpIn, cTpSld, cTotalEndidades? )
&& BuildQuery("S"," CT1_CONTA BETWEEN '1' AND '19999999999' AND "," SUBSTR(CT1_CONTA,1,4) IN ('1302','1303','1304') AND ", "1") 
*************************************************************************************************************
Method BuildQuery(cMov, cExpBtw, cExpIn, cTpSld,cTotEnt) 		Class PcoCertisign
local aArea 	:= GetArea()
local cQuery	:= " "
local cCmpDeb   := " "
local cCmpCre   := " "
local cVlrDeb   := " " 
local cVlrCre   := " "
local cFromDeb  := " " 
local cFromCre  := " " 
local cWhrDeb   := " " 
local cWhrCre   := " " 
local cGrpDeb   := " " 
local cGrpCre   := " " 

local cAliasQry	:= GetNextAlias()

if select(cAliasQry) > 0
	dbselectArea(cAliasQry)
	dbcloseArea()
	dbselectarea("AKD")
endif

if ::cModel == "1" && Real
	do case
	   case cMov == "S" 
			cCmpDeb += " SELECT  '"+::cDtFin+"'     AS Z__DATA,  "
			cCmpDeb += " 'D'                        AS Z__DC,    "
			cCmpDeb += " '1'                        AS Z__TS,    "			 
			cCmpDeb += " CT1_CONTA                  AS Z__CONTA, "   
			cCmpDeb += " ' '     AS       Z__CC,       "
			cCmpDeb += " ' '     AS       Z__ITEM,     "
			cCmpDeb += " ' '     AS       Z__CLVL,     "       
			cCmpDeb += " ' '     AS       Z__FILIAL,   "       
			cCmpDeb += " ' '     AS       Z__SEQ,      "
			cCmpDeb += " 0       AS       Z__REC,      "
			cCmpDeb += " ' '     AS       Z__E05,      " 
			cCmpDeb += " ' '     AS       Z__E06,      "
			cCmpDeb += " ' '     AS       Z__E07,      "
			cCmpDeb += " ' '     AS       Z__E08,      "
			cCmpDeb += " ' '     AS       Z__E09,      "
			cCmpDeb += " 'SALDO'    AS       Z__HIST,  "


			cCmpCre += " SELECT  '"+::cDtFin+"'     AS Z__DATA,  "
			cCmpCre += " 'C'                        AS Z__DC,    " 
			cCmpCre += " '1'                        AS Z__TS,    "
			cCmpCre += " CT1_CONTA                  AS Z__CONTA, "   
			cCmpCre += " ' '     AS       Z__CC,       "
			cCmpCre += " ' '     AS       Z__ITEM,     "
			cCmpCre += " ' '     AS       Z__CLVL,     "       
			cCmpCre += " ' '     AS       Z__FILIAL,   "       
			cCmpCre += " ' '     AS       Z__SEQ,      " 
			cCmpCre += " 0       AS       Z__REC,      "
			cCmpCre += " ' '     AS       Z__E05,      " 
			cCmpCre += " ' '     AS       Z__E06,      "
			cCmpCre += " ' '     AS       Z__E07,      "
			cCmpCre += " ' '     AS       Z__E08,      "
			cCmpCre += " ' '     AS       Z__E09,      "	   
			cCmpCre += " 'SALDO'    AS       Z__HIST,     "
					

     	 	cVlrDeb += " ( CT7_ATUDEB -  CT7_ATUCRD ) AS Z__VALOR "
      		cVlrCre += " ( CT7_ATUCRD -  CT7_ATUDEB ) AS Z__VALOR "

			cFromDeb += " FROM "+RetSqlName("CT7")+" CT7 " 
			cFromDeb += " INNER JOIN  "+RetSqlName("CT1")+" CT1 ON CT1_CONTA = CT7_CONTA AND " 
			cFromDeb += "       CT1_FILIAL = CT7_FILIAL AND CT1.D_E_L_E_T_ = ' '          "

			cFromCre += " FROM "+RetSqlName("CT7")+" CT7 " 
			cFromCre += " INNER JOIN  "+RetSqlName("CT1")+" CT1 ON CT1_CONTA = CT7_CONTA AND " 
			cFromCre += "       CT1_FILIAL = CT7_FILIAL AND CT1.D_E_L_E_T_ = ' '          "


			cWhrDeb += " WHERE "
			cWhrDeb += " CT7.CT7_FILIAL ='"+xFilial("CT7")+"' AND "
			cWhrDeb += iif(empty(cExpBtw)," ",cExpBtw)
			cWhrDeb += iif(empty(cExpIn)," ",cExpIn)
			cWhrDeb += " CT7.CT7_CONTA = CT1_CONTA            AND "
			cWhrDeb += " CT7.CT7_MOEDA ='01'                  AND "  
			cWhrDeb += " CT7_ATUDEB >  CT7_ATUCRD             AND "	 
			cWhrDeb += " CT7.CT7_TPSALD ='"+cTpSld+"'  AND "
			cWhrDeb += " CT7.D_E_L_E_T_ = ' ' AND "
			cWhrDeb += " CT7.CT7_DATA = (SELECT MAX(CT7_DATA) "
			cWhrDeb += " FROM "+RetSqlName("CT7")+" CT72 "
			cWhrDeb += " WHERE CT72.CT7_FILIAL ='"+xFilial("CT7")+"' AND "
			cWhrDeb += " CT72.CT7_MOEDA = '01' AND "
			cWhrDeb += " CT72.CT7_TPSALD = '"+cTpSld+"' AND "
			cWhrDeb += " CT72.CT7_CONTA = CT1_CONTA AND "
			cWhrDeb += " CT72.CT7_DATA <= '"+::cDtFin+"' AND "
			cWhrDeb += " CT72.D_E_L_E_T_ = ' ')  "
			
			cWhrCre += " WHERE "
			cWhrCre += " CT7.CT7_FILIAL ='"+xFilial("CT7")+"' AND "
			cWhrCre += iif(empty(cExpBtw)," ",cExpBtw)
			cWhrCre += iif(empty(cExpIn)," ",cExpIn)
			cWhrCre += " CT7.CT7_CONTA = CT1_CONTA            AND "
			cWhrCre += " CT7.CT7_MOEDA ='01'                  AND "  
			cWhrCre += " CT7_ATUCRD >  CT7_ATUDEB             AND "	 
			cWhrCre += " CT7.CT7_TPSALD ='"+cTpSld+"'  AND "
			cWhrCre += " CT7.D_E_L_E_T_ = ' ' AND "
			cWhrCre += " CT7.CT7_DATA = (SELECT MAX(CT7_DATA) "
			cWhrCre += " FROM "+RetSqlName("CT7")+" CT72 "
			cWhrCre += " WHERE CT72.CT7_FILIAL ='"+xFilial("CT7")+"' AND "
			cWhrCre += " CT72.CT7_MOEDA = '01' AND "
			cWhrCre += " CT72.CT7_TPSALD = '"+cTpSld+"' AND "
			cWhrCre += " CT72.CT7_CONTA = CT1_CONTA AND "
			cWhrCre += " CT72.CT7_DATA <= '"+::cDtFin+"' AND "
			cWhrCre += " CT72.D_E_L_E_T_ = ' ')  "					                 
			

	   case cMov == "M"
			cCmpDeb += " SELECT  CT2_DATA AS  Z__DATA,     "
			cCmpDeb += " CT2_DEBITO  AS       Z__CONTA,    " 
			cCmpDeb += " 'D'         AS       Z__DC,       "
			cCmpDeb += " '1'         AS       Z__TS,    "
			cCmpDeb += " CT2_CCD     AS       Z__CC,       "
			cCmpDeb += " '  '        AS       Z__ITEM,     "
			cCmpDeb += " '  '        AS       Z__CLVL,     "       	
			cCmpDeb += " '  '        AS       Z__FILIAL,   "       
			cCmpDeb += " ' '         AS       Z__SEQ,      "
			cCmpDeb += " 0           AS       Z__REC,      "
			cCmpDeb += " '  '        AS       Z__E05,      " 
			cCmpDeb += " '  '        AS       Z__E06,      "
			cCmpDeb += " '  '        AS       Z__E07,      "
			cCmpDeb += " '  '        AS       Z__E08,      "
			cCmpDeb += " '  '        AS       Z__E09,      "     
			cCmpDeb += " 'MOVIMENTO DIARIO - DEBITO'    AS       Z__HIST,     "
                                                    
			cCmpCre += " SELECT  CT2_DATA AS  Z__DATA,     "
			cCmpCre += " CT2_CREDIT  AS       Z__CONTA,    " 
			cCmpCre += " 'C'         AS       Z__DC,       "
			cCmpCre += " '1'         AS       Z__TS,    "
			cCmpCre += " CT2_CCC     AS       Z__CC,       "
			cCmpCre += " '  '        AS       Z__ITEM,     "
			cCmpCre += " '  '        AS       Z__CLVL,     "       
			cCmpCre += " '  '        AS       Z__FILIAL,   "       
			cCmpCre += " ' '         AS       Z__SEQ,      "
			cCmpCre += " 0           AS       Z__REC,      "
			cCmpCre += " '  '        AS       Z__E05,      " 
			cCmpCre += " '  '        AS       Z__E06,      "
			cCmpCre += " '  '        AS       Z__E07,      "
			cCmpCre += " '  '        AS       Z__E08,      "
			cCmpCre += " '  '        AS       Z__E09,      "     
			cCmpCre += " 'MOVIMENTO DIARIO - CREDITO'    AS       Z__HIST,     "
	
     	 	cVlrDeb += " SUM(CT2_VALOR)   AS       Z__VALOR    "
      		cVlrCre += " SUM(CT2_VALOR)   AS       Z__VALOR    "

			cFromDeb += " FROM "+RetSqlName("CT2")+" C      "
			cFromDeb += " INNER JOIN  "+RetSqlName("CT1")+" CT1 ON CT1_CONTA = CT2_DEBITO AND " 
			cFromDeb += "       CT1_FILIAL = '"+xfilial("CT1")+"' AND CT1.D_E_L_E_T_ = ' '          "

			cFromCre += " FROM "+RetSqlName("CT2")+" C      "
			cFromCre += " INNER JOIN  "+RetSqlName("CT1")+" CT1 ON CT1_CONTA = CT2_CREDIT AND " 
			cFromCre += "       CT1_FILIAL = '"+xfilial("CT1")+"' AND CT1.D_E_L_E_T_ = ' '          "

			cWhrDeb += " WHERE CT2_FILIAL = '"+xfilial("CT2")+"' AND "                                       
			cWhrDeb += " C.D_E_L_E_T_ = ' '                      AND "
			cWhrDeb += " CT2_DATA BETWEEN '"+::cDtIni+"' AND '"+::cDtFin+"'      AND "
			cWhrDeb += " CT2_DC IN ('1','3')             AND  "
			cWhrDeb += iif(empty(cExpBtw)," ",cExpBtw)
			cWhrDeb += iif(empty(cExpIn)," ",cExpIn)
			cWhrDeb += " CT2_TPSALD  = '"+alltrim(cTpSld)+"' "

			cWhrCre += " WHERE CT2_FILIAL = '"+xfilial("CT2")+"' AND "                                       
			cWhrCre += " C.D_E_L_E_T_ = ' '                      AND "
			cWhrCre += " CT2_DATA BETWEEN '"+::cDtIni+"' AND '"+::cDtFin+"'      AND "
			cWhrCre += " CT2_DC IN ('2','3')             AND  "
			cWhrCre += iif(empty(cExpBtw)," ",cExpBtw)
			cWhrCre += iif(empty(cExpIn)," ",cExpIn)
			cWhrCre += " CT2_TPSALD  = '"+alltrim(cTpSld)+"' "			
            
            if cTotEnt == "S" // Considera se totaliza com o cliente ou nao = criado por causa do tamanho do cadastro de cliente +- 3 milhoes
				// 5=Agente | 6 - Tipo Atv | 7 = Produtos | 8 = Canais | 9 - Classe Desp
				cGrpDeb += " GROUP BY CT2_DATA, CT2_DEBITO, CT2_CCD , CT2_ITEMD, CT2_CLVLDB, CT2_FILORI, CT2_EC05DB, CT2_EC06DB, CT2_EC07DB, CT2_EC08DB, CT2_EC09DB " 
				cGrpCre += " GROUP BY CT2_DATA, CT2_CREDIT, CT2_CCC , CT2_ITEMC, CT2_CLVLCR, CT2_FILORI, CT2_EC05CR, CT2_EC06CR, CT2_EC07CR, CT2_EC08CR, CT2_EC09CR " 		
			else
				// 5=Agente | 6 - Tipo Atv | 7 = Produtos | 8 = Canais | 9 - Classe Desp
				cGrpDeb += " GROUP BY CT2_DATA, CT2_DEBITO, CT2_CCD , CT2_ITEMD, CT2_CLVLDB, CT2_EC06DB, CT2_EC07DB, CT2_EC08DB, CT2_EC09DB " 
				cGrpCre += " GROUP BY CT2_DATA, CT2_CREDIT, CT2_CCC , CT2_ITEMC, CT2_CLVLCR, CT2_EC06CR, CT2_EC07CR, CT2_EC08CR, CT2_EC09CR " 		
			endif

  	   case cMov == "L" 

			cCmpDeb += " SELECT  CT2_DATA AS  Z__DATA,     "
			cCmpDeb += " CT2_DEBITO  AS       Z__CONTA,    " 
			cCmpDeb += " 'D'         AS       Z__DC,       "
			cCmpDeb += " '1'         AS       Z__TS,    "
			cCmpDeb += " CT2_CCD     AS       Z__CC,       "
			cCmpDeb += " CT2_ITEMD   AS       Z__ITEM,     "
			cCmpDeb += " CT2_CLVLDB  AS       Z__CLVL,     "       
			cCmpDeb += " CT2_FILORI  AS       Z__FILIAL,   "       
			cCmpDeb += " CT2_SEQUEN  AS       Z__SEQ,      " 
			cCmpDeb += " C.R_E_C_N_O_  AS     Z__REC,      " 
			cCmpDeb += " CT2_EC05DB  AS       Z__E05,      " 
			cCmpDeb += " CT2_EC06DB  AS       Z__E06,      "
			cCmpDeb += " CT2_EC07DB  AS       Z__E07,      "
			cCmpDeb += " CT2_EC08DB  AS       Z__E08,      "
			cCmpDeb += " CT2_EC09DB  AS       Z__E09,      "     
			cCmpDeb += " CT2_HIST    AS       Z__HIST,     "

		    cCmpCre += " SELECT  CT2_DATA AS  Z__DATA,     "
			cCmpCre += " CT2_CREDIT  AS       Z__CONTA,    " 
			cCmpCre += " 'C'         AS       Z__DC,       "
			cCmpCre += " '1'         AS       Z__TS,    "
			cCmpCre += " CT2_CCC     AS       Z__CC,       "
			cCmpCre += " CT2_ITEMC   AS       Z__ITEM,     "
			cCmpCre += " CT2_CLVLCR  AS       Z__CLVL,     "       
			cCmpCre += " CT2_FILORI  AS       Z__FILIAL,   "       
			cCmpCre += " CT2_SEQUEN  AS       Z__SEQ,      " 
			cCmpCre += " C.R_E_C_N_O_  AS     Z__REC,      "
			cCmpCre += " CT2_EC05CR  AS       Z__E05,      " 
			cCmpCre += " CT2_EC06CR  AS       Z__E06,      "
			cCmpCre += " CT2_EC07CR  AS       Z__E07,      "
			cCmpCre += " CT2_EC08CR  AS       Z__E08,      "
			cCmpCre += " CT2_EC09CR  AS       Z__E09,      "     
			cCmpCre += " CT2_HIST    AS       Z__HIST,     "

      		cVlrDeb += " CT2_VALOR   AS       Z__VALOR     "
      		cVlrCre += " CT2_VALOR   AS       Z__VALOR     "

			cFromDeb += " FROM "+RetSqlName("CT2")+" C      "
			cFromDeb += " INNER JOIN  "+RetSqlName("CT1")+" CT1 ON CT1_CONTA = CT2_DEBITO AND " 
			cFromDeb += "       CT1_FILIAL = '"+xfilial("CT1")+"' AND CT1.D_E_L_E_T_ = ' '          "

			cFromCre += " FROM "+RetSqlName("CT2")+" C      "
			cFromCre += " INNER JOIN  "+RetSqlName("CT1")+" CT1 ON CT1_CONTA = CT2_CREDIT AND " 
			cFromCre += "       CT1_FILIAL = '"+xfilial("CT1")+"' AND CT1.D_E_L_E_T_ = ' '          "

			cWhrDeb += " WHERE CT2_FILIAL = '"+xfilial("CT2")+"' AND "                                       
			cWhrDeb += " C.D_E_L_E_T_ = ' '                      AND "
			cWhrDeb += " CT2_DATA BETWEEN '"+::cDtIni+"' AND '"+::cDtFin+"'      AND "
			cWhrDeb += " CT2_DC IN ('1','3')             AND  "
			cWhrDeb += iif(empty(cExpBtw)," ",cExpBtw)
			cWhrDeb += iif(empty(cExpIn)," ",cExpIn)
			cWhrDeb += " CT2_TPSALD  = '"+alltrim(cTpSld)+"' "

			cWhrCre += " WHERE CT2_FILIAL = '"+xfilial("CT2")+"' AND "                                       
			cWhrCre += " C.D_E_L_E_T_ = ' '                      AND "
			cWhrCre += " CT2_DATA BETWEEN '"+::cDtIni+"' AND '"+::cDtFin+"'      AND "
			cWhrCre += " CT2_DC IN ('2','3')             AND  "
			cWhrCre += iif(empty(cExpBtw)," ",cExpBtw)
			cWhrCre += iif(empty(cExpIn)," ",cExpIn)
			cWhrCre += " CT2_TPSALD  = '"+alltrim(cTpSld)+"' "

	endcase
else && Orcado

		cCmpDeb := ""        
		cCmpDeb += " SELECT  CV1_DTFIM   AS       Z__DATA,     "
		cCmpDeb += " CV1_PERIOD          AS       Z__PER,      "   
		cCmpDeb += " CV1_SEQUEN             AS       Z__ORD,      "		
		cCmpDeb += " CV1_CT1FIM          AS       Z__CONTA,    " 
		cCmpDeb += " 'D'                 AS       Z__DC,       " 
		cCmpDeb += " '2'                 AS       Z__TS,       "		
		cCmpDeb += " CV1_CTTFIM          AS       Z__CC,       "
		cCmpDeb += " CV1_CTDFIM          AS       Z__ITEM,     "
		cCmpDeb += " CV1_CTHFIM          AS       Z__CLVL,     "       
		cCmpDeb += " '"+space(02)+"'     AS       Z__FILIAL,   "       
		cCmpDeb += " '"+space(02)+"'     AS       Z__SEQ,      "
		cCmpDeb += " 0                   AS       Z__REC,      "
		cCmpDeb += " '"+space(15)+"'     AS       Z__E05,      " 
		cCmpDeb += " CT1_ENT06           AS       Z__E06,      "
		cCmpDeb += " CV1_E07FIM          AS       Z__E07,      "
		cCmpDeb += " CV1_E08FIM          AS       Z__E08,      "
		cCmpDeb += " CV1_E09FIM          AS       Z__E09,      "
		cCmpDeb += " CASE WHEN CV1_DESCIT = ' ' THEN CT1_DESC01 ELSE CV1_DESCIT END    AS       Z__HIST,     "

		cVlrDeb := " CV1_VALOR           AS       Z__VALOR     "           

		cFromDeb := " FROM "+RetSqlName("CV1")+" CV      "
		cFromDeb += " INNER JOIN  "+RetSqlName("CT1")+" C1 ON CT1_CONTA = CV1_CT1FIM        AND "
		cFromDeb += "       CT1_FILIAL = '"+xfilial("CT1")+"' AND C1.D_E_L_E_T_ = ' '           "
	
		cWhrDeb  := ""             
		cWhrDeb  += " WHERE CV.D_E_L_E_T_ = ' '"
		cWhrDeb  += " AND CV1_DTFIM BETWEEN '"+::cDtIni+"' AND '"+::cDtFin+"'  "
		cWhrDeb  += " AND SUBSTR(CV1_CT1FIM,1,1) IN ('1','4')  "
		cWhrDeb  += " AND CV1_ORCMTO = '"+::cOrcCtb+"' "
		     
		cGrpDeb := ""

		cCmpCre := ""        
		cCmpCre += " SELECT  CV1_DTFIM      AS       Z__DATA,     "
		cCmpCre += " CV1_PERIOD             AS       Z__PER,      "
		cCmpCre += " CV1_SEQUEN             AS       Z__ORD,      "
		cCmpCre += " CV1_CT1FIM             AS       Z__CONTA,    " 
		cCmpCre += " 'C'                    AS       Z__DC,       "
		cCmpCre += " '2'                    AS       Z__TS,       "
		cCmpCre += " CV1_CTTFIM             AS       Z__CC,       "
		cCmpCre += " CV1_CTDFIM             AS       Z__ITEM,     "
		cCmpCre += " CV1_CTHFIM             AS       Z__CLVL,     "       
		cCmpCre += " '"+space(02)+"'        AS       Z__FILIAL,   "   
		cCmpCre += " '"+space(02)+"'        AS       Z__SEQ,      " 
		cCmpCre += " 0                      AS       Z__REC,      "
		cCmpCre += " '"+space(15)+"'        AS       Z__E05,      " 
		cCmpCre += " CT1_ENT06              AS       Z__E06,      "
		cCmpCre += " CV1_E07FIM             AS       Z__E07,      "
		cCmpCre += " CV1_E08FIM             AS       Z__E08,      "
		cCmpCre += " CV1_E09FIM             AS       Z__E09,      "     
		cCmpCre += " CASE WHEN CV1_DESCIT = ' ' THEN CT1_DESC01 ELSE CV1_DESCIT END    AS       Z__HIST,     "

		cVlrCre := " CV1_VALOR              AS       Z__VALOR     "		

		cFromCre := " FROM "+RetSqlName("CV1")+" CV      "
		cFromCre += " INNER JOIN  "+RetSqlName("CT1")+" C1 ON CT1_CONTA = CV1_CT1FIM        AND "
		cFromCre += "       CT1_FILIAL = '"+xfilial("CT1")+"' AND C1.D_E_L_E_T_ = ' '           "

		cWhrCre  := ""             
		cWhrCre  += " WHERE CV.D_E_L_E_T_ = ' '"
		cWhrCre  += " AND CV1_DTFIM BETWEEN '"+::cDtIni+"' AND '"+::cDtFin+"'  "
		cWhrCre  += " AND SUBSTR(CV1_CT1FIM,1,1) = '3'  "
		cWhrDeb  += " AND CV1_ORCMTO = '"+::cOrcCtb+"' "		
	
		cGrpCre := ""
endif 

cQuery := cCmpDeb
cQuery += cVlrDeb
cQuery += cFromDeb
cQuery += cWhrDeb
cQuery += cGrpDeb
cQuery += " UNION "
cQuery += cCmpCre
cQuery += cVlrCre
cQuery += cFromCre
cQuery += cWhrCre
cQuery += cGrpCre //+ " ORDER BY Z__REC "
memowrite("c:\pco\Query_"+alltrim(cAliasQry)+".txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.) 

if select(cAliasQry) > 0
	(cAliasQry)->(dbgotop())
else
	cAliasQry := ""
endif
RestArea(aArea)
return(cAliasQry)

*************************************************************************************************************
&& 
*************************************************************************************************************
Method GetParam() 		Class PcoCertisign  
local cPerg   		:= "CSQRYPCO06"
LOCAL aParamBox 	:= {}
LOCAL bOk 			:= {|| .T.}
LOCAL aButtons 		:= {}
LOCAL lCentered 	:= .T.
local cTitulo 		:= "Extracao dados - Orcado x Realizado"
LOCAL nPosx
LOCAL nPosy
LOCAL cLoad 		:= "CSQRYPCO06"
LOCAL lCanSave 		:= .T.
LOCAL lUserSave 	:= .T.
Static aPergRet 	:= {}   

aadd(aParamBox,{6,"Pasta para Gravacao do CSV"      ,padr("",150),"",,"",90 ,.T.,"",alltrim("c:\"),GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})
aAdd(aParamBox,{1,"Data"              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
aAdd(aParamBox,{1,"Data"              ,Ctod(Space(8)),"","","","",50,.F.}) // Tipo data
aadd(aParamBox,{2,"Tipo de Conta"     ,1, {"   ","0-Orcados","1-Ativos","2-Passivos","3-Receitas","4-Despesas" } , 50, '.T.', .T.})
aadd(aParamBox,{2,"Movimento"         ,1, {"   ","1-Realizado","2-Orcado","3-Planilha PCO"}  , 50, '.T.', .T.})
aadd(aParamBox,{2,"Totalizacao"       ,1, {"   ","S-Saldo final","M-Movimento do periodo","L-Lancamentos detalhados"}  , 50, '.T.', .T.})  

AADD(aParamBox,{1,"Cod. Orc Contabil"  ,	Space(9)    			,	"",	   		"",	"CV1"	,	"", 50,	.F.	})
AADD(aParamBox,{1,"Gestor Orçamento"   ,	Space(9)    			,	"",	   		"",	"USR"	,	"", 50,	.F.	})


lRet := ParamBox(aParamBox, cTitulo, aPergRet, bOk, aButtons, lCentered, nPosx,nPosy,, cLoad, lCanSave, lUserSave)
::cType    := ""
::cDtIni   := ""
::cDtFin   := ""
::cModel   := ""
::cFolder  := ""
::cProc    := ""    
::cTotal   := ""
::cOrcCtb  := ""
::cGestor  := ""

if lRet         
	if empty(mv_par04) 
		alert("O tipo de conta a exportar na planilha deve ser escolhido")
	else
		if empty(mv_par05)
			alert("O tipo de movimento deve ser escolhido: Orcado ou Realizado")
		else
			::cType    := iif(substr(mv_par05,1,1)=="2","0",substr(mv_par04,1,1))    
			::cTotal   := substr(mv_par06,1,1)
			::cDtIni   := dtos(mv_par02)
			::cDtFin   := dtos(mv_par03)
			::cModel   := substr(mv_par05,1,1)
	    	::cFolder  := alltrim(mv_par01)
    		::cProc    := "9000"+::cModel+::cType     
			::cOrcCtb  := alltrim(mv_par07)
			::cGestor  := alltrim(mv_par08) 
			::nSeqId++

		endif
	endif      
endif

Return()

*************************************************************************************************************
&& Validacao do periodo
*************************************************************************************************************
Method VldPeriod() 		Class PcoCertisign
local __lOk    := .t.  
local __dRef   := stod(::cDtIni )
local __dFin   := stod(::cDtFin ) 
if TcSqlExec(" DELETE FROM SZ0010 ") == 0
	__lOk    := .t.
	//dbselectarea("AKD")
	//akd->(DbOrderNickName("LEDGER")) //Indice 12 (C) - AKD_FILIAL+AKD_PROCES+AKD_TPSALD+AKD_STATUS+DTOS(AKD_DATA) 
	//while  __dRef <= __dFin 
	//	if akd->(dbseek(xfilial("AKD") + ::cProc + ::cModel+ " " + "1" + dtos(__dRef) ))
	//		__lOk    := .f.	
	//	endif
	//	__dRef := __dRef + 1
	//end-while
else 
	__lOk    := .f.
endif	
Return(__lOk)

*************************************************************************************************************
&& Sincroniza Clientes e Fornecedores
*************************************************************************************************************
Method Sync1E05() 		Class PcoCertisign   
local aArea 	:= GetArea()
local __cMax := oPcoCS:GetMaxCv0("05")
local cQuery	:= ""
local cAliasQry	:= GetNextAlias()
sa1->(dbsetorder(1))
ct1->(dbsetorder(1))
cv0->(dbsetorder(1)) 
sa2->(dbsetorder(1))

IF Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
ENDIF
cQuery := "  SELECT '1' AS TAB, A1_COD, A1_LOJA, A1.R_E_C_N_O_ AS REC FROM "+RetSqlName("SA1")+" A1 "
cQuery += " WHERE A1_FILIAL = '"+xfilial("SA1")+"' AND A1.D_E_L_E_T_ = ' '  "
cQuery += " AND 'C'||A1_COD||A1_LOJA NOT IN (SELECT CV0_CODIGO FROM "+RetSqlName("CV0")+" CV WHERE CV0_FILIAL = '"+xfilial("CV0")+"' AND CV0_PLANO = '05'  AND CV.D_E_L_E_T_ = ' ') "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.) 
sa1->(dbsetorder(1))
(cAliasQry)->(DbGotop())
while !(cAliasQry)->(eof()) 
	 if sa1->(dbseek(xfilial("SA1") + (cAliasQry)->a1_cod + (cAliasQry)->a1_loja ))     
	     memowrite("c:\pco\cliente.txt",sa1->a1_cod + __cMax + (cAliasQry)->a1_cod + (cAliasQry)->a1_loja )
    	 if oPcoCS:putCV0("05",__cMax,"C"+sa1->a1_cod+sa1->a1_loja,sa1->a1_nreduz,"","","C00000","2")
	 		__cMax := SOMA1(__cMax)
	   	 endif
	 endif
	 (cAliasQry)->(dbskip())
end-while
if Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
endif
RestArea(aArea)
Return() 

*************************************************************************************************************
&& Sincroniza Clientes e Fornecedores
*************************************************************************************************************
Method Sync2E05() 		Class PcoCertisign   
local aArea 	:= GetArea()
local __cMax := oPcoCS:GetMaxCv0("05")
local cQuery	:= ""
local cAliasQry	:= GetNextAlias()
sa1->(dbsetorder(1))
ct1->(dbsetorder(1))
cv0->(dbsetorder(1)) 
sa2->(dbsetorder(1))

if Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
endif 

cQuery := "  SELECT '1' AS TAB, A2_COD, A2_LOJA, A2.R_E_C_N_O_ AS REC FROM SA2010 A2   "
cQuery += "  WHERE A2_FILIAL = '  ' AND A2.D_E_L_E_T_ = ' '  "
cQuery += "  AND 'F'||A2_COD||A2_LOJA NOT IN ( SELECT CV0_CODIGO FROM CV0010 CV WHERE CV0_FILIAL = '  ' AND CV0_PLANO = '05'  AND CV.D_E_L_E_T_ = ' ') "


cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.) 
(cAliasQry)->(DbGotop())
while !(cAliasQry)->(eof())
    if sa2->(dbseek(xfilial("SA2") + (cAliasQry)->a2_cod + (cAliasQry)->a2_loja ))     	    
      if oPcoCS:putCV0("05",__cMax,"F"+sa2->a2_cod+sa2->a2_loja,sa2->a2_nreduz,"","","F00000","2")
	 	__cMax := SOMA1(__cMax)
   	   endif     
	endif
	 (cAliasQry)->(dbskip())
end-while

if Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
endif
RestArea(aArea)
Return()
        
*************************************************************************************************************
&& Sincroniza Conta Contabil x Classe x Operacao com CT1
*************************************************************************************************************
Method SyncCT1() 		Class PcoCertisign   
local aArea 	:= GetArea()
local cQuery	:= ""
local cAliasQry	:= GetNextAlias()

ct1->(dbsetorder(1))
ak5->(dbsetorder(1))
akf->(dbsetorder(1))
ak6->(dbsetorder(1))

IF Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
ENDIF

cQuery := " SELECT CT.R_E_C_N_O_ AS REC, CT1_CONTA FROM "+RetSqlName("CT1")+" CT "
cQuery += " WHERE CT1_FILIAL = '"+xfilial("CT1")+"' AND "                                       
cQuery += " CT.D_E_L_E_T_ = ' '   "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.) 
(cAliasQry)->(DbGotop())
while !(cAliasQry)->(eof())
     //Conta orcamentaria - AK5  
     ct1->(dbseek(xfilial("CT1") + alltrim((cAliasQry)->ct1_conta), .t. ))
     if !ak5->(dbseek(xfilial("AK5") + alltrim((cAliasQry)->ct1_conta), .t. ))
	     dbselectarea("AK5")
   		 RecLock("AK5",.T.)
   		 ak5->ak5_filial		:= 	xfilial("AK5")
   		 ak5->ak5_codigo		:= ct1->ct1_conta    
   		 ak5->ak5_descri		:= ct1->ct1_desc01
   		 ak5->ak5_tipo			:= ct1->ct1_classe
   		 ak5->ak5_debcre		:= ct1->ct1_normal
   		 ak5->ak5_masc			:= "001"
   		 ak5->ak5_dtinc			:= ctod("01/01/2014")
   		 ak5->ak5_dtini			:= ctod("01/01/1980")
   		 ak5->ak5_cosup			:= ct1->ct1_ctasup
   		 ak5->ak5_msblql 		:= "2"
	  	 MsUnlock()     
     endif
     //Classe - AK6

	 if !ak6->(dbseek(xfilial("AK6") + substr((cAliasQry)->ct1_conta,1,2), .t. ))     
	     dbselectarea("AK6")
   		 RecLock("AK6",.T.)
		 ak6->ak6_filial		:= xfilial("AK6")
		 ak6->ak6_codigo		:= substr(ct1->ct1_conta,1,2)
		 ak6->ak6_descri		:= ct1->ct1_desc01
		 ak6->ak6_obriga		:= "2"
		 ak6->ak6_oper			:= "2"
 		 ak6->ak6_decima		:= 2
		 ak6->ak6_format		:= "1" 		 
	  	 MsUnlock()
     endif
     //Operacao - AKF
	 if !akf->(dbseek(xfilial("AKF") + substr((cAliasQry)->ct1_conta,1,4), .t. ))
	     dbselectarea("AKF")
   		 RecLock("AKF",.T.) 
		 akf->akf_filial		:= xfilial("AKF")
		 akf->akf_codigo		:= substr(ct1->ct1_conta,1,4)
		 akf->akf_descri		:= ct1->ct1_desc01
	  	 MsUnlock()
	 endif    
	 DbSelectArea(cAliasQry)
	 (cAliasQry)->(dbskip())
end-while
if Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
endif
RestArea(aArea)

Return()
*************************************************************************************************************
&& Sincroniza produtos
*************************************************************************************************************
Method SyncE07() 		Class PcoCertisign
local aArea 	:= GetArea()
local __cMax := oPcoCS:GetMaxCv0("07")
local cQuery	:= ""
local cAliasQry	:= GetNextAlias()
sb1->(dbsetorder(1))
ct1->(dbsetorder(1))
cv0->(dbsetorder(1)) 
sz1->(dbsetorder(1))
IF Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
ENDIF
cQuery := " SELECT  R_E_C_N_O_ AS REC, B1_COD, B1_XSEG FROM "+RetSqlName("SB1")+" B "
cQuery += " WHERE B1_FILIAL = '"+xfilial("SB1")+"' AND "                                       
cQuery += "  B.D_E_L_E_T_ = ' ' AND B1_XSEG <> ' '  "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.) 
(cAliasQry)->(DbGotop())
while !(cAliasQry)->(eof())
     __lRet := .f.
     //sb1->(dbgoto((cAliasQry)->rec)) 
	 sb1->(dbseek(xfilial("SB1") + alltrim((cAliasQry)->b1_cod), .t. ))     
     sz1->(dbseek(xfilial("SZ1") + alltrim(sb1->b1_xseg) ))                                                               
     ct1->(dbseek(xfilial("CT1") + sb1->b1_conta ))  
     
	 if !cv0->(dbseek(xFilial("CV0")+"07"+alltrim(sb1->b1_xseg), .t.))       
     	oPcoCS:putCV0("07",__cMax,alltrim(sb1->b1_xseg),sz1->z1_descseg,sb1->b1_conta,ct1->ct1_desc01,"000000","1")
		 __cMax := SOMA1(__cMax)     	
     endif
     
     if oPcoCS:putCV0("07",__cMax,alltrim(sb1->b1_xseg)+alltrim(sb1->b1_cod),sb1->b1_desc,sb1->b1_conta,ct1->ct1_desc01,sb1->b1_xseg,"2")
		 __cMax := SOMA1(__cMax)
     endif
	 (cAliasQry)->(dbskip())
end-while

if Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
endif
RestArea(aArea)
Return()

*************************************************************************************************************
&& Grava CV0 - Para Produtos, clientes e fornecedores
*************************************************************************************************************
Method putCV0(cCV0_PLAN,cCV0_ITEM,cCV0_COD,cCV0_DESC,cCV0_ENT01,cCV0_E01DSC,cCV0_ENTSUP,cCV0_CLASSE) 		Class PcoCertisign    
local __lOk         := .f.
local aArea 		:= GetArea()
DbSelectArea("CV0")
DbSetOrder(1)
IF !DbSeek(xFilial("CV0")+cCV0_PLAN+cCV0_COD)		
	__lOk         := .t.
	RecLock("CV0",.T.)
		CV0->CV0_PLANO 		:= cCV0_PLAN
		CV0->CV0_ITEM  		:= cCV0_ITEM
		CV0->CV0_CODIGO		:= cCV0_COD
		CV0->CV0_DESC  		:= cCV0_DESC 
		CV0->CV0_ENT01  	:= cCV0_ENT01
		CV0->CV0_E01DSC  	:= cCV0_E01DSC		
		CV0->CV0_ENTSUP		:= cCV0_ENTSU
		CV0->CV0_CLASSE		:= cCV0_CLASSE
		CV0->CV0_NORMAL		:= "2"
		CV0->CV0_BLOQUE		:= "2"
		CV0->CV0_DTIBLQ		:= CTOD("")
		CV0->CV0_DTFBLQ		:= CTOD("")
		CV0->CV0_DTIEXI		:= CTOD("01/01/"+STR(Year(dDataBase),4))
		CV0->CV0_DTFEXI		:= CTOD("")
		CV0->CV0_FILIAL		:= xFilial("CV0")
		CV0->CV0_CFGLIV		:= ""
		CV0->CV0_LUCPER		:= cCV0_COD
		CV0->CV0_PONTE		:= cCV0_COD
	MsUnlock()		
ENDIF
RestArea(aArea)
Return(__lOk)

**************************************************************************************************************************
&& Busca o movimento das contas Orcado=CV0 | Realizado = CT2 -> 1,2,3 - saldos, investimento e despesas Movimento completo
**************************************************************************************************************************

Method CallPtoLct() 	Class PcoCertisign
Return()   

*************************************************************************************************************
&& 
*************************************************************************************************************
Method endProcess()     Class PcoCertisign

Return()

*************************************************************************************************************
&& 
*************************************************************************************************************
Method ClassifyMov(cMvAlias) 	Class PcoCertisign
local aArea 	:= GetArea()
local aEntids   := {"","","","","","","","",""}
dbselectarea(cMvAlias)

(cMvAlias)->(dbgotop())

While !(cMvAlias)->(eof())
    dbselectarea("SZ0")
	sz0->(RecLock("SZ0",.T.))
	sz0->z0_filial := xfilial("SZ0")
	sz0->z0_id     := ::cSId
	sz0->z0_proc   := ::cProc 
	sz0->z0_data   := stod((cMvAlias)->z__data)
	sz0->z0_dc     := (cMvAlias)->z__dc 
	sz0->z0_ts     := (cMvAlias)->z__ts 
	sz0->z0_conta  := (cMvAlias)->z__conta 
	sz0->z0_cc     := (cMvAlias)->z__cc
	sz0->z0_item   := (cMvAlias)->z__item
	sz0->z0_clvl   := (cMvAlias)->z__clvl
	sz0->z0_seq    := (cMvAlias)->z__seq
	sz0->z0_rec    := iif( (cMvAlias)->z__rec == 0 , ::nSeqId , (cMvAlias)->z__rec)
	sz0->z0_valor  := (cMvAlias)->z__valor	   
	sz0->z0_hist   := (cMvAlias)->z__hist	   
    if !empty((cMvAlias)->z__seq)
        aEntids := u_csClsMv( (cMvAlias)->z__seq , (cMvAlias)->z__rec, .f.)
		sz0->z0_e05    := aEntids[5]
		sz0->z0_e06    := aEntids[6]
		sz0->z0_e07    := aEntids[7]
		sz0->z0_e08    := aEntids[8]
		sz0->z0_e09	   := iif(empty(aEntids[9]),"DA",aEntids[9])									
	else
		sz0->z0_e05    := (cMvAlias)->z__e05
		sz0->z0_e06    := (cMvAlias)->z__e06
		sz0->z0_e07    := (cMvAlias)->z__e07
		sz0->z0_e08    := (cMvAlias)->z__e08
		sz0->z0_e09	   := iif(empty((cMvAlias)->z__e09),"DA",(cMvAlias)->z__e09) 									
	endif  
	sz0->(MsUnlock()) 
	dbselectarea(cMvAlias)
	(cMvAlias)->(dbSkip()) 
	::nSeqId++
EndDo
dbselectarea(cMvAlias)
dbclosearea()
dbselectarea("SZ0")            
sz0->(dbgotop())
RestArea(aArea)

Return()

*************************************************************************************************************
&& 
*************************************************************************************************************
Method PutAkd() 		Class PcoCertisign

dbselectarea("SZ0")
sz0->(dbsetorder(1))
sz0->(dbgotop())
PcoIniLan(::cProc)
while !sz0->(eof()) 
	//If PcoVldLan(::cProc,"01","CSQRYPCO")
		PcoDetLan(::cProc,"01","CSNEWPCO")
	//EndIf       
	sz0->(dbSkip())
end-while
dbselectarea("SZ0")
PcoFinLan(::cProc)
Return()
*************************************************************************************************************
&& 
*************************************************************************************************************
Method GetMaxCv0(__cEnt) 		Class PcoCertisign
LOCAL aArea 	:= GetArea()
LOCAL cCV0_ITEM	:= "000000"
LOCAL cQuery	:= ""
LOCAL cAliasQry	:= GetNextAlias()

IF Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
ENDIF

cQuery := "SELECT MAX(CV0_ITEM) AS CV0MAXITEM FROM "+RetSqlName("CV0")+" CV0 "
cQuery += "WHERE "
cQuery += " 		CV0.CV0_FILIAL ='"+xFilial("CV0")+"' "
cQuery += " AND 	CV0.CV0_PLANO  ='"+__cEnt+"' "
cQuery += " AND CV0.D_E_L_E_T_  =' '"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.) 

(cAliasQry)->(DbGotop())
IF (cAliasQry)->(!EOF())
	cCV0_ITEM := (cAliasQry)->CV0MAXITEM
ENDIF

IF Select(cAliasQry) > 0
	DbSelectArea(cAliasQry)
	DbCloseArea()
ENDIF
RestArea(aArea)
Return(SOMA1(cCV0_ITEM))
**************************************************************************************************************
&& Fim metodos 
**************************************************************************************************************
