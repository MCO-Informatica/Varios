#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSDK09   บAutor  ณOpvs(Warleson)      บ Data ณ  09/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monitora recebimento recebimento de e-mail                 บฑฑ
ฑฑบ          ณ para abertura de atendimento                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CallCenter(Certisign)                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTSDK09
//SetPrvt("oSay1","oBtn1","oBtn3","oFld1","oBtn4","oLBox1","nListBox1","aItens","oOk","oNo","OEr")
//SetPrvt("oTimer")
Local aSizeTrb	:= MsAdvSize(.F.)
Local oFWLayer
Local oWin1
Local oTPanelA
Local oLBox1

Private oDlg1
Private cMsg:='teset test tes'

oNo:= LoadBitmap(GetResources(),"QMT_COND")
oOk:= LoadBitmap(GetResources(),"QMT_OK")
OEr:= LoadBitmap(GetResources(),"QMT_NO")

aItens		:= BuscaConta()
nListBox1	:= 1

DEFINE DIALOG oDlg1 TITLE "Tํtulo" from aSizeTrb[1],0 to aSizeTrb[6],aSizeTrb[5]  PIXEL STYLE nOr(WS_VISIBLE,WS_POPUP)
	oFWLayer 		:= FWLayer():New()		
	oFWLayer:Init(oDlg1,.F.)		
	oFWLayer:AddCollumn("Col01",100,.T.)
	oFWLayer:AddWindow("Col01","Win01","Parโmetros",100,.F.,.T.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	
	oWin1 := oFWLayer:GetWinPanel('Col01','Win01')
	
	oTPanelA := TPanel():New(0,0,"",oWin1,NIL,.T.,.F.,NIL,NIL,0,13,.T.,.F.)
	oTPanelA:Align := CONTROL_ALIGN_ALLCLIENT
	
	oTPanelB := TPanel():New(0,0,"",oWin1,NIL,.T.,.F.,NIL,NIL,0,13,.T.,.F.)
	oTPanelB:Align := CONTROL_ALIGN_BOTTOM
	
	
	oTimer 		:= TTimer():New(10000,{|| aDados:=U_Logatual(@oLBox1),;
										oLBox1:SetArray(aDados),;
										oLBox1:bLine := {||{IIF(aDados[oLBox1:nat,1]==1,oNo,IIF(aDados[oLBox1:nat,1]==2,oOk,oEr)),;
															aDados[oLBox1:nat,2],;
											aDados[oLBox1:nat,3],;
											aDados[oLBox1:nat,4],;
											aDados[oLBox1:nat,5],;
											aDados[oLBox1:nat,6]}},;
										oSay1:CCAPTION:='ฺltimo Processamento: '+DtoC(Date())+' '+Time(),;
										oSay1:Refresh(),;
										oLBox1:refresh()},oDlg1)
	oBtn1 	  	:= TBtnBmp2():New(330,008,24,24,'BMPPOST',,,,{||},oTPanelB ,,,.F. );oBtn1:disable()
	oBtn1:Align := CONTROL_ALIGN_LEFT
	oSay1     	:= TSay():New( 168,018,{||""},oTPanelB,,,.F.,.F.,.F.,.T.,RGB(0,0,0),CLR_WHITE,635,010)
	oSay1:Align := CONTROL_ALIGN_LEFT
	oBtn3     	:= TButton():New( 165,183+60,"&Legenda",oTPanelB,{||legenda()},034,012,,,,.T.,,"",,,,.F. );oBtn3:SetCss("QPushButton{}")
	oBtn3:Align := CONTROL_ALIGN_RIGHT
	oBtn4     	:= TButton():New( 165,219.5+60,"&Sair",oTPanelB,{||oDlg1:end()},034,012,,,,.T.,,"",,,,.F. );oBtn4:SetCss("QPushButton{}")
	oBtn4:Align := CONTROL_ALIGN_RIGHT
	
	@ 013,003 LISTBOX oLBox1 FIELDS HEADER " ",'Caixas de Entrada'+space(30),"Msg Recebidas","Msg Processadas","Msg com Erro","Erro de Conta" SIZE 311,80 OF  oTPanelA PIXEL
	oLBox1:lUseDefaultColors:=.F.
	oLBox1:Align := CONTROL_ALIGN_ALLCLIENT
	oLBox1:SetArray(aItens)
	oLBox1:bLine := {||{IIF(aItens[oLBox1:nat,1]==1,oNo,IIF(aItens[oLBox1:nat,1]==2,oOk,oEr)),;
						aItens[oLBox1:nat,2],;
						aItens[oLBox1:nat,3],;
						aItens[oLBox1:nat,4],;
						aItens[oLBox1:nat,5],;
						aItens[oLBox1:nat,6]}}
	oTimer:Activate()
ACTIVATE DIALOG oDlg1 CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuscaConta   บAutor  ณOpvs(Warleson)   บ Data ณ  09/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtra as contas de e-mail ativa  		    			  บฑฑ
ฑฑบ          ณ 								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CallCenter(Certisign)                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function BuscaConta()

local aVetor:={}
Local cQuery

	cQuery:= " SELECT "+CRLF 
	cQuery+= " ZR_CTAMAIL,ZR_GRPSDK,ZR_ATIVO"+CRLF 
	cQuery+= " FROM "+Retsqlname('SZR')+CRLF 
	cQuery+= "  WHERE D_E_L_E_T_ = ' '"+CRLF 
	cQuery+= "  AND ZR_FILIAL = '" + xFilial("SZR")+"'"+CRLF 
//	cQuery+= "  AND ZR_ATIVO  = 'S'" 
	cQuery+= " Order by ZR_CTAMAIL" 
		
	If Select("TRBPARAM") > 0; DbSelectArea("TRBPARAM");TRBPARAM->(DbCloseArea());EndIf // Testa se a area esta em uso - fecha area.
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBPARAM",.F.,.T.)
    
    TRBPARAM->(dbgotop())
	
	While !TRBPARAM->(EoF())
		aAdd(aVetor,{iif(TRBPARAM->ZR_ATIVO =='S',2,1),ALLTRIM(TRBPARAM->ZR_CTAMAIL) ,'','','',''}) // conta de e-mail
		TRBPARAM->(dbskip())
	Enddo

	if empty(aVetor)
		aAdd(aVetor,{0,'','0','0','0','0'})
	Endif

Return aVetor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLogatual     บAutor  ณOpvs(Warleson)   บ Data ณ  09/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega o ๚ltimo Status das Caixas de entrada Ativa		  บฑฑ
ฑฑบ          ณ 								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CallCenter(Certisign)                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Logatual(oLBox1)

Local cRoot		:= GetSrvProfString("StartPath","")
Local cDir		:= SupergetMv('MV_LOGMAIL',,'CTSDK06')
Local cPath		:= ''
Local aDados	:= oLBox1:AARRAY
Local cQuery   	:= ""
Local cInQry	:= ""

aEval(aDados, {|x| cInQry += Alltrim(x[2])+","    })
cInQry := SubStr(cInQry,1,Len(cInQry)-1) 
cInQry := StrTran(cInQry,",","','")

cQuery:= "" 
cQuery+= " SELECT "
cQuery+= " 	MAIL_CTA, "
cQuery+= " 	MAX(REC_MSG) REC_MSG, "
cQuery+= "  MAX(PROC_MSG) PROC_MSG, "
cQuery+= " 	MAX(ERR_MSG) ERR_MSG, "
cQuery+= " 	MAX(ERR_CTA) ERR_CTA "
cQuery+= " FROM "
cQuery+= "   ( "
cQuery+= "   SELECT "
cQuery+= "     MAIL_CTA, "
cQuery+= "     COUNT(*) REC_MSG, "
cQuery+= "     0 PROC_MSG, "
cQuery+= "     0 ERR_MSG, "
cQuery+= "     0 ERR_CTA "
cQuery+= "   FROM "
cQuery+= "     MAILIN "
cQuery+= "   WHERE "
cQuery+= "     MAIL_TYPE = 'R' "
cQuery+= "   GROUP BY "
cQuery+= "     MAIL_CTA "
cQuery+= "   UNION "
cQuery+= "   SELECT "
cQuery+= "     MAIL_CTA, "
cQuery+= "     0 REC_MSG, "
cQuery+= "     COUNT(*) PROC_MSG, "
cQuery+= "     0 ERR_MSG, "
cQuery+= "     0 ERR_CTA "
cQuery+= "   FROM "
cQuery+= "     MAILIN "
cQuery+= "   WHERE "
cQuery+= "     MAIL_TYPE = 'P' "
cQuery+= "   GROUP BY "
cQuery+= "     MAIL_CTA "
cQuery+= "   UNION "
cQuery+= "   SELECT "
cQuery+= "     MAIL_CTA, "
cQuery+= "     0 REC_MSG, "
cQuery+= "     0 PROC_MSG, "
cQuery+= "     COUNT(*) ERR_MSG, "
cQuery+= "     0 ERR_CTA "
cQuery+= "   FROM "
cQuery+= "     MAILIN "
cQuery+= "   WHERE "
cQuery+= "     MAIL_ETYPE <> ' ' AND "
cQuery+= "     MAIL_ID <> ' ' "
cQuery+= "     GROUP BY "
cQuery+= "     MAIL_CTA "
cQuery+= "   UNION "
cQuery+= "   SELECT "
cQuery+= "     MAIL_CTA, "
cQuery+= "     0 REC_MSG, "
cQuery+= "     0 PROC_MSG, "
cQuery+= "     0 ERR_MSG, "
cQuery+= "     COUNT(*) ERR_CTA "
cQuery+= "   FROM "
cQuery+= "     MAILIN "
cQuery+= "   WHERE "
cQuery+= "     MAIL_ETYPE <> ' ' AND "
cQuery+= "     MAIL_ID = ' ' "
cQuery+= "   GROUP BY "
cQuery+= "     MAIL_CTA "
cQuery+= "   ) X "
cQuery+= " WHERE "
cQuery+= "   MAIL_CTA IN ('"+cInQry+"')
cQuery+= " GROUP BY "
cQuery+= "   MAIL_CTA "

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery),"TRBMAIL", .F., .T. )

If !TRBMAIL->(Eof())
	While	!TRBMAIL->(Eof())
		
		nPos := Ascan(aDados,{|x|  x[2] == Alltrim(TRBMAIL->MAIL_CTA) })
		
		If nPos > 0
			aDados[nPos,3] := Transform(TRBMAIL->REC_MSG,"@E 9999,999,999") 
			aDados[nPos,4] := Transform(TRBMAIL->PROC_MSG,"@E 9999,999,999") 
			aDados[nPos,5] := Transform(TRBMAIL->ERR_MSG,"@E 9999,999,999") 
			aDados[nPos,6] := Transform(TRBMAIL->ERR_CTA,"@E 9999,999,999") 
		EndIf
	
		TRBMAIL->(DbSkip()) 
	EndDo
Else
	aAdd(aDados,{0,'0','0','0','0','0'})
EndIf

TRBMAIL->(DbCloseArea())

Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณlegenda      บAutor  ณOpvs(Warleson)   บ Data ณ  09/19/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda da rotina CTSDK09                         		  บฑฑ
ฑฑบ          ณ 								                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CallCenter(Certisign)                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function legenda

Local aLegenda:={{'QMT_COND',space(5)+'Aguardando Processamento'},;
				 {'QMT_OK',space(5)+'Processamento em Andamento'},;			
				 {'QMT_NO',space(5)+'Com Inconsist๊ncia'}}

BrwLegenda('Caixas de Entrada','Legenda',aLegenda)

Return