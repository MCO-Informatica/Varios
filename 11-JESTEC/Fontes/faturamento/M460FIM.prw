#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460FIM   ºAutor  ³Roberto Marques    º Data ³  02/13/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ JESTEC                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function M460FIM()

//Declaração de Variáveis
    Private _cMsg 		:= ""          //Variável de Retorno da Função
    Private _aArea 		:= getArea()  //Armazena a área selecionada
//Variáveis de Valores de Impostos
    Private _nVlrIR 	:= 0
    Private _nVlrPIS	:= 0
    Private _NVLRCOF	:= 0
    Private _nVlrCSL	:= 0
    Private _nVlrLiq 	:= 0
    Private _nVlrBrt 	:= 0
    Private cProjeto	:= ""
    Private cRevisa		:= ""
    Private cTarefa		:= ""
    Private _cCodPro   := " "
    Private _cMenota   := " "
    Private _dDataVenc := " "
//Variáveis das Alíquitas de Impostos
//Passam de parâmetros
    Private _cNF  := SF2->F2_DOC    	//Numero da NF, posicionado no SF3
    Private _cSer := SF2->F2_SERIE 	 	//Série da NF
    Private _cCli := SF2->F2_CLIENTE 	//Cliente
    Private _cLoja:= SF2->F2_LOJA 		//Loja Cliente
    Private mSQL	:= ""
    Private cCodISS := ""
    Private cFatMat := ""
    Private nVlMat	:= SF2->F2_VALBRUT / 2
    Private nISS	:= SF2->F2_VALISS
    Private nINSS	:= SF2->F2_VALINSS
    Private cPed
    Private mSQL	:= ""

    _cQuery := " SELECT * FROM "+RETSQLNAME("SE1")
    _cQuery += " WHERE D_E_L_E_T_ = '' AND E1_PREFIXO = '"+_cSer+"' "
    _cQuery += " AND E1_NUM = '"+_cNF+"' AND E1_CLIENTE ='"+_cCli+"' "
    _cQuery += " AND E1_LOJA ='"+_cLoja+"'"

    dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)
    WHILE QUERY->(!EOF())
        If QUERY->E1_TIPO = 'IR-'
            _nVlrIR := QUERY->E1_VALOR
        EndIf
        If QUERY->E1_TIPO = 'PI-'
            _nVlrPIS := QUERY->E1_VALOR
        EndIf
        If QUERY->E1_TIPO = 'CF-'
            _nVlrCOF := QUERY->E1_VALOR
        EndIf
        If QUERY->E1_TIPO = 'CS-'
            _nVlrCSL := QUERY->E1_VALOR
        EndIf
        QUERY->(DBSKIP())
    ENDDO
    QUERY->(DBCLOSEAREA())
//Mensagem Incial

    If Select( "QUERY" ) > 0
        QUERY->( DbCloseArea() )
    EndIf

    If Select( "QSC5" ) > 0
        QSC5->( DbCloseArea() )
    EndIf

    _cQuery := " SELECT * FROM "+RETSQLNAME("SC5")
    _cQuery += " WHERE D_E_L_E_T_ = '' AND C5_SERIE = '"+_cSer+"' AND C5_NOTA = '"+_cNF+"'"



    dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QSC5", .F., .T.)
    _cMenota := ""

    cFATMAT	:= QSC5->C5_FATMAT

    _cQuery := " SELECT * FROM "+RETSQLNAME("SC6")
    _cQuery += " WHERE D_E_L_E_T_ = '' AND C6_SERIE = '"+_cSer+"' AND C6_NOTA = '"+_cNF+"'"

    dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)



    WHILE QUERY->(!EOF())
        //_cMenota  	:= ALLTRIM(QUERY->C5_MENNOTA)
        cProjeto 	:= QUERY->C6_PROJPMS
        cRevisa		:= QUERY->C6_REVISA
        cTarefa		:= QUERY->C6_EDTPMS
        cCODISS		:= QUERY->C6_CODISS
        cPed		:= QUERY->C6_NUM
        QUERY->(DBSKIP())
    ENDDO
    QUERY->(DBCLOSEAREA())

    If Select( "TMP1" ) > 0
        TMP1->( DbCloseArea() )
    EndIf

    mSQL := " SELECT * FROM "+ RetSQLName("AFC")
    mSQL += " WHERE AFC_FILIAL = '"+xFilial ("AFC")+"'"
    mSQL += " AND D_E_L_E_T_ <>'*' "
//	mSQL += " AND AFC_PROJET ='"+AFC->AFC_PROJET+"'"
    mSQL += " AND AFC_PROJET ='"+cProjeto+"'"
//	mSQL += " AND AFC_REVISA ='"+AFC->AFC_REVISA+"'"
    mSQL += " AND AFC_REVISA ='"+cRevisa+"'"
//	mSQL += " AND AFC_EDT ='"+AFC->AFC_PROJET+"'"
    mSQL += " AND AFC_EDT ='"+cTarefa+"'"

    DbUseArea( .T., "TOPCONN", TCGENQRY(,,mSQL),"TMP1", .F., .T.)
    TMP1->( DbGoTop() )

    DBSELECTAREA("AF8")
    DBSETORDER(1)
    DBSEEK(XFILIAL("AF8")+cProjeto,.F.)

    IF Alltrim(SC5->C5_NATUREZ) == "1010102"

        _cMenota := "Pedido de Compra.:"+TMP1->AFC_OP //+ Space(1) + CHR(13)+CHR(10) + Space(1) + Space(1) + CHR(13)+CHR(10) + Space(1)
        IF AllTrim(cCODISS) == "01023"
            _cMenota += " LC 116/03 LC 07.02 - " + TMP1->AFC_DESCRI //+ Space(1) + CHR(13)+CHR(10) + Space(1)
            _cMenota += AF8->AF8_DESCRI // +Space(1) + CHR(13)+CHR(10) + Space(1)
            _cMenota += " Site.: "+AllTrim(AF8->AF8_SITE)+" Municipio.:"+AllTrim(AF8->AF8_MUN)+" - "+AF8->AF8_EST //+ Space(1) + CHR(13)+CHR(10) + Space(1)
            _cMenota += " Local da Prestacao.: "+AllTrim(AF8->AF8_MUN)+" - "+AF8->AF8_EST //+ Space(1) + CHR(13)+CHR(10) + Space(1)
            IF cFatMat == "1"
                _cMenota += " Materiais.:50.00% R$ "+AllTrim(Transform(nVlMat,"@E 999,999.99")) +" -  Servicos.:50.00% R$ "+AllTrim(Transform(nVlMat,"@E 999,999.99")) //+ Space(1) + CHR(13)+CHR(10) + Space(1)
            Else
                _cMenota += " Servicos.:100.00% R$ "+AllTrim(Transform(SF2->F2_VALBRUT,"@E 999,999.99"))//+ Space(1) + CHR(13)+CHR(10) + Space(1)
            Endif
            If Select( "QUERY" ) > 0
                QUERY->( DbCloseArea() )
            EndIf
            _cQuery := " SELECT * FROM "+RETSQLNAME("SE1")
            _cQuery += " WHERE D_E_L_E_T_ <> '*' AND E1_TIPO = 'NF' AND E1_NUM = '"+_cNF+"'"
            dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)
            _dDataVenc := ""
            WHILE QUERY->(!EOF())
                _dDataVenc += DTOC(Stod(QUERY->E1_VENCTO)) +", "
                QUERY->(DBSKIP())
            ENDDO
            QUERY->(DBCLOSEAREA())
            IF LEN(_dDataVenc) >0
                _dDataVenc := SUBSTR(_dDataVenc,1,LEN(_dDataVenc)-2)
                _cMenota += " Vencimento em : "+ _dDataVenc
            ENDIF
            _nVlrLiq :=  (SF2->F2_VALBRUT - (_nVlrIR+_nVlrPIS+_nVlrCOF+_nVlrCSL))
            _cMenota += " Valor Liquido R$ "
            _cMenota += AllTrim(Transform(_nVlrLiq,"@E 999,999.99")) //+ Space(1) + CHR(13)+CHR(10) + Space(1) + Space(1) + CHR(13)+CHR(10) + Space(1)
            _cMenota += " Obs.: A retencao do INSS (11%) somente incidira sobre os servicos prestados, conforme Arts. 149, 150 da IN 20/2007. "
        Else
            _cMenota += "LC 116/03 LC 07.03 - " + TMP1->AFC_DESCRI //+ Space(1) + CHR(13)+CHR(10) + Space(1)
            _cMenota += AF8->AF8_DESCRI //+ Space(1) + CHR(13)+CHR(10) + Space(1)
            _cMenota += " Site.: "+AllTrim(AF8->AF8_SITE) +" Municipio.:"+AllTrim(AF8->AF8_MUN)+" - "+AF8->AF8_EST //+ Space(1) + CHR(13)+CHR(10) + Space(1)
            _cMenota += " Local da Prestacao.: Sao Paulo - SP" //+ Space(1) + CHR(13)+CHR(10) + Space(1)
            _cMenota += " Servicos.:100.00% R$ "+AllTrim(Transform(SF2->F2_VALBRUT,"@E 999,999.99")) //+ Space(1) + CHR(13)+CHR(10) + Space(1)
            If Select( "QUERY" ) > 0
                QUERY->( DbCloseArea() )
            EndIf
            _cQuery := " SELECT * FROM "+RETSQLNAME("SE1")
            _cQuery += " WHERE D_E_L_E_T_ = '' AND E1_TIPO = 'NF' AND E1_NUM = '"+_cNF+"'"
            dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery),"QUERY", .F., .T.)
            _dDataVenc := ""
            WHILE QUERY->(!EOF())
                _dDataVenc += DTOC(Stod(QUERY->E1_VENCTO)) +", "
                QUERY->(DBSKIP())
            ENDDO
            QUERY->(DBCLOSEAREA())
            IF LEN(_dDataVenc) >0
                _dDataVenc := SUBSTR(_dDataVenc,1,LEN(_dDataVenc)-2)
                _cMenota += " Vencimento em : "+ _dDataVenc
            ENDIF
            _nVlrLiq :=  (SF2->F2_VALBRUT - (_nVlrIR+_nVlrPIS+_nVlrCOF+_nVlrCSL))
            _cMenota += " Valor Liquido R$ "
            _cMenota += AllTrim(Transform(_nVlrLiq,"@E 999,999.99")) //+ Space(1) + CHR(13)+CHR(10) + Space(1) + Space(1) + CHR(13)+CHR(10) + Space(1)
        Endif


        // GRAVAR O CONTEUDO DA NF

        Dbselectarea("SC5")
        Dbsetorder(1)
        IF Dbseek(xFilial("SC5")+cPed)
            Reclock("SC5",.F.)
            //	SC5->C5_MENNOTA := _cMenota
            MsUnlock()
        Endif

    ENDIF

Return
