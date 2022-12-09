#INCLUDE "protheus.ch"

/*/{Protheus.doc} User Function PlanImp
   Planilha de Cadastro de Importaùùo
    @type  Function
    @author Anderson Martins
    @since 16/05/2022
    @version 1.0
    @example
    PlanImp
/*/

User Function PlanImp()

    Local cAlias := "SZ1"
    Local cTitulo := "Cadastro de ImportaÁ„o"
    Local cVidAlt := ".T."
    Local cVidExc := ".T."

    AxCadastro(cAlias, cTitulo, cVidAlt, cVidExc)

Return

// Gatilhos para o correto funcionamento da Rotina
//Criar Gatilhos abaixos
//u_plangat1()
User Function plangat1()
    Local aArea := GetArea()
    Local plangat1 := ""

    \=(-Z3_PTAXFE*4%)+Z3_PTAXFE



    RestArea(aArea)
Return plangat1

User Function plangat2()
    Local aArea := GetArea()
    Local plangat2 := ""
    //\=(Z3_PTAXFE*4%)+Z3_PTAXFE


    RestArea(aArea)
Return plangat2

User Function plangat3()
    Local aArea := GetArea()
    Local plangat3 := ""


    \=SUM(Z3_PPUSD : Z3_PFUSD)



    RestArea(aArea)
Return plangat3

User Function plangat4()
    Local aArea := GetArea()
    Local plangat4 := ""

    \=Z3_DFRETEF*Z3_PPUSD





    RestArea(aArea)
Return plangat4


User Function plangat5()
    Local aArea := GetArea()
    Local plangat5 := ""


    //\=Z3_PNETT*Z3_PFUSD
    Z3_PNETT * Z3



    RestArea(aArea)
Return plangat5

User Function plangat6()
    Local aArea := GetArea()
    Local plangat6 := ""



    \=Z3_DFRETEF+Z3_DFRETE



    RestArea(aArea)
Return plangat6

User Function plangat7()
    Local aArea := GetArea()
    Local plangat7 := ""


    \=Z3_RIMPIMP/Z3_DOLAREN




    RestArea(aArea)
Return plangat7

User Function plangat()
    Local aArea := GetArea()
    Local plangat := ""






    RestArea(aArea)
Return plangat

User Function plangat8()
    Local aArea := GetArea()
    Local plangat8 := ""


    \=Z3_RIPI/Z3_DOLAREN




    RestArea(aArea)
Return plangat8

User Function plangat9()
    Local aArea := GetArea()
    Local plangat9 := ""


    \=Z3_RICMS/Z3_DOLAREN




    RestArea(aArea)
Return plangat9

User Function plangat10()
    Local aArea := GetArea()
    Local plangat10 := ""


    \=Z3_RCOFINS/Z3_DOLAREN




    RestArea(aArea)
Return plangat10

User Function plangat11()
    Local aArea := GetArea()
    Local plangat11 := ""



    \=Z3_RPIS/Z3_DOLAREN



    RestArea(aArea)
Return plangat11

User Function plangat12()
    Local aArea := GetArea()
    Local plangat12 := ""


    \=Z3_ANTITO*Z3_PNETT




    RestArea(aArea)
Return plangat12

User Function plangat13()
    Local aArea := GetArea()
    Local plangat13 := ""


    \=Z3_RSISCO/Z3_DOLAREN




    RestArea(aArea)
Return plangat13

User Function plangat14()
    Local aArea := GetArea()
    Local plangat14 := ""


    \=Z3_RARMER/Z3_DOLAREN




    RestArea(aArea)
Return plangat14

User Function plangat15()
    Local aArea := GetArea()
    Local plangat15 := ""


    \=Z3_RINSMAD/Z3_DOLAREN




    RestArea(aArea)
Return plangat15

User Function plangat16()
    Local aArea := GetArea()
    Local plangat16 := ""


    \=Z3_RSDA/Z3_DOLAREN




    RestArea(aArea)
Return plangat16

User Function plangat17()
    Local aArea := GetArea()
    Local plangat17 := ""

    \=Z3_RDESCPA/Z3_DOLAREN





    RestArea(aArea)
Return plangat17

User Function plangat18()
    Local aArea := GetArea()
    Local plangat18 := ""


    \=Z3_RIMPOR/Z3_DOLAREN




    RestArea(aArea)
Return plangat18

User Function plangat19()
    Local aArea := GetArea()
    Local plangat19 := ""


    \=Z3_RRMDESM/Z3_DOLAREN




    RestArea(aArea)
Return plangat19

User Function plangat20()
    Local aArea := GetArea()
    Local plangat20 := ""


    \=Z3_RCAPAT/Z3_DOLAREN




    RestArea(aArea)
Return plangat20

User Function plangat21()
    Local aArea := GetArea()
    Local plangat21 := ""


    \=Z3_RDESLI/Z3_DOLAREN




    RestArea(aArea)
Return plangat21

User Function plangat22()
    Local aArea := GetArea()
    Local plangat22 := ""



    \=Z3_ROTDESP/Z3_DOLAREN



    RestArea(aArea)
Return plangat22

User Function plangat23()
    Local aArea := GetArea()
    Local plangat23 := ""


    \=Z3_REMCONT/Z3_DOLAREN




    RestArea(aArea)
Return plangat23

User Function plangat24()
    Local aArea := GetArea()
    Local plangat24 := ""



    \=Z3_RESFRTE/Z3_DOLAREN



    RestArea(aArea)
Return plangat24

User Function plangat25()
    Local aArea := GetArea()
    Local plangat25 := ""


    \=Z3_RICMSFT/Z3_DOLAREN




    RestArea(aArea)
Return plangat25

User Function plangat26()
    Local aArea := GetArea()
    Local plangat26 := ""


    \=Z3_RMOTOBO/Z3_DOLAREN




    RestArea(aArea)
Return plangat26

User Function plangat27()
    Local aArea := GetArea()
    Local plangat27 := ""


    \=Z3_RARTRA/Z3_DOLAREN




    RestArea(aArea)
Return plangat27

User Function plangat28()
    Local aArea := GetArea()
    Local plangat28 := ""


    \=Z3_RCARCRE/Z3_DOLAREN




    RestArea(aArea)
Return plangat28

User Function plangat29()
    Local aArea := GetArea()
    Local plangat29 := ""


    \=Z3_ROTDESP/Z3_DOLAREN




    RestArea(aArea)
Return plangat29

User Function plangat30()
    Local aArea := GetArea()
    Local plangat30 := ""


    \=SUM(Z3_DCUSFRE:Z3_DOUTRAS)




    RestArea(aArea)
Return plangat30

User Function plangat31()
    Local aArea := GetArea()
    Local plangat31 := ""



    \=+Z3_DTOTAL/Z3_PNETT



    RestArea(aArea)
Return plangat31

User Function plangat32()
    Local aArea := GetArea()
    Local plangat32 := ""


    \=(Z3_DTOTAL-Z3_DICMS-Z3_DCOFINS-Z3_DPIS-Z3_DIPI)/Z3_PNETT




    RestArea(aArea)
Return plangat32

User Function plangat33()
    Local aArea := GetArea()
    Local plangat33 := ""


    \=Z3_DCUPKGN*102%




    RestArea(aArea)
Return plangat33

User Function plangat34()
    Local aArea := GetArea()
    Local plangat34 := ""


    \=Z3_RSISCUS/Z3_DOLAREN




    RestArea(aArea)
Return plangat34

User Function plangat35()
    Local aArea := GetArea()
    Local plangat35 := ""



    \=Z3_RFRETEF*Z3_DOLAREN



    RestArea(aArea)
Return plangat35

User Function plangat36()
    Local aArea := GetArea()
    Local plangat36 := ""


    \=Z3_RFRETE*Z3_DOLAREN




    RestArea(aArea)
Return plangat36

User Function plangat37()
    Local aArea := GetArea()
    Local plangat37 := ""



    \=Z3_RCUSFRE*Z3_DOLAREN



    RestArea(aArea)
Return plangat37

User Function plangat38()
    Local aArea := GetArea()
    Local plangat38 := ""


    \=(Z3_RCUSFRE+Z3_RCAPAT+Z3_RANTID)*Z3_IMPOSIM




    RestArea(aArea)
Return plangat38

User Function plangat39()
    Local aArea := GetArea()
    Local plangat39 := ""



    \=(Z3_RCUSFRE/0,7275)*Z3_IPI



    RestArea(aArea)
Return plangat39

User Function plangat40()
    Local aArea := GetArea()
    Local plangat40 := ""



    \=((Z3_RCUSFRE+Z3_RCAPAT+Z3_RSISCO+Z3_RIMPIMP+Z3_RIPI+Z3_RCOFINS+Z3_RPIS+Z3_RANTID)/(1-Z3_ICMS))*Z3_ICMS



    RestArea(aArea)
Return plangat40

User Function plangat41()
    Local aArea := GetArea()
    Local plangat41 := ""


    \=((Z3_RCUSFRE+Z3_RCAPAT+Z3_RSISCO+Z3_RIMPIMP+Z3_RIPI+Z3_RCOFINS+Z3_RPIS+Z3_RANTID)/(1-Z3_ICMS))*Z3_ICMS




    RestArea(aArea)
Return plangat41

User Function plangat42()
    Local aArea := GetArea()
    Local plangat42 := ""


    \=((((Z3_RCUSFRE+Z3_RCAPAT+Z3_RANTID+Z3_RIMPIMP+Z3_RIPI)/(1-Z3_ICMS)*Z3_ICMS)+Z3_RCUSFRE+Z3_RCAPAT)/(1-Z3_COFINS-Z3_PIS))*Z3_COFINS




    RestArea(aArea)
Return plangat42

User Function plangat43()
    Local aArea := GetArea()
    Local plangat43 := ""


    \=((((Z3_RCUSFRE+Z3_RCAPAT+Z3_RANTID+Z3_RIMPIMP+Z3_RIPI)/(1-Z3_ICMS)*Z3_ICMS)+Z3_RCUSFRE+Z3_RCAPAT)/(1-Z3_COFINS-Z3_PIS))*Z3_PIS




    RestArea(aArea)
Return plangat43

User Function plangat44()
    Local aArea := GetArea()
    Local plangat44 := ""



    \=Z3_DANTID*Z3_DOLAREN



    RestArea(aArea)
Return plangat44

User Function plangat45()
    Local aArea := GetArea()
    Local plangat45 := ""


    \=400*5




    RestArea(aArea)
Return plangat45

User Function plangat46()
    Local aArea := GetArea()
    Local plangat46 := ""



    \=1500*5



    RestArea(aArea)
Return plangat46

User Function plangat47()
    Local aArea := GetArea()
    Local plangat47 := ""



    \=SUM(Z3_RCUSFRE:Z3_ROTDESP)-(Z3_RARMER:Z3_ROUTRAS)



    RestArea(aArea)
Return plangat47

User Function plangat48()
    Local aArea := GetArea()
    Local plangat48 := ""



    \=+Z3_RTOTAL/Z3_PNETT



    RestArea(aArea)
Return plangat48

User Function plangat49()
    Local aArea := GetArea()
    Local plangat49 := ""



    \=+(Z3_RTOTAL-Z3_RICMS-Z3_RCOFINS-Z3_RPIS-Z3_RIPI)/Z3_PNETT



    RestArea(aArea)
Return plangat49

User Function plangat50()
    Local aArea := GetArea()
    Local plangat50 := ""


    \=Z3_RCUPKGN*102%




    RestArea(aArea)
Return plangat50

User Function plangat51()
    Local aArea := GetArea()
    Local plangat51 := ""



    \=Z3_RRISCAM/0,6575



    RestArea(aArea)
Return plangat51

User Function plangat52()
    Local aArea := GetArea()
    Local plangat52 := ""



    \=Z3_RFRETEF/Z3_UTILUSD



    RestArea(aArea)
Return plangat52

User Function plangat53()
    Local aArea := GetArea()
    Local plangat53 := ""


    \=Z3_RFRETE/Z3_UTILUSD




    RestArea(aArea)
Return plangat53

User Function plangat54()
    Local aArea := GetArea()
    Local plangat54 := ""

    \=Z3_RCUSFRE/Z3_UTILUSD





    RestArea(aArea)
Return plangat54

User Function plangat55()
    Local aArea := GetArea()
    Local plangat55 := ""


    \=Z3_RIMPIMP/Z3_UTILUSD




    RestArea(aArea)
Return plangat55

User Function plangat56()
    Local aArea := GetArea()
    Local plangat56 := ""


    \=Z3_RCOFINS/Z3_UTILUSD




    RestArea(aArea)
Return plangat56

User Function plangat57()
    Local aArea := GetArea()
    Local plangat57 := ""

    \=Z3_RPIS/Z3_UTILUSD





    RestArea(aArea)
Return plangat57

User Function plangat58()
    Local aArea := GetArea()
    Local plangat58 := ""



    \=Z3_RANTID/Z3_UTILUSD



    RestArea(aArea)
Return plangat58

User Function plangat59()
    Local aArea := GetArea()
    Local plangat59 := ""


    \=Z3_RSISCO/Z3_UTILUSD




    RestArea(aArea)
Return plangat59

User Function plangat60()
    Local aArea := GetArea()
    Local plangat60 := ""


    \=Z3_RARMER/Z3_UTILUSD




    RestArea(aArea)
Return plangat60

User Function plangat61()
    Local aArea := GetArea()
    Local plangat61 := ""


    \=Z3_RINSMAD/Z3_UTILUSD




    RestArea(aArea)
Return plangat61

User Function plangat62()
    Local aArea := GetArea()
    Local plangat62 := ""



    \=Z3_RINSMAD/Z3_UTILUSD



    RestArea(aArea)
Return plangat62

User Function plangat63()
    Local aArea := GetArea()
    Local plangat63 := ""


    \=Z3_RDESCPA/Z3_UTILUSD




    RestArea(aArea)
Return plangat63

User Function plangat64()
    Local aArea := GetArea()
    Local plangat64 := ""



    \=Z3_RIMPOR/Z3_UTILUSD



    RestArea(aArea)
Return plangat64

User Function plangat65()
    Local aArea := GetArea()
    Local plangat65 := ""



    \=Z3_RRMDESM/Z3_UTILUSD



    RestArea(aArea)
Return plangat65

User Function plangat66()
    Local aArea := GetArea()
    Local plangat66 := ""


    \=Z3_RCAPAT/Z3_UTILUSD




    RestArea(aArea)
Return plangat66

User Function plangat67()
    Local aArea := GetArea()
    Local plangat67 := ""

    \=Z3_RDESLI/Z3_UTILUSD





    RestArea(aArea)
Return plangat67

User Function plangat68()
    Local aArea := GetArea()
    Local plangat68 := ""



    \=Z3_ROTDESP/Z3_UTILUSD



    RestArea(aArea)
Return plangat68

User Function plangat69()
    Local aArea := GetArea()
    Local plangat69 := ""


    \=Z3_REMCONT/Z3_UTILUSD




    RestArea(aArea)
Return plangat69

User Function plangat70()
    Local aArea := GetArea()
    Local plangat70 := ""



    \=Z3_RESFRTE/Z3_UTILUSD



    RestArea(aArea)
Return plangat70

User Function plangat71()
    Local aArea := GetArea()
    Local plangat71 := ""

    \=Z3_RICMSFT/Z3_UTILUSD





    RestArea(aArea)
Return plangat71

User Function plangat72()
    Local aArea := GetArea()
    Local plangat72 := ""


    \=Z3_RMOTOBO/Z3_UTILUSD




    RestArea(aArea)
Return plangat72

User Function plangat73()
    Local aArea := GetArea()
    Local plangat73 := ""

    \=Z3_RARTRA/Z3_UTILUSD





    RestArea(aArea)
Return plangat73

User Function plangat74()
    Local aArea := GetArea()
    Local plangat74 := ""


    \=Z3_CARCRE/Z3_UTILUSD




    RestArea(aArea)
Return plangat74

User Function plangat75()
    Local aArea := GetArea()
    Local plangat75 := ""


    \=Z3_ROUTRAS/Z3_UTILUSD




    RestArea(aArea)
Return plangat75

User Function plangat76()
    Local aArea := GetArea()
    Local plangat76 := ""


    \=SUM(Z3_DCUSFRE:Z3_DTOTAL)




    RestArea(aArea)
Return plangat76

User Function plangat77()
    Local aArea := GetArea()
    Local plangat77 := ""

    \=Z3_RCUPKG/Z3_PNETT





    RestArea(aArea)
Return plangat77

User Function plangat78()
    Local aArea := GetArea()
    Local plangat78 := ""

    \=+(Z3_DTOTAL-Z3_DICMS-Z3_DCOFINS-Z3_DPIS)/Z3_PNETT





    RestArea(aArea)
Return plangat78

User Function plangat79()
    Local aArea := GetArea()
    Local plangat79 := ""



    \=Z3_DCUPKGN/0,6575



    RestArea(aArea)
Return plangat79

User Function plangat80()
    Local aArea := GetArea()
    Local plangat80 := ""


    \=Z3_DCUSFRE*Z3_FECAFUT




    RestArea(aArea)
Return plangat80

User Function plangat81()
    Local aArea := GetArea()
    Local plangat81 := ""


    \=Z3_IPI




    RestArea(aArea)
Return plangat81

User Function plangat82()
    Local aArea := GetArea()
    Local plangat82 := ""


    \=Z3_ICMS




    RestArea(aArea)
Return plangat82

User Function plangat83()
    Local aArea := GetArea()
    Local plangat83 := ""


    \=Z3_COFINS




    RestArea(aArea)
Return plangat83

User Function plangat84()
    Local aArea := GetArea()
    Local plangat84 := ""

    \=Z3_PIS





    RestArea(aArea)
Return plangat84

User Function plangat85()
    Local aArea := GetArea()
    Local plangat85 := ""

    \=700-Z3_RIMPOR





    RestArea(aArea)
Return plangat85

User Function plangat86()
    Local aArea := GetArea()
    Local plangat86 := ""



    \=SUM(Z3_RCUSFRE:Z3_RTOTAL)-(Z3_RINSMAD+Z3_RSDA+Z3_RDESCPA+Z3_RIMPOR+Z3_RRMDESM+Z3_RCAPAT+Z3_RDESLI+Z3_ROUTRAS)



    RestArea(aArea)
Return plangat86

User Function plangat87()
    Local aArea := GetArea()
    Local plangat87 := ""


    \=Z3_RTOTAL/Z3_PNETT




    RestArea(aArea)
Return plangat87

User Function plangat88()
    Local aArea := GetArea()
    Local plangat88 := ""

    \=Z3_DCUPKGN/Z3_UTILUSD





    RestArea(aArea)
Return plangat88

User Function plangat89()
    Local aArea := GetArea()
    Local plangat89 := ""


    \=Z3_RSISCUS/0,6575




    RestArea(aArea)
Return plangat89

