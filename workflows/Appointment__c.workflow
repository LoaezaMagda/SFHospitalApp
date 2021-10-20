<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Appoitment_Remainder</fullName>
        <description>Send Appoitment Remainder</description>
        <protected>false</protected>
        <recipients>
            <field>Doctor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Patient_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Recordatorio_Cita</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Patient_Confirm_Appoitment</fullName>
        <description>Send Email to Patient Confirm Appoitment</description>
        <protected>false</protected>
        <recipients>
            <field>Doctor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Patient_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Confirm_appointment_patient</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Patient_Confirm_Appoitment2</fullName>
        <description>Send Email to Patient Confirm Appoitment2</description>
        <protected>false</protected>
        <recipients>
            <field>Patient_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Confirm_appointment_patient</template>
    </alerts>
    <alerts>
        <fullName>Send_email_when_appoitment_was_cancelled</fullName>
        <ccEmails>loaeza.magdalena@gmail.com</ccEmails>
        <description>Send email when appoitment was cancelled</description>
        <protected>false</protected>
        <recipients>
            <field>Doctor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Patient_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Appoitment_was_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Send_email_when_appoitment_was_confirmed</fullName>
        <ccEmails>loaeza.magdalena@gmail.com</ccEmails>
        <description>Send email when appoitment was confirmed</description>
        <protected>false</protected>
        <recipients>
            <field>Doctor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Patient_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Appoitment_was_Confirmed</template>
    </alerts>
    <alerts>
        <fullName>Send_emailt_appoitment_cancelled</fullName>
        <description>Send emailt appoitment cancelled</description>
        <protected>false</protected>
        <recipients>
            <field>Doctor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Patient_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Appoitment_was_Cancelled</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Status_to_Cancelled</fullName>
        <field>Status__c</field>
        <literalValue>cancelled</literalValue>
        <name>Update Status to Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Evaluate canceled status</fullName>
        <actions>
            <name>Send_email_when_appoitment_was_cancelled</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Appointment__c.Status__c</field>
            <operation>equals</operation>
            <value>cancelled</value>
        </criteriaItems>
        <description>Send email when appoitment was cancelled</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
