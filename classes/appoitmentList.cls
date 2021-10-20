public class appoitmentList {
    
    public List<Profile> profileName;
    public Appointment__c app {get;set;}
    public Id appId {get; set;} 
    public String currentId;
    public String currentProfile;
    
    public Integer totalRecs = 0;
    public integer index = 0;
    public integer blockSize = 5;
    public String qryResult;
    public Integer count;
    
    public static String appoitmentId = System.currentPagereference().getParameters().get('id');

   public appoitmentList(ApexPages.StandardController stdController) {
        app = new Appointment__c();
        currentProfile =  getCurrentProfile();
        currentId = UserInfo.getUserId();
        if(appoitmentId != null && String.isNotEmpty(appoitmentId)) {
            app = [SELECT Id,Name,Date__c,Patientt__c,Doctorr__c,Time__c, Status__c FROM Appointment__c WHERE Id =:appoitmentId LIMIT 1]; 
        }
    }

    public List<Appointment__c> getAppoitments() {
         if(currentProfile == 'Standar Platform User2'){
            qryResult = 'SELECT Id,Name,Date__c,Doctorr__c, Time__c,Patientt__c, Status__c  FROM Appointment__c WHERE Doctorr__r.User__c =:currentId ORDER BY Date__c ASC LIMIT:blockSize OFFSET:index';
            totalRecs= database.countQuery('select count() FROM Appointment__c WHERE Doctorr__r.User__c =:currentId ');
          }else if(currentProfile == 'Patients'){
            qryResult = 'SELECT Id,Name,Date__c,Doctorr__c, Time__c,Patientt__c, Status__c  FROM Appointment__c WHERE Patientt__r.User__c =:currentId ORDER BY Date__c ASC LIMIT:blockSize OFFSET:index';
            totalRecs= database.countQuery('select count() FROM Appointment__c WHERE Patientt__r.User__c =:currentId');
          }else if(currentProfile  == 'System Administrator'){
            qryResult = 'SELECT Id,Name,Date__c ,Doctorr__c,Patientt__c, Time__c, Status__c  FROM Appointment__c ORDER BY Date__c ASC LIMIT:blockSize OFFSET:index';
            totalRecs= database.countQuery('select count() FROM Appointment__c');
          }
          List<Appointment__c> res = Database.query(qryResult);
          return res;
        
    }
    
     public String getCurrentProfile() {
         profileName = [SELECT Name FROM Profile WHERE Id =:UserInfo.getProfileId() LIMIT 1];
         return profileName[0].Name ;
    }
    
    public void cancelAppoitment() {
        if(appId!= null && String.isNotEmpty(appId)){
           app = [SELECT Status__c FROM Appointment__c WHERE Id =:appId LIMIT 1];
            if(app.Status__c == null) {
                 app.Status__c = 'cancelled';
       			 upsert app;
            }
        }
       
    }
    
    public void confirmAppoitment() {
        if(appId!= null && String.isNotEmpty(appId)){
           app = [SELECT Status__c FROM Appointment__c WHERE Id =:appId LIMIT 1];
           if(app.Status__c == null) {
               app.Status__c = 'confirmed';
               upsert app;
               
           }
        }
    }
        
    public PageReference save() {
        try {
            if(appoitmentId != null){
               updateRecord(app);
            }
            else if(appoitmentId == null) {
                saveRecord(app);
            }
        }catch(DmlException e) {
            System.debug(e.getMessage());
        }
        PageReference redirectSuccess = new PageReference('/apex/Appoitments');
        redirectSuccess.setRedirect(true);
        return redirectSuccess;
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
    
    public String getAppoitmentId() {
        return appoitmentId;
    }
    
    private PageReference returnPageErrorDate(){
         PageReference pageRef = ApexPages.CurrentPage();
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 
        'Invalid Date,It can not be less than today');
         ApexPages.addMessage(myMsg);
         return pageRef;
    }
    
    private void updateRecord(Appointment__c app) {
        if(app.Date__c > Date.today())
		   upsert app;                    
        else
           returnPageErrorDate();
    }
    
    private void saveRecord(Appointment__c app){
        if(app.Date__c > Date.today()){
           if(currentProfile == 'Patients')
              {
                 List<Patients__c> pat = [select Id from Patients__c where User__c =: currentId LIMIT 1];
                 app.Patientt__c = pat[0].Id;
        
               }else if(currentProfile == 'Standar Platform User2') {
                 List<Doctor__c> doc = [select Id from Doctor__c where User__c =: currentId LIMIT 1];
                 app.Doctorr__c = doc[0].Id;
                        
               }
               upsert app;
               List<Appointment__c> ap = [SELECT Doctorr__r.Email__c, Patientt__r.Email__c FROM Appointment__c WHERE Id =:app.Id LIMIT 1];
               app.Doctor_Email__c = ap[0].Doctorr__r.Email__c;
               app.Patient_Email__c = ap[0].Patientt__r.Email__c;
               upsert app;
        }
        else{
            returnPageErrorDate();
        }
                
    }
    
    
}