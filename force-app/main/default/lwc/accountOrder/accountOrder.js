import { LightningElement, track, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import readCSV from '@salesforce/apex/AccountHandle.readCSVFile';
import insertCSVFile from '@salesforce/apex/AccountHandle.insertCSVFile';
import documentIdapx from '@salesforce/apex/AccountHandle.documentIdapx';
import { CloseActionScreenEvent } from 'lightning/actions';
 
const columns = [
    { label: 'Company Name', fieldName: 'Company_Name__c' },
    { label: 'Party Name', fieldName: 'PartyName__c' },
    { label: 'Amount', fieldName: 'Amount__c' },
    { label: 'VoucherType', fieldName: 'VoucherType__c' },
    { label: 'VoucherNumber', fieldName: 'VoucherNumber__c' },
    { label: 'Quantity', fieldName: 'Quantity__c' },
    { label: 'Guid', fieldName: 'Gu_Id__c' }
 
];
 
export default class ReadCSVFileInLWC extends LightningElement {
    @api recordId;
    @track error;
    @track columns = columns;
    @track data;
    @track showFile=true;
    @track showbutton=false;
    @track showbutton2=true;
    @track documentIdx;

    // accepted parameters
    get acceptedFormats() {
        return ['.csv'];
    }
   
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        this.documentIdx = uploadedFiles[0].documentId;
        console.log('documentIdx',JSON.stringify(this.documentIdx));
        console.log('uploadedFiles[0].documentId',uploadedFiles[0].documentId);
 
 
        console.log('uploadedFiles',uploadedFiles);
 
        // calling apex class
        readCSV({idContentDocument : uploadedFiles[0].documentId})
        .then(result => {
            console.log('result ===> '+JSON.stringify(result));
            
            this.data = result;
            console.log('result this.data ===> '+JSON.stringify(this.data));


            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'CSV Uploaded Successfully!!!',
                    variant: 'success',
                }),
            );
            this.showbutton=true;
            this.showFile=false;
            this.showbutton2=false;
 
        })
        .catch(error => {
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error!!',
                    message: JSON.stringify(error),
                    variant: 'error',
                }),
            );    
        })
 
    }
 
    handleProceed(event){
        console.log('Clicked process');
        insertCSVFile({accList : this.data})
         .then( result => {
 
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!',
                    message: 'CSV Inserted Successfully!!!',
                    variant: 'success',
                }),
            );
 
        const closeAction= new CloseActionScreenEvent();
        this.dispatchEvent(closeAction);
 
            console.log(' success : ',result);
         })
         .catch( error => {
             console.log(' Error : ',error);
         })
    }
 
    handleCancel(event) {
                console.log('Clicked handleCancel');
                this.showbutton=false;
                this.showbutton2 =true;
                this.data = null;
                this.showFile=true;      
 
               documentIdapx({idContentDocument : this.documentIdx})
                .then(result => {
                   console.log('Success==>',result);
                })
                .catch(error => {
                    console.log(error);
 
                       
                })
     
                console.log('fileUploadComponent handleCancel',fileUploadComponent);
           
    }
 
    handleCancelpop(){
        const closeAction= new CloseActionScreenEvent();
        this.dispatchEvent(closeAction);
 
    }
 
   
}