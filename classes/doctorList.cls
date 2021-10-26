public class doctorList {
	String qryResult;
    public Integer totalRecs = 0;
    public integer index = 0;
    public integer blockSize = 5;
    public String currentId;
    public String doctorId = System.currentPagereference().getParameters().get('id');
    public Doctor__c doc {get;set;}
    
    public doctorList(ApexPages.StandardController controller) {
        doc = new Doctor__c();
        if(doctorId != null && String.isNotEmpty(doctorId)) {
            doc = [SELECT Id,Name,User__c,Title__c,License_Number__c,Phone__c,Email__c FROM Doctor__c WHERE Id =:doctorId LIMIT 1]; 
        }
    }
    public List<Doctor__c> getDoctors() {
        currentId = UserInfo.getUserId();
        qryResult = 'SELECT Id,Name,User__c,Title__c,License_Number__c,Phone__c,Email__c,CreatedById FROM Doctor__c LIMIT:blockSize OFFSET:index';
        totalRecs= database.countQuery('select count() FROM Doctor__c');
        List<Doctor__c> res = Database.query(qryResult);
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
            upsert doc;
        }catch(DmlException e) {
            System.debug(e.getMessage());
        }
        PageReference redirectSuccess = new PageReference('/apex/Doctors');
        redirectSuccess.setRedirect(true);
        return redirectSuccess;
    }
    
    public String getDoctorId() {
        return doctorId;
    }
    
    
}