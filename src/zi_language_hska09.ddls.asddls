@AbapCatalog.sqlViewName: 'ZVI_LANG_HSKA09'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data model for languages'
define root view ZI_LANGUAGE_HSKA09
  as select from yhska09_language as Language
  /* Associations */
  association [0..1] to yhska09_types as _Types on $projection.language_id = _Types.language_id

{

  key listing_id,

      @EndUserText.label: 'Language Key'
      language_id,

      @EndUserText.label: 'Programming Language Name'
      _Types.name            as name,

      popularity,

      @EndUserText.label: 'Trend'
      trend,

      @EndUserText.label: 'Region'
      region,

      @EndUserText.label: 'Blacklisted'
      _Types.blacklisted     as Blacklisted,

      @EndUserText.label: 'Rating'
      _Types.rating          as Rating,

      @EndUserText.label: 'Developer'
      _Types.developer       as Developer,

      @EndUserText.label: 'Publishing Year'
      _Types.publishing_year as Publishing_Year,

      case _Types.blacklisted
        when ' ' then 2
        when 'N' then 3
        when 'Y' then 1
        else 0
      end                    as Criticality
}
