#include "protheus.ch"
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC10
Exemplo de setViewProperty e setViewAction

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC10()
Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Aluno x Turma')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar'       ACTION 'VIEWDEF.MVC10' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'          ACTION 'VIEWDEF.MVC10' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'          ACTION 'VIEWDEF.MVC10' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'          ACTION 'VIEWDEF.MVC10' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'         ACTION 'VIEWDEF.MVC10' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copia Padrao'     ACTION 'VIEWDEF.MVC10' OPERATION 9 ACCESS 0

Return aRotina

Static Function ViewDef()
Local oView := FWLoadView("MVC09")

    oView:EnableTitleView("FORM_ALUNOS","Aluno")

    //Executa a ação no Refresh da View
    oView:SetViewAction("REFRESH", {|oView| Refresh(oView) })

    //Executa a ação no acionamento do botão confirmar da View
    oView:SetViewAction("BUTTONOK", {|oView| ButtonOK(oView) })

    //Executa a ação no acionamento do botão cancelar da View
    oView:SetViewAction("BUTTONCANCEL", {|oView| ButtonCancel(oView) })

    //Executa a ação na deleção da linha da grid
    oView:SetViewAction("DELETELINE", {|oView,cIDForm,nNumLine| DeleteLine( oView,cIDForm,nNumLine )})

    //Executa a ação na restauração da linha da grid
    oView:SetViewAction("UNDELETELINE", {|oView,cIDForm,nNumLine| UnDeleteLine( oView,cIDForm,nNumLine ) })

    //Executa a ação antes de cancelar a Janela de edição se ação retornar .F. não apresenta o qustionamento ao usuario de formulario modificado
    oView:SetViewAction("ASKONCANCELSHOW", {|| .F.})

    //Cria um painel de detalhes da linha do grid
    oView:SetViewProperty( 'FORM_ALUNOS', "ENABLEDGRIDDETAIL", { 20 } )

    //Define um bloco para ser chamado na troca da linha
    oView:SetViewProperty( 'FORM_ALUNOS', "CHANGELINE", {{ |oView, cIDForm| ChangeLine(oView, cIDForm) }} )

    //Habilita filtro no grid
    oView:SetViewProperty("FORM_ALUNOS", "GRIDFILTER", {.T.})

    //Habilita pesquisa no grid
    oView:SetViewProperty("FORM_ALUNOS", "GRIDSEEK", {.T.})
    
    //Desabilita order no grid
    oView:SetViewProperty( "*", "GRIDNOORDER")


Return oView

Static Function Refresh(oView)
    Help( ,, 'HELP',, 'Executado Refresh da View.', 1, 0)  
Return

Static Function ButtonOK(oView)
    Help( ,, 'HELP',, 'Executado Botão OK.', 1, 0)  
Return

Static Function ButtonCancel(oView)
    Help( ,, 'HELP',, 'Executado Botão Cancelar.', 1, 0)  
Return

Static Function DeleteLine( oView,cIDForm,nNumLine )
    Help( ,, 'HELP',, i18n("Deletado a linha #1 do formulario #2",{cIDForm,nNumLine}), 1, 0)  
Return

Static Function UnDeleteLine( oView,cIDForm,nNumLine )
    Help( ,, 'HELP',, i18n("Desfeito a deleção da linha #1 do formulario #2",{cIDForm,nNumLine}), 1, 0)  
Return

Static Function ChangeLine(oView, cIDForm)
    Help( ,, 'HELP',, i18n("Troca de linhado formulario #1",{cIDForm}), 1, 0)  
Return