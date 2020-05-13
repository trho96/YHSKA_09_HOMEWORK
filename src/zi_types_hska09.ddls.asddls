@AbapCatalog.sqlViewName: 'ZVI_TYPES_HSKA09'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data model for types'
define root view ZI_TYPES_HSKA09 as select from yhska09_types as LanguageTypes{
      key language_id,
      @EndUserText.label: 'Programming Language Name'
      name,
      @EndUserText.label: 'Blacklisted'
      blacklisted,
      @EndUserText.label: 'Rating'
      rating,
      
      @EndUserText.label: 'Developer'
      developer,
      
      @EndUserText.label: 'Publishing Year'
      publishing_year
}
