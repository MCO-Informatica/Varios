#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"    
#Include "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVNDA470 บ Autor ณ                   บ Data ณ  10/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exporta Voucher ou Banco de Voucher para Excel             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function VNDA470(cNumFlu,cNumVou)   
Local cSqlRet := ""
Local aCab := {"C๓digo do Produto","N๚mero do Voucher","Tipo do Voucher","Data de Validade","Motivo de Emissใo do Voucher";
			   ,"Quantidade de vezes que pode ser utilizado","Produto Protheus","C๓digo Fluxo"}
Local aDados := {}
Default cNumvou := ""
    
cAliasSZF := "TMPSZF"
If Select((cAliasSZF)) <> 0
   dbSelectArea((cAliasSZF))
   dbCloseArea()
Endif
cSqlRet := "SELECT SZF.ZF_PDESGAR, SZF.ZF_COD, SZF.ZF_DESTIPO, SZF.ZF_DTVALID, SZF.ZF_DESMOT, SZF.ZF_QTDVOUC, SZF.ZF_PRODEST, SZF.ZF_CODFLU  FROM " + RetSqlName("SZF") + " SZF "

If Empty(cNumvou) 

	cSqlRet += "WHERE SZF.ZF_FILIAL = '" + xFilial("SZF") +"' AND SZF.ZF_CODFLU = '"+ Alltrim(cNumFlu) +"' AND SZF.D_E_L_E_T_ <> '*' "
Else                                                                                                                                  
	cSqlRet += "WHERE SZF.ZF_FILIAL = '" + xFilial("SZF") +"' AND SZF.ZF_CODFLU = '"+ Alltrim(cNumFlu);
			+"' AND SZF.ZF_COD = '"+ Alltrim(cNumvou)+"' AND SZF.D_E_L_E_T_ <> '*' "

Endif  

cSqlRet := ChangeQuery(cSqlRet)
TCQUERY cSqlRet NEW ALIAS "TMPSZF"

DbSelectArea("TMPSZF")

If TMPSZF->(!Eof())
	TMPSZF->(DbGoTop())   
	While TMPSZF->(!Eof())
	
		AADD(aDados,{TMPSZF->ZF_PDESGAR;
		     ,CHR(160)+TMPSZF->ZF_COD;
		     ,TMPSZF->ZF_DESTIPO;
		     ,SUBSTR(TMPSZF->ZF_DTVALID,1,4)+"-"+SUBSTR(TMPSZF->ZF_DTVALID,5,2)+"-"+SUBSTR(TMPSZF->ZF_DTVALID,7,2);
		     ,TMPSZF->ZF_DESMOT;
		     ,TMPSZF->ZF_QTDVOUC;
		     ,TMPSZF->ZF_PRODEST;
		     ,TMPSZF->ZF_CODFLU})
		TMPSZF->(DbSkip())
	Enddo
Endif    

DbSelectArea("TMPSZF")
TMPSZF->(DbCloseArea()) 
DlgToExcel({ {"ARRAY", "", aCab, aDados} })

Return