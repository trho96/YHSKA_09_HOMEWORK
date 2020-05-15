@AbapCatalog.sqlViewName: 'ZVI_REG_HSKA09'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data definition for regions'
define view ZI_REGION_HSKA09
  as select from yhska09_regions
{
  key region_key,
      region
}
