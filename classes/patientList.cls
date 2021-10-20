public class patientList {
	String qryResult;
    public Integer totalRecs = 0;
    public integer index = 0;
    public integer blockSize = 5;
    public String currentId;
    public String patientId = System.currentPagereference().getParameters().get('id');
    public ApexPages.StandardSetController stdCntrlr {get; set;}  
    public Patients__c patient {get;set;}
    
    public patientList(ApexPages.StandardController controller) {
        patient = new Patients__c();
        if(patientId != null && String.isNotEmpty(patientId)) {
            patient = [SELECT Id,User__c,First_Name__c, Last_Name__c,Age__c,Gender__c,Name,Email__c FROM Patients__c WHERE Id =:patientId LIMIT 1]; 
        }
    }
    public List<Patients__c> getPatients() {
        qryResult = 'SELECT Id,User__c,First_Name__c,Last_Name__c,Age__c,Gender__c,Name,Email__c FROM Patients__c LIMIT:blockSize OFFSET:index';
        totalRecs= database.countQuery('select count() FROM Patients__c');
        List<Patients__c> res = Database.query(qryResult);
        return res;
    }
    
    public void beginning() {
        index = 1;
        
    } 
    
    public void previous() {
        index = index - blockSize;
        
    }
    
    public void next() {
        index = index + blockSize;
    }
    
    public void end() {
        index = totalRecs - Math.mod(totalRecs, blockSize);
    }
    
    public boolean getprev() {
        if(index == 0) {
            return true;
        }else{
            return false;
        }
    }
    
    public boolean getnxt() {
        if((index + blockSize) > totalRecs)
            return true;
        else
            return false;
    }
    
    public PageReference save() {
        try {
            upsert patient;
        }catch(DmlException e) {
            System.debug('ALGO SALIO MAL');
        }
        PageReference redirectSuccess = new PageReference('/apex/Patients');
        redirectSuccess.setRedirect(true);
        return redirectSuccess;
    }
    
}