public with sharing class HotelRemoter {
	@RemoteAction
    public static List<Hotel__c> findAll() {
        return [select Id, Name, Location__Latitude__s, Location__Longitude__s 
                	from Hotel__c];
    }
}