#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function CMVC_07()
Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CMVC_07' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CMVC_07' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CMVC_07' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CMVC_07' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CMVC_07' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CMVC_07' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef() 
Local oModel 
Local oStruZB5 := FWFormStruct(1,"ZB5") 
Local oStruZB6 := FWFormStruct(1,"ZB6") 
	 
	oModel := MPFormModel():New("MD_TURMA_ALUNO")  
	oModel:SetDescription("Cadastro de Turma x Aluno x Nota")    
	oModel:addFields('ZB5MASTER',,oStruZB5)  
	oModel:addGrid('ZB6DETAIL','ZB5MASTER',oStruZB6)  
	
	oModel:SetRelation("ZB6DETAIL", ;       
	 					{{"ZB6_FILIAL",'xFilial("ZB6")'},;        
						{"ZB6_CODTUR","ZB5_CODTUR"  }}, ;       
						ZB6->(IndexKey(1)))         
 						
Return oModel 

Static Function ViewDef() 
Local oModel := ModelDef() 
Local oView 
Local oStrZB5:= FWFormStruct(2, 'ZB5')   
Local oStrZB6:= FWFormStruct(2, 'ZB6', {|cField| !(AllTrim(Upper(cField)) $ "ZB6_CODTUR")})   
    
	oView := FWFormView():New()  
	oView:SetModel(oModel)    
	oView:AddField('FORM_TURMA' , oStrZB5,'ZB5MASTER' )  
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'ZB6DETAIL')  
	
	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 30)  
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 70)  
 	
 	oView:SetOwnerView('FORM_ALUNOS','BOX_FORM_ALUNOS')  
 	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA')   
 	 	
Return oView